{ config, ... }:  {
	programs.git = {
		enable = true;

		settings.user = {
			name = "ryfenri";
			email = "rafa1000.skylanders@gmail.com";
		};
	};
}
