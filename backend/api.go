package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

type server struct {
	Place   string   `json:"place"`
	Country string   `json:"country"`
	Facts   []string `json:"facts"`
	Links   []string `json:"links"`
}

type serverData []server

func handler1(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	resp := serverData{
		{
			"Langkawi",
			"Malaysia",
			[]string{
				"Langkawi is full of pristine landscapes presented by the amazing mountains covered with mangrove forests, mysterious caves.",
				"Langkawi is a real paradise for divers or just for those who love to explore different sea creatures.",
				"Langkawi is a homeland of the world’s best beaches. There’s a great number of beaches on Langkawi suitable to any tastes.",
			},
			[]string{
				"http://www.orangesmile.com/common/img_cities_original/langkawi-3288-0.jpg",
				"http://www.orangesmile.com/common/img_cities_original/langkawi-3288-3.jpg",
				"http://www.orangesmile.com/common/img_cities_original/langkawi-3288-6.jpg",
			},
		},
	}
	json.NewEncoder(w).Encode(resp)
}

func handler2(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	resp := serverData{
		{
			"Lakshadweep",
			"India",
			[]string{
				"Lakshadweep actually means a collection of lakh islands (laksha means lakh whereas dweep means island). It covers 32 sq. Kilometer of land. Consequently, it is the smallest Union Territory of India.",
				"Lakshadweep has 36 islands, of which 10 are inhabited. Take some walks on these picturesque islands, mingle with the locals, peer at corals emerging from their underwater abode at low tide, and frolic in the warm waters of the Arabian Sea.",
				"Lakshadweep is the perfect place to luxuriate in pure seclusion. At dusk, watch the sun’s dying rays paint the lagoon into unforgettable and dramatic vistas as you stroll along the jetty at Kadmat Island, the only footprints in the sand being your own.",
			},
			[]string{
				"https://www.holidify.com/images/bgImages/LAKSHADWEEP-ISLANDS.jpg",
				"https://www.holidify.com/images/cmsuploads/compressed/yachtt_20180716173237_20190708121432.jpg",
				"http://tourism.gov.in/sites/default/files/gallery/Picture1_1.jpg",
			},
		},
	}
	json.NewEncoder(w).Encode(resp)
}

// GetPort from the environment
func GetPort() string {
	var port = os.Getenv("PORT")
	// Set a default port if there is nothing in the environment
	if port == "" {
		port = "8081"
		fmt.Println("\nINFO: No PORT environment variable detected, defaulting to " + port)
		fmt.Print("\nYour api is up and running! \n")
	}
	return ":" + port
}

func main() {
	http.HandleFunc("/langkawi", handler1)
	http.HandleFunc("/lakshadweep", handler2)
	fmt.Println("\nListening to web server...")
	err := http.ListenAndServe(GetPort(), nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
