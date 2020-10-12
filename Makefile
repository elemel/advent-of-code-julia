DAYS := $(wildcard */day_*)
ANSWERS := $(wildcard */*/answer_*.txt)

all: ${DAYS}

${DAYS}:
	${MAKE} --directory=$@ --makefile=${PWD}/Makefile.day

clean:
	rm ${ANSWERS}

.PHONY: all clean ${DAYS}
