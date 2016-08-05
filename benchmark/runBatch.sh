
loopLen=5

for ((i=1; i<=$loopLen; i++))
do 
s=1
for ((k=1; k<i; k++)) do ((s=s*2)); done
batchSize=$((s*8*1024)) 
echo processing batchSize: $batchSize

sh ./clean.sh
../bin/zookeeper-server-start.sh ../config/zookeeper.properties > ./logs/zk.log 2>&1 &
zkId=$!
echo "... has started zookeeper!!! on $zkId"
../bin/kafka-server-start.sh ../config/server.properties > ./logs/server.log 2>&1 &
serverId=$!
echo "... has started server!!! on $serverId"
../bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ttt > ./logs/topic.log 2>&1
echo "... finish creating the topic ttt, ready to start the producer"

../bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic ttt --num-records 50000000 --record-size 100 --throughput -1 --latency 0 --producer-props acks=1 bootstrap.servers=localhost:9092 buffer.memory=67108864 batch.size=$batchSize > ./logs/producer-$i.log 2>&1

sleep 3
kill -9 $zkId
kill -9 $serverId
echo "finish killing process!!!!"
sleep 3

done

