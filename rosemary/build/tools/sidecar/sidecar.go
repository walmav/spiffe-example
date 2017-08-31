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
	ghostunnel *os.Process
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
	fmt.Printf("Sidecar is up! Will use agent at %s\n\n", config.AgentURL)

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
		fmt.Printf("Will wait for TTL/2 (%d seconds)\n", ttl/2)
		select {
		case <-timer.C:
			fmt.Println("Time is up! Will renew cert.")
			// Continue
		case <-interrupt:
			fmt.Println("Interrupted! Will exit.")
			return nil
		}
	}
}

func signalGhostunnel(pk, crt string) (err error) {
	if ghostunnel == nil {
		// Start Ghostunnel
		cmdstr := fmt.Sprintf("%s --keystore %s --cacert %s", config.GhostunnelCmd, pk, crt)
		cmd := exec.Command(cmdstr)
		err = cmd.Start()
		if err != nil {
			return
		}
		ghostunnel = cmd.Process
	} else {
		// Signal Ghostunnel to reload certs
		err = ghostunnel.Signal(syscall.SIGUSR1)
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

	if len(bundles.WorkloadEntry) == 0 {
		err = errors.New("Fetched zero bundles")
		return
	}

	ttl = bundles.Ttl

	fmt.Printf("Writing %d bundles!\n", len(bundles.WorkloadEntry))
	for index, workloadEntry := range bundles.WorkloadEntry {
		pkFilename := fmt.Sprintf("%s/%d.key", config.CertDir, index)
		certFilename := fmt.Sprintf("%s/%d.cert", config.CertDir, index)
		if index == 0 {
			pk = pkFilename
			crt = certFilename
		}

		fmt.Printf("Writing keystore #%d...\n", index+1)
		keystore := append(workloadEntry.SvidPrivateKey, workloadEntry.Svid...)
		err = ioutil.WriteFile(pkFilename, keystore, os.ModePerm)
		if err != nil {
			return
		}

		fmt.Printf("Writing CA certs #%d...\n", index+1)
		err = ioutil.WriteFile(certFilename, workloadEntry.ControlPlaneBundle, os.ModePerm)
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
	fmt.Printf("Invoking FetchAllBundles: %s\n\n", string(reqStr))

	req, err := http.NewRequest("POST", config.AgentURL+fetchAllBundlesSuffix, bytes.NewBuffer(reqStr))
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
	fmt.Printf("FetchAllBundles returned: %s\n\n", string(respStr))

	err = json.Unmarshal([]byte(respStr), &bundles)
	if err != nil {
		return
	}

	return
}
