local Type = import("..DataType")

local function onSCShopPacket(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW,packet.data)
end

local SCShop =
    {
        name = "SCShop",
        ID = _LAIXIA_PACKET_SC_ShopID,
        data_array =
        {
            { "Items", Type.Array, Type.TypeArray.ShopItems },
            { "LastModifyTm", Type.Double },-- 最后修改时间
        },
        HandlerFunction = onSCShopPacket,
    }

return SCShop