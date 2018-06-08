


require "config"
require("cocos.init")
require("framework.init")
math.randomseed(os.time())

local utils  = import("framework.cc.utils.init")

cc.utils = cc.utils or {}

xzmj = xzmj or { }

local winSize = cc.Director:getInstance():getWinSize()

xzmj.winSize = winSize


xzmj.lx = "..laixia."


-- 事件派发
ObjectEventDispatch = import(xzmj.lx.."public.MonitorSystem")

xzmj.Layout = import("..laixia.tools.Layout")     --调取csb工具方法

xzmj.soundTools = import("..laixia.tools.SoundTools") --声音工具

xzmj.status = 'ddz'; -- > 默认状态

xzmj.Loader = import("..laixia.tools.IBaseLoader")

-- xzmj.ani = import(".animation.init")
xzmj.ani = import(xzmj.lx.."animation.init")

xzmj.json = import("..laixia.tools.dkjson")

xzmj.evt = import("..laixia.public.MonitorID")

xzmj.MainCommand = import("..laixia.ui.MainCommand")



xzmj.subApps = {};

xzmj.logPacketID = logPacket

--音效管理 add by feng
xzmj.soundManager   = import("..laixia.Manager.Sound.SoundManager")

xzmj.soundEnum      = import("..laixia.Manager.Sound.SoundEnum")

xzmj.UserManager    = import(xzmj.lx.."Model.UserManager").new()
   
xzmj.Animg = import "..laixia.animation.CocosAnimManager"

xzmj.Animg:load()




xzmj.resLoader = import("..laixia.public.ResLoader", CURRENT_MODULE_NAME)
    :init()
    :prepareForLoad()


xzmj.net = xzmj.net or {}
xzmj.net.http = import(xzmj.lx.."net.Http")
xzmj.net.HttpRequest = import(xzmj.lx.."net.HttpRequest")
xzmj.net.LaixiaNet = import(xzmj.lx.."net.LaixiaNet")
xzmj.net.Packet = import(xzmj.lx.."net.Packet")
import(xzmj.lx.."net.LXEngine")




xzmj.Model = xzmj.Model or {}
xzmj.Model.UserInfoModel = import(xzmj.lx.."Model.UserInfoModel")
xzmj.Model.GameLayerModel  = import(xzmj.lx.."Model.GameLayerModel")
xzmj.Model.MatchEnrollModel = import("..laixia.Model.MatchEnrollModel")
xzmj.Model.TaskLayerModel = import("..laixia.Model.TaskLayerModel")
xzmj.Model.MatchEnrollModel  = import(xzmj.lx.."Model.MatchEnrollModel")
xzmj.Model.PlayerInfoVO =    import(xzmj.lx.."Model.PlayerInfoVO")
xzmj.Model.PlayGroundModle = import(xzmj.lx.."Model.PlayGroundModle")
-- xzmj.Model.PokerDeskModel =  import(xzmj.lx.."Model.PokerDeskModel")
xzmj.Model.talklayerModel =  import(xzmj.lx.."Model.talklayerModel")
xzmj.Model.TaskLayerModel = import(xzmj.lx.."Model.TaskLayerModel")
xzmj.Model.UserManager = import(xzmj.lx.."Model.UserManager")
  




xzmj.public = xzmj.public or {}
xzmj.public.CommeText = import(xzmj.lx.."public.CommeText")
xzmj.public.CommonInterFace = import(xzmj.lx.."public.CommonInterFace")
xzmj.public.ModuleType = import(xzmj.lx.."public.ModuleType")
xzmj.public.MonitorID = import(xzmj.lx.."public.MonitorID")
xzmj.public.MonitorSystem = import(xzmj.lx.."public.MonitorSystem")
xzmj.public.ResLoader = import(xzmj.lx.."public.ResLoader")

xzmj.tools = xzmj.tools or {}
xzmj.tools.DateFormatUtil = import(xzmj.lx.."tools.DateFormatUtil")
xzmj.tools.dkjson = import(xzmj.lx.."tools.dkjson")
xzmj.tools.IBaseLoader = import(xzmj.lx.."tools.IBaseLoader")
xzmj.tools.Layout = import(xzmj.lx.."tools.Layout")
xzmj.tools.log = import(xzmj.lx.."tools.log")
xzmj.tools.SoundTools = import(xzmj.lx.."tools.SoundTools")


xzmj.ui = xzmj.ui or {}
xzmj.ui.BaseDialog = import(xzmj.lx.."ui.BaseDialog")
xzmj.ui.BaseScene = import(xzmj.lx.."ui.BaseScene")
xzmj.ui.BaseView = import(xzmj.lx.."ui.BaseView")
xzmj.ui.MainCommand = import(xzmj.lx.."ui.MainCommand")
xzmj.ui.PopupWindowWrapper = import(xzmj.lx.."ui.PopupWindowWrapper")
xzmj.ui.ViewStack = import(xzmj.lx.."ui.ViewStack")


xzmj.layer = xzmj.layer or {}
xzmj.layer.CommBtnNode = import(xzmj.lx.."ui.layer.CommWidet.CommBtnNode")
xzmj.layer.DebuggerLayer = import(xzmj.lx.."ui.layer.Debugger.DebuggerLayer")
xzmj.layer.FriendItemNode = import(xzmj.lx.."ui.layer.FriendLayer.FriendItemNode")
xzmj.layer.FriendLayer = import(xzmj.lx.."ui.layer.FriendLayer.FriendLayer")
xzmj.layer.ExitNode = import(xzmj.lx.."ui.layer.GameLayer.ExitNode")
xzmj.layer.GameLayer = import(xzmj.lx.."ui.layer.GameLayer.GameLayer")
xzmj.layer.PlayGroundLayer = import(xzmj.lx.."ui.layer.GameLayer.PlayGroundLayer")
xzmj.layer.PlayGroundNode = import(xzmj.lx.."ui.layer.GameLayer.PlayGroundNode")

xzmj.layer.GameTextTips = import(xzmj.lx.."ui.layer.GameTips.GameTextTips")
xzmj.layer.ItemNode = import(xzmj.lx.."ui.layer.GameTips.ItemNode")
xzmj.layer.RechargeTip = import(xzmj.lx.."ui.layer.GameTips.RechargeTip")
xzmj.layer.RuleTips = import(xzmj.lx.."ui.layer.GameTips.RuleTips")

xzmj.layer.WebView = import(xzmj.lx.."ui.layer.LobbyWindow.WebView")
xzmj.layer.PokerDeskConfig = import(xzmj.lx.."ui.layer.PokerDeskLayer.PokerDeskConfig")
xzmj.Model.PokerDeskModel =  import(xzmj.lx.."Model.PokerDeskModel")
xzmj.layer.MahjongChangeCardAct = import(xzmj.lx.."ui.layer.MahjongNode.MahjongChangeCardAct")
xzmj.layer.MahjongNodeMYDP = import(xzmj.lx.."ui.layer.MahjongNode.MahjongNodeMYDP")
xzmj.layer.MahjongNodeSP = import(xzmj.lx.."ui.layer.MahjongNode.MahjongNodeSP")
xzmj.layer.MahjongNodeSXDP = import(xzmj.lx.."ui.layer.MahjongNode.MahjongNodeSXDP")
xzmj.layer.MahjongNodeZP = import(xzmj.lx.."ui.layer.MahjongNode.MahjongNodeZP")
xzmj.layer.MahjongNodeZYCP = import(xzmj.lx.."ui.layer.MahjongNode.MahjongNodeZYCP")
xzmj.layer.MahjongNodeZYDP = import(xzmj.lx.."ui.layer.MahjongNode.MahjongNodeZYDP")

xzmj.layer.MatchDetailsLayer = import(xzmj.lx.."ui.layer.MatchEnrollLayer.MatchDetailsLayer")
xzmj.layer.MatchEnrollLayer = import(xzmj.lx.."ui.layer.MatchEnrollLayer.MatchEnrollLayer")
xzmj.layer.MatchEnrollNode = import(xzmj.lx.."ui.layer.MatchEnrollLayer.MatchEnrollNode")
xzmj.layer.MatchInstitutionLayer = import(xzmj.lx.."ui.layer.MatchEnrollLayer.MatchInstitutionLayer")
xzmj.layer.MatchInstitutionNode = import(xzmj.lx.."ui.layer.MatchEnrollLayer.MatchInstitutionNode")
xzmj.layer.MatchRewardLayer = import(xzmj.lx.."ui.layer.MatchEnrollLayer.MatchRewardLayer")
xzmj.layer.MatchRewardNode = import(xzmj.lx.."ui.layer.MatchEnrollLayer.MatchRewardNode")

xzmj.layer.GameStartAct = import(xzmj.lx.."ui.layer.PokerDeskLayer.GameStartAct")
-- xzmj.layer.PokerDeskConfig = import(xzmj.lx.."ui.layer.PokerDeskLayer.PokerDeskConfig")
-- xzmj.Model.PokerDeskModel =  import(xzmj.lx.."Model.PokerDeskModel")

xzmj.layer.PokerDeskLayer = import(xzmj.lx.."ui.layer.PokerDeskLayer.PokerDeskLayer")
xzmj.layer.PokerDeskNode = import(xzmj.lx.."ui.layer.PokerDeskLayer.PokerDeskNode")
xzmj.layer.PokerDeskTopNode = import(xzmj.lx.."ui.layer.PokerDeskLayer.PokerDeskTopNode")

xzmj.layer.Poker_icon = import(xzmj.lx.."ui.layer.PokerDeskLayer.Poker_icon")
xzmj.layer.Poker_Menu = import(xzmj.lx.."ui.layer.PokerDeskLayer.Poker_Menu")
xzmj.layer.Poker_PersonCenter = import(xzmj.lx.."ui.layer.PokerDeskLayer.Poker_PersonCenter")
xzmj.layer.Poker_talk = import(xzmj.lx.."ui.layer.PokerDeskLayer.Poker_talk")
xzmj.layer.Poker_wind = import(xzmj.lx.."ui.layer.PokerDeskLayer.Poker_wind")

xzmj.layer.PokerDeskBasepl = import(xzmj.lx.."ui.layer.PokerDeskLayer.PlayerProperty.PokerDeskBasepl")
xzmj.layer.PokerDeskLeftpl = import(xzmj.lx.."ui.layer.PokerDeskLayer.PlayerProperty.PokerDeskLeftpl")
xzmj.layer.PokerDeskMypl = import(xzmj.lx.."ui.layer.PokerDeskLayer.PlayerProperty.PokerDeskMypl")
xzmj.layer.PokerDeskRightpl = import(xzmj.lx.."ui.layer.PokerDeskLayer.PlayerProperty.PokerDeskRightpl")
xzmj.layer.PokerDeskToppl = import(xzmj.lx.."ui.layer.PokerDeskLayer.PlayerProperty.PokerDeskToppl")

 
xzmj.layer.RunLanternLayer = import(xzmj.lx.."ui.layer.RunLanternLayer.RunLanternLayer")

xzmj.layer.TalkEnjoyNode = import(xzmj.lx.."ui.layer.talklayer.TalkEnjoyNode")
xzmj.layer.talklayer = import(xzmj.lx.."ui.layer.talklayer.talklayer")
xzmj.layer.talk_info = import(xzmj.lx.."ui.layer.talklayer.talk_info")

xzmj.layer.TaskLayer = import(xzmj.lx.."ui.layer.TaskLayer.TaskLayer")
xzmj.layer.TaskNode = import(xzmj.lx.."ui.layer.TaskLayer.TaskNode")

xzmj.layer.DefeatLayer = import(xzmj.lx.."ui.layer.TipsLayer.DefeatLayer")
xzmj.layer.LaidouTips = import(xzmj.lx.."ui.layer.TipsLayer.LaidouTips")
xzmj.layer.PersonCenterTips = import(xzmj.lx.."ui.layer.TipsLayer.PersonCenterTips")
xzmj.layer.SetTips = import(xzmj.lx.."ui.layer.TipsLayer.SetTips")
xzmj.layer.WinnerLayer = import(xzmj.lx.."ui.layer.TipsLayer.WinnerLayer")

xzmj.layer.UserInfoLayer = import(xzmj.lx.."ui.layer.UserInfoLayer.UserInfoLayer")
xzmj.layer.UserinfoNode = import(xzmj.lx.."ui.layer.UserInfoLayer.UserinfoNode")
xzmj.layer.GameSettlementLayer = import(xzmj.lx.."ui.layer.GameSettlementLayer.GameSettlementLayer")
xzmj.layer.GameSettlementNode = import(xzmj.lx.."ui.layer.GameSettlementLayer.GameSettlementNode")


_G.setPlatformAdap(true)
_G.setCommonDisplay(true)


local MainScene = class("MainScene", xzmj.ui.BaseScene )

function MainScene:ctor()
    MainScene.super.ctor(self)
end

function MainScene:init(  )
    
end


function MainScene:onEnter()
    MainScene.super.onEnter(self)
    function addBackEvent()
            self.mTouchLayer = display.newLayer();
            self.mTouchLayer:addNodeEventListener(cc.KEYPAD_EVENT,function (event)
                local isBack = false
                if device.platform == "android" then
                    if event.key == "back" then -- 安卓键返回
                        isBack = true
                    end               
                end
                if(device.platform =="windows") then
                    if event.key == "7" then
                     end 
                end
            end )        
            self.mTouchLayer:setKeypadEnabled(true)
            self:addChild(self.mTouchLayer);
      end
     
    addBackEvent();
    self:startLoading()
   
end



function MainScene:startLoading()
    -- 测试用例 个人信息
    local data = {pid = 0,name = "00",headUrl = "games/gdy/images/head/male_09.png",gold = 10000,coin = 120000,sex = 1}
    xzmj.UserManager:updatePlayer(data)
    xzmj.MainCommand:InTypeJumpView(1)    
end 

function MainScene:onExit()
    MainScene.super.onExit(self)
    print("MainScene:onExit")
    if device.platform == "android" and self.mTouchLayer ~= nil then
      self.mTouchLayer:removeFromParent();        
      self.mTouchLayer = nil
   end 

end


function MainScene.EnterXZGame( ... )
    local scene = MainScene.new()
    display.replaceScene(scene)
end

MainScene.EnterXZGame()

return MainScene
