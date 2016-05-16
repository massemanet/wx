%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 12 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('uno').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").

start() ->
  WX = wx:new(),
  Xrc = wxXmlResource:get(),
  wxXmlResource:initAllHandlers(Xrc),
  true = wxXmlResource:load(Xrc, rc_dir("menu.xrc")),
  true = wxXmlResource:load(Xrc, rc_dir("frame.xrc")),
  Frame = wxFrame:new(),
  myframe(WX,Frame),
  wxFrame:show(Frame),
  loop(Frame),
  wx:destroy().

rc_dir(File) ->
  SelfDir = filename:dirname(code:which(?MODULE)),
  filename:join([SelfDir,rc,File]).

loop(Frame) ->
  receive
    {wx,5006,_,_,_} -> erlang:halt();
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      loop(Frame)
  end.

myframe(Parent, Frame) ->
  Xrc = wxXmlResource:get(),
  wxXmlResource:loadFrame(Xrc, Frame, Parent, "main_frame"),
  wxFrame:setMenuBar(Frame, wxXmlResource:loadMenuBar(Xrc, "main_menu")),
  wxFrame:createStatusBar(Frame, [{number,1}]),
  ok = wxFrame:connect(Frame, close_window),
  connect(Frame).

connect(Frame) ->
  Menues = [unload_resource_menuitem, reload_resource_menuitem,
            non_derived_dialog_tool_or_menuitem, derived_tool_or_menuitem,
            controls_tool_or_menuitem, uncentered_tool_or_menuitem,
            custom_class_tool_or_menuitem, platform_property_tool_or_menuitem,
            art_provider_tool_or_menuitem, variable_expansion_tool_or_menuitem
           ],
  wxFrame:connect(Frame,command_menu_selected, [{id, ?wxID_EXIT}]),
  wxFrame:connect(Frame,command_menu_selected, [{id, ?wxID_ABOUT}]),
  [connect_xrcid(Str,Frame) || Str <- Menues],
  ok.

connect_xrcid(Name,Frame) ->
  ID = wxXmlResource:getXRCID(atom_to_list(Name)),
  put(ID, Name),
  wxFrame:connect(Frame,command_menu_selected,[{id,ID}]).
