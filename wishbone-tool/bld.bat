@echo on

cd wishbone-tool
cargo build --release

copy target/release/wishbone-tool %PREFIX%/Library/
