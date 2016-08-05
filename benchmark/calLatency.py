
import os.path


fname1="/homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/benchmark/latency-log/latencyP.log"
fname2="/homes/hny9/chenxin/kafka/kafka-0.10.0.0-src/benchmark/latency-log/latencyC.log"
if (not os.path.isfile(fname1)):
  print " file does not exist "
if (not os.path.isfile(fname2)):
  print " file does not exist "

myfile1=open(fname1, "r")
myfile2=open(fname2, "r")
lines1=myfile1.readlines()
lines2=myfile2.readlines()

mylen = -1
if (len(lines1) != len(lines2) ):
  print " the size of the two lists of timestamp is not the same "

if (len(lines1) <= len(lines2) ):
  mylen = len(lines1)
else:
  mylen = len(lines2)

min_latency = 1000000 
sum_latency = 0
max_latency = 0
for i in range(mylen):
  ts1 = int(lines1[i])
  ts2 = int(lines2[i])
  lat = ts2-ts1
  if (lat < min_latency): min_latency = lat 
  if (lat > max_latency): max_latency = lat 
  sum_latency += lat 
 
print "average lantecy is: {0}, min: {1}, max: {2}".format( sum_latency*1.0/mylen, min_latency, max_latency )
