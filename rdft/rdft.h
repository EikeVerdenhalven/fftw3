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

/* $Id: rdft.h,v 1.13 2002-07-28 20:10:59 stevenj Exp $ */

#include "ifftw.h"
#include "codelet.h"

/* problem.c: */
typedef struct {
     problem super;
     tensor sz, vecsz;
     R *I, *O;
     rdft_kind kind;
} problem_rdft;

int X(problem_rdft_p)(const problem *p);
#define RDFTP X(problem_rdft_p)  /* shorthand */

void X(rdft_zerotens)(tensor sz, R *I);
problem *X(mkproblem_rdft)(const tensor sz, const tensor vecsz,
			   R *I, R *O, rdft_kind kind);
problem *X(mkproblem_rdft_d)(tensor sz, tensor vecsz,
			     R *I, R *O, rdft_kind kind);
const char *X(rdft_kind_str)(rdft_kind kind);

/* verify.c: */
void X(rdft_verify)(plan *pln, const problem_rdft *p, uint rounds);

/* solve.c: */
void X(rdft_solve)(plan *ego_, const problem *p_);

/* plan.c: */
typedef void (*rdftapply) (plan *ego, R *I, R *O);

typedef struct {
     plan super;
     rdftapply apply;
} plan_rdft;

plan *X(mkplan_rdft)(size_t size, const plan_adt *adt, rdftapply apply);

#define MKPLAN_RDFT(type, adt, apply) \
  (type *)X(mkplan_rdft)(sizeof(type), adt, apply)

/* various solvers */

solver *X(mksolver_rdft_r2hc_direct)(kr2hc k, const kr2hc_desc *desc);
solver *X(mksolver_rdft_hc2r_direct)(khc2r k, const khc2r_desc *desc);
solver *X(mksolver_rdft_hc2hc_dit)(khc2hc k, const hc2hc_desc *desc);
solver *X(mksolver_rdft_hc2hc_ditbuf)(khc2hc k, const hc2hc_desc *desc);
solver *X(mksolver_rdft_hc2hc_dif)(khc2hc k, const hc2hc_desc *desc);
solver *X(mksolver_rdft_hc2hc_difbuf)(khc2hc k, const hc2hc_desc *desc);

void X(rdft_rank0_register)(planner *p);
void X(rdft_rank_geq2_register)(planner *p);
void X(rdft_indirect_register)(planner *p);
void X(rdft_vrank_geq1_register)(planner *p);
void X(rdft_vrank2_transpose_register)(planner *p);
void X(rdft_vrank3_transpose_register)(planner *p);
void X(rdft_buffered_register)(planner *p);
void X(rdft_generic_register)(planner *p);
void X(rdft_rader_hc2hc_register)(planner *p);
void X(rdft_rader_dht_register)(planner *p);
void X(rdft_r2hc_hc2r_register)(planner *p);
void X(dft_r2hc_register)(planner *p);
void X(rdft_nop_register)(planner *p);

/****************************************************************************/
/* problem2.c: */
/* an RDFT2 problem transforms a 1d real array r[sz.n] with stride
   sz.is to/from an "unpacked" complex array {rio,iio}[sz.n/2 + 1]
   with stride sz.os.  vecsz has the usual interpretation.  */
typedef struct {
     problem super;
     iodim sz;
     tensor vecsz;
     R *r, *rio, *iio;
     rdft_kind kind; /* R2HC or HC2R */
} problem_rdft2;

int X(problem_rdft2_p)(const problem *p);
#define RDFT2P X(problem_rdft2_p)  /* shorthand */

problem *X(mkproblem_rdft2)(iodim sz, const tensor vecsz,
			    R *r, R *rio, R *iio, rdft_kind kind);
problem *X(mkproblem_rdft2_d)(iodim sz, tensor vecsz,
			      R *r, R *rio, R *iio, rdft_kind kind);
int X(rdft2_inplace_strides)(const problem_rdft2 *p, uint vdim);

/* verify.c: */
void X(rdft2_verify)(plan *pln, const problem_rdft2 *p, uint rounds);

/* solve.c: */
void X(rdft2_solve)(plan *ego_, const problem *p_);

/* plan.c: */
typedef void (*rdft2apply) (plan *ego, R *r, R *rio, R *iio);

typedef struct {
     plan super;
     rdft2apply apply;
} plan_rdft2;

plan *X(mkplan_rdft2)(size_t size, const plan_adt *adt, rdft2apply apply);

#define MKPLAN_RDFT2(type, adt, apply) \
  (type *)X(mkplan_rdft2)(sizeof(type), adt, apply)

/* various solvers */

solver *X(mksolver_rdft2_r2hc_direct)(kr2hc k, const kr2hc_desc *desc);
solver *X(mksolver_rdft2_hc2r_direct)(khc2r k, const khc2r_desc *desc);

void X(rdft2_vrank_geq1_register)(planner *p);
void X(rdft2_buffered_register)(planner *p);
void X(rdft2_nop_register)(planner *p);

/****************************************************************************/

/* configurations */
void X(rdft_conf_standard)(planner *p);

