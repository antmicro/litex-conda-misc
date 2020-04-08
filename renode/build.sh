#! /bin/bash

set -x

if [[ "$(uname)" == 'Linux' ]]; then
    install -D /usr/bin/realpath $BUILD_PREFIX/bin/realpath
    install -D /bin/sed $BUILD_PREFIX/bin/sed

fi

./build.sh --no-gui

mkdir -p $PREFIX/opt/renode/bin
mkdir -p $PREFIX/opt/renode/scripts
mkdir -p $PREFIX/opt/renode/platforms
mkdir -p $PREFIX/opt/renode/tests
mkdir -p $PREFIX/opt/renode/licenses


cp .renode-root $PREFIX/opt/renode/
cp -r output/bin/Release/* $PREFIX/opt/renode/bin/
cp -r scripts/* $PREFIX/opt/renode/scripts/
cp -r platforms/* $PREFIX/opt/renode/platforms/
cp -r tests/* $PREFIX/opt/renode/tests/

cp lib/resources/styles/robot.css $PREFIX/opt/renode/tests
cp src/Renode/RobotFrameworkEngine/renode-keywords.robot $PREFIX/opt/renode/tests
cp src/Renode/RobotFrameworkEngine/helper.py $PREFIX/opt/renode/tests

#copy the licenses
#some files already include the library name
find ./src/Infrastructure/src/Emulator ./lib ./tools/packaging/macos -iname "*-license" -exec cp {} $PREFIX/opt/renode/licenses/ \;

#others will need a parent directory name.
find ./src/Infrastructure ./lib/resources -iname "license" -print0 |\
    while IFS= read -r -d $'\0' file
do
    full_dirname=${file%/*}
    dirname=${full_dirname##*/}
    cp $file $PREFIX/opt/renode/licenses/$dirname-license
done

sed -i 's#os\.path\.join(this_path, "\.\./src/Renode/RobotFrameworkEngine/renode-keywords\.robot")#os.path.join(this_path,"renode-keywords.robot")#g' $PREFIX/opt/renode/tests/robot_tests_provider.py
sed -i "s#os\.path\.join(this_path, '\.\./lib/resources/styles/robot\.css')#os.path.join(this_path,'robot.css')#g" $PREFIX/opt/renode/tests/robot_tests_provider.py

mkdir -p $PREFIX/bin/

echo -e '#!/bin/bash\n\nmono $MONO_OPTIONS $CONDA_PREFIX/opt/renode/bin/Renode.exe "$@"' > $PREFIX/bin/renode
echo -e '#!/bin/bash\n\npython $CONDA_PREFIX/opt/renode/tests/run_tests.py --robot-framework-remote-server-full-directory $CONDA_PREFIX/opt/renode/bin "$@"' > $PREFIX/bin/renode-test

mkdir -p "${PREFIX}/etc/conda/activate.d"
cp "${RECIPE_DIR}/activate.sh" "${PREFIX}/etc/conda/activate.d/${PKG_NAME}_activate.sh"

