@ECHO off
title [Humbug] Visual Studio 2013 x64 Command Prompt 
@set builddir=build2013x64

@set PLATFORM=x64
@set CURDIR=%CD%
@REM call explorer build2013x64
@REM call explorer projects\Humbug
@set PATH=%~dp0projects\build\ImageMagick-6.7.9-Q16;%PATH%;%~dp0projects\build\MediaInfo;%~dp0projects\build\scripts

call %~dp0%config\config.bat
call "%DXSDK_DIR%\Utilities\Bin\dx_setenv.cmd"
cd "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\"
call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" amd64
set PATH=C:\Program Files\Git\usr\bin;D:\Program Files\ffmpeg\bin;E:\Devel\CPP\Libs\QT4\bin;D:\Program Files (x86)\ActivePerl_64_bit\Perl64\site\bin;D:\Program Files (x86)\ActivePerl_64_bit\Perl64\bin;%PATH%;
REM FFMPEG in Path already
REM set PATH=C:\Program Files\Git\usr\bin;E:\Devel\CPP\Libs\QT4\bin;D:\Program Files (x86)\ActivePerl_64_bit\Perl64\site\bin;D:\Program Files (x86)\ActivePerl_64_bit\Perl64\bin;%PATH%;
if "%PLATFORM%" == "X64" (
	set PLATFORM=x64
)

REM set QTDIR=E:\Devel\CPP\Libs\QT4
SET SDLDIR=%~dp0%builddir%\DEPS\SDL-%SDLVER%
SET LUA_DIR=E:\Devel\CPP\Libs\Lua\5.2.1\vc12\x64\static
REM SET BOOST_ROOTDIR=E:\Devel\CPP\Libs\boost\boost-1.55.0

IF NOT EXIST "%builddir%" mkdir %builddir%
cd %builddir%
@REM call VStudio2005CMD

@REM irgendwas mit popd oder pushd
@REM call VStudio2005CMD
@REM $(FULL_CURRENT_PATH)
@REM %comspec% /k ""$(FULL_CURRENT_PATH)""

REM call %comspec% /k ""C:\Programme\Microsoft Visual Studio 8\VC\vcvarsall.bat"" x86

type %~dp0%config\WelcomeShell.txt

REM start /B "C:\Program Files\Notepad++\notepad++.exe" "%~dp0\projects\np.session"
REM start /B "devenv" "Humbug.sln"

call %comspec% /U /k ""%~dp0\startcmake.bat"" x86

