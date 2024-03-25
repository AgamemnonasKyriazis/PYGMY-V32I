SHELL=/bin/bash

all:
	mkdir build;\
	cd build/;\
	mkdir synth;\
	mkdir synth/reports;\
	mkdir bit;\
	vivado -mode batch -nolog -nojournal -source ../build.tcl;\

clean:  
	rm -r build/;\
