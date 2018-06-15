
local ShopWindow = class("ShopWindow", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg;     
local Packet = import("....net.Packet") 

local db2 = laixia.JsonTxtData
local itemDBM 

function ShopWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
    self.mIsShow = false
end

function ShopWindow:getName()
    return "ShopWindow"
end

function ShopWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_SHOP_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW, handler(self, self.updateWindow))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_SHOP_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_ORDERINFO_WINDOW, handler(self, self.sendOrderIDPacket))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_EXCHANGE_WINDOW, handler(self, self.sendExchangePacket))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_EXCHANGE_WINDOW,handler(self,self.updateExchange))
end

--发送兑换请求
function ShopWindow:sendExchangePacket()
    local ExchangePacket = Packet.new("ExchangePacket", _LAIXIA_PACKET_CS_ExchangeDataID)
    ExchangePacket:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    ExchangePacket:setValue("GameID", laixia.config.GameAppID)
    ExchangePacket:setValue("LastTime", 0)
    laixia.net.sendHttpPacketAndWaiting(ExchangePacket, nil, 1)
end

function ShopWindow:updateExchange(mesg)
    print("111111111111111111111111111111111111111111111111111111111111111111111111111111111111")
    if laixia.kconfig.isYingKe ~= true then
        self.mExchangeItems={}
        for i,v in ipairs(mesg.data) do
            local Itemsdata = itemDBM:query("itemsID",v["ItemID"]);
            if Itemsdata then
                table.insert(self.mExchangeItems,v)
            end
        end
        self:showOnlyButton(3)
        self.lisview:removeAllItems()
        self:updateExchangeInfo()
    end
end

function ShopWindow:updateWindow()
    if self.mIsShow == false then 
        return 
    end
    self:updateGoodsInfo()
end

function updateUserCoin(data)
    print("ShopWindow---------------------alexwang")
    print(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)
    self:GetWidgetByName("Text_6"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
end
-- function updateUserCoin_IOS(status,data)
--     print("ShopWindow---------------------alexwang")
--     print(data)
--     if status == 0 then
--         laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(data)
--         self:GetWidgetByName("Text_6"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
--     end
-- end

function rechargeCallBack(data)
    print("rechargeCallBack=-------------alexwang")
    print(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)
    self:GetWidgetByName("Text_6"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
end
function ShopWindow:onShow(mesg)
    if self.mIsShow == false then
        self:setAdaptation()
        self.noRepeatTime = 0
        self.mshopItems = {}
        self.mExchangeItems={}  

--        self:GetWidgetByName("BG"):loadTexture("mall_bg.png",1)
        itemDBM =db2:queryTable("shop")

        if laixia.kconfig.isYingKe == true then
        --     self:GetWidgetByName("Mail_ListView"):setVisible(false)
        --     self.lisview = self:GetWidgetByName("Mail_ListView_Duihuan")
        --     self.lisview:setVisible(true)
        --     -- self.Image_zhishijinbi = self:GetWidgetByName("Image_zhishijinbi"):setVisible(true)
            -- if device.platform == "ios" then
            --     local state ,value = luaoc.callStaticMethod("IKCRBridgeManager", "getCoin",{ callback = updateUserCoin_IOS}, "(I)V");
            -- elseif device.platform == "android" then
            --     local javaClassName = APP_ACTIVITY
            --     local javaMethodName = "getUserCoin"
            --     local javaParams = { }
            --     local javaMethodSig = "()V"--"()Ljava/lang/String;"        
            --     local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            -- end
        end
        -- else
        --     self:GetWidgetByName("Mail_ListView_Duihuan"):setVisible(false)
        self.lisview = self:GetWidgetByName("Mail_ListView")
        -- end
        self.mGoodsCell = self:GetWidgetByName("Image_Mail_Item")  
        self.mExchangeCell = self:GetWidgetByName("Image_Exchange_Item")
        self.mImageCell = self:GetWidgetByName("ImageCell")
-----------------------------------------------------------------------------------------------------
        self.ButtonArray ={}

        --购买金币前景 --标号为1
        if laixia.kconfig.isYingKe ~= true then
            self.Button_GMJB_Selected = self:GetWidgetByName("Button_GMJB_Selected")
            self.Button_GMJB_Selected:addTouchEventListener(handler(self, self.doNothing))
            table.insert(self.ButtonArray,self.Button_GMJB_Selected)
            
            --购买金币后景 --标号为2
            self.Button_GMJB = self:GetWidgetByName("Button_GMJB")
            self.Button_GMJB:addTouchEventListener(handler(self, self.showGMJB)) --对应物品id为1
            table.insert(self.ButtonArray,self.Button_GMJB)
            
            -- --奖品兑换前景 --标号为3
            -- self.Button_JPDH_Selected = self:GetWidgetByName("Button_JPDH_Selected")
            -- table.insert(self.ButtonArray,self.Button_JPDH_Selected)
            -- self.Button_JPDH_Selected:addTouchEventListener(handler(self, self.doNothing))
            -- --奖品兑换后景 --标号为 4
            -- self.Button_JPDH = self:GetWidgetByName("Button_JPDH")
            -- self.Button_JPDH:addTouchEventListener(handler(self, self.showJPDH))
            -- table.insert(self.ButtonArray,self.Button_JPDH)
            self:showOnlyButton(mesg.data.buttonType)
            self.ButtonType = mesg.data.buttonType
        else
            self:GetWidgetByName("Button_GMJB_Selected"):setVisible(false)
            self:GetWidgetByName("Button_GMJB"):setVisible(false)
            self.Button_DHJB_Selected = self:GetWidgetByName("Button_DHJB_Selected")
            self.Button_DHJB_Selected:addTouchEventListener(handler(self, self.doNothing))
            self.Button_DHJB_Selected:setVisible(true)
            -- table.insert(self.ButtonArray,self.Button_DHJB_Selected)
        end
--------------------------------------------------------------------------P---------------------------
        self.mAllItems = {}      
        local goods = laixia.JsonTxtData:queryTable("shop"):queryAllMallInfoByOneList();
        if laixia.kconfig.isYingKe ~= true then   
            for i,v in ipairs(goods) do
                local isUse = false
                --安卓 或者 苹果官网
                if device.platform == "android" then
                    if tonumber(v.itemsID)<130000 and tonumber(v.itemsID)>=120000 then
                        isUse = true
                    end
                elseif device.platform == "ios" then
                    if tostring(laixia.LocalPlayercfg.CHANNELID)=="111267" then--官网
                        if tonumber(v.itemsID)<130000 and tonumber(v.itemsID)>=120000 then
                            isUse = true
                        end
                    elseif tostring(laixia.LocalPlayercfg.CHANNELID)=="201009" or tonumber(laixia.LocalPlayercfg.CHANNELID)>=200000 then--苹果渠道包
                        if tonumber(v.itemsID)<130000 and tonumber(v.itemsID)>=120000 then
                            isUse = true
                        end
                    elseif laixia.kconfig.isApple1 == true then--苹果马甲包
                        if tonumber(v.itemsID)<1200000 and tonumber(v.itemsID)>1100000 then
                            isUse = true
                        end
                    elseif laixia.kconfig.isApple2 == true then--苹果官网包
                        if tonumber(v.itemsID)<1300000 and tonumber(v.itemsID)>=1200000 then
                            isUse = true
                        end
                    else
                        if tonumber(v.itemsID)<130000 and tonumber(v.itemsID)>=120000 then
                            isUse = true
                        end
                    end
                else
                    if tonumber(v.itemsID)<130000 and tonumber(v.itemsID)>=120000 then
                        isUse = true
                    end
                end
                if isUse==true then
                    local isShow = false
                    if  not v.isShow or v.isShow==0  then --and v.itemsID ~= 1020
        --                table.insert(self.mAllItems,v)
                           isShow = true
                       --print("k = " .. i .. "v.itemsID : " .. v.itemsID)
                    end
                    local time = os.time()
                    if v.EndTime==0 and v.BeginTime == 0 then
        --                table.insert(self.mAllItems,v)
                        isShow = true
                    elseif time <= v.EndTime and time >= v.BeginTime then
        --                table.insert(self.mAllItems,v)
                        isShow = true
                    else
                        isShow = false
                    end
                    if isShow == true then
                        table.insert(self.mAllItems,v)
                    end
               end
            end
        elseif laixia.kconfig.isYingKe == true then
            for i,v in ipairs(goods) do
                local isUse = false
                if device.platform == "android" then
                    if tonumber(v.itemsID)<140000 and tonumber(v.itemsID)>=130000 then
                        isUse = true
                    end
                elseif device.platform == "ios" then
                    if tostring(laixia.LocalPlayercfg.CHANNELID)=="201010" then
                        if tonumber(v.itemsID)<140000 and tonumber(v.itemsID)>=130000 then
                            isUse = true
                        end
                    elseif tostring(laixia.LocalPlayercfg.CHANNELID)=="111267" then--官网
                        if tonumber(v.itemsID)<140000 and tonumber(v.itemsID)>=130000 then
                            isUse = true
                        end
                    elseif tostring(laixia.LocalPlayercfg.CHANNELID)=="201009" or tonumber(laixia.LocalPlayercfg.CHANNELID)>=200000 then--苹果渠道包
                        if tonumber(v.itemsID)<140000 and tonumber(v.itemsID)>=130000 then
                            isUse = true
                        end
                    -- elseif laixia.config.isApple1==true then--苹果马甲包
                    --     if tonumber(v.itemsID)<1400000 and tonumber(v.itemsID)>1100000 then
                    --         isUse = true
                    --     end
                    -- elseif laixia.kconfig.isApple2==true then--苹果官网包
                    --     if tonumber(v.itemsID)<1300000 and tonumber(v.itemsID)>=1200000 then
                    --         isUse = true
                    --     end
                    -- else
                    --     if tonumber(v.itemsID)<140000 and tonumber(v.itemsID)>=130000 then
                    --         isUse = true
                    --     end
                    end
                else
                    if tonumber(v.itemsID)<140000 and tonumber(v.itemsID)>=130000 then
                        isUse = true
                    end
                end
                if isUse==true then
                    local isShow = false
                    if  not v.isShow or v.isShow==0  then --and v.itemsID ~= 1020
        --                table.insert(self.mAllItems,v)
                           isShow = true
                       --print("k = " .. i .. "v.itemsID : " .. v.itemsID)
                    end
                    local time = os.time()
                    if v.EndTime==0 and v.BeginTime == 0 then
        --                table.insert(self.mAllItems,v)
                        isShow = true
                    elseif time <= v.EndTime and time >= v.BeginTime then
        --                table.insert(self.mAllItems,v)
                        isShow = true
                    else
                        isShow = false
                    end
                    if isShow == true then
                        table.insert(self.mAllItems,v)
                    end
                end
            end
        end
        self.mshopItems = self.mAllItems
-----------------------------------------------------------------------------------------------------
----显示公共的头
       ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_COMMONTOP_WINDOW,
        { goBackFun = function()
            if laixia.LocalPlayercfg.OnReturnFunction == _LAIXIA_EVENT_UPDATE_SELECTROOM_WINDOW then
                 -- laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_UPDATE_SELECTROOM_WINDOW
             self.mRoomType = 2 --经典场
            local stream = Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
                  stream:setValue("RoomType", self.mRoomType)
                  laixia.net.sendPacketAndWaiting(stream)
            else
                  ObjectEventDispatch:pushEvent(laixia.LocalPlayercfg.OnReturnFunction)
                  
            end
            --ObjectLocalPlayerData.OnReturnFunction = _LAIXIA_EVENT_SHOW_HALL_WINDOW
          end,
          --isDisableLaidou = true,
        })
       self.mIsShow = true
   end
end

        
--返回按钮
function ShopWindow:goBack(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onCallBackFunction()
    end
end

--显示购买金币
function ShopWindow:showGMJB(sender, eventType)
    if eventType == ccui.TouchEventType.ended then

        self:showOnlyButton(1)
        self.lisview:removeAllItems()
        self.mshopItems = self.mAllItems
        self:updateGoodsInfo()
    end
end


--显示奖品兑换
function ShopWindow:showJPDH(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.mExchangeItems={}
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_EXCHANGE_WINDOW)
    end
end
--不做事情，因为前景不是图片是按钮，所以绑定一个空方法
function ShopWindow:doNothing(sender, eventType)
    if eventType == ccui.TouchEventType.ended then

    end
end


--显示唯一的前景按钮
function ShopWindow:showOnlyButton(index)
    laixia.UItools.onShowOnly(index,self.ButtonArray)  
end


--设置显示兑换的物品
function ShopWindow:addExchangeCell(start,over)
    if laixia.kconfig.isYingKe ~= true then
        local mode = self.mImageCell:clone()
        self.lisview:pushBackCustomItem(mode)
        self.mModeSize = mode:getContentSize();
        self.mEachWidth = self.mModeSize.width / 3
        self.mPosX = self.mEachWidth / 2
        
        if start == 1 then
            self.mPosY = self.mModeSize.height /2
         elseif start>1 then
            self.mPosY = self.mPosY + 50
        end
        self:addExchange2Listview(start,over,mode)
    end
end
--设置显示商城的物品
function ShopWindow:addGoodsCell(start,over)
        local mode = self.mImageCell:clone()
        self.lisview:pushBackCustomItem(mode)
        self.mModeSize = mode:getContentSize();
        self.mEachWidth = self.mModeSize.width / 3
        self.mPosX = self.mEachWidth / 2
        if start == 1 then
            self.mPosY = self.mModeSize.height /2
        elseif start>1 then
            self.mPosY = self.mPosY + 50
        end
        self:adGoods2Listview(start,over,mode)
end

function ShopWindow:addExchange2Listview(start,over,mode)
    if laixia.kconfig.isYingKe  ~= true then
        for i=start,over do 
            
            local itemMode=self.mExchangeCell:clone()
            itemMode:setPosition(cc.p(self.mPosX,self.mPosY))
            itemMode:addTo(mode)
            self.mPosX = self.mPosX + self.mEachWidth-60

            local itemInfo = self.mExchangeItems[i]
            itemMode.Info = itemInfo

            --items
            local Itemsdata = db2:queryTable("items"):query("ItemID",itemInfo["ItemID"])
            --shop
            local Itemsdata2 = itemDBM:query("ItemID",itemInfo["ItemID"]);
            itemMode:setTouchEnabled(true)
            itemMode:addTouchEventListener(function (sender,eventType)
                self:onShowExchageDetail(sender,eventType)
                end)
            local btn_Exchange=self:GetWidgetByName("Button_Exchange_Btn", itemMode)
            local totalCoin = itemInfo["ItemCount"]
            local labelCoinWithoutDot = self:GetWidgetByName("BitmapLabel_Title_Num",itemMode)
            
            -- if totalCoin < 100000 then 
            --     labelCoinWithoutDot:setVisible(true)
            --     labelCoinWithoutDot:setString(totalCoin.."奖券")
            -- else
            --     local total = totalCoin / 10000  --以万为单位
            --     if math.floor(total) < total then  --有小数
            --         local tmp = string.format("%0.1f",total)
            --         local priceBeforeDot = math.floor(total)
            --         local priceAfterDot = (tmp * 10) % 10
            --         labelCoinWithoutDot:setVisible(true)
            --         labelCoinWithoutDot:setString(total.."万".."奖券")
            --     else    
            --         labelCoinWithoutDot:setVisible(true)
            --         labelCoinWithoutDot:setString(total.."万".."奖券")
            --     end
            -- end

            
            self:GetWidgetByName("Label_Exchange", itemMode):setString("现有库存"..itemInfo["ItemNum"])

            local image = Itemsdata.ImagePath
            local imageCoinIcon = self:GetWidgetByName("Image_Dia_Icon",itemMode) --物品图标

            ----
            local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
            if #baoming_Array >1 then
                if Itemsdata.ItemID == 120020 or Itemsdata.ItemID == 1100020 or Itemsdata.ItemID == 1021 then
                    imageCoinIcon:loadTexture(Itemsdata.ImagePath)
                    imageCoinIcon:setPositionX(imageCoinIcon:getPositionX()+10)
                    imageCoinIcon:setScale(0.4) 
                else 
                    imageCoinIcon:loadTexture(Itemsdata.ImagePath)
                    iamgeCoinIcon:setScale(0.7)
                end
               
            else
                imageCoinIcon:removeAllChildren()
            --ImagePath字段 道具大icon############
                if Itemsdata.ItemID == 120020 or Itemsdata.ItemID == 1100020 or Itemsdata.ItemID == 1021  then
                    imageCoinIcon:loadTexture(Itemsdata.ImagePath, 1)
                    imageCoinIcon:setPositionX(imageCoinIcon:getPositionX()+10)
                    imageCoinIcon:setScale(0.5) 
                else
                    imageCoinIcon:loadTexture(Itemsdata.ImagePath, 1)
                    imageCoinIcon:setScale(0.7)     
                end       
            end
            ----
            
            -- if image ~= nil and image~="null" then
            --     imageCoinIcon:loadTexture(image,1)
            -- end
             
            -- if Itemsdata.PresentItemID1 == 1003 then
            --      local sicon =  "red_packet_"..Itemsdata.BaseCount..".png"
            --      local count = ccui.ImageView:create(sicon,1)
            --      count:setPosition(78,60)
            --      count:setLocalZOrder(100)
            --      count:addTo(imageCoinIcon)
            -- end
            imageCoinIcon:setScale(0.9)                            
            btn_Exchange.Info = itemInfo
            btn_Exchange:addTouchEventListener( function(sender, eventType)
                    -- 绑定触摸监听函数
                    self:onShowExchageDetail(sender, eventType)
                end )
        end
    end
end

function ShopWindow:onShowExchageDetail(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:dispatchEvent( { name = _LAIXIA_EVENT_SHOW_REDEEMDETAILS_WINDOW, Info = sender.Info })
    end
end

--设置物品的详情
function ShopWindow:adGoods2Listview(start,over,mode)
    if laixia.kconfig.isYingKe ~= true then  
        for i=start,over do 
            local itemMode = self.mGoodsCell:clone()
            itemMode:setPosition(cc.p(self.mPosX,self.mPosY))
            itemMode:addTo(mode)
            self.mPosX = self.mPosX +  self.mEachWidth-60


            local shopItems = self.mshopItems[i]
            local itemID = tonumber(shopItems["itemsID"])
            local itemInfo = laixia.JsonTxtData:queryTable("items"):query("ItemID",itemID)
           -- local itemInfo2 = laixia.JsonTxtData:queryTable("shop"):query("itemsID",itemID);

            --icon
            local image = itemInfo.ImagePath
            local imageCoinIcon = self:GetWidgetByName("Image_Dia_Icon",itemMode)
            local baoming_Array = string.split(itemInfo.ImagePath ,'/')
            if #baoming_Array >1 then
                -- local sprite = display.newSprite(itemInfo.ImagePath)
                -- sprite:setScale(0.8)  
                -- sprite:setAnchorPoint(cc.p(0.5,0.5))
                -- sprite:setPosition(cc.p(20,30))
                -- sprite:addTo(imageCoinIcon)
                -- if Itemsdata.ItemID == 120020 or Itemsdata.ItemID == 1100020 then
                --     imageCoinIcon:loadTexture(Itemsdata.ImagePath, 1)
                --     imageCoinIcon:setScale(0.3) 
                -- else
                --     imageCoinIcon:loadTexture(Itemsdata.ImagePath, 1)
                --     imageCoinIcon:setScale(0.7)     
                -- end 
                if itemInfo.ItemID == 120020 or itemInfo.ItemID == 1100020 or itemInfo.ItemID == 1021 then
                    imageCoinIcon:loadTexture(itemInfo.ImagePath)
                    imageCoinIcon:setPositionX(imageCoinIcon:getPositionX()+10)
                    imageCoinIcon:setScale(0.5) 
                else 
                    imageCoinIcon:loadTexture(itemInfo.ImagePath)
                    imageCoinIcon:setScale(0.7)
                end
                -- imageCoinIcon:loadTexture(itemInfo.ImagePath)
                -- imageCoinIcon:setScale(0.7)
               
            else
                imageCoinIcon:removeAllChildren()
                --ImagePath字段 道具大icon############
                if itemInfo.ItemID == 120020 or itemInfo.ItemID == 1100020 or itemInfo.ItemID == 1021 then
                    imageCoinIcon:loadTexture(itemInfo.ImagePath, 1)
                    imageCoinIcon:setPositionX(imageCoinIcon:getPositionX()+10)
                    imageCoinIcon:setScale(0.5) 
                else
                    imageCoinIcon:loadTexture(itemInfo.ImagePath, 1)
                    imageCoinIcon:setScale(0.7)     
                end 
                -- imageCoinIcon:loadTexture(itemInfo.ImagePath, 1)
                -- imageCoinIcon:setScale(0.7)            
            end
            --imageCoinIcon:setScale(0.8)

            --
            self:GetWidgetByName("Button_Money_Btn", itemMode):setVisible(true)
            local buttonBuy = self:GetWidgetByName("Button_Money_Btn", itemMode) 
            itemMode.ID = itemID
            itemMode:setTouchEnabled(true)
            itemMode:addTouchEventListener( function(sender, eventType)
                self:buy(sender, eventType)
            end )
            --self:AddWidgetEventListenerFunction("Button_Money_Btn",handler(self,self.buy))

            buttonBuy.ID = itemID
            buttonBuy:addTouchEventListener( function(sender, eventType)
                self:buy(sender, eventType)
            end )
            --self:AddWidgetEventListenerFunction("Image_Mail_Item",handler(self,self.buy))

            --Price 按钮 元
           local labelPrice = self:GetWidgetByName("AtlasLabel_Num",buttonBuy)
           labelPrice:setString("¥" .. shopItems.Price..'元')
           labelPrice:enableOutline(cc.c4b(152,70,3,255), 2)


            --ShopDesc
            self:GetWidgetByName("Label_Exchange",itemMode) :setVisible(true)
            self:GetWidgetByName("Label_Exchange",itemMode) :setString(shopItems.ShopDesc)

            --ItemName
            local labelCoinWithoutDot = self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setString(itemInfo.ItemName)


             --self:GetWidgetByName("Label_Exchange",itemMode) :setString("多送"..shopItems.ShopDesc.."金币")
    --        if itemInfo.BaseCount~=0 then 
    --            totalCoin = totalCoin + itemInfo.BaseCount
    --            if itemInfo.AddCount and itemInfo.AddCount~=0 then 
    --                local addCount = itemInfo.AddCount 
    --                totalCoin = totalCoin + addCount
    --                local  mAddCount = totalCoin- shopItems.Price  *10000
    --                if mAddCount > 0 then
    --                   
    --                end
    --            end
    --        end
                --最上面的num
                -- local labelCoinWithoutDot = self:GetWidgetByName("BitmapLabel_Title_Num",itemMode)
                --  local totalCoin = 0
                -- if totalCoin < 100000 then 
                --    if totalCoin == 1 then
                --         local name =itemInfo.ItemName 
                --         labelCoinWithoutDot:setVisible(true)
                --         labelCoinWithoutDot:setString(name)

                --         if itemInfo.ItemID == 3009 then
                --             self:GetWidgetByName("Label_Exchange",itemMode) :setVisible(true)
                --             self:GetWidgetByName("Label_Exchange",itemMode) :setString("内含4张门票")                    
                --         end

                --         if 3204 == itemInfo.ItemID or 3205 == itemInfo.ItemID then
                --             self:GetWidgetByName("Label_Exchange",itemMode) :setVisible(true)
                --             self:GetWidgetByName("Label_Exchange",itemMode) :setString("新上线加赠20%")  
                --         end
                --    else
                --         labelCoinWithoutDot:setVisible(true)
                --         local name =itemInfo.ItemName 
                --         labelCoinWithoutDot:setString(name)
                --         --labelCoinWithoutDot:setString(totalCoin.."金币")
                --    end

                -- else
                --     local total = totalCoin / 10000  --以万为单位
                --     if math.floor(total) < total then  --有小数
                --         local tmp = string.format("%0.1f",total)
                --         local priceBeforeDot = math.floor(total)
                --         local priceAfterDot = (tmp * 10) % 10
                --         labelCoinWithoutDot:setVisible(true)
                --         local name =itemInfo.ItemName 
                --         labelCoinWithoutDot:setString(name)
                --         --labelCoinWithoutDot:setString(total.."万".."金币")

                --     else    
                --         labelCoinWithoutDot:setVisible(true)
                --         local name =itemInfo.ItemName 
                --         labelCoinWithoutDot:setString(name)
                --         --labelCoinWithoutDot:setString(total.."万".."金币")
                --     end
                -- end
        end
    elseif laixia.kconfig.isYingKe == true then
        -- for i=start,over do
        --     local shopItems = self.mshopItems[i]
        --     local itemID = tonumber(shopItems["itemsID"])
        --     -- if device.platform == "ios" then 
        --     --     self.mGoodsCell:loadTexture("new_ui/ShopWindow/000"..(i+4)..".png")
        --     -- elseif device.platform == "android" then
        --     --     self.mGoodsCell:loadTexture("new_ui/ShopWindow/000"..i..".png")
        --     -- else
        --     --     self.mGoodsCell:loadTexture("new_ui/ShopWindow/000"..i..".png")
        --     -- end
        --     local itemMode = self.mGoodsCell:clone()
        --     itemMode:setPosition(cc.p(self.mPosX,self.mPosY))
        --     itemMode:addTo(mode)
        --     self.mPosX = self.mPosX +  self.mEachWidth-60
        --     self:GetWidgetByName("Image_Dia_Icon",itemMode):setVisible(false)
        --     self:GetWidgetByName("Button_Money_Btn", itemMode):setVisible(false)
        --     self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setVisible(false)

        --     self:GetWidgetByName("Button_duihuan",itemMode) :setVisible(true)
        --     local buttonBuy = self:GetWidgetByName("Button_duihuan",itemMode) 
        --     buttonBuy.ID = itemID
        --     buttonBuy:addTouchEventListener( function(sender, eventType)
        --         self:buy(sender, eventType)
        --     end )
        -- end
        for i=start,over do 
            local shopItems = self.mshopItems[i]
            local itemID = tonumber(shopItems["itemsID"])
            
            -- local itemInfo = laixia.JsonTxtData:queryTable("items"):query("ItemID",itemID)


            self.mGoodsCell:loadTexture("new_ui/ShopWindow/diban.png")
            self:GetWidgetByName("Image_Dia_Icon",itemMode):setVisible(false)
            self:GetWidgetByName("Button_Money_Btn", itemMode):setVisible(false)
            local itemMode = self.mGoodsCell:clone()
            itemMode:setPosition(cc.p(self.mPosX,self.mPosY))
            itemMode:addTo(mode)
            self.mPosX = self.mPosX +  self.mEachWidth-60

            self:GetWidgetByName("Label_Exchange",itemMode):setVisible(true)
            self:GetWidgetByName("Label_Exchange",itemMode) :setString(shopItems.ShopDesc)

            self:GetWidgetByName("Image_exchange",itemMode):setVisible(true)
            self:GetWidgetByName("Image_zhishi",itemMode):setVisible(true)
            self:GetWidgetByName("Image_jinbi",itemMode):setVisible(true)

            self:GetWidgetByName("Button_duihuan",itemMode):setVisible(true)
            local buttonBuy = self:GetWidgetByName("Button_duihuan",itemMode) 

            itemMode.ID = itemID
            itemMode:setTouchEnabled(true)
            itemMode:addTouchEventListener( function(sender, eventType)
                self:buy(sender, eventType)
            end )

            buttonBuy.ID = itemID
            buttonBuy:addTouchEventListener( function(sender, eventType)
                self:buy(sender, eventType)
            end )
            
            if laixia.kconfig.isYingKe==true then
                if itemID == 130001 then
                    self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setString("1万金币")
                    buttonBuy.ZhiShiBiNum = 100
                elseif itemID == 130002 then
                    self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setString("2万金币")
                    buttonBuy.ZhiShiBiNum = 200
                elseif itemID == 130003 then
                    self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setString("3万金币")
                    buttonBuy.ZhiShiBiNum = 300
                elseif itemID == 130004 then
                    self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setString("10万金币")
                    buttonBuy.ZhiShiBiNum = 1000
                elseif itemID == 130005 then
                    self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setString("20万金币")
                    buttonBuy.ZhiShiBiNum = 2000
                elseif itemID == 130006 then
                    self:GetWidgetByName("BitmapLabel_Title_Num",itemMode):setString("30万金币")
                    buttonBuy.ZhiShiBiNum = 3000
                end
            end
        end
    end
end
function ShopWindow:sendOrderIDPacket(msg)
    if msg and msg.data and msg.data.id then
        local CSRequestOrder = Packet.new("CSRequestOrder", _LAIXIA_PACKET_CS_RequestOrderID)
        local _gameAPPID = laixia.config.GameAppID
        CSRequestOrder:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
        CSRequestOrder:setValue("GameID", _gameAPPID)
        CSRequestOrder:setValue("ItemID", msg.data.id)
        laixia.net.sendHttpPacketAndWaiting(CSRequestOrder)
    end
end

function ShopWindow:buy(sender, eventType)
    -- if eventType == ccui.TouchEventType.ended then
    --     -- if os.time() - self.noRepeatTime < 2 then
    --     --     self.noRepeatTime = os.time()
    --     --     return
    --     -- end
    --     if laixia.kconfig.isYingKe == true then
    --         --发送芝士币兑换金币请求
    --         self:sendOrderIDPacket({data={id=sender.ID}})
    --         return
    --     end
    --     self.noRepeatTime = os.time()
    --     laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

    --     if laixia.config.isAudit then
    --         ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, {Text = "暂时不能充值"}) 
    --     elseif sender.ID == 120020 then
    --         ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_WEEKCARD_WINDOW,{id=sender.ID}) 
    --     else
    --         self:sendOrderIDPacket({data={id=sender.ID}})
    --     end   
    -- end
    if eventType == ccui.TouchEventType.ended then
    print("55555555555555555555555555555555555555555555555")
        if laixia.kconfig.isYingKe == true then
            if sender.ZhiShiBiNum > (laixia.LocalPlayercfg.ZhiShiBiNum or 0) then
                if device.platform == "android" then
                    local javaClassName = APP_ACTIVITY
                    local javaMethodName = "gotoChargePage"
                    local javaParams = { }
                    local javaMethodSig = "()V"        
                    local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                else
                    local state ,value = luaoc.callStaticMethod("IKCRBridgeManager", "showPayView");
                end
            else
                --发送芝士币兑换金币请求
                print("alexwang---------点击购买商品"..sender.ID)
                self:sendOrderIDPacket({data={id=sender.ID}})
            end
            return
        end
        self.noRepeatTime = os.time()
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        if laixia.config.isAudit then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, {Text = "暂时不能充值"}) 
        elseif sender.ID == 120020 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_WEEKCARD_WINDOW,{id=sender.ID}) 
        else
            self:sendOrderIDPacket({data={id=sender.ID}})
        end   
    end
end
-- --发送芝士币兑换金币请求
-- function ShopWindow:sendExchangeJBPacket(msg)
--     if msg and msg.data and string.sub(tostring(msg.data.id),0,2) == "13" then
--         local CSRequestExchangeJB = Packet.new("CSRequestExchangeJB", _LAIXIA_PACKET_CS_RequestExchangeJBID)
--         CSRequestExchangeJB:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
--         CSRequestExchangeJB:setValue("GameID",laixia.config.GameAppID)
--         CSRequestExchangeJB:setValue("ItemID", msg.data.id)
--         laixia.net.sendHttpPacket(CSRequestExchangeJB)
--     end   
-- end
--更新兑换物品
function ShopWindow:updateExchangeInfo()
    print("111111111111111111111111111111111111111111111111111111111111111111111111111111111111")
    local amount = #self.mExchangeItems 
    local index = tonumber(amount / 4)
    local mode = amount % 4
    if mode~=0 then 
        index = index + 1
    end 
    if index > 0 then 
        for i=1,index do 
            local start = (i-1)*4 + 1
            local over = i * 4 
            if over >amount then 
                over = amount
            end
            if start >1 then
                self.mPosY = self.mPosY - 1300
            end

            self:addExchangeCell(start,over)
        end
    end 
end

--进行适配
function ShopWindow:setAdaptation()
    -- local view = self.mInterfaceRes;
    -- view:setAnchorPoint(0.5,0.5)
    -- view:pos(display.cx, display.cy)
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
            self:GetWidgetByName("Image_2"):setScaleX(2436/3*2/1280)
        end
    end
end
--更新物品
function ShopWindow:updateGoodsInfo()
    local amount = #self.mshopItems
    local index = tonumber(amount / 4)
    local mode = amount % 4
    if mode~=0 then 
        index = index + 1
    end 
    if index > 0 then 
        for i=1,index do 
            local start = (i-1)*4 + 1
            local over = i * 4 
            if over >amount then 
                over = amount
            end
                self:addGoodsCell(start,over)
        end
    end 
end

function ShopWindow:onDestroy()
    self.mIsShow = false
    self.mExchangeItems={}
end

return ShopWindow.new()
