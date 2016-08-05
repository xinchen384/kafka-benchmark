
loopLen=5

for ((i=1; i<=$loopLen; i++))
do 
s=10
for ((k=1; k<i; k++)) do ((s=s*10)); done
recordSize=$s
numRecord=$((5000000000/$s))
echo processing $recordSize $numRecord
../bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic ttt --num-records $numRecord --record-size $recordSize --throughput -1 --producer-props acks=1 bootstrap.servers=localhost:9092 buffer.memory=67108864 batch.size=8196 > $i.log 
done

