package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

const (
	LISTEN_PORT = "18080"
)

func main() {
	func() {
		// Expect the root of the web-server to be used
		http.HandleFunc("/", webServerHandler)
		log.Println("Starting server at port " + LISTEN_PORT)

		// Run HTTP server to listen a port saved in LISTEN_PORT
		if err := http.ListenAndServe(":"+LISTEN_PORT, nil); err != nil {
			// logger.InitLogger(logServer, "tcp", syslog.LOG_ERR)
			log.Println(err.Error())
			// Get out is case of error
			os.Exit(-1)
		}
	}()
}

// Serves HTTP requests and responses on them
//
// ---
//
// @w: (http.ResponseWriter) HTTP response writer object
//
// @r: (ptr http.Request) HTTP request object
func webServerHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "OPTIONS":
		doOptions(&w, r)

	case "HEAD":
		doHead(&w, r)

	case "GET":
		doGet(&w, r)

	case "PUT":
		doPut(&w, r)

	case "POST":
		doPost(&w, r)

	default:
		doOthers(&w, r)
	}
}

func doOptions(w *http.ResponseWriter, r *http.Request) {
	WriteStandardHeaders(*w)
	(*w).Header().Set("Hook-Result", "OK")
	(*w).Header().Set("Allow", "GET,HEAD,PUT,POST,OPTIONS")
}

func doHead(w *http.ResponseWriter, r *http.Request) {
	WriteStandardHeaders(*w)
	(*w).Header().Set("Hook-Result", "OK")
}

func doGet(w *http.ResponseWriter, r *http.Request) {
	message := "The URL path is missing"
	switch r.RequestURI {
	case "/healthy":
		message = "The services is healthy"

	case "/ready":
		message = "The services is ready"

	case "/":
	default:
		log.Println(message)
		httpErrorResponseHandler(*w, message, http.StatusNotFound)
		return
	}

	httpResponseHandler(*w, []byte(message))
}

func doPut(w *http.ResponseWriter, r *http.Request) {
	reqBody, err := io.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("%s", reqBody)
	httpResponseHandler(*w, reqBody)
}

func doPost(w *http.ResponseWriter, r *http.Request) {
	reqBody, err := io.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("%s", reqBody)
	httpResponseHandler(*w, reqBody)
}

func doOthers(w *http.ResponseWriter, r *http.Request) {
	fmt.Println(r)
	httpErrorResponseHandler(*w, r.Method+" is not supported here", http.StatusMethodNotAllowed)
}

// // Handles HTTP error response
// //
// ---
//
// @w: (ptr http.ResponseWriter) HTTP response writer object
//
// @reason: (string) Text reason messge
//
// @status: (int) HTTP header status
func httpErrorResponseHandler(w http.ResponseWriter, reason string, status int) {
	WriteStandardHeaders(w)
	w.Header().Set("Hooker-Result", "ERROR")
	w.Header().Set("Hooker-Error-Text", reason)
	w.WriteHeader(status)
	w.Write([]byte("Error occured: " + reason))
	log.Println(reason)
}

// // Handles HTTP response
// //
// ---
//
// @w: (ptr http.ResponseWriter) HTTP response writer object
//
// @email: (ptr string) email of a subscriber
//
// @message: (ptr string) message to be sent to a subscriber
func httpResponseHandler(w http.ResponseWriter, message []byte) {
	WriteStandardHeaders(w)
	w.Header().Set("Hooker-Result", "OK")
	w.Write(message)
}

// WriteStandardHeaders writes standard headers to a response
// @w: a response writer
func WriteStandardHeaders(w http.ResponseWriter) {
	w.Header().Set("Server", "Hooker-Handler")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Credentials", "true")
	w.Header().Set("Connection", "Keep-Alive")
	w.Header().Set("Keep-Alive", "timeout=5, max=100")
}
