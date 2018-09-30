import sys

idsFile = sys.argv[1]
NamesAndIdsFile = sys.argv[2]
oname = sys.argv[3]

with open(idsFile) as f:
    content = f.readlines()
ids = [x.strip() for x in content]

IdToName = {}
with open(NamesAndIdsFile) as f:
    content = f.readlines()
content = [x.strip() for x in content]
for line in content:
	tup = line.split()
	IdToName[tup[2]] = tup[1][4:]

with open(oname, 'w') as fd:		
	for i in ids:
		if i == "":
			continue	
		fd.write("SyS_" + IdToName[i] + '\n')
		fd.write("sys_" + IdToName[i] + '\n')