PLATFORM=KIM1

all: assemble ptp clean

assemble:
	ca65 -g -l abirahasa.lst abirahasa.s
	ld65 -t none -vm -m abirahasa.map -o abirahasa.bin abirahasa.o
	ca65 -g -l story1.lst story1.s
	ld65 -t none -vm -m story1.map -o story1.bin story1.o

ptp: assemble
	srec_cat abirahasa.bin -binary -offset 0x0200 -o ../abirahasa.ptp -MOS_Technologies -CRLF
	srec_cat story1.bin -binary -offset 0x1000 -o ../abirahasa_story1.ptp -MOS_Technologies -CRLF

clean:
	$(RM) abirahasa.o abirahasa.map abirahasa.bin
	$(RM) story1.o story1.map story1.bin story1.lst