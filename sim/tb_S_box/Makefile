SRC_PATH=../../rtl

all: synth sim

# Design and testbench synthesis
synth:
	mkdir -p work
	iverilog -g2012 -o work/tb_Sn $(SRC_PATH)/S1.sv $(SRC_PATH)/S2.sv \
		$(SRC_PATH)/S3.sv $(SRC_PATH)/S4.sv $(SRC_PATH)/S5.sv \
		$(SRC_PATH)/S6.sv $(SRC_PATH)/S7.sv $(SRC_PATH)/S8.sv tb_Sn.sv

# Launch simulation
sim:
	./work/tb_Sn

# Open waveform
wave:
	gtkwave work/wave.ocd \
		--rcvar 'fontname_signals Monospace 20' \
		--rcvar 'fontname_waves Monospace 20' \
		--rcvar 'scale_to_time_dimension n'

# Delete all artifacts
clean:
	rm -rf work
