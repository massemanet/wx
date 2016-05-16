%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 16 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('due').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").

start() ->
  WX = wx:new(),
  Xrc = wxXmlResource:get(),
  wxXmlResource:initAllHandlers(Xrc),
  wxXmlResource:load(Xrc, "/Users/masse/git/wx/due.xrc"),
  wxXmlResource:load(Xrc, "/Users/masse/git/wx/duem.xrc"),
  Frame = wxFrame:new(),
  wxXmlResource:loadFrame(Xrc, Frame, WX, "MyFrame1"),
  MenuBar = wxXmlResource:loadMenuBar(Xrc, "m_menubar1"),
  wxFrame:setMenuBar(Frame,MenuBar),
  ID1 = wxXmlResource:getXRCID("m_menuitem1"),
  ID2 = wxXmlResource:getXRCID("m_menuitem2"),
  wxFrame:connect(Frame,command_menu_selected,[{id,ID1}]),
  wxFrame:connect(Frame,command_menu_selected,[{id,ID2}]),
  wxFrame:connect(Frame, close_window),
  wxFrame:connect(Frame,command_menu_selected, [{id, ?wxID_ANY}]), % -1
  ButtonID = wxXmlResource:getXRCID(atom_to_list(m_button2)),
  wxFrame:connect(Frame,command_button_clicked,[{id,ButtonID}]),
  wxFrame:show(Frame),
  loop().

loop() ->
  receive
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      loop()
  end.
