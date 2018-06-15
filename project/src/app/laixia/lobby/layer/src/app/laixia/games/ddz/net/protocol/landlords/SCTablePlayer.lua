
local Type = import("...DataType")

local function RoomPlayerMsg(packet)

    local player = { }
    player.ID = packet:getValue("PlayerId")
    player.Name = packet:getValue("Name")
    player.gold = packet:getValue("Gold")
    player.maxwin = packet:getValue("MaxWinGold")
    player.SignStr = packet:getValue("SignStr")
    player.imgPath = packet:getValue("ImgPath")
    player.WinNum = packet:getValue("WinNum")
    player.LostNum = packet:getValue("LostNum")
    player.Level = packet:getValue("Level")
    player.Title = packet:getValue("Title")
    player.Sex = packet:getValue("Sex")
    player.bisaiWin = packet:getValue("bisaiWin")
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_USEINFO_WINDOW, player)
end

return
    {
        ID = _laixiaddz_PACKET_SC_TablePlayerID,
        -- 站内玩家信息,
        name = "CSTablePlayer",
        data_array =
        {
            { "PlayerId", Type.Int },-- 玩家id
            { "Level", Type.Int },-- 等级
            { "WinNum", Type.Int },-- 胜利次数
            { "LostNum", Type.Int },-- 失败场次
            { "MaxWinGold", Type.Int },
            { "Gold", Type.Double },
            { "Title", Type.UTF8 },-- 称号
            { "Name", Type.UTF8 },
            { "SignStr", Type.UTF8 },-- 个性签名
            { "ImgPath", Type.UTF8 },-- 头像路径
            { "Sex", Type.Int },-- 性别 0男  1女
            { "bisaiWin" , Type.Int},--比赛胜利次数(冠军次数)
            
        },
        HandlerFunction = RoomPlayerMsg,
    };

