#!/bin/bash

# Path to github.com/ftyers/ud-scripts
UDSCRIPTS=$1 
# Prefix of the file you want to test, e.g. 'oab'
PREFIKS=$2

# Take the hand-annotated corpus and select only those sentences that have been fully annotated 
## Then remove the dependency and function annotation (tags following '@')
## And remove comments (lines starting with #)
## Remove duplicate newlines to make a single newline separator between each sentence
## Then replace that newline with ¶ as a sentence separator
## Convert the CG-annotated corpus to Apertium style
## Replace the newline, and add a newline after each token, as it was lost in conversion
## Get rid of the '<tv>' tag which shouldn't appear
cat $PREFIKS.vislcg.txt | python3 $UDSCRIPTS/vislcg3-fully-annotated.py 2>/dev/null | cut -f1 -d'@' | grep -v '^#' | python3 $UDSCRIPTS/remove-double-newlines.py | sed 's/^$/¶/g' | cg-conv -A -l | sed 's/¶/\n/g' | sed 's/\$ *\^/$\n^/g' | sed 's/<tv>//g' > /tmp/$PREFIKS.ref 
# Take the reference file and select only the surface forms, e.g. between ^ and /
## To avoid making unnecessary multiwords, add some guff at the end of the line
## Run it through the Apertium tools, 
## Then remove the guff.
cat /tmp/$PREFIKS.ref | cut -f2 -d'^' | cut -f1 -d'/' | sed 's/$/@#@./g' | apertium-destxt | lt-proc -w ../bre.automorf.bin  | apertium-retxt  | cut -f1 -d'@' > /tmp/$PREFIKS.src 
# Run the source file through the constraint grammar
cat /tmp/$PREFIKS.src | cg-proc -t ../bre.rlx.bin | sed 's/<tv>//g' > /tmp/$PREFIKS.tst
# Evaluate the file, calculating all kinds of statistics.
python3 $UDSCRIPTS/evaluate-tagger.py /tmp/$PREFIKS.src /tmp/$PREFIKS.ref /tmp/$PREFIKS.tst 
