/*
 * Copyright (c) 2002 Matteo Frigo
 * Copyright (c) 2002 Steven G. Johnson
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* $Id: solve2.c,v 1.1 2002-07-28 20:10:59 stevenj Exp $ */

#include "rdft.h"

/* use the apply() operation for RDFT2 problems */
void X(rdft2_solve)(plan *ego_, const problem *p_)
{
     plan_rdft2 *ego = (plan_rdft2 *) ego_;
     const problem_rdft2 *p = (const problem_rdft2 *) p_;
     ego->apply(ego_, p->r, p->rio, p->iio);
}
