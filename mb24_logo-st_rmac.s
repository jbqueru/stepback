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

LogoInit:
	move.l	#BigLogoX, logo_read_x
	move.l	#BigLogoY1, logo_read_y1
	move.l	#BigLogoY2, logo_read_y2

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

	rts

LogoErase:
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

	rts

; ##################
; ##################
; ###            ###
; ###  Big Logo  ###
; ###            ###
; ##################
; ##################
LogoDraw:

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

	rts

	.data

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

	.include "tmp/mb24.sines.rmac"

	.bss

	.even

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

logo_shifted:
	ds.l	3 * 8 * 80 * 16
