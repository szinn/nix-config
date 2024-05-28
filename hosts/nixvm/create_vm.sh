#!/usr/bin/env bash

set -euo pipefail

prlctl create nixvm -o other
prlctl set nixvm --device-set cdrom0 --image ~/Downloads/nixos-minimal-23.11.7313.9d29cd266ceb-aarch64-linux.iso --connect
prlctl set nixvm --device-set net0 --type bridged
prlctl set nixvm --device-set net0 --mac DECAFF200102
prlctl set nixvm --memsize 16384
prlctl set nixvm --cpus 4
prlctl set nixvm --device-set hdd0 --size 128G
prlctl start nixvm
