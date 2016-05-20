-module(xwx).

%% xwx: xwx library's entry point.

-export([resources/2,
         frames/3,
         app_menu/2,
         menubar/4,
         statusbar/2,
         buttons/2,
         statictexts/2,
         treectrls/2,
         sliders/2,
         comboboxes/2,
         textctrls/2]).

-include("../include/xwx.hrl").

resources(M,Files) ->
  Dir = filename:dirname(proplists:get_value(source,M:module_info(compile))),
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

statusbar(Frame,Items) ->
  map_items(Frame,wxStatusBar,Items).

statictexts(Frame,Items) ->
  map_items(Frame,wxStaticText,Items).

menubar(XRC,Frame,Bar,Items) ->
  MenuBar = wxXmlResource:loadMenuBar(XRC,Bar),
  wxFrame:setMenuBar(Frame,MenuBar),
  connect_menu_items_by_name(MenuBar,command_menu_selected,Items).

sliders(Frame,Items) ->
  connect_by_name(Frame,[command_slider_updated],wxSlider,Items).

buttons(Frame,Buttons) ->
  connect_by_name(Frame,[command_button_clicked],wxButton,Buttons).

treectrls(Frame,Treectrls) ->
  connect_by_name(Frame,[command_tree_item_collapsed,
                         command_tree_item_expanded,
                         command_tree_sel_changed],wxTreeCtrl,Treectrls).

textctrls(Frame,Texts) ->
  connect_by_name(Frame,[command_text_enter],wxTextCtrl,Texts).

comboboxes(Frame,Combos) ->
  connect_by_name(Frame,[command_combobox_selected],wxComboBox,Combos).

map_items(Frame,Type,Items) ->
  lists:map(
    fun(Item) ->
        ID = wxXmlResource:getXRCID(Item),
        Obj = wxXmlResource:xrcctrl(Frame,Item,Type),
        #xwx{id=ID,object=Obj}
    end,
    Items).

connect_menu_items_by_name(Bar,Command,Items) ->
  lists:map(
    fun(Item) ->
        ID = wxXmlResource:getXRCID(Item),
        wxMenuBar:connect(Bar,Command,[{id,ID}]),
        #xwx{id=ID,object=Bar}
    end,
    Items).

connect_by_name(Frame,Commands,Type,Items) ->
  lists:map(
    fun(Item) ->
        ID = wxXmlResource:getXRCID(Item),
        Res = wxXmlResource:xrcctrl(Frame,Item,Type),
        [Type:connect(Res,C) || C <- Commands],
        #xwx{id=ID,object=Res}
    end,
    Items).
