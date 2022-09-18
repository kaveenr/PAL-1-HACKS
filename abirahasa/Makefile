PLATFORM=KIM1

all: assemble ptp clean

assemble:
	ca65 -g -l abirahasa.lst abirahasa.s
	ld65 -t none -vm -m abirahasa.map -o abirahasa.bin abirahasa.o

ptp: assemble
	srec_cat abirahasa.bin -binary -offset 0x0200 -o ../abirahasa.ptp -MOS_Technologies -CRLF

clean:
	$(RM) abirahasa.o abirahasa.map abirahasa.bin