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
	move.l	#vert_buffer, vert_read
	move.l	#VertFont, vert_font_read
	move.l	#VertFont + 2, vert_char_end
	move.l	#VertText, vert_text_read

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

	move.l	fb_back, a0
	move.l	vert_read, a1
	lea	100(a1), a2
	lea	200(a1), a3
	moveq.l	#19,d1
DrawVert:
	.rept	10
	move.w	(a1)+, d0
	move.w	d0, 8(a0)
	move.w	d0, 144(a0)
	move.w	(a2)+, d0
	move.w	d0, 24(a0)
	move.w	d0, 128(a0)
	move.w	(a3)+, d0
	move.w	d0, 40(a0)
	move.w	d0, 112(a0)
	add.w	#160, a0
	.endr
	dbra	d1, DrawVert

; *********************
; **                 **
; ** Insert new data **
; **                 **
; *********************

	move.l	vert_read, a0
	move.l	vert_font_read, a1
	move.w	(a1)+, d0
	cmp.l	vert_char_end, a1
	bne.s	InChar

	move.l	vert_text_read, a2
	moveq.l	#0, d1
	move.b	(a2)+, d1
	sub.b	#32, d1
	cmp.l	#EndVertText, a2
	bne.s	InText
	move.l	#VertText, a2
InText:
	move.l	a2, vert_text_read

	move.l	#VertFont, a1
	mulu.w	#36, d1
	add.w	d1, a1
	lea.l	36(a1), a2
	move.l	a2, vert_char_end
InChar:
	move.l	a1, vert_font_read
	move.w	d0, (a0)
	move.w	d0, 600(a0)

; ***************************
; **                       **
; ** Point to new location **
; **                       **
; ***************************

	move.l	vert_read, a0
	addq.w	#2, a0
	cmp.l	#vert_buffer + 600, a0
	bne.s	BufferOk
	move.l	#vert_buffer, a0
BufferOk:
	move.l	a0, vert_read

	rts

	.data
	.even

VertFont:
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000

	dcb.w	3,0

	dc.w	%0000111111111100
	dc.w	%0011100000011111
	dc.w	%0111000000001111
	dc.w	%0111000000000000
	dc.w	%1110000000000000
	dc.w	%1110000000000000
	dc.w	%1111100000011100
	dc.w	%1111111111111110
	dc.w	%1111100000011100
	dc.w	%1110000000000000
	dc.w	%1110000000000000
	dc.w	%0111000000000000
	dc.w	%0111000000001111
	dc.w	%0011100000011111
	dc.w	%0000111111111110

	dcb.w	3,0

	dc.w	%0000011111100000
	dc.w	%0001110000111000
	dc.w	%0011100000011100
	dc.w	%0111000000001110
	dc.w	%0110000000001110
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%0110000000001110
	dc.w	%0111000000001110
	dc.w	%0011100000011100
	dc.w	%0001110000111000
	dc.w	%0000011111100000

	dcb.w	3,0

	dc.w	%0001111111111000
	dc.w	%0011111001111100
	dc.w	%0111100000011110
	dc.w	%0111000000001110
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%1111100000011111
	dc.w	%1111111111111111
	dc.w	%1111100000011111
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%0111000000001110
	dc.w	%0111100000011110
	dc.w	%0111110000111110
	dc.w	%0011100000011100

	dcb.w	3,0

	dc.w	%0011100000011100
	dc.w	%0111110000111110
	dc.w	%0111100000011110
	dc.w	%0111000000001110
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%1111100000011111
	dc.w	%1111111111111111
	dc.w	%1111100000011111
	dc.w	%1110000000000111
	dc.w	%1110000000000111
	dc.w	%0111000000001110
	dc.w	%0111100000011110
	dc.w	%0111110000111110
	dc.w	%0011100000011100

	dcb.w	3,0

	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000000000000000
	dc.w	%0000000000000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000001111000000
	dc.w	%0000000000000000

	dcb.w	3,0

VertText:
	dc.b	'!"#$ ! !   !!! !!! !!!   ! ! !      '
EndVertText:

	.bss
	.even

vert_read:
	ds.l	1

vert_buffer:
	ds.w	2 * 300

vert_font_read:
	ds.l	1
vert_char_end:
	ds.l	1

vert_text_read:
	ds.l	1
