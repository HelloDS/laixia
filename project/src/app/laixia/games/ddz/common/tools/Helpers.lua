


--工具函数
--判断一个表是否为空

local xDict = import(".Dict");

local MAX_NUM1 = 100000000; -- 1亿
local MAX_NUM2 = 10000;

local Helper = {};

function isTableEmpty(t)
    if(t == nil) then
        return true
    else
        return next(t) == nil
    end
end

function isTableNotEmpty(t)
    return not isTableEmpty(t)
end


--rule1 添加 "," 分割数字现
function Helper.numeralRules_1(number)

    local str = ""
    local num = number
    local temp = tostring(num)
    while num > 0   do
        if string.len(temp)> 3 then
            local ren = string.sub(temp,-3)
            num = tonumber(string.sub(temp,0,-4))
            temp = tostring(num)
            str = ren..","..str
        elseif string.len(temp)>= 1 then
            str = temp..","..str
            num = 0
        else
            num = 0
        end
    end
    str = string.sub(str,0,-2)
    return  str
end

--run2 取整数显示最高级别，亿，万为单位
function Helper.numeralRules_2(num)
    local retStrNumber;

    if(num < MAX_NUM2)then
        retStrNumber = tostring(num);
    elseif(num >=MAX_NUM2 and num <MAX_NUM1)then
        retStrNumber =  tonumber(string.sub(tostring(num / MAX_NUM2),1,5))..xDict.DICT(_ID_DICT_TYPE_TEN_THOUSAND);
    --retStrNumber = tostring(math.floor(num /MAX_NUM2))..xDict.DICT(_ID_DICT_TYPE_TEN_THOUSAND);
    elseif(num >= MAX_NUM1) then
        retStrNumber = tonumber(string.sub(tostring(num / MAX_NUM1),1,5))..xDict.DICT(_ID_DICT_TYPE_HUNDRED_MILLION);
    --retStrNumber = tostring(math.floor(num /MAX_NUM2))..xDict.DICT(_ID_DICT_TYPE_HUNDRED_MILLION);
    else
        error("not implement");
    end
    return retStrNumber;
end
function Helper.ConvertStrToNum(str)
    if tonumber(str)~=nil then
        return str
    end
    local len = string.len(str)
    local result = 0
    local tempStr = string.sub(str,len-2)
    local tempNum = string.sub(str,0,len-3)
    if tempStr == "万" then
        result = tempNum*10000
    elseif tempStr == "亿" then
        result = tempNum * 10000000
    else
       result = tempNum 
    end
    return result
end



function Helper.numeralRules_5(num)

    num = num or 0
    if(num >= MAX_NUM1) then
        return string.format("%g",num /MAX_NUM1)..xDict.DICT(_ID_DICT_TYPE_HUNDRED_MILLION);
    elseif(num == MAX_NUM1)then
    --return tostring(num)..xDict.DICT(_ID_DICT_TYPE_HUNDRED_MILLION);
    elseif(num >= (MAX_NUM2*100)) then
        local a = string.format("%g",num /MAX_NUM2)..xDict.DICT(_ID_DICT_TYPE_TEN_THOUSAND)
        return string.format("%g",num /MAX_NUM2)..xDict.DICT(_ID_DICT_TYPE_TEN_THOUSAND);
    --    elseif(num ==MAX_NUM2) then
    --        return tostring(num)..xDict.DICT(_ID_DICT_TYPE_TEN_THOUSAND);
    else
        return tostring(num);
    end
    return nil
end

function Helper.StringRules_6(str)
    local len = string.utf8len2( str)
    local ResultStr=""
    if len>8 then
        ResultStr = string.subUtf8Str(str,8).."..."
    else
        ResultStr = str
    end
    return ResultStr
end

function Helper.popupReLoginWindow(msginfo,msgTypeinfo)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDJUMP_WINDOW,{msg = msginfo,msgType = msgTypeinfo})

end

function Helper.failedLoadSubApp()
    laixiaddz.helper.popupReLoginWindow(laixia.utilscfg.DICT(_ID_DICT_TYPE_CONNECT_TIMEOUT), "http")
end

return Helper ;
--endregion
