# use watcom's wmake
.ERASE

# Compiler flags:
#  -q   no banner
#  -wx  max warnings
#  -0   generate 8086 code
#  -ms  force small model (default)
#  -s   remove runtime stack checks (required)
#  -os  optimize for size
#  -zu  assume that SS != DS (required)
#  -ecc default to __cdecl calling convention (bad idea)
#
!ifdef __UNIX__
HOST_CC=cc
PDIR=./
X=
Q=\"
!else
HOST_CC=owcc
PDIR=
X=.exe
Q="
!endif


#SIGXP_OFFSET = 256
!ifdef MEMHOLE_SIZE
_SIG_FLAGS += -DMEMHOLE_SIZE=$(MEMHOLE_SIZE)
!endif
!ifdef SIGXP_OFFSET
_SIG_FLAGS += -DSIGXP_OFFSET=$(SIGXP_OFFSET)
!endif

CPU = 386

CFLAGS   = -q -0 -wx -zu -s -oas -d1+ -ms -fpi87
CFLAGS32 = -q -wx -zu -s -oas -d1+ -ms -nt=BIOS32 -nd=BIOS32
# -oat seems to prevent ENTER/LEAVE generation
#CFLAGS32 = -q -wx -zu -s -oat -d1+ -ms -nt=BIOS32 -nd=BIOS32

#DEFS = -DVBOX -DVBOX_LANBOOT_SEG=0xE200 -DVBOX_VERSION_STRING=$(Q)0.9$(Q) &
# -DVBOX_WITH_SCSI -DVBOX_BIOS_CPU=80386 -DIN_RC -DMSDOS
DEFS = &
	-DVBOX &
	-DVBOX_VERSION_STRING=$(Q)7.1$(Q) &
	-DVBOX_PC_BIOS &
	-DVBOX_LANBOOT_SEG=0xE200 &
	-DVBOX_WITH_SCSI &
 	-DVBOX_WITH_AHCI &
	-DVBOX_WITH_VIRTIO_SCSI &
	-DVBOX_BIOS_CPU=80386 &
	-DMSDOS &
	-DIN_RC &
	$(_SIG_FLAGS)


AFLAGS = -q -0 -wx

BCODEDIR=../../BiosCommonCode

INCLS  = -I$(Q)../../../../../include$(Q) -I$(Q)$(BCODEDIR)$(Q)


OBJS_1 = &
	post.obj &
	bios.obj &
	print.obj &
	ata.obj &
	floppy.obj &
	floppyt.obj &
	eltorito.obj &
	boot.obj &
	keyboard.obj &
	disk.obj &
	serial.obj &
	system.obj &
	invop.obj &
	timepci.obj &
	ps2mouse.obj &
	parallel.obj &
	logo.obj &
	scsi.obj &
	buslogic.obj &
	lsilogic.obj &
	__U4M.obj &
	__U4D.obj &
	__U8RS.obj &
	__U8LS.obj &
	fmemset.obj &
	fmemcpy.obj &
	

OBJS_2 = &
	apm.obj &
	virtio.obj &
	ahci.obj &
	pcibios.obj &
	pciutil.obj &
	vds.obj &
	pcibio32.obj &
	apm_pm.obj &
	pci32.obj &
	_smlcode.obj &
	orgs.obj

OBJS = &
	$(OBJS_1) &
	_memhole.obj &
	$(OBJS_2) &



LINK_ARGS = &
	name $@ system dos debug all option quiet &
	option nofarcalls, map, verbose, statics, symfile &
	option nodefaultlibs &
	output raw offset=0xF0000 order &
	clname DATA segaddr=0xF000 segment _DATA &
	clname CODE &
	segment _TEXT segaddr=0xF000 offset=0x1600 &
	segment BIOS32 segaddr=0xF000 offset=0xDA00 &
	segment BIOSSEG segaddr=0xF000 offset=0xE000 &
	file { $(OBJS) } &
	disable 1014, 1023, 1080, 2120



!if $(CPU) > 286
#OBJS += ahci.obj
#OBJS += pci32.obj
#DEFS += -DVBOX_WITH_AHCI
!endif

.c.obj : .autodepend
	wcc -fo=.obj $(CFLAGS) $(DEFS) $(INCLS) $<

.asm.obj : .autodepend
	wasm -fo=.obj $(AFLAGS) $(DEFS) $(INCLS) $<

vboxbios.rom : vboxbios.bin biossums$(X)
	$(PDIR)biossums$(X) vboxbios.bin $@

vboxbios.bin : $(OBJS) $(__MAKEFILES__)
	wlink $(LINK_ARGS)

biossums$(X): ../../../../bldprogs/biossums.c
	$(HOST_CC) -s -o $@ $(Q)../../../../bldprogs/biossums.c$(Q)

logo.obj : logo.c .autodepend
	wcc -fo=.obj $(INCLS) $(CFLAGS) $(DEFS) $<

pci32.obj : pci32.c .autodepend
	wcc386 -fo=.obj $(INCLS) $(DEFS) $(CFLAGS32) $<

__U4M.obj : $(BCODEDIR)/__U4M.asm
	wasm -fo=$@ $(AFLAGS) $(DEFS) $(INCLS) $<

__U4D.obj : $(BCODEDIR)/__U4D.asm
	wasm -fo=$@ $(AFLAGS) $(DEFS) $(INCLS) $<

__U8RS.obj : $(BCODEDIR)/__U8RS.asm
	wasm -fo=$@ $(AFLAGS) $(DEFS) $(INCLS) $<

__U8LS.obj : $(BCODEDIR)/__U8LS.asm
	wasm -fo=$@ $(AFLAGS) $(DEFS) $(INCLS) $<

fmemcpy.obj : $(BCODEDIR)/fmemcpy.asm
	wasm -fo=$@ $(AFLAGS) $(DEFS) $(INCLS) $<

fmemset.obj : $(BCODEDIR)/fmemset.asm
	wasm -fo=$@ $(AFLAGS) $(DEFS) $(INCLS) $<

ASMBitLastSetU16.obj : $(BCODEDIR)/ASMBitLastSetU16.asm
	wasm -fo=$@ $(AFLAGS) $(DEFS) $(INCLS) $<

# asm.h and uint32.h both require far data pointers by default. (use compact model)
DoUInt32Div.obj : $(BCODEDIR)/DoUInt32Div.c
	wcc -fo=$@ $(INCLS) -q -mc -0 -wx -zu -s -oas -d1+ -fpi87 $(DEFS) -DVBOX_PC_BIOS $<

clean : .symbolic
	@rm -f *.obj *.err
	@rm -f biossums$(X)
	@rm -f vboxbios.bin vboxbios.rom vboxbios.map vboxbios.sym
