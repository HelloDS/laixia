local db2 = import(".data");
local laixiaddzTools = laixiaddz.UItools;
local stringSplit = laixiaddzTools.stringSplit;
local stringSplitColor = laixiaddzTools.stringSplitColor;
local colorSplitGroups = laixiaddzTools.stringSplitColors;

--超级礼包
local access_mall = {
    --根据ID查询mall数据
    queryMallInfoByID = function (dt,ID)
        if(dt.buf ~= nil )then
            for _,v in ipairs(dt.buf) do
                if v["itemsID"] == ID then
                    local result = {};
                    result["isShow"] = v["isShow"]
                    result["itemsID"] = v["itemsID"]
                    result["price"] = v["Price"]
                    result["cost"] = v["cost"]
                    return result;
                end
            end
        end
        return nil
    end,
    --查询所有mall数据
    queryAllMallInfoByOneList = function (dt)
        local resultList = {}
        if(dt.buf ~= nil )then
            for _,v in ipairs(dt.buf) do
                local result = {}
                result["isShow"] = v["isShow"]
                result["itemsID"] = v["itemsID"]
                result["Price"] = v["Price"]
                result["BeginTime"] = v["BeginTime"]
                result["EndTime"] = v["EndTime"]
                result["ShopDesc"] = v["ShopDesc"]
                result["cost"] = v["cost"]
                result["price"] = v["price"]
                table.insert(resultList,result)
            end
        end
        return resultList
    end
}


--广播消息
local broadcastInfo = {
    queryMessageByID = function (dt,noticeID,Param)
        if(dt.buf ~= nil )then
            local noticeIDN = tonumber(noticeID)
            for _,v in ipairs(dt.buf) do
                --                local tableId = tostring(v["id"])
                --                local noticeID = ID
                if(v["id"] == noticeIDN) then
                    local colorArr = colorSplitGroups(v.color)
                    local msgStr = {}
                    msgStr.BroadCastMsg = v.mode
                    msgStr.Color = colorArr
                    msgStr.Param = Param
                    local msgArr = stringSplitColor(msgStr)
                    msgArr.show = v.show
                    return msgArr
                end
            end
        end
        return nil
    end,
}

--礼品界面
local access_synthesis = {
    getSynthesisByItemID = function(dt,itemID)
        local temp = {}
        if(dt.buf ~= nil )then
            for _,v in ipairs(dt.buf) do
                local str = string.split(v.ItemID,"|")
                for k,value in ipairs(str) do
                    if temp[value]==nil then
                        temp[value] = v.SynthesisId
                    elseif temp[value]~="-1" then
                        temp[value] = "-1"
                    end
                end
            end
        end
        if temp[tostring(itemID)] and temp[tostring(itemID)] > 0 then
            for _,v in ipairs(dt.buf) do
                if v.SynthesisId == temp[tostring(itemID)] then
                    local res = {}
                    res.SynthesisId = v.SynthesisId
                    res.ItemID = string.split(v.ItemID,"|")
                    res.PartNum = string.split(v.Num,"|")
                    return res
                end
            end
        end
        return nil
    end,
}

local itemsLoad = function(path)
    local buf = db2.textLoader(path);
    local ret_buf = {};
    for i,v in ipairs(buf) do
        ret_buf[i] = laixiaddz.UItools.stringSplit(v,"|",{"PresentItemID2","Length"},nil)
    end
    return ret_buf;
end

function db2:onInit()
    print("db2:onInit start");
    self:load{
        {"window","games/ddz/data/uiConfigure.json"},
    }

    self.resLoader_t = {
        {"items","games/ddz/data/items.txt",itemsLoad},
        {"shop","games/ddz/data/shop.json",nil,access_mall,},
        {"mail_mode","games/ddz/data/mail_mode.json",nil,broadcastInfo,},
        {"gameInstruction","games/ddz/data/gameInstruction.json"},
        {"room_list","games/ddz/data/room_list.json"},

        {"common","games/ddz/data/common.json"},
        {"synthesis","games/ddz/data/synthesis.json",nil,access_synthesis,},
        {"gradeArray","games/ddz/data/gradeArray.json"},
        {"vipGrade","games/ddz/data/vipGrade.json"},
    };
end

return db2;
