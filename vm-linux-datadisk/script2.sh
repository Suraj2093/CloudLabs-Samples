#!/bin/bash

No_of_DataDisk=$1

counter=0
datadiskcount=1

parted -l | grep /dev/sd | grep -o sd[a-z] | sort -u -f > sample1.txt
lsblk | grep part | grep -o sd[a-z] | sort -u -f > sample2.txt

part1=$(head -1 sample2.txt | tail +1)
part2=$(head -2 sample2.txt | tail +2)

grep -v $part1 sample1.txt | grep -v $part2 > disk.txt
rm sample1.txt
rm sample2.txt

while [ $counter -lt ${No_of_DataDisk} ]; do
device=$(head -$datadiskcount disk.txt | tail +$datadiskcount)


sudo fdisk /dev/$device <<EOF
p
n
p
1


w
EOF

mkfs.ext4 /dev/${device}1 <<EOF
y
EOF
sleep 2

#"creating Directories to mount "
mkdir /data$counter
sleep 2

#log "Fetching the UUID of the device"
uuid=$(blkid -s UUID -o value /dev/${device}1)

#log "Adding partitions to fstab to mount on reboot"
echo "UUID=$uuid     /data$counter    ext4   defaults,nofail   0 2" >> /etc/fstab
sleep 2

#log "Mounting newly created partition using fstab file"
mount -a
sleep 5

counter=`expr $counter + 1`
datadiskcount=`expr $datadiskcount + 1`
done

rm disk.txt
