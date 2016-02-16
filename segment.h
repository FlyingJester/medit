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

#ifdef __cplusplus
}
#endif
