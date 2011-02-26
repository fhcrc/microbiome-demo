#!/bin/sh -eu

PREFIX=pplacer_v1.1

case `uname -s` in
Linux)
  echo "Downloading linux binaries..."
  wget "http://matsen.fhcrc.org/pplacer/builds/${PREFIX}_Linux.2.6.5-7.324-smp.tar.gz"
  ;;
Darwin)
  echo "Downloading OS X binaries..."
  curl -O "http://matsen.fhcrc.org/pplacer/builds/${PREFIX}_Darwin.10.6.0.tar.gz"
  ;;
*)
  echo "Your OS is not recognized. You will have to download manually."
  ;;
esac

tar -xzf ${PREFIX}*.tar.gz

cat <<EOF
pplacer and guppy have been downloaded in this directory.
Now put them in your path, e.g. with:
export PATH=\$PATH:\`pwd\`/\`echo pplacer_*/\`
EOF
