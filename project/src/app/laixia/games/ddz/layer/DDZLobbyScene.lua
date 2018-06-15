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
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, handler(self, self.addInfo)) --显示飘字动画
    ObjectEventDispatch:addEventListener("ddz_scene_update_coin", handler(self, self.getAccountInfo)) -- 更新金币
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
    csbNode:setScaleX(display.width/1280)
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
    if data then
        self:getGameInfo(data)
    else
        self:checkSng()
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
            if self["loadData"] then 
                self:loadData()   
            end
            ObjectEventDispatch:pushEvent("lobby_top_win_update_coin")
            -- print("DDZLobbyScene MEDUSA_CASH_ACCOUNT===获取成功")         
        else
            if self["loadData"] then 
                self:loadData()
            end
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
        self.txt_gold:setString(laixiaddz.helper.numeralRules_5(laixiaddz.LocalPlayercfg.LaixiaGoldCoin or 0))
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
                    MatchId         = list[i].match_enroll_id,           -- 唯一标识
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
 * @param  data = {RoomType,TableID,RoomID,match_ins_id}
 * @param  room_id  游戏标识
--]]
function DDZLobbyScene:getGameInfo(data)
    dump(data)
    if not data.TableID or tonumber(data.TableID) == 0 then

        print("getGameInfo111 === 断线重连!") 
        local dataParam = {}
        dataParam.RoomType = data.RoomType
        dataParam.RoomID = data.RoomID
        dataParam.MatchInsId = data.match_ins_id
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,dataParam)
    else
        local dataParam = {}
        dataParam.RoomID = data.RoomID
        dataParam.RoomType = data.RoomType
        dataParam.MatchInsId = data.match_ins_id
        
        print(dataParam,"getGameInfo222 === 断线重连!") 
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,dataParam)
        
        local packet = laixiaddz.Packet.new("getGameInfo", "play_card")
        packet:setValue("room_id", data.RoomID)-- 写入包数据
        packet:setValue("table_id", data.TableID)
        packet:setValue("pid",laixiaddz.LocalPlayercfg.LaixiaPlayerID)
        packet:setValue("msg_id","table_sys")
        laixiaddz.net:sendSocketPacket(packet)
    end
end

--[[
 * 提示信息
 * @param  传一字符串就行
--]]
function DDZLobbyScene:addInfo(msg)
    if msg and msg.data then
        local data_ = {
            message = msg.data,
            w = display.cx,
            h = display.cy+200,
            type_ = 1
        }
        local MatterTips = require("lobby.layer.tips.MatterTips").new(data_)
        MatterTips:setPosition(cc.p(data_.w,data_.h))
        local scene = cc.Director:getInstance():getRunningScene()
        scene:addChild(MatterTips,10001)
    end
end

--[[
 * 检测sng是否报名
 * @param  nil
--]]
function DDZLobbyScene:checkSng()
    local stream = Packet.new("EnterListRoom", "LXG_MATCH_ENROLL_LIST")
    stream:setReqType("get")
    stream:setValue("uid", laixiaddz.LocalPlayercfg.LaixiaPlayerID)
    local function cb(data)
        local matchlist = {}
        if data.dm_error==0 and data.data~=nil then
            local index
            matchlist[1] = {}
            matchlist[1].rooms = {}
            local info
            for i =1,#data.data.match_list do
                matchlist[1].rooms[i] = {}
                matchlist[1].rooms[i].RoomType = data.data.match_list[i].match_type  -- 1定时 2人满SNG
                matchlist[1].rooms[i].Sate = data.data.match_list[i].enroll_status
                if matchlist[1].rooms[i].Sate == 2 then -- 0 不能报名 1 可以报名 2 已经报名
                    matchlist[1].rooms[i].SelfJoin = 1
                else
                    matchlist[1].rooms[i].SelfJoin = 0
                end
                matchlist[1].rooms[i].RoomID = data.data.match_list[i].match_id
                matchlist[1].rooms[i].CurJoinNum = data.data.match_list[i].num
                matchlist[1].rooms[i].JoinMinLimit = data.data.match_list[i].begin_min
                matchlist[1].rooms[i].JoinMaxLimit = data.data.match_list[i].begin_max
                matchlist[1].rooms[i].RoomName = data.data.match_list[i].match_name
                matchlist[1].rooms[i].Icon = data.data.match_list[i].icon
                matchlist[1].rooms[i].BaomingInfo = data.data.match_list[i].champion_award
                matchlist[1].rooms[i].Baomingfei = data.data.match_list[i].enter_fee
                matchlist[1].rooms[i].match_desc = data.data.match_list[i].match_desc
                matchlist[1].rooms[i].match_format = data.data.match_list[i].rules_desc
                matchlist[1].rooms[i].RankRds = json.decode(data.data.match_list[i].award_desc) -- {field,award}
                matchlist[1].rooms[i].JoinBTime = data.data.match_list[i].enroll_start_timestamp    -- 报名开始
                matchlist[1].rooms[i].JoinETime = data.data.match_list[i].enroll_end_timestamp      -- 报名结束
                matchlist[1].rooms[i].BeginTime = data.data.match_list[i].match_start_timestamp     -- 比赛开始
                matchlist[1].rooms[i].EndTime = data.data.match_list[i].match_end_timestamp         -- 比赛结束
                matchlist[1].rooms[i].MatchId = data.data.match_list[i].match_enroll_id

                if data.data.match_list[i].match_type == 2 and data.data.match_list[i].enroll_status == 2 then
                    index = i
                end
            end
            laixiaddz.LocalPlayercfg.LaixiaMatchdata =matchlist
            laixiaddz.LocalPlayercfg.LaixiaGamePageType = 1
            laixiaddz.LocalPlayercfg.LaixiaGameListIndex =  1
            if index then
                self:onGotoMatch(nil,ccui.TouchEventType.ended)
                local event = {}
                event = laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[index]
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLISTDETAIL_WINDOW,event)
            end
        else
            print("比赛列表信息 失败")
            dump(data)
        end
    end
    laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
end

--[[
 * 注销
 * @param  nil 
--]]
function DDZLobbyScene:onDestroy()
end

return DDZLobbyScene