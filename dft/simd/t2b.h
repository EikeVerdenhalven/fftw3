/*
 * Copyright (c) 2003, 2007-14 Matteo Frigo
 * Copyright (c) 2003, 2007-14 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#ifndef __DFT_SIMD_T2B_H__
#define __DFT_SIMD_T2B_H__
#ifdef GENUS
#error GENUS already defined!!
#endif

#include SIMD_HEADER

#undef LD
#define LD LDA
#undef ST
#define ST STA

#define VTW VTW2
#define TWVL TWVL2
#define BYTW BYTW2
#define BYTWJ BYTWJ2

#define GENUS XSIMD(dft_t2bsimd_genus)
extern const ct_genus GENUS;

#endif
