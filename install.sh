#!/bin/bash

set -u

mkdir -p ~/src/github.com/kenchan
git clone https://github.com/kenchan/wsl-setup.git ~/src/github.com/kenchan/wsl-setup

pushd ~/src/github.com/kenchan/wsl-setup

bin/setup
sudo bin/mitamae local $@ system.rb

popd

echo -e "\nPlease run the following command to complete the setup:\n"
echo -e "  \033[1mSet up your user environment:\033[0m"
echo -e "     \033[36mbin/mitamae local user.rb\033[0m\n"
