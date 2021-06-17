#!/bin/bash

checkmd5 () {
    md5_hash=$1
    md5_file=$(md5sum $2)
    md5_file=${md5_file%% *}
    echo "MD5 hash to check: $md5_hash"
    echo "MD5 hash from $(basename $2): $md5_file"
    if [[ "$md5_hash" == "$md5_file" ]]
    then 
        echo "MD5 hash matches the file!"
    else
        echo "MD5 hash does not match the file!"
    fi
}
