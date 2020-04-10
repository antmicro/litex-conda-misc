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

sed -i.b 's/name: renode/name: renode-travis/' meta.yaml
sed -i.b "s/{{GIT_DESCRIBE_TAG}}/$DESCRIBE_TAG/" meta.yaml
sed -i.b 's/git_url: .*/path: renode/' meta.yaml
sed -i.b 's/git_rev: /# git_rev: /' meta.yaml
rm meta.yaml.b
patch meta.yaml meta_requirements.patch
patch build.sh build_sed.patch
patch build.sh build_without_gui.patch
patch renode/tools/common.sh tools_common.patch

cat meta.yaml

ls -l
