MEdit
=====

A slightly crazy text editing library
-------------------------------------

What is MEdit?
--------------

MEdit is a library implementing the underlying features of a text editor. It
is intended to be useful both for implementing a command-line editor and for a
GUI editor with the use of an external toolkit.

Why is it crazy?
----------------

MEdit is written in a mixture of Mercury and Assembly (with a small amount of
glue in C). Mercury is a purely declarative, pure functional logic langauge.
Assembly is assembly. I chose Mercury because a number of operations can be
expressed nicely with pure declarative syntax, such as text insertion and
deletion, undo/redo, and cursor management. But functional languages tend to
either be inefficient or cumbersome when it comes to memory management, and so
I decided to perform the basic memory management (particularly with regards to
text buffers) in a native language. I chose Assembly for two reasons. One, for
the fun, and two because only low level languages seem to really be suited to
the task.

How do I use it?
----------------

It's not ready :) You can try it out by building it first. You will need the
Mercury compiler, at least version 14 (although there is a bug in the HLC grade
for MMC 14 that MEdit hits), and yasm or nasm. Build the library, then check
out the *.mh files for the API.

I'll add doxygen or pandoc someday. But it's not in a stable state to
meaningfully document yet.
