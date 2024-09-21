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

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                         Sprites for MB24 demo                         ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; See mb24_main-st_rmac.s file for overall explanation

; Note that the shifted sprite is sorted out of order.
; This comes from a combination of 2 factors:
;   -The shifted data is read with a movem instruction, for which the
;      register order is fixed.
;   -The left and right columns need to be displayed with an or instruction,
;      which requires a data register, while the other columns are displayed
;      with a move instruction, for which address registerd are acceptable.

	.text

; ##############
; ##############
; ###        ###
; ###  Init  ###
; ###        ###
; ##############
; ##############

SpritesInit:

; ******************
; **              **
; ** Set pointers **
; **              **
; ******************

; TODO: find a way to move the 67 constant to the C file

	lea.l	sprite_read_x1, a0
	move.l	#SpriteX1, (a0)+
	move.l	#SpriteX1 + 67 * 2, (a0)+
	move.l	#SpriteX1 + 134 * 2, (a0)+
	move.l	#SpriteX2, (a0)+
	move.l	#SpriteX2 + 12 * 2, (a0)+
	move.l	#SpriteX2 + 27 * 2, (a0)+
	move.l	#SpriteY1, (a0)+
	move.l	#SpriteY1 + 67 * 2, (a0)+
	move.l	#SpriteY1 + 134 * 2, (a0)+
	move.l	#SpriteY2, (a0)+
	move.l	#SpriteY2 + 30 * 2, (a0)+
	move.l	#SpriteY2 + 39 * 2, (a0)+
	.rept 3
	move.l	fb_front, (a0)+
	.endr
	.rept 3
	move.l	fb_back, (a0)+
	.endr
	move.l	#sprites_shifted, (a0)+
	move.l	#sprites_shifted + 24 * 20, (a0)+
	move.l	#sprites_shifted + 24 * 20 * 2, (a0)+

; *******************************
; **                           **
; ** Prepare unshifted version **
; **                           **
; *******************************

	lea.l	SpritesBitmap, a0
	lea.l	sprites_shifted, a1

	moveq.l	#59, d7
.Copy:
	move.l	d7, d6
	divu	#20, d6
	swap	d6
	cmp.w	#1, d6
	ble.s	.CopyTopBottom
	cmp.w	#18, d6
	bge.s	.CopyTopBottom
	move.l	(a0)+, (a1)
	move.l	(a0)+, 8(a1)
	move.l	(a0)+, 12(a1)
	move.l	(a0)+, 16(a1)
	move.l	(a0)+, 20(a1)
	move.l	(a0)+, 4(a1)
	bra.s	.CopyLineDone
.CopyTopBottom:
	move.l	(a0)+, (a1)
	move.l	(a0)+, 4(a1)
	move.l	(a0)+, 8(a1)
	move.l	(a0)+, 20(a1)
	move.l	(a0)+, 12(a1)
	move.l	(a0)+, 16(a1)
.CopyLineDone:
	adda.w	#24, a1
	dbra	d7, .Copy

; ****************************************************
; **                                                **
; ** Shift into other versions, one pixel at a time **
; **                                                **
; ****************************************************

	lea.l	sprites_shifted, a0
	lea.l	sprites_shifted + 24 * 20 * 3, a1

	moveq.l	#14, d7
.Pixel:
	moveq.l	#59, d6
.Line:
	move.l	d6, d5
	divu.w	#20, d5
	swap	d5
	cmp.w	#1, d5
	ble.s	.ShiftTopBottom
	cmp.w	#18, d5
	bge.s	.ShiftTopBottom

	moveq.l	#1, d5
.Plane:
	move.w	(a0), d0
	lsr.w	d0
	move.w	d0, (a1)
	move.w	8(a0), d0
	roxr.w	d0
	move.w	d0, 8(a1)
	move.w	12(a0), d0
	roxr.w	d0
	move.w	d0, 12(a1)
	move.w	16(a0), d0
	roxr.w	d0
	move.w	d0, 16(a1)
	move.w	20(a0), d0
	roxr.w	d0
	move.w	d0, 20(a1)
	move.w	4(a0), d0
	roxr.w	d0
	move.w	d0, 4(a1)
	addq.l	#2, a0
	addq.l	#2, a1

	dbra	d5, .Plane
	bra.s	.ShiftLineDone

.ShiftTopBottom:

	moveq.l	#1, d5
.PlaneTopBottom:
	move.w	(a0), d0
	lsr.w	d0
	move.w	d0, (a1)
	move.w	4(a0), d0
	roxr.w	d0
	move.w	d0, 4(a1)
	move.w	8(a0), d0
	roxr.w	d0
	move.w	d0, 8(a1)
	move.w	20(a0), d0
	roxr.w	d0
	move.w	d0, 20(a1)
	move.w	12(a0), d0
	roxr.w	d0
	move.w	d0, 12(a1)
	move.w	16(a0), d0
	roxr.w	d0
	move.w	d0, 16(a1)
	addq.l	#2, a0
	addq.l	#2, a1

	dbra	d5, .PlaneTopBottom
.ShiftLineDone:

	lea.l	20(a0), a0
	lea.l	20(a1), a1
	dbra	d6, .Line
	dbra	d7, .Pixel

	rts

; ###############
; ###############
; ###         ###
; ###  Erase  ###
; ###         ###
; ###############
; ###############

SpritesErase:
	moveq.l	#2, d7
	lea.l	sprite_erase_front, a6

.OneSprite:
	movea.l	(a6), a0
	lea.l	4(a0), a0
	moveq.l	#0, d0

	moveq.l	#19, d6
.Loop:
	move.l	d0, (a0)
	move.l	d0, 8(a0)
	move.l	d0, 16(a0)
	move.l	d0, 24(a0)
	move.l	d0, 32(a0)
	move.l	d0, 40(a0)

	lea.l	160(a0), a0
	dbra	d6, .Loop

	move.l	12(a6), (a6)+
	dbra	d7, .OneSprite

	rts

; ##############
; ##############
; ###        ###
; ###  Draw  ###
; ###        ###
; ##############
; ##############

SpritesDraw:
; d0 | left mask
; d1 | right mask
; d2 | center mask
; d3 | temp / sprite data
; d4 | temp / sprite data
; d5 | temp
; d6 | line loop counter
; d7 | sprite loop counter
; a0 | bitmap source
; a1 | bitmap destination
; a2 | temp / sprite data
; a3 | sprite data
; a4 | sprite data
; a5 | sprite data
; a6 | sprite variables
; a7 | stack

	moveq.l	#2, d7
	lea.l	sprite_read_x1, a6
LoopSprite:
	movea.l	72(a6), a0
	movea.l	fb_back, a1

	movea.l	24(a6), a2
	move.w	(a2)+, d4
	cmpa.l	#SpriteY1End, a2
	bne.s	SpriteY1Ok
	lea.l	SpriteY1, a2
SpriteY1Ok:
	move.l	a2, 24(a6)

	movea.l	36(a6), a2
	add.w	(a2)+, d4
	cmpa.l	#SpriteY2End, a2
	bne.s	SpriteY2Ok
	lea.l	SpriteY2, a2
SpriteY2Ok:
	move.l	a2, 36(a6)

	lsr.w	#2, d4
	mulu.w	#160, d4
	adda.w	d4, a1

	movea.l	(a6), a2
	move.w	(a2)+, d4
	cmpa.l	#SpriteX1End, a2
	bne.s	SpriteX1Ok
	lea.l	SpriteX1, a2
SpriteX1Ok:
	move.l	a2, (a6)

	movea.l	12(a6), a2
	add.w	(a2)+, d4
	cmpa.l	#SpriteX2End, a2
	bne.s	SpriteX2Ok
	lea.l	SpriteX2, a2
SpriteX2Ok:
	move.l	a2, 12(a6)

	lsr.w	#2, d4
	move.w	d4, d5
	and.w	#$f, d5
	sub.w	d5, d4
	lsr.w	d4
	adda.w	d4, a1

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

	mulu.w	#24 * 20 * 3, d5
	adda.w	d5, a0

	move.l	a1, 60(a6)

	moveq.l	#0, d2

	moveq.l	#1, d6
.LoopTop:
	movem.l	(a0)+, d3-d4/a2
;	and.l	d0, (a1)+
;	and.l	d0, (a1)
	addq.w	#4, a1
	or.l	d3, (a1)+
;	move.l	d2, (a1)+
	addq.w	#4, a1
	or.l	d4, (a1)+
	move.l	d2, (a1)+
	move.l	a2, (a1)+
	movem.l	(a0)+, d3-d4/a2
	move.l	d2, (a1)+
	move.l	a2, (a1)+
;	move.l	d2, (a1)+
	addq.w	#4, a1
	or.l	d3, (a1)+
;	and.l	d1, (a1)+
;	and.l	d1, (a1)
	addq.w	#4, a1
	or.l	d4, (a1)+

	lea.l	112(a1), a1
	dbra	d6, .LoopTop

	moveq.l	#15, d6
.LoopMiddle:
	movem.l	(a0)+, d3-d4/a2-a5
	and.l	d0, (a1)+
	and.l	d0, (a1)
	or.l	d3, (a1)+
	move.l	d2, (a1)+
	move.l	a2, (a1)+
	move.l	d2, (a1)+
	move.l	a3, (a1)+
	move.l	d2, (a1)+
	move.l	a4, (a1)+
	move.l	d2, (a1)+
	move.l	a5, (a1)+
	and.l	d1, (a1)+
	and.l	d1, (a1)
	or.l	d4, (a1)+

	lea.l	112(a1), a1
	dbra	d6, .LoopMiddle

	moveq.l	#1, d6
.LoopBottom:
	movem.l	(a0)+, d3-d4/a2
;	and.l	d0, (a1)+
;	and.l	d0, (a1)
	addq.w	#4, a1
	or.l	d3, (a1)+
;	move.l	d2, (a1)+
	addq.w	#4, a1
	or.l	d4, (a1)+
	move.l	d2, (a1)+
	move.l	a2, (a1)+
	movem.l	(a0)+, d3-d4/a2
	move.l	d2, (a1)+
	move.l	a2, (a1)+
;	move.l	d2, (a1)+
	addq.w	#4, a1
	or.l	d3, (a1)+
;	and.l	d1, (a1)+
;	and.l	d1, (a1)
	addq.w	#4, a1
	or.l	d4, (a1)+

	lea.l	112(a1), a1
	dbra	d6, .LoopBottom

	addq.l	#4, a6
	dbra	d7, LoopSprite

	rts

; ###################
; ###################
; ###             ###
; ###  Variables  ###
; ###             ###
; ###################
; ###################

	.bss

	.even
sprites_shifted:
	ds.l	6 * 20 * 16 * 3

sprite_read_x1:
	ds.l	3
sprite_read_x2:
	ds.l	3
sprite_read_y1:
	ds.l	3
sprite_read_y2:
	ds.l	3
sprite_erase_front:
	ds.l	3
sprite_erase_back:
	ds.l	3
sprite_preshifted:
	ds.l	3

; #########################
; #########################
; ###                   ###
; ###  Additional data  ###
; ###                   ###
; #########################
; #########################

	.include	"out/inc/names_curves.s"
	.include	"names_bitmaps.s"
