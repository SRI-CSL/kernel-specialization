cp generateExclusionSymbols.py ${1}/.
cp slash_kernel.sh ${1}/.
cp ${2} ${1}/.
cd ${1}
python generateExclusionSymbols.py kernel-manifest.json exclusion_list
cat ${2} >> exclusion_list 
OCCAM_LOGFILE=occam.log slash --work-dir=slashing --keep-external=exclusion_list kernel-manifest.json
./compile_occam_final.sh