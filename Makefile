SHELL=/bin/bash

flash:
	cd build/;\
	vivado -mode batch -nolog -nojournal -source ../flash.tcl;\

all:
	mkdir build;\
	cd build/;\
	mkdir synth;\
	mkdir synth/reports;\
	mkdir bit;\
	vivado -mode batch -nolog -nojournal -source ../build.tcl;\

clean:  
	rm -r build/;\
