MERCURY=mmc
MFLAGS=-E --linkage static --mercury-linkage static
ASM=yasm
ASMFLAGS=
ASMFLAGS=-f elf64
LINK=gcc

all: segment medit_mercury

medit_mercury: medit_algorithm.m medit_native.m string_pool.m
	$(MERCURY) $(MFLAGS) --make libstring_pool 

segment: segment.o test_segment.o
	$(LINK) -o test_segment segment.o test_segment.o -lc

segment.o: segment.s
	$(ASM) $(ASMFLAGS) segment.s

test_segment.o: test_segment.c segment.h
	gcc -Os -c test_segment.c -o test_segment.o

clean:
	rm *.o
	rm *.mh
	rm -rf Mercury
	rm test_segment
