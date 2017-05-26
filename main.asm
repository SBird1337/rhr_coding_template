//this file can access the ROM directly,
//use it to place hooks, overwrite bytes etc.


//open a gba file named bpre0.gba in the base folder
//set the base symbol to 0x08000000, the ROM section

.gba
.thumb
.open "base/bpre0.gba","build/YOUR_PROJECT.gba",0x08000000

//you can include other files like so, the path is arbitrary

//.include "patches/some_hooks.asm"

//inside the file you only need to place instructions to override
//locations in the rom like so

//.org 0x08ABCDEF //some random address
//ldr r0, =some_global_symbol_in_the_source+1
//bx r0

//this would create a hook over r0 to some_global_symbol_in_the_source
//make sure the symbol is defined, and that it is thumb code
//NOTE: All code we define should be thumb code with our compiler settings

//You can also add hooks directly in here, this is an example which will
//be compiled and can be tinkered with


.org 0x0806D698
ldr r1, =ex_per_step_scripts+1
bx r1
.pool
//NOTE: We jump in r1 here because r0 is used by convention to pass the argument
//      We could also use r2-r3, those are caller-save convention registers as well
//      .pool indicates that armips may put symbolic constants here, so in this case
//      the address of ex_per_step_scripts will be located at the .pool pseudo-op



//this needs to be done to include all our code

//address of our code, I use a 32 MB rom, so I place it after the first
//16 MB of our main output file, after the original code has ended

.org 0x09000000
.importobj "object/linked.o"
.close