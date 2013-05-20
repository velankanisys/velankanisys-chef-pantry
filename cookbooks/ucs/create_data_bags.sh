#!/bin/bash

for i in `ls data_bags` ; do 
    for j in `ls data_bags/$i/`; do
        knife data bag create $i
            knife data bag from file $i data_bags/$i/$j ;
       done ;
    done
