--
-- Author: Feng
-- Date: 2018-05-03 12:53:49
--
local JsonTxtData = require("lobby.data.init");

local BagLayer = class("BagLayer" ,import("common.base.BaseDialog"))
local scene = cc.Director:getInstance():getRunningScene()
local isshow = false

--[[
    构造函数
]]
function BagLayer:ctor()
    if isshow == true then
        return
    end
    self.super.ctor(self, "new_ui/BagLayer.csb")
    self:sendRequest()
    self:init()

    local function onNodeEvent(event)
        if "enter" == event then
            isshow = true
        elseif "exit" == event then
            isshow = false
        end
    end
    self:registerScriptHandler(onNodeEvent)    
end

----示例
function BagLayer:sendRequest()
    self.isPrevious = nil
    local stream =  laixia.Packet.new("bag", "LXG_BAGPACK_GET")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    stream:setValue("query_type", 0)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event

        if data1.dm_error == 0 then
            print("request bag success")
            if data1 ~= nil then
                self:onSCPackItemsPacket(data1)
            end
        else
            print("request bag error")
             scene:popUpTips(data1.error_msg)
        end 
    end)
end

--2背包数据逻辑
function BagLayer:onSCPackItemsPacket(packet)
    local ostime = os.time()
    local tempArray
    if packet ~= nil then
        tempArray = packet.data
        for i=1,#tempArray do 
            tempArray[i].ItemID = tonumber(tempArray[i].item_id)
            tempArray[i].ItemCount = tempArray[i].item_ct
            tempArray[i].EffTime = 0
            tempArray[i].ItemObjectID = tempArray[i].id
        end
    end

    laixia.LocalPlayercfg.LaixiaPropsData = tempArray
    self:updateWindow(isUpdate)
    
end

--[[
    初始化
]]
function BagLayer:init()
    --初始化界面
    -- local csbNode = cc.CSLoader:createNode("new_ui/BagLayer.csb")
    -- csbNode:setAnchorPoint(0.5, 0.5)
    -- csbNode:setPosition(display.cx,display.cy)
    -- self:addChild(csbNode)
    -- self.rootNode = csbNode
    -- _G.adapPanel_root(csbNode)
    --返回按钮
    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onBack))


    self.Panel_button = _G.seekNodeByName(self.rootNode,"Panel_button")
    --左边四个按钮
    self.Button_all = _G.seekNodeByName(self.Panel_button,"Button_all")
    --self.Button_all:setVisible(false)
    self.Button_ticket = _G.seekNodeByName(self.Panel_button,"Button_ticket")
    --self.Button_ticket:setVisible(false)
    self.Button_prop = _G.seekNodeByName(self.Panel_button,"Button_prop")
    --self.Button_prop:setVisible(false)
    self.Button_prize = _G.seekNodeByName(self.Panel_button,"Button_prize")
    --self.Button_prize:setVisible(false)

    self.Button_all_select = _G.seekNodeByName(self.Panel_button,"Button_all_select")
    self.Button_all_select:setVisible(false)
    self.Button_ticket_select = _G.seekNodeByName(self.Panel_button,"Button_ticket_select")
    self.Button_ticket_select:setVisible(false)
    self.Button_prop_select = _G.seekNodeByName(self.Panel_button,"Button_prop_select")
    self.Button_prop_select:setVisible(false)
    self.Button_prize_select = _G.seekNodeByName(self.Panel_button,"Button_prize_select")
    self.Button_prize_select:setVisible(false)

    --self.Button_all:addTouchEventListener(handler(self,self.onCleanup))
    self.Button_all_select:addTouchEventListener(handler(self,self.showAllIteam))
    --self.Button_ticket:addTouchEventListener(handler(self,self.onCleanup))
    self.Button_ticket_select:addTouchEventListener(handler(self,self.showMenpiao))
    --self.Button_prop:addTouchEventListener(handler(self,self.onCleanup))
    self.Button_prop_select:addTouchEventListener(handler(self,self.showTools))
    --self.Button_prize:addTouchEventListener(handler(self,self.onCleanup))
    self.Button_prize_select:addTouchEventListener(handler(self,self.showExchange))

    --加载的控件
    self.Panel_cell = _G.seekNodeByName(self.rootNode,"Panel_cell")
    self.mLibaoCell = self.Panel_cell--:clone()
    

    --cell的三个物品
    self.Button_item_1 = _G.seekNodeByName(self.Panel_cell,"Button_item1")
    self.Button_item_1:setVisible(false)
    -- self.Button_item_1:addTouchEventListener(handler(self, self.onBack))
    self.Button_item_2 = _G.seekNodeByName(self.Panel_cell,"Button_item2")
    self.Button_item_2:setVisible(false)
    -- self.Button_item_2:addTouchEventListener(handler(self, self.onBack))
    self.Button_item_3 = _G.seekNodeByName(self.Panel_cell,"Button_item3")
    self.Button_item_3:setVisible(false)
    -- self.Button_item_3:addTouchEventListener(handler(self, self.onBack))
    
    --四个list容器
    self.Panel_listvecter = _G.seekNodeByName(self.rootNode,"Panel_listvecter")
    self.ListView_all = _G.seekNodeByName(self.Panel_listvecter,"ListView_all")
    self.ListView_ticket = _G.seekNodeByName(self.Panel_listvecter,"ListView_ticket")
    self.ListView_prop = _G.seekNodeByName(self.Panel_listvecter,"ListView_prop")
    self.ListView_prize = _G.seekNodeByName(self.Panel_listvecter,"ListView_prize")

    self.mListViewLibao = self.ListView_all
    self.Mybag_duijiangList = self.ListView_prize
    self.Mybag_menpiaoList = self.ListView_ticket
    self.Mybag_daojuList = self.ListView_prop

    self.ButtonArray ={}
    table.insert(self.ButtonArray,self.Button_all)
    table.insert(self.ButtonArray,self.Button_all_select)
    table.insert(self.ButtonArray,self.Button_ticket)
    table.insert(self.ButtonArray,self.Button_ticket_select)
    table.insert(self.ButtonArray,self.Button_prop)
    table.insert(self.ButtonArray,self.Button_prop_select)
    table.insert(self.ButtonArray,self.Button_prize)
    table.insert(self.ButtonArray,self.Button_prize_select)
    
    -- 标记一下当前的道具 (按钮注释了 这个也没什么用了)      
    self:showOnlyButton(1)
    self:startShow()
    JsonTxtData:init()
end

--跟新listview
function BagLayer:updateWindow()
    --数据保存在laixia.LocalPlayercfg.LaixiaPropsData 变量中
    local propsItems = laixia.LocalPlayercfg.LaixiaPropsData 
    -- 遍历是否有任务红包（如果有的话就把它放到第一个位置）
    for k,v in pairs(propsItems) do
        local temp = {}
        if v.ItemID == 13002 and k ~= 1 then
            temp = propsItems[1]
            propsItems[1] = propsItems[k]
            propsItems[k] = temp
        end
    end
    print("2222222")
    --四个UINode数组 
    self.mUINodeArray = {};
    self.daojuUINodeArray = {};
    self.menpiaoUINodeArray = {}
    self.duijiangUINodeArray = {};


    --四个UIitemMsg数组
    self.mUIItemMsgArray = { }
    --道具 门票 兑奖
    self.mMenpiaoArray = {}
    self.mDuijiangArray = {}
    self.mDaojuArray = {}
        
    local itemMsg = JsonTxtData:queryTable("items")
    for i,v in ipairs(propsItems) do
        local itemData =itemMsg:query("ItemID",v.ItemID)
        if itemData then
            if itemData.ItemType == 2 then
                table.insert(self.mMenpiaoArray,v)
            --elseif itemData.ItemType == 7 or itemData.ItemType==0 or itemData.ItemType==2 then
            elseif itemData.ItemType == 3 then
                table.insert(self.mDuijiangArray,v)
            else
                table.insert(self.mDaojuArray,v)
            end
            table.insert(self.mUIItemMsgArray,v)
        end
    end


    self.mListViewLibao:removeAllItems()
    self.Mybag_duijiangList:removeAllItems()
    self.ListView_ticket:removeAllItems()
    self.Mybag_daojuList:removeAllItems()

    -- self.ListView_all:removeAllItems()
    -- self.ListView_prize:removeAllItems()
    -- self.ListView_ticket:removeAllItems()
    -- self.ListView_prop:removeAllItems()

    self:addItems();
    if (self.mUINodeArray[1] ~= nil) then
        self.Index = 1
        --self:hideTips()
    else
        --self:showTips()
    end
    self:showAllIteam()
end
--[[remove item from list]]
function BagLayer:removeItem()
    self.Mybag_menpiaoList:removeAllItems(index);
    
end
--添加item数据和节点到表中
function BagLayer:addItems()
    --定义一个局部变量 保存Item数

    local itemNumber
    for listViewIndex=1,4 do-----现在只走listViewIndex==1（就是显示全部Item）
        local dataArray = {}
        local dataArrays = {}

        if listViewIndex==1 then
            dataArrays = self.mUIItemMsgArray
        elseif listViewIndex==2 then
            dataArrays = self.mDaojuArray
        elseif listViewIndex == 3 then
            dataArrays = self.mMenpiaoArray
        elseif listViewIndex==4 then
            dataArrays = self.mDuijiangArray
        end

        for i=1,#dataArrays do
        local itemid = dataArrays[i].ItemID
           local itemMsg = JsonTxtData:queryTable("items"):query("ItemID",itemid); 
           -- local itemMsg = self.itemMsg

            if itemMsg.isPile == 0 then
                for j=1,dataArrays[i].ItemCount do
                    dataArray[#dataArray+1] = clone(dataArrays[i])
                    dataArray[#dataArray].ItemCount = 1
                end
            else
                if itemMsg.PileNum >= dataArrays[i].ItemCount then
                     dataArray[#dataArray+1] = clone(dataArrays[i])
                else 
                    local counts = dataArrays[i].ItemCount
                    local num1 =  math.floor(dataArrays[i].ItemCount / itemMsg.PileNum)
                    local num2 =  counts % itemMsg.PileNum
                    for j=1,num1 do
                         dataArray[#dataArray+1] = clone(dataArrays[i])
                        dataArray[#dataArray].ItemCount = itemMsg.PileNum
                        --  dataArrays[i].ItemCount = itemMsg.PileNum
                        -- table.insert(dataArray,dataArrays[i])
                    end

                    local num2 =  counts % itemMsg.PileNum
                    if (num2 ~= 0) then
                        num1 = num1+1
                        dataArray[#dataArray+1] = clone(dataArrays[i])
                        dataArray[#dataArray].ItemCount = num2
                    end   
                end
            end
        end
     
        self.dataArrayss = dataArray

        if listViewIndex == 1 then
            itemNumber = #dataArray
        elseif listViewIndex == 2 then
            itemNumber = #dataArray
        elseif listViewIndex == 3 then
            itemNumber = #dataArray
        elseif listViewIndex == 4 then
            itemNumber = #dataArray
        end
        --获取有几行控件 最后一行控件有几个item
        --totalNumber 用来记录有几行 向下取整(返回小于参数x的最大整数)
        local totalNumber =  math.floor(itemNumber / 3)
        --numberMod   用来最后一行的Item的个数
        local numberMod =  itemNumber% 3

        local addModelNumber = totalNumber
        --如果最后一行的Item的个数~=0 那么行+1(因为上面是向下取整的)
        if (numberMod ~= 0) then 
            addModelNumber = totalNumber + 1
        end
        --控件
        --遍历行
        for i=1,addModelNumber do 
            local model = self.mLibaoCell:clone()
            if listViewIndex==1 then
                self.mListViewLibao:pushBackCustomItem(model);
            elseif listViewIndex==2 then
                self.Mybag_daojuList:pushBackCustomItem(model);
            elseif listViewIndex == 3 then
                self.Mybag_menpiaoList:pushBackCustomItem(model);
            elseif listViewIndex==4 then
                self.Mybag_duijiangList:pushBackCustomItem(model);
            end

            for j=1,3 do 
                local idx = j
                --index = 当前是所有控件中的第几个 注意:i从1，j从0开始
                local index = 3*(i-1) + j
                if (dataArray[index] ~=nil and dataArray[index].ItemCount >= 0 )then
                   local itemMsg = JsonTxtData:queryTable("items"):query("ItemID",dataArray[index].ItemID);
                    --取出克隆的基础容器(行)上的item(列)
                    local btnModel = _G.seekNodeByName(model,"Button_item" .. idx)
                    local index = 3*(i-1) + j

                    if (dataArray[index] ~=nil and dataArray[index].ItemCount >= 0 )then
                        btnModel:setVisible(true)
                        btnModel:setTag(index)     
                        if listViewIndex == 1 then
                            self.mUINodeArray[#self.mUINodeArray + 1] = btnModel
                        elseif listViewIndex == 2 then
                            self.daojuUINodeArray[#self.daojuUINodeArray + 1] = btnModel
                        elseif listViewIndex == 3 then
                            self.menpiaoUINodeArray[#self.menpiaoUINodeArray + 1] = btnModel
                        elseif listViewIndex == 4 then
                            self.duijiangUINodeArray[#self.duijiangUINodeArray + 1] = btnModel
                        end    
                        --重新保存取出克隆的基础容器(行)上的item(列)           
                        local model_sender = _G.seekNodeByName(btnModel,"Button_use")
                        --取出item的id保存
                        model_sender.ItemID = dataArray[index].ItemID
                        --取出itemObjectID 保存
                        model_sender.ItemObjectID = dataArray[index].ItemObjectID
                        --添加item的按钮监听
                        btnModel:addTouchEventListener(handler(self, self.onClickToShow))
                        --按钮上的光效
                        local gx = _G.seekNodeByName(btnModel,"Mybag_guangxiao")
                        gx:setVisible(false)
                    end
                end
            end
        end
        -- 填充
        for i = 1, itemNumber do
           self:addItem(i, dataArray[i],listViewIndex);
        end

    end
end 

--添加Item到界面上 并设置Item上的节点
function BagLayer:addItem(index, item,tabIndex)
    local dataArray = {}
    if tabIndex==1 then
        dataArray = self.dataArrayss
    elseif tabIndex==2 then
        dataArray = self.dataArrayss
    elseif tabIndex == 3 then
        dataArray = self.dataArrayss
    elseif tabIndex==4 then
        dataArray = self.dataArrayss
    end
    --暂时注释掉
    local itemData =JsonTxtData:queryTable("items"):query("ItemID",tonumber(item.ItemID))
    if (itemData ~= nil) then
        if tabIndex == 1 then
            self.control = self.mUINodeArray[index]
        elseif tabIndex == 2 then
            self.control = self.daojuUINodeArray[index]
        elseif tabIndex == 3 then
            self.control = self.menpiaoUINodeArray[index]
        elseif tabIndex == 4 then
            self.control = self.duijiangUINodeArray[index]
        end
       self.control:setTag(index)

        local name = _G.seekNodeByName(self.control,"Text_des")
        name:setString(itemData.ItemName)
        name:enableGlow(cc.c4b(0, 0, 0, 255))

        --物品图标
        local icon = _G.seekNodeByName(self.control,"Image_prize")
        icon:setVisible(false)
        local baoming_Array = string.split(itemData.ImagePath ,'/')
        icon:removeAllChildren()


        if #baoming_Array >1 then
            -- local sprite = display.newSprite(itemData.ImagePath)
            -- sprite:setScale(0.4)  
            -- sprite:setAnchorPoint(cc.p(0.5,0.5))
            -- sprite:setPosition(cc.p(0,0))
            -- sprite:addTo(icon)
            icon:loadTexture(itemData.ImagePath)
            icon:setScale(0.5) 
        else
            --ImagePath字段 道具大icon############
            icon:loadTexture(itemData.ImagePath)
            icon:setScale(0.5)            
        end
        icon:setVisible(true)
        --使用按钮
                --需要的参数在这带过去 -----------------------------使用物品
                --Button_use.itemID
        local Button_use = _G.seekNodeByName(self.control,"Button_use")
        -- Button_use.id = item.ItemID
        Button_use:addTouchEventListener(handler(self, self.onUse))

        --物品有效时间
        local text_time = _G.seekNodeByName(self.control,"Text_time")
        text_time:setVisible(true)

        --如果effTime不是永久有效
        if dataArray[index].EffTime > 0 and itemData.isPile==0 then
            local diff = dataArray[index].EffTime/1000 - os.time()
            local time1 = math.floor(diff/60/60/24)
            text_time:setVisible(true)
           text_time:setString(time1.."天")
           text_time:enableGlow(cc.c4b(255, 0, 0, 255))
           --物品数量
            local Text_number = _G.seekNodeByName(self.control,"Text_number")
            Text_number:setVisible(false)
            Text_number:enableGlow(cc.c4b(255, 0, 0, 255))
        else
            text_time:setVisible(false)
             local Text_number = _G.seekNodeByName(self.control,"Text_number")
             --  
            Text_number:setString("X" .. dataArray[index].ItemCount)
            -- Text_number:enableGlow(cc.c4b(255, 0, 0, 255))
             --显示fnt字体的另外一种方式，只不过上面的封装了一下   
            -- display.newBMFontLabel({text = "1",font="new_ui/fnt/bagNumber.fnt"})
            --  :align(display.CENTER,display.cx,display.cy)
            --  :addTo(Text_number)
        end
    end
end 

--点击物品
function BagLayer:onClickToShow(sender,eventType)
    if eventType == ccui.TouchEventType.began then      
    elseif eventType == ccui.TouchEventType.moved then
        print("moved")
        _G.seekNodeByName(sender,"Mybag_guangxiao"):setVisible(false)
    elseif eventType == ccui.TouchEventType.ended then
        print("ended")
        _G.seekNodeByName(sender,"Mybag_guangxiao"):setVisible(true)
        if self.isPrevious == nil then
            self.isPrevious = sender
        elseif self.isPrevious == sender then
            return
        else
            if self.isPrevious == nil then
                self.isPrevious = sender
            else
                _G.seekNodeByName(self.isPrevious,"Mybag_guangxiao"):setVisible(false)
                self.isPrevious = sender
            end
        end
    end
end

--物品的使用
function BagLayer:onUse(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.isPrevious ~= nil then
            _G.seekNodeByName(self.isPrevious,"Mybag_guangxiao"):setVisible(false)
            local sender_parent = sender:getParent()
            _G.seekNodeByName(sender_parent,"Mybag_guangxiao"):setVisible(true)
            self.isPrevious = sender_parent
        else
            local sender_parent = sender:getParent()
            _G.seekNodeByName(sender_parent,"Mybag_guangxiao"):setVisible(true)
            self.isPrevious = sender_parent
        end
        
        --发送使用请求  
        print("使用物品回调")
        --local sender = {}
        --sender.ItemID = self.curItemID
        --sender.ItemObjectID  = self.curItemObjectID
        print("sender.ItemID" .. sender.ItemID)
        print("sender.ItemObjectID" .. sender.ItemObjectID)
        local itemMsg = JsonTxtData:queryTable("items"):query("ItemID",tonumber(sender.ItemID))
        self.duihuanNum = 0
    
        if  sender.ItemID == 13002 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"请前往游戏场完成任务")
            return
        end
        
        if itemMsg.ItemType == 7 then
            --等级礼包使用的时候
            if itemMsg.GetLimit == 1 and laixia.LocalPlayercfg.LaixiaPlayerLevel<itemMsg.LimitNumber then
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "您当前等级不足，需要"..itemMsg.LimitNumber.."级才能领取哦。")
            else
                --发送使用请求
            end
        else
            local dataTable = {}
            dataTable.ID = itemMsg.ItemID
            dataTable.ObjID = sender.ItemObjectID
            dataTable.page = "MyBagWindow"
            if itemMsg.isDelivery == 1 then
                if itemMsg.DeliveryFunctionID == 1 then
                    --游戏大厅
                    ------ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MAININTERFACE_WINDOW)
                elseif itemMsg.DeliveryFunctionID == 2 then
                    --游戏场界面
                    laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_UPDATE_SELECTROOM_WINDOW
                    local stream = Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
                    stream:setValue("RoomType", 2)
                    laixia.net.sendPacketAndWaiting(stream)
                elseif itemMsg.DeliveryFunctionID == 3 then
                    --比赛场界面
                    ------ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
                    laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW
                    --请求
                elseif itemMsg.DeliveryFunctionID == 4 then
                    --自建桌界面
                    laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_PACKET_CREATESELFBUILF
                    ------ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_PACKET_CREATESELFBUILF)
                end
            else 
                --不跳转
                if itemMsg.ItemType == 1 then
                    --货币
                    ------ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,itemMsg.ItemDesc)
                    if itemMsg.isDisapear == 1 then
                        self.isPrevious = nil
                        --清除右边数据
                     end
                elseif itemMsg.ItemType == 2 then
                    --门票
                    ------ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,itemMsg.ItemDesc)
                    --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
                    if itemMsg.isDisapear == 1 then
                        self.isPrevious = nil
                        --清除右边数据
                    end
                elseif itemMsg.ItemType == 3 then
                    if itemMsg.ItemID == 9998 or (itemMsg.ItemID >=30000 and itemMsg.ItemID <40000)  then
                    --使用实物道具******************  
                    --在这发请求？  还是在最终确认的时候发？
                        --获取unionid 
                        local data1 = {}
                        data1.obj = self
                        data1.ID = sender.ItemID
                        data1.ObjID = sender.ItemObjectID
                        data1.item_ct = 1
                        data1.page = "MyBagWindow"
                        data1.isDisapear = itemMsg.isDisapear
                        local MessageLayer = require("lobby.layer.bag.MessageUpLayer").new(data1)
                        self:addChild(MessageLayer)
                    else
                        --1.走兑换的 红包/京东卡   这个暂时没有接口 所以没调
                        if string.sub(sender.ItemID,1,2) == "15" and itemMsg.ObtainItemIDList ~= nil then
                            -- if string.sub(sender.ItemID,3,4) == "01" then
                            --添加兑换界面
                            local arg = {}
                            arg.ItemID = sender.ItemID 
                            arg.ObtainItemIDList =  sender.ItemObjectID
                            arg.obj = self
                            local popuplayer = require("lobby.layer.bag.PopUpLayer").new(itemMsg.ObtainItemIDList,arg)
                            self:addChild(popuplayer)
                            print("添加兑换界面 PopUpLayer")
                        else
                        --2.直接使用
                            local stream =  laixia.Packet.new("bag", "LXG_BAGPACK_USE")
                            stream:setReqType("post")
                            stream:setPostData("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
                            stream:setPostData("item_id", sender.ItemID)
                            stream:setPostData("item_ct", 1)
                            laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
                                local data1 = event
                                if data1.dm_error == 0 then
                                    print("duihuan success")
                                    scene:popUpTips("使用成功")
                                else
                                    print("duihuan error")
                                    scene:popUpTips(data1.error_msg)
                                end 
                            end)
                        end
                    end
                elseif itemMsg.ItemType == 4 then
                    
                elseif itemMsg.ItemType == 5 then 
                   
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,itemMsg.ItemDesc)
                end
            end 
        end
    end
end

--返回按钮
function BagLayer:onBack(sender,eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- self:removeAllChildren()
        self:removeFromParent()
    end
end

--显示唯一的空间，当前显示为单数
function BagLayer:onShowOnly(index,nodeArray)
    if index > #nodeArray then
        return
    else
        for i,v in ipairs(nodeArray) do
            local n = i%2
            if (i == index  ) then
                v:show()
            elseif(i %2 == 0) then
                v:show()
            else
                v:hide()
            end

        end
        nodeArray[index+1]:hide()
    end
end

--显示唯一的前景按钮
function BagLayer:showOnlyButton(index)
    self:onShowOnly(index,self.ButtonArray)    
end

function BagLayer:startShow()
    self:showOnlyButton(1)
    self.mListViewLibao:setVisible(true)
    self.Mybag_daojuList:setVisible(false)
    self.Mybag_menpiaoList:setVisible(false)
    self.Mybag_duijiangList:setVisible(false)
end

--显示所有物品
function BagLayer:showAllIteam(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(1)
        self.mListViewLibao:setVisible(true)
        self.Mybag_daojuList:setVisible(false)
        self.Mybag_menpiaoList:setVisible(false)
        self.Mybag_duijiangList:setVisible(false)
    end
end

--显示道具
function BagLayer:showTools(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(5)
        self.mListViewLibao:setVisible(false)
        self.Mybag_daojuList:setVisible(true)
        self.Mybag_menpiaoList:setVisible(false)
        self.Mybag_duijiangList:setVisible(false)
    end
end

--显示门票
function BagLayer:showMenpiao(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(3)
        self.mListViewLibao:setVisible(false)
        self.Mybag_daojuList:setVisible(false)
        self.Mybag_menpiaoList:setVisible(true)
        self.Mybag_duijiangList:setVisible(false)
    end
end

--显示兑换
function BagLayer:showExchange(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(7)
        self.mListViewLibao:setVisible(false)
        self.Mybag_daojuList:setVisible(false)
        self.Mybag_menpiaoList:setVisible(false)
        self.Mybag_duijiangList:setVisible(true)
    end
end


return BagLayer