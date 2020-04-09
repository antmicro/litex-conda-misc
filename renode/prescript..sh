#!/bin/bash

set -x

BRANCH=master

cd renode
git clone https://github.com/renode/renode.git
cd renode
git checkout $BRANCH
DESCRIBE_TAG=`git describe --tags | tr '-' '_'`

cd ..
cat meta.yaml
mv renode/tools/packaging/conda/* .

sed -i "s/{{GIT_DESCRIBE_TAG}}/$DESCRIBE_TAG/" meta.yaml
sed -i 's/git_url: .*/path: renode/' meta.yaml
sed -i 's/git_rev: /# git_rev: /' meta.yaml
patch meta.yaml meta_python_2.7.patch
patch build.sh build_without_gui.patch

cat meta.yaml

ls -l
