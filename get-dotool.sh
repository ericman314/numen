#!/bin/sh
# ./get-dotool.sh ['install']
version=1.6
distfile="https://git.sr.ht/~geb/dotool/archive/$version.tar.gz"
checksum=ce6783b4b697cb8046da32995066926106db97afe7934b522b0e183b995fae1e

if [ "$*" != '' ] && [ "$*" != install ]; then
	echo bad usage
	exit 1
fi

ok=1
! command -v go >/dev/null && echo 'you need go (aka golang)' && unset ok
! command -v tar >/dev/null && echo 'you need tar' && unset ok
! command -v scdoc >/dev/null && echo 'you need scdoc' && unset ok
! command -v wget >/dev/null && echo 'you need wget' && unset ok
! test -d /usr/include/xkbcommon && echo 'you need libxkbcommon-dev' && unset ok
[ "$ok" ] || exit

export DOTOOL_VERSION="$version"

mkdir -p tmp && cd tmp
if ! [ "$1" ]; then
	wget --no-verbose -O dotool.tar.gz "$distfile" || exit
	if [ "$(sha256sum dotool.tar.gz | cut -d' ' -f1)" != "$checksum" ]; then
		echo dotool.tar.gz did not match checksum
		exit 1
	fi
	tar xf dotool.tar.gz || exit
	cd "dotool-$version" || exit
	./build.sh || exit
else
	cd "dotool-$version" || exit
	./build.sh install || exit
fi
