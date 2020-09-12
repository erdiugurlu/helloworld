package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

//home page
func homeLink(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World from @ErdiUgurlu!")
}

//HealthCheckHandler is for readiness and liveness probes
func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "The service is healthy...")
}

func main() {
	// create a new router
	router := mux.NewRouter().StrictSlash(true)
	log.Print("the service is working...")
	router.HandleFunc("/", homeLink)
	router.HandleFunc("/health", HealthCheckHandler)

	// listen and serve
	log.Fatal(http.ListenAndServe(":11130", router))
}
