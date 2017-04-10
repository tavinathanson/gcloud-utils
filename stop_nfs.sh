for POOLNUM in $(eval echo {$1..$2})
do
    export INSTANCE=tavi-cloud-nfs-$POOLNUM
    echo "Stopping $INSTANCE..."
    gcloud compute instances stop $INSTANCE --zone us-east1-b
done
