TMP_BUILD=$(mktemp -d 2>/dev/null || mktemp -d -t 'citmpdir')
mkdir -p ../cmake-3.7.2
cd ../cmake-3.7.2
DSTDIR=$(pwd)
cd ${TMP_BUILD}
curl https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.sh --output cmake-3.7.2-Linux-x86_64.sh
echo '2e250d9a23764a9c54262c1ddc275b02666b81e2cbe05459d15906825655874b  cmake-3.7.2-Linux-x86_64.sh' > cmake-check.txt
shasum -c cmake-check.txt
sharc=$?;
rm cmake-check.txt
if [[ $sharc != 0 ]]; then exit $sharc; fi
sh ./cmake-3.7.2-Linux-x86_64.sh --skip-license --prefix=${DSTDIR}
