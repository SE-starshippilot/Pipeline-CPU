TEST_INDEX = 1 2 3 4 5 6 7 8
compile: test_CPU.v
	iverilog -o result.out test_CPU.v