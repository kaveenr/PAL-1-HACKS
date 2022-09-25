PLATFORM=KIM1

all: assemble ptp clean

assemble:
	ca65 -g -l paltimer.lst paltimer.s
	ld65 -t none -vm -m paltimer.map -o paltimer.bin paltimer.o

ptp: assemble
	srec_cat paltimer.bin -binary -offset 0x0200 -o ../paltimer.ptp -MOS_Technologies -CRLF

clean:
	$(RM) paltimer.o paltimer.map paltimer.bin