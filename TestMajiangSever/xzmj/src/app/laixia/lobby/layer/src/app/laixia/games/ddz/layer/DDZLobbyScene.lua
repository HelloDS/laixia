--[[
* 斗地主游戏大厅
]]

--fix me 需要用CSBBase可以单独调用，因为CSBBase是一个类 不是一个节点
--local CSBBase = require("app.laixia.lobby.ui.CSBBase")
local CURRENT_MODULE_NAME = ...
require("logger")
require("cocos.init")
require("framework.init")
require("games.ddz.init") 
local Packet =  require("lobby.net.Packet")  
local laixiaHelper = require("common.tools.Helpers")

local DDZLobbyScene = class("DDZLobbyScene", function()
    return display.newScene()
end) 

--[[
 * 构造
 * @param  nil
--]]
function DDZLobbyScene:ctor(...)
    laixiaddz.resLoader = require("games.ddz.public.ResLoader")
        :init()
        :prepareForLoad()
    laixiaddz.ani:doLoad();
    laixiaddz.ui.UILayer:addTo(self):setLocalZOrder(2)
    self:init(...)
end

--[[
 * 初始化
 * @param  data = (table_id,room_id)
--]]
function DDZLobbyScene:init(data)
     --初始化界面
    local csbNode = cc.CSLoader:createNode("games/ddz/new_ui/ddzLobbyScene.csb")
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.cx,display.cy)
	self:addChild(csbNode,1)
	self.rootNode = csbNode  
    _G.adap(csbNode)
    local Image_Bg = _G.seekNodeByName(self.rootNode,"Image_Bg")
    if Image_Bg then
        Image_Bg:setContentSize(cc.size(display.width, display.height))
    end
    self.btn_game = _G.seekNodeByName(self.rootNode,"btn_game")
    self.btn_game:addTouchEventListener(handler(self,self.onGotoGame))
    self.btn_match = _G.seekNodeByName(self.rootNode,"btn_match")
    self.btn_match:addTouchEventListener(handler(self,self.onGotoMatch))
    self.btn_go_shop = _G.seekNodeByName(self.rootNode,"btn_go_shop")
    self.btn_go_shop:addTouchEventListener(handler(self,self.onTouchBtn)) 
    self.btn_go_shop:setVisible(false)
    self.btn_go_wenhao = _G.seekNodeByName(self.rootNode,"btn_go_wenhao")
    self.btn_go_wenhao:addTouchEventListener(handler(self,self.onTouchBtn)) 
    self.btn_go_wenhao:setVisible(false) 
    self.Button_ddz_tuichu = _G.seekNodeByName(self.rootNode,"Button_ddz_tuichu")
    self.Button_ddz_tuichu:addTouchEventListener(handler(self,self.onTouchBtn)) 
    self.txt_playername = _G.seekNodeByName(self.rootNode,"txt_playername")
    if self.txt_playername then
        self.txt_playername:setString(laixiaHelper.StringRules_6(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname)) 
    end  
    self:getAccountInfo()
    self:addHead()   
    -- self:getGameState()
    if data then
        self:getGameInfo(table_id,room_id)
    end
end

--[[
 * 加头像
 * @param  nil
--]]
function DDZLobbyScene:addHead()
    local path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
    local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID..".png"
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    if (fileExist) then
        path = localIconName
    end
    local img_head = _G.seekNodeByName(self.rootNode,"img_head")
    if img_head then
        local templet = "images/touxiangkuang_now.png"
        local fileExist1 = cc.FileUtils:getInstance():isFileExist(templet)
        local fileExist2 = cc.FileUtils:getInstance():isFileExist(path)
        if fileExist1 and fileExist2 then
            laixiaddz.UItools.addHead(img_head, path, templet)
        end
    end
end

--[[
 * 按钮点击事件
 * @param  sender 点击按钮
 * @param  event  事件类型
--]]
function DDZLobbyScene:onTouchBtn(sender, eventType)
    _G.onTouchButton(sender, eventType)
    local senderName = sender:getName()
    if eventType == ccui.TouchEventType.ended then
        if senderName == "btn_go_shop" then
            print("商城")
        elseif senderName == "btn_go_wenhao" then
            print("来豆")
        elseif senderName == "Button_ddz_tuichu" then
            _G.setPlatformAdap(false)
            _G.setCommonDisplay(false)
            local mainScene = require("app/scenes/MainScene").new()
            display.replaceScene(mainScene)
        end
    end
end

--[[
 * 获取用户信息
 * @param  nil
--]]
function DDZLobbyScene:getAccountInfo()
    local stream =  laixia.Packet.new("userInfo", "MEDUSA_CASH_ACCOUNT")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    -- stream:setValue(laixia.LocalPlayercfg.LaixiaTokenID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data = event
        if event.dm_error == 0 then
            laixia.LocalPlayercfg.LaixiaGoldCoin = data.gold_coin or 0
            laixia.LocalPlayercfg.LaixiaLdCoin   = data.laidou_coin or 0
            laixia.LocalPlayercfg.LaixiaZsCoin   = data.zscoin or 0
            self:loadData()   
            -- print("DDZLobbyScene MEDUSA_CASH_ACCOUNT===获取成功")         
        else
            self:loadData()
            -- print("DDZLobbyScene MEDUSA_CASH_ACCOUNT===获取失败")
        end 
    end) 
end

--[[
 * 用户信息设置
 * @param  nil
--]]
function DDZLobbyScene:loadData()
    self.txt_gold = _G.seekNodeByName(self.rootNode,"txt_gold")
    if self.txt_gold then
        self.txt_gold:setString(laixiaddz.LocalPlayercfg.LaixiaGoldCoin or 0)
    end
    self.txt_laidou = _G.seekNodeByName(self.rootNode,"txt_laidou")
    if self.txt_laidou then
        self.txt_laidou:setString(laixiaddz.LocalPlayercfg.LaixiaLdCoin or 0)
    end
end

--[[
 * 显示游戏场界面
 * @param  sender 点击按钮
 * @param  event  事件类型
--]]
function DDZLobbyScene:onGotoGame(sender,eventtype)
    if eventtype == ccui.TouchEventType.ended then
        local stream = Packet.new("EnterListRoom", "LXG_GAME_LIST")
        stream:setReqType("get")
        local function cb(data)
            local test = data
            -- print("游戏场协议信息详情 = ↓")
            -- dump(data.data.game_list)
            -- require("games.ddz.ui.layer.LobbyWindow.GameRoomGround").new()
            local game_list = {}
            local list = data.data.game_list
            for i=1,#list do
                game_list[i] = {
                    RoomID          = list[i].match_id or 0,             -- 比赛场标识
                    AwardDesc       = list[i].task_award or "",          -- 奖励信息↑三个字段改此 
                    OnlineNumber    = list[i].num or 0,                  -- 在线人数 
                    BaseScore       = list[i].base_table_score or 0,     -- 低分
                    MinGold         = list[i].min_coin or 0,             -- 最小金币
                    MaxGold         = list[i].max_coin or 0,             -- 最大金币
                    RoomName        = list[i].match_name or "",          -- 比赛场名字
                    Status          = list[i].status or 0,               -- 状态：0不能进入,1能进入
                }
            end
            print("游戏场信息转换详情 = ↓")
            dump(game_list)
            ObjectEventDispatch:dispatchEvent({name = _laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW, data = game_list})
        end
        laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
    end
end

--[[
 * 去比赛场
 * @param  sender 按钮
 * @param  sender 事件类型
--]]
function DDZLobbyScene:onGotoMatch(sender,eventtype)
    if eventtype == ccui.TouchEventType.ended then
        --显示比赛界面
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
        laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW
    end
end

--[[
 * 获取比赛详情
 * @param  table_id 桌子标识
 * @param  room_id  游戏标识
--]]
function DDZLobbyScene:getGameInfo(table_id,room_id)
    if not table_id and not room_id then return end
    print("getGameInfo ===比赛信息") 
    local stream =  laixia.Packet.new("getGameInfo", "LXG_MATCH_INFO")
    stream:setReqType("post")
    stream:setValue("table_id", table_id)
    stream:setValue("room_id", room_id)
    stream:setPostData("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixiaddz.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data = event
        if event.dm_error == 0 then
            local scene = cc.Director:getInstance():getRunningScene()
            scene:popUpTips("进入比赛。。。。！")
            -- dump(data)
            -- print("getGameInfo ===比赛信息成功") 
            -- 测试
            -- local data = {}
            -- data.RoomID = 1003
            -- data.RoomType = 4 --比赛场标识位
            -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,data)
        else
            print("getGameInfo ===比赛信息失败")
        end 
    end) 
end

--[[
 * 提示信息
 * @param  传一字符串就行
--]]
function DDZLobbyScene:popUpTips(msg)
    if not msg then return end
    local data_ = {
        message = msg,
        w = display.cx,
        h = display.cy+200,
        type_ = 1
    }
    local MatterTips = require("lobby.layer.tips.MatterTips").new(data_)
    MatterTips:setPosition(cc.p(data_.w,data_.h))
    self:addChild(MatterTips,1111)
end

return DDZLobbyScene