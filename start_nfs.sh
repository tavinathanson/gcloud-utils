for POOLNUM in $(eval echo {$1..$2})
do
    local INSTANCE=tavi-cloud-nfs-$POOLNUM
    echo "Starting $INSTANCE..."
    gcloud compute instances start tavi-cloud-nfs-$POOLNUM --zone us-east1-b
done
