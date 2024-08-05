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

	.data

	.even

SpritesBitmap:
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	.rept 2
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c000, $0000f0ff, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c000, $0000f0f0, $0000f000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c000, $0000f0ff, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c000, $0000f0f0, $0000f000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0ff, $000000ff, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000

	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	.rept 2
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0f0, $0000f0ff, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0ff, $0000f0f0, $0000f000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0f0, $0000f0ff, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0f0, $0000f0f0, $0000f000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0f0, $0000f0ff, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000

	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	.rept 2
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c00f, $0000f0ff, $000000ff, $0000f00f, $0002f001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0f0, $000000f0, $0000f0f0, $000000f0, $00020001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0f0, $0000f0ff, $000000ff, $0000f0f0, $0002f001, $80008000
	.endr
	.rept 2
	dc.l	$a000c0f0, $0000f0f0, $0000f0f0, $000000f0, $0002f001, $80008000
	.endr
	.rept 2
	dc.l	$a000c00f, $0000f0f0, $0000f0ff, $0000f00f, $0002f001, $80008000
	.endr
	.rept 2
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000
