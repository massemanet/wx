%% -*- mode: erlang; erlang-indent-level: 2 -*-
%%% Created : 16 May 2016 by masse <mats.cronqvist@gmail.com>

%% @doc
%% @end

-module('due').
-author('masse').
-export([start/0]).

-include_lib("wx/include/wx.hrl").

-record(xwx,{id,object}).

start() ->
  Dir = "/Users/masse/git/wx",
  Files = ["due.xrc","duem.xrc"],
  WX = wx:new(),
  XRC = resources(Dir,Files),
  [Frame] = frames(WX,XRC,["MyFrame1"]),
  [Exit] = connect_app_menu(Frame,[?wxID_EXIT]),
  [MI1,MI2] = menu_items(XRC,Frame,"m_menubar1",["m_menuItem1","m_menuItem2"]),
  [But] = buttons(Frame,["m_button2"]),
  [Txt] = text_ctrls(Frame,["m_textCtrl1"]),
  [CBx] = combo_boxes(Frame,["m_comboBox1"]),
  wxFrame:show(Frame),
  loop(MI1,MI2,But,Txt,CBx,Exit).

-define(event(X), #wx{id = _ID} when _ID == X#xwx.id).
loop(MI1,MI2,But,Txt,CBx,Exit) ->
  receive
    #wx{event=#wxClose{}} ->
      io:format("Got ~p ~n", [close]);
    ?event(MI1) ->
      io:format("Got ~p ~n", [menu_item1]);
    ?event(MI2) ->
      io:format("Got ~p ~n", [menu_item2]);
    ?event(But) ->
      io:format("Got ~p ~n", [button]);
    ?event(Txt) ->
      io:format("Got ~p ~n", [text_ctrl]);
    ?event(CBx) ->
      io:format("Got ~p ~n", [combobox]);
    ?event(Exit) ->
      io:format("Got ~p ~n", [exit]);
    Ev ->
      io:format("Got ~p ~n", [Ev]),
      io:fwrite("~p~n",[{MI1,MI2,But,Txt,CBx,Exit}])
  end,
  loop(MI1,MI2,But,Txt,CBx,Exit).

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
  lists:map(
    fun(Id) ->
        wxFrame:connect(Frame,command_menu_selected,[{id,Id}]),
        #xwx{id=Id,object=Frame}
    end,
    Ids).

menu_items(XRC,Frame,Bar,Items) ->
  MenuBar = wxXmlResource:loadMenuBar(XRC,Bar),
  wxFrame:setMenuBar(Frame,MenuBar),
  connect_items_by_name(MenuBar,command_menu_selected,Items).

buttons(Frame,Buttons) ->
  connect_by_name(Frame,command_button_clicked,wxButton,Buttons).

text_ctrls(Frame,Texts) ->
  connect_by_name(Frame,command_text_enter,wxTextCtrl,Texts).

combo_boxes(Frame,Combos) ->
  connect_by_name(Frame,command_combobox_selected,wxComboBox,Combos).

connect_items_by_name(Bar,Command,Items) ->
  lists:map(
    fun(Item) ->
        ID = wxXmlResource:getXRCID(Item),
        wxMenuBar:connect(Bar,Command,[{id,ID}]),
        #xwx{id=ID,object=Bar}
    end,
    Items).

connect_by_name(Frame,Command,Type,Items) ->
  lists:map(
    fun(Item) ->
        ID = wxXmlResource:getXRCID(Item),
        Res = wxXmlResource:xrcctrl(Frame,Item,Type),
        Type:connect(Res,Command),
        #xwx{id=ID,object=Res}
    end,
    Items).
