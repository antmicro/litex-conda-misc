#!/bin/bash

set -x

cd "$PACKAGE"

# Copy the recipe from the Renode's master
git clone --depth 1 https://github.com/renode/renode.git
mv renode/tools/packaging/conda/* .
rm -rf renode
rm README.rst

# Make Travis-specific changes to the recipe
function patch-func {
    if ! patch --no-backup-if-mismatch "$1" "$2"; then
        # Print the rejected part of the diff
        cat "$1.rej"
        exit -1
    fi
}
patch-func build.sh build_without_gui.patch
patch-func meta.yaml meta_modifications.patch

# Clean the recipe
rm build_without_gui.patch
rm meta_modifications.patch
rm prescript..sh
