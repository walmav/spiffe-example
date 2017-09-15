package main

import (
	"context"

	workload "github.com/spiffe/spiffe-example/rosemary/build/tools/sidecar/wlapi"
	"google.golang.org/grpc"
)

const (
	configFile = "sidecar_config.hcl"
)

func main() {
	// 0. Load configuration
	// 1. Request certs using Workload API
	// 2. Put cert on disk
	// 3. Start ghostunnel if not running, otherwise send SIGUSR1 to reload cert
	// 4. Wait until TTL expires
	// 5. Goto 1

	config, err := ParseConfig(configFile)
	if err != nil {
		panic(err)
	}
	log("Sidecar is up! Will use agent at %s\n\n", config.AgentAddress)

	workloadClient, err := createGrpcClient(config)
	if err != nil {
		panic(err)
	}

	sidecar := NewSidecar(config, workloadClient)

	err = sidecar.RunDaemon()
	if err != nil {
		panic(err)
	}
}

func createGrpcClient(config *SidecarConfig) (workloadClient workload.WorkloadClient, err error) {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	opt := grpc.WithInsecure()
	opts := []grpc.DialOption{opt}

	conn, err := grpc.Dial(config.AgentAddress, opts...)

	workloadClient = workload.NewWorkloadClient(conn)

	return
}
