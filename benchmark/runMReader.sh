


numRecord=5000000

../bin/kafka-consumer-perf-test.sh --new-consumer true --zookeeper localhost:2181 --broker-list localhost:9092 --messages $(($numRecord)) --topic ttt --threads 1 --group 1 >& ./logs/consumer1.log &
../bin/kafka-consumer-perf-test.sh --new-consumer true --zookeeper localhost:2181 --broker-list localhost:9092 --messages $(($numRecord)) --topic ttt --threads 1 --group 2 >& ./logs/consumer2.log 
