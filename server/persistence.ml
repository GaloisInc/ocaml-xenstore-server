(*
 * Copyright (C) Citrix Systems Inc.
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
open Sexplib
open Lwt
open Xenstore
open Protocol

let ( |> ) a b = b a
let ( ++ ) f g x = f (g x)

let debug fmt = Logging.debug "persistence" fmt
let error fmt = Logging.error "persistence" fmt

module type VIEW = sig
  type t

  val create: unit -> t Lwt.t

  val read: t -> Protocol.Path.t -> Node.contents Lwt.t

  val write: t -> Protocol.Path.t -> Node.contents -> unit Lwt.t

  val rm: t -> Protocol.Path.t -> unit Lwt.t

  val merge: t -> string -> unit Lwt.t
end