
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/Support/CommandLine.h"
#include <llvm/Analysis/LoopInfo.h>
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InlineAsm.h"

#include <string> 
#include <unistd.h> 
#include <set>
#include <iostream>
#include <fstream>

using namespace llvm;
using namespace std;

static cl::opt<string> oname("output-file-name",
          cl::desc("output file name"));

namespace {

  struct ParseSyscalls : public ModulePass {
    static char ID;
    ParseSyscalls() : ModulePass(ID) {}
    bool runOnModule(Module& M) {
      set<int> sysIds;
      for(Module::iterator mit = M.getFunctionList().begin(); mit != M.getFunctionList().end(); ++mit) {
        Function * func = &*mit;
        for(Function::iterator b = func->begin(), e = func->end(); b != e; ++b) {
          BasicBlock *BB = &*b;
          for(BasicBlock::iterator it = BB->begin(), it2 = BB->end(); it != it2; it++) {
            if(CallInst * callInst = dyn_cast<CallInst>(&*it)) {
              if(callInst->isInlineAsm()) {
                const InlineAsm * IA = cast<InlineAsm>(callInst->getCalledValue());            
                if(IA->getAsmString() == "syscall") {
                  if(ConstantInt * CI = dyn_cast<ConstantInt>(callInst->getOperand(0))) 
                    sysIds.insert(CI->getZExtValue());
                  else 
                    errs() << "skipping non constant in " << func->getName() << " " << *callInst << "\n";
                }
              }
            }      
          }
        }
      }
      ofstream ofile;
      ofile.open(oname);
      for(auto val : sysIds) ofile << val << "\n";     
      return true;
    }
  };
}

char ParseSyscalls::ID = 0;
static RegisterPass<ParseSyscalls> X("asm-analyze", "Simplifying library calls", false, false);
