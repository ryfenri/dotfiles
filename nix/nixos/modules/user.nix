{ pkgs, ...}: {
	users = {
		users.ryfenri= {
			isNormalUser = true;
			description = "ryfenri";
			extraGroups = [
				"networkmanager"
				"wheel"
				"input"
				"libvirtd"
				"kvm" 
				"disk"
			];
			packages = with pkgs; [];
		};
	};
}
