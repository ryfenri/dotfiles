{
  imports = [
	./env.nix
	./user.nix
	#./hyprland.nix
	./bluetooth.nix
#	./sddm-avatar.nix
	./services.nix
	./portal.nix
	./gpg.nix
	./virtualisation.nix
	./sound.nix

	# gaming
	./aagl.nix
	./cachix.nix
	./steam.nix
  ];
}
