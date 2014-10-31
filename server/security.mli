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

type domid = int
type path = string    (* TODO: which path type to use? *)

module type S = sig
  type t
  (** A Xenstore security module instance. *)

  module Context : sig
    type t
    (** Security attributes of nodes in this module. *)

    val to_string : t -> string
    (** Convert a context to a string for storage. *)

    val of_string : string -> t
    (** Create a context from a string. *)

    val tag : string option
    (** A name unique to this module that is used to tag security contexts
        in a node's extended attributes.  If this is 'None' then security
        contexts should not be stored for this module. *)

    val root : unit -> t
    (** The initial context for the root node. *)

    val default : unit -> t
    (** The default or unlabeled context when none is present. *)
  end

  (* TODO: we should probably pass command line arguments here *)
  val init : unit -> t
  (** [init t] initializes this security module. *)

  val new_node_context : t -> path -> Context.t -> Context.t
  (** [new_node_context t path parent_context] computes a security
      context for a node at [path] with a parent having the
      security type [parent_context] *)

  (* TODO: what hooks do we need for value checking? *)

  (* Per-permission hook functions. *)
  module Perm : sig
    (** {2 Domain-Node Permissions} *)

    val read : t -> domid -> path -> Context.t -> bool
    (** [read t domid path context] returns false if [domid] does
        not have permission to read [path] with security [context]. *)

    val write : t -> domid -> path -> Context.t -> bool
    (** [write t domid path context] returns false if [domid] does
        not have permission to write [path] with security [context]. *)
  
    val create : t -> domid -> path -> Context.t -> bool
    (** [create t domid path context] returns false if [domid] does
        not have permission to create [path] with security [context]. *)
  
    val delete : t -> domid -> path -> Context.t -> bool
    (** [delete t domid path context] returns false if [domid] does
        not have permission to delete the node at [path] with
        security [context]. *)
  
    val chmod : t -> domid -> path -> Context.t -> string -> bool
    (** [chmod t domid path context dac_perms] returns false if [domid]
        does not have permission to change the DAC permissions of
        the node at [path] with security [context].
        
        Note that [dac_perms] is information for audit purposes only. *)
  
    val relabelfrom : t -> domid -> path -> Context.t -> bool
    (** [relabelfrom t domid path context] returns false if [domid]
        does not have permission to change the context of the
        node at [path] from [context]. *)
  
    val relabelto : t -> domid -> path -> Context.t -> bool
    (** [relabelto t domid path context] returns false if [domid]
        does not have permission to change the context of the
        node at [path] to [context]. *)

    val override : t -> domid -> path -> Context.t -> bool
    (** [override t domid path context] returns false if [domid]
        does not have permission to override the DAC permissions
        when accessing the node at [path] with security [context]. *)

    (** {2 Node-Node Permissions} *)

    val bind : t -> domid -> path -> Context.t -> path -> Context.t -> bool
    (** [bind t domid parent_path parent_context child_path child_context]
        returns false if creating a node at [child_path] with security
        type [child_context] with a parent node of [parent_path] having
        security type [parent_context] is not allowed.
        
        The permission is used to control the shape of Xenstore
        based on node contexts. *)

    val transition : t -> domid -> path -> Context.t -> Context.t -> bool
    (** [transition t domid path old new] returns false if the
        node at [path] is not allowed to change its context from
        [old] to [new]. *)

    (** {2 Domain-Domain Permissions} *)

    val introduce : t -> domid -> domid -> bool
    (** [introduce t sdomid tdomid] returns false if [sdomid]
        does not have permission to introduce [tdomid] to
        Xenstore. *)

    val stat : t -> domid -> domid -> bool
    (** [stat t sdomid tdomid] returns false if [sdomid] does
        not have permission to query whether [tdomid] has
        been introduced to Xenstore. *)

    val release : t -> domid -> domid -> bool
    (** [release t sdomid tdomid] returns false if [sdomid] does
        not have permission to un-introduce [tdomid] from
        Xenstore. *)

    val resume : t -> domid -> domid -> bool
    (** [resume t sdomid tdomid] returns false if [sdomid] does
        not have permission to send an XS_RESUME request for
        [tdomid].  Is this used currently? *)

    val chown_from : t -> domid -> domid -> bool
    (** [chown_from t sdomid tdomid] returns false if [sdomid]
        does not have permission to change DAC ownership of
        nodes from [tdomid]. *)

    val chown_to : t -> domid -> domid -> bool
    (** [chown_to t sdomid tdomid] returns false if [sdomid]
        does not have permission to change DAC ownership of
        nodes to [tdomid]. *)

    val chown_transition : t -> domid -> domid -> bool
    (** [chown_transition t sdomid tdomid] returns false if
        the policy does not allow changing a node's DAC ownership
        from [sdomid] to [tdomid]. *)

    (* XXX how do these work? *)
    val retain_owner : t -> domid -> domid -> bool
    val make_priv_for : t -> domid -> domid -> bool
    val set_as_target : t -> domid -> domid -> bool
    val set_target : t -> domid -> domid -> bool
  end
end
