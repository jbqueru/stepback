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

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                               Init Code                               ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.68000
	.text

; #####################
; #####################
; ###               ###
; ###  Entry point  ###
; ###               ###
; #####################
; #####################

	pea.l	MainSup
	move.w	#38, -(sp)		; SupExec
	trap	#14			; XBios

MainSup:

; #########################
; #########################
; ###                   ###
; ###  Init interrupts  ###
; ###                   ###
; #########################
; #########################

	move.w	#$2700, sr		; turn all interrupts off in the CPU

	move.b	#0, $fffffa07.w		; disable MFP interrupts A
	move.b	#0, $fffffa09.w		; disable MFP interrupts B

	move.l	#VBL_Handler, $70.w	; install our own VBL handler

; TODO: clear BSS

; #######################
; #######################
; ###                 ###
; ###  Init graphics  ###
; ###                 ###
; #######################
; #######################

	stop	#$2300			; wait for a VBL

; TODO: switch to empty framebuffer

; ***********************
; **                   **
; ** Set graphics mode **
; **                   **
; ***********************

	move.b	#2, $ffff820a.w		; switch to 50 Hz
	move.b	#0, $ffff8260.w		; switch to mode 0

; *****************
; **             **
; ** Set palette **
; **             **
; *****************

	moveq.l	#15, d0
	lea.l	PaletteData, a0
	lea.l	$ffff8240.w, a1
PaletteCopy:
	move.w	(a0)+, (a1)+
	dbra	d0, PaletteCopy

; ***********************************
; **                               **
; ** Prepare framebuffer addresses **
; **                               **
; ***********************************

	lea.l	fb_raw, a0
	move.l	a0, d0			; \
	add.l	#$ff, d0		; | align framebuffer on 256 bytes
	move.b	#$00, d0		; /
	movea.l	d0, a0

	move.l	a0, fb_front
	adda.w	#32000, a0
	move.l	a0, fb_back

; #########################
; #########################
; ###                   ###
; ###  Init demo parts  ###
; ###                   ###
; #########################
; #########################

	bsr	AudioInit
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

; ****************
; **            **
; ** Play Music **
; **            **
; ****************

	bsr	AudioPlay

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

; ***********************
; **                   **
; ** Invoke demo parts **
; **                   **
; ***********************

	bsr	LogoErase
	bsr	SpritesErase

	move.w	#$744, d0
	bsr.s	TimeShow

	bsr	VertDraw

	move.w	#$474, d0
	bsr.s	TimeShow

	bsr	HorizDraw

	move.w	#$447, d0
	bsr.s	TimeShow

	bsr	LogoDraw

	move.w	#$774, d0
	bsr.s	TimeShow

	bsr	SpritesDraw

	move.w	#$777, d0
	bsr.s	TimeShow

	move.w	#670, d0
.Wait:
	dbra	d0, .Wait

;	move.w	#$777, $ffff8240.w


; ************************
; **                    **
; ** Back to loop start **
; **                    **
; ************************

	bra	MainLoop

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                          Interrupt handlers                           ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; #####################
; #####################
; ###               ###
; ###  VBL Handler  ###
; ###               ###
; #####################
; #####################

VBL_Handler:
	move.w	PaletteData, $ffff8240.w
	rte

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                           Helper functions                            ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; ######################
; ######################
; ###                ###
; ###  Time display  ###
; ###                ###
; ######################
; ######################

TimeShow:
	rts
	move.w	d0, $ffff8240.w
	moveq.l	#39, d0			; 1 nop
.Loop:
	dbra	d0, .Loop		; 40 * 3 + 1 = 121 nop
	move.w	PaletteData, $ffff8240.w ; 6 nop
	rts

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                                 Data                                  ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.data
	.even

; *************
; **         **
; ** Palette **
; **         **
; *************

PaletteData:
	dc.w	$112, $234, $403, $526
	dc.w	$322, $667, $556, 0
	dc.w	$533, 0, 0, 0
	dc.w	$744, 0, 0, $666

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                               Variables                               ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.bss
	.even

; ******************
; **              **
; ** Framebuffers **
; **              **
; ******************

fb_front:
	.ds.l	1
fb_back:
	.ds.l	1

fb_raw:
	.ds.b	64255

; #############################################################################
; #############################################################################
; ###                                                                       ###
; ###                                                                       ###
; ###                              Demo parts                               ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.include	"mb24_audio-st_rmac.s"
	.include	"mb24_vscroll-st_rmac.s"
	.include	"mb24_hscroll-st_rmac.s"
	.include	"mb24_logo-st_rmac.s"
	.include	"mb24_sprites-st_rmac.s"

	.end
