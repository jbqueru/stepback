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
; ###                                 Init                                  ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

	.68000
	.bss
StartBss:				; start of BSS, so that we can clear it

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
	addq.l	#6, sp

	move.w	#0, -(sp)		; Term0
	trap	#1			; GemDos

MainSup:
	move.w	#$2700, sr		; turn all interrupts off in the CPU

; ###################
; ###################
; ###             ###
; ###  Clear BSS  ###
; ###             ###
; ###################
; ###################

	lea.l	StartBss, a0
	lea.l	EndBss, a1
.ClearBss:
	clr.b	(a0)+			; clear one byte, advance
	cmpa.l	a1, a0			; reached the end of BSS?
	bne.s	.ClearBss		; if not, keep going

; ############################
; ############################
; ###                      ###
; ###  Save machine state  ###
; ###                      ###
; ############################
; ############################

; *************************
; **                     **
; ** Save graphics state **
; **                     **
; *************************

	move.b	$ffff8201.w, save_8201	; framebuffer address high byte
	move.b	$ffff8203.w, save_8203	; framebuffer address medium byte
	move.b	$ffff820a.w, save_820a	; refresh rate
	move.b	$ffff8260.w, save_8260	; resolution

	lea.l	$ffff8240.w, a0		; palette base address
	lea.l	save_palette, a1
	moveq.l	#15, d7
.SavePalette:
	move.w	(a0)+, (a1)+
	dbra	d7, .SavePalette

; **********************
; **                  **
; ** Save sound state **
; **                  **
; **********************

	lea.l	save_sound, a0
	moveq.l	#13, d7
.SaveSound:
	move.b	d7, $ffff8800.w		; set register to read
	move.b	$ffff8800.w, (a0)+	; read register
	dbra	d7, .SaveSound

; **************************
; **                      **
; ** Save interrupt state **
; **                      **
; **************************

	move.b	$fffffa07.w, save_fa07	; MFP interrupt enable A
	move.b	$fffffa09.w, save_fa09	; MFP interrupt enable B

	move.l	$70.w, save_vbl		; VBL

; #########################
; #########################
; ###                   ###
; ###  Init interrupts  ###
; ###                   ###
; #########################
; #########################

	move.b	#0, $fffffa07.w		; disable MFP interrupts A
	move.b	#0, $fffffa09.w		; disable MFP interrupts B

	move.l	#VBL_Empty, $70.w	; install our own VBL handler

; #######################
; #######################
; ###                 ###
; ###  Init graphics  ###
; ###                 ###
; #######################
; #######################

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

	move.l	a0, fb_front		; address of one framebuffer
	lea.l	32000(a0), a0
	move.l	a0, fb_back		; address of other framebuffer

	lsr.l	#8, d0			; \
	move.b	d0, $ffff8203.w		; | set hardware framebuffer address
	lsr.l	#8, d0			; | (takes effect after VBL)
	move.b	d0, $ffff8201.w		; /

	stop	#$2300			; Wait for VBL (might be a suprious queued one)
	stop	#$2300			; Wait for VBL

; ***********************
; **                   **
; ** Set graphics mode **
; **                   **
; ***********************

	move.b	#2, $ffff820a.w		; switch to 50 Hz
	move.b	#0, $ffff8260.w		; switch to mode 0

; *************************
; **                     **
; ** Set up intro screen **
; **                     **
; *************************

	lea.l	IntroScreen + 2, a0
	lea.l	$ffff8240.w, a1
	moveq.l	#15, d7
IntroPaletteCopy:
	move.w	(a0), (a1)+
	dbra	d7, IntroPaletteCopy

	lea.l	IntroScreen + 34, a0
	movea.l	fb_back, a1
	move.w	#999, d7
CopyIntroScreen:
	.rept	8
	move.l	(a0)+, (a1)+
	.endr
	dbra	d7, CopyIntroScreen

; ***********************
; **                   **
; ** Swap framebuffers **
; **                   **
; ***********************

	move.l	fb_back, d0
	move.l	fb_front, fb_back
	move.l	d0, fb_front
	lsr.l	#8, d0
	move.b	d0, $ffff8203.w
	lsr.l	#8, d0
	move.b	d0, $ffff8201.w

; ####################
; ####################
; ###              ###
; ###  Init music  ###
; ###              ###
; ####################
; ####################

	bsr	AudioInit
	move.l	#VBL_Music, $70.w

	move.w	#0, d7
NextFade:
	move.l	count_vbl, d0
WaitFade:
	cmp.l	count_vbl, d0
	beq.s	WaitFade

	addq.w	#1, d7

	lea.l	IntroScreen + 2, a0
	lea.l	2(a0), a1
	lea.l	$ffff8242.w, a2

	moveq.l	#1, d6
NextColor:

	cmp.w	#32, d7
	bge.s	BlueFull

	move.w	(a0), d0
	move.w	(a1), d1
	andi.w	#$7, d0
	andi.w	#$7, d1
	sub.w	d0, d1
	muls.w	d7, d1
	addi.w	#$10, d1
	asr.w	#5, d1
	add.w	d0, d1
	bra.s	BlueDone
BlueFull:
	move.w	(a1), d1
	andi.w	#$7, d1
BlueDone:
	move.w	d1, d2

	cmp.w	#24, d7
	ble.s	RedNone
	cmp.w	#56, d7
	bge.s	RedFull

	move.w	(a0), d0
	move.w	(a1), d1
	andi.w	#$700, d0
	andi.w	#$700, d1
	sub.w	d0, d1
	move.w	d7, d5
	subi.w	#24, d5
	muls.w	d5, d1
	addi.w	#$1000, d1
	asr.w	#5, d1
	add.w	d0, d1
	andi.w	#$700, d1
	bra.s	RedDone
RedNone:
	move.w	(a0), d1
	andi.w	#$700, d1
	bra.s	RedDone
RedFull:
	move.w	(a1), d1
	andi.w	#$700, d1
RedDone:
	add.w	d1, d2

	cmp.w	#48, d7
	ble.s	GreenNone

	move.w	(a0), d0
	move.w	(a1), d1
	andi.w	#$70, d0
	andi.w	#$70, d1
	sub.w	d0, d1
	move.w	d7, d5
	subi.w	#48, d5
	muls.w	d5, d1
	addi.w	#$100, d1
	asr.w	#5, d1
	add.w	d0, d1
	andi.w	#$70, d1
	bra.s	GreenDone
GreenNone:
	move.w	(a0), d1
	andi.w	#$70, d1
GreenDone:
	add.w	d1, d2

	move.w	d2, (a2)+

	addq.w	#2, a1

	addq.w	#1, d6
	cmp.w	#16, d6
	bne.w	NextColor
	cmp.w	#80, d7
	bne.w	NextFade



; #########################
; #########################
; ###                   ###
; ###  Init demo parts  ###
; ###                   ###
; #########################
; #########################

	bsr	VertInit
	bsr	HorizInit
	bsr	SpriteInit
	bsr	NamesInit

	lea.l	intro_data, a0
	moveq.l	#0, d0
	moveq.l	#24, d7
IntroSetupLoopY:
	moveq.l	#19, d6
IntroSetupLoopX:
	move.w	d0, (a0)+
	addq.w	#1, d0
	move.w	d0, (a0)+
	addq.w	#7, d0
	dbra	d6, IntroSetupLoopX
	addi.w	#1120, d0
	dbra.w	d7, IntroSetupLoopY

; ****************************
; **                        **
; ** Wait for intro timeout **
; **                        **
; ****************************
	move.l	#$cafe, d7
	move.w	#1000, d6
	moveq.l	#11, d5
WaitIntro:
	move.l	count_vbl, d0
WaitIntoVBL:
	cmp.l	count_vbl, d0
	beq.s	WaitIntoVBL

	cmp.b	#$39, $fffffc02.w
	beq	Exit

	cmp.l	#613 - 80, d0
	blt.s	WaitIntro


	move.l	d5, d2
EraseSquare:
	lea.l	intro_data, a0

	move.l	d7, d4
	divu.w	d6, d4
	swap	d4
	add.w	d4, d4

	subq.w	#1, d6
	move.w	d6, d0
	add.w	d0, d0
	move.w	(a0, d4.w), d3
	move.w	(a0, d0.w), (a0, d4.w)

	movea.l	fb_front, a1
	adda.w	d3, a1
	moveq.l	#0, d0
	movep.l	d0, 0(a1)
	movep.l	d0, 160(a1)
	movep.l	d0, 320(a1)
	movep.l	d0, 480(a1)
	movep.l	d0, 640(a1)
	movep.l	d0, 800(a1)
	movep.l	d0, 960(a1)
	movep.l	d0, 1120(a1)

	ror.w	#5, d7
	addi.w	#$50da, d7

	dbra.w	d2, EraseSquare
	eori.w	#7, d5


	cmp.l	#613, count_vbl
	blt.w	WaitIntro

; *****************
; **             **
; ** Set palette **
; **             **
; *****************

	moveq.l	#15, d7
	lea.l	PaletteData, a0
	lea.l	$ffff8240.w, a1
PaletteCopy:
	move.w	(a0)+, (a1)+
	dbra	d7, PaletteCopy

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

	stop	#$2300			; Note: the music is played there

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

	bsr	SpriteErase
	bsr	NamesErase
	bsr	VertDraw
	bsr	HorizDraw
	bsr	SpriteDraw
	bsr	NamesDraw

; ********************
; **                **
; ** Check keyboard **
; **                **
; ********************

	cmp.b	#$39, $fffffc02.w
	beq.s	Exit

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
; ###                                 Exit                                  ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

Exit:
	move.l	#VBL_Empty, $70.w
	move.b	save_8201, $ffff8201.w
	move.b	save_8203, $ffff8203.w

	stop	#$2300
	move.b	save_820a, $ffff820a.w
	move.b	save_8260, $ffff8260.w
	lea.l	save_palette, a0
	lea.l	$ffff8240.w, a1
	moveq.l	#15, d7
.RestorePalette:
	move.w	(a0)+, (a1)+
	dbf	d7, .RestorePalette

.RestoreSound:
	lea.l	save_sound, a0
	moveq.l	#13, d7
.SaveSound:
	move.b	d7, $ffff8800.w
	move.b	(a0)+, $ffff8802.w
	dbra	d7, .SaveSound

	move.w	#$2700, sr

	move.b	save_fa07, $fffffa07.w
	move.b	save_fa09, $fffffa09.w
	move.l	save_vbl, $70.w

	rts

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

VBL_Empty:
	rte

VBL_Music:
	addq.l	#1, count_vbl
	movem.l	d0/a0-a1, -(sp)
	bsr.s	AudioPlay
	movem.l	(sp)+, d0/a0-a1
	rte

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
	dc.w	$022, $233, $613, $746
	dc.w	$234, $767, $750, $772
	dc.w	$345, $542, $457, $247
	dc.w	$556, $412, $777, $222

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
count_vbl:
	.ds.l	1

save_palette:
	.ds.w	16

save_vbl:
	.ds.l	1

save_8201:
	.ds.b	1
save_8203:
	.ds.b	1
save_820a:
	.ds.b	1
save_8260:
	.ds.b	1
save_sound:
	.ds.b	14
save_fa07:
	.ds.b	1
save_fa09:
	.ds.b	1

; ****************
; **            **
; ** Intro data **
; **            **
; ****************
	.even
intro_data:
	.ds.w	1000

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

	.include	"audio.s"
	.include	"vertical_scroll.s"
	.include	"horizontal_scroll.s"
	.include	"sprite.s"
	.include	"names.s"

	.data
	.even
IntroScreen:
	.incbin		"LOGO.PI1"

	.bss
EndBss:					; end of BSS, clear to here
	.end
