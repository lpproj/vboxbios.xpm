ifdef MEMHOLE_SIZE
OPTARGS += "MEMHOLE_SIZE=$(MEMHOLE_SIZE)"
endif
ifdef SIGXP_OFFSET
OPTARGS += "SIGXP_OFFSET=$(SIGXP_OFFSET)"
endif

WMAKE_CMD = wmake -h $(OPTARGS)

.PHONY : all vboxbios.rom rombios bios clean rebuild

all: vboxbios.rom

vboxbios.rom:
	$(WMAKE_CMD) $@

rombios: vboxbios.rom
	$(WMAKE_CMD) $(subst rombios,$(empty),$@) vboxbios.rom

bios: vboxbios.rom
	$(WMAKE_CMD) $(subst bios,$(empty),$@) vboxbios.rom

clean:
	$(WMAKE_CMD) $@

rebuild:
	$(WMAKE_CMD) $(subst rebuild,$(empty),$@) clean vboxbios.rom

