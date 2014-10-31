(*
 * Copyright (C) Galois, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *)

type t = unit

module Context = struct
  type t = unit
  let to_string _ = ""
  let of_string _ = ()
  let tag = None
  let root () = ()
  let default () = ()
end

let init () = ()
let new_node_context _ _ _ = ()
let root_context _ = ()

module Perm = struct
  let read _ _ _ _ = true
  let write _ _ _ _ = true
  let create _ _ _ _ = true
  let delete _ _ _ _ = true
  let chmod _ _ _ _ _ = true
  let relabelfrom _ _ _ _ = true
  let relabelto _ _ _ _ = true
  let override _ _ _ _ = true

  let bind _ _ _ _ _ _ = true
  let transition _ _ _ _ _ = true

  let introduce _ _ _ = true
  let stat _ _ _ = true
  let release _ _ _ = true
  let resume _ _ _ = true
  let chown_from _ _ _ = true
  let chown_to _ _ _ = true
  let chown_transition _ _ _ = true
  let retain_owner _ _ _ = true
  let make_priv_for _ _ _ = true
  let set_as_target _ _ _ = true
  let set_target _ _ _ = true
end

