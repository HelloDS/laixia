local Type = import("...DataType")

local function onPacketSCJoinSyncRet(packet)
    local data = packet.data
    laixiaddz.LocalPlayercfg.laixiaddzSelfBuildTable = data.TableID
    --    if ui.CardTableDialog.isHaveDiZHu == false  then
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SELFBUILDINGUI,data)
    --    end

end

return
    {
        ID = _laixiaddz_PACKET_SC_JoinSyncRetID,
        name = "SCJoinSyncRet",
        data_array =
        {
            {"TableID", Type.Int},
            {"Players", Type.Array, Type.TypeArray.SelfBuilPlayers},
        },
        HandlerFunction = onPacketSCJoinSyncRet,
    }
