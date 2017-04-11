for POOLNUM in $(eval echo {$1..$2})
do
    export INSTANCE=tavi-cloud-nfs-$POOLNUM
    echo "Starting $INSTANCE..."
    gcloud compute instances start $INSTANCE --zone us-east1-b
done
