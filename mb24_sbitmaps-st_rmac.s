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
	.rept 3
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	.rept 14
	dc.l	$a000c000, $00000000, $00000000, $00000000, $00020001, $80008000
	.endr
	dc.l	$bfffc000, $ffff0000, $ffff0000, $ffff0000, $fffe0001, $80008000
	dc.l	$8000ffff, $0000ffff, $0000ffff, $0000ffff, $0000ffff, $80008000
	dc.l	$ffffffff, $ffffffff, $ffffffff, $ffffffff, $ffffffff, $80008000
	.endr
