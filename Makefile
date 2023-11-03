bootstrap: mint_bootstrap install_bundle generate_xcodeproj_file install_pods_repo_update

mint_bootstrap:
	MINT_LINK_PATH=.bin mint bootstrap --link

install_bundle:
	bundle install

generate_xcodeproj_file:
	mint run xcodegen

install_pods:
	bundle exec pod install

install_pods_repo_update:
	bundle exec pod install --repo-update

generate_workspace: generate_xcodeproj_file install_pods

git_clean:
	git clean -f -d -x
