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

mkdir -p out/bin
mkdir -p out/inc
mkdir -p out/tos

cc vertical_scroll_curves.c -o out/bin/vertical_scroll_curves -lm
out/bin/vertical_scroll_curves > out/inc/vertical_scroll_curves.s

cc horizontal_scroll_curves.c -o out/bin/horizontal_scroll_curves -lm
out/bin/horizontal_scroll_curves > out/inc/horizontal_scroll_curves.s

cc names_curves.c -o out/bin/names_curves -lm
out/bin/names_curves > out/inc/names_curves.s

cc sprite_curves.c -o out/bin/sprite_curves -lm
out/bin/sprite_curves > out/inc/sprite_curves.s

cc vertical_font_convert.c -o out/bin/vertical_font_convert
out/bin/vertical_font_convert

cc horizontal_font_convert.c -o out/bin/horizontal_font_convert
out/bin/horizontal_font_convert > out/inc/horizontal_scroll_font.s

cc names_convert.c -o out/bin/names_convert
out/bin/names_convert

cc sprite_convert.c -o out/bin/sprite_convert
out/bin/sprite_convert

rmac -s -p -4 stepback.s -o out/tos/STEPBACK.PRG
chmod 664 out/tos/STEPBACK.PRG
upx -9 -q out/tos/STEPBACK.PRG

rm -rf out/stepback
mkdir -p out/stepback
cp out/tos/STEPBACK.PRG out/stepback
cp LICENSE LICENSE_ASSETS AGPL_DETAILS.md README.md out/stepback
cp blank.msa out/stepback/stepback.msa
if [ -d .git ]
then
  git bundle create -q out/stepback/stepback.bundle --branches --tags HEAD
fi

rm -rf out/src
mkdir -p out/src
cp $(ls -1 | grep -v ^out\$) out/src
(cd out && zip -9 -q stepback/src.zip src/*)
