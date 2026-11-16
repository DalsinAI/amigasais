/* The GFOS port's start: the stack, the version string and PROGDIR:User
 * (the settings, the saves and the high scores), made before main() so
 * PhysicsFS can make it the write directory.
 * Copyright (c) 2026 AmiCradle Team. GPL 3 or later, like SAIS GPL. */
#include <sys/stat.h>

/* A Shell gives 4 KB of stack; SDL 2 and the game want more. libnix's
 * startup sets this much up. */
unsigned long __stack = 256 * 1024;
static const char version[] __attribute__((used)) =
    "$VER: StrangeAdventures 1.7.0 (16.11.2026)";

static void __attribute__((constructor)) amiga_user_drawer(void)
{
	mkdir("PROGDIR:User", 0755);
}
