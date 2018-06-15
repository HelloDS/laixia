local TPPayWindow = class("TPPayWindow", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 

local db2 = laixiaddz.JsonTxtData
local itemDBM 

function TPPayWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function TPPayWindow:getName()
    return "TPPayWindow"
end

function TPPayWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_PAY_WINDOW,handler(self,self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_PAY_TOFUN,handler(self,self.LaixiaSDkPay))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_PAY_WEIYOUXI,handler(self,self.WeiyouxiPay))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_PAY_XIAOMI,handler(self,self.XiaomiPay))

end

--调用小米支付
function TPPayWindow:XiaomiPay(msg)
    if msg and msg.data and msg.data.orderID then
        local orderID = msg.data.orderID
        local mShopItem = laixiaddz.JsonTxtData:queryTable("shop"):queryMallInfoByID(msg.data.ItemID);
        local Price = mShopItem["price"]
    
        itemDBM = itemDBM  or db2:queryTable("items");
        local item = itemDBM:query("ItemID",msg.data.ItemID)
        
        --local args = { msg.data.ItemID, item.ItemName, tostring(orderID), Price }
        local args = { tostring(orderID), Price }
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
            local className = APP_ACTIVITY
            local sigs = "(Ljava/lang/String;I)V"
          
            local payState = luaj.callStaticMethod(className,"miPay",args,sigs)
           
            if payState then
                print("pay success")
            else
                print("pay error")
            end
        end 

    end


end


function TPPayWindow:WeiyouxiPay(msg)
    if msg and msg.data and msg.data.orderID then
        local orderID = msg.data.orderID
        local mShopItem = laixiaddz.JsonTxtData:queryTable("shop"):queryMallInfoByID(msg.data.ItemID);
        local Price = mShopItem["price"]
    
        itemDBM = itemDBM  or db2:queryTable("items");
        local item = itemDBM:query("ItemID",msg.data.ItemID)

        local args = { msg.data.ItemID, item.ItemName, tostring(orderID), Price }
        
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
            local className = APP_ACTIVITY
            local sigs = "(ILjava/lang/String;Ljava/lang/String;I)V"
            local payState = luaj.callStaticMethod(className,"getPay",args,sigs)
            if payState then
                print("pay success")
            else
                print("pay error")
            end
        end 

    end
end

function Android_SDK(args)

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        -- local className = APP_ACTIVITY
        -- local sigs = "(IILjava/lang/String;I)V"
        -- local payState = luaj.callStaticMethod(className,"getPay",args,sigs)
        -- if payState then
        --     print("pay success")
        -- else
        --     print("pay error")
        -- end

        --local args = { payType, AppType, tostring(orderID), Price }
        local channelName = 0
        if args.payType == 1 then
            channelName = "weixin"
        elseif args.payType == 2 then
            channelName = "zhifubao"
        else
            channelName = "other"
        end
        local function callback(isSuccess)
            if isSuccess==true then
                -- if self.msg.ItemID == 120020 then
                --     local iconpath = "res/new_ui/common/red_packet/weekcard.png"
                --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EFFECTGOLD_WINDOW,{iconpath=iconpath})
                --     return
                -- end
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EFFECTGOLD_WINDOW)
                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"充值成功")
            else
                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"充值失败")
            end
        end
        laixiaddz.LocalPlayercfg.PluginChannel:setEndCallBack(callback)
        laixiaddz.LocalPlayercfg.PluginChannel:pay(channelName,args.ItemID,args.Price,args.productName,args.orderID)
    end   
end

local function sendOrderToSever(msg)

    local array = msg
    local onsendtoSever = Packet.new("onsendtoSever", _LAIXIA_PACKET_CS_RechargeToIOS)
    onsendtoSever:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    onsendtoSever:setValue("AppID", array.appID)
    onsendtoSever:setValue("IOSResult", tostring( array.receiptData))
    onsendtoSever:setValue("OrderID", tostring(array.orderID))

    local productID = array.productID
    laixia.net.sendHttpPacket(onsendtoSever)

end


function TPPayWindow:onIOSPay(msg)
    local Price 
    local item
    local orderID
    local payType

    print("alexwang---------")
    print(msg.data.orderID)
    print(msg.data.ItemID)


    if msg and msg.data and msg.data.orderID then
        orderID = msg.data.orderID
        local mShopItem = laixiaddz.JsonTxtData:queryTable("shop"):queryMallInfoByID(tostring(msg.data.ItemID));
        Price = mShopItem["price"]

        itemDBM = itemDBM  or db2:queryTable("items");
        item = itemDBM:query("ItemID",msg.data.ItemID)
        if(item ==nil) then
            return;
        end 

            -- local ItemName = item.ItemName;
            payType = laixiaddz.LocalPlayercfg.LaixiaPayType --1  表示是微信 2 是支付宝
            -- local AppType =  laixia.config.GameAppID --游戏类型
            local length = string.len(tostring(orderID))
            if length < 16 then
                local num = 16-length
                for i=1,num do
                    orderID = "0" .. orderID
                end  
            end
            -- local args = { payType=payType, AppType=AppType, orderID=tostring(orderID), Price=Price ,ItemID=msg.data.ItemID ,productName = item.ItemName }
            -- Android_SDK(args)
            -- laixiaddz.LocalPlayercfg.LaixiaPayType = 0
            -- laixiaddz.LocalPlayercfg.LaixiaIsShowPayWindow =  true
    end
    print(laixiaddz.LocalPlayercfg.CHANNELID)
    print(payType)
    print(msg.data.ItemID)
    print(Price)
    print(item.ItemName)
    print(orderID)


    if tostring(laixiaddz.LocalPlayercfg.CHANNELID) == "500026" then --苹果官网
        local function callback(isSuccess)
            if isSuccess==true then
                -- if self.msg.ItemID == 120020 then
                --     local iconpath = "res/new_ui/common/red_packet/weekcard.png"
                --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EFFECTGOLD_WINDOW,{iconpath=iconpath})
                --     return
                -- end
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EFFECTGOLD_WINDOW)
                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"充值成功")
            else
                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"充值失败")
            end
        end
        laixiaddz.LocalPlayercfg.PluginChannel:setEndCallBack(callback)
        laixiaddz.LocalPlayercfg.PluginChannel:pay("appstore",msg.data.ItemID,Price,item.ItemName,orderID)
        -- local appID = tostring(laixia.config.GameAppID)
        -- local productID = tostring (msg.data.ItemID)
        -- local orderID = msg.data.orderID
        -- local arg = {callBack = sendOrderToSever, AppID = appID, productID = productID, OrderID = orderID}
        -- result, value = luaoc.callStaticMethod("IAPOperation", "buyProdution", arg)
    elseif tostring(laixiaddz.LocalPlayercfg.CHANNELID) == "111267" or tonumber(laixiaddz.LocalPlayercfg.CHANNELID)>200000 then --微信 自己官网版本 有微信
        local channelName = 0
        if payType == 1 then
            channelName = "weixin"
        elseif payType == 2 then
            channelName = "zhifubao"
            return
        end
        local function callback(isSuccess)
            if isSuccess==true then
                -- if self.msg.ItemID == 120020 then
                --     local iconpath = "res/new_ui/common/red_packet/weekcard.png"
                --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EFFECTGOLD_WINDOW,{iconpath=iconpath})
                --     return
                -- end
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EFFECTGOLD_WINDOW)
                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"充值成功")
            else
                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"充值失败")
            end
        end
        print("111267 pay")
        laixiaddz.LocalPlayercfg.PluginChannel:setEndCallBack(callback)
        laixiaddz.LocalPlayercfg.PluginChannel:pay(channelName,msg.data.ItemID,Price,item.ItemName,orderID)
        laixiaddz.LocalPlayercfg.LaixiaPayType = payType
        laixiaddz.LocalPlayercfg.LaixiaIsShowPayWindow =  true
    end
end



function TPPayWindow:onAndroldPay(msg)
  
    if msg and msg.data and msg.data.orderID then
        local orderID = msg.data.orderID
        local mShopItem = laixiaddz.JsonTxtData:queryTable("shop"):queryMallInfoByID(tostring(msg.data.ItemID));
        local Price = mShopItem["price"]

        itemDBM = itemDBM  or db2:queryTable("items");
        local item = itemDBM:query("ItemID",msg.data.ItemID)
        if(item ==nil) then
            return;
        end 
            local ItemName = item.ItemName;
            local payType = laixiaddz.LocalPlayercfg.LaixiaPayType --1  表示是微信 2 是支付宝
            local AppType =  laixia.config.GameAppID --游戏类型
            local length = string.len(tostring(orderID))
            if length < 16 then
                local num = 16-length
                for i=1,num do
                    orderID = "0" .. orderID
                end  
            end
            local args = { payType=payType, AppType=AppType, orderID=tostring(orderID), Price=Price ,ItemID=msg.data.ItemID ,productName = item.ItemName }
            Android_SDK(args)
            laixiaddz.LocalPlayercfg.LaixiaPayType = 0
            laixiaddz.LocalPlayercfg.LaixiaIsShowPayWindow =  true
    end
end

function TPPayWindow:LaixiaSDkPay(msg)
    -- local ItemID = msg.data.ItemID

    -- local mShopItem = laixiaddz.JsonTxtData:queryTable("shop"):queryMallInfoByID(tostring(ItemID));
    -- local Price = mShopItem["price"]
    -- local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    print("LaixiaSDK --PAY")
    if device.platform == "android" then
        self:onAndroldPay(msg)
    elseif device.platform == "ios" then
        self:onIOSPay(msg)
    end



end

function TPPayWindow:onShow(msg)
    self.BG = self:GetWidgetByName("Image_4")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)
    self:AddWidgetEventListenerFunction("Button_CancelPayment", handler(self, self.onDestroy))
    self:AddWidgetEventListenerFunction("Button_WeChatPay", handler(self, self.goPay))
    self:GetWidgetByName("Button_WeChatPay"):setTag(1)
    self:AddWidgetEventListenerFunction("Button_ZhiFuBaoPay", handler(self, self.goPay))
    self:GetWidgetByName("Button_ZhiFuBaoPay"):setTag(2)
    self.msg = msg
end

function TPPayWindow:onDestroy(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:destroy()
    end 
end

--显示购买金币
function TPPayWindow:goPay(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
       local tag = sender:getTag()
       local msg = self.msg
       laixiaddz.LocalPlayercfg.LaixiaPayType = tag
       self:LaixiaSDkPay(msg)
       self:destroy()
    end
end



return TPPayWindow.new()
