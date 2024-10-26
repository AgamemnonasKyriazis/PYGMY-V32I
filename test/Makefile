test:
	iverilog top_tb.v ../rtl/*.v -I ../rtl/
	./a.out
	GDK_BACKEND=x11 gtkwave top_tb.vcd

clean:
	rm -f a.out