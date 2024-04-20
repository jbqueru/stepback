# Whose notes are these

I am Jean-Baptiste "JBQ" "Djaybee" Quéru, original author of the
Vs Hive game, and these are my personal notes about the licensing
constraints associated with that code.
These notes might not (and probably do not) reflect the thoughts
of other people who might have been involved in the code you
received, whether they distributed it to you, modified it, or
contributed to my version. There's still a reasonable chance
that they don't entirely disagree with me, since they wouldn't
have been involved otherwise.

# Background

On the one hand, I understand that corporate creators of Open Source
Software might prefer the Apache 2.0 license, and that has influenced
me in the past into picking that license for my personal projects.

On the other hand, I now try to prefer the GPL family for my own
Open Source projects, because I believe that recipients and users
of software should be given the legal rights, technical means, and
necessary information, that they need in order to maintain that
software themselves.

I try to choose the most restrictive of the GPL variants when I
believe that the additional restrictions are relevant to the way
my code might be used.

# Details

While the GPL licenses are well designed for desktop environments,
with some good attempts at covering embedded cases and server cases,
I find them somewhat confusing in the case of retrocomputing, because
development and execution environments for retrocomputing aren't exact
matches for their desktop counterparts.
This document aims to clarify my interpretation of the GPL, to help
align my expectations with those of recipients of my software, though
the exact license text remains the ultimate binding one.

At the time of writing, the current versions of the GPL are LGPLv3,
GPLv3 and AGPLv3, which were orriginally published in 2007.
This document refers to those versions, and specifically to AGPLv3.

## Appropriate Legal Notices

It is understood that not all retrocomputing targets can reasonably
display **Appropriate Legal Notices** as defined in GPL.

As a rough guideline, targets with less than 32kB of total RAM will
rarely be expected to display such notices, while machines with 1MB
or more of total RAM will typically have no difficulty displaying
such notices.
Between those extremes, the choice will depend on the exact
characteristics of both the target and the actual program.

## Source Code and Preferred Form

The **source code** in its **preferred form** is specifically expected
to contain full revision history with meaningful fine-grained change
messages, typically in git or in something newer with similar capabilities.
Snapshots (a.k.a. tarballs) might be acceptable when their usage
is justified (e.g. to provide smaller downloads side-by-side with
full revision history).

The source code is expected to contain image files for graphics when
such files are used, and all design documentation including screen
layouts and timing calculations.

## Standard Interfaces

The Standard Interfaces might be the addresses of hardware registers
or the mechanisms to invoke BIOS or OS methods (e.g. the knowledge
that on Atari 2600, address `$1B` is the graphics for player 0, often
called `GRP0`, or that on Atari ST, `XBIOS $26` invokes a subroutine in
supervisor mode and is often called `Supexec`).

## Major Components and System Libraries

In the case of retrocomputing, **Major Components** also include actual
target hardware, BIOSes and OSes associated with such hardware (whether
stored in ROM or otherwise), emulators, assemblers and compilers used
to build retrocomputing applications, toolchain configuration files and
libraries for each target (even when distributed separately from other
tools,) and relevant packaging tools.

**System Libraries** include any common interface declaration files for
each target, e.g. files that declaring that `GRP0` is `$1B`, or that
`XBIOS` is `$E` while `Supexec` is `$26`.

## User Product

When the program is meant to be used in a public terminal, such as a
gaming cabinet installed in an amusement arcade, whether coin-operated
or not, the resulting terminal should be considered a **User Product**.

Additionally, using such a terminal will be considered a
**Remote Network Interaction**. While I realize that this is quite
a stretch from the letter of AGPLv3, it's also consistent with the
spirit of GPL in general where users of software must be allowed to
maintain it and modify it.

# In practice

In practice, it is expected that any user of the program can receive a
copy of the Corresponding Source, whether the usage happens on hardware
that the user owns or not. It is also expected that recipients of
tangible products including the program can replace the program with
their modified version.

Finally, as a matter of development practice, I try to reduce or
eliminate my code's reliance on external interface declarations and
prefer to recreate such declarations myself in a self-contained way.
I also try to reduce my code's reliance on BIOSes and OSes
associated with the target, though full elimination is not always
possible.
