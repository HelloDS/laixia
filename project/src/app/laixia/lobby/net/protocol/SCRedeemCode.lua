local Type = import("..DataType")
local StatusCode = import("..StatusCode")
--兑换码兑换消息
local function onSCRedeemCodePacket(packet)
    local StatusID = packet:getValue("StatusID") --状态吗
    local Items = packet:getValue("Items")--道具
    local itemDMB = laixia.JsonTxtData:queryTable("items");

    if (StatusCode.new(StatusID):isOK() == true)and (Items ~= nil )and (#Items > 0 ) then
        local str = ""
        for i,v in ipairs(Items) do
            local Item = itemDMB:query("ItemID",Items[i].ItemID);
            if Item.ItemName == "金币" then
                laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold+Items[i].ItemCount
            elseif Item.ItemName == "奖券" then
                laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon+Items[i].ItemCount
            end
            if str=="" then
                str = "兑换成功，获得" .. Items[i].ItemCount .. Item.ItemName
            else
                str = str .. "," .. Items[i].ItemCount .. Item.ItemName
            end
        end

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_REDEEMGIFT_WINDOW)   --隐藏兑换码兑换窗口
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,str)
    end
end


local  SCRedeemCode =
    {
        ID = _LAIXIA_PACKET_SC_RedeemCodeID,
        name = "SCRedeemCode",
        data_array=
        {
            {"StatusID",    Type.Short}, --状态码
            {"Items",    Type.Array,Type.TypeArray.Items}
        },
        HandlerFunction = onSCRedeemCodePacket,

    }

return SCRedeemCode