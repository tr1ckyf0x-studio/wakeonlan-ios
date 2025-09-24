bootstrap: mint_bootstrap install_bundle generate_resources generate_xcodeproj_file

mint_bootstrap:
	MINT_LINK_PATH=.bin mint bootstrap --link

install_bundle:
	bundle install

generate_xcodeproj_file:
	mint run xcodegen

generate_resources:
	mint run swiftgen --config Wake\ On\ Lan/swiftgen.yml

git_clean:
	git clean -f -d -x
