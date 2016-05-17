-module(xwx).

%% xwx: xwx library's entry point.

-export([resources/2,
         frames/3,
         app_menu/2,
         menubar/4,
         buttons/2,
         comboboxes/2,
         textctrls/2]).

-include("../include/xwx.hrl").

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

app_menu(Frame,Ids) ->
  lists:map(
    fun(Id) ->
        wxFrame:connect(Frame,command_menu_selected,[{id,Id}]),
        #xwx{id=Id,object=Frame}
    end,
    Ids).

menubar(XRC,Frame,Bar,Items) ->
  MenuBar = wxXmlResource:loadMenuBar(XRC,Bar),
  wxFrame:setMenuBar(Frame,MenuBar),
  connect_items_by_name(MenuBar,command_menu_selected,Items).

buttons(Frame,Buttons) ->
  connect_by_name(Frame,command_button_clicked,wxButton,Buttons).

textctrls(Frame,Texts) ->
  connect_by_name(Frame,command_text_enter,wxTextCtrl,Texts).

comboboxes(Frame,Combos) ->
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
