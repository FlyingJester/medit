#include "segment.h"
#include <stdio.h>
#include <stdlib.h>

struct TextSegment;
char *TextSegmentLine(struct TextSegment*, unsigned line);

#define SEGMENT_TEST(SEG, LINE)\
	printf("Segment at %p, line %i is at %p.\n", SEG, LINE, TextSegmentLine(SEG, LINE))

int main(int argc, char *argv[]){
	struct TextSegment *seg1 = NULL, *seg2 = (void*)216216216;
	
	printf("Segment size is %i\n", TextSegmentStructSize());

	seg1 = calloc(1, TextSegmentStructSize());
	seg2 = calloc(1, TextSegmentStructSize());

	SEGMENT_TEST(seg1, 0);
	SEGMENT_TEST(seg1, 8);
	SEGMENT_TEST(seg1, 9);
	SEGMENT_TEST(seg2, 0);
	SEGMENT_TEST(seg2, 1);
	SEGMENT_TEST(seg2, 2);
	SEGMENT_TEST(seg2, 3);
	SEGMENT_TEST(seg2, 7);

	printf("Line counts (should be 0, 0): %i, %i\n", TextSegmentLineCount(seg1), TextSegmentLineCount(seg2));

	TextSegmentAddLine(seg1, NULL);
	
	TextSegmentAddLine(seg2, (char*)0xDEADBEEF);
	TextSegmentAddLine(seg2, (char*)0xABCDEF);
	
	printf("Line counts (should be 1, 2): %i, %i\n", TextSegmentLineCount(seg1), TextSegmentLineCount(seg2));


	printf("Line positions (should be *, 0xDEADBEEF, 0xABCDEF): %p, %p, %p\n", seg2, TextSegmentLine(seg2, 0), TextSegmentLine(seg2, 1));

	{
		int i = 0; 
		do{
			printf("Line test: %p\n", TextSegmentLine(seg2, i));
		}while(++i < 32);
	}
}

/*
unsigned ConcatenateTextSegments(struct TextSegment *into, struct TextSegment *outof);
unsigned TextSegmentLineCount(const struct TextSegment *);
unsigned TextSegmentStructSize();
unsigned TextSegmentAddLine(struct TextSegment *to, char *line);
unsigned TextSegmentInsertLine(struct TextSegment *to, char *line, unsigned at);
*/

