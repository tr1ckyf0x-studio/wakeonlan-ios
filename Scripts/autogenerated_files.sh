#!/bin/sh

GENERATED_DIR="./Wake\ On\ Lan/Modules/WOLResources/Sources/Generated"
eval mkdir -p $GENERATED_DIR
eval touch $GENERATED_DIR/Strings+Generated.swift
eval touch $GENERATED_DIR/XCAssets+Generated.swift

swiftgen config run --config Wake\ on\ LAN/Modules/**/swiftgen.yml

SOURCERY_MODULES=(
	"AddHost"
	"CoreDataService"
	)

MODULES_FOLDER="./Wake On Lan/Modules"

for MODULE in "${SOURCERY_MODULES[@]}"; do
	MODULE_DIR="${MODULES_FOLDER}/${MODULE}"
	sourcery -v --config "${MODULE_DIR}/sourcery.yml"
done
