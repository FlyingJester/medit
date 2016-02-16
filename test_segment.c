#include "segment.h"
#include <stdio.h>
#include <stdlib.h>

struct TextSegment;
char *TextSegmentLine(struct TextSegment*, unsigned line);

#define SEGMENT_TEST(SEG, LINE)\
	printf("Segment at %p, line %i is at %p.\n", SEG, LINE, TextSegmentLine(SEG, LINE))

int main(int argc, char *argv[]){
	struct TextSegment *seg1 = (void*)0, *seg2 = (void*)216216216;
	SEGMENT_TEST(seg1, 0);
	SEGMENT_TEST(seg1, 8);
	SEGMENT_TEST(seg1, 9);
	SEGMENT_TEST(seg2, 0);
	SEGMENT_TEST(seg2, 1);
	SEGMENT_TEST(seg2, 2);
	SEGMENT_TEST(seg2, 3);
	SEGMENT_TEST(seg2, 7);
	
	printf("Segment size is %i\n", TextSegmentStructSize());

	seg1 = calloc(1, TextSegmentStructSize());
	seg2 = calloc(1, TextSegmentStructSize());

	printf("Line counts: %i, %i\n", TextSegmentLineCount(seg1), TextSegmentLineCount(seg2));

	

}

/*
000000000000005c t 
0000000000000075 t 
000000000000001c T SplitTextSegment
000000000000000d T TextSegmentLine
0000000000000000 T TextSegmentLineCount
0000000000000005 T TextSegmentStructSize
*/

