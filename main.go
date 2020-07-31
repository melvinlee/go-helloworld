package main

import (
	"fmt"
	"log"
	"net/http"
)

const (
	port = ":80"
)

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, _ *http.Request) {
		fmt.Fprint(w, "Hello universe!, How are you today?\n")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(200)
	})

	log.Println("Starting application on port", port, "...")

	log.Fatal(http.ListenAndServe(port, nil))
}
