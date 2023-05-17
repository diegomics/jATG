import argparse
parser = argparse.ArgumentParser(description= "for html to Rdataset")
parser.add_argument("--ht", "-html", help="html file")
parser.add_argument("--O", "-out", help="Output")

arg = parser.parse_args()
inputopen = open(arg.ht)
owriter = open(arg.O,"w")
first=True
data=False
for lines in inputopen:
	line=lines.rstrip("\n").lstrip(" ")
	if line.startswith("data.addColumn"):
		val = line.rstrip("');\n").split(",")[1]
		if first==True:
			owriter.write(val.lstrip(" '"))
		else:
			owriter.write("\t"+val.lstrip(" '"))
		first=False

	elif line.startswith("data.addRows"):
		data=True
		owriter.write("\n")

	elif line.startswith("]);"):
		data=False

	elif line.startswith("[") and data==True:
		values=line.lstrip("['").rstrip("],\n").split(",")
		values[0]=values[0].rstrip("'")
		tabLine = "\t".join(values)
		owriter.write(tabLine+"\n")


owriter.close()
