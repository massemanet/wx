%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 19 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('colors_oc').
-author('masse').
-export([start/0,start/1]).

start() ->
  start("/opt/X11/share/X11/rgb.txt").

start(Filename) ->
  [{N,mk_oc(R,G,B)} || {R,G,B,N} <- get_rgbn(Filename)].

mk_oc(R,G,B) ->
  <<R1:1,R2:1,R3:1,R4:1,R5:1,R6:1,R7:1,R8:1>> = <<R>>,
  <<G1:1,G2:1,G3:1,G4:1,G5:1,G6:1,G7:1,G8:1>> = <<G>>,
  <<B1:1,B2:1,B3:1,B4:1,B5:1,B6:1,B7:1,B8:1>> = <<B>>,
  {oc(R1,G1,B1),oc(R2,G2,B2),oc(R3,G3,B3),oc(R4,G4,B4),
   oc(R5,G5,B5),oc(R6,G6,B6),oc(R7,G7,B7),oc(R8,G8,B8)}.

oc(R,G,B) ->
  <<I:3>> = <<R:1,G:1,B:1>>,
  I.

get_rgbn(Filename) ->
  {ok,Raw} = file:read_file(Filename),
  Lines = string:tokens(binary_to_list(Raw),"\n"),
  ColorsColorNames = [string:tokens(L,"\t") || L <- Lines],
  RGB_N = [{string:tokens(Cs," "),CN} || [Cs,CN] <- ColorsColorNames],
  [{l2i(R),l2i(G),l2i(B),N} || {[R,G,B],N} <- RGB_N, string:str(N," ")==0].

l2i(L) -> list_to_integer(L).
