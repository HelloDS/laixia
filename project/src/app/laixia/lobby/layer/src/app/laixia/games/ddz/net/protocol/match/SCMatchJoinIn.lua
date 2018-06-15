
local Type = import("...DataType")


local function onPacketMatchJoinIn(packet)
    print("SCMatchJoinIn");
    laixiaddz.LocalPlayercfg.laixiaddzGamePageType = packet:getValue("PageType")
    laixiaddz.LocalPlayercfg.laixiaddzMatchLastRoom = packet:getValue("RoomID")
    laixiaddz.LocalPlayercfg.laixiaddzMatchRoomType= 0 --定时赛开赛
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "ShopWindow" then --在商店界面不弹出 去比赛的弹窗

--        local Details = Packet.new("CGDetails", _laixiaddz_PACKET_CS_MatchDetailsID)
--        Details:setValue("GameID", laixiaddz.config.GameAppID)
--        Details:setValue("PageType", laixiaddz.LocalPlayercfg.laixiaddzGamePageType)
--        local roomID = 0
--        if laixiaddz.LocalPlayercfg.laixiaddzMatchRoom == nil then
--            roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
--        else
--            roomID = laixiaddz.LocalPlayercfg.laixiaddzMatchRoom
--        end
--        Details:setValue("RoomID", roomID)
--        laixiaddz.net.sendPacketAndWaiting(Details)
        
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_NOSHOW_MATCHJOIN_WINDOW,{data="ShopWindow"} )
    elseif laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzIsInMatch== true  then  --此时在比赛牌桌内
    
--       local Details = Packet.new("CGDetails", _laixiaddz_PACKET_CS_MatchDetailsID)
--        Details:setValue("GameID", laixiaddz.config.GameAppID)
--        Details:setValue("PageType", laixiaddz.LocalPlayercfg.laixiaddzGamePageType)
--        local roomID = 0
--        if laixiaddz.LocalPlayercfg.laixiaddzMatchRoom == nil then
--            roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
--        else
--            roomID = laixiaddz.LocalPlayercfg.laixiaddzMatchRoom
--        end
--        Details:setValue("RoomID", roomID)
--        laixiaddz.net.sendPacketAndWaiting(Details)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_NOSHOW_MATCHJOIN_WINDOW,{data="laixiaddzIsInMatch"} )
    elseif laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then  --此时在常规牌桌内
--       local Details = Packet.new("CGDetails", _laixiaddz_PACKET_CS_MatchDetailsID)
--        Details:setValue("GameID", laixiaddz.config.GameAppID)
--        Details:setValue("PageType", laixiaddz.LocalPlayercfg.laixiaddzGamePageType)
--        local roomID = 0
--        if laixiaddz.LocalPlayercfg.laixiaddzMatchRoom == nil then
--            roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
--        else
--            roomID = laixiaddz.LocalPlayercfg.laixiaddzMatchRoom
--        end
--        Details:setValue("RoomID", roomID)
--        laixiaddz.net.sendPacketAndWaiting(Details)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_NOSHOW_MATCHJOIN_WINDOW,{data="laixiaddzisConnectCardTable"} )
        --参加比赛点击参加时强制把比赛详情页面中的比赛进行退赛处理
    -- elseif  laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "lhd_main_window" then 
    --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DRAGON_QUIT_TABLE)
    -- elseif   laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "GameListWindow" and   laixiaddz.LocalPlayercfg.laixiaddzisMatchDetail == true  then 
    --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_WITHDRAW_MATCHJOIN_WINDOW)
    --    -- return  
    else
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHJOIN_WINDOW,{TEXT=packet:getValue("Mesg"),RDS =packet:getValue("Rds")} )
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchJoinInID ,
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