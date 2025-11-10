{ pkgs, ... }:
{
	virtualisation.spiceUSBRedirection.enable = true;

	virtualisation.libvirtd = {
		enable = true;
		qemu.package = pkgs.qemu_full;
	};
}
