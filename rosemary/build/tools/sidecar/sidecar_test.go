package main

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"testing"
	"time"

	workload "github.com/spiffe/spiffe-example/rosemary/build/tools/sidecar/wlapi"
)

const (
	testPort        = 22222
	testTimeSeconds = 20
	testTTL         = 10
)

// TestSidecar_Integration will run the sidecar with an 'echo' command simulating ghostunnel
// and a simple webserver to mock the Workload API to the sidecar.
// The objetive is to make sure sidecar is requesting certs and invoking command successfully.
// TODO: 'echo' command exits immediately so we cannot test SIGUSR1 signalling. Improve this.
func TestSidecar_Integration(t *testing.T) {
	tmpdir, err := ioutil.TempDir("", "test-certs")
	if err != nil {
		panic(err)
	}
	defer os.RemoveAll(tmpdir)

	config = &SidecarConfig{
		AgentURL:      fmt.Sprintf("http://localhost:%d", testPort),
		CertDir:       tmpdir,
		GhostunnelCmd: "echo",
	}

	startWebServer(testPort)

	fmt.Printf("Will test for %d seconds.\n", testTimeSeconds)
	go sendInterrupt(testTimeSeconds)

	err = daemon()
	if err != nil {
		panic(err)
	}
}

func sendInterrupt(seconds int) {
	time.Sleep(time.Second * time.Duration(seconds))
	fmt.Printf("Tested for %d seconds. Will interrupt!\n", testTimeSeconds)
	p, err := os.FindProcess(os.Getpid())
	if err != nil {
		panic(err)
	}
	err = p.Signal(os.Interrupt)
	if err != nil {
		panic(err)
	}
}

func serveBundles(w http.ResponseWriter, r *http.Request) {
	bundlesToServe := &workload.Bundles{
		Ttl: testTTL,
		Bundles: []*workload.WorkloadEntry{
			&workload.WorkloadEntry{
				SpiffeId:         "localhost/id",
				Svid:             readFile("keys/svid.pem"),
				SvidPrivateKey:   readFile("keys/svid_pk.pem"),
				SvidBundle:       readFile("keys/bundle.pem"),
				FederatedBundles: nil,
			},
		},
	}

	w.Header().Set("Content-Type", "application/json")
	result, _ := json.Marshal(bundlesToServe)
	io.WriteString(w, string(result))
}

func readFile(file string) (bytes []byte) {
	bytes, err := ioutil.ReadFile(file)
	if err != nil {
		panic(err)
	}
	return
}

func startWebServer(port int32) {
	http.HandleFunc(fetchAllBundlesSuffix, serveBundles)
	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		panic(err)
	}
	go http.Serve(listener, nil)
}
