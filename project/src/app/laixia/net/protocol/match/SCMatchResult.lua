
local Type = import("...DataType")

local function onPacketMatchResult(packet) -- 胜利结算
    local rank = packet:getValue("Rank")
    local data={}
    data.rank =  packet:getValue("Rank")
    data.rewards =packet:getValue("Rewards")
    data.roomID = packet:getValue("RoomID")
    data.GameType = packet:getValue("GameType")
    data.ISWin= true

    laixia.LocalPlayercfg.LaixiaMatchRoom= packet:getValue("RoomID")
    laixia.LocalPlayercfg.LaixiaIsInMatch = false

    local isHas = false
   
        if laixia.LocalPlayercfg.LaixiaPropsData then
            for k,v in ipairs(packet.data.Rewards) do
                 if v.ItemID==1001 then
                    laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + v.ItemCount
                elseif v.ItemID==1002 then
                    laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon + v.ItemCount
                elseif v.ItemObjectID==0 then
                else
                    if not v.ItemObjectID and v.ItemObjectID ~= 0 then
                        isHas=false
                        for j, k in  ipairs(laixia.LocalPlayercfg.LaixiaPropsData) do
                            if k.ItemObjectID == v.ItemObjectID then
                                isHas=true
                                k.ItemCount = v.ItemCount
                            end
                        end
                    end
                    if isHas==false then
                        table.insert(laixia.LocalPlayercfg.LaixiaPropsData,v)
                    end
                end
            end
        end
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHRESULT_WINDOW,data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchResultID,
        name = "SCMatchResult",
        data_array =
        {
            {"GameID",Type.Byte},
            {"RoomID",Type.Int},
            {"Rewards",Type.Array,Type.TypeArray.ResultItem},
            {"Rank",Type.Int},
            {"GameType",Type.Int},
        },
        HandlerFunction = onPacketMatchResult,
    }


