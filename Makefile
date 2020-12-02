PARTS := $(wildcard */*/part_*.jl)
ANSWERS_1 := $(patsubst %/part_1.jl,%/answer_1.txt,${PARTS})
ANSWERS := $(patsubst %/part_2.jl,%/answer_2.txt,${ANSWERS_1})

all: ${ANSWERS}

2019/%/answer_1.txt: 2019/%/part_1.jl 2019/%/input.txt 2019/Intcode.jl Julmust.jl
	julia 2019/$*/part_1.jl < 2019/$*/input.txt > $@

2019/%/answer_2.txt: 2019/%/part_2.jl 2019/%/input.txt 2019/Intcode.jl Julmust.jl
	julia 2019/$*/part_2.jl < 2019/$*/input.txt > $@

2020/%/answer_1.txt: 2020/%/part_1.jl 2020/%/input.txt Julmust.jl
	julia 2020/$*/part_1.jl < 2020/$*/input.txt > $@

2020/%/answer_2.txt: 2020/%/part_2.jl 2020/%/input.txt Julmust.jl
	julia 2020/$*/part_2.jl < 2020/$*/input.txt > $@

clean:
	rm -f ${ANSWERS}

.DELETE_ON_ERROR:
.PHONY: all clean
