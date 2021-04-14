No_of_DataDisk=$1

counter=0
arr=(sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm sdn sdo sdp sdq sdr sds sdt sdu sdv sdw sdx sdy sdz)


while [ $counter -lt ${No_of_DataDisk} ]; do
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
done
