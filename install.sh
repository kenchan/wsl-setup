#!/bin/bash

set -u

mkdir -p ~/src/github.com/kenchan
git clone https://github.com/kenchan/wsl-setup.git ~/src/github.com/kenchan/wsl-setup

pushd ~/src/github.com/kenchan/wsl-setup

bin/setup
sudo bin/mitamae local $@ system.rb

popd

echo -e "\n$ gh auth login\n$ bin/mitamae local user.rb\n"
