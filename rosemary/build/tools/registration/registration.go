package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"reflect"

	"github.com/spiffe/spire/pkg/api/registration"
	"github.com/spiffe/spire/pkg/common"
)

const (
	entryURL = "http://spire:8080/entry"
	dataFile = "registration.json"
)

func main() {
	// Load entries from data file
	entries := &common.RegistrationEntries{}
	dat, err := ioutil.ReadFile(dataFile)
	if err != nil {
		panic(err)
	}

	json.Unmarshal(dat, &entries)

	// Inject each entry and verify it
	for index, registeredEntry := range entries.Entries {
		fmt.Printf("Creating entry #%d...\n", index+1)
		entityID, err := createEntry(registeredEntry)
		if err != nil {
			panic(err)
		}
		valid, err := validateEntry(entityID, registeredEntry)
		if err != nil {
			panic(err)
		}
		if valid {
			fmt.Printf("Fetched entity %s is OK!\n\n", entityID)
		} else {
			fmt.Printf("Fetched entity %s mismatch! Aborting...\n", entityID)
			return
		}
	}

	fmt.Printf("All OK!\n")
}

func createEntry(registeredEntry *common.RegistrationEntry) (entityID string, err error) {
	reqStr, err := json.Marshal(registeredEntry)
	if err != nil {
		return
	}
	fmt.Printf("Invoking CreateEntry: %s\n", string(reqStr))

	req, err := http.NewRequest("POST", entryURL, bytes.NewBuffer(reqStr))
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
	fmt.Printf("CreateEntry returned: %s\n", string(respStr))

	registeredEntryID := &registration.RegistrationEntryID{}
	err = json.Unmarshal([]byte(respStr), &registeredEntryID)
	if err != nil {
		return
	}
	entityID = registeredEntryID.Id

	return
}

func validateEntry(entityID string, registeredEntry *common.RegistrationEntry) (ok bool, err error) {
	fmt.Printf("Invoking FetchEntry: %s\n", entityID)

	req, err := http.NewRequest("GET", entryURL+"/"+entityID, bytes.NewBufferString(""))
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
	fmt.Printf("FetchEntry returned: %s\n", string(respStr))

	var fetchedRegisteredEntry *common.RegistrationEntry
	err = json.Unmarshal([]byte(respStr), &fetchedRegisteredEntry)
	if err != nil {
		return
	}

	ok = reflect.DeepEqual(fetchedRegisteredEntry, registeredEntry)

	return
}
