package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

type SystemMetrics struct {
	Timestamp    int64   `json:"timestamp"`
	Load1        float64 `json:"load1"`
	Load5        float64 `json:"load5"`
	Uptime       float64 `json:"uptime"`
	MemTotalKb   float64 `json:"mem_total_kb"`
	MemAvailable int64   `json:"mem_used_kb"`
	Measurement  string  `json:"measurement"`
	Tag          string  `json:"tag"`
}

func readProcFile(path string) (string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", fmt.Errorf("failed to read file: %s, %w", path, err)
	}
	return string(data), nil
}

func main() {
	metrics := SystemMetrics{
		Timestamp: time.Now().Unix(),
	}

	loadavg, err := readProcFile("/proc/loadavg")
	if err != nil {
		log.Println(err)
		return
	}

	if loadParts := strings.Fields(loadavg); len(loadParts) >= 2 {
		metrics.Load1, _ = strconv.ParseFloat(loadParts[0], 64)
		metrics.Load5, _ = strconv.ParseFloat(loadParts[1], 64)
	}

	uptime, err := readProcFile("/proc/uptime")
	if err != nil {
		log.Println(err)
		return
	}
	if uptimeParts := strings.Fields(uptime); len(uptimeParts) >= 1 {
		metrics.Uptime, _ = strconv.ParseFloat(uptimeParts[0], 64)
	}

	meminfo, err := readProcFile("/proc/meminfo")
	if err != nil {
		log.Println(err)
		return
	}
	for _, line := range strings.Split(meminfo, "\n") {
		if strings.HasPrefix(line, "MemTotal:") {
			valueStr := strings.Fields(line)[1]
			metrics.MemTotalKb, _ = strconv.ParseFloat(valueStr, 64)
		}
		if strings.HasPrefix(line, "MemAvailable:") {
			valueStr := strings.Fields(line)[1]
			metrics.MemAvailable, _ = strconv.ParseInt(valueStr, 10, 64)

		}
	}

	metrics.Measurement = "go_awesome_monitor"
	metrics.Tag = "host=wsl"

	metrics.Timestamp = time.Now().UnixNano()

	jsonData, err := json.Marshal(metrics)
	if err != nil {
		log.Fatal("failed to marshal metrics: ", err)
	}

	lineProtocol := fmt.Sprintf("%s,%s load1=%.2f,load5=%.2f,uptime=%.2f,mem_total_kb=%.2f,mem_available_kb=%d %d",
		metrics.Measurement,
		metrics.Tag,
		metrics.Load1,
		metrics.Load5,
		metrics.Uptime,
		metrics.MemTotalKb,
		metrics.MemAvailable,
		metrics.Timestamp,
	)

	url := "http://localhost:8086/write?db=telegraf"
	resp, err := http.Post(url, "text/plain", strings.NewReader(lineProtocol))
	if err != nil {
		log.Fatal("failed post to InfluxDb: ", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusNoContent {
		log.Fatal("InfluxDb send error:", resp.StatusCode)
	}

	fmt.Println("Metrics sent to InfluxDB, successfully")

	dateStr := time.Now().Format("06-01-02")
	logFileName := fmt.Sprintf("/var/log/%s-awesome-monitoring.log", dateStr)

	file, err := os.OpenFile(logFileName, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		log.Fatal("failed to open log file (sudo?): ", err)
	}
	defer file.Close()
	if _, err := file.Write(append(jsonData, '\n')); err != nil {
		log.Fatal("failed to write to log file: ", err)
	}
}
