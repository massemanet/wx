%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 16 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('due').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").

start() ->
  Dir = "/Users/masse/git/wx",
  Files = ["due.xrc","duem.xrc"],
  WX = wx:new(),
  XRC = resources(Dir,Files),
  [Frame] = frames(WX,XRC,["MyFrame1"]),
  connect_app_menu(Frame,[?wxID_EXIT]),
  menues(XRC,Frame,"m_menubar1",["m_menuItem1","m_menuItem2"]),
  buttons(Frame,["m_button2"]),
  [Txt] = texts(Frame,["m_textCtrl1"]),
  combos(Frame,["m_comboBox1"]),
  wxFrame:show(Frame),
  loop(Txt).

loop(Txt) ->
  receive
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      io:fwrite("~p~n",[wxTextCtrl:getValue(Txt)]),
      loop(Txt)
  end.

resources(Dir,Files) ->
  XRC = wxXmlResource:get(),
  wxXmlResource:initAllHandlers(XRC),
  lists:foreach(
    fun(F) ->
        wxXmlResource:load(XRC, filename:join(Dir,F))
    end,
    Files),
  XRC.

frames(WX,XRC,FrameNames) ->
  lists:map(
    fun(FName)->
        Frame = wxFrame:new(),
        wxXmlResource:loadFrame(XRC, Frame, WX, FName),
        wxFrame:connect(Frame,close_window),
        Frame
    end,
    FrameNames).

connect_app_menu(Frame,Ids) ->
  [wxFrame:connect(Frame,command_menu_selected,[{id,Id}]) || Id <- Ids].

menues(XRC,Frame,Bar,Items) ->
  MenuBar = wxXmlResource:loadMenuBar(XRC,Bar),
  wxFrame:setMenuBar(Frame,MenuBar),
  connect_items_by_name(Frame,command_menu_selected,wxMenu,Items).

buttons(Frame,Buttons) ->
  connect_by_name(Frame,command_button_clicked,wxButton,Buttons).

texts(Frame,Texts) ->
  connect_by_name(Frame,command_text_enter,wxTextCtrl,Texts).

combos(Frame,Combos) ->
  connect_by_name(Frame,command_combobox_selected,wxComboBox,Combos).

connect_items_by_name(Frame,Command,Type,Items) ->
  lists:map(
    fun(Item) ->
        ID = wxXmlResource:getXRCID(Item),
        wxFrame:connect(Frame,Command,[{id,ID}]),
        Res = wxXmlResource:xrcctrl(Frame,Item,Type),
%%        Type:connect(Res,Command),
        Res
    end,
    Items).

connect_by_name(Frame,Command,Type,Items) ->
  lists:map(
    fun(Item) ->
        Res = wxXmlResource:xrcctrl(Frame,Item,Type),
        Type:connect(Res,Command),
        Res
    end,
    Items).
