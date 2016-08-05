
loopLen=5

for ((i=1; i<=$loopLen; i++))
do
s=10
for ((k=1; k<i; k++)) do ((s=s*10)); done

recordSize=$s
numRecord=$((5000000000/$s))
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

../bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --latency 0 --topic ttt --num-records $numRecord --record-size $recordSize --throughput -1 --producer-props acks=0 bootstrap.servers=localhost:9092 buffer.memory=67108864 batch.size=32768 > ./logs/producer-$i.log 2>&1 



sleep 3
kill -9 $zkId
kill -9 $serverId 
echo "finish killing process!!!!"
sleep 3

done
