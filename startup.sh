#!/usr/bin/env bash
# elasticsearch settings and run
sudo sysctl -w vm.max_map_count=262144

#Optional to install fish shell
sudo apt-add-repository ppa:fish-shell/release-2; \
sudo apt-get update; \
sudo apt-get install -y fish

# Make fish my default shell
sudo chsh -s $(which fish) $(whoami)
