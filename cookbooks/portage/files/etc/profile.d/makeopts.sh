#!/bin/bash
export MAKEOPTS="-j$(($(nproc) / 2))"
