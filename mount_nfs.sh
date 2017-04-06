mount-nfs () {
    local POOLNUM=$1
    local server_name=tavi-cloud-nfs-$POOLNUM
    local mount_point=/nfs-pool-$POOLNUM
    echo "Mounting $server_name to $mount_point"

    sudo mkdir -p $mount_point
    sudo mount -t nfs $server_name:/nfs-pool $mount_point
    touch $mount_point/.witness.txt
    echo "Done mounting"
}

for POOLNUM in $(eval echo {$1..$2})
do
    mount-nfs $POOLNUM
done
