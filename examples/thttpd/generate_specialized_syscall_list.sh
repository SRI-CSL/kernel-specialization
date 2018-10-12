wget http://acme.com/software/thttpd/thttpd-2.27.tar.gz
tar xvf thttpd-2.27.tar.gz
cd thttpd-2.27
CC=gclang ./configure 
make CC=gclang
get-bc -b thttpd
cp thttpd.bc ..
cd ..

cp ../init-utilities/* .

OCCAM_LOGFILE=occam.log slash --work-dir=slashing --keep-external=keep.list --no-strip ${1} 
cp slashing/libc.a-final.bc .


cd ../../LLVMPasses/ && make build_ParseSyscalls && cd ../examples/thttpd/
opt -load ../../LLVMPasses/build/ParseSyscalls.so -asm-analyze -output-file-name=${2} libc.a-final.bc -o tmp.bc 

# hard-coding system call Id for non-constant syscall case in libc
echo "105" >> ${2}

python ../generateSysCallList.py ${2} ../syscallIdToName ${3}

cat ../necessary_symbols >> ${3}
