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

# Test general Renode fixes
patch meta.yaml win-python-version.patch
patch activate.sh limit-libdl-finding-to-linux.patch

sed -i.bak 's/name: renode/name: renode-travis/' meta.yaml
sed -i.bak "s/{{GIT_DESCRIBE_TAG}}/$DESCRIBE_TAG/g" meta.yaml
sed -i.bak 's/git_url: .*/path: renode/' meta.yaml
sed -i.bak 's/git_rev: /# git_rev: /' meta.yaml
rm meta.yaml.bak

cat meta.yaml

if [[ `uname` == 'Linux' || `uname` == 'Darwin' ]]; then
  patch build.sh build_without_gui.patch
  patch renode/tools/common.sh tools_common.patch
else
  sed -i.bak 's/\/p:/-p:/g' renode/build.sh
  rm renode/build.sh.bak
fi
