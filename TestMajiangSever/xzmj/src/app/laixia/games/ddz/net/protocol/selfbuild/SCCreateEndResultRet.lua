
local Type = import("...DataType")
local function onPacketSCCreateEndResultRet(packet)


    local data = packet.data
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_APPLYDISMISS_WINDOW)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_SELFBUILDINGRESULT_WINDOW,data)

end

return
    {
        ID = _laixiaddz_PACKET_SC_CreateEndResultRetID,
        name = "SCCreateEndResultRet",
        data_array =
        {
            {"TableID",Type.Int},
            {"Jushu",Type.Int},--局数
            {"TableType",Type.Int},--对局类型
            {"Bureaus", Type.Array, Type.TypeArray.BureauEndInfo },--玩家胜负数据
        },
        HandlerFunction = onPacketSCCreateEndResultRet,
    }

--endregion
