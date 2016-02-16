:- module string_pool.
:- interface.

:- import_module medit_native, medit_algorithm.

:- type string_pool.

:- pred string_alloc(string_pool::di, string_pool::uo,
	size::in, external_string::uo) is det.
	
:- pred string_naive_alloc(string_pool::di, string_pool::uo,
	size::in, external_string::uo) is det.

:- pred string_dealloc(string_pool::di, string_pool::uo,
	external_string::di) is det.

:- pred string_dealloc(string_pool::di, string_pool::uo,
	external_string::di, size::in) is det.

%=============================================================================%
:- implementation. %----------------------------------------------------------%
%=============================================================================%

:- import_module list, int, pair.

:- type string_data ---> data(external_string, size).
:- type string_pool == list(string_data).

%=============================================================================%
%===  String searching predicate. Finds the best fit for a size in a Pool. ===%
%=============================================================================%
:- type search ---> found(index, size) ; none.
:- pred string_find(string_pool::di, string_pool::di, string_pool::uo, 
	index::in, size::in, search::in, search::out) is det.

% This is the nicer version to use.
:- pred string_find(string_pool::di, string_pool::uo,
	size::in, search::out) is det.
	
string_find([data(StrIn, SizeIn+0) | ListIn], List, ListOut, I, Size, none, Out) :-
	( if Size =< SizeIn+0
	  then X = found(I, SizeIn+0)
	  else X = none
	),
	string_find(ListIn, [ data(StrIn, SizeIn+0) | List ], ListOut, I+1, Size, X, Out).

string_find([data(StrIn, SizeIn+0) | ListIn], List, ListOut, I, Size, In, Out) :-
	In = found(_, SizeOld),
	( if Size =< SizeIn+0, SizeIn+0 < SizeOld
	  then X = found(I, SizeIn+0)
	  else X = In
	),
	string_find(ListIn, [ data(StrIn, SizeIn+0) | List ], ListOut, I+1, Size, X, Out).
	
string_find([], !List, _, _, !Found).

string_find(StringIn, StringOut, Size, Found) :-
	string_find(StringIn, [], StringOut, 0, Size, none, Found).

%=============================================================================%
%==== Outward facing allocators. Will always try to use existing strings. ====%
%=============================================================================%
string_dealloc(!Pool, Ext) :- string_dealloc(!Pool, Ext, 320).
string_dealloc(Pool, [ data(Str, Size) | Pool ], Str, Size).

string_naive_alloc([ data(Str, _) | Pool ], Pool, Size,
	external_realloc(Str, Size)).

string_alloc(!Pool, Size, String) :-
	string_find(!Pool, Size, Found),
	(
		Found = found(I, _),
		stitch_list(!Pool, I, data(String, _))
	;
		Found = none,
		string_naive_alloc(!Pool, Size, String)
	).
