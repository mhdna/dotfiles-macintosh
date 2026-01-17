.PHONY: dots delete

dots:
	# cp ~/.local/share/rofimoji/frecency ./rofimoji/.local/share/rofimoji/ > /dev/null 2>&1; rm ~/.local/share/rofimoji/frecency > /dev/null 2>&1
	./stow-wrapper.sh --dotfiles --verbose --target=$$HOME --restow */

delete:
	./stow-wrapper.sh --verbose --target=$$HOME --delete */

brew:
	brew install --file=./brew_packages.txt

os:
	# Change default Screenshots Location
	defaults write com.apple.screencapture location ~/Pictures/Screenshots

services:
	# Services
	# brew services start mysql
