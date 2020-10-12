ANSWERS := $(wildcard */*/answer_*.txt)
DAYS := $(wildcard */day_*)

all: ${DAYS}

${DAYS}:
	${MAKE} --directory=$@ --makefile=${PWD}/day.mak

clean:
	rm ${ANSWERS}

.PHONY: all clean ${DAYS}
