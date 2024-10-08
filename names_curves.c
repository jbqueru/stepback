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

	printf(".data\n");
	printf(".even\n");

	printf("NameX1:\n");
	for (int t = 0; t < 201; t++) {
		int x = 199 * 4 * (1 - cos (t * 2 * M_PI / 201)) / 2 + 0.5;
		printf("\tdc.w\t%d\n", x);
	}
	printf("NameX1End:\n");

	printf("\n");

	printf("NameX2:\n");
	for (int t = 0; t < 51; t++) {
		int x = 40 * 4 * (1 - cos (t * 2 * M_PI / 51)) / 2 + 0.5;
		printf("\tdc.w\t%d\n", x);
	}
	printf("NameX2End:\n");

	printf("\n");

	printf("NameY1:\n");
	for (int t = 0; t < 201; t++) {
		int x = 150 * 4 * (1 - sin (t * 2 * M_PI / 201)) / 2 + 0.5;
		printf("\tdc.w\t%d\n", x);
	}
	printf("NameY1End:\n");

	printf("\n");

	printf("NameY2:\n");
	for (int t = 0; t < 53; t++) {
		int x = 30 * 4 * (1 - sin (t * 2 * M_PI / 53)) / 2 + 0.5;
		printf("\tdc.w\t%d\n", x);
	}
	printf("NameY2End:\n");

	printf("\n");
}
