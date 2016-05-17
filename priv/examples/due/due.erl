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
  WX      = wx:new(),
  XRC     = xwx:resources(?MODULE,["due.xrc","duem.xrc"]),
  [Frame] = xwx:frames(WX,XRC,["Frame"]),
  [Exit]  = xwx:app_menu(Frame,[?wxID_EXIT]),
  [SB]    = xwx:statusbar(Frame,["statusBar"]),
  [ST]    = xwx:statictexts(Frame,["staticText1"]),
  [M1,M2] = xwx:menubar(XRC,Frame,"menubar1",["menuItem1","menuItem2"]),
  [But]   = xwx:buttons(Frame,["button1"]),
  [Txt]   = xwx:textctrls(Frame,["textCtrl1"]),
  [CBx]   = xwx:comboboxes(Frame,["comboBox1"]),
  wxFrame:show(Frame),
  loop(M1,M2,But,Txt,CBx,SB,ST,Exit).

-define(event(X,Y), #wx{id=_ID, event=#wxCommand{type=Y}} when _ID==X#xwx.id).
loop(MI1,MI2,But,Txt,CBx,SB,ST,Exit) ->
  receive
    #wx{event=#wxClose{}} ->
      io:format("Got ~p ~n", [close]),
      erlang:halt();
    ?event(MI1,command_menu_selected) ->
      io:format("Got ~p ~n", [menuitem1]);
    ?event(MI2,command_menu_selected) ->
      io:format("Got ~p ~n", [menuitem2]);
    ?event(But,command_button_clicked) ->
      Text = wxTextCtrl:getValue(Txt#xwx.object),
      wxStatusBar:setStatusText(SB#xwx.object,Text),
      io:format("Got ~p ~n", [button]);
    ?event(Txt,command_text_enter) ->
      io:format("Got ~p ~n", [textctrl]);
    ?event(CBx,command_combobox_selected) ->
      Text = wxComboBox:getValue(CBx#xwx.object),
      wxStaticText:setLabel(ST#xwx.object,Text),
      io:format("Got ~p ~n", [combobox]);
    ?event(Exit,_) ->
      io:format("Got ~p ~n", [exit]),
      erlang:halt();
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      io:fwrite("~p~n",[{MI1,MI2,But,Txt,CBx,SB,ST,Exit}])
  end,
  loop(MI1,MI2,But,Txt,CBx,SB,ST,Exit).
