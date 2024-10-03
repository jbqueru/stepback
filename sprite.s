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

	.text

SpriteInit:
	move.l	#SpriteX, sprite_read_x
	move.l	#SpriteY1, sprite_read_y1
	move.l	#SpriteY2, sprite_read_y2

	move.l	#BigSprite, a0
	move.l	#sprite_shifted, a1

	move.w	#727, d0		// 7 * 104 - 1
.Copy:
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
	dbra	d0, .Copy

	move.l	#sprite_shifted, a0
	move.l	#sprite_shifted + 84 * 104, a1
	moveq.l	#14, d0
.Pixel:
	moveq.l	#103, d1
.Line:
	moveq.l	#5, d2
.BitPlane:
	cmp.w	#4, d2
	sge	d3
	and.w	#16, d3
	move.w	d3, ccr
	moveq.l	#6, d3
.16pix:
	move.w	(a0), d4
	roxr.w	d4
	move.w	d4, (a1)
	adda.w	#12, a0
	adda.w	#12, a1
	dbra.w	d3, .16pix
	sub.w	#82, a0
	sub.w	#82, a1
	dbra	d2, .BitPlane
	add.w	#72, a0
	add.w	#72, a1
	dbra	d1, .Line
	dbra	d0, .Pixel

	move.l	fb_front, sprite_address_front
	move.l	fb_back, sprite_address_back

	rts

SpriteErase:
	move.l	sprite_address_front, a0

	moveq.l	#0, d4
	move.l	d4, d5
	move.l	d4, d6
	move.l	d4, d7
	move.l	d4, a3
	move.l	d4, a4
	move.l	d4, a5

	moveq.l	#103, d0
.Erase:
	movem.l	d4-d7/a3-a5, (a0)
	movem.l	d4-d7/a3-a5, 28(a0)
	add	#160, a0
	dbra d0, .Erase

	rts

; ####################
; ####################
; ###              ###
; ###  Big Sprite  ###
; ###              ###
; ####################
; ####################
SpriteDraw:

	move.l	fb_back, a0
	move.l	#sprite_shifted, a1

	move.l	sprite_read_y1, a2
	move.w	(a2)+, d0
	cmp.l	#SpriteY1End, a2
	bne.s	.Y1Ok
	move.l	#SpriteY1, a2
.Y1Ok:
	move.l	a2, sprite_read_y1

	move.l	sprite_read_y2, a2
	add.w	(a2)+, d0
	cmp.l	#SpriteY2End, a2
	bne.s	.Y2Ok
	move.l	#SpriteY2, a2
.Y2Ok:
	move.l	a2, sprite_read_y2

	lsr.w	#3, d0
	mulu.w	#160, d0
	add.w	d0, a0

	move.l	sprite_read_x, a2
	moveq.l	#0, d1
	move.b	(a2)+, d1
	cmp.l	#SpriteXEnd, a2
	bne.s	.XOk
	move.l	#SpriteX, a2
.XOk:
	move.l	a2, sprite_read_x
	move.w	d1, d0
	and.w	#$f0, d0
	lsr.w	d0
	add.w	d0, a0
	and.w	#$0f, d1
	mulu.w	#84 * 104, d1
	add.l	d1, a1

	move.l	sprite_address_back, sprite_address_front
	move.l	a0, sprite_address_back

	moveq.l	#15, d0
.Lp0:
	.rept 7
	movem.l	(a1)+, d5-d7
	and.l	d5, (a0)
	or.l	d6, (a0)+
	move.l	d7, (a0)+
	.endr
	add.w	#104, a0
	dbra	d0, .Lp0

	moveq.l	#71, d0
.Lp1:
	.rept 2
	movem.l	(a1)+, d5-d7
	and.l	d5, (a0)
	or.l	d6, (a0)+
	move.l	d7, (a0)+
	.endr
	.rept 3
	movem.l	(a1)+, d5-d7
	move.l	d6, (a0)+
	move.l	d7, (a0)+
	.endr
	.rept 2
	movem.l	(a1)+, d5-d7
	and.l	d5, (a0)
	or.l	d6, (a0)+
	move.l	d7, (a0)+
	.endr
	add.w	#104, a0
	dbra	d0, .Lp1

	moveq.l	#15, d0
.Lp2:
	.rept 7
	movem.l	(a1)+, d5-d7
	and.l	d5, (a0)
	or.l	d6, (a0)+
	move.l	d7, (a0)+
	.endr
	add.w	#104, a0
	dbra	d0, .Lp2

	rts


	.bss

	.even

sprite_y:
	ds.w	1
sprite_address_front:
	ds.l	1
sprite_address_back:
	ds.l	1

sprite_read_x:
	ds.l	1
sprite_read_y1:
	ds.l	1
sprite_read_y2:
	ds.l	1

sprite_shifted:
	ds.l	3 * 7 * 104 * 16

	.include "out/inc/sprite_curves.s"
	.include "sprite_bitmap.s"