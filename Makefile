.PHONY: clean doc test

all: doc test

clean:
	rm -rf doc/

doc:
	fenneldoc iter.fnl

test:
	fennel tests/unit.fnl
