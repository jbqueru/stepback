; Copyright 2024 Jean-Baptiste M. "JBQ" "Djaybee" Queru
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU Affero General Public License as
; published by the Free Software Foundation, either version 3 of the
; License, or (at your option) any later version.
;
; As an added restriction, if you make the program available for
; third parties to use on hardware you own (or co-own, lease, rent,
; or otherwise control,) such as public gaming cabinets (whether or
; not in a gaming arcade, whether or not coin-operated or otherwise
; for a fee,) the conditions of section 13 will apply even if no
; network is involved.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU Affero General Public License for more details.
;
; You should have received a copy of the GNU Affero General Public License
; along with this program. If not, see <https://www.gnu.org/licenses/>.
;
; SPDX-License-Identifier: AGPL-3.0-or-later

; Coding style:
;	- ASCII
;	- hard tabs, 8 characters wide, except in ASCII art
;	- 120 columns overall
;	- Standalone block comments in the first 80 columns
;	- Code-related block comments allowed in the last 80 columns
;	- Note: rulers at 40, 80 and 120 columns help with source width
;
;	- Assembler directives are .lowercase
;	- Mnemomics and registers are lowercase unless otherwise required
;	- Global symbols for code are CamelCase
;	- Symbols for variables are snake_case
;	- Symbols for hardware registers are ALL_CAPS
;	- Related symbols start with the same prefix (so they sort together)
;	- hexadecimal constants are lowercase ($eaf00d).
;
;	- Include but comment out instructions that help readability but
;		don't do anything (e.g. redundant CLC on 6502 when the carry is
;		guaranteed already to be clear). The comment symbol should be
;		where the instruction would be, i.e. not on the first column.
;		There should be an explanation in a comment.
;	- Use the full instruction mnemonic when a shortcut would potentially
;		cause confusion. E.g. use movea instead of move on 680x0 when
;		the code relies on the flags not getting modified.

	.68000
	.text

	pea.l	SupEntr
	move.w	#38, -(sp)
	trap	#14
	addq.w	#6, sp

	move.w	#0, -(sp)
	trap	#1

SupEntr:
	move.w	#$2700, sr

	move.b	#0, $fffffa07.w
	move.b	#0, $fffffa09.w
	move.b	#0, $fffffa0b.w
	move.b	#0, $fffffa0d.w
	move.b	#0, $fffffa0f.w
	move.b	#0, $fffffa11.w

	move.l	#VBL_Handler, $70.w
	move.l	#HBL_Handler, $120.w

	stop	#$2300
	stop	#$2300

;	and.b	#%11110111, $fffffa17.w
;	move.b	#0, $fffffa0b.w
;	move.b	#0, $fffffa0f.w
;	move.b	#0, $fffffa1b.w
;	move.b	#%0000, $fffffa1b.w
;	move.b	#200, $fffffa21.w
;	move.b	#%1000, $fffffa1b.w
;	move.b	#%00000001, $fffffa07.w
;	move.b	#%00000001, $fffffa13.w

	move.b	#2, $ffff820a.w
	move.b	#0, $ffff8260.w

	move.w	#$732, $ffff8242.w
	move.w	#$463, $ffff8244.w
	move.w	#$463, $ffff8246.w

	move.w	#$322, $ffff8248.w
	move.w	#$533, $ffff8250.w
	move.w	#$744, $ffff8258.w

	move.w	#$667, $ffff824a.w
	move.w	#$556, $ffff824c.w

	move.l	#fb_raw, d0
	add.l	#$ff, d0
	and.l	#$ffffff00, d0

	move.l	d0, fb_front
	add.l	#32000, d0
	move.l	d0, fb_back

	bsr	VertInit

	move.l	#HorizText, horiz_text_read
	move.l	#horiz_buffer, horiz_read
	move.l	#horiz_buffer, horiz_previous_read
	move.l	#HorizFont, horiz_font_read
	move.l	#HorizFont + 2, horiz_char_end

	move.l	#BigLogoX, logo_read_x
	move.l	#BigLogoY1, logo_read_y1
	move.l	#BigLogoY2, logo_read_y2

	move.l	#SpriteX1, sprite_read_x1
	move.l	#SpriteY1, sprite_read_y1
	move.l	fb_back, sprite_erase_back
	move.l	fb_front, sprite_erase_front

	move.l	#BigLogo, a0
	move.l	#logo_shifted, a1

	move.w	#639, d0
CopyLogo:
	movem.w	(a0)+, d4-d7
	move.w	d4, d3
	or.w	d5, d3
	or.w	d6, d3
	or.w	d7, d3
	not.w	d3
	move.w	d3, (a1)+
	move.w	d3, (a1)+
	move.w	d4, (a1)+
	move.w	d5, (a1)+
	move.w	d6, (a1)+
	move.w	d7, (a1)+
	dbra	d0, CopyLogo

	move.l	#logo_shifted, a0
	move.l	#logo_shifted + 96 * 80, a1
	moveq.l	#14, d0
LogoPixel:
	moveq.l	#79, d1
ShiftLine:
	moveq.l	#5, d2
ShiftBitPlane:
	cmp.w	#4, d2
	sge	d3
	and.w	#16, d3
	move.w	d3, ccr
	moveq.l	#7, d3
Shift16pix:
	move.w	(a0), d4
	roxr.w	d4
	move.w	d4, (a1)
	adda.w	#12, a0
	adda.w	#12, a1
	dbra.w	d3, Shift16pix
	sub.w	#94, a0
	sub.w	#94, a1
	dbra	d2, ShiftBitPlane
	add.w	#84, a0
	add.w	#84, a1
	dbra	d1, ShiftLine
	dbra	d0, LogoPixel

	move.l	fb_front, logo_address_front
	move.l	fb_back, logo_address_back


	move.l	#SmallSprite, a0
	move.l	#sprite_shifted, a1
	moveq.l	#19, d0
CopySprite:
	move.l	(a0)+, (a1)
	move.l	(a0)+, 8(a1)
	move.l	(a0)+, 12(a1)
	move.l	(a0)+, 16(a1)
	move.l	(a0)+, 20(a1)
	move.l	(a0)+, 4(a1)
	add.w	#24, a1
	dbra	d0, CopySprite

	move.l	#sprite_shifted, a0
	move.l	#sprite_shifted + 24 * 20, a1
	moveq.l	#14, d0
SpritePixel:
	moveq.l	#19, d1
SpriteLine:
	moveq.l	#1, d2
SpritePlane:
	move.w	(a0), d3
	lsr.w	d3
	move.w	d3, (a1)
	move.w	8(a0), d3
	roxr.w	d3
	move.w	d3, 8(a1)
	move.w	12(a0), d3
	roxr.w	d3
	move.w	d3, 12(a1)
	move.w	16(a0), d3
	roxr.w	d3
	move.w	d3, 16(a1)
	move.w	20(a0), d3
	roxr.w	d3
	move.w	d3, 20(a1)
	move.w	4(a0), d3
	roxr.w	d3
	move.w	d3, 4(a1)
	addq.l	#2, a0
	addq.l	#2, a1
	dbra	d2, SpritePlane
	add.w	#20, a0
	add.w	#20, a1
	dbra	d1, SpriteLine
	dbra	d0, SpritePixel




; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                               Main Loop                               ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

MainLoop:

; *************************
; **                     **
; ** Wait for next VSync **
; **                     **
; *************************

	stop	#$2300

; ***********************
; **                   **
; ** Swap framebuffers **
; **                   **
; ***********************

	move.l	fb_front, d0
	move.l	fb_back, fb_front
	move.l	d0, fb_back
	lsr.l	#8, d0
	move.b	d0, $ffff8203.w
	lsr.l	#8, d0
	move.b	d0, $ffff8201.w

	move.l	logo_address_front, a0

	moveq.l	#0, d4
	move.l	d4, d5
	move.l	d4, d6
	move.l	d4, d7
	move.l	d4, a3
	move.l	d4, a4
	move.l	d4, a5
	move.l	d4, a6

	moveq.l	#79, d0
EraseLogo:
	movem.l	d4-d7/a3-a6, (a0)
	movem.l	d4-d7/a3-a6, 32(a0)
	add	#160, a0
	dbra d0, EraseLogo

	move.l	sprite_erase_front, a0
	move.l	sprite_erase_back, sprite_erase_front

	moveq.l	#19, d0
EraseSprite:
	move.l	d4, 4(a0)
	move.l	d4, 12(a0)
	move.l	d4, 20(a0)
	move.l	d4, 28(a0)
	move.l	d4, 36(a0)
	move.l	d4, 44(a0)
	add.w	#160, a0
	dbra	d0, EraseSprite


	move.w	#$744, $ffff8240.w
	.rept 12
	mulu.w	d0,d0
	.endr
	move.w	#$000, $ffff8240.w

	bsr VertDraw

	move.w	#$474, $ffff8240.w
	.rept 12
	mulu.w	d0,d0
	.endr
	move.w	#$000, $ffff8240.w


; #############################
; #############################
; ###                       ###
; ###  Horizontal scroller  ###
; ###                       ###
; #############################
; #############################

; *************************
; **                     **
; ** Draw to framebuffer **
; **                     **
; *************************

	move.l	fb_back, a0
	add.w	#120 * 160 + 2, a0
	move.l	horiz_read, d0
	move.l	d0, a1
	move.w	#8, d0
Text0:
	move.w	#19, d1
Text1:
	move.w	(a1)+, d2
	move.w	d2, (a0)
	move.w	d2, 160(a0)
	move.w	d2, 320(a0)
	move.w	d2, 480(a0)
	move.w	d2, 640(a0)
	move.w	d2, 800(a0)
	move.w	d2, 960(a0)
	move.w	d2, 1120(a0)

	addq.w	#8, a0
	dbra	d1, Text1
	add.w	#1120, a0
	add.w	#40, a1
	dbra	d0, Text0

; *********************
; **                 **
; ** Insert new data **
; **                 **
; *********************

	move.l	horiz_read, a0
	move.l	horiz_font_read, a1
	move.w	(a1), d0
	eor	#1, horiz_half_advance
	bne.s	HInChar
	addq.w	#2, a1
	cmp.l	horiz_char_end, a1
	bne.s	HInChar

	move.l	horiz_text_read, a2
	moveq.l	#0,d1
	move.b	(a2)+, d1
	cmp.l	#EndHorizText, a2
	bne.s	HInText
	move.l	#HorizText, a2
HInText:
	move.l	a2, horiz_text_read

	move.l	#HorizChars, a2
	sub.b	#32, d1
	lsl.w	#2, d1
	add.w	d1, a2
	move.l	(a2)+, a1
	move.l	(a2)+, horiz_char_end
HInChar:
	move.l	a1, horiz_font_read

	move.l	horiz_previous_read, a1
	moveq.l	#8, d2
ShiftPixel:
	move.w	(a1), d3
	lsl.w	#4, d3

	lsr.w	d0
	scs	d1
	and.b	#$f, d1
	or.b	d1, d3
	move.w	d3, (a0)
	move.w	d3, 40(a0)
	add.w	#80, a1
	add.w	#80, a0
	dbra	d2, ShiftPixel

; ****************************
; **                        **
; ** Point to new locations **
; **                        **
; ****************************

	move.l	horiz_read, a0
	move.l	a0, horiz_previous_read

	add.w	#40 * 2 * 9, a0
	cmp.l	#horiz_buffer + 40 * 2 * 9 * 4, a0
	blt.s	HorizBufferOk
	sub.w	#40 * 2 * 9 * 4 - 2, a0
	cmp.l	#horiz_buffer + 40, a0
	bne.s	HorizBufferOk
	sub.w	#40, a0
HorizBufferOk:
	move.l	a0, horiz_read

	move.w	#$447, $ffff8240.w
	.rept 12
	mulu.w	d0,d0
	.endr
	move.w	#$000, $ffff8240.w


; ##################
; ##################
; ###            ###
; ###  Big Logo  ###
; ###            ###
; ##################
; ##################

	move.l	fb_back, a0
	move.l	#logo_shifted, a1

	move.l	logo_read_y1, a2
	move.w	(a2)+, d0
	cmp.l	#BigLogoY1End, a2
	bne.s	LogoY1Ok
	move.l	#BigLogoY1, a2
LogoY1Ok:
	move.l	a2, logo_read_y1

	move.l	logo_read_y2, a2
	add.w	(a2)+, d0
	cmp.l	#BigLogoY2End, a2
	bne.s	LogoY2Ok
	move.l	#BigLogoY2, a2
LogoY2Ok:
	move.l	a2, logo_read_y2

	lsr.w	#2, d0
	mulu.w	#160, d0
	add.w	d0, a0

	move.l	logo_read_x, a2
	moveq.l	#0, d1
	move.b	(a2)+, d1
	cmp.l	#BigLogoXEnd, a2
	bne.s	LogoXOk
	move.l	#BigLogoX, a2
LogoXOk:
	move.l	a2, logo_read_x
	move.w	d1, d0
	and.w	#$f0, d0
	lsr.w	d0
	add.w	d0, a0
	and.w	#$0f, d1
	mulu.w	#96 * 80, d1
	add.l	d1, a1

	move.l	logo_address_back, logo_address_front
	move.l	a0, logo_address_back

	moveq.l	#79, d0
Lp0:
	.rept 8
	movem.l	(a1)+, d5-d7
	and.l	d5, (a0)
	or.l	d6, (a0)+
	move.l	d7, (a0)+
	.endr
	add.w	#96, a0
	dbra	d0, Lp0

	move.w	#$774, $ffff8240.w
	.rept 12
	mulu.w	d0,d0
	.endr
	move.w	#$000, $ffff8240.w

; #######################
; #######################
; ###                 ###
; ###  Small Sprites  ###
; ###                 ###
; #######################
; #######################

	move.l	fb_back, a0
	move.l	#sprite_shifted, a1

	move.l	sprite_read_y1, a2
	move.w	(a2)+, d6
	cmp.l	#SpriteY1End, a2
	bne.s	SpriteY1Ok
	move.l	#SpriteY1, a2
SpriteY1Ok:
	move.l	a2, sprite_read_y1
	lsr.w	#2, d6
	mulu.w	#160, d6
	add.w	d6, a0

	move.l	sprite_read_x1, a2
	move.w	(a2)+, d4
	cmp.l	#SpriteX1End, a2
	bne.s	SpriteX1Ok
	move.l	#SpriteX1, a2
SpriteX1Ok:
	move.l	a2, sprite_read_x1

	lsr.w	#2, d4
	move.w	d4, d5
	and.w	#$f, d5
	sub.w	d5, d4
	lsr.w	d4
	add	d4, a0

	moveq.l	#-1, d2
	move.w	#$7fff, d3
	lsr.w	d5, d2
	not	d2
	lsr.w	d5, d3

	move.w	d2, d0
	swap 	d0
	move.w	d2, d0
	move.w	d3, d1
	swap	d1
	move.w	d3, d1

	mulu.w	#24 * 20, d5
	add.w	d5, a1

	move.l	a0, sprite_erase_back

	lea.l	0.w, a2

	moveq.l	#19, d7

DrawSprite:
	movem.l	(a1)+, d2-d3/a3-a6
	and.l	d0, (a0)+
	and.l	d0, (a0)
	or.l	d2, (a0)+
	move.l	a2, (a0)+
	move.l	a3, (a0)+
	move.l	a2, (a0)+
	move.l	a4, (a0)+
	move.l	a2, (a0)+
	move.l	a5, (a0)+
	move.l	a2, (a0)+
	move.l	a6, (a0)+
	and.l	d1, (a0)+
	and.l	d1, (a0)
	or.l	d3, (a0)+
	add.w	#112, a0
	dbra	d7, DrawSprite

	move.w	#$777, $ffff8240.w
	.rept 12
	mulu.w	d0,d0
	.endr
	move.w	#$000, $ffff8240.w

	bra	MainLoop

VBL_Handler:
	rte

HBL_Handler:
	eor.w	#$444, $ffff8240.w
	rte

	.include "mb24_vscroll-st_rmac.s"

	.data

	.include "mb24.hfont.st.rmac"

HorizText:
	dc.b	"I'M JBQ (JEAN-BAPTISTE) \"DJAYBEE\", "
	dc.b	"FROM THE MEGABUSTERS. REMEMBER US? YOU'D BETTER! "
	dc.b	"MEGABUSTERS: TOP DEMO CREW IN CHAUFFAYER!!!  "
	dc.b	"JBQUERU@GMAIL.COM HTTPS://GITHUB.COM/JBQUERU    "
	dc.b	"THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG       "
	dc.b	" !\"'(),-./0123456789:?@ABCDEFGHIJKLMNOPQRSTUVWXYZ "
EndHorizText:

	.even

BigLogo:
	.rept 2
	dc.l	$ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $80000000, $80000000
	.endr
	.rept 2
	dc.l	$c0003fff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0001fffe, $ffff0000, $80000000, $80000000
	.endr
	.rept 72
	dc.l	$c0003000, $f0000000, $00000000, $00000000, $00000000, $00000000, $00000000, $00000000, $00000000, $00000000, $00000000, $00000000, $00010002, $00030000, $80000000, $80000000
	.endr
	.rept 2
	dc.l	$c0003fff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0000ffff, $ffff0000, $0001fffe, $ffff0000, $80000000, $80000000
	.endr
	.rept 2
	dc.l	$ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $ffff0000, $80000000, $80000000
	.endr

SmallSprite:
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	.rept 14
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000

	.include "tmp/mb24.sines.rmac"

	.bss

	.even
fb_front:
	.ds.l	1
fb_back:
	.ds.l	1

horiz_buffer:
	ds.w	20 * 2 * 9 * 4

horiz_read:
	ds.l	1
horiz_previous_read:
	ds.l	1

horiz_font_read:
	ds.l	1
horiz_char_end:
	ds.l	1

horiz_half_advance:
	ds.w	1

horiz_text_read:
	ds.l	1

logo_shifted:
	ds.l	3 * 8 * 80 * 16

sprite_shifted:
	ds.l	6 * 20 * 16

logo_y:
	ds.w	1
logo_address_front:
	ds.l	1
logo_address_back:
	ds.l	1

logo_read_x:
	ds.l	1
logo_read_y1:
	ds.l	1
logo_read_y2:
	ds.l	1

sprite_read_x1:
	ds.l	1
sprite_read_x2:
	ds.l	1
sprite_read_y1:
	ds.l	1
sprite_read_y2:
	ds.l	1
sprite_erase_front:
	ds.l	1
sprite_erase_back:
	ds.l	1

fb_raw:
	.ds.b	64255

	.end
