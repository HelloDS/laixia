local Type = import("...DataType")
local StatusCode = import("...StatusCode")

--所有创建房间的roomID 为50
local function onPacketSCAppleDismiss(packet)
    --     if StatusCode.new(packet.data.StatuID):isOK() == true  then
    local data = packet.data

    local index = 0
    for i=1,#data.AppleDissUserSet do
        if data.AppleDissUserSet[i].status == 0 then

            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_APPLYDISMISS_WINDOW)
            return
        end
    end
    if ui.AppleDismissLayer.mIsShow == false then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_APPLYDISMISS_WINDOW,{data = data})
    elseif ui.AppleDismissLayer.mIsShow == true then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_APPLYDISMISS_WINDOW,{data = data})
    end
    --     end
end

return
    {
        ID = _LAIXIA_PACKET_SC_AppleDismissID,
        name = "SCAppleDismiss",
        data_array =
        {
            --{"StatuID", Type.Short},
            {"AppleDissUserSet",Type.Array,Type.TypeArray.AppleDissUserSet},

        },
        HandlerFunction = onPacketSCAppleDismiss,
    }
