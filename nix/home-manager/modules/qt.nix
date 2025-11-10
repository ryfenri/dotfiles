{ pkgs, ...}:
{
	qt = { 
		enable = true;
		platformTheme.name = "qtct";
		style.name = "kvantum";
	};

	xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
		General.theme = "Catppuccin-Macchiato-Flamingo";
	};
}
