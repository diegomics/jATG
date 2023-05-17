# Usage:
```
usage: repeatMaskerHtml2R.py [-h] [--ht HT] [--O O]

for html to Rdataset

optional arguments:
  -h, --help         show this help message and exit
  --ht HT, -html HT  html file
  --O O, -out O      Output
```

```
Usage: Rscript plotREP.R <configFile> <out.svg>
```

# Easy way to run on a directory of html files:
```
JATGBASE="/home/max/myGITs/jatg"                                                                                         
DATA="/media/max/data/projects/phd/ANALYSIS/Y-CHROM/repeatStuff"
CFG="/media/max/data/projects/phd/ANALYSIS/Y-CHROM/repeatStuff/repStuff.cfg"

rm -rf $CFG

for html in $DATA/*.html;do
        echo $html
        SID=$(basename $html | sed 's/.fasta.align.divsum.html//')
        echo $SID
        python $JATGBASE/1.preliminary/2.masking/scripts/repeatMaskerHtml2R.py --ht $html --O ${html}_R.tsv
        echo -e "${SID}\t${html}_R.tsv" >> $CFG
done

Rscript $JATGBASE/1.preliminary/2.masking/scripts/plotREP.R $CFG ${CFG}.svg
```
