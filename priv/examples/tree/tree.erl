%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 19 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('tree').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").
-include("../../../include/xwx.hrl").

start() ->
  WX      = wx:new(),
  XRC     = xwx:resources(?MODULE,["tree.xrc"]),
  [Frame] = xwx:frames(WX,XRC,["Frame"]),
  [Tree]  = xwx:treectrls(Frame,["treeCtrl"]),
  [Exit]  = xwx:app_menu(Frame,[?wxID_EXIT]),
  wxFrame:show(Frame),
  RootId = wxTreeCtrl:addRoot(Tree#xwx.object, "Root"),
  wxTreeCtrl:appendItem(Tree#xwx.object, RootId, "anItem"),
  loop(Tree,Exit).

-define(event(X,Y), #wx{id=_ID, event=#wxCommand{type=Y}} when _ID==X#xwx.id).

loop(Tree,Exit) ->
  receive
    #wx{event=#wxClose{}} ->
      io:format("Got ~p ~n", [close]),
      erlang:halt();
    ?event(Tree,Act) ->
      io:format("Got ~p ~n", [{Tree,Act}]),
      loop(Tree,Exit);
    ?event(Exit,_) ->
      io:format("Got ~p ~n", [exit]),
      erlang:halt();
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      loop(Tree,Exit)
  end.
