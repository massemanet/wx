%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 17 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('colors').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").
-include("../../../include/xwx.hrl").

start() ->
  WX      = wx:new(),
  XRC     = xwx:resources(?MODULE,["colors.xrc"]),
  [Frame] = xwx:frames(WX,XRC,["Frame"]),
  [Exit]  = xwx:app_menu(Frame,[?wxID_EXIT]),
  [ST]    = xwx:statictexts(Frame,["staticText"]),
  [Red,Grn,Blu] = xwx:sliders(Frame,["slider_r","slider_g","slider_b"]),
  wxFrame:show(Frame),
  loop(Red,Grn,Blu,ST,Exit).

-define(event(X,Y), #wx{id=_ID, event=#wxCommand{type=Y}} when _ID==X#xwx.id).
loop(Red,Grn,Blu,ST,Exit) ->
  receive
    #wx{event=#wxClose{}} ->
      io:format("Got ~p ~n", [close]),
      erlang:halt();
    ?event(Red,command_slider_updated) ->
      Text = wxSlider:getValue(Red#xwx.object),
      io:format("Got ~p ~n", [{red,Text}]);
    ?event(Exit,_) ->
      io:format("Got ~p ~n", [exit]),
      erlang:halt();
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      io:fwrite("~p~n",[{Red,Grn,Blu,ST,Exit}])
  end,
  loop(Red,Grn,Blu,ST,Exit).
