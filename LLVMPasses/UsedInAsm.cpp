
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

namespace {

  struct UsedInAsm : public ModulePass {
    static char ID;
    UsedInAsm() : ModulePass(ID) {}
    bool isDelim(char c) {
      return (c == '_' || (c >= 48 && c <= 57) || (c >= 65 && c <= 90) || (c >= 97 && c <= 122));
    }
    vector<string> getTokens(string asmString) {
      string currString;
      vector<string> tokens;
      for(unsigned i = 0; i < asmString.size(); i++) {
        char c = asmString[i];
        if(isDelim(c))
          currString += c;
        else {
          tokens.push_back(currString);
          currString = "";
        } 
      }
      return tokens;
    }
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
                if(IA->getAsmString() != "syscall") {
                  vector<string> tokens = getTokens(IA->getAsmString());
                  for(unsigned i = 0; i < tokens.size(); i++)
                    errs() << tokens[i] << "\n";
                }
              }
            }      
          }
        }
      }
      return true;
    }
  };
}

char UsedInAsm::ID = 0;
static RegisterPass<UsedInAsm> X("used-in-asm", "Simplifying library calls", false, false);
