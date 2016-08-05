
package com.consumer;

import kafka.consumer.ConsumerIterator;
import kafka.consumer.KafkaStream;
 
public class ConsumerTest implements Runnable {
    private KafkaStream<byte[], byte[]> m_stream;
    private int m_threadNumber;
 
    public ConsumerTest(KafkaStream<byte[], byte[]> a_stream, int a_threadNumber) {
        m_threadNumber = a_threadNumber;
        m_stream = a_stream;
    }
 
    public void run() {
        ConsumerIterator<byte[], byte[]> it = m_stream.iterator();
        System.out.println("start running Thread: " + m_threadNumber);
        long startTime = System.currentTimeMillis();
        while (it.hasNext()){
            System.out.println("Thread " + m_threadNumber + ": " + new String(it.next().message()));
            //System.out.println("runnnning : " + m_threadNumber);
        }
        long stopTime = System.currentTimeMillis();
        long elapsedTime = stopTime - startTime;
        System.out.println("Shutting down Thread, time " + elapsedTime);
    }
}
