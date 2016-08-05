
# remember to turn off the swap for a stable performance 
loopLen=5

s=1000
#for ((k=1; k<i; k++)) do ((s=s*10)); done
recordSize=$s
#4,000,000,000
numRecord=$((16000000000/$s))
#numRecord=$((16000000000/$s))

echo processing $recordSize $numRecord

free -m
sync; echo 3 | sudo tee /proc/sys/vm/drop_caches
free -m

sh ./clean.sh
rm -f ./logs/*.log
../bin/zookeeper-server-start.sh ../config/zookeeper.properties > ./logs/zk.log 2>&1 &
zkId=$!
echo "... has started zookeeper!!! on $zkId"
../bin/kafka-server-start.sh ../config/server.properties > ./logs/server.log 2>&1 &
serverId=$!
echo "... has started server!!! on $serverId"
../bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ttt > ./logs/topic.log 2>&1
echo "... finish creating the topic ttt, starting the producer"

START=$(date +%s);
#rm -f ./logs/producer.log
echo "start producer at " 
echo "$START" | awk '{print int($1/60)" min : "int($1%60) " sec"}'
ssh d0101b02 "sh /homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --latency 0 --topic ttt --num-records $numRecord --record-size $recordSize --throughput -1 --producer-props acks=1 bootstrap.servers=10.6.37.24:9092 buffer.memory=67108864 batch.size=32768 >& /homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/benchmark/logs/producer.log" & 
#../bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --latency 0 --topic ttt --num-records $numRecord --record-size $recordSize --throughput -1 --producer-props acks=1 bootstrap.servers=localhost:9092 buffer.memory=67108864 batch.size=32768 > ./logs/producer.log 2>&1 & 

sleep 180 
echo "start consumer at "
echo "$(date +%s)" | awk '{print int($1/60)" min : "int($1%60) " sec"}'
echo "starting consumer, should receive $numRecord..."
ssh d0101b03 "sh /homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/bin/kafka-consumer-perf-test.sh --new-consumer true --zookeeper 10.6.37.24:2181 --broker-list 10.6.37.24:9092 --messages $numRecord --topic ttt --threads 1 --group 1 >& /homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/benchmark/logs/consumer1.log 2>&1" 

#another consumer
#ssh d0101b04 "sh /homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/bin/kafka-consumer-perf-test.sh --new-consumer true --zookeeper 10.6.37.24:2181 --broker-list 10.6.37.24:9092 --messages $numRecord --topic ttt --threads 1 --group 2 >& /homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/benchmark/logs/consumer2.log 2>&1"

#../bin/kafka-consumer-perf-test.sh --new-consumer true --zookeeper localhost:2181 --broker-list localhost:9092 --messages $(($numRecord)) --topic ttt --threads 1 > ./logs/consumer.log 2>&1

END=$(date +%s);
echo $((END-START)) | awk '{print int($1/60)" min : "int($1%60) " sec"}'

sleep 5 
kill -9 $zkId
kill -9 $serverId 
echo "finish killing process!!!!"
sleep 2 


#python ./calLatency.py 2>&1 | tee ./logs/latency.log

