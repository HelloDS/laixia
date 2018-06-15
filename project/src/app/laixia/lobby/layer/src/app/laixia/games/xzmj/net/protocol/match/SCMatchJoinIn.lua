
local Type = import("...DataType")


local function onPacketMatchJoinIn(packet)
    print("SCMatchJoinIn");
    laixia.LocalPlayercfg.LaixiaGamePageType = packet:getValue("PageType")
    laixia.LocalPlayercfg.LaixiaMatchLastRoom = packet:getValue("RoomID")
    laixia.LocalPlayercfg.LaixiaMatchRoomType= 0 --定时赛开赛
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "ShopWindow" then --在商店界面不弹出 去比赛的弹窗

--        local Details = Packet.new("CGDetails", _LAIXIA_PACKET_CS_MatchDetailsID)
--        Details:setValue("GameID", laixia.config.GameAppID)
--        Details:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
--        local roomID = 0
--        if laixia.LocalPlayercfg.LaixiaMatchRoom == nil then
--            roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
--        else
--            roomID = laixia.LocalPlayercfg.LaixiaMatchRoom
--        end
--        Details:setValue("RoomID", roomID)
--        laixia.net.sendPacketAndWaiting(Details)
        
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_NOSHOW_MATCHJOIN_WINDOW,{data="ShopWindow"} )
    elseif laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaIsInMatch== true  then  --此时在比赛牌桌内
    
--       local Details = Packet.new("CGDetails", _LAIXIA_PACKET_CS_MatchDetailsID)
--        Details:setValue("GameID", laixia.config.GameAppID)
--        Details:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
--        local roomID = 0
--        if laixia.LocalPlayercfg.LaixiaMatchRoom == nil then
--            roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
--        else
--            roomID = laixia.LocalPlayercfg.LaixiaMatchRoom
--        end
--        Details:setValue("RoomID", roomID)
--        laixia.net.sendPacketAndWaiting(Details)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_NOSHOW_MATCHJOIN_WINDOW,{data="LaixiaIsInMatch"} )
    elseif laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then  --此时在常规牌桌内
--       local Details = Packet.new("CGDetails", _LAIXIA_PACKET_CS_MatchDetailsID)
--        Details:setValue("GameID", laixia.config.GameAppID)
--        Details:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
--        local roomID = 0
--        if laixia.LocalPlayercfg.LaixiaMatchRoom == nil then
--            roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
--        else
--            roomID = laixia.LocalPlayercfg.LaixiaMatchRoom
--        end
--        Details:setValue("RoomID", roomID)
--        laixia.net.sendPacketAndWaiting(Details)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_NOSHOW_MATCHJOIN_WINDOW,{data="LaixiaisConnectCardTable"} )
        --参加比赛点击参加时强制把比赛详情页面中的比赛进行退赛处理
    -- elseif  laixia.LocalPlayercfg.LaixiaCurrentWindow == "lhd_main_window" then 
    --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_QUIT_TABLE)
    -- elseif   laixia.LocalPlayercfg.LaixiaCurrentWindow == "GameListWindow" and   laixia.LocalPlayercfg.LaixiaisMatchDetail == true  then 
    --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WITHDRAW_MATCHJOIN_WINDOW)
    --    -- return  
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHJOIN_WINDOW,{TEXT=packet:getValue("Mesg"),RDS =packet:getValue("Rds")} )
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchJoinInID ,
        name = "SCMatchJoinIn",
        data_array =
        {
            { "GameID", Type.Byte },
            { "RoomID", Type.Int },
            { "PageType", Type.Byte }, --页签类型
            { "Mesg", Type.UTF8 },
            { "Rds", Type.Array,Type.TypeArray.Rds},-- 参加比赛第一名奖励
        },

        HandlerFunction = onPacketMatchJoinIn,
    }