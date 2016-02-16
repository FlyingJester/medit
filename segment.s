%define NUM_SEGMENT_LINES 32

STRUC TextSegment
  .next: resq 1
  .num resq 1
  .lines resq NUM_SEGMENT_LINES
ENDSTRUC

section .text
align 8

global TextSegmentLineCount
global TextSegmentStructSize
global TextSegmentLine
global SplitTextSegment

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextSegmentLineCount:
  mov rax,[rcx+TextSegment.num]
  ret
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextSegmentStructSize:
  mov rax,16+(NUM_SEGMENT_LINES*8)
  ret
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextSegmentLine:
  mov rax,rcx
  add rax,TextSegment.lines
  shl rdx,3
  add rax,rdx
  ret
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SplitTextSegment:
  ; Put S1's next into S2's next
  mov rax,[rcx+TextSegment.next]
  mov [rdx+TextSegment.next],rax

  ; Set S1's next to S2
  mov [rcx+TextSegment.next],rdx

  ; Clear S2's line count
  mov qword [rdx+TextSegment.num],0x0

  ; If there are more than 16 lines in S1, move all but 16 into S2.
  mov rax,[rcx+TextSegment.num]
  cmp rax,16
  jle done_transferring

  ; rax is counter
  sub rax,16
  mov [rdx+TextSegment.num],rax

  ; Update the line counts
  mov qword [rcx+TextSegment.num],0x0F
  mov [rdx+TextSegment.num],rax

  ; 128 is 16 * 8, the offset to the second half of S1's line list
  mov r15,rcx
  add r15,TextSegment.lines+128

  mov r14,rdx
  add r14,TextSegment.lines

 move_line:
  mov r13,[r15]
  mov [r14],r13

  dec rax
  cmp rax,0
  je done_transferring
  
  add r15,8
  add r14,8

  jmp move_line

 done_transferring:
  ret
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Returns whether or not outof is now empty, in which case into's next will
; be set to the same as outof's next.
; unsigned Concatenate(struct TextSegment *into, struct TextSegment *outof);
ConcatenateTextSegments:
  ; Calculate how many lines to move

  ; r15 is the number of lines in segment 1
  mov r15,[rcx+TextSegment.num]
  ; r13 is the number of lines in segment 2
  mov r13,[rdx+TextSegment.num]
  mov r11,r15
  add r11,r14
  mov r14,NUM_SEGMENT_LINES
  
  
  ; r14 also has the number of lines in segment 2
  ; mov r14,r13
  sub r11,r14
  ; If we can just move all lines, just move them.
  jle concat_move_lines
  sub r13,r11
  ; r13 must have the number of lines to move
 concat_move_lines:
 
 ; Update line counts.
  sub qword [rdx+TextSegment.num],r13
  add qword [rcx+TextSegment.num],r13
  ; Make r15 the first line to move in Segment 1
  shl r15,3
  add r15,TextSegment.lines
  add r15,rcx
  ; Make r14 the first line to move in Segment 1
  shl r14,3
  add r14,TextSegment.lines
  add r15,rcx
 concat_next_line:
  ; Move the lines.
  mov r11,[r14]
  mov qword [r14],0 ; zero out the old line. Just in case :)
  mov qword [r15],r11
  
  add r14,8
  add r15,8
  dec r13
  jnz concat_next_line
  
  mov rax,[rdx+TextSegment.num]
  ret
 ; return