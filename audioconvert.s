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

; 1 pattern of 16 beats of 5 VBL
; 1 pattern of 64 beats of 7 VBL
; 1 pattern of 17 beats of 5 VBL
; 23 patterns of 64 beats of 5 VBL

	.68000
	.text

	pea.l	MainSup
	move.w	#38, -(sp)		; SupExec
	trap	#14			; XBios
        addq.l  #6, sp

	move.w	#0, -(sp)
	move.l	#FileName, -(sp)
	move.w	#60, -(sp)
	trap	#1
	addq.l	#8, sp
	move.w	d0, FileHandle

	move.l	#RegDump, -(sp)
	move.l	#7973 * 14, -(sp)
	move.w	FileHandle, -(sp)
	move.w	#64, -(sp)
	trap	#1
	lea.l	12(sp), sp

	move.w	FileHandle, -(sp)
	move.w	#62, -(sp)
	trap #1
	addq.l	#4, sp

        move.w  #0, -(sp)
        trap	#1

MainSup:

; #########################
; #########################
; ###                   ###
; ###  Init interrupts  ###
; ###                   ###
; #########################
; #########################

	move.w	#$2700, sr		; turn all interrupts off in the CPU

	bsr	Music

; Music length:
; 1 pattern 16 * 5
; 1 pattern 64 * 7
; 1 pattern 17 * 5
; 23 patterns 64 * 5
	move.w	#7972, d0
	lea.l	RegDump, a0
PlayMusic:
	movem.l	d0/a0, -(sp)
	bsr	Music + 8
;	move.w	#13000, d0
Wait:
;	dbra	d0, Wait
	movem.l	(sp)+, d0/a0

	lea.l	$ffff8800.w, a1
	moveq.l	#13, d1
ReadReg:
	move.b	d1, (a1)
	move.b	(a1), (a0)+
	dbra	d1, ReadReg

	dbra	d0, PlayMusic
	bsr	Music + 4
        rts

Music:
	.incbin	"CLOUDYLJ.SND"

	.data
FileName:
	dc.b	"AREGDUMP.BIN", 0

	.bss
FileHandle:
	ds.w	1
RegDump:
	ds.b	7973 * 14

	.end
