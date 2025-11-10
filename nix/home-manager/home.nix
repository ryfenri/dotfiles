{ config, pkgs, lib, inputs, ... }: {
	imports = [
		./zsh.nix
		./modules/bundles.nix
		inputs.zen-browser.homeModules.default
	];

	nixpkgs.config.allowUnfree = true;

	home = {
		username = "ryfenri";
		homeDirectory = "/home/ryfenri";
		stateVersion = "25.05";

		file =
		let
			symlink = config.lib.file.mkOutOfStoreSymlink;
			home_dir = config.home.homeDirectory;
		in {
			".config/rmpc/notify".source = symlink "${home_dir}/.github/dotfiles/.config/rmpc/notify";
			".config/rmpc/themes/".source = symlink "${home_dir}/.github/dotfiles/.config/rmpc/themes/";
			".config/mpd".source = symlink "${home_dir}/.github/dotfiles/.config/mpd";
		};

		packages = with pkgs; [
			cava
			vesktop
			rustdesk
			spotify
			pass
			obsidian
			obs-studio
			mpv
			swaybg
			matugen
			pywal
			pywalfox-native
			firefox

			lefthook

			qemu_full
			virt-manager
		];
	};


	programs.zen-browser.enable = true;

	programs.bash = {
		enable = true;
		initExtra = ''
		if [ -t 1 ] && [ "$(ps -p $PPID -o comm=)" != "zsh" ]; then
		  exec ${pkgs.zsh}/bin/zsh
		fi
		'';
	};
}
