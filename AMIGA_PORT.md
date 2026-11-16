Strange Adventures in Infinite Space for GFOS
=============================================

A port of SAIS GPL 1.7.0, Christopher Collins's GPL release of Digital
Eel's Strange Adventures in Infinite Space (Richard Carlson, Iikka
Keranen and William Sears, 2002), from https://github.com/kuroneko/sais
at commit 5efa77ccc3b7ac04d3ba809911df480a5d6f226e, for GFOS: AmigaOS 3.2
with GFOpenUp, on a 68040 or 68060 with an FPU, on GFOpenGPU's SDL 2.

Take a small starship out into a galaxy of a few dozen stars, find alien
relics and new crew, trade, fight, and get home before the time runs out.
A whole game takes about half an hour.

Status: written for Cradle's os32-gcc16-open6 stove; not yet run in a lab.


What you need
-------------

- GFOS: AmigaOS 3.2 with GFOpenUp and its GFOpenGPU part, which installs
  LIBS:GFOpenGPU/SDL2.module and SDL2_mixer.module, LIBS:physfs.library
  and LIBS:z.library.
- A 68040 or 68060 with an FPU (not an LC040 or EC040), an RTG screen that
  shows 640 x 480 (or the AmiCradle lab), about 6 MB of free memory and
  18 MB on disk.
- Nothing else: the game data is in the drawer.


How to play
-----------

On GFOS: GFOpenUpTool INSTALL Parts/StrangeAdventures puts the game in
SYS:Games/StrangeAdventures. From the archive: run
Install-StrangeAdventures (or copy the StrangeAdventures drawer where you
want it). Then double-click StrangeAdventures. The mouse does everything;
the Manual in the drawer explains the game.

The settings, the saved game and the high scores are kept in the drawer's
User drawer; the Installer keeps it on an update and GFOpenUp never
touches it. Mods go in the drawer's mods drawer (Mods.txt says how).


Building
--------

    make -f amiga/Makefile.amigaos -j4 STOVE=/path/to/os32-gcc16-open6

or, in Cradle, stove_build with the os32-gcc16-open6 stove and target
package (package/build-amiga.sh), which also makes the GFOpenUp part
(Parts/StrangeAdventures) and packs StrangeAdventures-VERSION-68040.lha.
tests/test_part.sh checks the part on the host.


What was changed
----------------

- src/sdl_main.c: on GFOS, PhysicsFS reads the game's drawer and writes to
  its User drawer (upstream's "sane config" would write saves beside the
  data, where an update replaces them); the window asks for no OpenGL and
  the renderer for no acceleration, so SDL's software renderer draws it.
- amiga/: the start (stack, $VER, the User drawer), the Makefile, the
  Installer spec (amicradle scripts/ports/port_installer.py) and the
  GlowIcons (scripts/ports/port_icons.py, from art/sais.svg).
- amiga/physfs/: physfs.library's header and the stub that opens it, from
  DalsinAI/gfopenphysfs d3a0ad78 (the stove's kit has no PhysicsFS yet);
  PhysicsFS itself runs in LIBS:physfs.library.
- package/ and tools/: the stove build, the GFOpenUp part and the archive.
- Nothing else of upstream's: its data loaders already read little-endian
  files byte by byte, so they work on the 68k as they are.


Licences
--------

The program is GPL 3 (COPYING.md). The game data is Digital Eel's,
redistributed with their permission under Creative Commons
Attribution-NonCommercial 4.0 (Licences.txt). The Amiga files are The
AmiCradle Team's, GPL 3 or later like the game (the packing tools MIT).

Designed, tested and delivered by The AmiCradle Team.
