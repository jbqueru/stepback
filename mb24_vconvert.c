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

char charorder[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:!?()/@- ";

unsigned char bigfont[2 * 18 * 95];

void main() {
	FILE* inputfile = fopen("mb24_fonts.pi1", "rb");
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

	int s = 0;
	for (char c = ' '; c <= '~'; c++) {
		int n = -1;
		for (int i = 0; i < sizeof charorder; i++) {
			if (charorder[i] == c) {
				n = i;
				break;
			}
		}
		if (n < 0) continue;
		int x0 = (n % 18) * 17;
		int y0 = (n / 18) * 19;
		for (int y = 0; y < 18; y++) {
			for (int b = 0; b < 2; b++) {
				unsigned long o = 0;
				for (int x = 0; x < 8; x++) {
					o <<= 1;
					if (rawpixels[x0 + b * 8 + x][y0 + y] == 7) {
						o |= 1;
					}
				}
				bigfont[b + y * 2 + s] = o;
			}
		}
		s += 36;
	}

	FILE* outputfile1 = fopen("tmp/mb24_vfont.bin", "wb");
	fwrite(bigfont, 1, s, outputfile1);
	fclose(outputfile1);
}
