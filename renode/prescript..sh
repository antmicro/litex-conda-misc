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

patch meta.yaml win-python-version.patch
sed -i.bak 's/name: renode/name: renode-travis/' meta.yaml
sed -i.bak "s/{{GIT_DESCRIBE_TAG}}/$DESCRIBE_TAG/" meta.yaml
sed -i.bak 's/git_url: .*/path: renode/' meta.yaml
sed -i.bak 's/git_rev: /# git_rev: /' meta.yaml
rm meta.yaml.bak
patch build.sh build_without_gui.patch
patch renode/build.sh verbose_build.patch
patch renode/tools/common.sh tools_common.patch
patch bld.bat add_msbuilds-path_in_bld.patch

cat meta.yaml

ls -l
