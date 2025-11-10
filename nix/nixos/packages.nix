{pkgs, inputs, ...}:
let
	custom_sddm_astronaut = pkgs.sddm-astronaut.override {
		embeddedTheme = "pixel_sakura";
	};
in {
	programs.niri.enable = true;

	environment.systemPackages = with pkgs; [
		ripgrep
		pinentry-curses
		unzip
		btop
		bat
		neovim
		fish
		zsh
		nautilus
		git
		kitty
		alacritty
		firefox
		tor-browser
		dunst
		swww
		starship
		rofi
		waybar
		inputs.noctalia.packages.${system}.default
		inputs.quickshell.packages.${system}.default
		inputs.caelestia-shell.packages.${system}.with-cli
		zoxide
		eza
		fastfetch
		tmux

		xwayland-satellite

		# gaming
		steam
		protonup

		# theme
		custom_sddm_astronaut
		qt6.qtwayland
		(tela-circle-icon-theme.override { colorVariants = [ "dracula" ]; })
		(catppuccin-kvantum.override {
			accent = "flamingo";
			variant = "macchiato";
		})
		papirus-folders
		adwaita-icon-theme
		adw-gtk3

		# dev
		gcc
		cargo
		python3
		python3Packages.pip
		home-manager


		# utils
		mpd
		wl-clipboard
		wf-recorder
		imagemagick
		jq
		grim
		grimblast
		slurp
		swappy
		fzf
		bluez
		bluez-tools
		blueman
		pavucontrol
		alsa-utils
		pipewire
		pulseaudio

		# lib
		libnotify
		lxqt.lxqt-policykit
		libsForQt5.qtstyleplugin-kvantum
		libsForQt5.qt5ct
		libsForQt5.qt5.qtquickcontrols2
		libsForQt5.qt5.qtgraphicaleffects
	];

	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-emoji
		noto-fonts-cjk-sans
		twemoji-color-font
		font-awesome
		cantarell-fonts
		cascadia-code
		powerline-fonts
		powerline-symbols
		material-symbols
		roboto
		montserrat
		nerd-fonts.fira-code
		nerd-fonts.jetbrains-mono
	];
}
