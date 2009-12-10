addCMakeParams()
{
    addToSearchPath CMAKE_INCLUDE_PATH $1/include
    addToSearchPath CMAKE_LIBRARY_PATH $1/lib
    addToSearchPath CMAKE_MODULE_PATH $1/share/cmake-@majorVersion@/Modules
}

fixCmakeFiles()
{
    local replaceArgs
    echo "fixing cmake files"
    replaceArgs="-e -f -L -T /usr /FOO"
    replaceArgs="$replaceArgs -a NO_DEFAULT_PATH \"\" -a NO_SYSTEM_PATH \"\""
    find $1 -type f -name "*.cmake" -print0 | xargs -0 replace-literal ${replaceArgs}
}

cmakeConfigurePhase()
{
    eval "$preConfigure"

    if test -z "$dontFixCmake"; then
        fixCmakeFiles .
    fi

    if test -z "$dontUseCmakeBuildDir"; then
        mkdir -p build
        cd build
        cmakeDir=..
    fi

    if test -z "$dontAddPrefix"; then
        cmakeFlags="-DCMAKE_INSTALL_PREFIX=$prefix $cmakeFlags"
    fi

    # Avoid cmake resetting the rpath of binaries, on make install
    cmakeFlags="-DCMAKE_SKIP_BUILD_RPATH=ON $cmakeFlags"

    echo "cmake flags: $cmakeFlags ${cmakeFlagsArray[@]}"

    cmake ${cmakeDir:-.} $cmakeFlags ${cmakeFlagsArray[@]}

    eval "$postConfigure"
}

if test -z "$dontUseCmakeConfigure"; then
    configurePhase=cmakeConfigurePhase
fi

envHooks=(${envHooks[@]} addCMakeParams)
