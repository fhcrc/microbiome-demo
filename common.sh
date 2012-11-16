: ${SRC:=$MICROBIOME_ROOT/src${ALTSRC:+/$ALTSRC}}
: ${BIN:=$MICROBIOME_ROOT/bin}

command -v aptx >/dev/null || {
    aptx () {
        java -jar $BIN/forester.jar -c $BIN/_aptx_configuration_file $1 &
    }
}

cd $(dirname $0)

set -v
