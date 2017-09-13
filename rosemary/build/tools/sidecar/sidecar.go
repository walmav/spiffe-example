package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
	"time"

	workload "github.com/spiffe/spiffe-example/rosemary/build/tools/sidecar/wlapi"      //github.com/spiffe/sri/pkg/api/workload"
	common "github.com/spiffe/spiffe-example/rosemary/build/tools/sidecar/wlapi/common" //github.com/spiffe/sri/pkg/common"
)

const (
	fetchAllBundlesSuffix = "/fetchAllBundles"
	configFile            = "sidecar_config.hcl"
)

var (
	config     *SidecarConfig
	ghostunnel *exec.Cmd
)

func main() {
	// 0. Load configuration (other endpoint address)
	// 1. Request certs using Workload API
	// 2. Put cert on disk
	// 3. Start ghostunnel if not running, otherwise send SIGUSR1 to reload cert
	// 4. Wait until TTL expires
	// 5. Goto 1

	config, err := ParseConfig(configFile)
	if err != nil {
		panic(err)
	}
	log("Sidecar is up! Will use agent at %s\n\n", config.AgentURL)

	err = daemon()
	if err != nil {
		panic(err)
	}
}

func daemon() error {
	// Create channel for interrupt signal
	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, syscall.SIGINT, syscall.SIGTERM)

	// Main loop
	for {
		// Fetch and dump certificates
		pk, crt, ttl, err := dumpBundles()
		if err != nil {
			return err
		}
		err = signalGhostunnel(pk, crt)
		if err != nil {
			return err
		}

		// Create timer for TTL/2
		timer := time.NewTimer(time.Second * time.Duration(ttl/2))

		// Wait for either timer or interrupt signal
		log("Will wait for TTL/2 (%d seconds)\n", ttl/2)
		select {
		case <-timer.C:
			log("Time is up! Will renew cert.\n")
			// Continue
		case <-interrupt:
			log("Interrupted! Will exit.\n")
			return nil
		}
	}
}

func signalGhostunnel(pk, crt string) (err error) {
	if ghostunnel == nil || ghostunnel.ProcessState.Exited() {
		// Start Ghostunnel
		args := fmt.Sprintf("%s --keystore %s --cacert %s", config.GhostunnelArgs, pk, crt)
		ghostunnel := exec.Command(config.GhostunnelCmd, args)
		ghostunnel.Stdout = os.Stdout
		ghostunnel.Stderr = os.Stderr
		err = ghostunnel.Start()
		if err != nil {
			return
		}
	} else {
		// Signal Ghostunnel to reload certs
		err = ghostunnel.Process.Signal(syscall.SIGUSR1)
		if err != nil {
			return
		}
	}

	return
}

func dumpBundles() (pk, crt string, ttl int32, err error) {
	bundles, err := fetchBundles()
	if err != nil {
		return
	}

	if len(bundles.Bundles) == 0 {
		err = errors.New("Fetched zero bundles")
		return
	}

	ttl = bundles.Ttl

	log("Writing %d bundles!\n", len(bundles.Bundles))
	for index, bundle := range bundles.Bundles {
		pkFilename := fmt.Sprintf("%s/%d.key", config.CertDir, index)
		certFilename := fmt.Sprintf("%s/%d.cert", config.CertDir, index)
		if index == 0 {
			pk = pkFilename
			crt = certFilename
		}

		log("Writing keystore #%d...\n", index+1)
		keystore := append(bundle.SvidPrivateKey, bundle.Svid...)
		err = ioutil.WriteFile(pkFilename, keystore, os.ModePerm)
		if err != nil {
			return
		}

		log("Writing CA certs #%d...\n", index+1)
		err = ioutil.WriteFile(certFilename, bundle.SvidBundle, os.ModePerm)
		if err != nil {
			return
		}
	}
	return
}

func fetchBundles() (bundles *workload.Bundles, err error) {
	reqStr, err := json.Marshal(&common.Empty{})
	if err != nil {
		return
	}
	log("Invoking FetchAllBundles\n")

	req, err := http.NewRequest("GET", config.AgentURL+fetchAllBundlesSuffix, bytes.NewBuffer(reqStr))
	if err != nil {
		return
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return
	}
	defer resp.Body.Close()

	respStr, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return
	}
	log("FetchAllBundles returned\n")

	err = json.Unmarshal([]byte(respStr), &bundles)
	if err != nil {
		return
	}

	return
}

func log(format string, a ...interface{}) {
	fmt.Print(time.Now().Format(time.Stamp), ": ")
	fmt.Printf(format, a...)
}
