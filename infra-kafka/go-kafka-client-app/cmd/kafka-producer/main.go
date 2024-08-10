package main

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/IBM/sarama"
)

type Message struct {
	Greeting string `json:"greeting"`
}

func main() {
	// Set up Kafka producer configuration
	config := sarama.NewConfig()
	config.Producer.Return.Successes = true

	// Create Kafka producer
	producer, err := sarama.NewSyncProducer([]string{"kafka.infra-kafka.svc.cluster.local:9092"}, config)
	if err != nil {
		log.Fatalf("Failed to create Kafka producer: %v", err)
	}
	defer producer.Close()

	// Create a message struct and marshal it to JSON
	msg := Message{Greeting: "Hello, Kafka!"}
	jsonValue, err := json.Marshal(msg)
	if err != nil {
		log.Fatalf("Failed to marshal message to JSON: %v", err)
	}

	// Send a test message to Kafka topic
	topic := "test-topic"
	message := &sarama.ProducerMessage{
		Topic: topic,
		Key:   sarama.StringEncoder("Greetings"),
		Value: sarama.StringEncoder(jsonValue),
	}

	partition, offset, err := producer.SendMessage(message)
	if err != nil {
		log.Fatalf("Failed to send message to Kafka: %v", err)
	}

	fmt.Printf("Message sent to topic %s, partition %d, offset %d\n", topic, partition, offset)
}