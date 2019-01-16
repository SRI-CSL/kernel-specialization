wget http://acme.com/software/thttpd/thttpd-2.27.tar.gz
tar xvf thttpd-2.27.tar.gz
cd thttpd-2.27
CC=gclang ./configure 
make CC=gclang
get-bc -b thttpd
cp thttpd.bc ..
cd ..

get-bc -b ${2}/lib/libc.a
cp ${2}/lib/libc.a.bc .

../../occam_pipe_line/run_occam.sh $PWD thttpd.manifest keep.list ${3}

cp slashing/libc.a-final.bc .



cd ../../LLVMPasses/ && make build_ParseSyscalls && cd ../examples/thttpd/
opt -load ../../LLVMPasses/build/ParseSyscalls.so -parse-asm -output-file-name=${1} libc.a-final.bc -o tmp.bc 

# hard-coding system call Id for non-constant syscall case in libc
echo "105" >> ${1}
