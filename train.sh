#! /usr/bin/env bash

function die {
    echo $1 && exit -1
}

ROOT=$PWD
CLUSTERFILE="$ROOT/clusters/parli.txt"
TMPDIR="$ROOT/tmp"
FONT="Tharlon"
FONTSTRIP=$(echo $FONT | tr -d ' ')
FONTDIR="$ROOT/$FONTSTRIP"
COUNT=1
LANG="mya"
export TESSDATA_PREFIX="/usr/share/tesseract-ocr/tessdata/"

[ -e $CLUSTERFILE ] || die "Cluster file not found"

rm -rf $TMPDIR
mkdir -p $TMPDIR
mkdir -p $FONTDIR

echo "Creating clusters"
for i in `seq 0 $COUNT`; do
    cat "$CLUSTERFILE" | sort -R  > "$TMPDIR/$i-clusters"
    cat "$TMPDIR/$i-clusters" | tr '\n' ' ' > "$TMPDIR/$i-clusters-squeezed"
    text2image --text="$TMPDIR/$i-clusters-squeezed" --outputbase="$FONTDIR/$LANG.$FONTSTRIP.exp$i" --font="$FONT" --fonts_dir="$HOME/.fonts"

    CLUSTERWC=$(wc -l "$TMPDIR/$i-clusters" | cut -f1 -d' ')
    BOXWC=$(wc -l "$FONTDIR/$LANG.$FONTSTRIP.exp$i.box" | cut -f1 -d' ')
    [ $CLUSTERWC = $BOXWC ] || die "$i - lines count in boxfile and clusters doesn't equal."

    ./merger.py "$FONTDIR/$LANG.$FONTSTRIP.exp$i.box" "$TMPDIR/$i-clusters" > "$FONTDIR/$LANG.$FONTSTRIP.exp$i.box.tmp"
    mv "$FONTDIR/$LANG.$FONTSTRIP.exp$i.box" "$FONTDIR/$LANG.$FONTSTRIP.exp$i.box.bak"
    mv "$FONTDIR/$LANG.$FONTSTRIP.exp$i.box.tmp" "$FONTDIR/$LANG.$FONTSTRIP.exp$i.box"
done

# for i in `seq 0 $COUNT`; do
#     tesseract "$FONTDIR/$LANG.$FONTSTRIP.exp$i.tif" "$FONTDIR/$LANG.$FONTSTRIP.exp$i"  box.train.stderr
# done

# cd $FONTDIR
# unicharset_extractor "$LANG.$FONTSTRIP".exp*.box

# echo "$FONTSTRIP 0 0 0 0 0" > font_properties
# shapeclustering -F font_properties -U unicharset "$LANG.$FONTSTRIP".exp*.tr
# mftraining -F font_properties -U unicharset -O "$LANG.unicharset" "$LANG.$FONTSTRIP".exp*.tr
# cntraining "$LANG.$FONTSTRIP".exp*.tr

# mv shapetable $LANG.shapetable
# mv normproto $LANG.normproto
# mv inttemp $LANG.inttemp
# mv pffmtable $LANG.pffmtable

# combine_tessdata $LANG.
