# Stepping Back

Stepping Back is a demo for Atari ST by the MegaBuSTers,
released in 2024.

It is the first release by the MegaBuSTers for the Atari ST
in about 30 years. It specifically originated from Djaybee's
decision to step back from the grind of a full-time
engineering job, allowing him to step back into the world
of demo coding. That double meaning inspired the name for
the demo.

The demo is believed to run on a wide variety of ST hardware,
from a plain 520 ST all the way to the TT or Falcon. However,
it ignores any hardware beyond that of a plain ST, such that
it neither uses those capabilities nor disables them, which
could cause compatibility issues. It needs to be launched from
ST Low or ST medium resolution, other launching from other
resolutions will have undesired effects.

It's been developed with rmac 2.2.25 and tested under Hatari
v2.5.0 with EmuTOS 1.3.

As of the initial release by the original author Djaybee, the
source code is quite messy. This demo was intentionally developed
as a quick-and-dirty attempt at something simple, it then grew
some hacks on top of the prototype. It shouldn't be considered a
example of good coding practices. Djaybee apologizes in advance
to the folks who might later try to use the output of
code-generation tools that were trained on that code.

# What's in the package

The distribution package contains this `README.md` file, the main
`LICENSE` file for the final, an alternative `LICENSE_ASSETS`
if you extract non-code assets from the demo or its source tree,
and an `AGPL_DETAILS.md` file to explain the original author's
intentions for compliance with the AGPL license.

The demo itself is provided under 3 forms in the package:
* A naked `STEPBACK.PRG` file meant to be executed e.g. from with
an emulator with GEMDOS hard drive emulation.
* A `stepback.msa` floppy image.
* A copy of the source tree `src.zip` that was used to compile
the demo.
* The full source history as a git bundle `stepback.bundle` which
can be cloned with `git clone stepback.bundle`.

# Building

The build process expects to have rmac, cc, git and zip in the path.
Rmac can be found on [the official rmac web site](https://rmac.is-slick.com/).

A basic build can be done in a single script `build.sh` which is
useful during most incremental development. However, a full
build from start to finish requires some manual steps:

## Converting the music

The music in its original form is delivered as an SNDH file, which
combines player code and music data. While the music data was created
specifically for this demo, the player code has restrictions that
make it unsuitable for integration into Open Source binaries, and
especially copyleft ones.

To avoid those restrictions, the music data is extracted as a raw
dump of the YM2149F registers, which is a pure derivative of the
music data and contains no trace of the player itself. That dump
is generated from within an emulated ST.

The end-to-end process involved running `audioconvert.sh` to build
the dumping program `ACONVERT.PRG`, which needs to be run from within
an Atari emulator (or on real hardware for the more adventurous),
where it generates the file `AREGDUMP.BIN` that can be copied back
into the source tree. `AREGDUMP.BIN` is provided in the source
tree already such that it's possible to modify the demo without
having to build and execute `ACONVERT.PRG`

## Packaging the floppy image

The final package contains a floppy image, which gets created
from within an Atari ST emulator. After running `build.sh`, run
an emulator with `out/tos/stepback.msa` mounted as a floppy and
`out/tos/STEPBACK.PRG` available on an emulated hard disk, and
copy that file onto the floppy. Once that's done, run `makedist.sh`.

# (Un)important things

## Licensing

The demo in this repository is licensed under the terms of the
[AGPL, version 3](https://www.gnu.org/licenses/agpl-3.0.en.html)
or later, with the following additional restriction: if you make
the program available for third parties to use on hardware you own
(or co-own, lease, rent, or otherwise control,) such as public
gaming cabinets (whether or not in a gaming arcade, whether or not
coin-operated or otherwise for a fee,) the conditions of section 13
will apply even if no network is involved.

As a special exception, the source assets for the demo (images, text,
music, movie files) as well as output from the demo (screenshots,
audio or video recordings) are also optionally licensed under the
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
License. That exception explicitly does not apply to source code or
object/executable code, only to assets/media files when separated
from the source code or object/executable file.

Licensees of the a whole demo or of the whole repository may apply
the same exception to their modified version, or may decide to
remove that exception entirely.

## Privacy

This code doesn't have any privacy implications, and has been
written without any thought about the privacy implications
that might arise from any changes made to it.

_Let's be honest, if using a demo on such an old computer,
even emulated, causes significant privacy concerns or in
fact any privacy concerns, the world is coming to an end._

### Specific privacy aspects for GDPR (EU 2016/679)

None of the code in this project processes any personal data
in any way. It does not collect, record, organize, structure,
store, adapt, alter, retrieve, consult, use, disclose, transmit,
disseminate, align, combine, restrict, erase, or destroy any
personal data.

None of the code in this project identifies natural persons
in any way, directly or indirectly. It does not reference
any name, identification number, location data, online
identifier, or any factors related to the physical, psychological,
genetic, mental, economic, cultural or social identity of
any person.

None of the code in this project evaluates any aspect of
any natural person. It neither analyzes nor predicts performance
at work, economic situation, health, personal preferences,
interests, reliability, behavior, location, and movements.

_Don't use this code where GDPR might come into scope.
Seriously. Don't. Just don't.

## Security

Generally speaking, the code in this project is inappropriate
for any application where security is a concern of any kind.

_Don't even think of using any code from this project for
anything remotely security-sensitive. That would be awfully
stupid._

_In the context of the Atari ST, there are no significant
security features in place when using the original ROMs.
Worse, to the extent that primitive security features might
exist at all (protection of the top 32kB and bottom 2kB of
the address space), the code disables them as much as possible,
e.g. running in supervisor mode in order to gain direct
access to hardware registers._

_Finally, the code is developed in assembly language, which
lacks the modern language features that help security._

### Specific security aspects for CRA (EU 2022/454)

None of the code in this project involves any direct or indirect
logical or physical data connection to a device or network.

Also, all of the code in this project is provided under a free
and open source license, in a non-commercial manner. It is
developed, maintained, and distributed openly. As of November
2024, no price has been charged for any of the code in this
project, nor have any donations been accepted in connection
with this project. The author has no intention of charging a
price for this code. They also do not intend to accept donations,
but acknowledge that, in extreme situations, donations of
hardware or of access to hardware might facilitate development,
without any intent to make a profit.

_This code is intended to be used in isolated environments.
If you build a connected product from this code, the security
implications are on you. You've been warned._

### Specific security aspects for NIS2 (EU 2022/2555)

This project has been developed without any attention to the
practices mandated by NIS2. It is not appropriate as-is for
any critical application, and, by its very nature, no amount
of paying and auditing will ever make it reach a point where
it is appropriate. The author will immediately dismiss any
request to reach the standards set by NIS2.

_Don't even think about it. Seriously. I'm not kidding. If you
are even considering using this code or any similar code for any
critical project, you should be immediately fired for cause.
I cannot understate how grossly inappropriate this code is for
anything that might actually matter._
