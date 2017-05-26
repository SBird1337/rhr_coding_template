### Heart of the toolchain, compiles your code, ###
### links it, and inserts it into the ROM		###
###												###

AS	:= arm-none-eabi-as
LD	:= arm-none-eabi-ld
OBJCOPY	:= arm-none-eabi-objcopy
CC	:= arm-none-eabi-gcc
ARS	:= armips

### Other tools you might need at some point    ###
### can be defined here as well					###

GRIT	:= grit
NM		:= arm-none-eabi-nm
VBA		:= vba
MAKE	:= make

### Define a standard path for make to look for ###
### your tools, as well as your standard path	###

export PATH := $(realpath ../tools):$(PATH)

### Some arguments for gcc you can acces in     ###
### your code, for example with #ifdef			###

DEFINES	:= -DBPRE -DSOFTWARE_VERSION=0

### Flags to pass to your compilers, note       ###
### that our include directory is "include",    ###
### defined via -Iinclude if you wish to change ###
### it											###

ASFLAGS := -mthumb
CFLAGS	:= -mthumb -mthumb-interwork -g -mcpu=arm7tdmi -fno-inline -mlong-calls
CFLAGS	+= -march=armv4t -O0 -std=c99 -Wall -Wextra -Wunreachable-code
CFLAGS	+= -Iinclude $(DEFINES)
GRITFLAGS := -ftc -fa
LDFLAGS := -z muldefs

### Standard directories to put our files into  ###
### or take the source files from				###

BLDPATH	:= object
OUTPATH := build
SOURCEDIR := src
LINKER	:= linker.lsc
SYMBOLS := bpre.sym

PROJECT_NAME	:= YOUR_PROJECT

MAIN_OBJ	:= $(BLDPATH)/linked.o

### some commands to make enumerating files     ###
### a bit easier								###

rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

### lists of our source files, note that they   ###
### have to be given unique extensions			###
### .S/.s for ASM, .c for C files,              ###
### capitalization does matter here!			###

ASM_SRC_PP  := $(call rwildcard,src/,*.S)
ASM_SRC     := $(call rwildcard,src/,*.s)
C_SRC       := $(call rwildcard,src/,*.c)

ASM_OBJ_PP  := $(ASM_SRC_PP:%.S=$(BLDPATH)/%.o)
ASM_OBJ     := $(ASM_SRC:%.s=$(BLDPATH)/%.o)
C_OBJ       := $(C_SRC:%.c=$(BLDPATH)/%.o)

ALL_OBJ     := $(C_OBJ) $(ASM_OBJ_PP) $(ASM_OBJ)

### rules for making objects out of source      ###
### we use gcc for all of our compilation, as   ###
### it will call the assembler respectively     ###
### and can resolve preprocessor commands		###

$(BLDPATH)/%.o: %.c
	$(shell mkdir -p $(dir $@))
	$(CC) $(CFLAGS) -c $< -o $@

$(BLDPATH)/%.o: %.S
	$(shell mkdir -p $(dir $@))
	$(CC) $(CFLAGS) -c $< -o $@

$(BLDPATH)/%.o: %.s
	$(shell mkdir -p $(dir $@))
	$(AS) $(ASFLAGS) $< -o $@

### rules for building the whole project		###

all: rom

.PHONY: rom
rom: main.asm $(MAIN_OBJ)
	$(ARS) $<
	$(NM) $(BLDPATH)/linked.o -n -g --defined-only | \
		sed -e '{s/^/0x/g};{/.*\sA\s.*/d};{s/\sT\s/ /g}' > $(OUTPATH)/__symbols.sym
	@echo "*** SUCCESSFULLY BUILT PROJECT ***"

$(MAIN_OBJ): $(ALL_OBJ)
	$(LD) $(LDFLAGS) -T $(LINKER) -T $(SYMBOLS) --whole-archive -r -o $@ --start-group $^ --end-group

.PHONY: clean
clean:
	rm -f $(OUTPATH)/__symbols.sym $(OUTPATH)/build.gba
	rm -R -f object/*

.PHONY: run
run: rom
	$(VBA) "build/$(PROJECT_NAME).gba"