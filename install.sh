#!/bin/bash

set -u

mkdir -p ~/src/github.com/kenchan
git clone https://github.com/kenchan/wsl-setup.git ~/src/github.com/kenchan/wsl-setup

pushd ~/src/github.com/kenchan/wsl-setup

bin/setup
sudo bin/mitamae local $@ system.rb

popd

echo -e "\nPlease run the following commands to complete the setup:\n"
echo -e "  \033[1m1. Authenticate with GitHub:\033[0m"
echo -e "     \033[36mgh auth login\033[0m\n"
echo -e "  \033[1m2. Set up your user environment:\033[0m"
echo -e "     \033[36mbin/mitamae local user.rb\033[0m\n"
