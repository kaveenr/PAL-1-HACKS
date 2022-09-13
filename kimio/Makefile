PLATFORM=KIM1

all: assemble ptp clean

assemble:
	ca65 -g -l kimio.lst kimio.s
	ld65 -t none -vm -m kimio.map -o kimio.bin kimio.o

ptp: assemble
	srec_cat kimio.bin -binary -offset 0x0200 -o ../kimio.ptp -MOS_Technologies -CRLF

clean:
	$(RM) kimio.o kimio.map kimio.bin