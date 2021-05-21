#!/bin/sh

GENERATED_DIR="./Wake\ On\ Lan/Modules/WOLResources/Generated"
eval mkdir -p $GENERATED_DIR
eval touch $GENERATED_DIR/Strings+Generated.swift
eval touch $GENERATED_DIR/XCAssets+Generated.swift
eval touch $GENERATED_DIR/Fonts.swift