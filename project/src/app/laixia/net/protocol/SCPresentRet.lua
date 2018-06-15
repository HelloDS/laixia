
local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onPacketPresentRet(packet)
    if StatusCode.new(packet.data.StatusID):isOK() then
        local items = packet:getValue("Items")

        for i, vw in ipairs( items) do
            for j, vn in ipairs( laixia.LocalPlayercfg.LaixiaPropsData) do
                if vw .ItemID == vn.ItemID then
                    laixia.LocalPlayercfg.LaixiaPropsData[j] = vw
                end
            end
        end

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"道具赠送成功！")
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_TOOLBOX_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_PRESENT_WINDOW)
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_PresentRetID,
        name = "SCPresentRet",
        data_array =
        {
            { "StatusID", Type.Short },     -- 状态码
            { "ItemID", Type.Int },         -- 物品id
            { "DoneeID", Type.Int },        -- 受赠人ID
            { "Time", Type.Int },           -- 时间
            { "Items", Type.Array, Type.TypeArray.Items } --物品列表
        },
        HandlerFunction = onPacketPresentRet,
    }


