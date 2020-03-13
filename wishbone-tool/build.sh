#!/bin/bash

# binutils build
set -e
set -x


cd wishbone-tool
cargo build --release

install -D target/release/wishbone-tool $PREFIX/bin
