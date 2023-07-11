CFLAGS	= -O4 -pedantic -Wall -Wno-misleading-indentation
LDFLAGS	= -lm -ljasper -ljpeg -llcms2

dcraw:	dcraw.o

debug:	dcraw.c
	gcc -ggdb3 -O0 -o dcraw_debug dcraw.c -Wno-misleading-indentation -lm -ljasper -ljpeg -llcms2

timing: dcraw-timing.c
	gcc -O3 -o dcraw_timing dcraw-timing.c -Wno-misleading-indentation -lm -ljasper -ljpeg -llcms2
