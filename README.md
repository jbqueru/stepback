# Djaybee's 40th

A collection of little demos to celebrate Djaybee's 40th code-versary

# Background

I started programming in 1984, and I am using 2024 to celebrate 40 years
of coding experience.

This chapter explains how I started, which now guides how I intend to
celebreate.

### The BASIC beginnings

Back in 1984, I was 10 years old, living in France.
My family was not into computers, the closest we had was a
[Philips Videopac (a.k.a. Magnavox
Odyssey<sup>2</sup>)](https://en.wikipedia.org/wiki/Magnavox_Odyssey_2)
in the early 80s; we did have the Computer Intro / Computer Programmer
cartridge, and I remember typing some of the listings from the manual, 
but I couldn't grok it enough to write my own code.

I guess 1984 was a turning point in computing.
The world of games was still reeling from the
[video game crash of 1983](https://en.wikipedia.org/wiki/Video_game_crash_of_1983),
and no new consoles were released in 1984; the closest ended up being
the [Atari 7800](https://en.wikipedia.org/wiki/Atari_7800), which
got announced in 1984, but the collapse of Atari delayed its launch
until 1986.
1984 also saw the switch of high-end personal computers to 16-bit,
with the [Apple Macintosh](https://en.wikipedia.org/wiki/Macintosh_128K)
and the [IBM PC/AT](https://en.wikipedia.org/wiki/IBM_Personal_Computer_AT).

For me more specifically, 1984 was the release of the
[Amstrad CPC](https://en.wikipedia.org/wiki/Amstrad_CPC), arguably the
swan song of 8-bit computing, in an environment where French leaders
mistakenly believed that the switch to digital would imply that most
computer users would be programmers. I that environment, I got my hands
on a loaner CPC for a couple of months, and I taught myself some
[BASIC](https://en.wikipedia.org/wiki/Locomotive_BASIC) programming.

I got a loaner [TI 99/4A](https://en.wikipedia.org/wiki/TI-99/4A)
before my family bought our own CPC, our first computer. I quickly
realized that BASIC was not enough to rival commercial games,
and I learned of a mythical "assembly" language that was much faster
than BASIC. I eventually managed to import some assembly documentation
from England (this was way before anything was available online) and
did put together a few assembly instructions, but the lack of tools
and guidance made me hit a wall.

Somewhere along the way, I also used the
[Thomson MO5](https://en.wikipedia.org/wiki/Thomson_MO5) in school,
still in BASIC.

### 68000 and assembly

In 1989, we got an [Atari ST](https://en.wikipedia.org/wiki/Atari_ST).
Back to BASIC I went, using
[GFA BASIC 2 and 3](https://en.wikipedia.org/wiki/GFA_BASIC),
[STOS BASIC](https://en.wikipedia.org/wiki/STOS_BASIC) and even a French
oddity called BASIC 1000D. 
Mostly, though, in late 1990, through an unlikely chain of
relationships, a friend taught me assembly for the
[68000](https://en.wikipedia.org/wiki/Motorola_68000) and I never looked
back. I coded for the Atari ST (including the STE variant), as well as the
[Falcon](https://en.wikipedia.org/wiki/Atari_Falcon) (I even pushed to its
[FPU](https://en.wikipedia.org/wiki/Motorola_68881)
but never touched its [DSP](https://en.wikipedia.org/wiki/Motorola_56000)).

My work on the Atari ST was part of the
[MegaBusters](https://demozoo.org/groups/8210/) demo crew, where I
picked the name _Djaybee_. I look back at that time, proud of what
I had been able to achieve without formal training, but also proud
of how much better I've become since then.

I estimate that I wrote about 100,000 lines of assembly during that
period.

### Turning professional

At some point beyond that, I started to use computers with operating
systems that mostly hid the hardware from me, and I lost contact with
that kind of programming, I made the mistake of never diving into
[OpenGL](https://en.wikipedia.org/wiki/OpenGL) enough, the last times
I played with such methods of programming were with
[BeOS](https://en.wikipedia.org/wiki/BeOS)' `BWindowScreen` and
`BDirectWindow` APIs.

### Other things I've seen

Along that path, my family did own a
[Sega Mega Drive](https://en.wikipedia.org/wiki/Sega_Genesis) (with
the Power Base Converter to play Master System games), a [Nintendo
Super NES](https://en.wikipedia.org/wiki/Super_Nintendo_Entertainment_System),
a pair of [Atari Lynx](https://en.wikipedia.org/wiki/Atari_Lynx)
that I still have to this day,
an [Atari 7800](https://en.wikipedia.org/wiki/Atari_7800) toward the
end of its life,
even an [Atari Jaguar](https://en.wikipedia.org/wiki/Atari_Jaguar).
You could say that I was a hardcore Atari fan-boy.

I'm pretty sure that I did get to see a few other machines, that I
did not own:
[Intellivision](https://en.wikipedia.org/wiki/Intellivision),
[ColecoVision](https://en.wikipedia.org/wiki/ColecoVision),
[Vectrex](https://en.wikipedia.org/wiki/Vectrex),
[ZX81](https://en.wikipedia.org/wiki/ZX81),
[Thomson MO5](https://en.wikipedia.org/wiki/Thomson_MO5),
[Amiga 500](https://en.wikipedia.org/wiki/Amiga_500) and
[600](https://en.wikipedia.org/wiki/Amiga_600),
and I know I've seen a few other machines in passing,
[Matra Alice (a TRS-80 clone)](https://en.wikipedia.org/wiki/Matra_Alice),
[ZX Spectrum](https://en.wikipedia.org/wiki/ZX_Spectrum),
[Commodore 64](https://en.wikipedia.org/wiki/Commodore_64),
[Apple IIc](https://en.wikipedia.org/wiki/Apple_IIc).

### Fast-forward to 2024

In 1998-99, I relocated from Europe to the USA, since that's where
I had been able to find a first job. I initially still coded a
little bit on the side, but, quickly, coding for work took so
many of my mental cycles that I couldn't manage to code on the side
any longer.

As the years went by (actually decades), my job took me in directions
where I coded less and less, where I saw less and less code. The first
year of the COVID pandemic was an opportunity to try to get back
to 68000 assembly for the Atari ST, under emulation, and I found that
I enjoyed that and that my professional experience helped me well.
Since then, I've touched a variety of other processors and machines
under emulation, which has been fun.

In 2024, I am relocating from the USA back to Europe, for which I
have been taking a career break. Since this year marks 40 years
since I started programming, I figured that I would try to
celebrate the anniversary.

# The plan

As I'm starting this project, my plan is to write some code for
half a dozen targets, initially aiming for some sort
of scrolling text along with some sprites.

## The targets

### Atari ST

Obviously, Atari ST is on the list. It's been my starting point
for assembly programming, I can't ignore it.

### Amstrad CPC

I'll go back to Amstrad, and, this time, I will manage to make it
do something in assembly.

### Atari 2600

A unique architecture, where you've got to race the beam directly
with the CPU. Arguably the ZX80 and ZX81 are more extreme in that
domain, but racing the beam all the way requires to replace the
built-in ROM, which is easy with an emulator but not quite in the
spirit of those machines.

### Atari 7800

Another unique architecture, that has no framebuffer, no sprites,
no tiles. I like that it seems to offer a twin challenge: getting
something to work at all, and getting something optimized.

### TBD

I have quite a range of choices here.

One is to go for something based on the TI 9918A,
which could be the ColecoVision
(or the Sega SG-1000, which feels like a near-clone),
or the TI 99/4A itself that I actually used in person;
the chip is also used in the MSX, which could be an 
attractive option since its sound chip is essentially
the same as the ones in the Atari ST and Amstrad CPC.

I could also go further back, e.g. I'm familiar with
the hardware from the arcade _Space Invaders_, which
goes back to 1976.

I could touch other machines, e.g. the Vectrex for something
unusual, or the Neo Geo as an extreme sprite-based approach,
or simply the NES because I have a love-hate relationship
with that machine and its rushed hardware.

In another direction, I can look in the direction of fantasy
consoles (PICO-8, TIC-80) or block-based programming (Scratch)
or even somewhere at the intersection (MakeCode).

## The features

Very quickly, a difficulty becomes scrolling: not all machines
support fine-grained hardware scrolling. The Atari ST can
do 8-line vertical (the STe can do better than that), the CPC
can do 8-line vertical and 8-pixel horizontal (in mode 1). If
I go toward anything based on 9918A, there's no hardware
scrolling, and tiles must be 8-pixel aligned. 7800 has a bias 
toward anything organized in slices of 8 or 16 lines, 2600
has a very low-resolution background, and the bit organization
makes it unfriendly toward horizontal scrolling.

This all suggests vertical scrolling as a first exploration,
especially in slices of 8 pixels.

# (Un)important things

## Licensing

This game is licensed under the terms of the
[AGPL, version 3](https://www.gnu.org/licenses/agpl-3.0.en.html)
or later, with the following additional restriction: if you make
the program available for third parties to use on hardware you own
(or co-own, lease, rent, or otherwise control,) such as public
gaming cabinets (whether or not in a gaming arcade, whether or not
coin-operated or otherwise for a fee,) the conditions of section 13
will apply even if no network is involved.

As a special exception, the source assets for the game (images, text,
music, movie files) as well as output from the game (screenshots,
audio or video recordings) are also optionally licensed under the
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
License. That exception explicitly does not apply to source code or
object/executable code, only to assets/media files.

Licensees of the whole game can apply the same exception to their
modified version.

On the other hand, When in doubt, limit yourself to AGPL and
remove the exception from your modified version.

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

_Let's be honest, if using a demo on such an old computer
causes significant privacy concerns or in fact any privacy
concerns, the world is coming to an end._

## Security (including CRA)

None of the code in this project involves any direct or indirect
logical or physical data connection to a device or network.

Also, all of the code in this project is provided under a free
and open source license, in a non-commercial manner. It is
developed, maintained, and distributed openly. As of April
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
The targeted processors might have no security features
(most 8-bit processors), or might be inadequate by modern
security standards (e.g. 68000).
Worse, to the extent that primitive security features might
exist at all, the code will likely disable them as much as
possible, e.g. running Atari ST code in supervisor mode in
order to gain direct access to hardware registers.
Finally, the code is developed in assembly language, which
lacks the modern language features that help security._
