#!/bin/sh

cd ${TMPDIR:-/tmp}

[ -z $(which tlmgr) ] || TL_INSTALLED_PKGS=$(tlmgr info --list --only-installed --data name | tr '\n' ' ')
[ -z "$TL_INSTALLED_PKGS" ] ||
  echo "If you want to reinstall currently installed packages, use this command after the TinyTeX installation is done:

    tlmgr install $TL_INSTALLED_PKGS"

OSNAME=$(uname)
[ -z $OSNAME ] && echo "This operating system is not supported." && exit 1

TINYTEX_INSTALLER=${TINYTEX_INSTALLER:-"TinyTeX-1"}

if [ $OSNAME = 'Darwin' ]; then
  TEXDIR=${TINYTEX_DIR:-"~/Library"}/TinyTeX
else
  TEXDIR=${TINYTEX_DIR:-"~"}/.TinyTeX
  if [ $OSNAME != 'Linux']; then
    TINYTEX_INSTALLER="intaller-unix"
  fi
fi

rm -rf $TEXDIR

if [ -z $TINYTEX_VERSION ]; then
  TINYTEX_URL="https://yihui.org/tinytex/$TINYTEX_INSTALLER"
else
  TINYTEX_URL="https://github.com/yihui/tinytex-releases/releases/download/v$TINYTEX_VERSION/$TINYTEX_INSTALLER-v$TINYTEX_VERSION"
fi

case $OSNAME in
  "Darwin")
    curl -LO ${TINYTEX_URL}.tgz
    tar xzf TinyTeX-1.tgz -C $(dirname $TEXDIR)
    rm TinyTeX-1.tgz
    ;;
  "Linux")
    wget --progress=dot:giga ${TINYTEX_URL}.tar.gz
    tar xzf TinyTeX-1.tar.gz -C $(dirname $TEXDIR)
    rm TinyTeX-1.tar.gz
    ;;
  *)
    echo "We do not have a prebuilt TinyTeX package for the operating system $(uname)."
    echo "I will try to install from source for you instead."
    wget ${TINYTEX_URL}.tar.gz
    tar xzf ${TINYTEX_INSTALLER}.tar.gz
    ./install.sh
    mkdir -p $TEXDIR
    mv texlive/* $TEXDIR
    rm -r texlive ${TINYTEX_INSTALLER}.tar.gz install.sh
    ;;
esac

cd $TEXDIR/bin/*/
[ $OSNAME != "Darwin" ] && ./tlmgr option sys_bin ~/bin
./tlmgr path add