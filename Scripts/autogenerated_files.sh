#!/bin/sh

# Make new lines the only separator
# Fixes spaces in paths
IFS=$'\n'

SCRIPT_DIR=$(dirname $(readlink -f $0))
PROJECT_ROOT=$(dirname $SCRIPT_DIR)

for file in $(find $PROJECT_ROOT -name 'preGen.sh'); do
	sh $file
done

for file in $(find $PROJECT_ROOT -name 'swiftgen.yml'); do
	swiftgen config run --config $file
done

for file in $(find $PROJECT_ROOT -name 'sourcery.yml'); do
	sourcery --config $file
done
