package main

import (
	"fmt"
	"log"

	"github.com/IBM/sarama"
)

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

	// Send a test message to Kafka topic
	topic := "test-topic"
	message := &sarama.ProducerMessage{
		Topic: topic,
		Value: sarama.StringEncoder("Hello, Kafka!"),
	}

	partition, offset, err := producer.SendMessage(message)
	if err != nil {
		log.Fatalf("Failed to send message to Kafka: %v", err)
	}

	fmt.Printf("Message sent to topic %s, partition %d, offset %d\n", topic, partition, offset)
}