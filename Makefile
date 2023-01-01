all: 	nix-switch
	home-manager switch
	@echo

nix-switch:
	sudo nixos-rebuild switch


upgrade:
	sudo nix-channel --update
	sudo nixos-rebuild switch --upgrade

build:
	sudo nixos-rebuild build


test:
	sudo nixos-rebuild test
