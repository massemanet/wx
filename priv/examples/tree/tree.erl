%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 19 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('tree').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").
-include("../../../include/xwx.hrl").

-record(state,{menu1,menu2,tree,exit}).

start() ->
  WX      = wx:new(),
  XRC     = xwx:resources(?MODULE,["tree.xrc","treem.xrc"]),
  [Frame] = xwx:frames(WX,XRC,["Frame"]),
  [Exit]  = xwx:app_menu(Frame,[?wxID_EXIT]),
  [M1,M2] = xwx:menubar(XRC,Frame,"menubar1",["menuItem1","menuItem2"]),
  [Tree]  = xwx:treectrls(Frame,["treeCtrl"]),
  wxFrame:show(Frame),
  RootId = wxTreeCtrl:addRoot(Tree#xwx.object, "Root"),
  wxTreeCtrl:appendItem(Tree#xwx.object, RootId, "anItem"),
  loop(#state{menu1=M1,menu2=M2,tree=Tree,exit=Exit}).

-define(event(X,Y), #wx{id=_ID, event=#wxCommand{type=Y}} when _ID==X#xwx.id).

loop(S) ->
  receive
    #wx{event=#wxClose{}} ->
      io:format("Got ~p ~n", [close]),
      erlang:halt();
    ?event(S#state.tree,Act) ->
      io:format("Got ~p ~n", [{S#state.tree,Act}]),
      loop(S);
    ?event(S#state.exit,_) ->
      io:format("Got ~p ~n", [exit]),
      erlang:halt();
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      loop(S)
  end.
