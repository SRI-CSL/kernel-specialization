LLVM_INCLUDE_PATH=/usr/include/llvm-5.0/
LLVM_C_INCLUDE_PATH=/usr/include/llvm-c-5.0/


ifeq ($(LLVM_CC_NAME),)
  CLANG = clang
else
  CLANG = $(LLVM_CC_NAME)
endif

build_ParseSyscalls:
	mkdir -p build
	$(CLANG) -I$(LLVM_INCLUDE_PATH) -I$(LLVM_C_INCLUDE_PATH) -I./ -D_DEBUG -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -O3 -fomit-frame-pointer -std=c++11 -fvisibility-inlines-hidden -fno-exceptions -fno-rtti -fPIC -ffunction-sections -fdata-sections -Wcast-qual -pedantic -Wno-long-long -Wall -W -Wno-unused-parameter -Wwrite-strings -Wcovered-switch-default -Wno-uninitialized -Wno-missing-field-initializers -Wno-comment -c -MMD -MP -MF "build/ParseSyscalls.d.tmp" -MT "ParseSyscalls.o" -MT "ParseSyscalls.d" ParseSyscalls.cpp -o build/ParseSyscalls.o
	$(CLANG) -O3 -Wl,-R -Wl,'$ORIGIN' -Wl,--gc-sections -rdynamic -L./ -Lm./ -shared -o build/ParseSyscalls.so build/ParseSyscalls.o -lpthread -ltinfo -ldl -lm

build_UsedInAsm:
	mkdir -p build
	$(CLANG) -I$(LLVM_INCLUDE_PATH) -I$(LLVM_C_INCLUDE_PATH) -I./ -D_DEBUG -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -O3 -fomit-frame-pointer -std=c++11 -fvisibility-inlines-hidden -fno-exceptions -fno-rtti -fPIC -ffunction-sections -fdata-sections -Wcast-qual -pedantic -Wno-long-long -Wall -W -Wno-unused-parameter -Wwrite-strings -Wcovered-switch-default -Wno-uninitialized -Wno-missing-field-initializers -Wno-comment -c -MMD -MP -MF "build/UsedInAsm.d.tmp" -MT "UsedInAsm.o" -MT "UsedInAsm.d" UsedInAsm.cpp -o build/UsedInAsm.o
	$(CLANG) -O3 -Wl,-R -Wl,'$ORIGIN' -Wl,--gc-sections -rdynamic -L./ -Lm./ -shared -o build/UsedInAsm.so build/UsedInAsm.o -lpthread -ltinfo -ldl -lm
