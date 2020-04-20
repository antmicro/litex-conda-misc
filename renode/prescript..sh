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

sed -i.bak 's/name: renode/name: renode-travis/' meta.yaml
sed -i.bak "s/{{GIT_DESCRIBE_TAG}}/$DESCRIBE_TAG/" meta.yaml
sed -i.bak 's/git_url: .*/path: renode/' meta.yaml
sed -i.bak 's/git_rev: /# git_rev: /' meta.yaml
rm meta.yaml.bak
patch build.sh build_without_gui.patch
patch renode/tools/common.sh tools_common.patch

cat meta.yaml

ls -l
