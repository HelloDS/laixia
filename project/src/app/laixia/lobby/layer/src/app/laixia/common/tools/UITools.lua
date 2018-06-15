--region NewFile_1.lua

local strsplit = string.split;

local uiTools = {}
-- 添加头像
--base:目标容器
--pngContent：头像图片
--pngTemplet：抠像模版
function uiTools.addHead(base, pngContent, pngTemplet,offset)

    if (base == nil) then
        return
    end

    local test = cc.Sprite:create(pngContent)
    if(test == nil)then
        cc.FileUtils:getInstance():removeFile(pngContent);
        return
    end

    local test2 = cc.Sprite:create(pngTemplet)
    if(test2 == nil)then
        return
    end

    offset = offset or 0;


    -- 创建模版头像
    local head = cpp_create_clipping_node(pngContent, pngTemplet)
    head:addTo(base)

    local size  = head:getContentSize()
    -- 缩放头像比例到按钮大小
    local templet = display.newSprite(pngTemplet) --模板
    local templet_size = templet:getContentSize()
    local head_btn_size = base:getContentSize() --头像框尺寸

    local headSpr = display.newSprite(pngContent)
    local head_size = headSpr:getContentSize() --头像尺寸
    local sw = ((head_btn_size.width - offset)/templet_size.width)
    local sh = ((head_btn_size.height - offset)/templet_size.height)
    head:setScale(sw , sh )

    -- 设置头像在按钮中居中
    head:setPosition(head_btn_size.width/2, head_btn_size.height/2)


    return head;
end

--切成数组
function uiTools.Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

--根据金币数量返回最小的充值id
function uiTools.getIDByMinGold(num)
    if num and num>0 then
        --local mAllMallInfo = laixia.db.MallDataManager:getAllMallInfoByOneList()
        local db2 = laixia.JsonTxtData
        local itemDBM = db2:queryTable("items");
        local mAllMallInfo = db2:queryTable("shop"):queryAllMallInfoByOneList();
        sortFunc = function(a, b) return b.price > a.price end
        table.sort(mAllMallInfo, sortFunc)
        for k,v in ipairs(mAllMallInfo) do
            local itemsInfo = itemDBM:query("ItemID",v.itemsID);
            --laixia.db.ItemsDataManager:getItemByItemID(v.itemsID)
            --筛选掉不显示的商城数据
            if (not v.isShow or v.isShow==0)  and itemsInfo.PresentItemID1=='1001' and itemsInfo.BaseCount+itemsInfo.AddCount>=num then
                return v.itemsID
            end
        end
    end
    return nil
end
--用于解析静态数据把字符串解析成数字集合或字符串集合。str一行的集合数据，delimiter切分标记，needSplitInt需要解析数字集合的字段名集合，needSplitStr需要解析字符集合的字段名集合
function uiTools.stringSplit(str,delimiter,needSplitInt,needSplitStr)
    if not str or type(str) ~= "table" or not delimiter or (not needSplitInt and not needSplitStr) then
        return
    end
    for i,v in pairs(str) do
        if needSplitInt and table.indexof(needSplitInt,i,0) then
            local splitStr = string.split(v,delimiter)
            for ii,vv in pairs(splitStr) do
                splitStr[ii] = tonumber(vv)
            end
            str[i] = splitStr
        elseif needSplitStr and table.indexof(needSplitStr,i,0) then
            local splitStr = string.split(v,delimiter)
            str[i] = splitStr
        end
    end
    return str
end

function uiTools.stringSplitColor(str)
    local castMsg = str.BroadCastMsg
    local colorArr = str.Color
    if #colorArr <= 0 then
        colorArr[1] = {color1=255,color2=239,color3=192}
    end
    local paramArr = str.Param
    local msgArr = {}
    local msgColorArr = {}
    local key =1
    while true do
        local strKey = key - 1
        local innerStr = "{" .. strKey .."}"
        local tmpMsg = string.split(castMsg,innerStr)
        local tmpMsgLen = #tmpMsg
        if tmpMsgLen ==2 then
            table.insert(msgArr,tmpMsg[1])
            table.insert(msgColorArr,colorArr[1])
            if (paramArr[key]) then
                table.insert(msgArr,paramArr[key])
                if (colorArr[key +1]) then
                    table.insert(msgColorArr,colorArr[key +1])
                else
                    table.insert(msgColorArr,colorArr[#colorArr])
                end
            else
                table.insert(msgArr,"{" .. key .."}"..tmpMsg[2])
                table.insert(msgColorArr,colorArr[1])
                break
            end
            castMsg = tmpMsg[2]
        else
            table.insert(msgArr,castMsg)
            table.insert(msgColorArr,colorArr[1])
            break
        end
        key = key + 1
    end
    local data = {}
    data.BroadCastMsg = msgArr
    data.Color = msgColorArr
    return data
end

-- mail_mode配置文件中  不同颜色用“,”分割   颜色值用“|”分割
function uiTools.stringSplitColors(colorStr)
    local colorArr = {}
    local tmpColorArr = string.split(colorStr,",")
    if #tmpColorArr < 1 then
        -- 配置文件有错
        return nil
    end
    for i=1 , #tmpColorArr do
        local tmpColor = tmpColorArr[i]
        local colorValue = string.split(tmpColor,"|")
        if #colorValue ~= 3 then
            -- 配置文件有错
            return nil
        end
        local value = {}
        value.color1 = colorValue[1]
        value.color2 = colorValue[2]
        value.color3 = colorValue[3]
        table.insert(colorArr,value)
    end
    return colorArr
end

function uiTools.stringMathPattern(str,pattern)
    if pattern == nil then
        pattern = "[%a-zA-Z0-9_]"
    end
    local slen = string.len(str)
    local t = ""
    for s in string.gmatch(str,pattern) do
        t = t .. s
    end
    local tlen = string.len(t)
    if slen == tlen then
        return true ;
    else
        return false
    end
end

-- 某功能模块是否关闭
-- funcType：功能模块
-- isClose:true 关闭  false 开放
function uiTools.isFuncClose(funcType,funcArr)
    local isClose = false
    if funcArr then
        local temp = string.split(funcArr,",")
        for k,v in ipairs(temp) do
            if v == funcType then
                isClose = true
                break
            end
        end
    else
        isClose = true
    end
    return isClose
end

--显示唯一的空间，当前显示为单数
function uiTools.onShowOnly(index,nodeArray)

    if index > #nodeArray then
        return
    else
        for i,v in ipairs(nodeArray) do
            local n = i%2
            if (i == index  ) then
                v:show()
            elseif(i %2 == 0) then
                v:show()
            else
                v:hide()
            end

        end
        nodeArray[index+1]:hide()
    end
end

function uiTools.udpateSuperGiftIcon(btnSpGift)
--        btnSpGift:removeAllChildren()
--         btnSpGift:setOpacity(0)
--         local btnPointX,btnPointY = btnSpGift:getPosition()
--         local system = laixia.ani.CObjectAnimationManager;
--         local node

--         local funAction = cc.CallFunc:create(function()
--         node = system:playAnimationAt(btnSpGift,"ddz_shouchonglibao","Default Timeline",
--                                         function() end )
--                                         node:setPosition(cc.p(-3,2))
--         end)

--         local funAction1 = cc.CallFunc:create(function()
--                             node:setOpacity(0)
--                             btnSpGift:setOpacity(255)
--                             node:removeFromParent()
--                             end)

--           btnSpGift:runAction(
--            cc.Sequence:create(
--                funAction
-- --               ,cc.DelayTime:create(2.82),
-- --               funAction1
--            ))


end

return uiTools

