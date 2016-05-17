%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 16 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('due').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").
-include("../../../include/xwx.hrl").

start() ->
  Dir = filename:dirname(proplists:get_value(source,due:module_info(compile))),
  Files = ["due.xrc","duem.xrc"],
  WX = wx:new(),
  XRC = xwx:resources(Dir,Files),
  [Frame] = xwx:frames(WX,XRC,["Frame"]),
  [Exit] = xwx:app_menu(Frame,[?wxID_EXIT]),
  [M1,M2] = xwx:menubar(XRC,Frame,"menubar1",["menuItem1","menuItem2"]),
  [But] = xwx:buttons(Frame,["button1"]),
  [Txt] = xwx:textctrls(Frame,["textCtrl1"]),
  [CBx] = xwx:comboboxes(Frame,["comboBox1"]),
  wxFrame:show(Frame),
  loop(M1,M2,But,Txt,CBx,Exit).

-define(event(X,Y), #wx{id=_ID, event=#wxCommand{type=Y}} when _ID==X#xwx.id).
loop(MI1,MI2,But,Txt,CBx,Exit) ->
  receive
    #wx{event=#wxClose{}} ->
      io:format("Got ~p ~n", [close]);
    ?event(MI1,_) ->
      io:format("Got ~p ~n", [menu_item1]);
    ?event(MI2,_) ->
      io:format("Got ~p ~n", [menu_item2]);
    ?event(But,_) ->
      io:format("Got ~p ~n", [button]);
    ?event(Txt,_) ->
      io:format("Got ~p ~n", [text_ctrl]);
    ?event(CBx,_) ->
      io:format("Got ~p ~n", [combobox]);
    ?event(Exit,_) ->
      io:format("Got ~p ~n", [exit]);
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      io:fwrite("~p~n",[{MI1,MI2,But,Txt,CBx,Exit}])
  end,
  loop(MI1,MI2,But,Txt,CBx,Exit).
