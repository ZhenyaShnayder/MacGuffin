DESIGN_NAME=key_setup
SRC_PATH=../../rtl

all: synth sim

# Design and testbench synthesis
synth:
	mkdir -p work
	iverilog -g2012 -o work/tb_$(DESIGN_NAME) $(SRC_PATH)/$(DESIGN_NAME).sv \
	$(SRC_PATH)/encryption.sv $(SRC_PATH)/Round.sv \
	$(SRC_PATH)/round_F.sv $(SRC_PATH)/P_box.sv \
	$(SRC_PATH)/S1.sv $(SRC_PATH)/S2.sv $(SRC_PATH)/S3.sv $(SRC_PATH)/S4.sv \
	$(SRC_PATH)/S5.sv $(SRC_PATH)/S6.sv $(SRC_PATH)/S7.sv $(SRC_PATH)/S8.sv \
	tb_$(DESIGN_NAME).sv

# Launch simulation
sim:
	./work/tb_$(DESIGN_NAME)

# Open waveform
wave:
	gtkwave work/wave.ocd \
		--rcvar 'fontname_signals Monospace 20' \
		--rcvar 'fontname_waves Monospace 20' \
		--rcvar 'scale_to_time_dimension n'

# Delete all artifacts
clean:
	rm -rf work
