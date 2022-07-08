@echo off
if "%VS170COMNTOOLS%" == "" (
  msg "%username%" "Visual Studio 19(Visual Studio 2022) not detected, you can choose to run VsDevCmd.bat first before run this. Should locate at [VS2022 Installation Folder]\Common7\Tools"
  exit 1
)
if not exist x265.sln (
  call make-solutions.bat
)
if exist x265.sln (
  call "%VS170COMNTOOLS%\..\..\VC\vcvarsall.bat"
  MSBuild /property:Configuration="Release" x265.sln
  MSBuild /property:Configuration="Debug" x265.sln
  MSBuild /property:Configuration="RelWithDebInfo" x265.sln
)
