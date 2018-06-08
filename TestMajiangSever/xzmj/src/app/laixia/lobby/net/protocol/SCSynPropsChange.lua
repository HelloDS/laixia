local Type = import("..DataType")
local Dict = require("app.laixia.common.tools.Dict")

local function onSCSynPropsChangePacket(packet)


    local StatusID = packet:getValue("StatusID")
    local Items = packet:getValue("Items")

    for i, v in ipairs(Items) do
        local chushu = math.floor(v.ItemID/1000)
        local yushu  = v.ItemID % 1000
        if chushu == 8 and StatusID == 8 then
            table.remove(Items,i)
            Items.ItemID = v.ItemID
        end
        if v.ItemID==1001 then
            laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + v.ItemCount
        elseif v.ItemID==1002 then
            laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon + v.ItemCount
        elseif v.ItemObjectID==0 then
        else
            if laixia.LocalPlayercfg.LaixiaPropsData then
                local isHas=false
                for j, k in ipairs(laixia.LocalPlayercfg.LaixiaPropsData) do
                    if k.ItemObjectID == v.ItemObjectID then
                        isHas=true
                        k.ItemCount = v.ItemCount + k.ItemCount
                    end
                end

                if isHas==false then
                    table.insert(laixia.LocalPlayercfg.LaixiaPropsData,v)
                end
            end
        end

    end
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GETLAIDOU, Items)
    --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GAIN_WINDOW, Items)
    --发送牌桌更新金币和奖券消息
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATAGOLD)
end


local  SCSynPropsChange =
    {
        ID = _LAIXIA_PACKET_SC_SynPropsChangeID ,
        name = "SCSynPropsChange",
        data_array=
        {
            {"StatusID",    Type.Byte},        --原因
            {"Items",    Type.Array,Type.TypeArray.Items}  --道具
        },
        HandlerFunction = onSCSynPropsChangePacket,

    }

return SCSynPropsChange
