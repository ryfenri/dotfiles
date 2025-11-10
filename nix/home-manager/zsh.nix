{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		syntaxHighlighting.enable = true;

		oh-my-zsh = {
			enable = true;
			plugins = [ "git" ];
		};

		shellAliases =
		let
			flakePath = "~/nix";
			general_scripts_path = "~/.local/bin";
		in {
			rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
			upd = "nix flake update ${flakePath}";
			upg = "sudo nixos-rebuild switch --upgrade --flake ${flakePath}";
			hms = "home-manager switch --flake ${flakePath}";

			conf = "nvim ~/nix/nixos/configuration.nix";
			pkgs = "nvim ~/nix/nixos/packages.nix";
			hypr = "nvim ~/nix/home-manager/modules/wm/hypr/default.nix";


			l = "eza -lh --icons=auto"; # long list
			lg = "eza -lh --icons=auto --grid"; # long list grid
			ls = "eza -1 --icons=auto"; # short list
			ll = "eza -lha --icons=auto --group-directories-first";
			llg = "eza -lha --icons=auto --group-directories-first --grid"; # long list all grid
			ld = "eza -lhD --icons=auto"; # long list only dirs 

			# kitty
			icat = "kitten icat";

			# apps
			vim = "nvim";
			cat = "bat";
			ff = "fastfetch";
			fzf = "fzf --preview='bat --color=always {}' --border=rounded";
			vfzf = "nvim $(fzf --preview='bat --color=always {}' --border=rounded)";
			rq = "python3 ${general_scripts_path}/random_quotes.py";

			# obsidian
			on = "python3 ${general_scripts_path}/obsidian.py -n";
			os = "python3 ${general_scripts_path}/obsidian.py -s";
			op = "python3 ${general_scripts_path}/obsidian.py -p";
		};

		initContent = ''
		fastfetch
		'';
	};

	programs.zoxide = {
		enable = true;
		enableZshIntegration = true;
		options = [
			"--cmd cd"
		];
	};
}
