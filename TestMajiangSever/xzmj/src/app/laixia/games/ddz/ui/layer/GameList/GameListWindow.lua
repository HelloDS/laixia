--@ 比赛列表

local GameListWindow = class("GameListWindow", import("...CBaseDialog"):new())--
local soundConfig = laixiaddz.soundcfg;
local Packet = import("....net.Packet")
local scheduler = require "framework.scheduler"
local db2 = laixiaddz.JsonTxtData
local itemDBM

function GameListWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
end

function GameListWindow:getName()
    return "GameListWindow" -- csb = GameList.csb
end

function GameListWindow:onInit()
    self.super:onInit(self)
    local Image_Bg = _G.seekNodeByName("Image_1")
    if Image_Bg then
        Image_Bg:setContentSize(cc.size(display.width, display.height))
    end
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW, handler(self, self.show))                 -- 显示列表
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SENDDINGSHI_GOGAMELIST, handler(self, self.getMatchList))        -- 请求列表
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW, handler(self, self.updataMatchlist))   -- 更新列表
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHLIST_WINDOW, handler(self, self.destroy))              -- 注销
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW,handler(self, self.updataPanel)) -- 更新列表
    self.mIsShow = false
    self.time = 0
    self.isNeedModify = false
    self.isAction = true
end

--[[
 * 请求比赛列表
 * @param  arr = nil
--]]
function GameListWindow:getMatchList()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
    self:sendMatchListReq()
end

--[[
 * 比赛列表请求协议
 * @param  arr = nil
--]]
function GameListWindow:sendMatchListReq()
    local stream = Packet.new("EnterListRoom", "LXG_MATCH_ENROLL_LIST")
    stream:setReqType("get")
    stream:setValue("uid", laixiaddz.LocalPlayercfg.LaixiaPlayerID)
    local function cb(data)
        local response 
        local matchlist = {}
        if data.dm_error==0 and data.data~=nil then
            matchlist[1] = {}
            matchlist[1].rooms = {}
            -- print("比赛列表信息1↓")
            -- dump(data.data.match_list)
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
                -- matchlist[1].rooms[i].RankRds = data.data.match_list[i].award_desc
                matchlist[1].rooms[i].Baomingfei = data.data.match_list[i].enter_fee
                -- dump(json.encode(data.data.match_list[i].enter_fee))
                -- dump(matchlist[1].rooms[i].Baomingfei)
                matchlist[1].rooms[i].match_desc = data.data.match_list[i].match_desc
                matchlist[1].rooms[i].match_format = data.data.match_list[i].rules_desc
                matchlist[1].rooms[i].RankRds = json.decode(data.data.match_list[i].award_desc) -- {field,award}
                matchlist[1].rooms[i].JoinBTime = data.data.match_list[i].enroll_start_timestamp    -- 报名开始
                matchlist[1].rooms[i].JoinETime = data.data.match_list[i].enroll_end_timestamp      -- 报名结束
                matchlist[1].rooms[i].BeginTime = data.data.match_list[i].match_start_timestamp     -- 比赛开始
                matchlist[1].rooms[i].EndTime = data.data.match_list[i].match_end_timestamp         -- 比赛结束

                matchlist[1].rooms[i].MatchId = data.data.match_list[i].match_enroll_id
            end
            -- print("比赛列表信息2↓")
            -- dump(matchlist[1].rooms)
            --返回
            laixiaddz.LocalPlayercfg.LaixiaMatchdata =matchlist--packet:getValue("PageTypeMessage")
            laixiaddz.LocalPlayercfg.LaixiaGamePageType = 1--laixiaddz.LocalPlayercfg.LaixiaMatchdata[i].PageType
            laixiaddz.LocalPlayercfg.LaixiaGameListIndex =  1--i
            self:updataPanel()
        else
            print("比赛列表信息 失败")
            dump(data)
        end
    end
    laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
end

--[[
 * 显示界面
 * @param  arr = nil
--]]
function GameListWindow:onShow()
    laixiaddz.soundTools.playMusic(soundConfig.SCENE_MUSIC.lobby,true);
    if self.mIsShow == false then
        self:startTimer()
        self:setAdaptation()
        --增加一个定位的标识
        cc.UserDefault:getInstance():setStringForKey("lastwindow","ddz_GameListWindow")
        cc.UserDefault:getInstance():setDoubleForKey("lastwindow_time",os.time())
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_COMMONTOP_WINDOW,
            {
                goBackFun = function()
                    self:destroy()
                end,
            } )
        itemDBM =db2:queryTable("items");
        self.updata_time = 0
        --1~~~~~~~~~~~~~~~~~~~~~~~~~~~~~cell
        self.imgDetail = self:GetWidgetByName("Image_GameList_Item")  --添加的物品条
        --2单独的listview
        self.ItemCell = self:GetWidgetByName("Image_ListView")    --添加条目的父类
        --3大listview
        self.ListView = self:GetWidgetByName("ListView")
        self.ListView_2 = self:GetWidgetByName("ListView_2")
        self.Image_1 = self:GetWidgetByName("Image_1")
        self:goGoldMatch()
        self.Text_Time = self:GetWidgetByName("Text_Time")
        self.mTime = ""
        local temp = os.date("%H") .. ":" .. os.date("%M")
        if(self.Text_Time ~= nil and self.mTime ~=temp ) then
            self.mTime = temp
            self.Text_Time:setString(self.mTime)
        end
        -- if device.platform ~= "windows" then
        --     self:sendCurVersion()
        -- end
        
        self.mIsShow = true
    end
    self.mIndex = 0
    self.mIndex2 = 0
    self.time1 = 0
    self.Panel_guodu = self:GetWidgetByName("Panel_guodu")
    self.Panel_guodu:setVisible(false)
    self.matchInfo = {}
    self.matchNodeList = {}
    self.ListView:removeAllItems()
    self.ListView:setVisible(false)
end

--[[
 * 发送我本地版本号
 * @param  arr = nil
--]]
function GameListWindow:sendCurVersion()
    local version = cc.UserDefault:getInstance():getStringForKey("version")
    if version ~=nil and version~="" then
    elseif version==nil or version=="" then
            CurVersion = "2.0.14"
    end
    local stream = Packet.new("CSGetVersion", _LAIXIA_PACKET_CS_GETVERSION)
    stream:setValue("Code", 0)
    stream:setValue("GameID", 1)
    stream:setValue("GameVersion",version)
    laixia.net.sendHttpPacketAndWaiting(stream,nil,2) 
end

--置顶比赛 伊诺凯和映客
function GameListWindow:TopMatchNode()
end

--[[
 * 更新界面
 * @param  arr = nil
--]]
function GameListWindow:updataPanel()
    if self.mIsShow then
        if self.isNeedModify == true then
            self.matchInfo = laixiaddz.LocalPlayercfg.LaixiaMatchdata
            self:TopMatchNode()
            -- self:refreshMatchList_new()
            self:schedulerTick(1)
        else ---置顶的逻辑
            self.ListView:removeAllItems()
            self.matchNodeList ={}
            self.matchInfo = laixiaddz.LocalPlayercfg.LaixiaMatchdata
            self:TopMatchNode()
            self.mPageType = laixiaddz.LocalPlayercfg.LaixiaGamePageType
            self.mIndex = 0
            self:initUI()
        end
        function DeepCopy(object)      
            local SearchTable = {}  
            local function Func(object)  
                if type(object) ~= "table" then  
                    return object         
                end  
                local NewTable = {}  
                SearchTable[object] = NewTable  
                for k, v in pairs(object) do  
                    NewTable[Func(k)] = Func(v)  
                end     
                return setmetatable(NewTable, getmetatable(object))      
            end    
            return Func(object)  
        end   
        local matchInfoTemp2 = {}
        local isNeedAdd2 = nil
        for i=1,#self.matchInfo[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms do
            matchInfoTemp2[#matchInfoTemp2+1] = DeepCopy(self.matchInfo[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i])
            self.ListView_2:removeAllItems()
        end
        self.mIndex2 = #matchInfoTemp2
        self:addMatchCell2(1,self.mIndex2,matchInfoTemp2)
        self.isAction = false
    end
end

--[[
 * 添加节点
 * @param  begin = 其实坐标
 * @param  over = 结束坐标
 * @param  array = 信息数组
--]]
function GameListWindow:addMatchCell2(begin,over,array)
    local temp = array
    -- if over >4 then
    --     over = 4
    -- end
    for i = begin, over do
        local match_node = self.imgDetail:clone()
        local lableMatchTitle = self:GetWidgetByName("Lable_MatchTitle", match_node)
        lableMatchTitle:setString(temp[i].RoomName)
        local num = temp[i].CurJoinNum
        if num < 0 then
            local num = 0
        end
        local texture_Array = string.split(temp[i].Icon ,',')
        local icon  = self:GetWidgetByName("Image_Photo_JB", match_node)
        
        icon:loadTexture(texture_Array[1])
        icon:setLocalZOrder(1010)
        icon:setScale(0.4)
        local circle = self:GetWidgetByName("Image_33", match_node)
        if texture_Array[2] ~= nil then
            local count = ccui.ImageView:create(texture_Array[2],1)
            count:setPosition(78,60)
            count:setLocalZOrder(1100)
            count:addTo(icon)
        end
        self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(num)  --当前在线人数
        self:GetWidgetByName("Label_Item_ChampAward",match_node):setString("冠军"..temp[i].BaomingInfo)

        self.Label_Item_Time = self:GetWidgetByName("Label_Item_Time",match_node)
        self.Label_Item_Subtitle = self:GetWidgetByName("Label_Item_Subtitle",match_node)
        self.Label_Item_BaomingFee = self:GetWidgetByName("Label_Item_BaomingFee",match_node)
        -- 显示报名费
        local str = ""
        local baoming_Arrays = temp[i].Baomingfei
        local isFree  = self:getItemFree(baoming_Arrays)
        if isFree then
            str = "免费\n"
        else
            if baoming_Arrays and type(baoming_Arrays) == "table" and #baoming_Arrays > 0 then
                for k,v in pairs(baoming_Arrays) do
                    if  v.payment_method and (v.payment_method == "fee1" or v.payment_method == "fee2") then
                        if v.payment_info and v.payment_info[1].num and tonumber(v.payment_info[1].num) > 0 then 
                            if tonumber(v.payment_info[1].num) > 0 then
                                local Itemsdata = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",tonumber(v.payment_info[1].id))
                                str = str..Itemsdata.ItemName.."X"..v.payment_info[1].num.."\n"
                            end
                        end
                    end
                end
            end
        end
        self.Label_Item_BaomingFee:setString(str)

        local day = os.time()   -- 得到当前的秒数
        -- local time = temp[i].JoinBTime
        if temp[i].RoomType == 2 then --定时开赛
            -- print( os.date("%m月" .. "%d日" .."%X", time, time, time))
            -- if os.date("%d", time) == os.date("%d", day) then              -- 判断是否是今天
            --     local h = os.date("%H", time)..":00"
            --     self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(h)
            -- elseif os.date("%d", time) - os.date("%d", day) > 0 and os.date("%d", time) - os.date("%d", day) <= 1 then
            --     local h = os.date("%H", time)..":00"
            --     self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(h)
            -- else
                -- local h = os.date("%H", time)..":00"
                -- self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(h)
            -- end
            local h = os.date("%H", temp[i].JoinBTime)..":00--"..os.date("%H", temp[i].JoinETime)..":00"
            self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(h)

            local diffhour = 24 - tonumber(os.date("%H",os.time()))
            local diff = temp[i].JoinBTime-os.time()
            local hour = (diff)/24/60/60 - diffhour/24
            local day = ""
            if hour >=2 then
                self.Label_Item_Time:setString(os.date("%m",temp[i].JoinBTime).."月"..os.date("%d",temp[i].JoinBTime).."日")
            elseif hour>=1 then
                self.Label_Item_Time:setString("后天")
            elseif hour>=0 then
                self.Label_Item_Time:setString("明天") 
            else
                self.Label_Item_Time:setString("今天")
            end

        else --SNG人满开赛 --现在没有时间段的
            local beginTime = os.date("%H",temp[i].JoinBTime)..":"..os.date("%M",temp[i].JoinBTime)
            local endTime = os.date("%H",temp[i].JoinETime)..":"..os.date("%M",temp[i].JoinETime)
            self.Label_Item_Time:setString(beginTime.."-"..endTime)
            self:GetWidgetByName("Label_Item_Subtitle", match_node):setString("满".. temp[i].JoinMinLimit.. "人开赛")
        end
        if day<temp[i].JoinBTime then --没开赛的人数归0
            self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(0) 
        else
            local h2 = os.date("%H",temp[i].JoinETime)
            local m2 = os.date("%M",temp[i].JoinETime)--string.match(temp[i].JoinETime,"(%d+):(%d+)")
            h2 = tonumber(h2)
            m2 = tonumber(m2)
            local h1 = tonumber(os.date("%H",day))
            local m1 = tonumber(os.date("%M",day))
            if h1*3600 +m1*60 > h2*3600 + m2*60 and day>=temp[i].JoinBTime then
                self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(0) 
            end
        end
        --~~~~~~~~~~~~~~~~~~~~~~~~蓝色报名按钮
        local btnSignUp = self:GetWidgetByName("Button_Signup",match_node)
        btnSignUp:addTouchEventListener(handler(self, self.goDetails))
        btnSignUp.itemId = i
        --~~~~~~~~~~~~~~~~~~~~~~~~~退赛按钮
        local Image_Signed = self:GetWidgetByName("Image_Signed",match_node)
        Image_Signed:addTouchEventListener(handler(self, self.goDetails))
        Image_Signed.itemId = i
        --~~~~~~~~~~~~~~~~~~~~~~~~绿色报名按钮
        local btn_Signed_free = self:GetWidgetByName("Button_Signup_free",match_node)
        btn_Signed_free:addTouchEventListener(handler(self, self.goDetails))
        btn_Signed_free.itemId = i
        btn_Signed_free:setVisible(false)
        --~~~~~~~~~~~~~~~~~~~~~~~~不可报名按钮
        local Button_unSignup = self:GetWidgetByName("Button_unSignup",match_node) --不可报名按钮
        Button_unSignup:addTouchEventListener(handler(self, self.goDetails))
        Button_unSignup.itemId = i

        --~~~~~~~~~~~~~~~~~~~~~~~~背景
        local node = self:GetWidgetByName("Image_bg", match_node)
        node:addTouchEventListener(handler(self,self.goDetails))
        node.itemId = i
        local move_time = 0.4+i*0.05
        self.ListView_2:setVisible(true)
        self.ListView_2:pushBackCustomItem(match_node)
        if self.isAction then
            match_node:setVisible(false)
            local arr = {}
            table.insert(arr, cc.MoveBy:create(0,cc.p(0,-516)))
            table.insert(arr,cc.CallFunc:create(function(match_node)
                match_node:setVisible(true)
            end))
            table.insert(arr, cc.MoveBy:create(move_time,cc.p(0,516)))
            match_node:runAction(cc.Sequence:create(arr))
        end
        -- node.time = temp[i].JoinBTime
        node.RoomType = temp[i].RoomType
        node.roomId = temp[i].RoomID   

        -- self.imgDetail.time = temp[i].JoinBTime
        self.imgDetail.RoomType = temp[i].RoomType
        self.imgDetail.roomId = temp[i].RoomID
        -- btnSignUp.time = temp[i].JoinBTime
        btnSignUp.RoomType =temp[i].RoomType
        btnSignUp.roomId = temp[i].RoomID

        -- btn_Signed_free.time = temp[i].JoinBTime
        btn_Signed_free.RoomType =temp[i].RoomType
        btn_Signed_free.roomId = temp[i].RoomID

        -- Image_Signed.time = temp[i].JoinBTime
        Image_Signed.RoomType =temp[i].RoomType
        Image_Signed.roomId = temp[i].RoomID

        -- Button_unSignup.time = temp[i].JoinBTime
        Button_unSignup.RoomType = temp[i].RoomType
        Button_unSignup.roomId = temp[i].RoomID


        Button_unSignup:setVisible(temp[i].Sate == 0)                -- 不能报名
        Image_Signed:setVisible(temp[i].Sate == 2)                   -- 退报名
        btn_Signed_free:setVisible(temp[i].Sate == 1 and isFree )    -- 免费报名
        btnSignUp:setVisible(temp[i].Sate == 1 and not isFree )      -- 报名
        self.imgDetail:setTouchEnabled(0 == temp[i].SelfJoin)        -- 没加入
        self.imgDetail:setEnabled(0 == temp[i].SelfJoin)             -- 没加入
        match_node.RoomID = temp[i].RoomID
        self.matchNodeList[temp[i].RoomID]=match_node
    end
end

function GameListWindow:initUI()-- 初始化界面
    laixiaddz.LocalPlayercfg.LaixiaMatchlastStage = 1
    laixiaddz.LocalPlayercfg.LaixiaMatchDifen = 0
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MARKEDWORDS_WINDOW)   --关闭前置界面
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRESULT_WINDOW)
end

function GameListWindow:updateSelectButton()
    if self.mIsShow then
        if 1 == self.mPageType then
            self.Button_jinbi:setVisible(true)
            self.Button_huafei_Front:setVisible(true)

            self.Button_jinbi:setTouchEnabled(true)
            self.Button_jinbiFront:setVisible(false)

            self.Button_huafei:setVisible(false)
        elseif 2 == self.mPageType then
            self.Button_jinbi:setVisible(false)
            self.Button_huafei:setVisible(true)
            self.Button_huafei_Front:setVisible(false)
            self.Button_jinbiFront:setVisible(true)
        end
    end
end


function GameListWindow:goGoldMatch(sender, eventType)
    if 1 == self.mPageType then
        return
    end
    self.mPageType = 1
    -- self:sendRenmanPacket()
    self:sendMatchListReq()
end

function GameListWindow:goBillMatch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if 2 == self.mPageType then
            return
        end
        self.mPageType = 2
        self:updateSelectButton()
        self:sendMatchListReq()
    end
end

function GameListWindow:updataMatchlist()
    if self.mIsShow then
        local temp = self.matchNodeList[laixiaddz.LocalPlayercfg.LaixiaMatchRoom]
        self.tempMatchInfo = nil
        for k, v in ipairs(self.matchInfo[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms) do
            if laixiaddz.LocalPlayercfg.LaixiaMatchRoom == v.RoomID then
                self.tempMatchInfo = v
                break
            end
        end
        if temp and self.tempMatchInfo then
            local isFree = self:getItemFree(self.tempMatchInfo.Baomingfei)
            self:GetWidgetByName("Button_unSignup",temp):setVisible(self.tempMatchInfo.Sate == 0)                -- 不能报名
            self:GetWidgetByName("Image_Signed",temp):setVisible(self.tempMatchInfo.Sate == 2)                   -- 退报名
            self:GetWidgetByName("Button_Signup",temp):setVisible(self.tempMatchInfo.Sate == 1 and not isFree )  -- 报名
            self:GetWidgetByName("Button_Signup_free",temp):setVisible(self.tempMatchInfo.Sate == 1 and isFree ) -- 免费报名
            local num = self.tempMatchInfo.CurJoinNum or 0
            if num < 0 then num = 0 end
            self:GetWidgetByName("Label_Item_CurrentNum", temp):setString(num)
        end
    end
end

--[[
 * 报名及退赛界面 GameListDetailWindow
 * @param  sender
 * @param  eventType
--]]
function GameListWindow:goDetails(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixiaddz.LocalPlayercfg.LaixiaMatchRoom = sender.roomId
        laixiaddz.LocalPlayercfg.LaixiaMatchRoomType = sender.RoomType
        if sender.RoomType == 1 then
            laixiaddz.LocalPlayercfg.LaixiaisSNG = true
        end
        if sender.itemId then
            local event = {}
            event = laixiaddz.LocalPlayercfg.LaixiaMatchdata[1].rooms[sender.itemId]
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLISTDETAIL_WINDOW,event)
        end
    end
end

--[[
 * 启动定时器
 * @param  nil
--]]
function GameListWindow:startTimer()
    if not self.__Timer then
        self.__Timer = scheduler.scheduleGlobal(function(dt)
            self:schedulerTick(dt)
        end, 0.2) -- 时间限制
    end
end

--[[
 * 消耗定时器
 * @param  nil
--]]
function GameListWindow:stopTimer()
    if self.__Timer then
        scheduler.unscheduleGlobal(self.__Timer)
        self.__Timer = nil
    end 
end

function GameListWindow:schedulerTick(dt)
    if self.mIsShow == true then
        self.mTime = ""
        local day = os.time()
        local temp = string.format("%.2d",tonumber(os.date("%H", day))) .. ":" ..string.format("%.2d",tonumber(os.date("%M", day)))
        if(self.Text_Time ~= nil and self.mTime ~=temp ) then
            self.mTime = temp
            self.Text_Time:setString(self.mTime)
        end
        -- TODO REMOVE ↓
        -- if laixiaddz.LocalPlayercfg.LaixiaIsInMatch == true then
        --     self.isNeedModify = false
        -- end
        -- if self.isNeedModify == true then
        --     self.refreshListTime = self.refreshListTime + 1
        --     if self.refreshListTime>20 then
        --         self.refreshListTime = 0
        --         self:updateRefreshList()
        --     end
        -- end


        -- TODO 刷列表信息
        -- self.time = self.time + dt
        -- if self.time >= 10 then
        --     self.time = 0
        --     for i, var in pairs(self.matchNodeList) do
        --         for index=1,#self.matchInfo[1].rooms do
        --             local v = self.matchInfo[1].rooms[index]
        --             if self.matchNodeList[i].RoomID == v.RoomID then
        --                 local temp = self.matchNodeList[i]
        --                 self.tempMatchInfo  = v
        --                 if temp and self.tempMatchInfo then
        --                     if day < v.JoinBTime then
        --                         -- 没到报名时间
        --                         self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
        --                         self:GetWidgetByName("Image_Signed",temp):setVisible(false)
        --                         self:GetWidgetByName("Button_Signup",temp):setVisible(false)
        --                         self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
        --                     elseif day > v.JoinBTime and  day < v.JoinETime then
        --                         local isFree = self:getItemFree(self.tempMatchInfo.Baomingfei)
        --                         self:GetWidgetByName("Button_unSignup",temp):setVisible(self.tempMatchInfo.Sate == 0)                -- 不能报名
        --                         self:GetWidgetByName("Image_Signed",temp):setVisible(self.tempMatchInfo.Sate == 2)                   -- 退报名
        --                         self:GetWidgetByName("Button_Signup_free",temp):setVisible(self.tempMatchInfo.Sate == 1 and isFree ) -- 免费报名
        --                         self:GetWidgetByName("Button_Signup",temp):setVisible(self.tempMatchInfo.Sate == 1 and not isFree )  -- 报名
        --                         self.imgDetail:setTouchEnabled(0 == self.tempMatchInfo.SelfJoin)
        --                     elseif v.RoomType == 1 and day >= v.BeginTime then
        --                         -- 定时赛场 比赛已经开始 重新请求列表信息
        --                         self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
        --                         self:GetWidgetByName("Image_Signed",temp):setVisible(false)
        --                         self:GetWidgetByName("Button_Signup",temp):setVisible(false)
        --                         self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
        --                         self.isNeedModify = false
        --                         -- self:sendMatchListReq()
        --                     end
        --                 end
        --             end
        --         end
        --     end
        -- end
    end
end

--[[
 * 进行适配
 * @param  nil
--]]
function GameListWindow:setAdaptation()
    if(self.hDialogType ~= DialogTypeDef.DEFINE_SINGLE_DIALOG) then
    end
    if device.platform == "ios" then
        --暂时先 适配 iphoneX
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self:GetWidgetByName("Image_1"):setScaleX(2436/3*2/1280)
        end
    end
end

--[[
 * 获取当前比赛是否免费
 * @param  arr = 
 * {
 *     1 = {payment_method,payment_info={1={num,id}}
 *     2 = {payment_method,payment_info={1={num,id}}
 * }
 * @retrun  true 免费
--]]
function GameListWindow:getItemFree(arr)
    local isf = true
    if arr and type(arr) == "table" and #arr > 0 then
        for k,v in pairs(arr) do
            if v.payment_method and (v.payment_method == "fee1" or v.payment_method == "fee2") then
                if v.payment_info and v.payment_info[1].num and tonumber(v.payment_info[1].num) > 0 then 
                    isf = false
                    return isf 
                end
            end
        end
    end
    return isf
end

--[[
 * 注销
 * @param  arr = nil
--]]
function GameListWindow:onDestroy()
    self:stopTimer()
    self.mIsShow = false
    self.isNeedModify  = false
    self.time = 0
    self.matchInfo = {}
    self.mPageType = 0
    self.matchNodeList ={}
    self.isAction = true
end

return GameListWindow.new()