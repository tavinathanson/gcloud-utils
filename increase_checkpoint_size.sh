echo "Increase size for checkpoint-trials..."
export MAIN_NFS_SERVER=checkpoint-trials-fs-vm
export ADD_NFS_SIZE=5000 # in GBs
export OLD_DISK_NUMS=$(eval gcloud compute disks list | grep checkpoint-trials-fs-[0-9][0-9]* | awk 'BEGIN {FS="fs-"} {print $2}' | sed '/^\s*$/d' | cut -d \  -f 1)
export NUMS_ARR=($OLD_DISK_NUMS)
IFS=$'\n'
export OLD_DISK_NUM=$(echo "${NUMS_ARR[*]}" | sort -nr | head -n1)
echo "Old disk number $OLD_DISK_NUM"
export DISK_NUM=$((OLD_DISK_NUM + 1))
echo "Using disk number $DISK_NUM..."
export NEW_DISK_NAME=checkpoint-trials-fs-$DISK_NUM
export GCLOUD_ZONE=us-east1-b
export ZPOOL_NAME=checkpoint-trials

# Create the disk
gcloud compute disks create $NEW_DISK_NAME --size $ADD_NFS_SIZE --type "pd-standard" --zone $GCLOUD_ZONE

# Attach it pseudo-physically to the main NFS VM
gcloud compute instances attach-disk $MAIN_NFS_SERVER --disk $NEW_DISK_NAME --device-name $NEW_DISK_NAME --zone $GCLOUD_ZONE

# Add this new disk to the ZFS POOL to expand the pool
gcloud compute ssh --zone $GCLOUD_ZONE $MAIN_NFS_SERVER -- sudo zpool add -f $ZPOOL_NAME /dev/disk/by-id/google-$NEW_DISK_NAME
