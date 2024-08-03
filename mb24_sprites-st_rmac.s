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
	bsr	HorizInit
	bsr	LogoInit

	move.l	#SpriteX1, sprite_read_x1
	move.l	#SpriteY1, sprite_read_y1
	move.l	fb_back, sprite_erase_back
	move.l	fb_front, sprite_erase_front


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

	bsr	LogoErase

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

	bsr	HorizDraw

	move.w	#$447, $ffff8240.w
	.rept 12
	mulu.w	d0,d0
	.endr
	move.w	#$000, $ffff8240.w

	bsr	LogoDraw

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


	.data

	.even

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

	.include	"tmp/mb24.sines.rmac"

	.bss

	.even
fb_front:
	.ds.l	1
fb_back:
	.ds.l	1

sprite_shifted:
	ds.l	6 * 20 * 16

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

	.include	"mb24_vscroll-st_rmac.s"
	.include	"mb24_hscroll-st_rmac.s"
	.include	"mb24_logo-st_rmac.s"

	.end
