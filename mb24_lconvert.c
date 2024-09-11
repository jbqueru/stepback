/*
 * Copyright 2024 Jean-Baptiste M. "JBQ" "Djaybee" Queru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * As an added restriction, if you make the program available for
 * third parties to use on hardware you own (or co-own, lease, rent,
 * or otherwise control,) such as public gaming cabinets (whether or
 * not in a gaming arcade, whether or not coin-operated or otherwise
 * for a fee,) the conditions of section 13 will apply even if no
 * network is involved.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

// SPDX-License-Identifier: AGPL-3.0-or-later

#include <stdio.h>
#include <math.h>

unsigned char pi1[32034];

unsigned char rawpixels[320][200];

unsigned char logo[7 * 8 * 104];

unsigned char map_colors[] = {0, 2, 1, 4, 8, 12, 5, 3, 6, 7, 9, 10, 11, 13, 14, 15};

void main() {
	FILE* inputfile = fopen("mb24_gfx.pi1", "rb");
	fread(pi1, 1, 32034, inputfile);

	for (int y = 0; y < 200; y++) {
		for (int x = 0; x < 320; x++) {
			int byteoffset = 34;
			byteoffset += (x / 16) * 8;
			byteoffset += (x / 8) % 2;
			byteoffset += y * 160;

			int bitoffset = 7 - (x % 8);

			rawpixels[x][y] =
				(((pi1[byteoffset] >> bitoffset) & 1)) +
				(((pi1[byteoffset + 2] >> bitoffset) & 1) * 2) +
				(((pi1[byteoffset + 4] >> bitoffset) & 1) * 4) +
				(((pi1[byteoffset + 6] >> bitoffset) & 1) * 8);
		}
	}

	for (int i = 0; i < 12 * 2 * 60; i++) {
		logo[i] = 0;
	}

	for (int y = 0; y < 104; y++) {
		for (int x = 0; x < 97; x++) {
			unsigned int c = map_colors[rawpixels[x + 81][y + 96]];
			if (c & 1) {
				logo[(x / 16) * 8 + (x & 8) / 8 + y * 56 + 0] |= (0x80 >> (x & 7));
			}
			if (c & 2) {
				logo[(x / 16) * 8 + (x & 8) / 8 + y * 56 + 2] |= (0x80 >> (x & 7));
			}
			if (c & 4) {
				logo[(x / 16) * 8 + (x & 8) / 8 + y * 56 + 4] |= (0x80 >> (x & 7));
			}
			if (c & 8) {
				logo[(x / 16) * 8 + (x & 8) / 8 + y * 56 + 6] |= (0x80 >> (x & 7));
			}
		}
	}


	FILE* outputfile1 = fopen("tmp/mb24_lbitmap.bin", "wb");
	fwrite(logo, 1, 7 * 8 * 104, outputfile1);
	fclose(outputfile1);
}
