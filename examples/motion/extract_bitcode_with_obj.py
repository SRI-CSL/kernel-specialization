import subprocess, sys, json, os, shutil
import string, random

def extract_bc_workdir(fname):
    fname, ext = os.path.splitext(os.path.basename(fname))
    workDir = os.getcwd() + '/wllvm_obj_files_' + fname 
    if ext:
        workDir += '_' + ext[1:]
    return workDir + '/'

def check_bc(line):
	if len(line) > 7 and line[:7] == "Writing":
		return True
	return False

def check_obj(line):
	if len(line) > 7 and line[:7] == "WARNING":
		return True
	return False

def get_bc(lines):
	bc = filter(lambda x : check_bc(x), lines)
	assert len(bc) == 1
	bc = bc[0][18:]
	# objs = filter(lambda x : check_obj(x), lines)
	# objs = map(lambda line : line[50:-26], objs)
	return bc

def extract_bc(fname):
	p = subprocess.Popen(["extract-bc", "-b", fname.strip()], stderr=subprocess.PIPE)
	lines = p.communicate()[1].split('\n')
	bc = get_bc(lines)
	basepath = extract_bc_workdir(fname)
	objs = map(lambda obj : basepath + obj, os.listdir(basepath))
	return bc, objs

def create_dir(name):
	if os.path.exists(name):
		shutil.rmtree(name)
	os.mkdir(name)
 
def move_dir(src, dest):
	if os.path.exists(dest):
		shutil.rmtree(dest)
	shutil.move(src, dest)

def get_new_dest(dest):
	dname = os.path.dirname(dest)
	fname, ext = os.path.splitext(os.path.basename(dest))
	return dname + '/' + fname + '.' + random.choice(string.letters) + ext 

def copy_without_replacement(src, dest):
	if os.path.exists(dest):
		new_dest = get_new_dest(dest)
		copy_without_replacement(src, new_dest)		
	else:
		shutil.copyfile(src, dest)

fname = sys.argv[1]
final_dir = None
if len(sys.argv) > 2:
	final_dir = sys.argv[2]
with open(fname) as f:
	content = f.readlines()
config = [x.strip() for x in content]

for line in config:
	toks = line.split()
	name, files = toks[0], toks[1:]
	bcdir, objdir = name + "_bcs/", name + "_objs/"
	create_dir(bcdir)
	create_dir(objdir)
	for fname in files:
		bc, objs = extract_bc(fname) 
		shutil.copyfile(bc, bcdir + os.path.basename(bc))
		for obj in objs:
			copy_without_replacement(obj, objdir + os.path.basename(obj))
	if final_dir:
		move_dir(bcdir, final_dir + '/' + bcdir)
		move_dir(objdir, final_dir + '/' + objdir)