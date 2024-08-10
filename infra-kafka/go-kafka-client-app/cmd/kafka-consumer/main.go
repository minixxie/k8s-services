package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"

	"github.com/IBM/sarama"
)

func main() {
	log.Println("Starting Kafka consumer...")

	// Set up configuration for Kafka consumer
	config := sarama.NewConfig()
	config.Consumer.Return.Errors = true

	// Specify the Kafka brokers to connect to
	brokers := []string{"kafka.infra-kafka.svc.cluster.local:9092"}

	// Create a new consumer
	consumer, err := sarama.NewConsumer(brokers, config)
	if err != nil {
		log.Fatalf("Failed to create consumer: %v", err)
	}
	defer func() {
		if err := consumer.Close(); err != nil {
			log.Fatalf("Error closing consumer: %v", err)
		}
	}()

	// Specify the Kafka topic to consume from
	topic := "test-topic"

	// Create a new partition consumer for the specified topic and partition
	partitionConsumer, err := consumer.ConsumePartition(topic, 0, sarama.OffsetNewest)
	if err != nil {
		log.Fatalf("Failed to create partition consumer: %v", err)
	}
	defer func() {
		if err := partitionConsumer.Close(); err != nil {
			log.Fatalf("Error closing partition consumer: %v", err)
		}
	}()

	// Set up a signal handler to gracefully shut down the consumer
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, os.Interrupt)

	// Start consuming messages from Kafka
	for {
		select {
		case msg := <-partitionConsumer.Messages():
			// Handle the received message
			fmt.Printf("Received message: %s\n", string(msg.Value))
		case err := <-partitionConsumer.Errors():
			log.Printf("Error consuming message: %v", err)
		case <-signals:
			// Shut down the consumer gracefully
			log.Println("Shutting down consumer...")
			return
		}
	}
}