import subprocess
import json
import os, sys

def get_files(path):
	if path[-1] == '*':
		return list(map(lambda x: path[:-1] + x, os.listdir(path[:-1])))
	else:
		return [path]

def format_symbol_line(line):
	line = line[17:].split()
	return (line[0], line[1])

def get_Symbols(fname):
	p = subprocess.Popen(["llvm-nm", fname.strip()], stdout=subprocess.PIPE)
	symbols = p.communicate()[0]
	symbols = symbols.split('\n')
	if symbols[-1] == '':
		symbols = symbols[:-1]
	return list(map(lambda x: format_symbol_line(x), symbols))

def get_native_lib_UW_symbols(native_libs):
	symbols = []
	for path in native_libs:
		files = get_files(path)
		for nlb in files:
			csymbols = get_Symbols(nlb)
			for (tag, name) in csymbols:
				if tag == 'U' or tag == 'W':
					if not name in symbols:
						symbols.append(name)
				elif tag == 'T' or tag == 't' or tag == 'D' or tag == 'd':
					if name in symbols:
						symbols.remove(name)
				else:
					print "Ignoring Symbol ", tag, name, nlb
	return symbols

def update_with_module_TDW_symbols(modules, nlb_symbols):
	symbols = []
	for path in modules:
		files = get_files(path)
		for mod in files:
			csymbols = get_Symbols(mod)
			for (tag, name) in csymbols:
				if tag == 'T' or tag == 't' or tag == 'D' or tag == 'd':
					if name in nlb_symbols and not (name  in symbols):
						symbols.append(name)
				elif tag == 'W':
					if not name in symbols:
						symbols.append(name)
				elif not tag == 'U':
					print "Ignoring Symbol ", tag, name, mod
	return symbols

def parse_json(manifest_file):
	man_data = None
	with open(manifest_file) as mfile:    
		man_data = json.load(mfile)
	return man_data

def generateExclusionSymbols(modules, native_libs):
	nlb_symbols = get_native_lib_UW_symbols(native_libs)
	return update_with_module_TDW_symbols(modules, nlb_symbols)

if __name__ == '__main__':
	mname = sys.argv[1]
	oname = sys.argv[2]
	man_data = parse_json(mname)
	modules = man_data["modules"] + [man_data["main"]]
	native_libs = man_data["native_libs"]
	symbols = generateExclusionSymbols(modules, native_libs)
	with open(oname, 'w') as fd:
		for s in symbols:
			fd.write(s + '\n')