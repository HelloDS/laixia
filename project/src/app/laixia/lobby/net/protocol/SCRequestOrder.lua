-- 订单

local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function handlerFunction(packet)
    dumpGameData(packet)
    if packet.data.StatusID==0 then
        local orderID = packet:getValue("OrderID")
        local ItemID=packet:getValue("ItemID")

        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if laixia.kconfig.isYingKe == true then
            if ItemID == 130001 then
                if laixia.LocalPlayercfg.ZhiShiBiNum >= 100 then
                    laixia.LocalPlayercfg.ZhiShiBiNum = laixia.LocalPlayercfg.ZhiShiBiNum - 100
                    --laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + 10000
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW)
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"成功兑换1万金币")
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"您的芝士币不足兑换1万金币")
                end
            elseif ItemID == 130002 then
                if laixia.LocalPlayercfg.ZhiShiBiNum >= 200 then
                    laixia.LocalPlayercfg.ZhiShiBiNum = laixia.LocalPlayercfg.ZhiShiBiNum - 200
                    --laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + 20000
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW)
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"成功兑换2万金币")
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"您的芝士币不足兑换2万金币")
                end 
            elseif ItemID == 130003 then
                if laixia.LocalPlayercfg.ZhiShiBiNum >= 300 then
                    laixia.LocalPlayercfg.ZhiShiBiNum = laixia.LocalPlayercfg.ZhiShiBiNum - 300
                    --laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + 30000
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW)
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"成功兑换3万金币")
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"您的芝士币不足兑换3万金币")
                end 
            elseif ItemID == 130004 then
                if laixia.LocalPlayercfg.ZhiShiBiNum >= 1000 then
                    laixia.LocalPlayercfg.ZhiShiBiNum = laixia.LocalPlayercfg.ZhiShiBiNum - 1000
                    --laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + 100000
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW)
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"成功兑换10万金币")
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"您的芝士币不足兑换10万金币")
                end 
            elseif ItemID == 130005 then
                if laixia.LocalPlayercfg.ZhiShiBiNum >= 2000 then
                    laixia.LocalPlayercfg.ZhiShiBiNum = laixia.LocalPlayercfg.ZhiShiBiNum - 2000
                   -- laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + 200000
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW)
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"成功兑换20万金币")
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"您的芝士币不足兑换20万金币")
                end 
            elseif ItemID == 130006 then
                if laixia.LocalPlayercfg.ZhiShiBiNum >= 3000 then
                    laixia.LocalPlayercfg.ZhiShiBiNum = laixia.LocalPlayercfg.ZhiShiBiNum - 3000
                    --laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + 300000
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW)
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"成功兑换30万金币")
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"您的芝士币不足兑换30万金币")
                end 
            end
        else
            if device.platform == "android" then
                if tostring(laixia.LocalPlayercfg.CHANNELID) == "160186" then
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_PAY_WINDOW,{orderID=orderID,ItemID=ItemID})
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_PAY_WINDOW,{orderID=orderID,ItemID=ItemID})
                end
                return
            elseif device.platform == "ios" then
                if  tostring(laixia.LocalPlayercfg.CHANNELID) == "500026" then--苹果官网
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_PAY_TOFUN,{orderID=orderID,ItemID=ItemID})
                elseif tostring(laixia.LocalPlayercfg.CHANNELID) == "111267" then
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_PAY_WINDOW,{orderID=orderID,ItemID=ItemID})
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_PAY_WINDOW,{orderID=orderID,ItemID=ItemID})
                end
                return
            else
                print("------other targetPlatform")
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_PAY_WINDOW,{orderID=orderID,ItemID=ItemID})
            end
        end
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"您有订单还在处理中") 
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_RequestOrderID,
        name = "SCRequestOrder",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态
            { "OrderID", Type.UTF8 },
            { "ItemID",Type.Int},
            { "business", Type.UTF8 },
            { "corpType", Type.Byte },
            { "appType", Type.UTF8 },
            { "orderAmt", Type.Int },
            { "paymentTag", Type.Byte },
            { "returnURL", Type.UTF8 },
            { "sign", Type.UTF8 },

        },
        HandlerFunction = handlerFunction,

    }