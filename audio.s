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

AudioInit:
	move.l	#Music, audio_pointer
	rts

AudioPlay:
	move.l	audio_pointer, a0

	moveq.l	#13, d0
	lea.l	$ffff8800.w, a1
CopyReg:
	move.b	d0, (a1)
	move.b	(a0)+, 2(a1)
	dbra	d0, CopyReg

	cmpa.l	#MusicEnd, a0
	bne.s	InMusic
	lea.l	Music + (16 * 5 + 64 * 7 + 17 * 5 + 10 * 64 * 5) * 14, a0
InMusic:
	move.l	a0, audio_pointer
	rts

	.bss
	.even

audio_pointer:
	ds.l	1

	.data
	.even
Music:
	.incbin	"AREGDUMP.BIN"
MusicEnd:
