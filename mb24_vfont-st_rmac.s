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
; ###                      Vertical font for MB24 demo                      ###
; ###                                                                       ###
; ###                                                                       ###
; #############################################################################
; #############################################################################

; SEE mb24_vscroll file for full explanation

; This is an actual source file, this is not a generated file.

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
