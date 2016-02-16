:- module medit_native.
:- interface.

:- type external_string.

:- func external_alloc(int::in) = (external_string::uo) is det.
:- pred external_free(external_string::di) is det.
:- func external_realloc(external_string::di, int::in) =
	(external_string::uo) is det.

%=============================================================================%
:- implementation. %----------------------------------------------------------%
%=============================================================================%

%=============================================================================%
%=======  Native allocator wrappers. Used mainly for resizing strings. =======%
%=============================================================================%

:- pragma foreign_decl("C", "#include <stdlib.h>").
:- pragma foreign_type("C", external_string, "void*").

:- pragma foreign_proc("C", external_alloc(N::in) = (Out::uo),
	[will_not_call_mercury, promise_pure],
	"{ Out = malloc(N); }").
	
:- pragma foreign_proc("C", external_realloc(X::di, N::in) = (Out::uo),
	[will_not_call_mercury, promise_pure],
	"{ Out = realloc(X, N); }").
	
:- pragma foreign_proc("C", external_free(X::di),
	[will_not_call_mercury, promise_pure],
	"{ free(X); }").