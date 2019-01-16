# ${1} -> work directory
# ${2} -> manifest file
# ${3} -> keep.list
# ${4} -> kernel specialization home

cp ${3} ${1}/.
cp ${2} ${1}/.

cd ${4}/LLVMPasses
make build_UsedInAsm

cd ${4}/occam_pipe_line
cp generateExclusionSymbols.py ${1}/.
cd ${1}
KS_PATH=${4} python generateExclusionSymbols.py ${2} exclusion_list
cat ${3} >> exclusion_list 
rm occam.log
OCCAM_LOGFILE=occam.log slash --work-dir=slashing --keep-external=exclusion_list --no-strip --no-specialize ${2} 