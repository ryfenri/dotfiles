{ pkgs, ... }: {
  services = {
	gnome.gnome-keyring.enable = true;

    xserver = {
		enable = true;

		xkb.layout = "us";
		xkb.variant = "";

		videoDrivers = [ "nvidia" ];
    };
	
	displayManager.sddm = {
		enable = true;
		
		extraPackages = with pkgs; [
			kdePackages.qtmultimedia
		];

		theme = "sddm-astronaut-theme";
	};

    blueman = {
      enable = true;
    };

    openssh.enable = true;
    flatpak.enable = true;
	mpd.enable = true; 

/*
	mysql = {
		enable = true;
		package = pkgs.mariadb;
	};
  */
  };

  security.polkit.enable = true;
}
