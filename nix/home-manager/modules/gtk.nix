{ pkgs, ... }: 

let
  tela-circle-dracula = (pkgs.tela-circle-icon-theme.override { colorVariants = [ "dracula" ]; }); 
in 
{
	gtk = {
		enable = true;
		theme = {
		  name = "Catppuccin-Macchiato-Standard-Flamingo-Dark";
		  package = pkgs.catppuccin-gtk.override {
			accents = [ "flamingo" ];
			size = "standard";
			variant = "macchiato";
		  };
		};
		iconTheme = {
			package =  tela-circle-dracula;
			name = "Tela-Circle-Dracula";
		};

		gtk3 = {
		  extraConfig.gtk-application-prefer-dark-theme = true;
		};
	  };

	  dconf.settings = {
		"org/gnome/desktop/interface" = {
		  gtk-theme = "Catppuccin-Macchiato-Standard-Flamingo-Dark";
		  color-scheme = "prefer-dark";
		};
	  };
}
