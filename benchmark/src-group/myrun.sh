

CLASSPATH=".:/homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/core/build/libs/kafka_2.10-0.10.0.0.jar:/homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/core/build/dependant-libs-2.10.6/*"
CLASSPATH="$CLASSPATH:/homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/tools/build/libs/kafka-tools-0.10.0.0.jar:/homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/tools/build/dependant-libs-2.10.6/*"
CLASSPATH="$CLASSPATH:/homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/clients/build/libs/kafka-clients-0.10.0.0.jar"

javac -cp $CLASSPATH ./com/consumer/*.java -Xlint:unchecked

jar -cvfm ConsumerGroupExample.jar manifest.txt com/consumer/*.class

echo " start running ... "

java -cp $CLASSPATH com.consumer.ConsumerGroup localhost:2181 random-group ttt 1  

