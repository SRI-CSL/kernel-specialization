./get_sources.sh
MUSLLVM=${2} ./get_bitcode.sh
../../occam_pipe_line/run_occam.sh $PWD motion.manifest keep.list ${3}
cp slashing/libc.a-final.bc .


cd ../../LLVMPasses/ && make build_ParseSyscalls && cd ../examples/motion/
opt -load ../../LLVMPasses/build/ParseSyscalls.so -parse-asm -output-file-name=${1} libc.a-final.bc -o tmp.bc 

