bootstrap: mint_bootstrap install_bundle generate_xcodeproj_file

mint_bootstrap:
	MINT_LINK_PATH=.bin mint bootstrap --link

install_bundle:
	bundle install

generate_xcodeproj_file:
	mint run xcodegen

git_clean:
	git clean -f -d -x

sync_development_certificates:
	bundle exec fastlane ios sync_development_certificates
