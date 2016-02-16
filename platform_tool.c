#include <stdio.h>
#include <stdlib.h>
static const char *guts = "\n\
%define UNIX 0\n\
%define HAIKU 1\n\
%define WINDOWS 2\n\
%define PLATFORM "

#if defined(_WIN32)||defined(MSYS)||defined(__CYGWIN__)||defined(__MINGW32__)
	" WINDOWS"
#else
	" UNIX"
#endif

"\n\n";


int main(int argc, char *argv[]){
	const char *path = (argc>1)?argv[1]:"platform.inc";
	FILE *const file = fopen(path, "w");
	if(!file)
		return EXIT_FAILURE;
	
	fputs(guts, file);
	fclose(file);
	return EXIT_SUCCESS;
}
