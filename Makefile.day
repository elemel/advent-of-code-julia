all: answer_1.txt answer_2.txt

answer_1.txt: part_1.jl input.txt
	julia part_1.jl < input.txt > answer_1.txt

answer_2.txt: part_2.jl input.txt
	julia part_2.jl < input.txt > answer_2.txt

.PHONY: all
