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

It's been developed and tested under Hatari v2.5.0 with
EmuTOS 1.3.

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

## Privacy (including GDPR)

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

_Let's be honest, if using a demo on such an old computer,
even emulated, causes significant privacy concerns or in
fact any privacy concerns, the world is coming to an end._

## Security (including CRA)

None of the code in this project involves any direct or indirect
logical or physical data connection to a device or network.

Also, all of the code in this project is provided under a free
and open source license, in a non-commercial manner. It is
developed, maintained, and distributed openly. As of September
2024, no price has been charged for any of the code in this
project, nor have any donations been accepted in connection
with this project. The author has no intention of charging a
price for this code. They also do not intend to accept donations,
but acknowledge that, in extreme situations, donations of
hardware or of access to hardware might facilitate development,
without any intent to make a profit.

_Don't even think of using any code from this project for
anything remotely security-sensitive. That would be awfully
stupid.
In the context of the Atari ST, there are no significant
security features in place when using the original ROMs.
Worse, to the extent that primitive security features might
exist at all, the code disables them as much as possible,
e.g. running in supervisor mode in order to gain direct
access to hardware registers.
Finally, the code is developed in assembly language, which
lacks the modern language features that help security._
