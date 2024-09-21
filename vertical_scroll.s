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
; ###                   Vertical scrolltext for MB24 demo                   ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; SEE mb24_main file for full explanation

	.text

VertInit:
	move.l	#vert_buffer, vert_buffer_read
	move.l	#VertFont, vert_char_read
	move.l	#VertFont + 36, vert_char_end
	move.l	#VertText, vert_text_read

	move.l	#VerticalCurve + 75, vert_curve1
	move.l	#VerticalCurve + 60, vert_curve2
	move.l	#VerticalCurve + 45, vert_curve3
	move.l	#VerticalCurve + 30, vert_curve4
	move.l	#VerticalCurve + 15, vert_curve5
	move.l	#VerticalCurve + 00, vert_curve6

	rts

; ############################
; ############################
; ###                      ###
; ###  Vertical scrollers  ###
; ###                      ###
; ############################
; ############################

; *************************
; **                     **
; ** Draw to framebuffer **
; **                     **
; *************************
VertDraw:

	move.l	vert_buffer_read, a1
	movea.l	a1, a2
	movea.l	a1, a3
	movea.l	a1, a4
	movea.l	a1, a5
	movea.l	a1, a6

	movea.l	vert_curve1, a0
	moveq.l	#0, d0
	move.b	(a0)+, d0
	addi.w	#20 * 5 * 2, d0
	cmpa.l	#VerticalCurveEnd, a0
	bne.s	.InCurve1
	lea.l	VerticalCurve, a0
.InCurve1:
	move.l	a0, vert_curve1
	adda.w	d0, a1

	movea.l	vert_curve2, a0
	moveq.l	#0, d0
	move.b	(a0)+, d0
	addi.w	#20 * 4 * 2, d0
	cmpa.l	#VerticalCurveEnd, a0
	bne.s	.InCurve2
	lea.l	VerticalCurve, a0
.InCurve2:
	move.l	a0, vert_curve2
	adda.w	d0, a2

	movea.l	vert_curve3, a0
	moveq.l	#0, d0
	move.b	(a0)+, d0
	addi.w	#20 * 3 * 2, d0
	cmpa.l	#VerticalCurveEnd, a0
	bne.s	.InCurve3
	lea.l	VerticalCurve, a0
.InCurve3:
	move.l	a0, vert_curve3
	adda.w	d0, a3

	movea.l	vert_curve4, a0
	moveq.l	#0, d0
	move.b	(a0)+, d0
	addi.w	#20 * 2 * 2, d0
	cmpa.l	#VerticalCurveEnd, a0
	bne.s	.InCurve4
	lea.l	VerticalCurve, a0
.InCurve4:
	move.l	a0, vert_curve4
	adda.w	d0, a4

	movea.l	vert_curve5, a0
	moveq.l	#0, d0
	move.b	(a0)+, d0
	addi.w	#20 * 2, d0
	cmpa.l	#VerticalCurveEnd, a0
	bne.s	.InCurve5
	lea.l	VerticalCurve, a0
.InCurve5:
	move.l	a0, vert_curve5
	adda.w	d0, a5

	movea.l	vert_curve6, a0
	moveq.l	#0, d0
	move.b	(a0)+, d0
	cmpa.l	#VerticalCurveEnd, a0
	bne.s	.InCurve6
	lea.l	VerticalCurve, a0
.InCurve6:
	move.l	a0, vert_curve6
	adda.w	d0, a6

	movea.l	fb_back, a0
	lea.l	16(a0), a0
	moveq.l	#19,d1
.Draw10Lines:
	.rept	10
	move.w	(a1)+, (a0)
	move.w	(a2)+, 24(a0)
	move.w	(a3)+, 48(a0)
	move.w	(a4)+, 72(a0)
	move.w	(a5)+, 96(a0)
	move.w	(a6)+, 120(a0)
	lea.l	160(a0), a0
	.endr
	dbra	d1, .Draw10Lines

; *********************
; **                 **
; ** Insert new data **
; **                 **
; *********************

	move.l	vert_buffer_read, a0
	move.l	vert_char_read, a1
	move.w	(a1)+, d0
	cmp.l	vert_char_end, a1
	bne.s	.InChar

	move.l	vert_text_read, a2
	moveq.l	#0, d1
	move.b	(a2)+, d1
	cmp.l	#VertTextEnd, a2
	bne.s	.InText
	move.l	#VertText, a2
.InText:
	move.l	a2, vert_text_read

	move.l	#VertFont, a1
	lea.l	VertChars, a3
	move.b	-32(a3, d1.w), d1
	mulu.w	#36, d1
	add.w	d1, a1
	lea.l	36(a1), a2
	move.l	a2, vert_char_end
.InChar:
	move.l	a1, vert_char_read
	move.w	d0, (a0)
	move.w	d0, 760(a0)

; ***************************
; **                       **
; ** Point to new location **
; **                       **
; ***************************

	move.l	vert_buffer_read, a0
	addq.w	#2, a0
	cmp.l	#vert_buffer + 760, a0
	bne.s	.BufferOk
	move.l	#vert_buffer, a0
.BufferOk:
	move.l	a0, vert_buffer_read

	rts

	.data

VertText:
	dc.b	'THIS DEMO IS CALLED STEPPING BACK     '
	dc.b	'IT IS A BRAND NEW DEMO IN 2024 '
	dc.b	'BY THE MEGABUSTERS             '
	dc.b	'GUEST MUSIC BY AD FROM MPS       '
	dc.b	'GRAPHICS AND FONTS BY PANDAFOX      '
	dc.b	'CODE BY DJAYBEE WITH HINTS FROM TROED AND GWEM           '
	dc.b	'THIS DEMO IS LICENSED UNDER AGPL V3, '
	dc.b	'WITH ASSETS OPTIONALLY UNDER CC:BY-SA V4.  '
	dc.b	'MORE DETAILS AT HTTPS://GITHUB.COM/JBQUERU/STEPBACK         '
	dc.b	'FOR THE CREATION OF THIS DEMO, '
	dc.b	'DJAYBEE USED HATARI EMUTOS RMAC AND GCC.  '
	dc.b	'PANDAFOX USED ST-PAINT.  '
	dc.b	'AD USED MAXYMISER.  '
	dc.b	'              '
	dc.b	'              '
VertTextEnd:

VertChars:
	dc.b	0, 1, 0, 0, 0, 0, 0, 0
	dc.b	2, 3, 0, 0, 4, 5, 6, 7
	dc.b	8, 9, 10, 11, 12, 13, 14, 15
	dc.b	16, 17, 18, 0, 0, 0, 0, 19
	dc.b	20, 21, 22, 23, 24, 25, 26, 27
	dc.b	28, 29, 30, 31, 32, 33, 34, 35
	dc.b	36, 37, 38, 39, 40, 41, 42, 43
	dc.b	44, 45, 46

	.bss
	.even

vert_buffer_read:
	ds.l	1

vert_curve1:
	ds.l	1
vert_curve2:
	ds.l	1
vert_curve3:
	ds.l	1
vert_curve4:
	ds.l	1
vert_curve5:
	ds.l	1
vert_curve6:
	ds.l	1

vert_char_read:
	ds.l	1
vert_char_end:
	ds.l	1

vert_text_read:
	ds.l	1

vert_buffer:
	ds.w	2 * 380

	.data
	.even
VertFont:
	.incbin	"out/inc/vertical_scroll_font.bin"
	.include "out/inc/vertical_scroll_curves.s"
