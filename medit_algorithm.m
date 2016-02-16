:- module medit_algorithm.
:- interface.

:- import_module list.

:- type size == int.
:- type index == int.

	%==========================================================================
	% stitch_list(ListIn, ListOut, Index, Out)
	% Finds Index element of ListIn, returns that in Out, and returns the
	% remainder of ListIn in ListOut
	%
:- pred stitch_list(list(T)::di, list(T)::uo, index::in, T::uo) is det.

	%==========================================================================
	% stitch_list(ListIn, ListPrepend, ListOut, Index, Out)
	% Finds Index element of ListIn, returns that in Out, and returns the
	% remainder of ListIn prepeneded by ListPrepend in ListOut.
	% Mostly used to implement stitch_list/4.
	%
:- pred stitch_list(list(T)::di, list(T)::di, list(T)::uo,
	index::in, T::uo) is det.

%=============================================================================%
:- implementation. %----------------------------------------------------------%
%=============================================================================%

:- import_module int.
:- use_module require, exception.

%=============================================================================%
%======= Removes a specific index from a list, maintaining uniqueness. =======%
%=============================================================================%

stitch_list(PoolIn, PoolOut, I, Out) :- stitch_list(PoolIn, [], PoolOut, I, Out).
stitch_list([X | PoolIn], PoolMid, PoolOut, I, Out) :-
	( if I =< 0
	  then PoolOut = PoolIn, Out = X
	  else stitch_list(PoolIn, [ X | PoolMid ], PoolOut, I-1, Out)
	).

stitch_list([], !Pool, I, Out) :-
	require.error("Index out of range."),
	exception.throw(exception.software_error("Index out of range.")).

