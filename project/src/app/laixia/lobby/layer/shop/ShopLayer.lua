--[[
 * 大厅主界面层
]]

local JsonTxtData = require("lobby.data.init");
local ShopLayer = class("ShopLayer" , import("common.base.BaseDialog"))
local scene = cc.Director:getInstance():getRunningScene()
local isshow = false

--[[
 * 构造函数
 * @param  data = {pageIndex}
--]]
function ShopLayer:ctor(data)
    if isshow == true then
        return
    end
    self.super.ctor(self, "new_ui/MallLayer.csb")
    self:hide()
    self.mshopItems = {}
    self.mExchangeItems={} 
    self.btnType = {Gold = 1,Cheese = 2,Exchange = 3}

    local stream =  laixia.Packet.new("bag", "LXG_SHOP_GET_ITEM")
    stream:setReqType("get")
    stream:setValue("cv", "1.3.20_Android")
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1.dm_error == 0 then
            if data1 ~= nil then
                self.mshopItems = data1.data
                -- print("获取商城物品成功 ↓")
                -- dump(self.mshopItems)
                self:init(data1.data)
                self:show()
            end
        else
            -- print("获取商城物品失败")
            scene:popUpTips(data1.error_msg)
        end  
    end)
    
    local function onNodeEvent(event)
        if "enter" == event then
            isshow = true
        elseif "exit" == event then
            isshow = false
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

--[[
 * 初始化
 * @param  data = {pageIndex}
--]]
function ShopLayer:init(data)
    -- 节点获取及初始化
    self.Panel_button = _G.seekNodeByName(self.rootNode,"Panel_button")
    self.btnGold = _G.seekNodeByName(self.Panel_button,"Button_gold")
    self.btnGold:addTouchEventListener(handler(self,self.onTouchBtn))
    self.btnCheese = _G.seekNodeByName(self.Panel_button,"Button_zhishi")
    self.btnCheese:addTouchEventListener(handler(self,self.onTouchBtn))
    self.btnCheese:setVisible(false)
    self.btnExchange = _G.seekNodeByName(self.Panel_button,"Button_exchange")
    self.btnExchange:addTouchEventListener(handler(self,self.onTouchBtn))
    self.btnExchange:setVisible(false)
    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.gotoBack))
    self.Panel_right = _G.seekNodeByName(self.rootNode,"Panel_right")
    self.Image_zhishibackground = _G.seekNodeByName(self.Panel_right,"Image_zhishibackground")
    self.Image_goldbackground = _G.seekNodeByName(self.Panel_right,"Image_goldbackground")  
    self.PageView_mall = _G.seekNodeByName(self.Panel_right,"PageView_mall")
    self.Text_zhishi_num = _G.seekNodeByName(self.Panel_right,"Text_zhishi_num")
    self.Text_gold_num = _G.seekNodeByName(self.Panel_right,"Text_gold_num")
    self.Text_zhishi_num:setString(laixia.LocalPlayercfg.LaixiaZsCoin)
    self.Text_gold_num:setString(laixia.LocalPlayercfg.LaixiaGoldCoin)
    self.mImageCell = _G.seekNodeByName(self.rootNode,"Panel_cell")
    self.listGold = _G.seekNodeByName(self.rootNode,"ListView_mall")
    self.listCheese = _G.seekNodeByName(self.rootNode,"ListView_cheese")
    self.listExchange = _G.seekNodeByName(self.rootNode,"ListView_exchange")
    
    JsonTxtData:init()
    local defPagetIndex = self.btnType.Gold
    if data and data.pageIndex then
        defPagetIndex = data.pageIndex
    end
    self.pageArray ={
        {btn = self.btnGold},
        {btn = self.btnCheese},
        {btn = self.btnExchange}
    }
    self:changeBtn(defPagetIndex)
end

--[[
 * 按钮点击事件
 * @param  sender 点击按钮
 * @param  event  事件类型
--]]
function ShopLayer:onTouchBtn(sender,event)
    _G.onTouchButton(sender, event)
    local senderName = sender:getName()
    if event == ccui.TouchEventType.ended then 
        if senderName == "Button_gold" then
    local defPagetIndex = self.btnType.Gold
            self:changeBtn(self.btnType.Gold)
        elseif senderName == "Button_zhishi" then
            self:changeBtn(self.btnType.Cheese)
        elseif senderName == "Button_exchange" then
            self:changeBtn(self.btnType.Exchange)
        end
    end
end

--[[
 * 切换按钮
 * @param  btnIndex 页签标识
--]]
function ShopLayer:changeBtn(btnIndex)
    if self.pageIndex and btnIndex and self.pageIndex == btnIndex then return end
    if self.pageIndex then
        local listView = self.pageArray[self.pageIndex]
        if listView.list then
            listView.list:setVisible(false)
        end
        -- listView.btn:setOpacity(255)
        listView.btn:setColor(cc.c3b(200,200,200))
    end
    self.pageIndex = btnIndex or self.btnType.Gold 
    local listView = self.pageArray[self.pageIndex]
    if not listView.list then
        if self.pageIndex == self.btnType.Gold then
            self:updateGoodsInfo()
            listView["list"] = self.listGold
        elseif self.pageIndex == self.btnType.Cheese then
            -- TODO
            listView["list"] = self.listCheese
        elseif self.pageIndex == self.btnType.Exchange then
            -- TODO
            listView["list"] = self.listExchange
        end
        listView.list:setVisible(true)
    else
        listView.list:setVisible(true)
    end
    listView.btn:setColor(cc.c3b(255,255,255))
end

--[[
 * 刷新商品
 * @param  nil
--]]
function ShopLayer:updateGoodsInfo()
    local amount = #self.mshopItems
    local index = tonumber(amount / 3)
    local mode = amount % 3
    if mode~=0 then 
        index = index + 1
    end 
    if index > 0 then 
        for i=1,index do 
            local start = (i-1)*3 + 1
            local over = i * 3 
            self:addGoodsCell(start,over)
        end
    end 
end

--[[
 * 添加商品
 * @param  start 起始位置
 * @param  over  结束位置
--]]
function ShopLayer:addGoodsCell(start,over)
    local mode = self.mImageCell:clone()
    self.listGold:pushBackCustomItem(mode)
    self.mModeSize = mode:getContentSize();
    self.mEachWidth = self.mModeSize.width / 3
    self.mPosX = 0
    self:adGoods2Listview(start,over,mode)
end

--[[
 * 添加商品
 * @param  start 起始位置
 * @param  over  结束位置
 * @param  mode  商品节点
--]]
function ShopLayer:adGoods2Listview(start,over,mode)
    for i=start,over do 
        local count = 1
        if i%3 == 0 then
            count = 3
        else
            count = i%3
        end
        local mode = _G.seekNodeByName(mode, "Button_item"..count)
        local Text_price = _G.seekNodeByName(mode,"Text_number")
        local Text_desc = _G.seekNodeByName(mode,"Text_desc")
        local Image_icon = _G.seekNodeByName(mode,"Image_icon")
        local Image_percent = _G.seekNodeByName(mode,"Image_percent")
        local BF_goldnum = _G.seekNodeByName(mode,"BF_goldnum")
        local Image_tenthousand = _G.seekNodeByName(mode,"Image_tenthousand")
        local shopItems = self.mshopItems[i]
        -- TODO 首冲
        -- TODO 加成
        if not shopItems then
            mode:setVisible(false)
        else
            local itemID = shopItems.itemid
            mode.id = itemID
            if itemID == 100001 then
                mode.GolNum = 10000
                mode.CoinNum = 100
            elseif itemID == 100002 then
                mode.GolNum = 20000
                mode.CoinNum = 200
            elseif itemID == 100003 then
                mode.GolNum = 30000
                mode.CoinNum = 300
            elseif itemID == 100004 then
                mode.GolNum = 300000
                mode.CoinNum = 1000
            elseif itemID == 100005 then
                mode.GolNum = 400000
                mode.CoinNum = 2000
            elseif itemID == 100006 then
                mode.GolNum = 500000
                mode.CoinNum = 3000
            elseif itemID == 130001 then
                mode.GolNum = 700000
                mode.CoinNum = 4000
            else
                mode.GolNum = 10000
                mode.CoinNum = 5
            end
            if Text_desc then
                Text_desc:setString(shopItems.itemdesc)
                Text_desc:enableOutline(cc.c4b(111,42,0,255), 2)
                Text_desc:enableShadow(cc.c3b(255, 255, 255),cc.size(2,-2))
            end
            BF_goldnum:setString(mode.GolNum/10000)
            Image_tenthousand:setPositionX(BF_goldnum:getPositionX()+BF_goldnum:getContentSize().width)
            --Image_percent:setVisible(true)
            Image_icon:loadTexture(shopItems.imagepath)
            mode:setTouchEnabled(true)
            mode:addTouchEventListener(handler(self, self.onTouchBuy))
            Text_price:setString(mode.CoinNum)
        end
    end
end

--[[
 * 按钮点击事件
 * @param  sender 点击按钮
 * @param  event  事件类型
--]]
function ShopLayer:onTouchBuy(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        if sender.CoinNum > (laixia.LocalPlayercfg.LaixiaZsCoin or 0) then
            local scene = cc.Director:getInstance():getRunningScene()
            scene:addZSB()
        else
            --发送芝士币兑换金币请求
            self:sendorderidpacket(sender.id,sender.GolNum,sender.CoinNum)
        end
    end
end

function ShopLayer:onDelaty(sender)
    sender:setTouchEnabled(false)
    local dela = cc.DelayTime:create(0.5)
    local fun = cc.CallFunc:create(function()
        sender:setTouchEnabled(true)
        end)
    local seq = cc.Sequence:create(dela,fun)
    sender:runAction(seq)
end

--[[
 * 更新芝士币
 * @param  addCoin 更新数量
--]]
function updateUserCoin(data)
    print("updateUserCoin=-------------")
    dump(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    local scene = cc.Director:getInstance():getRunningScene()
    scene:updateCoin(tonumber(info.zscoin),true)
    self.Text_zhishi_num:setString(laixia.LocalPlayercfg.LaixiaZsCoin)
end

function rechargeCallBack(data)
    print("rechargeCallBack=-------------")
    dump(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    local scene = cc.Director:getInstance():getRunningScene()
    scene:updateCoin(tonumber(info.zscoin),true)
    self.Text_zhishi_num:setString(laixia.LocalPlayercfg.LaixiaZsCoin)
end

--[[
 * 发送订单
 * @param  itemid 物品标识
 * @param  coinNum 兑换数量
--]]
function ShopLayer:sendorderidpacket(itemid,goldNum,coinNum)
    
    local stream =  laixia.Packet.new("shoplayer", "LXG_SHOP_USE_ITEM")
    stream:setReqType("post")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    stream:setValue("itemid", itemid)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1.dm_error == 0 then
            print("兑换成功 ↓")
            -- dump(data1)
            local scene = cc.Director:getInstance():getRunningScene()
            scene:updateGold(goldNum + goldNum *0.1)
            scene:updateCoin(-coinNum)
            self.Text_gold_num:setString(laixia.LocalPlayercfg.LaixiaGoldCoin)
            self.Text_zhishi_num:setString(laixia.LocalPlayercfg.LaixiaZsCoin)
        else
            scene:popUpTips(data1.error_msg)
        end
    end)
end

function ShopLayer:gotoBack(sender,eventtype)
    _G.onTouchButton(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        self:onDestroy()
    end
end

--[[
 * 注销
 * @param  nil 
--]]
function ShopLayer:onDestroy()
    self:removeFromParent()
    self.rootNode = nil
    self.mshopItems = {}
    self.btnType = {}
    self.pageArray ={}
end

return ShopLayer