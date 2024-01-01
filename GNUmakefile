
ifdef MEMHOLE_SIZE
OPTARGS += "MEMHOLE_SIZE=$(MEMHOLE_SIZE)"
endif
ifdef SIGXP_OFFSET
OPTARGS += "SIGXP_OFFSET=$(SIGXP_OFFSET)"
endif

SRC_BIOS = src/VBox/Devices/PC/BIOS/

# workaround for Windows out of msys2
# (with mingw32-make)
ifeq ($(findstring mingw,$(MAKE)),mingw)
CP_P = copy /y
RM = del
SRC_BIOSD = $(subst /,$\\,$(SRC_BIOS))
else
CP_P = cp -p
RM = rm
SRC_BIOSD = $(SRC_BIOS)
endif

.PHONY : all vboxbios.rom rombios bios clean rebuild

all: vboxbios.rom

vboxbios.rom:
	@$(MAKE) -C $(SRC_BIOS) $(OPTARGS) $@
	$(CP_P) $(SRC_BIOSD)vboxbios.rom .
	$(CP_P) $(SRC_BIOSD)vboxbios.map .

rombios: vboxbios.rom

bios: vboxbios.rom

clean:
	@$(MAKE) -C $(SRC_BIOS) $(OPTARGS) $@
	-$(RM) vboxbios.rom
	-$(RM) vboxbios.map

rebuild:
	@$(MAKE) -C $(SRC_BIOS) $(OPTARGS) $@
	$(CP_P) $(SRC_BIOSD)vboxbios.rom .
	$(CP_P) $(SRC_BIOSD)vboxbios.map .

