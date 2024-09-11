#!/bin/sh
# Copyright 2024 Jean-Baptiste M. "JBQ" "Djaybee" Queru
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# As an added restriction, if you make the program available for
# third parties to use on hardware you own (or co-own, lease, rent,
# or otherwise control,) such as public gaming cabinets (whether or
# not in a gaming arcade, whether or not coin-operated or otherwise
# for a fee,) the conditions of section 13 will apply even if no
# network is involved.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# SPDX-License-Identifier: AGPL-3.0-or-later

mkdir -p tmp

cc vertical_scroll_curves.c -o tmp/vertical_scroll_curves -lm
tmp/vertical_scroll_curves > tmp/vertical_scroll_curves.s

cc horizontal_scroll_curves.c -o tmp/horizontal_scroll_curves -lm
tmp/horizontal_scroll_curves > tmp/horizontal_scroll_curves.s

cc names_curves.c -o tmp/names_curves -lm
tmp/names_curves > tmp/names_curves.s

cc sprite_curves.c -o tmp/sprite_curves -lm
tmp/sprite_curves > tmp/sprite_curves.s

cc vertical_font_convert.c -o tmp/vertical_font_convert
tmp/vertical_font_convert

cc horizontal_font_convert.c -o tmp/horizontal_font_convert
tmp/horizontal_font_convert > tmp/horizontal_scroll_font.s

cc names_convert.c -o tmp/names_convert
tmp/names_convert

cc sprite_convert.c -o tmp/sprite_convert
tmp/sprite_convert

mkdir -p out

~/code/rmac/rmac -s -v -p -4 stepback.s -o out/STEPBACK.PRG
