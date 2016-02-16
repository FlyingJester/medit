
bits 64

%include "platform.inc"

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
  mov rax,[ARG1+TextSegment.num]
  ret
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextSegmentStructSize:
  mov rax,16+(NUM_SEGMENT_LINES*8)
  ret
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextSegmentLine:
  mov rax,ARG1
  add rax,TextSegment.lines
  shl ARG2,3
  add rax,ARG2
  ret
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SplitTextSegment:
  ; Put S1's next into S2's next
  mov rax,[ARG1+TextSegment.next]
  mov [ARG2+TextSegment.next],rax

  ; Set S1's next to S2
  mov [ARG1+TextSegment.next],ARG2

  ; Clear S2's line count
  mov qword [ARG2+TextSegment.num],0x0

  ; If there are more than 16 lines in S1, move all but 16 into S2.
  mov rax,[ARG1+TextSegment.num]
  cmp rax,16
  jle done_transferring

  ; rax is counter
  sub rax,16
  mov [ARG2+TextSegment.num],rax

  ; Update the line counts
  mov qword [ARG1+TextSegment.num],0x0F
  mov [ARG2+TextSegment.num],rax

  ; 128 is 16 * 8, the offset to the second half of S1's line list
  mov r15,ARG1
  add r15,TextSegment.lines+128

  mov r14,ARG2
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

  ; r8 is the number of lines in segment 1
  mov r8,[ARG1+TextSegment.num]
  ; r9 is the number of lines in segment 2
  mov r9,[ARG2+TextSegment.num]
  mov r11,r8
  add r11,r9 

  mov r10, r9
  ; r11 now equals (Seg1.num+Seg2.num) - NumSegments.
  sub r11,NUM_SEGMENT_LINES 
  ; If we can just move all lines, just move them.
  jle concat_move_lines
  
  ; Otherwise, subtract the difference from r10 (segment 2 num lines).
  sub r10,r11
  
  ; r10 must have the number of lines to move
 concat_move_lines:
 
 ; Update line counts.
  sub qword [ARG2+TextSegment.num],r10
  add qword [ARG1+TextSegment.num],r10
  ; Make r8 the first line to move in Segment 1
  shl r8,3
  add r8,TextSegment.lines
  add r8,ARG1
  ; Make r9 the first line to move in Segment 2
  shl r9,3
  add r9,TextSegment.lines
  add r9,ARG2
 concat_next_line:
  ; Move the lines.
  mov r11,[r9]
  mov qword [r9],0 ; zero out the old line. Just in case :)
  mov qword [r8],r11
  
  add r9,8
  add r8,8
  dec r10
  jnz concat_next_line
  
  mov rax,[ARG2+TextSegment.num]

  ret
 ; return
