
import os.path

fname1="./logs/producer.log"
fname2="../logs/server.log"
if (not os.path.isfile(fname1)):
  print " file does not exist "
if (not os.path.isfile(fname2)):
  print " file does not exist "

myfile1=open(fname1, "r")
myfile2=open(fname2, "r")
lines1=myfile1.readlines()
lines2=myfile2.readlines()

count = 0
acc=0
for line in lines1:
  words=line.split()
  if len(words)>5 and words[5] == "client": 
    count += 1
    #print line 
  if len(words)>10 and words[10] == "accumulator": 
    acc += 1
    
print " producer log has send count: ", count, " send to accumulator ", acc

count = 0
for line in lines2:
  words=line.split()
  if len(words)>5 and words[5] == "handle": 
    count += 1
    #print line 
 
print " server log has count: ", count
