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
; ###             Horizontal scrolltext for Stepping Back demo              ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; SEE stepback.s file for full explanation

	.text

; ********************
; **                **
; ** Initialization **
; **                **
; ********************
HorizInit:
	move.l	#HorizText, horiz_text_read
	move.l	#horiz_buffer, horiz_read
	move.l	#horiz_buffer, horiz_previous_read
	move.l	#HorizFont, horiz_font_read
	move.l	#HorizFont + 2, horiz_char_end
	move.l	#HorizontalCurve, horiz_curve
	move.l	fb_back, horiz_back
	move.l	fb_front, horiz_front

	rts

; *************************
; **                     **
; ** Draw to framebuffer **
; **                     **
; *************************
HorizDraw:

	movea.l	fb_back, a0

	movea.l	horiz_curve, a2
	moveq.l	#0, d0
	move.b	(a2)+, d0
	cmp.l	#HorizontalCurveEnd, a2
	bne.s	.InCurve
	lea.l	HorizontalCurve, a2
.InCurve:
	move.l	a2, horiz_curve
	mulu.w	#160, d0
	lea.l	2(a0, d0.w), a0

	movea.l	horiz_back, a2
	cmpa.l	a2, a0
	bge.s	.EraseTop
.EraseBottom:
	lea.l	72 * 160(a0), a2
	moveq.l	#0, d0
	moveq.l	#19, d1
.LoopBottom:
	move.w	d0, (a2)
	move.w	d0, 160(a2)
	move.w	d0, 320(a2)
	move.w	d0, 480(a2)
	move.w	d0, 640(a2)
	move.w	d0, 800(a2)
	move.w	d0, 960(a2)
	move.w	d0, 1120(a2)
	addq.w	#8, a2
	dbra	d1, .LoopBottom
	bra.s	.EraseDone
.EraseTop:
	moveq.l	#0, d0
	moveq.l	#19, d1
.LoopTop:
	move.w	d0, (a2)
	move.w	d0, 160(a2)
	move.w	d0, 320(a2)
	move.w	d0, 480(a2)
	move.w	d0, 640(a2)
	move.w	d0, 800(a2)
	move.w	d0, 960(a2)
	move.w	d0, 1120(a2)
	addq.w	#8, a2
	dbra	d1, .LoopTop
.EraseDone:

	move.l	horiz_front, horiz_back
	move.l	a0, horiz_front

	movea.l	horiz_read, a1
	moveq.l	#8, d0
Text0:
	moveq.l	#19, d1
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
	lea.l	1120(a0), a0
	lea.l	40(a1), a1
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

	rts

	.data

HorizText:
	dc.b	'THE MEGABUSTERS ARE BACK! '
	dc.b	'      '
	dc.b	'PANDAFOX AND DJAYBEE FROM THE MEGABUSTERS, IN '
	dc.b	'COLLABORATION WITH AD FROM MPS AS OUR MUSIC GUEST, '
	dc.b	'ARE BRINGING YOU A NEW MEGABUSTERS SCREEN IN 2024. '
	dc.b	'         '
	dc.b	'HEY! AD AT THE KEYBOARD! IT\'S BEEN A REAL PLEASURE '
	dc.b	'WORKING WITH THE GUYS FROM THE MEGABUSTERS! '
	dc.b	'WHEN PANDAFOX ASKED ME IF I HAD A LITTLE MUSIC IN STOCK, '
	dc.b	'I IMMEDIATELY ACCEPTED! WE WORKED IN A GREAT ATMOSPHERE, '
	dc.b	'DESPITE THE FACT THAT WE EACH LIVE IN A DIFFERENT COUNTRY... '
	dc.b	'I TAKE THIS OPPORTUNITY TO GREET ALL MY CONTACTS AND '
	dc.b	'PARTICULARLY MY FRIENDS FROM MPS AND ADN. KISSES! '
	dc.b	'            '
	dc.b	'IMPERATOR FROM THE MEBABUSTERS AT THE KEYBOARD, '
	dc.b	'THOUGH YOU MIGHT NOW KNOW ME BETTER AS PANDAFOX! '
	dc.b	'I AM GENUINELY VERY HAPPY TO PARTICIPATE IN A '
	dc.b	'NEW DEMO FROM MY FIRST GROUP, AFTER 30 YEARS! '
	dc.b	'MEGABUSTERS, THE GROUP I ENJOYED SO MUCH, THE '
	dc.b	'GROUP WHERE I GREW, WHERE I LEARNED EVERYTHING, '
	dc.b	'AND WITHOUT WHICH I WOULDN\'T BE WHERE I AM TODAY. '
	dc.b	'I\'D LIKE TO THANK ALL THE MEMBERS, ALL THOSE '
	dc.b	'EXTRAORDINARY INDIVIDUALS (IT HAD TO BE SAID,) '
	dc.b	'FOR THOSE UNFORGETTABLE YEARS IN THE ATARI '
	dc.b	'DEMOSCENE ADVENTURE. '
	dc.b	'SHOUT OUT TO MY ADOPTIVE GROUP SINCE 2016, HMD, '
	dc.b	'WHERE PASSIONATE MEMBERS COMING FROM DIFFERENT '
	dc.b	'GROUPS, JUST LIKE MYSELF, HAVE GATHERED TO '
	dc.b	'RELIVE THAT PASSION. '
	dc.b	'FINALLY, RESPECTFUL GREETINGS TO ALL THOSE OTHER '
	dc.b	'GROUPS THAT KEEP THE ATARI DEMOSCENE ALIVE IN 2024. '
	dc.b	'HAVE A GREAT SILLYVENTURE EVERYONE, ENJOY! '
	dc.b	'            '
	dc.b	'DJAYBEE AT THE KEYBOARD! I AM WRITING A DEMO SCROLLTEXT '
	dc.b	'FOR THE FIRST TIME IN 30 YEARS. IT\'S GOOD TO BE BACK. '
	dc.b	'    '
	dc.b	'FOR THIS DEMO, I WAS LUCKY TO BE ABLE TO COLLABORATE '
	dc.b	'WITH AD WHO COMPOSED THE SUPERB MUSIC, AND WITH PANDAFOX '
	dc.b	'WHO DID A GREAT JOB WITH ALL THE GRAPHICS '
	dc.b	'IN SPITE OF THE ANNOYINGLY SPECIFIC CONSTRAINTS '
	dc.b	'I FORCED ON HIM. '
	dc.b	'            '
	dc.b	'IN THE BIGGER PICTURE, I (DJAYBEE) WOULD LIKE TO '
	dc.b	'THANK ALL OF THE MEGABUSTERS FOR INTRODUCING ME TO '
	dc.b	'LARGE-SCALE CODING PROJECTS IN A WAY THAT KICKSTARTED '
	dc.b	'MY PROFESSIONAL LIFE. '
	dc.b	'PRINST AND TRONIC DESERVE SPECIFIC THANKS FOR GUIDING '
	dc.b	'MY FIRST STEPS IN ASSEMBLY. '
	dc.b	'FRIENDLY MENTIONS GO TO GRIZZO, THE SHADOW, YAHOO, '
	dc.b	'WASP, MOBY DICK, BINOUIT, OXWALD, JAILE, BART OF NOISE, '
	dc.b	'AND EVERST. '
	dc.b	'ANNE AND ALINE ALSO CONTRIBUTED TO THE SUCCESS OF '
	dc.b	'THE MEGABUSTERS. '
	dc.b	'LAST BUT NOT LEAST, HUGE THANKS TO PANDAFOX FOR BEING '
	dc.b	'A POSITIVE FORCE KEEPING THE MEGABUSTERS ALIVE, '
	dc.b	'AND FOR BEING SO PATIENT WITH ME EVEN THOUGH I HAD '
	dc.b	'CANCELED TWO DEMOS ON HIM ALREADY, ONE A LONG TIME AGO '
	dc.b	'AND ANOTHER ONE MORE RECENTLY. '
	dc.b	'             '
	dc.b	'THIS IS THE END OF THIS SCROLLTEXT, THANKS '
	dc.b	'FOR READING! WE WILL WRAP THIS UP AND GET '
	dc.b	'STARTED ALL OVER AGAIN! '
	dc.b	'                      '
EndHorizText:

	.bss
	.even

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

horiz_curve:
	ds.l	1

horiz_back:
	ds.l	1
horiz_front:
	ds.l	1

horiz_text_read:
	ds.l	1

horiz_buffer:
	ds.w	20 * 2 * 9 * 4

	.data
	.even

HorizChars:
	dc.l	Horiz32, Horiz33, Horiz34, Horiz39, Horiz39, Horiz39, Horiz39, Horiz39
	dc.l	Horiz40, Horiz41, Horiz44, Horiz44, Horiz44, Horiz45, Horiz46, Horiz47
	dc.l	Horiz48, Horiz49, Horiz50, Horiz51, Horiz52, Horiz53, Horiz54, Horiz55
	dc.l	Horiz56, Horiz57, Horiz58, Horiz63, Horiz63, Horiz63, Horiz63, Horiz63
	dc.l	Horiz64, Horiz65, Horiz66, Horiz67, Horiz68, Horiz69, Horiz70, Horiz71
	dc.l	Horiz72, Horiz73, Horiz74, Horiz75, Horiz76, Horiz77, Horiz78, Horiz79
	dc.l	Horiz80, Horiz81, Horiz82, Horiz83, Horiz84, Horiz85, Horiz86, Horiz87
	dc.l	Horiz88, Horiz89, Horiz90, HorizEnd

	.include "out/inc/horizontal_scroll_font.s"
	.include "out/inc/horizontal_scroll_curves.s"

