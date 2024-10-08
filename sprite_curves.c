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

void main() {
	printf("\n");
	printf("; This is a generated file.\n");
	printf("; For AGPLv3, this is Object Code, not Source Code.\n");
	printf("; DO NOT EDIT, DO NO SUBMIT.\n");
	printf("\n");

	printf("\t.data\n");
	printf("\n");

	printf("SpriteX:\n");
	for (int t = 0; t < 251; t++) {
		int x = 4 + 215 * (1 - cos (t * 2 * M_PI / 251)) / 2 + 0.5;
		printf("\tdc.b\t%d\n", x);
	}
	printf("SpriteXEnd:\n");

	printf("\n");
	printf("\t.even\n");
	printf("\n");

	printf("SpriteY1:\n");
	for (int t = 0; t < 127; t++) {
		int x = 36 * 8 * (1 - cos (t * 2 * M_PI / 127)) / 2 + 0.5;
		printf("\tdc.w\t%d\n", x);
	}
	printf("SpriteY1End:\n");

	printf("\n");

	printf("SpriteY2:\n");
	for (int t = 0; t < 601; t++) {
		int x = 60 * 8 * (1 - cos (t * 2 * M_PI / 601)) / 2 + 0.5;
		printf("\tdc.w\t%d\n", x);
	}
	printf("SpriteY2End:\n");

}
