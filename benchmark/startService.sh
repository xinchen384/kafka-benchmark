
loopLen=5

s=1000
#for ((k=1; k<i; k++)) do ((s=s*10)); done
recordSize=$s
numRecord=$((5000000000/$s))
#numRecord=$((50000/$s))
echo processing $recordSize $numRecord

sh ./clean.sh
../bin/zookeeper-server-start.sh ../config/zookeeper.properties > ./logs/zk.log 2>&1 &
zkId=$!
echo "... has started zookeeper!!! on $zkId"
../bin/kafka-server-start.sh ../config/server.properties > ./logs/server.log 2>&1 &
serverId=$!
echo "... has started server!!! on $serverId"
../bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ttt > ./logs/topic.log 2>&1
echo "... finish creating the topic ttt, ready to start the producer"
echo " type c to start ... "

ch='a'
while [ $ch != 'c' ]
do
sleep 1
read ch
done
echo " starting ... "

../bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --latency 1 --topic ttt --num-records $numRecord --record-size $recordSize --throughput -1 --producer-props acks=1 bootstrap.servers=localhost:9092 buffer.memory=67108864 batch.size=32768 > ./logs/producer.log 2>&1 

echo "... finish producer, type c to turn off the service "
ch='a'
while [ $ch != 'c' ]
do
sleep 1
read ch
done
echo " doing ... "
#../bin/kafka-consumer-perf-test.sh --latency 5000000 --new-consumer true --zookeeper localhost:2181 --broker-list localhost:9092 --messages $(($numRecord+1)) --topic ttt --threads 1 > ./logs/consumer.log 2>&1
#../bin/kafka-consumer-perf-test.sh --latency 5000000 --new-consumer true --zookeeper 10.6.36.157:2181 --broker-list 10.6.36.157:9092 --messages 5000000 --topic ttt --threads 1 > ./logs/consumer.log 2>&1

sleep 3
kill -9 $zkId
kill -9 $serverId 
echo "finish killing process!!!!"
sleep 3

