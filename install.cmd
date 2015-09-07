@echo off
setlocal
set VIMBIN=
set GITBIN=
set INSTALL_TEMP=%TEMP%\vimrc_install_%RANDOM%
set PWD=%CD%
set VIMRC_GIT=https://github.com/weig/vim
set SOLARIZED_COLOR_GIT=https://github.com/altercation/solarized.git
set PLUGIN_GIT=https://github.com/vim-scripts/vcscommand.vim.git https://github.com/kien/ctrlp.vim.git https://github.com/scrooloose/nerdtree.git https://github.com/scrooloose/nerdcommenter.git
echo.
echo Vim Configuration Setup Script
echo ==============================
echo.
:::::Check required environment
set /p ="Searching Vim installation... " <nul

for /r "%ProgramFiles(x86)%\Vim" %%I in (vim.exe*) do set VIMBIN=%%I
for /r "%ProgramFiles%\Vim" %%I in (vim.exe*) do set VIMBIN=%%I

if "%VIMBIN%"=="" goto no_vim_found

echo %VIMBIN%

:::::Check Git binary
set /p ="Searching for Git installation... " < nul
for /r "%ProgramFiles(x86)%\Git" %%I in (git.exe*) do set GITBIN=%%I
for /r "%ProgramFiles%\Git" %%I in (git.exe*) do set GITBIN=%%I

if "%GITBIN%"=="" set GITBIN=%GIT_BIN%

if not exist "%GITBIN%" goto no_git_found

echo %GITBIN%
:::::Check Home directory
set HOME=%HOMEDRIVE%%HOMEPATH%
echo User Home Directory is %HOME%

if not exist %HOME% goto no_home_found

:::::Create Working copy
mkdir %INSTALL_TEMP%
cd /d %INSTALL_TEMP%

"%GITBIN%" clone %VIMRC_GIT% vim
if not %ERRORLEVEL%==0 goto error_clone_vim

"%GITBIN%" clone %SOLARIZED_COLOR_GIT% solarized
if not %ERRORLEVEL%==0 goto error_clone_solarized

mkdir %INSTALL_TEMP%\plugins
cd %INSTALL_TEMP%\plugins

for %%I in (%PLUGIN_GIT%) do (
        "%GITBIN%" clone %%I
        if not %ERRORLEVEL%==0 goto error_clone_plugin
        )
cd ..

:::::Install vimrc file
echo Installing .vimrc file to %HOME%\.vimrc...
copy %INSTALL_TEMP%\vim\.vimrc %HOME% > nul

:::::Setup .vim directory
echo Preparing .vim directory at %HOME%\.vim...
if exist %HOME%\.vim move %HOME%\.vim %HOME%\_vim_old

mkdir %HOME%\.vim

:::::Install Solarized Color Theme
echo Installing Solarized Color Theme...
if not exist %HOME%\.vim\colors mkdir %HOME%\.vim\colors
copy solarized\vim-colors-solarized\colors\solarized.vim %HOME%\.vim\colors > nul

:::::Install Plugins
for /d %%I in (%INSTALL_TEMP%\plugins\*) do (
        echo Installing Plugin %%~nI...
        xcopy /e /c /i /y %%I\* %HOME%\.vim\ > nul
        )

echo Completed!
goto end

:no_vim_found
echo Cannot find Vim binary in your Program Files folder. Please make sure the Vim is installed.
goto end

:no_home_found
echo Cannot find HOME directory. Please make sure the environment HOMEDRIVE and HOMEPATH are set.
goto end

:no_git_found
echo Cannot find Git binary. Please make sure Git binary is installed or set GIT_BIN environment to the binary.
goto end

:error_clone_vim
echo Error occurs while cloning the Vimrc repository.
goto end

:error_clone_solarized
echo Error occurs while cloning the Solarized Color theme repository.
goto end

:error_clone_plugin
echo Error occurs while cloning one of the plugin repositories.
goto end

goto end

:end
echo Cleaning up...
cd /d %PWD%
rd /q /s %INSTALL_TEMP%
endlocal

