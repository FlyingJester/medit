MERCURY?=mmc
MFLAGS?=-E --linkage static --mercury-linkage static
ASM?=yasm
ASMFLAGS?=-f elf64
CC?=gcc
LINK?=gcc
PLATFORM=

all: segment medit_mercury

medit_mercury: medit_algorithm.m medit_native.m string_pool.m
	$(MERCURY) $(MFLAGS) --make libstring_pool

platform_tool: platform_tool.c
	$(CC) platform_tool.c -o platform_tool

platform_inc: platform_tool
	./platform_tool platform_autogen.inc

segment: segment.o test_segment.o
	$(LINK) -o test_segment segment.o test_segment.o -lc

segment.o: segment.s platform.inc platform_inc
	$(ASM) $(ASMFLAGS) segment.s -o segment.o

test_segment.o: test_segment.c segment.h
	$(CC) -Os -c test_segment.c -o test_segment.o

clean:
	rm *.o
	rm *.mh
	rm -rf Mercury
	rm test_segment
