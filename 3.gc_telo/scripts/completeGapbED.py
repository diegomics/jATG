import argparse

parser = argparse.ArgumentParser(description='calculates the heterozygosity based on a vcf file using windows of size w')
parser.add_argument('-bed', '--b', help='bed containing gap positions')
parser.add_argument('-genome', '--g', help='number_lengths_GC_Ns from jatg Stats module')
parser.add_argument('-out', '--o', help='bed out file containg gaps and sequence regions')
args = parser.parse_args()


inBED=open(args.b)
inGenomeFile=open(args.g)
oWriter=open(args.o, "wt")

lenHash={}
visitedHash={}
for line in inGenomeFile:
	splitted=line.rstrip().split("\t")
	scafID=splitted[1]
	scafLen=int(splitted[2])
	lenHash[scafID]=scafLen

curI=0
lastID=""
for line in inBED:
	splitted=line.rstrip().split("\t")
	sID=splitted[0]
	start=int(splitted[1])
	end=int(splitted[2])

	scafLen=lenHash[sID]

	if not sID in visitedHash:
		if lastID!="":
			oWriter.write("%s\t%i\t%i\t%s\n"%(lastID, curI+1, lenHash[lastID], "CODING"))
		curI=0
		visitedHash[sID]=1



	if start > curI+1:
		newSegStart=curI+1
		newSegEnd=start-1
		oWriter.write("%s\t%i\t%i\t%s\n"%(sID, newSegStart, newSegEnd, "CODING"))
		curI=end

	lastID=sID
	lastLine=line
	oWriter.write("%s\t%i\t%i\t%s\n"%(sID, start, end, "GAP"))
