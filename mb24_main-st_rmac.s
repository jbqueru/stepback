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
	bsr	SpritesInit


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
	bsr	SpritesErase

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

	bsr	SpritesDraw

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

	.bss

	.even
fb_front:
	.ds.l	1
fb_back:
	.ds.l	1

fb_raw:
	.ds.b	64255

	.include	"mb24_vscroll-st_rmac.s"
	.include	"mb24_hscroll-st_rmac.s"
	.include	"mb24_logo-st_rmac.s"
	.include	"mb24_sprites-st_rmac.s"

	.end
