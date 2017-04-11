INSTANCES=()
for POOLNUM in $(eval echo {$1..$2})
do
    export INSTANCE=tavi-cloud-nfs-$POOLNUM
    INSTANCES+=($INSTANCE)
    echo "Stopping $INSTANCE..."
done
gcloud compute instances stop ${INSTANCES[@]} --zone us-east1-b
