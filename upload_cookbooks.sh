#!/bin/bash

#TOOD - make this Rake taks

for i in `ls cookbooks` ; do knife cookbook upload $i ; done
