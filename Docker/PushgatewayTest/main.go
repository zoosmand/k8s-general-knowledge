package main

import (
    "fmt"
    "os"

    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/push"
)

func gauge(url string) {
    completionTime := prometheus.NewGauge(prometheus.GaugeOpts{
        Name: "test_gauge_metric_for_k8s_deployment",
        Help: "The timestamp of the last successful completion of a test.",
    })
    completionTime.SetToCurrentTime()
    if err := push.New(url, "test_gauge_metric").
        Collector(completionTime).
        Grouping("testing", "a gauge").
        Push(); err != nil {
        fmt.Println("Could not push completion time to Pushgateway:", err)
    }
}

func main() {
    if len(os.Args) <= 1 {
        fmt.Println("Wrong URL!")
    } else {
        gauge(os.Args[1])
    }
}

