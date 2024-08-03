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

; See mb24_main-st_rmac.s file for full explanation

	.text

; ##############
; ##############
; ###        ###
; ###  Init  ###
; ###        ###
; ##############
; ##############

SpritesInit:
	move.l	#SpriteX1, sprite_read_x1
	move.l	#SpriteY1, sprite_read_y1
	move.l	fb_back, sprite_erase_back
	move.l	fb_front, sprite_erase_front


	move.l	#SmallSprite, a0
	move.l	#sprite_shifted, a1
	moveq.l	#19, d0
.Copy:
	move.l	(a0)+, (a1)
	move.l	(a0)+, 8(a1)
	move.l	(a0)+, 12(a1)
	move.l	(a0)+, 16(a1)
	move.l	(a0)+, 20(a1)
	move.l	(a0)+, 4(a1)
	add.w	#24, a1
	dbra	d0, .Copy

	move.l	#sprite_shifted, a0
	move.l	#sprite_shifted + 24 * 20, a1
	moveq.l	#14, d0
.Pixel:
	moveq.l	#19, d1
.Line:
	moveq.l	#1, d2
.Plane:
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
	dbra	d2, .Plane
	add.w	#20, a0
	add.w	#20, a1
	dbra	d1, .Line
	dbra	d0, .Pixel

	rts

; ###############
; ###############
; ###         ###
; ###  Erase  ###
; ###         ###
; ###############
; ###############

SpritesErase:
	move.l	sprite_erase_front, a0
	move.l	sprite_erase_back, sprite_erase_front

	moveq.l	#19, d0
.Loop:
	move.l	d4, 4(a0)
	move.l	d4, 12(a0)
	move.l	d4, 20(a0)
	move.l	d4, 28(a0)
	move.l	d4, 36(a0)
	move.l	d4, 44(a0)
	add.w	#160, a0
	dbra	d0, .Loop

	rts

; ##############
; ##############
; ###        ###
; ###  Draw  ###
; ###        ###
; ##############
; ##############

SpritesDraw:

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

.Loop:
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

; #########################
; #########################
; ###                   ###
; ###  Additional data  ###
; ###                   ###
; #########################
; #########################

	.include	"tmp/mb24_scurves-st_rmac.s"
	.include	"mb24_sbitmaps-st_rmac.s"
