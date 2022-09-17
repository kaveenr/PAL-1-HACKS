PLATFORM=KIM1

all: assemble ptp clean

assemble:
	ca65 -g -l gametty.lst gametty.s
	ld65 -t none -vm -m gametty.map -o gametty.bin gametty.o

ptp: assemble
	srec_cat gametty.bin -binary -offset 0x0200 -o ../gametty.ptp -MOS_Technologies -CRLF

clean:
	$(RM) gametty.o gametty.map gametty.bin