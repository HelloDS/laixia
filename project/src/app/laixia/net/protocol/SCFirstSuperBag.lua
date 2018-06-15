local Type = import("..DataType")

local function onSCFirstSuperBagPacket(packet)
    local msg = packet.data
    if msg.StatusID ~= 0 then
        return
    end
    if msg.FirstBuy == 0 then
        laixia.LocalPlayercfg.isShouchong = true
    else
        laixia.LocalPlayercfg.isShouchong = false
    end
    -- if msg.FirstBuy > 0 then  -- 不该出现这种情况
    --     return
    -- else
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_RETURN_FIRSTGIFT_WINDOW)
    -- end
end

local SCFirstSuperBag =
    {
        ID = _LAIXIA_PACKET_SC_FirstSuperBagID,
        name = "SCFirstSuperBag",
        data_array =
        {
            { "StatusID", Type.Short },           -- 0 成功  1  失败
            { "FirstBuy", Type.Int },-- 0：今天未购买   >0 已购买    <0  订单处理中
            { "FirstSuperBag", Type.Int},
        },
        HandlerFunction = onSCFirstSuperBagPacket,
    }

return SCFirstSuperBag