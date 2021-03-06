#!/bin/bash -e

# Get list of keyframe lists
KEYFRAMES_LISTS=test_keyframe_lists.txt
ls ../../indexer/test_db/*.txt > $KEYFRAMES_LISTS

# Parameters for frame-based index
CENTROIDS=512
LD_MODE=1
VERBOSE=1

if [ $LD_MODE -eq 0 ]; then
    LD_NAME=sift
elif [ $LD_MODE -eq 1 ]; then
    LD_NAME=siftgeo
else
    echo "Unrecognized LD_NAME"
    exit
fi

# Loop over each video and binarize their point indexed FVs
for list in `cat $KEYFRAMES_LISTS`; do
    # Edit list to take into account relative path
    sed 's,\.\./,../../indexer/,g' $list > ${list}.pi

    in_name=${list%.txt}.${LD_NAME}_fv_point_idx_k${CENTROIDS}
    out_name=${list%.txt}.${LD_NAME}_bfv_point_idx_k${CENTROIDS}
    
    # Command line
    cmd=$(echo time \
               ./binarize_index \
               -i $in_name \
               -o $out_name \
               -v $VERBOSE)

    # Write and execute command
    echo $cmd
    $cmd
done
