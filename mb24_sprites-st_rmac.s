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

	move.l	#SpriteX1, sprite_read_x1
	move.l	#SpriteY1, sprite_read_y1
	move.l	fb_back, sprite_erase_back
	move.l	fb_front, sprite_erase_front

; *******************************
; **                           **
; ** Prepare unshifted version **
; **                           **
; *******************************

	lea.l	SpritesBitmap, a0
	lea.l	sprites_shifted, a1

	moveq.l	#59, d7
.Copy:
	move.l	(a0)+, (a1)
	move.l	(a0)+, 8(a1)
	move.l	(a0)+, 12(a1)
	move.l	(a0)+, 16(a1)
	move.l	(a0)+, 20(a1)
	move.l	(a0)+, 4(a1)
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
	movea.l	sprite_erase_front, a0
	lea.l	4(a0), a0
	moveq.l	#0, d0

	moveq.l	#19, d7
.Loop:
	move.l	d0, (a0)
	move.l	d0, 8(a0)
	move.l	d0, 16(a0)
	move.l	d0, 24(a0)
	move.l	d0, 32(a0)
	move.l	d0, 40(a0)

	lea.l	160(a0), a0
	dbra	d7, .Loop

	move.l	sprite_erase_back, sprite_erase_front

	rts

; ##############
; ##############
; ###        ###
; ###  Draw  ###
; ###        ###
; ##############
; ##############

SpritesDraw:

	lea.l	sprites_shifted, a0
	movea.l	fb_back, a1

	movea.l	sprite_read_y1, a2
	move.w	(a2)+, d6
	cmpa.l	#SpriteY1End, a2
	bne.s	SpriteY1Ok
	lea.l	SpriteY1, a2
SpriteY1Ok:
	move.l	a2, sprite_read_y1
	lsr.w	#2, d6
	mulu.w	#160, d6
	adda.w	d6, a1

	movea.l	sprite_read_x1, a2
	move.w	(a2)+, d4
	cmpa.l	#SpriteX1End, a2
	bne.s	SpriteX1Ok
	lea.l	SpriteX1, a2
SpriteX1Ok:
	move.l	a2, sprite_read_x1

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

	move.l	a1, sprite_erase_back

	moveq.l	#0, d4

	moveq.l	#19, d7

.Loop:
	movem.l	(a0)+, d2-d3/a3-a6
	and.l	d0, (a1)+
	and.l	d0, (a1)
	or.l	d2, (a1)+
	move.l	d4, (a1)+
	move.l	a3, (a1)+
	move.l	d4, (a1)+
	move.l	a4, (a1)+
	move.l	d4, (a1)+
	move.l	a5, (a1)+
	move.l	d4, (a1)+
	move.l	a6, (a1)+
	and.l	d1, (a1)+
	and.l	d1, (a1)
	or.l	d3, (a1)+

	lea.l	112(a1), a1
	dbra	d7, .Loop

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

; #########################
; #########################
; ###                   ###
; ###  Additional data  ###
; ###                   ###
; #########################
; #########################

	.include	"tmp/mb24_scurves-st_rmac.s"
	.include	"mb24_sbitmaps-st_rmac.s"
