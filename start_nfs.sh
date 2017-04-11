INSTANCES=()
for POOLNUM in $(eval echo {$1..$2})
do
    export INSTANCE=tavi-cloud-nfs-$POOLNUM
    INSTANCES+=($INSTANCE)
    echo "Starting $INSTANCE..."
done
gcloud compute instances start ${INSTANCES[@]} --zone us-east1-b
