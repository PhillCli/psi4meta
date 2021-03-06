
#if [ "$(uname)" == "Darwin" ]; then
#
#    # link against conda Clang
#    # * -fno-exceptions squashes `___gxx_personality_v0` symbol and thus libc++ dependence
#    ALLOPTS="-clang-name=${CLANG} ${OPTS} -fno-exceptions"
#    ALLOPTSCXX="-clang-name=${CLANG} -clangxx-name=${CLANGXX} -stdlib=libc++ -I${PREFIX}/include/c++/v1 ${OPTS} -fno-exceptions -mmacosx-version-min=10.9"
#
#    # configure
#    ${BUILD_PREFIX}/bin/cmake \
#        -H${SRC_DIR} \
#        -Bbuild \
#        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
#        -DCMAKE_BUILD_TYPE=Release \
#        -DCMAKE_C_COMPILER=icc \
#        -DCMAKE_CXX_COMPILER=icpc \
#        -DCMAKE_C_FLAGS="${ALLOPTS}" \
#        -DCMAKE_CXX_FLAGS="${ALLOPTSCXX}" \
#        -DCMAKE_INSTALL_LIBDIR=lib \
#        -DMAX_AM_ERI=${MAX_AM_ERI} \
#        -DBUILD_SHARED_LIBS=ON \
#        -DMERGE_LIBDERIV_INCLUDEDIR=ON \
#        -DENABLE_XHOST=OFF
#fi


if [ "$(uname)" == "Linux" ]; then

    # load Intel compilers
    set +x
    source /theoryfs2/common/software/intel2019/bin/compilervars.sh intel64
    set -x

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -GNinja \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=icpc \
        -DCMAKE_CXX_FLAGS="${ALLOPTS}" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DBUILD_SHARED=ON \
        -DBUILD_STATIC=OFF \
        -DLIBINT2_SHGAUSS_ORDERING=gaussian \
        -DLIBINT2_CARTGAUSS_ORDERING=standard \
        -DLIBINT2_SHELL_SET=standard \
        -DENABLE_ERI=2 \
        -DENABLE_ERI3=2 \
        -DENABLE_ERI2=2 \
        -DWITH_ERI_MAX_AM:STRING="5;5;5" \
        -DWITH_ERI3_MAX_AM=6 \
        -DWITH_ERI2_MAX_AM=6 \
        -DERI3_PURE_SH=OFF \
        -DERI2_PURE_SH=OFF \
        -DMPFR_ROOT=${PREFIX} \
        -DBOOST_ROOT=${PREFIX} \
        -DEigen3_ROOT=${PREFIX} \
        -DLIBINT_GENERATE_FMA=ON \
        -DENABLE_XHOST=OFF \
        -DENABLE_CXX11API=ON \
        -DENABLE_FORTRAN=OFF \
        -DBUILD_TESTING=ON

        #-DEigen3_DIR=${PREFIX}/share/eigen3/cmake/
fi

# build & install & test
cd build
cmake --build . --target install -j${CPU_COUNT}
