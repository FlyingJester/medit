%include "platform_autogen.inc"

%if PLATFORM == WINDOWS
  %define ARG1 rcx
  %define ARG2 rdx
  %define ARG3 r8
  %define ARG4 r9
%else
  %define ARG1 rdi
  %define ARG2 rsi
  %define ARG3 rcx
  %define ARG4 rdx
%endif
