#pragma once

#ifdef __cplusplus
extern "C" {
#endif

struct TextSegment;
char *TextSegmentLine(struct TextSegment*, unsigned line);

void SplitTextSegment(struct TextSegment *from, struct TextSegment *other);

/* Returns whether or not outof is now empty, in which case into's next will
 * be set to the same as outof's next.
 */
unsigned ConcatenateTextSegments(struct TextSegment *into, struct TextSegment *outof);

unsigned TextSegmentLineCount(const struct TextSegment *);
unsigned TextSegmentStructSize();

/* Returns a 1-indexed position where the line was positioned, or 0 if there
 * is not enough room.
 */
unsigned TextSegmentAddLine(struct TextSegment *to, char *line);
unsigned TextSegmentInsertLine(struct TextSegment *to, char *line, unsigned at);

#ifdef __cplusplus
}
#endif
