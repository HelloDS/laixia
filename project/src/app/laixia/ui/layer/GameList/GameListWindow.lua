-- region GameListWindow.lua

-- 比赛列表

local GameListWindow = class("GameListWindow", import("...CBaseDialog"):new())--
local soundConfig = laixia.soundcfg;
local Packet = import("....net.Packet")

local db2 = laixia.JsonTxtData
local itemDBM

function GameListWindow:ctor(...)

    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
end

function GameListWindow:getName()
    -- 返回当期啊界面的名字，用来在表中索引表在WindowManager中
    return "GameListWindow"
end

function GameListWindow:onInit()
    self.super:onInit(self)

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW, handler(self, self.show))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_MATCHLIST_WINDOW, handler(self, self.destroy))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW, handler(self, self.updataMatchlist))  --更新列表页中比赛的状态（报名或者退出报名）

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW,handler(self, self.updataPanel)) --更新当前标签的数据

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_SIGN,handler(self, self.showSign)) --显示标签

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_GAMELIST_GOGAMELIST,handler(self, self.goMatchList))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SENDRENMAN_GOGAMELIST, handler(self, self.goMatchGameByrenman))--liguilong 请求比赛列表请求

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SENDDINGSHI_GOGAMELIST, handler(self, self.goMatchGameBydingshi))

    self.mIsShow = false
    self.time = 0
    self.refreshListTime = 0
    self.isNeedModify = false
end

function GameListWindow:goMatchGameByrenman()
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
end

function GameListWindow:sendRenmanPacket()
    -- local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
    -- CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
    -- CSMatchListPacket:setValue("PageType", 2 )
    -- laixia.net.sendPacketAndWaiting(CSMatchListPacket)
end

function GameListWindow:sendDingshiPacket()
    local CSMatchSignPacket = Packet.new("CSMatchSign", _LAIXIA_PACKET_CS_MatchSignID)
    CSMatchSignPacket:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendPacketAndWaiting(CSMatchSignPacket)  
    -- local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
    -- CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
    -- CSMatchListPacket:setValue("PageType", 1 )
    -- laixia.net.sendPacketAndWaiting(CSMatchListPacket)
end

function GameListWindow:goMatchGameBydingshi()
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
    self:sendDingshiPacket()
end

function GameListWindow:goMatchList()
    local CSMatchSignPacket = Packet.new("CSMatchSign", _LAIXIA_PACKET_CS_MatchSignID)
    CSMatchSignPacket:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendPacketAndWaiting(CSMatchSignPacket)  

    -- local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
    -- CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
    -- CSMatchListPacket:setValue("PageType", 1 )--laixia.LocalPlayercfg.LaixiaGamePageType
    -- laixia.net.sendPacketAndWaiting(CSMatchListPacket)
end

function GameListWindow:onShow()
    laixia.soundTools.playMusic(soundConfig.SCENE_MUSIC.lobby,true);
    if self.mIsShow == false then
        self:setAdaptation()
        --增加一个定位的标识
        cc.UserDefault:getInstance():setStringForKey("lastwindow","ddz_GameListWindow")
        cc.UserDefault:getInstance():setDoubleForKey("lastwindow_time",os.time())
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_COMMONTOP_WINDOW,
            {
                goBackFun = function()
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)
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
        if device.platform ~= "windows" then
            self:sendCurVersion()
        end
        
        self.mIsShow = true
    end
    --第一次进入gamelist的标志
    self.firstJoin = true
    self.mIndex = 0
    self.mIndex2 = 0
    self.time1 = 0
    self.Panel_guodu = self:GetWidgetByName("Panel_guodu")
    self.Panel_guodu:setTouchEnabled(true)
    self.Panel_guodu:setSwallowTouches(true)

    self.matchInfo = {}
    self.matchNodeList = {}
    self.ListView:removeAllItems()
    self.ListView:setVisible(false)
    self.ListView_2:setVisible(false)
end

--发送我本地版本号
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

--更新当前的标签数据
function GameListWindow:updataPanel()
    if self.mIsShow then
        --isNeedModify  判断是否需要刷新的字段
        if self.isNeedModify == true then
            self.matchInfo = laixia.LocalPlayercfg.LaixiaMatchdata
            self:TopMatchNode()
            self:refreshMatchList_new()
        else ---置顶的逻辑
            --如果不需要刷新字段 
            --1.ListView移除上面的所有控件
            self.ListView:removeAllItems()
            self.matchNodeList ={}
            --默认页签的比赛数据 *****
            self.matchInfo = laixia.LocalPlayercfg.LaixiaMatchdata
            --默认页签的名称
            self.sign_name = laixia.LocalPlayercfg.LaixiaGamePageName
            --2.排序比赛 置顶比赛
            self:TopMatchNode()
            --页签类型数组 ***** 这个数组做什么用的   
            self.mPageType = laixia.LocalPlayercfg.LaixiaGamePageType
            --s
            self.mIndex = 0
            self:initUI()
        end
        self:SpiltChannel()
    end
end

--置顶比赛 伊诺凯和映客
function GameListWindow:TopMatchNode()
    local matchInfoTemp = {}
    for i=1,#self.matchInfo do
        matchInfoTemp[i]={}
        matchInfoTemp[i].rooms={}
        for j=1,#self.matchInfo[i].rooms do
            --伊诺凯的比赛置顶
            if self.matchInfo[i].rooms[j].isTop == 1 then
                matchInfoTemp[i].rooms[#matchInfoTemp[i].rooms+1] = self.matchInfo[i].rooms[j]
            end
        end
    end
    --筛屌这两个比赛的其他比赛
    for i=1,#self.matchInfo  do
        for j=1,#self.matchInfo[i].rooms do 
            if self.matchInfo[i].rooms[j].isTop ~= 1 then
                matchInfoTemp[i].rooms[#matchInfoTemp[i].rooms+1] = self.matchInfo[i].rooms[j]
            end
        end
    end
    self.matchInfo = matchInfoTemp
end

--拆分渠道专享的比赛 
function GameListWindow:SpiltChannel()
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

    self.matchInfoTemp2 = {}
    if self.matchInfo ~= nil and #self.matchInfo ~=0 then
        if self.matchInfo[1].rooms ~=nil and #self.matchInfo[1].rooms ~= 0 then
            for i=1,#self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms do
                local baoming_Array =  string.split(self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i].Baomingfei ,',')
                local value = baoming_Array[1]--string.split(baoming_Array,',')[1]

                if string.split(value,':')[1] == "-2" then
                    if tonumber(string.split(value,":")[2]) == tonumber(laixia.LocalPlayercfg.CHANNELID) or device.platform == "windows" then
                        self.matchInfoTemp2[#self.matchInfoTemp2+1] = DeepCopy(self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i])
                    end
                else
                    self.matchInfoTemp2[#self.matchInfoTemp2+1] = DeepCopy(self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i])
                end
            end
    
            self.ListView_2:removeAllItems()
            for i=1,4 do
                local match_node = self.imgDetail:clone()
                self.ListView_2:pushBackCustomItem(match_node)
                match_node:setVisible(false)
            end
            --之前直接调用了这个 并且带有从下向上移动效果
            --self.mIndex2 = #self.matchInfoTemp2
            --self:addMatchCell2(1,self.mIndex2,self.matchInfoTemp2)
           -- self:showSign()
             self.mIndex2 = #self.matchInfoTemp2
             --之前直接调用了这个 并且带有从下向上移动效果
             self:addMatchCell2(1,self.mIndex2,self.matchInfoTemp2)
        end
    end 
end

--请求标签数据的回调方法
--标签的显示和位置调整 
function GameListWindow:showSign()

    self.sign_data = laixia.LocalPlayercfg.LaixiaMatchSigndata
    --深拷贝
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
    --cocostudio的十五个控件全部隐藏   
    --定义变量 
    local sign_size = self:GetWidgetByName("Button_sign_1"):getContentSize().width
    for i=1,5 do
        self:GetWidgetByName("Button_sign_copy_"..i):setVisible(false)
        self:GetWidgetByName("Button_sign_"..i):setVisible(false)
        self:GetWidgetByName("Text_sign_"..i):setVisible(false)
    end
    
   
    --#self.matchInfoTemp2
    --**********
    for i=1,#self.sign_data do
        local diff= ((-#self.sign_data/2+0.5)+i-1)*sign_size
        self:GetWidgetByName("Button_sign_"..i):addTouchEventListener(handler(self, self.showSignButton))
        self:GetWidgetByName("Button_sign_"..i).old = i
        --self:GetWidgetByName("Button_sign_"..i).id = i
        self:GetWidgetByName("Button_sign_"..i):setPositionX(display.cx+diff)
        self:GetWidgetByName("Text_sign_"..i):setPositionX(display.cx+diff)
        self:GetWidgetByName("Button_sign_copy_"..i):setPositionX(display.cx+diff)
        self:GetWidgetByName("Text_sign_"..i):setString(self.sign_data[i].PageName)--self.sign_data[i].PageName   self.sign_name[i] --
        self:GetWidgetByName("Button_sign_copy_"..i):setVisible(true)
        self:GetWidgetByName("Button_sign_"..i):setVisible(true)
        self:GetWidgetByName("Text_sign_"..i):setVisible(true)
        --**********
        if tonumber(self.sign_data[i].DefaultDisplay) == 1 then--self.matchInfoTemp2[i].defaultdisplay == 1 then
            --记录当前按下的按钮
            --数据处理 找到默认显示的字段用一个成员变量记录一下 self.indexsign
            self.indexsign = i
             --第一次 self.indexsign = 默认的标签
            --**********
            --if self.firstJoin == true then
            self.indexsign_2 = self.sign_data[i].PageType  --
                --self.firstJoin = false
           -- end
           local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
            CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
            CSMatchListPacket:setValue("PageType", self.indexsign_2 )
            laixia.net.sendPacketAndWaiting(CSMatchListPacket)
            
            --self.sign_data[i].Type
            self:GetWidgetByName("Button_sign_copy_"..i):setVisible(true)
            self:GetWidgetByName("Button_sign_"..i):setVisible(false)
            self:GetWidgetByName("Text_sign_"..i):setVisible(true)
           
            --这个地方应该调用一下addMatchCell 用处理好的数据   每次更新界面或者点击了其他标签请求其他标签的数据的时候都调用addMatchCell2 和 addMatchCell
            --为什么要把addMatchCell放在onTick中呢？
            --self:addMatchCell(1,self.mIndex2)
        end  
    end
end

--标签按钮的回调
function GameListWindow:showSignButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        --将点击的按钮的按下状态显示 之前的按下状态的按钮设为正常状态
        self:GetWidgetByName("Button_sign_"..sender.old):setVisible(false)
        self:GetWidgetByName("Button_sign_copy_"..sender.old):setVisible(true)
        --**********
        self:GetWidgetByName("Button_sign_"..self.indexsign):setVisible(true)
        self:GetWidgetByName("Button_sign_copy_"..self.indexsign):setVisible(false)

        --local temp = self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms
        if sender.old == 1 then
            --发送请求该标签的数据
            self.indexsign = 1
            self.indexsign_2 = self.sign_data[1].PageType
            --self.ListView:removeAllItems()
            --self.ListView:setVisible(false)
            --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW,self.matchInfoTemp2)
            ----self:addMatchCell(1,#self.matchInfoTemp2)
        elseif sender.old == 2 then
            --发送请求该标签的数据
            --self:gotoBisaichang(2)
            self.indexsign = 2
            self.indexsign_2 = self.sign_data[2].PageType
            -- self.ListView:removeAllItems()
            -- self.ListView:setVisible(false)
            --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW,self.matchInfoTemp2)
            ----self:addMatchCell(1,#self.matchInfoTemp2)
        elseif sender.old == 3 then
            --self:gotoBisaichang(3)
            self.indexsign = 3
            self.indexsign_2 = self.sign_data[3].PageType
            -- self.ListView:removeAllItems()
            -- self.ListView:setVisible(false)
            --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW,self.matchInfoTemp2)
            ----self:addMatchCell(1,#self.matchInfoTemp2)
        elseif sender.old == 4 then
            --self:gotoBisaichang(4)
            self.indexsign = 4
            self.indexsign_2 = self.sign_data[4].PageType
            -- self.ListView:removeAllItems()
            -- self.ListView:setVisible(false)
            --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW,self.matchInfoTemp2)
            ----self:addMatchCell(1,#self.matchInfoTemp2)
            --发送请求该标签的数据
        elseif sender.old == 5 then
            --self:gotoBisaichang(5)
            self.indexsign = 5
            self.indexsign_2 = self.sign_data[5].PageType
            -- self.ListView:removeAllItems()
            -- self.ListView:setVisible(false)
            --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW,self.matchInfoTemp2)
            ----self:addMatchCell(1,#self.matchInfoTemp2)
            --发送请求该标签的数据
        end

        self.Panel_guodu:setTouchEnabled(true)
        self.Panel_guodu:setSwallowTouches(true)
        self:gotoBisaichang(self.indexsign_2)
    end
end

--发送请求点击标签页的比赛的数据
function GameListWindow:gotoBisaichang(pagetype)
    local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
    CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
    CSMatchListPacket:setValue("PageType", pagetype )
    laixia.net.sendPacketAndWaiting(CSMatchListPacket)
end

--添加比赛列表的移动效果
function GameListWindow:addMatchCell2(begin,over,array)
    local temp = array
    self.ListView:setVisible(false)
    --local temp = self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms
    if over >4 then
        over = 4
    end
    for i = begin, over do
        --应该加上判断是5个类型的 if msg.type == self.senderid then 满足当前点击的那个类型的比赛才加进去  ontick也应该根据类型进行是否添加比赛
        local match_node = self.imgDetail:clone()

        local lableMatchTitle = self:GetWidgetByName("Lable_MatchTitle", match_node)
        --local tmp = string.gsub(temp[i].RoomName,"金币",laixia.utilscfg.CoinType());
        lableMatchTitle:setString(temp[i].RoomName)

        local num = temp[i].CurJoinNum
        if num < 0 then
            local num = 0
        end
        local texture_Array = string.split(temp[i].Icon ,',')
        local icon  = self:GetWidgetByName("Image_Photo_JB", match_node)
        
        icon:loadTexture(texture_Array[1])
        icon:setLocalZOrder(10)
        icon:setScale(0.4)
        local circle = self:GetWidgetByName("Image_33", match_node)
        local system = laixia.ani.CocosAnimManager
        self.rewardlcon = system:playAnimationAt(match_node,"doudizhu_rewardlcon")
        self.rewardlcon:pos(circle:getPositionX(),circle:getPositionY())
        if texture_Array[2] ~= nil then
            local count = ccui.ImageView:create(texture_Array[2],1)
            count:setPosition(78,60)
            --count:setScale(1)
            count:setLocalZOrder(100)
            count:addTo(icon)
        end
        self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(num)  --当前在线人数
        --local tmp = string.gsub(temp[i].BaomingInfo,"金币",laixia.utilscfg.CoinType());
        --self:GetWidgetByName("Label_Item_Subtitle",match_node):setString(temp[i].BaomingInfo)

        self:GetWidgetByName("Label_Item_ChampAward",match_node):setString("冠军"..temp[i].BaomingInfo)

        local day = os.time()   -- 得到当前的秒数
        local time = temp[i].Time
        local str = nil
        self.Label_Item_Time = self:GetWidgetByName("Label_Item_Time",match_node)
        self.Label_Item_Subtitle = self:GetWidgetByName("Label_Item_Subtitle",match_node)
        self.Label_Item_BaomingFee = self:GetWidgetByName("Label_Item_BaomingFee",match_node)

       local baoming_Array
       local baoming_Arrays = string.split(temp[i].Baomingfei ,',')
       if #baoming_Arrays >1 then
            baoming_Array = string.split(baoming_Arrays[1] ,":") 
            --baoming_Array = string.splite(baoming_Arrays[1] ,":") 
       else    
           baoming_Array = string.split(temp[i].Baomingfei,':')
       end
       
       if baoming_Array[1]=="-1" or baoming_Array[1]=="-2" then
            self.Label_Item_BaomingFee:setString("渠道专享")
       else
            local Itemsdata = laixia.JsonTxtData:queryTable("items"):query("ItemID",tonumber(baoming_Array[1]))
            if tonumber(baoming_Array[2])==0 then
                self.Label_Item_BaomingFee:setString("免费")
            else
                self.Label_Item_BaomingFee:setString(Itemsdata.ItemName.."X"..baoming_Array[2])
            end
        end
        if temp[i].RoomType == 0 then --定时开赛
            if os.date("%d", time) == os.date("%d", day) then              -- 判断是否是今天
                print( os.date("%d", time) ,os.date("%d", day))
                str = os.date( "%X",  time)

                str = string.split(str, "00:00")
                -- 整点开赛
                if str[2] == "" then
                    str[1] = str[1] .. "00"
                else
                    str = string.split(str[1], ":00")
                end

                self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(str[1])
            elseif os.date("%d", time) - os.date("%d", day) > 0 and os.date("%d", time) - os.date("%d", day) <= 1 then
                str = os.date( "%X",  time)
                str = string.split(str, "00:00")
                -- 整点开赛
                if str[2] == "" then
                    str[1] = str[1] .. "00"
                else
                    str = string.split(str[1], ":00")
                end
                self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(str[1])
            else
                str = os.date("%X", time)
                str = string.split(str, "00:00")
                -- 整点开赛
                if str[2] == "" then
                    str[1] = str[1] .. "00"
                else
                    str = string.split(str[1], ":00")
                end
                self:GetWidgetByName("Label_Item_Subtitle", match_node):setString( str[1])
            end
            local diff = temp[i].Time-os.time()
            local diffhour = 24 - tonumber(os.date("%H",os.time()))
            local hour =  diff/24/60/60 - diffhour/24
            if hour >=2 then
                    self.Label_Item_Time:setString(os.date("%m",temp[i].Time).."月"..os.date("%d",temp[i].Time).."日")
            elseif hour>=1 then
                self.Label_Item_Time:setString("后天")
            elseif hour>=0  then
                self.Label_Item_Time:setString("明天") 
            else
                self.Label_Item_Time:setString("今天")--os.date("%H:%M",time))
            end
        else --SNG人满开赛 --现在没有时间段的
            self.Label_Item_Time:setString(temp[i].BeginTime.."-"..temp[i].EndTime)
            self:GetWidgetByName("Label_Item_Subtitle", match_node):setString("满".. temp[i].JoinMinLimit.. "人开赛")
        end
        if day<temp[i].JoinTimes then --没开赛的人数归0
            self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(0) 
        else
            local h2,m2 = string.match(temp[i].EndTime,"(%d+):(%d+)")
            h2 = tonumber(h2)
            m2 = tonumber(m2)
            local h1 = tonumber(os.date("%H",day))
            local m1 = tonumber(os.date("%M",day))
            if h1*3600 +m1*60 > h2*3600 + m2*60 then
                self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(0) 
            end
        end
        --~~~~~~~~~~~~~~~~~~~~~~~~蓝色报名按钮
        local btnSignUp = self:GetWidgetByName("Button_Signup",match_node)
        btnSignUp:addTouchEventListener(handler(self, self.goDetails))
        --~~~~~~~~~~~~~~~~~~~~~~~~~退赛按钮
        local Image_Signed = self:GetWidgetByName("Image_Signed",match_node)
        Image_Signed:addTouchEventListener(handler(self, self.goDetails))
        --~~~~~~~~~~~~~~~~~~~~~~~~绿色报名按钮
        local btn_Signed_free = self:GetWidgetByName("Button_Signup_free",match_node)
        btn_Signed_free:addTouchEventListener(handler(self, self.goDetails))
        --~~~~~~~~~~~~~~~~~~~~~~~~不可报名按钮
        local Button_unSignup = self:GetWidgetByName("Button_unSignup",match_node) --不可报名按钮
        Button_unSignup:addTouchEventListener(handler(self, self.goDetails))

        --~~~~~~~~~~~~~~~~~~~~~~~~背景
        local node = self:GetWidgetByName("Image_bg", match_node)
        node:addTouchEventListener(handler(self,self.goDetails))
        local move_time = 0.7+i*0.05
        self.ListView_2:setVisible(true)
        self.ListView_2:pushBackCustomItem(match_node)
        local moveton = cc.MoveBy:create(move_time,cc.p(5.5,516))
        --设置多久进行抖动
        local dd_time 
        
        local function remoList()
            print("aaaaaaaaaaaaaa")
            self.ListView_2:setVisible(false)
           -- self.Panel_guodu:setVisible(false)
            self.Panel_guodu:setSwallowTouches(false)
            self.ListView:setVisible(true)
        end

        local function moveList()
            print("bbbbbbbbbbbbbbb")
            --self.ListView:setPosition(cc.p(89.33,27,67))
            local moveto1 = cc.MoveTo:create(0.10,cc.p(89.33,26.5))
            local moveto2 = cc.MoveTo:create(0.10,cc.p(89.33,28.3))
            local seq1 = cc.Sequence:create(moveto1,moveto2)
            self.ListView_2:runAction(seq1)
        end

        local func1 = cc.CallFunc:create(remoList)
        local func2 = cc.CallFunc:create(moveList)
        local det = cc.DelayTime:create(0.4)
        

        if #temp == 1 and over == 1 then
            dd_time = 0.75
            local detalytime_dd = cc.DelayTime:create(dd_time)
            local seq = cc.Sequence:create(detalytime_dd,func2,det,func1)
            self.Image_1:runAction(seq)
        elseif #temp == 2 and i == 2 then
            dd_time = 0.8

            local detalytime_dd = cc.DelayTime:create(dd_time)
            local seq = cc.Sequence:create(detalytime_dd,func2,det,func1)
            self.Image_1:runAction(seq)
        elseif #temp == 3 and i == 3 then
            dd_time = 0.85

            local detalytime_dd = cc.DelayTime:create(dd_time)
            local seq = cc.Sequence:create(detalytime_dd,func2,det,func1)
            self.Image_1:runAction(seq)
        elseif #temp >= 4 and i == 4 then
            dd_time = 0.9

            local detalytime_dd = cc.DelayTime:create(dd_time)
            local seq = cc.Sequence:create(detalytime_dd,func2,det,func1)
            self.Image_1:runAction(seq)
        end
        
        match_node:runAction(moveton)
        
        
        node.time = temp[i].Time
        node.RoomType = temp[i].RoomType
        node.roomId = temp[i].RoomID   

        self.imgDetail.time = temp[i].Time
        self.imgDetail.RoomType = temp[i].RoomType
        self.imgDetail.roomId = temp[i].RoomID
        btnSignUp.time = temp[i].Time
        btnSignUp.RoomType =temp[i].RoomType
        btnSignUp.roomId = temp[i].RoomID

        btn_Signed_free.time = temp[i].Time
        btn_Signed_free.RoomType =temp[i].RoomType
        btn_Signed_free.roomId = temp[i].RoomID

        Image_Signed.time = temp[i].Time
        Image_Signed.RoomType =temp[i].RoomType
        Image_Signed.roomId = temp[i].RoomID

        Button_unSignup.time = temp[i].Time
        Button_unSignup.RoomType = temp[i].RoomType
        Button_unSignup.roomId = temp[i].RoomID
       --  -------------------------------------------------
        ---state 2 报名中
        --1比赛开始前
        --3比赛中 4比赛结束
        if temp[i].Sate==2 then
            --可以报名
            if 0 == temp[i].SelfJoin then --没报名
                if tonumber(baoming_Array[2])==0 then --免费
                    btnSignUp:setVisible(false)
                    btn_Signed_free:setVisible(true)  --免费按钮可见(绿色的)
                    self.imgDetail:setTouchEnabled(true)
                    self.imgDetail:setEnabled(true)
                else
                    btnSignUp:setVisible(true)         --蓝色按钮可见
                    btn_Signed_free:setVisible(false)
                    self.imgDetail:setTouchEnabled(true)
                    self.imgDetail:setEnabled(true)
                end
                Image_Signed:setVisible(false)  -- 退赛不可见
            elseif 1 == temp[i].SelfJoin then -- 报名了
                btnSignUp:setVisible(false)
                btn_Signed_free:setVisible(false)
                Image_Signed:setVisible(true)  --退赛可见
            end
            Button_unSignup:setVisible(false)
        else--不可以报名 时间不在范围内 
            if temp[i].RoomType == 1 then
                if 1 == temp[i].SelfJoin then --sng不是报名中就是过了比赛开放时间了 并且报名状态是1的 就显示退赛按钮
                    Button_unSignup:setVisible(false)
                    btnSignUp:setVisible(false)
                    btn_Signed_free:setVisible(false)
                    Image_Signed:setVisible(true)
                    --lableMatchTitle:setVisible(false)
                else                            --mtt的灰色报名按钮可见
                    Button_unSignup:setVisible(true)
                    btnSignUp:setVisible(false)
                    btn_Signed_free:setVisible(false)
                    Image_Signed:setVisible(false)
                    self.imgDetail:setTouchEnabled(true)
                    self.imgDetail:setEnabled(true)
                end
            else
                Button_unSignup:setVisible(true)
                btnSignUp:setVisible(false)
                btn_Signed_free:setVisible(false)
                Image_Signed:setVisible(false)
                self.imgDetail:setTouchEnabled(true)
                self.imgDetail:setEnabled(true)
            end
        end
        match_node.RoomID = temp[i].RoomID
        self.matchNodeList[temp[i].RoomID]=match_node
    end
end

--初始化界面
function GameListWindow:initUI()
    laixia.LocalPlayercfg.LaixiaMatchlastStage = 1
    laixia.LocalPlayercfg.LaixiaMatchDifen = 0
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MARKEDWORDS_WINDOW)   --关闭前置界面
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHRESULT_WINDOW)
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
    self:sendRenmanPacket()
    self:sendDingshiPacket()
end

function GameListWindow:goBillMatch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if 2 == self.mPageType then
            return
        end
        self.mPageType = 2
        self:updateSelectButton()
        self:sendDingshiPacket()
    end
end

function GameListWindow:updataMatchlist()
    self.ListView_2:setVisible(false)
    if self.mIsShow then
        local temp = self.matchNodeList[laixia.LocalPlayercfg.LaixiaMatchRoom]
        self.tempMatchInfo = nil
        for k, v in ipairs(self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms) do
            if laixia.LocalPlayercfg.LaixiaMatchRoom == v.RoomID then
                self.tempMatchInfo = v
                break
            end
        end
        if temp and self.tempMatchInfo then
            local num = self.tempMatchInfo.CurJoinNum
            if num < 0 then
                local num = 0
            end
            self:GetWidgetByName("Label_Item_CurrentNum", temp):setString(num)
            local day =  os.time()  
            if day<self.tempMatchInfo.JoinTimes then --没开赛的人数归0
                self:GetWidgetByName("Label_Item_CurrentNum", temp):setString(0) 
            else
                local h2,m2 = string.match(self.tempMatchInfo.EndTime,"(%d+):(%d+)")
                h2 = tonumber(h2)
                m2 = tonumber(m2)
                
                local h1 = tonumber(os.date("%H",day))
                local m1 = tonumber(os.date("%M",day))
                if h1*3600 +m1*60 > h2*3600 + m2*60 then
                    self:GetWidgetByName("Label_Item_CurrentNum", temp):setString(0) 
                end
            end
            local baoming_Array = string.split(self.tempMatchInfo.Baomingfei ,':')
            if self.tempMatchInfo.Sate==2 then
                if 0 == self.tempMatchInfo.SelfJoin then
                    self:GetWidgetByName("Image_Signed",temp):setVisible(false) --已报名
                    if tonumber(baoming_Array[2])==0 then
                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(true) --报名
                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                    else
                        self:GetWidgetByName("Button_Signup",temp):setVisible(true) --报名
                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false) --报名
                    end
                elseif self.tempMatchInfo.SelfJoin then
                    self:GetWidgetByName("Image_Signed",temp):setVisible(true)
                    self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                end
                self:GetWidgetByName("Button_unSignup"):setVisible(false)
            else
                self:GetWidgetByName("Button_unSignup"):setVisible(true)
            end
        end
    end
end

-- { "RoomType", CDataTypeObj.Byte },-- 房间类型，1人满开始，0 定时开赛
-- { "Sate", CDataTypeObj.Byte },-- 当前状态，1报名前，2报名中，3报名结束
-- { "SelfJoin", CDataTypeObj.Byte },-- 自己是否报名比赛 1，是0 否
-- { "RoomID", CDataTypeObj.Int },-- 房间ID
-- { "CurJoinNum", CDataTypeObj.Int },-- 当前报名人数
-- { "JoinMinLimit",CDataTypeObj.Int}, --最少开赛人数限制
-- { "Time", CDataTypeObj.Int },-- 比赛开始时间
-- { "RoomName", CDataTypeObj.UTF8 },-- 房间名称
-- { "Icon",CDataTypeObj.UTF8},--图标
-- { "BaomingInfo",CDataTypeObj.UTF8}     --报名信息
--Baomingfei
--加 报名费用
function GameListWindow:addMatchCell(begin, over)
    local temp = self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms
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
        icon:setLocalZOrder(10)
        icon:setScale(0.4)
        local circle = self:GetWidgetByName("Image_33", match_node)
        local system = laixia.ani.CocosAnimManager
        self.rewardlcon = system:playAnimationAt(match_node,"doudizhu_rewardlcon")
        self.rewardlcon:pos(circle:getPositionX(),circle:getPositionY())
        if texture_Array[2] ~= nil then
            local count = ccui.ImageView:create(texture_Array[2],1)
            count:setPosition(78,60)
            --count:setScale(1)
            count:setLocalZOrder(100)
            count:addTo(icon)
        end
        self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(num)  --当前在线人数
        self:GetWidgetByName("Label_Item_ChampAward",match_node):setString("冠军"..temp[i].BaomingInfo)
        local day = os.time()   -- 得到当前的秒数
        local time = temp[i].Time
        local str = nil
        self.Label_Item_Time = self:GetWidgetByName("Label_Item_Time",match_node)
        self.Label_Item_Subtitle = self:GetWidgetByName("Label_Item_Subtitle",match_node)
        self.Label_Item_BaomingFee = self:GetWidgetByName("Label_Item_BaomingFee",match_node)

        local baoming_Array
        local baoming_Arrays = string.split(temp[i].Baomingfei ,',')
        if #baoming_Arrays >1 then
            baoming_Array = string.split(baoming_Arrays[1] ,":") 
        else    
           baoming_Array = string.split(temp[i].Baomingfei,':')
        end
       
        if baoming_Array[1]=="-1" or baoming_Array[1]=="-2" then
            self.Label_Item_BaomingFee:setString("渠道专享")
        else
            local Itemsdata = laixia.JsonTxtData:queryTable("items"):query("ItemID",tonumber(baoming_Array[1]))
            if tonumber(baoming_Array[2])==0 then
                self.Label_Item_BaomingFee:setString("免费")
            else
                self.Label_Item_BaomingFee:setString(Itemsdata.ItemName.."X"..baoming_Array[2])
            end
        end
        if temp[i].RoomType == 0 then --定时开赛
            if os.date("%d", time) == os.date("%d", day) then              -- 判断是否是今天
                print( os.date("%d", time) ,os.date("%d", day))
                str = os.date( "%X",  time)

                str = string.split(str, "00:00")
                -- 整点开赛
                if str[2] == "" then
                    str[1] = str[1] .. "00"
                else
                    str = string.split(str[1], ":00")
                end

                self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(str[1])
            elseif os.date("%d", time) - os.date("%d", day) > 0 and os.date("%d", time) - os.date("%d", day) <= 1 then
                str = os.date( "%X",  time)
                str = string.split(str, "00:00")
                -- 整点开赛
                if str[2] == "" then
                    str[1] = str[1] .. "00"
                else
                    str = string.split(str[1], ":00")
                end
                self:GetWidgetByName("Label_Item_Subtitle", match_node):setString(str[1])
            else
                str = os.date("%X", time)

                str = string.split(str, "00:00")
                -- 整点开赛
                if str[2] == "" then
                    str[1] = str[1] .. "00"
                else
                    str = string.split(str[1], ":00")
                end
                self:GetWidgetByName("Label_Item_Subtitle", match_node):setString( str[1])
            end
            local diff = temp[i].Time-os.time()
            local diffhour = 24 - tonumber(os.date("%H",os.time()))
            local hour =  diff/24/60/60 - diffhour/24
            if hour >=2 then
                    self.Label_Item_Time:setString(os.date("%m",temp[i].Time).."月"..os.date("%d",temp[i].Time).."日")
            elseif hour>=1 then
                self.Label_Item_Time:setString("后天")
            elseif hour>=0  then
                self.Label_Item_Time:setString("明天")
            else
                self.Label_Item_Time:setString("今天")--os.date("%H:%M",time))
            end
        else --SNG人满开赛 --现在没有时间段的
            self.Label_Item_Time:setString(temp[i].BeginTime.."-"..temp[i].EndTime)
            self:GetWidgetByName("Label_Item_Subtitle", match_node):setString("满".. temp[i].JoinMinLimit.. "人开赛")
        end
        if day<temp[i].JoinTimes then --没开赛的人数归0
            self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(0) 
        else
            local h2,m2 = string.match(temp[i].EndTime,"(%d+):(%d+)")
            h2 = tonumber(h2)
            m2 = tonumber(m2)
            local h1 = tonumber(os.date("%H",day))
            local m1 = tonumber(os.date("%M",day))
            if h1*3600 +m1*60 > h2*3600 + m2*60 then
                self:GetWidgetByName("Label_Item_CurrentNum", match_node):setString(0) 
            end
        end
        --~~~~~~~~~~~~~~~~~~~~~~~~蓝色报名按钮
        local btnSignUp = self:GetWidgetByName("Button_Signup",match_node)
        btnSignUp:addTouchEventListener(handler(self, self.goDetails))
        --~~~~~~~~~~~~~~~~~~~~~~~~~退赛按钮
        local Image_Signed = self:GetWidgetByName("Image_Signed",match_node)
        Image_Signed:addTouchEventListener(handler(self, self.goDetails))
        --~~~~~~~~~~~~~~~~~~~~~~~~绿色报名按钮
        local btn_Signed_free = self:GetWidgetByName("Button_Signup_free",match_node)
        btn_Signed_free:addTouchEventListener(handler(self, self.goDetails))
        --~~~~~~~~~~~~~~~~~~~~~~~~不可报名按钮
        local Button_unSignup = self:GetWidgetByName("Button_unSignup",match_node) --不可报名按钮
        Button_unSignup:addTouchEventListener(handler(self, self.goDetails))

        --~~~~~~~~~~~~~~~~~~~~~~~~背景
        local node = self:GetWidgetByName("Image_bg", match_node)
        node:addTouchEventListener(handler(self,self.goDetails))
        self.ListView:pushBackCustomItem(match_node)
        node.time = temp[i].Time
        node.RoomType = temp[i].RoomType
        node.roomId = temp[i].RoomID   

        self.imgDetail.time = temp[i].Time
        self.imgDetail.RoomType = temp[i].RoomType
        self.imgDetail.roomId = temp[i].RoomID
        btnSignUp.time = temp[i].Time
        btnSignUp.RoomType =temp[i].RoomType
        btnSignUp.roomId = temp[i].RoomID

        btn_Signed_free.time = temp[i].Time
        btn_Signed_free.RoomType =temp[i].RoomType
        btn_Signed_free.roomId = temp[i].RoomID

        Image_Signed.time = temp[i].Time
        Image_Signed.RoomType =temp[i].RoomType
        Image_Signed.roomId = temp[i].RoomID

        Button_unSignup.time = temp[i].Time
        Button_unSignup.RoomType = temp[i].RoomType
        Button_unSignup.roomId = temp[i].RoomID
        ---state 2 报名中
        --1比赛开始前
        --3比赛中 4比赛结束
        if temp[i].Sate==2 then
            --可以报名
            if 0 == temp[i].SelfJoin then--看下话费
                if tonumber(baoming_Array[2])==0 then
                    btnSignUp:setVisible(false)
                    btn_Signed_free:setVisible(true)
                    self.imgDetail:setTouchEnabled(true)
                    self.imgDetail:setEnabled(true)
                else
                    btnSignUp:setVisible(true)
                    btn_Signed_free:setVisible(false)
                    self.imgDetail:setTouchEnabled(true)
                    self.imgDetail:setEnabled(true)
                end
                Image_Signed:setVisible(false)
            elseif 1 == temp[i].SelfJoin then
                btnSignUp:setVisible(false)
                btn_Signed_free:setVisible(false)
                Image_Signed:setVisible(true)
            end
            Button_unSignup:setVisible(false)
        else--不可以报名 时间不在范围内
            if 1 == temp[i].SelfJoin then
                Button_unSignup:setVisible(false)
                btnSignUp:setVisible(false)
                btn_Signed_free:setVisible(false)
                Image_Signed:setVisible(true)
            else -- 修123
                Button_unSignup:setVisible(true)

                btnSignUp:setVisible(false)
                btn_Signed_free:setVisible(false)
                Image_Signed:setVisible(false)
                self.imgDetail:setTouchEnabled(true)
                self.imgDetail:setEnabled(true)
            end
        end
        match_node.RoomID = temp[i].RoomID
        self.matchNodeList[temp[i].RoomID]=match_node
    end
end

function GameListWindow:goDetails(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixia.LocalPlayercfg.LaixiaMatchRoom = sender.roomId
        laixia.LocalPlayercfg.LaixiaMatchRoomType = sender.RoomType
        if sender.RoomType == 1 then
            laixia.LocalPlayercfg.LaixiaisSNG = true
        end
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MATCHDETAIL_WINDOW)

    end
end

function GameListWindow:goTuisai(sender, eventType)
    --GameListDetailWindow中的
    --type和id是GameListJoin的
    local roomID = 0
    if laixia.LocalPlayercfg.LaixiaMatchRoom == nil then
        roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
    else
        roomID = laixia.LocalPlayercfg.LaixiaMatchRoom
    end

    if eventType == ccui.TouchEventType.ended then
        local CSExitMatchGame = Packet.new("CSExitMatchGame", _LAIXIA_PACKET_CS_ExitMatchGameID)
        CSExitMatchGame:setValue("GameID", laixia.config.GameAppID)
        CSExitMatchGame:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
        CSExitMatchGame:setValue("RoomID", roomID)
        laixia.net.sendPacketAndWaiting(CSExitMatchGame)
        if laixia.LocalPlayercfg.LaixiaCurrentWindow ~= "GameListWindow"  then -- 如果当前界面不是比赛列表则请求比赛列表
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_GAMELIST_GOGAMELIST)
        end
        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "LobbyWindow" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)      -- 请求个人详情
        end
    end
end

function GameListWindow:retire(sender,eventType)  --退出报名
    if eventType == ccui.TouchEventType.ended then
        local parent = sender:getParent() --原因是为了防止同时报名多个比赛
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local time = parent.time

        local CSExitMatchGame = Packet.new("CSExitMatchGame", _LAIXIA_PACKET_CS_ExitMatchGameID)
        CSExitMatchGame:setValue("GameID", laixia.config.GameAppID)
        CSExitMatchGame:setValue("PageType", parent.roomType)
        CSExitMatchGame:setValue("RoomID", parent.roomId)
        laixia.net.sendPacketAndWaiting(CSExitMatchGame)
        laixia.LocalPlayercfg.LaixiaMatchRoom = parent.roomId
    end
end

function GameListWindow:signup(sender, eventType)  --报名
    if eventType == ccui.TouchEventType.ended then
        print("this is function sifnup")
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local parent = sender:getParent()
        laixia.LocalPlayercfg.LaixiaMatchRoomType = parent.roomType
        laixia.LocalPlayercfg.LaixiaMatchRoom = parent.roomId
        local matchname = parent.name:gsub("金币",laixia.utilscfg.CoinType())
        local time = parent.time
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_REGISTER_MATCH_WINDOW, {["RoomType"]=laixia.LocalPlayercfg.LaixiaGamePageType,["RoomID"] =parent.roomId})
        cc.UserDefault:getInstance():setDoubleForKey("matdchRoomID", parent.roomId)
        cc.UserDefault:getInstance():setStringForKey("MatchName",matchname)
    end
end

function GameListWindow:onTick(dt)
    if self.mIsShow == true then
        self.mTime = ""
        local temp = os.date("%H") .. ":" .. os.date("%M")
        if(self.Text_Time ~= nil and self.mTime ~=temp ) then
            self.mTime = temp
            self.Text_Time:setString(self.mTime)
        end
        --self.time1 = self.time1+dt
        -- local function remoList()
        --     self.ListView_2:setVisible(false)
        --     self.Panel_guodu:setVisible(false)
        --     --self.Panel_guodu:removeFromParent()
        --     self.ListView:setVisible(true)
        -- end

        -- local function moveList()
        --     --self.ListView:setPosition(cc.p(89.33,27,67))
        --     local moveto1 = cc.MoveTo:create(0.10,cc.p(89.33,28))
        --     local moveto2 = cc.MoveTo:create(0.10,cc.p(89.33,28.5))
        --     local seq1 = cc.Sequence:create(moveto1,moveto2)
        --     self.ListView_2:runAction(seq1)
        -- end

        -- if self.time1>2 then
        --     local func1 = cc.CallFunc:create(remoList)
        --     local func2 = cc.CallFunc:create(moveList)
        --     local det = cc.DelayTime:create(0.4)
        --     local seq = cc.Sequence:create(func2,det,func1)
        --     self.Image_1:runAction(seq)
        -- end
        
        --更新列表数据
--        if #self.matchInfo>0 and self.matchInfo[laixia.LocalPlasyercfg.LaixiaGameListIndex]~=nil and self.mIndex ~= #self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms and (self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[self.mIndex+1].Sate==2 or self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[self.mIndex+1].Sate==1) then  
        --临时需求 已经开始的房间或者已经结束的不显示
        if #self.matchInfo > 0 and self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex]~=nil and self.mIndex ~= #self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms then
            local old = self.mIndex + 1
            self.mIndex = self.mIndex + 1
            if self.matchInfo[1].rooms ~=nil and #self.matchInfo[1].rooms ~= 0 then
                local baoming_Array =  string.split(self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[self.mIndex].Baomingfei ,',')
                if self.mIndex > #self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms then
                    self.mIndex = #self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms
                end
                if laixia.config.isAudit then
                    for i=old,self.mIndex do
                        local Award = self.matchInfo[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i].Icon
                        local texture_Array = string.split(Award,',')--  new_ui/common/new_common/day2.png
                        if tostring(texture_Array[1]) == "new_ui/common/red_packet/bisaizhuanyongjinbi.png" then --审核包 只能显示冠军奖励是金币的场次
                            self:addMatchCell(old, self.mIndex)
                        end
                    end
                --新增需求 当发现某个比赛是-2时 则为渠道专享的
                else
                    local isNeedAdd = true
                    local array = {}
                    for key,value in pairs(baoming_Array) do
                        if string.split(value,':')[1] == "-2" then
                            if tonumber(string.split(value,":")[2]) == tonumber(laixia.LocalPlayercfg.CHANNELID) or device.platform == "windows" then
                                isNeedAdd = true
                                break
                            else
                                isNeedAdd = false
                            end
                        end
                    end
                    if isNeedAdd == true then
                        self:addMatchCell(old, self.mIndex)
                    end
                end
            end
        end
        
        if laixia.LocalPlayercfg.LaixiaIsInMatch == true then
            self.isNeedModify = false
        end
        if self.isNeedModify == true then
            self.refreshListTime = self.refreshListTime + dt
            if self.refreshListTime>20 then
                self.refreshListTime = 0
                self:updateRefreshList()
            end
        end
        self.time = self.time + dt
        if self.time >= 1 then
            self.time = 0
            for i, var in pairs(self.matchNodeList) do
                for index=1,#self.matchInfo[1].rooms do
                    local v = self.matchInfo[1].rooms[index]
                    if self.matchNodeList[i].RoomID == v.RoomID then
                        local temp = self.matchNodeList[i]
                        self.tempMatchInfo  = v
                        local time = v.Time
                        if temp and self.tempMatchInfo then
                            local baoming_Array = string.split(self.tempMatchInfo.Baomingfei ,':')
                            --SNG 永远可以报名
                            local day = os.time()
                            local hour = os.date("%H")
                            local minute = os.date("%M")
                            local secend =  os.date("%S")
                            local timebef5 = tonumber(hour*3600 + minute*60 + secend)
                            print(timebef5)
                            --开始时间时间戳
                            local h1,m1 = string.match(v.BeginTime,"(%d+):(%d+)")
                            h1 = tonumber(h1)
                            m1 = tonumber(m1)
                            --s1 = tonumber(s1) 
                            --开始报名时间
                            local time1 = h1 * 3600 + m1 * 60-- + s1
                            local h2,m2 = string.match(v.EndTime,"(%d+):(%d+)")
                            h2 = tonumber(h2)
                            m2 = tonumber(m2)
                            --结束报名时间
                            local time2 = h2 * 3600 + m2*60
                            --判断时间 用就可以报名
                            if v.RoomType == 1 then
                                 --if timebef5<time1 then  --小于开始比赛时间day < time1
                                if tonumber(day)< v.JoinTimes then
                                    if 1 == v.SelfJoin then
                                        self:GetWidgetByName("Button_unSignup",temp):setVisible(false)
                                        self:GetWidgetByName("Image_Signed",temp):setVisible(true)
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                        --lableMatchTitle:setVisible(false)
                                    else -- 修123--     --全部不可报名
                                        self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
                                        self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                    end
                                 elseif timebef5>time2 then
                                --     --全部不可报名
                                    if 1 == v.SelfJoin then
                                        self:GetWidgetByName("Button_unSignup",temp):setVisible(false)
                                        self:GetWidgetByName("Image_Signed",temp):setVisible(true)
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                        --lableMatchTitle:setVisible(false)
                                    else -- 修123--     --全部不可报名
                                        self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
                                        self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                    end
                                 else
                                    if 1 == v.SelfJoin then
                                        self:GetWidgetByName("Button_unSignup",temp):setVisible(false)
                                        self:GetWidgetByName("Image_Signed",temp):setVisible(true)
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                        --lableMatchTitle:setVisible(false)
                                    else -- 修123--     --全部不可报名
                                        self:GetWidgetByName("Button_unSignup",temp):setVisible(false)
                                        self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(true)
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                    end
                                 end
                            --elseif timebef5<time1 then  --小于开始比赛时间day < time1
                            elseif day<v.JoinTimes then
                                -----------------
                                --全部不可报名
                                self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
                                self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                                self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                            elseif day < time then
                                --如果没有报名 
                                if 0 == self.tempMatchInfo.SelfJoin then
                                    self.imgDetail:setTouchEnabled(true)
                                    --退赛设为false
                                    self:GetWidgetByName("Image_Signed",temp):setVisible(false) --已报名
                                    --如果报名类型==0 绿色报名按钮设置可见  否则蓝色按钮设置可见
                                    if tonumber(baoming_Array[2])==0 then
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(true) --报名
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                    else
                                        self:GetWidgetByName("Button_Signup",temp):setVisible(true) --报名
                                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false) --报名
                                    end
                                    self:GetWidgetByName("Button_unSignup",temp):setVisible(false)
                                    self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                                --如果报名了 退赛按钮设置true
                                elseif self.tempMatchInfo.SelfJoin then
                                    self:GetWidgetByName("Image_Signed",temp):setVisible(true)
                                self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                end
                            --如果大于开始比赛时间 那么置灰
                            elseif day>= time then
                                self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
                                self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                                self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                                self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                                --一场比赛已经结束 那么这个时候要计时 刷新列表
                                self.isNeedModify = true
                            end
                        end
                    end
                end
            end
        end
    end
end

--刷新比赛列表
function GameListWindow:refreshMatchList_new()
    for i, var in pairs(self.matchNodeList) do
        for index=1,#self.matchInfo[1].rooms do
            local v = self.matchInfo[1].rooms[index]
            if self.matchNodeList[i].RoomID == v.RoomID then
                local temp = self.matchNodeList[i]
                self.tempMatchInfo  = v
                local time = self:GetWidgetByName("Label_Item_Subtitle", temp):getString()

                local hour = os.date("%H",v.Time)
                local minute = os.date("%M",v.Time)
                local NewTime = hour*60 + minute
                
                local OldTime = NewTime
                if #string.split(time,":")~=2 then
                else
                    if tonumber(string.split(time,":")[1])==nil then
                        return
                    end
                    OldTime = tonumber(string.split(time,":")[1])*60+tonumber(string.split(time,":")[2])   ----这里切记 时间 取得是控件上的值 
                end
                if temp and self.tempMatchInfo and NewTime~=OldTime then
                    local baoming_Array = string.split(self.tempMatchInfo.Baomingfei ,':')
                    local day = os.time()
                    self.isNeedModify = true
                    local hour = os.date("%H")
                    local minute = os.date("%M")
                    local secend =  os.date("%S")
                    local str
                    if os.date("%d", v.Time) == os.date("%d", day) then              -- 判断是否是今天
                        print( os.date("%d", v.Time) ,os.date("%d", day))
                        str = os.date( "%X",  v.Time)
                    else
                        str = os.date("%m月" .. "%d日" .."%X", v.Time, v.Time, v.Time)
                    end
                    str = string.split(str, "00:00")
                    -- 整点开赛
                    if str[2] == "" then
                        str[1] = str[1] .. "00"
                    else
                        str = string.split(str[1], ":00")
                    end
                    self:GetWidgetByName("Label_Item_Subtitle",temp):setString(str[1])
                    local timebef5 = tonumber(hour*3600 + minute*60 + secend)
                    print(timebef5)
                    --开始时间时间戳
                    local h1,m1 = string.match(v.BeginTime,"(%d+):(%d+)")
                    h1 = tonumber(h1)
                    m1 = tonumber(m1) 
                    --开始报名时间
                    local time1 = h1 * 3600 + m1 * 60-- + s1
                    local h2,m2 = string.match(v.EndTime,"(%d+):(%d+)")
                    h2 = tonumber(h2)
                    m2 = tonumber(m2)
                    --结束报名时间
                    local time2 = h2 * 3600 + m2*60
                   if tonumber(timebef5)<tonumber(time1) then  --小于开始比赛时间day < time1
                        -----------------
                        --全部不可报名
                        self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
                        self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                        self.matchNodeList[i]:setTouchEnabled(false)
                        self.matchNodeList[i]:setEnabled(false)
                    elseif tonumber(day) < tonumber(v.Time) then
                        -----------------
                        self.matchNodeList[i]:setTouchEnabled(true)
                        self.matchNodeList[i]:setEnabled(true)
                        --如果没有报名 
                        if 0 == self.tempMatchInfo.SelfJoin then
                            self.imgDetail:setTouchEnabled(true)
                            --退赛设为false
                            self:GetWidgetByName("Image_Signed",temp):setVisible(false) --已报名
                            --如果报名类型==0 绿色报名按钮设置可见  否则蓝色按钮设置可见
                            if tonumber(baoming_Array[2])==0 then
                                self:GetWidgetByName("Button_Signup_free",temp):setVisible(true) --报名
                                self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                            else
                                self:GetWidgetByName("Button_Signup",temp):setVisible(true) --报名
                                self:GetWidgetByName("Button_Signup_free",temp):setVisible(false) --报名
                            end
                            self:GetWidgetByName("Button_unSignup",temp):setVisible(false)
                            self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                            --如果报名了 退赛按钮设置true
                        elseif self.tempMatchInfo.SelfJoin then
                            self:GetWidgetByName("Image_Signed",temp):setVisible(true)
                            self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                            self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                        end
                        --如果大于开始比赛时间 那么置灰
                    elseif tonumber(day)>= tonumber(v.Time) then
                        self:GetWidgetByName("Button_unSignup",temp):setVisible(true)
                        self:GetWidgetByName("Image_Signed",temp):setVisible(false)
                        self:GetWidgetByName("Button_Signup",temp):setVisible(false)
                        self:GetWidgetByName("Button_Signup_free",temp):setVisible(false)
                        --一场比赛已经结束 那么这个时候要计时 刷新列表
                    end
                end
            end
        end
    end
end

--进行适配
function GameListWindow:setAdaptation()
    -- local view = lay.cx, display.cy)
    --view:setScale(display.contentScaleFactor)
    -- view:setScaleY(display.widthInPixels/display.width)
    if(self.hDialogType ~= DialogTypeDef.DEFINE_SINGLE_DIALOG) then
        --view:setScale(display.contentScaleFactor)
            -- :scaleX(XScale)
            -- :scaleY(YScale)
    end
    if device.platform == "ios" then
        --暂时先 适配 iphoneX
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self:GetWidgetByName("Image_1"):setScaleX(2436/3*2/1280)
        end
    end
end

--刷新数据
function GameListWindow:updateRefreshList()
    --一直刷新到有数据修改 就停止
    self.ListView_2:setVisible(false)
    self:sendDingshiPacket()
end

function GameListWindow:onDestroy()
    self.mIsShow = false
    self.isNeedModify  = false
    self.refreshListTime = 0
    self.time = 0
    self.matchInfo = {}
    self.mPageType = 0
    self.matchNodeList ={}
end

return GameListWindow.new()
