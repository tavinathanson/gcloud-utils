get-project-name () {
    local project=$(curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" \
                         -H "Metadata-Flavor: Google" 2>/dev/null)
    echo $project
}

create-nfs () {
    local server_name=$1
    local size=$2
    local mount_point=$3
    echo "Creating $server_name"

    local project=$(get-project-name)
    source /home/tavi/coclo/my-config.env

    gcloudnfs create --zone $gcloud_zone --project $project \
              --network default --machine-type n1-standard-1 \
              --server-name $server_name \
              --data-disk-name $server_name-disk --data-disk-type pd-standard \
              --data-disk-size $size
    echo "Finished with gcloudnfs"
    echo "Add: export NFS_MOUNTS=\$NFS_MOUNTS:$server_name,/nfs-pool/,.witness.txt,$mount_point"
}

create-nfs-if-none () {
    # Only argument is NFS server number
    local POOLNUM=$1
    local EXISTING=$(eval gcloud compute disks list | grep tavi-cloud-nfs-$POOLNUM)
    if [ -z "$EXISTING" ]; then echo "$POOLNUM does not exist yet"; else echo "$POOLNUM already exists"; return; fi

    create-nfs tavi-cloud-nfs-$POOLNUM 2000 /nfs-pool-$POOLNUM
}

for POOLNUM in $(eval echo {$1..$2})
do
    create-nfs-if-none $POOLNUM
done
