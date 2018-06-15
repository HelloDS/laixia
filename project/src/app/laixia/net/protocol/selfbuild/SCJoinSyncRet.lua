local Type = import("...DataType")

local function onPacketSCJoinSyncRet(packet)
    local data = packet.data
    laixia.LocalPlayercfg.LaixiaSelfBuildTable = data.TableID
    --    if ui.CardTableDialog.isHaveDiZHu == false  then
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SELFBUILDINGUI,data)
    --    end

end

return
    {
        ID = _LAIXIA_PACKET_SC_JoinSyncRetID,
        name = "SCJoinSyncRet",
        data_array =
        {
            {"TableID", Type.Int},
            {"Players", Type.Array, Type.TypeArray.SelfBuilPlayers},
        },
        HandlerFunction = onPacketSCJoinSyncRet,
    }
