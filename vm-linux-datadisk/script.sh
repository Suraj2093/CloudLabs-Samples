No_of_DataDisk=$1
echo "No. of data disk is: " ${No_of_DataDisk} >> mountdatadisk.log

counter=0
echo "Counter : " $counter >> mountdatadisk.log

arr=(sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm sdn sdo sdp sdq sdr sds sdt sdu sdv sdw sdx sdy sdz)
echo "Array : " ${arr[*]} >> mountdatadisk.log

echo "Counter : " $counter >> mountdatadisk.log


while [ $counter -lt ${No_of_DataDisk} ]; do
echo "Disk Partition : " ${arr[$counter]} >> mountdatadisk.log
sudo fdisk /dev/${arr[$counter]} <<EOF
p
n
p
1


w
EOF

mkfs.ext4 /dev/${arr[$counter]}1 <<EOF
y
EOF

#"creating Directories to mount "
mkdir -p /mnt/data$counter

#log "Adding partitions to fstab to mount on reboot"
echo "/dev/${arr[$counter]}1     /mnt/data$counter    ext4   defaults,nofail   0 2" >> /etc/fstab

#log "Mounting newly created partition using fstab file"
mount -a

counter=`expr $counter + 1`
echo "Counter : " $counter >> mountdatadisk.log
done
