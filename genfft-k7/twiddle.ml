(*
 * Copyright (c) 1997-1999 Massachusetts Institute of Technology
 * Copyright (c) 2000 Matteo Frigo
 * Copyright (c) 2000 Steven G. Johnson
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
 *)
(* $Id: twiddle.ml,v 1.3 2002-06-15 17:51:39 athena Exp $ *)

(* policies for loading/computing twiddle factors *)
open Complex
open Util

let square x = 
  if (!Magic.wsquare) then
    wsquare x
  else
    times x x

let rec is_pow_2 n = 
  n = 1 || ((n mod 2) = 0 && is_pow_2 (n / 2))

let rec log2 n = if n = 1 then 0 else 1 + log2 (n / 2)

let rec largest_power_of_2_smaller_than i =
  if (is_pow_2 i) then i
  else largest_power_of_2_smaller_than (i - 1)

let rec_array n f =
  let g = ref (fun i -> Complex.zero) in
  let a = Array.init n (fun i -> lazy (!g i)) in
  let h i = f (fun i -> Lazy.force a.(i)) i in
  begin
    g := h;
    h
  end

let load_reim sign w i = 
  let x = Complex.make (w (2 * i), w (2 * i + 1)) in
  if sign = 1 then x else Complex.conj x
  
(* various policies for computing/loading twiddle factors *)

let rec forall id combiner a b f =
    if (a >= b) then id
    else combiner (f a) (forall id combiner (a + 1) b f)

(* load all twiddle factors *)
let twiddle_policy_load_all =
  let bytwiddle n sign w f i =
    if i = 0 then 
      f i
    else
      Complex.times (load_reim sign w (i - 1)) (f i)
  and twidlen n = 2 * (n - 1)
  and twdesc n =
    "{\n" ^
    (forall "" (^) 1 n (fun i ->
      Printf.sprintf "{ TW_COS, 0, %d }, { TW_SIN, 0, %d },\n" i i)) ^
    "{ TW_NEXT, 1, 0 }\n}"
  in bytwiddle, twidlen, twdesc

(* shorthand for policies that only load W[0] *)
let policy_one mktw =
  let bytwiddle n sign w f = 
    let g = (mktw n (load_reim sign w)) in
    fun i -> Complex.times (g i) (f i)
  and twidlen n = 2
  and twdesc n =
    "{{ TW_COS, 0, 1 }, { TW_SIN, 0, 1 }, { TW_NEXT, 1, 0 }}"
  in bytwiddle, twidlen, twdesc
    
(* compute w^n = w w^{n-1} *)
let twiddle_policy_iter =
  policy_one (fun n ltw ->
    rec_array n (fun self i ->
      if i = 0 then Complex.one
      else if i = 1 then ltw (i - 1)
      else times (self (i - 1)) (self 1)))

(*
 * if n is even, compute w^n = (w^{n/2})^2, else
 *  w^n = w w^{n-1}
 *)
let twiddle_policy_square1 =
  policy_one (fun n ltw ->
    rec_array n (fun self i ->
      if i = 0 then Complex.one
      else if i = 1 then ltw (i - 1)
      else if ((i mod 2) == 0) then
	square (self (i / 2))
      else times (self (i - 1)) (self 1)))

(*
 * if n is even, compute w^n = (w^{n/2})^2, else
 * compute  w^n from w^{n-1}, w^{n-2}, and w
 *)
let twiddle_policy_square2 =
  policy_one (fun n ltw ->
    rec_array n (fun self i ->
      if i = 0 then Complex.one
      else if i = 1 then ltw (i - 1)
      else if ((i mod 2) == 0) then
	square (self (i / 2))
      else 
	wthree (self (i - 1)) (self (i - 2)) (self 1)))

(*
 * if n is even, compute w^n = (w^{n/2})^2, else
 *  w^n = w^{floor(n/2)} w^{ceil(n/2)}
 *)
let twiddle_policy_square3 =
  policy_one (fun n ltw ->
    rec_array n (fun self i ->
      if i = 0 then Complex.one
      else if i = 1 then ltw (i - 1)
      else if ((i mod 2) == 0) then
	square (self (i / 2))
      else times (self (i / 2)) (self (i - i / 2))))

let current_twiddle_policy = ref twiddle_policy_load_all

let twiddle_policy () = !current_twiddle_policy

let set_policy x = Arg.Unit (fun () -> current_twiddle_policy := x)

let undocumented = " Undocumented twiddle policy"

let speclist = [
  "-twiddle-load-all", set_policy twiddle_policy_load_all, undocumented;
  "-twiddle-iter", set_policy twiddle_policy_iter, undocumented;
  "-twiddle-square1", set_policy twiddle_policy_square1, undocumented;
  "-twiddle-square2", set_policy twiddle_policy_square2, undocumented;
  "-twiddle-square3", set_policy twiddle_policy_square3, undocumented;
] 
