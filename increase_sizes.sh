for POOLNUM in $(eval echo {$1..$2})
do
    echo "Increase size for $POOLNUM..."
	  export MAIN_NFS_SERVER=tavi-cloud-nfs-$POOLNUM
	  export ADD_NFS_SIZE=2000 # in GBs
    export OLD_DISK_NUM=$(eval gcloud compute disks list | grep tavi-cloud-nfs-$POOLNUM | awk 'BEGIN {FS="disk-"} {print $2}' | sed '/^\s*$/d' | cut -d \  -f 1)
    export DISK_NUM=$((OLD_DISK_NUM + 1))
    echo "Using disk number $DISK_NUM..."
	  export NEW_DISK_NAME=tavi-cloud-nfs-$POOLNUM-disk-$DISK_NUM
	  export GCLOUD_ZONE=us-east1-b
	  export ZPOOL_NAME=nfs-pool

	  # Create the disk
	  gcloud compute disks create $NEW_DISK_NAME --size $ADD_NFS_SIZE --type "pd-standard" --zone $GCLOUD_ZONE

	  # Attach it pseudo-physically to the main NFS VM
	  gcloud compute instances attach-disk $MAIN_NFS_SERVER --disk $NEW_DISK_NAME --device-name $NEW_DISK_NAME --zone $GCLOUD_ZONE

	  # Add this new disk to the ZFS POOL to expand the pool
	  gcloud compute ssh --zone $GCLOUD_ZONE $MAIN_NFS_SERVER -- sudo zpool add -f $ZPOOL_NAME /dev/disk/by-id/google-$NEW_DISK_NAME
done
