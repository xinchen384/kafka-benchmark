

ps -u chenxin | grep java | awk '{print $1}' | xargs kill -9

echo "on d0101b02 nodes: java processes: "
ssh d0101b02 "ps -u chenxin | grep java | awk '{print \$1}'"
#ssh d0101b02 "cat /proc/meminfo"
ssh d0101b02 "ps -u chenxin | grep java | awk '{print \$1}' | xargs kill"

echo "on d0101b03 nodes: java processes: "
ssh d0101b03 "ps -u chenxin | grep java | awk '{print \$1}'"
ssh d0101b03 "ps -u chenxin | grep java | awk '{print \$1}' | xargs kill"

