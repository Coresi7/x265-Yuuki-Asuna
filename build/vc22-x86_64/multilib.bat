@echo off
if "%VS170COMNTOOLS%" == "" (
  vsdevcmd.bat
)

mkdir 8bit
if not exist CMakeCache.txt (
    copy ..\CMakeDemo\CMakeCache.txt %~dp0\8bit
)

if "%VS170COMNTOOLS%" == "" (
  msg "%username%" "Visual Studio 17 not detected"
  goto end
)

call "%VS170COMNTOOLS%\..\..\VC\vcvarsall.bat"

mkdir 12bit
mkdir 10bit

pushd 12bit
cmake -G "Visual Studio 17" ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DMAIN12=ON
if exist x265.sln (
  MSBuild /property:Configuration="Release" x265.sln
  copy/y Release\x265-static.lib ..\8bit\x265-static-main12.lib
)

pushd ..\10bit
cmake -G "Visual Studio 17" ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
if exist x265.sln (
  MSBuild /property:Configuration="Release" x265.sln
  copy/y Release\x265-static.lib ..\8bit\x265-static-main10.lib
)

pushd ..\8bit
if not exist x265-static-main10.lib (
  msg "%username%" "10bit build failed"
  goto end
)
if not exist x265-static-main12.lib (
  msg "%username%" "12bit build failed"
  goto end
)
cmake -G "Visual Studio 17" ../../../source -DEXTRA_LIB="x265-static-main10.lib;x265-static-main12.lib" -DLINKED_10BIT=ON -DLINKED_12BIT=ON
if exist x265.sln (
  MSBuild /property:Configuration="Release" x265.sln
  :: combine static libraries (ignore warnings caused by winxp.cpp hacks)
  move Release\x265-static.lib x265-static-main.lib
  LIB.EXE /ignore:4006 /ignore:4221 /OUT:Release\x265-static.lib x265-static-main.lib x265-static-main10.lib x265-static-main12.lib
)

:end
popd