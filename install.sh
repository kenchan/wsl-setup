#!/bin/bash

set -u

mkdir -p ~/src/github.com/kenchan
git clone git@github.com:kenchan/wsl-setup.git ~/src/github.com/kenchan/wsl-setup

pushd ~/src/github.com/kenchan/wsl-setup

bin/setup
sudo bin/mitamae local $@ system.rb
#bin/mitamae local $@ user.rb

popd
