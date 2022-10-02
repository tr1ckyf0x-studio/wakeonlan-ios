#!/bin/sh

GENERATED_DIR="./Wake\ On\ Lan/Modules/WOLResources/Sources/WOLResources/Generated"
eval mkdir -p $GENERATED_DIR

swiftgen config run --config Wake\ on\ LAN/Modules/**/swiftgen.yml

SOURCERY_MODULES=(
	"AddHost"
	"CoreDataService"
	"SharedProtocolsAndModels"
    "AboutScreen"
    "WOLResources"
    "WakeOnLanService"
    "SharedRouter"
	)

MODULES_FOLDER="./Wake On Lan/Modules"

for MODULE in "${SOURCERY_MODULES[@]}"; do
	MODULE_DIR="${MODULES_FOLDER}/${MODULE}"
	sourcery -v --config "${MODULE_DIR}/sourcery.yml"
done
