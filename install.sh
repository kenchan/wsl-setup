#!/bin/bash

set -u

mkdir -p ~/src/github.com/kenchan
git clone https://github.com/kenchan/wsl-ubuntu-setup.git ~/src/github.com/kenchan/wsl-ubuntu-setup

pushd ~/src/github.com/kenchan/wsl-ubuntu-setup

bin/setup
sudo bin/mitamae local recipe.rb

popd
