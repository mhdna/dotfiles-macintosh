.PHONY: dots delete

dots:
	# cp ~/.local/share/rofimoji/frecency ./rofimoji/.local/share/rofimoji/ > /dev/null 2>&1; rm ~/.local/share/rofimoji/frecency > /dev/null 2>&1
	./stow-wrapper.sh --dotfiles --verbose --target=$$HOME --restow */

delete:
	./stow-wrapper.sh --verbose --target=$$HOME --delete */
