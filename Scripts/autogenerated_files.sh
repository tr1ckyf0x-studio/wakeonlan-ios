#!/bin/sh

mkdir -p Packages/Frameworks/Sources/WOLResources/Generated

swiftgen config run --config Packages/**/swiftgen.yml

for file in $(find . -name sourcery.yml); do
	sourcery -v --config $file
done
