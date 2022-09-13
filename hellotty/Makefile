PLATFORM=KIM1

all: assemble ptp clean

assemble:
	ca65 -g -l hellotty.lst hellotty.s
	ld65 -t none -vm -m hellotty.map -o hellotty.bin hellotty.o

ptp: assemble
	srec_cat hellotty.bin -binary -offset 0x0200 -o ../hellotty.ptp -MOS_Technologies -CRLF

clean:
	$(RM) hellotty.o hellotty.map hellotty.bin