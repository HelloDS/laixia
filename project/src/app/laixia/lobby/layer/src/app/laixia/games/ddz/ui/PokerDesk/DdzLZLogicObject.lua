
--- 癞-子-牌的-表-达-式服-务-器-给过-来-的-一-个0-12的-数-字，
---因-此-所-有-的癞-子-牌-判断-都-是-根-据这--个-值--癞子牌的标号是 laizipoker
local CardType = import("..uiData.PokerType");
local DdzLZLogicObject = class("DdzLZLogicObject", function()
    return { }
end )


-- 查-找-牌-中-各种-牌-的-个-数
function DdzLZLogicObject:analyzeAirplaneFunc(aiOutPokersIndex)
    local l_ct = {
        single = { },-- 单-张
        duble = { },-- 对
        three = { },-- 三张
        four = { }-- 四张
    }
    local l_ChupaiOrder = aiOutPokersIndex
    local lengh = #l_ChupaiOrder

    for index = 1, lengh do
        if l_ChupaiOrder[index].num == 1 then
            table.insert(l_ct.single, l_ChupaiOrder[index])
        elseif l_ChupaiOrder[index].num == 2 then
            table.insert(l_ct.duble, l_ChupaiOrder[index])
        elseif l_ChupaiOrder[index].num == 3 then
            table.insert(l_ct.three, l_ChupaiOrder[index])
        elseif l_ChupaiOrder[index].num == 4 then
            table.insert(l_ct.four, l_ChupaiOrder[index])
        end
    end
    return l_ct
end


-- 判-定-是-否-是-三-代-二-，-如-果-牌数-不-是-五-，则-返-回-false
function DdzLZLogicObject:LZIsThreeTwoCardFunction(tCardType, lengh, laiziNum)

    if lengh ~= 5 then
        return false
    end

    for i=1,#tCardType.single do
        if tCardType.single[i].card_NO>12  then
           return false
        end
    end

    if #tCardType.three == 1 and #tCardType.duble == 1 then
        -- 两张癞子和三张癞子的情况
        return true
    end
    if #tCardType.duble == 2 and (laiziNum == 1 or laiziNum == 2 ) then  
        return  true
    end

    if #tCardType.three == 1 and laiziNum == 1 then
        -- 三张普通牌和一张单牌一张癞子牌
        return true
    end

    if #tCardType.four == 1 and laiziNum >= 1  then
        -- 4癞子和单牌,或者一张癞子和炸弹
        return true -- 改为false 则屏蔽炸弹带一张的情况
    end
    return false
end

-- 判-断-是-不-是-癞-子-的-连-对
function DdzLZLogicObject:LZIsLaiziDoubleListFunction(aiOutPokersIndex, laiziNum)
    local l_ChupaiOrder = aiOutPokersIndex
    local lengh = #l_ChupaiOrder
      
   for k3 = 1, lengh do
        if l_ChupaiOrder[k3].is_Laizigou == true then
            local temp = l_ChupaiOrder[lengh]
            l_ChupaiOrder[lengh] = l_ChupaiOrder[k3]
            l_ChupaiOrder[k3] = temp
            break
        end
    end

    for i = 1, lengh-1 do--因为必定有癞子，所以此时必须考虑癞子
        for n = 1, lengh - 2 do
            if l_ChupaiOrder[n].card_NO > l_ChupaiOrder[n + 1].card_NO then
                local temp = l_ChupaiOrder[n]
                l_ChupaiOrder[n] = l_ChupaiOrder[n + 1]
                l_ChupaiOrder[n + 1] = temp
            end
        end
    end


    for i = 1, lengh do
        if l_ChupaiOrder[i].card_NO == 12 and l_ChupaiOrder[i].is_Laizigou == false then
            -- 如果有2且不是癞子牌则不是连对
            return false
        end
    end
    local pokerNum = 0
    for index = 1, #l_ChupaiOrder do
        pokerNum = pokerNum + l_ChupaiOrder[index].num
    end

    if pokerNum % 2 ~= 0 then
        -- 不能被2整除的情况排除
        return false
    end

    local numDoubleList = 0
    -- 凑成对需要的牌数
    local max = 0
    local min = 0
    local num = 0

    for index = lengh-1, 1, -1 do
        if l_ChupaiOrder[index].is_Laizigou == false then
            if (l_ChupaiOrder[index].num > 2) then
                -- 非癞子牌，有大于两张的情况就直接排除
                return false
            elseif (l_ChupaiOrder[index].num < 2) then
                numDoubleList = numDoubleList + 2 - l_ChupaiOrder[index].num
                -- 计算凑成对需要的牌数
            end

            if max == 0 then
                max = l_ChupaiOrder[index].card_NO
            else
                min = l_ChupaiOrder[index].card_NO

                if min >= 0 and(max - 1 - min) > 0 then
                    num = num + max - 1 - min
                end
                max = min
            end

        end
    end

    if (numDoubleList == laiziNum or numDoubleList == 0 or (laiziNum - numDoubleList)%2==0) and(num * 2 <= laiziNum - numDoubleList) then
        -- 如果需要凑成对的牌数等于癞子或者等于0个数并且，凑成顺子的牌数（差值在2以内）乘以二小于等于剩余的癞子个数
        return true
    else
        return false
    end
end

-- 判-断-是-不-是-癞-子-顺-子
function DdzLZLogicObject:LZIsLaiziListFunction(aiOutPokersIndex, laiziNum)
    local l_ChupaiOrder = aiOutPokersIndex
    local lengh = 0
    local num = #l_ChupaiOrder
    for i = 1, num  do
        lengh = lengh + l_ChupaiOrder[i].num
        if l_ChupaiOrder[i].num >1 and l_ChupaiOrder[i].is_Laizigou==false then  --如果多张中不是癞子则排除
           return false
        end
    end
    
    if lengh < 5 then
        -- 小于5张不是顺子
        return false
    end

    for k3 = 1, num do
        if l_ChupaiOrder[k3].is_Laizigou == true then  -- 把癞子排在最后
            local temp = l_ChupaiOrder[num]
            l_ChupaiOrder[num] = l_ChupaiOrder[k3]
            l_ChupaiOrder[k3] = temp
            break
        end
    end

    for k1 = 1, num - 1 do
        for k2 = 1, num - 2 do
            if l_ChupaiOrder[k2].card_NO > l_ChupaiOrder[k2 + 1].card_NO then
                local temp = l_ChupaiOrder[k2]
                l_ChupaiOrder[k2] = l_ChupaiOrder[k2 + 1]
                l_ChupaiOrder[k2 + 1] = temp
            end
        end
    end
    
    if l_ChupaiOrder[num -1].card_NO == 12 and l_ChupaiOrder[num-1].is_Laizigou == false then
        -- 如果有2且不是癞子牌则不是顺子
        return false
    end
    local max = 0
    local min = -1
    local mnum = 0

    for index = num-1 , 1, -1 do
        if l_ChupaiOrder[index].is_Laizigou == false then
            if max == 0 then
                max = l_ChupaiOrder[index].card_NO
            else
                min = l_ChupaiOrder[index].card_NO

                if min >= 0 and(max - 1 - min) > 0 then
                    mnum = mnum + max - 1 - min
                end
                max = min
            end

        end
    end

    if min == -1 then
        -- 仅有一张牌的情况
        if laiziNum == 4 then
            return true
        else
            return false
        end
    end

    return mnum <= laiziNum
    -- 单顺子的判断是，当前牌值的差刚好小于等于癞子个数
end

-- 判-断-是-不是-四-带-两张-单-牌
function DdzLZLogicObject:LZIsFourTwoCard(tCardType, lengh, laiziNum)
    if lengh ~= 6 then
        return false
    end

    if #tCardType.four == 1 and #tCardType.duble == 1 then
        -- 四带一对
        return true
    end

    if #tCardType.four == 1 and #tCardType.single == 2 then
        -- 四带两张单
        return true
    end

    if #tCardType.three == 2 and laiziNum == 3 then
        -- 三张癞子三张普通牌
        return true
    end

    if #tCardType.three == 1 then
        if #tCardType.single == 3 and laiziNum == 1 then
            -- 三张加两张单牌加一张癞子
            return true
        end

        if #tCardType.duble == 1 and laiziNum == 2 then
            -- 三张加两张癞子加一张单牌
            return true
        end
       if #tCardType.duble == 1 and laiziNum == 1 then
            -- 三张加两张加一张癞子
            return true
        end
    end

    if #tCardType.duble == 3 and laiziNum == 2 then
        -- 两个对加一对癞子
        return true
    end

    if #tCardType.duble == 2 and laiziNum == 2 then
        -- 一个对加一对癞子加两张单牌
        return true
    end

    if #tCardType.duble == 1 and laiziNum >= 3 then
        -- 一个对加四个癞子，或者一个对加三个癞子一张单牌
        return true
    end

    if #tCardType.single == 3 and laiziNum ==3 then
            -- 三张加两张单牌加一张癞子
            return true
    end
    return false

end

-- 对-牌-按-牌值-进-行-排序-,把-癞-子牌-排-最-大,
---这-样在-计-算-剩余-牌-数-的-时-候，不-用-考-虑-癞-子-牌-影-响
function DdzLZLogicObject:LZSortAllCardFunction(aiOutPokersIndex)
    local l_ChupaiOrder = aiOutPokersIndex

    for i = 1, #l_ChupaiOrder do
        if l_ChupaiOrder[i].is_Laizigou == true then
            local temp = l_ChupaiOrder[i]
            l_ChupaiOrder[i] = l_ChupaiOrder[#l_ChupaiOrder]
            l_ChupaiOrder[#l_ChupaiOrder] = temp
        end
    end


    for i = 1, #l_ChupaiOrder - 1 do
        for j = 1, #l_ChupaiOrder - i - 1 do
            if l_ChupaiOrder[j].card_NO > l_ChupaiOrder[j + 1].card_NO then
                local temp = l_ChupaiOrder[j];
                l_ChupaiOrder[j] = l_ChupaiOrder[j + 1]
                l_ChupaiOrder[j + 1] = temp
            end
        end
    end
    return l_ChupaiOrder
end

-- 判-断-是-不-是四-带-两-个-对
function DdzLZLogicObject:LZIsFourTwoDoubleCardFunction(tCardType, lengh, laiziNum)

    if lengh ~= 8 then
        return false
    end
    for i=1,#tCardType.single do
        if tCardType.single[i].card_NO>12  then
           return false
        end
    end

    if #tCardType.four == 2 then
        -- 两个四
        return true
    end

    if #tCardType.four == 1 then
        if #tCardType.duble == 2 then
            -- 四带俩对
            return true
        end

        if #tCardType.duble == 1 and laiziNum <= 2 then
            -- 四带一对加一张单牌和一张癞子&一对癞子加两张单牌
            return true
        end

        if #tCardType.three == 1 and laiziNum >=1 then
            -- 四带一张单牌和三张癞子,或者一张癞子
            return true
        end
    end

    if #tCardType.three == 2 and laiziNum == 3  then
        -- 三张加三张癞子
        if #tCardType.single ==2 and tCardType.single[1].card_NO <=12 and tCardType.single[2].card_NO <=12 then
            return true
        end
        if #tCardType.duble == 1 and tCardType.duble[1].card_NO <=12  then
           return true
        end
    end

    if #tCardType.three == 1 then
        if #tCardType.duble == 2 and laiziNum <= 2 then
            -- 三张加两个对和一张癞子&--三张加上一个对和两张癞子
            return true
        end

        if #tCardType.four == 4 and laiziNum == 4 then
            -- 三张带四癞子
            return true
        end
    end

    if #tCardType.duble == 4 and laiziNum == 2 then
        -- 四个对，有俩癞子
        return true
    end

    if #tCardType.duble == 2 and laiziNum >= 3 then
        -- 两个对加三癞子加一张单牌&两个对加四癞子
        return true
    end

    if #tCardType.duble == 1 and laiziNum == 4 then
        -- 一个对加四癞子加俩单牌
        return true
    end

    return false
end

-- 飞-机-带-单-或-者-带-对
-- @l_ChupaiOrder  排序后的牌，按牌值排序
-- @lengh  总牌数
-- @laiziNum  癞子牌个数
-- @beishu  飞机带单和带对的标记，如果beishu == 1 则表示带单，beishu == 2 则表示带对
function DdzLZLogicObject:LZLaiziAircraftSingleCardFunction(l_ChupaiOrder, lengh, laiziNum, beishu)

    if lengh %(3 + beishu) ~= 0 or lengh < 6  then
        return false
    end

    local laiziPlane = lengh /(3 + beishu)
    local num = #l_ChupaiOrder
    local airArray = { }

    for k3 = 1, num do
        if l_ChupaiOrder[k3].is_Laizigou == true then
            local temp = l_ChupaiOrder[num]
            l_ChupaiOrder[num] = l_ChupaiOrder[k3]
            l_ChupaiOrder[k3] = temp
            break
        end
    end

    for k1 = 1, num - 1 do --对除癞子牌进行排序
        for k2 = 1, num - 2 do
            if l_ChupaiOrder[k2].card_NO > l_ChupaiOrder[k2 + 1].card_NO then
                local temp = l_ChupaiOrder[k2]
                l_ChupaiOrder[k2] = l_ChupaiOrder[k2 + 1]
                l_ChupaiOrder[k2 + 1] = temp
            end
        end
    end

    for i = num - 1, 1, -1 do

        local mout = clone(l_ChupaiOrder)
        local mlaiziPlane = laiziPlane
        local laizi_num = laiziNum

        for j = i, 1, -1 do
            if mout[j].is_Laizigou == false and mout[j].num > 0 and mout[j].card_NO< 12 then  -- 如果是非癞子牌则凑成飞机需要的牌数
                if  mout[j].num <=3 then
                    laizi_num = laizi_num -(3 - mout[j].num)
                end
                
                mlaiziPlane = mlaiziPlane - 1

                if mlaiziPlane < 0 or laizi_num < 0 then
                    break
                end

                table.insert(airArray, mout[j])
                mout[j].num = -1
                mout[num].num = laizi_num
                if mlaiziPlane == 0 and laizi_num >= 0 then
                    if (beishu * laiziPlane) ==(lengh - laiziPlane * 3) then
                        if beishu == 2 then
                            local doubleNum = laiziPlane
                            -- 对余牌进行配对

                            for bei1 = 1, num do
                                if mout[bei1].num == 1 then
                                    doubleNum = doubleNum - 1
                                    laizi_num = laizi_num - 1
                                     mout[bei1].num =mout[bei1].num-1
                                     mout[num].num = mout[num].num-1
                                elseif mout[bei1].num == 2 then
                                    doubleNum = doubleNum - 1
                                    mout[bei1].num =mout[bei1].num-2
                                elseif mout[bei1].num == 3 then
                                    doubleNum = doubleNum - 2
                                    laizi_num = laizi_num - 1
                                    mout[bei1].num =mout[bei1].num-1
                                elseif mout[bei1].num == 4 then
                                    doubleNum = doubleNum - 2
                                    mout[bei1].num =mout[bei1].num-1
                                end
                            end

                            if doubleNum == 0 and laizi_num == 0 then
                                return true
                            else
                                break
                            end
                        end
                        return true
                    else
                        break
                    end

                end

                if j >= 2 and mout[j].card_NO - 1 ~= mout[j - 1].card_NO then  --凑成相连的牌
                    laizi_num = laizi_num - 3
                    mlaiziPlane = mlaiziPlane - 1

                    if mlaiziPlane < 0 or laizi_num < 0 then
                        break
                    end

                    table.insert(airArray, mout[j])
                    mout[j].num = -1
                    mout[num].num = laizi_num
                    if mlaiziPlane == 0 and laizi_num >= 0 then
                        if (beishu * laiziPlane) ==(lengh - laiziPlane * 3) then
                            if beishu == 2 then
                                local doubleNum = laiziPlane
                                -- 对余牌进行配对
                                for bei1 = 1, num do
                                    if mout[bei1].num == 1 then
                                        doubleNum = doubleNum - 1
                                        laizi_num = laizi_num - 1
                                     mout[bei1].num =mout[bei1].num-1
                                     mout[num].num = mout[num].num-1
                                    elseif mout[bei1].num == 2 then
                                        doubleNum = doubleNum - 1
                                        mout[bei1].num =mout[bei1].num-2
                                    elseif mout[bei1].num == 3 then
                                        doubleNum = doubleNum - 2
                                        laizi_num = laizi_num - 1
                                        mout[bei1].num =mout[bei1].num-2
                                    elseif mout[bei1].num == 4 then
                                        doubleNum = doubleNum - 2
                                        mout[bei1].num =mout[bei1].num-2
                                    end
                                end

                                if doubleNum == 0 and laizi_num == 0 then
                                    return true
                                else
                                    break
                                end
                            end                            
                            return true
                        else
                            break
                        end

                    end
                end

            end
           if laizi_num >= 3 and mlaiziPlane ==1  then  -- 当飞机牌中有癞子牌本身时，考虑四张癞子的情况，三张癞子可以满足，当为四张的时候也要考虑进去
                return true
           end 
        end

    end
    return false

end

-- 飞机不带--用的方案是补齐--前面方法用的是排除--测试时候在查看那个方法好
-- @l_ChupaiOrder  排序后的牌
-- @lengh  总牌数
-- @laiziNum  癞子牌个数
function DdzLZLogicObject:LZLaiziAircraftCardFunction(moutPokersIndex, lengh, laiziNum)

    if lengh % 3 ~= 0 or lengh < 6  then
        return false
    end
   local  l_ChupaiOrder = clone(moutPokersIndex)
    -- 按照拍面值进行排序
    local num = #l_ChupaiOrder

    for i = 1, num do  --对牌值排序
        for n = 1, num - 1 do
            if l_ChupaiOrder[n].card_NO > l_ChupaiOrder[n + 1].card_NO then
                local temp = l_ChupaiOrder[n]
                l_ChupaiOrder[n] = l_ChupaiOrder[n + 1]
                l_ChupaiOrder[n + 1] = temp
            end
        end
    end
    
    if l_ChupaiOrder[num - 1].card_NO == 12 and l_ChupaiOrder[num].is_Laizigou == false then
        -- 如果有2且不是癞子牌则不是飞机
        return false
    end

    local chaNum = 1
    for i = 1, num do
        if l_ChupaiOrder[i].is_Laizigou == false then

            if l_ChupaiOrder[i].num <= 3 then
                -- 用癞子补齐，如果癞子不够补齐则返回false
                laiziNum = laiziNum -(3 - l_ChupaiOrder[i].num)
            else
                return false
            end

            if laiziNum < 0 then
                return false
            end

            if i+1 <= num then
                if l_ChupaiOrder[i].card_NO + 1 ~= l_ChupaiOrder[i + 1].card_NO then
                -- 牌型不是连续的,不是补齐，如果癞子牌不够补齐则返回false
                laiziNum = laiziNum - 3
                if laiziNum < 0 then
                    return false
                end

                chaNum = chaNum + 1

                if i + chaNum <= num then
                    if l_ChupaiOrder[i].card_NO + chaNum ~= l_ChupaiOrder[i + chaNum].card_NO then
                        -- 补齐之后查看后年的牌是否是连续的
                        return false
                    end
                    i = i + chaNum
                    -- 跳转到补齐后的牌
                end
            end
            end

        end
    end

    if laiziNum == 0 or laiziNum == 3 then
        return true
    else
        return false
    end
end
------------------------------------下面的是提示出牌的逻辑，用于提示比上家出的牌大的所有牌--------------------------------------
function DdzLZLogicObject:CardTypeTable()
    return
    {
        Type = nil,     -- 牌型
        Table = { },    -- 牌值
        ShowPoker ={} , -- 癞子组的牌型
        isTip = true,   -- true提示 false不提示
        Index = 0       -- 提示是几索引
    }
end

--选-出-所-有的-符-合-要-求的-牌-，比如-取-出所-有-的 对，所有的三张
--复-用-性-比较-高-因--此单-独-抽--出一个--方-法
-- @aiTable   筛选的表 默认是自己整个手牌
-- @num 最后时候出的有效牌值(上一手) -- 如果值为-1 则表示全部牌型
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
-- @TypeNum -- 为获取牌的个数  对的时候值为2 三的时候值为  3
function DdzLZLogicObject:LZGetAllTpyeFunc(aiTable, num, laizi_Num, laizipoker,TypeNum)

    local double = { } -- 用于保存最终数组
    local tempDouble = { } -- 用于保存中间数组
    local laiziNum = laizi_Num -- 癞子牌个数


    for index = num + 2, 13 do

        if aiTable[index][1] >= TypeNum then  -- 不用癞子添加的情况下
            local tableType = {   }
            tableType.Array={}
            tableType.ShowPoker={}
            tableType.Index = index
            tableType.IsLaizi = false
            local count = 0
            for i = 2, 5 do

                if aiTable[index][i] >= 0 then
                    count = count + 1
                    table.insert(tableType, aiTable[index][i])
                    table.insert(tableType.Array,aiTable[index][i])
                    table.insert(tableType.ShowPoker,aiTable[index][i]%13)
                end
                if count >= TypeNum then   --纯癞子能管上的情况下
                    break
                end
            end
            table.insert(tempDouble, tableType)
        end

        if index ~= laizipoker and(aiTable[index][1] + laizi_Num) >= TypeNum and 
            laizi_Num >0  and  laizipoker > 0 and
            aiTable[index][1] >= 1 and TypeNum>=2 then 

            local tableType = {   }
            tableType.Array={}
            tableType.ShowPoker={}
            tableType.Index = index
            tableType.IsLaizi = false
            local count = 0
            for i = 2, 5 do
                if aiTable[index][i] >= 0 then  
                    count = count + 1
                    table.insert(tableType, aiTable[index][i])
                    table.insert(tableType.Array,aiTable[index][i])
                    table.insert(tableType.ShowPoker,aiTable[index][i]%13)
                    if count == TypeNum -1 then -- 如果能够满足条件则已经添加，此时就添加癞子牌组成相应的牌型
                       break
                    end
                end
            end
            if count < TypeNum then
                for i = 2, 5 do
                    if aiTable[laizipoker][i] >= 0 then  -- 有可能癞子是3
                        count = count + 1
                        laiziNum = laiziNum -1
                        tableType.IsLaizi = true
                        table.insert(tableType.Array,aiTable[laizipoker][i])
                        table.insert(tableType, aiTable[laizipoker][i])
                        table.insert(tableType.ShowPoker,tableType.ShowPoker[1])
                    end
                    if count >= TypeNum then
                        break
                    end
                end
            end
            if count < TypeNum then
                break
                -- 跳出外部的for循环
            end

            table.insert(tempDouble, tableType)
        end
    end

      if TypeNum ==1 then
          for index =14,15 do
              if aiTable[index][2] >= 0 then
                local tableType = {   }
                tableType.Array={}
                tableType.ShowPoker={}
                tableType.Index = index
                tableType.IsLaizi = false
               table.insert(tableType, aiTable[index][2])
               table.insert(tableType.Array,aiTable[index][2])
               table.insert(tableType.ShowPoker,aiTable[index][2]%13+13)
               table.insert(tempDouble, tableType)
          end
      end

  end

    for i = 1, #tempDouble do
        if aiTable[tempDouble[i].Index][1] == TypeNum then -- 把最符合条件的排在前面
            table.insert(double, tempDouble[i])
        end
    end
    for i = 1, #tempDouble do
        if aiTable[tempDouble[i].Index][1] ~= TypeNum then
            table.insert(double, tempDouble[i])
        end
    end
   return double
end

-- 获-取-单-牌
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值
function DdzLZLogicObject:LZGetLaiziSingleFunction(aiTable, aiOutPokersIndex)

    local l_ChupaiOrder = aiOutPokersIndex
    if #l_ChupaiOrder > 1 then
        return
    end
    if l_ChupaiOrder[1].num > 1 then
        return
    end
    local single = { };
    local tempSingle = { }
    if l_ChupaiOrder[1].arr[1].CardValue < 53 then
        for i = l_ChupaiOrder[1].card_NO + 2, 15 do
            if aiTable[i][1] >= 1 then
                   for j = 2, #aiTable[i] do
                    if aiTable[i][j] >= 0 then
                        local tableType = self:CardTypeTable()
                        tableType.Type = CardType.SINGLE_CARD
                        tableType.Index = i
                        table.insert(tableType.Table, aiTable[i][j])
                        table.insert(tempSingle, tableType)
                        local showPoker =0
                        if aiTable[i][j]< 52 then
                            showPoker=aiTable[i][j]%13
                        else
                            showPoker=aiTable[i][j]%13+13
                        end
                        table.insert(tableType.ShowPoker, showPoker)
                        break
                    end
                end
            end
        end
        -- 修改提示顺序
        for i = 1, #tempSingle do
            local n = tempSingle[i].Index
            if aiTable[tempSingle[i].Index][1] == 1 then
                table.insert(single, tempSingle[i])
            end
        end
        for i = 1, #tempSingle do
            if aiTable[tempSingle[i].Index][1] == 2 then
                table.insert(single, tempSingle[i])
            end
        end
        for i = 1, #tempSingle do
            if aiTable[tempSingle[i].Index][1] == 3 then
                table.insert(single, tempSingle[i])
            end
        end
        for i = 1, #tempSingle do
            if aiTable[tempSingle[i].Index][1] == 4 then
                tempSingle[i].isTip = false
                table.insert(single, tempSingle[i])
            end
        end
        return single
    end
    return nil
end

-- 判-断-数-组-是够-满-足-固-定数-目-的-连续-牌-，并返-回-满-足的-数组
-- @aiTable  -- 筛选的表 默认是自己整个手牌
-- @judeTable  --用于判断的是数组
-- @laizi_Num  -- 癞子牌个数
-- @laizipoker   -- 癞子牌的标号
-- @listNum  --连续牌的个数（如：连对中对的个数）
function DdzLZLogicObject:LZjudgeDoubleListFunc(aiTable, judeTable, laizi_Num, laizipoker, listNum)


    local resultTable = { }
    local laiziNum = laizi_Num    -- 癞子个数
    local length = #judeTable    -- table有效牌的个数
    local typeNum = 0    -- 获取有效的牌（是对的时候值为2，飞机的时候值为3）
    if length > 0 then
        typeNum = #judeTable[1]
        -- 获取有效的牌
    end

    for i = 1, length do
        -- 对数组进行排序--按照牌值
        for j = 1, length - i do
            if judeTable[j].Index > judeTable[j + 1].Index then
                local temp = judeTable[j];
                judeTable[j] = judeTable[j + 1]
                judeTable[j +  1] = temp
            end
        end
    end

    if #judeTable > 0 and judeTable[length].Index > 12 then  --2的标号是13
        -- 最后一个是否大于2
        if listNum > 1 then
            length = length - 1
        end
    end

    if listNum > length then
        return resultTable
    end
    local chooseTable = self:ChooseJudeTable(judeTable)
    
    self:LZSmalltobigFunc(aiTable,resultTable,chooseTable,listNum,laizi_Num,typeNum,laizipoker)
    self:LZBigtoSmallFunc(aiTable,resultTable,chooseTable,listNum,laizi_Num,laizipoker,typeNum)	
	
    return resultTable
end 

-- 筛-选-出-来-判-断-牌-的-数-组-把-重-复-的-拿-掉
function DdzLZLogicObject:ChooseJudeTable(judeTable)
    local tempTable = clone(judeTable)
    local reTable = { }
    table.insert(reTable, tempTable[1])
    for i = 2, #tempTable do
        if tempTable[i].Index ~= reTable[#reTable].Index  and 
            (tempTable[i][1]%13 ~= 12 or tempTable[i][1]%13== ui.CardTableDialog.hLaiziCard )then    --主体牌中不能有2，除非2 为癞子牌
            table.insert(reTable, tempTable[i])
        end
    end
    return reTable
end


function DdzLZLogicObject:LZSmalltobigFunc(aiTable,resultTable,chooseTable,listNum,laizi_Num,typeNum,laizipoker)
---------------------------------------------------------- 从小牌开始匹配的情况-----------------------------------------------------------	
    local length = #chooseTable
    for i = 1, length - listNum + 1 do-- 从小牌开始匹配的情况
        -- AAABBBCCC 取两个连续的三张的时候有两种情况 AAABBB  BBBCCC
        -- 防止越界
        while true do

            laiziNum = laizi_Num
            local tempTalbe = { }
            tempTalbe.ShowPoker = { }
            -- 用于存放中间数组
            local count = 0
            local laiziBJ = 2
            -- 癞子牌二维数组中的下标
            local gradeIndex =0 --用于判断处理缺少牌的时候--用癞子补足

            for j = i, i + listNum - 1 do
                if gradeIndex == 0 then
                   gradeIndex =chooseTable[j].Index
                end

				local iscontinue = function ()
						if chooseTable[j].Index - gradeIndex > 1  then --如果不连续 用癞子补充配对
							 laiziNum=laiziNum-  typeNum
							 count = count + 1
                             local shownum = tempTalbe.ShowPoker[#(tempTalbe.ShowPoker)]+1
							 for m =1, typeNum do
								  -- 添加癞子牌
								  for n = laiziBJ, 5 do
									  if laizipoker > 0 and aiTable[laizipoker][n] >= 0 then
										  laiziBJ = n+1
										  table.insert(tempTalbe, aiTable[laizipoker][n])
										  table.insert(tempTalbe.ShowPoker, shownum)
										  break
									  end
								  end
							  end
							  gradeIndex =gradeIndex+1
						
						end	
				end
----------------------------------------------------------------------------------------------------
                iscontinue()  -- 连对的时候补一个对
                if laiziNum < 0 then
                    break
                end
                if count == listNum then
                    table.insert(resultTable, tempTalbe)
                    break
                end

                iscontinue()-- 连对的时候补第二个对
                if laiziNum < 0 then
                    break
                end
                if count == listNum then
                    table.insert(resultTable, tempTalbe)
                    break
                end
---------------------------------------------------------------------------------------------------
				if chooseTable[j].IsLaizi == true then
					local chaNum = typeNum - aiTable[chooseTable[j].Index][1]
					laiziNum = laiziNum - chaNum
				end

                if chooseTable[j].Index == laizipoker and laiziNum < typeNum then -- 如果癞子作为本身，并且癞子牌的个数不足时
                    break
                end
                if chooseTable[j].Index == laizipoker  then -- 如果癞子作为本身，减去癞子牌的个数
                    laiziNum=laiziNum- typeNum
                end

                gradeIndex =chooseTable[j].Index

				if laiziNum < 0 then
					break
				end
				
				for m =(aiTable[chooseTable[j].Index][1] + 1), typeNum do
					-- 添加癞子牌
					for n = laiziBJ, 5 do
						if laizipoker > 0 and aiTable[laizipoker][n] >= 0 then
							chooseTable[j][m] = aiTable[laizipoker][n]
							laiziBJ = n+1
							break
						end
					end
				end


				for k = 1, typeNum do
                    if chooseTable[j].Index == laizipoker then
                        for n = laiziBJ, 5 do
                            if laizipoker > 0 and aiTable[laizipoker][n] >= 0 then
                                table.insert(tempTalbe, aiTable[laizipoker][n])
                                table.insert(tempTalbe.ShowPoker, aiTable[laizipoker][n]%13)
                                laiziBJ = n + 1
                                break
                            end
                        end
                    else
                        table.insert(tempTalbe, chooseTable[j][k])
                        table.insert(tempTalbe.ShowPoker, chooseTable[j].ShowPoker[k])
                    end
				end

				count = count + 1
									
						
                if count == listNum then
                    table.insert(resultTable, tempTalbe)
                    break
                end
            end

            break
        end
    end
end

function DdzLZLogicObject:LZBigtoSmallFunc(aiTable , resultTable, chooseTable, listNum, laizi_Num, laizipoker, typeNum)
    local length = #chooseTable
    local ishave = false
    for i = length, listNum + 1, -1 do
        -- 从大牌开始匹配
        while true do
            ishave = false
                for m1=1,#resultTable do
                    local max =resultTable[m1].ShowPoker[listNum*typeNum]
                    if chooseTable[i][1] % 13 == max % 13 then
                        -- 当与最大值相同时，说明有重复
                        ishave = true
                        break
                    end 
                end

                if ishave then
                    break
                end

                laiziNum = laizi_Num
                local tempTalbe = { }
                -- 用于存放中间数组
                tempTalbe.ShowPoker = { }
                local count = 0
                local laiziBJ = 2
                -- 癞子牌二维数组中的下标
                local gradeIndex = 0
                -- 用于判断处理缺少牌的时候--用癞子补足

                for j = i, i - listNum, -1 do
                    if gradeIndex == 0 then
                        gradeIndex = chooseTable[j].Index
                    end
-----------------------------------------------------------------------------------------------------
                    local isbigContinue = function()
                        if gradeIndex - chooseTable[j].Index > 1 then
                            laiziNum = laiziNum - typeNum
                            count = count + 1

                            local shownum = tempTalbe.ShowPoker[#(tempTalbe.ShowPoker)]-1
                            for m = 1, typeNum do  -- 添加癞子牌
                                for n = laiziBJ, 5 do
                                    if laizipoker > 0 and aiTable[laizipoker][n] >= 0 then
                                        laiziBJ = n+1
                                        table.insert(tempTalbe, aiTable[laizipoker][n])
                                        table.insert(tempTalbe.ShowPoker, shownum)
                                        break
                                    end
                                end
                            end
                            gradeIndex = gradeIndex - 1
                        end
                    end
-----------------------------------------------------------------------------------------------------
                    isbigContinue()              -- 连对的时候补一个对
                    if laiziNum < 0 then
                        break
                    end
                    if count == listNum then
                        table.insert(resultTable, tempTalbe)
                        break
                    end

                    isbigContinue()  -- 连对的时候补第二个对
                    if laiziNum < 0 then
                        break
                    end
                    if count == listNum then
                        table.insert(resultTable, tempTalbe)
                        break
                    end

                    isbigContinue()  -- 连对的时候补第3个对
                    if laiziNum < 0 then
                        break
                    end
                    if count == listNum then
                        table.insert(resultTable, tempTalbe)
                        break
                    end

-----------------------------------------------------------------------------------------------------
                    if chooseTable[j].IsLaizi == true then
                        local chaNum = typeNum - aiTable[chooseTable[j].Index][1]
                        laiziNum = laiziNum - chaNum
                    end

                    if chooseTable[j].Index == laizipoker and laiziNum < typeNum then -- 如果癞子作为本身，并且癞子牌的个数不足时
                        break
                    end

                    if chooseTable[j].Index == laizipoker  then -- 如果癞子作为本身，减去癞子牌的个数
                        laiziNum=laiziNum- typeNum
                    end

                    gradeIndex = chooseTable[j].Index

                    if laiziNum < 0 then
                        break
                    end

                    for m =(aiTable[chooseTable[j].Index][1] + 1), typeNum do
                        -- 添加癞子牌
                        for n = laiziBJ, 5 do
                            if laizipoker > 0 and aiTable[laizipoker][n] >= 0 then
                                chooseTable[j][m] = aiTable[laizipoker][n]
                                laiziBJ = n+1
                                break
                            end
                        end
                    end

                    for k = 1, typeNum do
                        if chooseTable[j].Index == laizipoker then
                            for n = laiziBJ, 5 do
                                if laizipoker > 0 and aiTable[laizipoker][n] >= 0 then
                                    table.insert(tempTalbe, aiTable[laizipoker][n])
                                    table.insert(tempTalbe.ShowPoker, aiTable[laizipoker][n]%13)
                                    laiziBJ = n + 1
                                    break
                                end
                            end
                        else
                            table.insert(tempTalbe, chooseTable[j][k])
                            table.insert(tempTalbe.ShowPoker, chooseTable[j].ShowPoker[k])
                        end
                    end

                    count = count + 1
                    if count == listNum then
                        table.insert(resultTable, tempTalbe)
                        break
                    end

                end

            break
        end
    end
end

--三-不-带（-比-上家-大-的-）
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziThreeFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    if l_ChupaiOrder[1].card_NO >= 12 then
        -- 222
        return
    end

    local three = { }
    local cardNo = l_ChupaiOrder[1].card_NO
    local tempThree =  self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,3)  -- 获取所有的三张


   for i = 1, #tempThree do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.THREE_CARD
        tableType.Index = tempThree[i].Index
        for k = 1, #tempThree[i] do
            table.insert(tableType.Table, tempThree[i][k])
            table.insert(tableType.ShowPoker, tempThree[i].ShowPoker[k])
        end
        table.insert(three, tableType)
    end

    for i = 1, #three do
        if aiTable[three[i].Index][1] == 4 then
            three[i].isTip = false
        end
    end
    return three
end

--选-出--对牌-（比上家大的）
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手)
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziDoubleFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    if l_ChupaiOrder[1].card_NO >= 12 then
        -- 22 最大对牌
        return 
    end
   local tempDouble = { }
   local card_NO =l_ChupaiOrder[1].card_NO
   local double = self:LZGetAllTpyeFunc(aiTable, card_NO, laizi_Num, laizipoker , 2)

    for i = 1, #double do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.DOUBLE_CARD
        tableType.Index =double[i].Index
        for k = 1, 2 do
            table.insert(tableType.Table, double[i].Array[k])
            table.insert(tableType.ShowPoker, double[i].ShowPoker[k])
        end
        table.insert(tempDouble, tableType)
    end

    return tempDouble
end

--处-理--带二-的-重-复-问题-处-理其-中-与-主-牌重-复-的-问题
function DdzLZLogicObject:LZNotRepeatFunction(aiTable,tempthree, double, laizipoker)
    local cloneDouble = {}
    local beforenum = 0

    for i = 1, #tempthree do
        cloneDouble = clone(double)

        for del = 1, #cloneDouble do -- 防止重复，对中有重复的
            if cloneDouble[del][1]>= 0 then
                 if beforenum == cloneDouble[del].Index then
                    cloneDouble[del][1] = -1
                    cloneDouble[del][2] = -1
                else
                    beforenum = cloneDouble[del].Index
                end
            end
        end

        local laiziarray = { }
        for ins1 = 2, 5 do    -- 把癞子牌写入数组，并且把主牌中用过的癞子牌置成-1.防止重复使用
            if laizipoker > 0 and aiTable[laizipoker][ins1] >= 0 then
                table.insert(laiziarray, aiTable[laizipoker][ins1])
            end
        end
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.THREE_TWO_CARD
        tableType.Index = tempthree[i].Index
        for j = 1, #tempthree[i] do
            table.insert(tableType.Table, tempthree[i][j])        -- 把主牌写入
            table.insert(tableType.ShowPoker, tempthree[i].ShowPoker[j])

            for f1 = 1, #laiziarray do
                if laiziarray[f1] == tempthree[i][j] then
                    laiziarray[f1] = -1
                end
            end
        end

        for m = 1, #cloneDouble do
            for t1 = 1, #tableType.Table do
                local laizidouble = false
                if cloneDouble[m][1] >= 0 and(cloneDouble[m][1] == tableType.Table[t1] or cloneDouble[m][2] == tableType.Table[t1]) then
                    -- 防止对中有与主牌重复的牌

                    if cloneDouble[m].IsLaizi == false then
                        -- 如果是非癞子牌
                        cloneDouble[m][1] = -1
                        cloneDouble[m][2] = -1
                    else
                        -- 如果是癞子，则遍历这个对，从中找到癞子牌，然后从癞子数组中取一张未用的癞子牌匹配成对
                        for dou1 = 1, #cloneDouble[m] do
                            if cloneDouble[m][dou1] % 13 == laizipoker - 1 then -- 是癞子牌
                                for lai1 = 1, #laiziarray do
                                    if laiziarray[lai1] >= 0 then  --癞子有可能为 0 
                                        cloneDouble[m][dou1] = laiziarray[lai1]
                                        laiziarray[lai1] = -1
                                        laizidouble = true
                                        break;
                                    end
                                end
                            end
                        end

                        if not laizidouble then
                            cloneDouble[m][1] = -1
                            cloneDouble[m][2] = -1
                        end
                    end
                end
            end
        end

    end

    return cloneDouble
end

-- 提-取-癞-子-三-带一
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziThreeOneFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local length = 0
    local mainPoker = -1;
    -- 用来记录当前牌的序号
    -- 主牌
    for index = 1, 2 do
        length = length + l_ChupaiOrder[index].num
        if l_ChupaiOrder[index].num == 3 then
            mainPoker = index
        end
    end
    if length < 4 then
        return
    end

    if mainPoker == -1 then
        return
    end
    if l_ChupaiOrder[mainPoker].card_NO >= 12 then
        -- 222
        return
    end
    local treeOne = { }
    local cardNo = l_ChupaiOrder[mainPoker].card_NO

    local tempthree = self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,3)  -- 获取所有的三张
    local single =self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker,1)  -- 获取所有的单张


    for i = 1, #tempthree do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.THREE_ONE_CARD
        tableType.Index = tempthree[i].Index
        for j = 1, #tempthree[i] do
            table.insert(tableType.Table, tempthree[i][j]) --把主牌写入
            table.insert(tableType.ShowPoker, tempthree[i].ShowPoker[j])
        end

        for m =1,#single  do
            if length == #tableType.Table then
                break
            end
            for n = 1, #tableType.Table do
                if single[m][1]==tableType.Table[n]  then -- 取单的时候不能与飞机的主牌相同
                    m= m+1
                    break
                end
                if n == #tableType.Table then --遍历到最后
                    table.insert(tableType.Table, single[m][1])
                    table.insert(tableType.ShowPoker, single[m].ShowPoker[1])
                    break
                end
            end
        end
        if #tableType.Table ==4 then -- 如果不满足则不加入提示队列--如果有癞子的情况，如果癞子作为单则也可以匹成炸弹
             table.insert(treeOne, tableType)
        end
    end

    for i = 1, #treeOne do
        if aiTable[treeOne[i].Index][1] == 4 then
            treeOne[i].isTip = false
        end
    end
    return treeOne
end

--获-取-所-有-的-软-炸-弹
function DdzLZLogicObject:LZGetSoftBombFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)
    local l_ChupaiOrder = aiOutPokersIndex
    local cardNo = -1
    if #l_ChupaiOrder >0 then
        for i =1, #l_ChupaiOrder do
            cardNo = l_ChupaiOrder[i].card_NO
            if l_ChupaiOrder[i].card_NO < cardNo and l_ChupaiOrder[i].card_NO ~= laizipoker-1  then -- 获取其中最小的,并且不是癞子的--
               cardNo = l_ChupaiOrder[i].card_NO 
            end
        end
    end
    local softBomb = { }
    local temp={}

    local four = self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker, 4)
    -- 获取所有的4张
    local num = #four

    for i = 1, num do
        if four[i].IsLaizi == true and  four[i].ShowPoker[1] > cardNo then  --是癞子组成的，并且大于最小值
            table.insert(temp, four[i])
        end
        if four[i].IsLaizi == false  then -- 非癞子一定可以管
           table.insert(temp, four[i])
        end
    end
    softBomb= self:LZSetInBomFunction(aiTable,temp)

    return softBomb
end

--提-取-癞-子-三代-二-（比上家大的）
--带-二-的-牌是-比-较-难判-断-的，要考虑癞子牌重复的问题
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziThreeTwoFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local length = 0
    local mainPoker = -1
    local laiziNum = laizi_Num

    -- 主牌
    for index = 1, #l_ChupaiOrder do
        length = length + l_ChupaiOrder[index].num
        if l_ChupaiOrder[index].num == 3 then
            mainPoker = index
        end
    end

    if mainPoker == -1 then
        return
    end
    if l_ChupaiOrder[mainPoker].card_NO >= 12 then
        -- 222
        return
    end
    local have =0 
    for i=1,15  do
        have = have+ aiTable[i][1]
    end
    
    if have < 5 then
      return 
    end

   local threeTwo = { }
   local cardNo = l_ChupaiOrder[mainPoker].card_NO
   local tempthree =  self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,3)  -- 获取所有的三张
   local double = self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker,2)  -- 获得所有的对张

   for i = 1, #tempthree do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.THREE_TWO_CARD
        tableType.Index = tempthree[i].Index
        for j = 1, #tempthree[i] do
            table.insert(tableType.Table, tempthree[i][j])
            table.insert(tableType.ShowPoker, tempthree[i].ShowPoker[j])
        end
         local mtemTree ={}
         table.insert(mtemTree,tempthree[i])
         local cloneDouble = self:LZNotRepeatFunction(aiTable,mtemTree, double, laizipoker)--把当前的对子中与主牌相同的取消掉

         for n =1,#cloneDouble do 
             if cloneDouble[n][1] >= 0  then
                table.insert(tableType.Table, cloneDouble[n][1])
                table.insert(tableType.Table, cloneDouble[n][2])
                table.insert(tableType.ShowPoker, cloneDouble[n].ShowPoker[1])
                table.insert(tableType.ShowPoker, cloneDouble[n].ShowPoker[2])
                break
             end
         end 
         if #tableType.Table < 5 then
              tableType.isTip = false
         else
             table.insert(threeTwo, tableType)
         end
    end

   for i = 1, #threeTwo do
        if aiTable[threeTwo[i].Index][1] == 4 then
            threeTwo[i].isTip = false
        end
    end
   return threeTwo
end


function DdzLZLogicObject:LZGetKingBombFunction(aiTable)
    local bomb={}
    if aiTable[14][1] > 0 and aiTable[15][1] > 0 then
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.BOMB_CARD
        if aiTable[14][1] >= 0 then
            table.insert(tableType.Table, aiTable[14][2])
        end
        if aiTable[15][1] >= 0 then
            table.insert(tableType.Table, aiTable[15][2])
        end
        table.insert(bomb, tableType)
    end
    return bomb

end

function DdzLZLogicObject:LZSetInBomFunction(aiTable,four)
    local bomb = {}
    for i=1,#four do
      local tableType = self:CardTypeTable()
      tableType.Type = CardType.BOMB_CARD
       for j =1, #four[i] do
           table.insert(tableType.Table, four[i][j])
           table.insert(tableType.ShowPoker, four[i].ShowPoker[j])
       end
       table.insert(bomb, tableType)
    end
 
    if aiTable[14][1] > 0 and aiTable[15][1] > 0 then
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.BOMB_CARD
        if aiTable[14][1] >= 0 then
            table.insert(tableType.Table, aiTable[14][2])
        end
        if aiTable[15][1] >= 0 then
            table.insert(tableType.Table, aiTable[15][2])
        end
        table.insert(bomb, tableType)
    end

    return bomb

end

-- 获-取-所-有炸-弹
-- @aiTable -- 表示是所有的牌
-- @laizi_Num  -- 癞子牌个数
-- @laizipoker  --癞子牌的标号
function DdzLZLogicObject:LZGetLaizuiAllBombFunction(aiTable, laizi_Num, laizipoker)

    local tBomb = { }
    for index = 1, 13 do
        if aiTable[index][1] >= 4 then
            local tableType = self:CardTypeTable()
            tableType.Type = CardType.BOMB_CARD
            for i = 2, 5 do
                table.insert(tableType.Table, aiTable[index][i])
                table.insert(tableType.ShowPoker, aiTable[index][i]%13)
            end
            table.insert(tBomb, tableType)
        elseif aiTable[index][1] + laizi_Num >= 4 and aiTable[index][1] >= 1 and laizipoker>0  and  laizi_Num >0 and index ~= laizipoker then  --癞子配炸弹
            local count = 0
            local tableType = self:CardTypeTable()
            tableType.Type = CardType.BOMB_CARD
            for i = 2, 5 do
                if aiTable[index][i] >= 0 then
                    count = count + 1
                    table.insert(tableType.Table, aiTable[index][i])
                    table.insert(tableType.ShowPoker, aiTable[index][i]%13)
                end
            end
            if count < 4 then
                for i = 2, 5 do
                    if aiTable[laizipoker][i] >= 0 then
                        count = count + 1
                        table.insert(tableType.Table, aiTable[laizipoker][i])
                        table.insert(tableType.ShowPoker, tableType.ShowPoker[1])
                    end
                    if count >= 4 then
                        break
                    end
                end
            end
            if count < 4 then
                break
                -- 跳出外部的for循环
            end
            table.insert(tBomb, tableType)
        end
    end
    if aiTable[14][1] > 0 and aiTable[15][1] > 0 then
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.BOMB_CARD
        table.insert(tableType.Table, aiTable[14][2])
        table.insert(tableType.Table, aiTable[15][2])
        table.insert(tBomb, tableType)
    end
    return tBomb
end

--获-取-替-补的-牌-，四带-二-的-时-候只-提-取-其-中-的一张
function DdzLZLogicObject:LZGetBenchFunction(aiTable,single)
    local bench ={}
    local temp ={}
    temp.ShowPoker={}
    for i=1,#single do
        if single[i].Index <14 then
           for j =2,5 do
             if aiTable[single[i].Index][j] >= 0 and aiTable[single[i].Index][j]~= single[i][1] then  
               table.insert(temp,aiTable[single[i].Index][j])
               table.insert(temp.ShowPoker,aiTable[single[i].Index][j]%13)
               table.insert(bench,temp)
               temp ={}
               temp.ShowPoker={}
             end
           end
        end
    end
    return bench
end

-- 软-炸-不-带-牌
function DdzLZLogicObject:LZChooseSoftBombFunction(four) 
    local result ={}
    for i=1,#four do
        if four[i].IsLaizi==false then
            table.insert(result,four[i])
        end
    end
--    return  result
    return four
end

-- 获-取-炸-弹-包-括-癞-子-炸-弹（比上家大的）
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker 
function DdzLZLogicObject:LZGetLaiziBombFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    if #l_ChupaiOrder > 1 then
        return
    end

    if l_ChupaiOrder[1].num ~= 4 then
        return
    end

 
 local cardNo = l_ChupaiOrder[1].card_NO
    if #l_ChupaiOrder >0 then
        for i =1, #l_ChupaiOrder do
            cardNo = l_ChupaiOrder[i].card_NO
            if l_ChupaiOrder[i].card_NO < cardNo and l_ChupaiOrder[i].card_NO ~= laizipoker-1  then -- 获取其中最小的,并且不是癞子的--
               cardNo = l_ChupaiOrder[i].card_NO 
            end
        end
    end

    local bomb = { }
    local temp ={}
   
    local four =  self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker,4)  -- 获取所有的4张
    local num = #four
     for i = 1, num do
        if four[i].IsLaizi == false and (four[i].ShowPoker[1] > cardNo or four[i].ShowPoker[1] == laizipoker -1 )then -- 取非癞子，或者纯癞子
            table.insert(temp, four[i])
        end
    end
    bomb= self:LZSetInBomFunction(aiTable,temp)
    return bomb
end

-- 获-取-四-带二（比上家大）
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziBOMTwoFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local laiziNum = laizi_Num
    local mainPoker = -1

    for index = 1, #l_ChupaiOrder do
        if l_ChupaiOrder[index].num == 4 then
            mainPoker = index
        end
    end
    if mainPoker == -1 then
        return
    end
    if l_ChupaiOrder[mainPoker].card_NO >= 12 then
        -- 2222
        return
    end

    local BOMBTwo = { }
    local cardNo = l_ChupaiOrder[mainPoker].card_NO
    local four =  self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,4)  -- 获取所有的四张
    local single = self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker,1)  -- 获得所有的单张
    local bench= self:LZGetBenchFunction(aiTable,single)
    four= self:LZChooseSoftBombFunction(four)
    for i = 1, #four do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.BOMB_TWO_CARD
        tableType.Index = four[i].Index
        for j = 1, #four[i] do
            table.insert(tableType.Table, four[i][j]) --把主牌写入
            table.insert(tableType.ShowPoker, four[i].ShowPoker[j])
        end
        local index = 0  --标号用来处理最后一手牌是对的情况 四带一对
        local count =0
         for m = 1, #single do
            for n = 1, #tableType.Table do
                if single[m][1] == tableType.Table[n]  then  
                    -- 取单的时候不能与主牌相同
                   break
                end
                if n == #tableType.Table then  -- 确定遍历到最后
                    table.insert(tableType.Table, single[m][1])
                    table.insert(tableType.ShowPoker, single[m].ShowPoker[1])
                    count=count +1
                end
            end
            if count >= 2 then
               break
            end
        end
        if #tableType.Table < 6 then
            -- 当四带一对的时候取单只取一张有可能补不足因此要做一个最后的处理
            for i = 1, #bench do
            local shownum =0
                if bench[i][1] >=52 then
                    shownum = bench[i][1]%13+13
                else
                    shownum = bench[i][1]%13
                end
                for n = 1, #tableType.Table do
                    if bench[i][1] ~= tableType.Table[n] then
                        table.insert(tableType.Table, bench[i][1])
                        table.insert(tableType.ShowPoker,shownum)
                        count = count + 1
                    end
                    if count >= 2 then
                        break
                    end
                end
                if count >= 2 then
                    break
                end
            end
        end

        if #tableType.Table == 6 then
            table.insert(BOMBTwo, tableType)
        end
    end
 
    return BOMBTwo

end

-- 飞-机--不-带
-- aiTable   筛选的表 默认是自己整个手牌
-- aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- laizi_Num  癞子牌的个数
-- 癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziAircraftFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local length = 0
    -- 所有牌数
    local  mainPoker = 0 

    for index = 1, #l_ChupaiOrder do
        length = length + l_ChupaiOrder[index].num
    end

    if length % 3 ~= 0 then
        return
    end
    if l_ChupaiOrder[#l_ChupaiOrder].card_NO >= 11 then
        -- AAA--管牌逻辑的处理，没有比带AAA更大的飞机了
        return
    end
    mainPoker= length/3
    local AircrResult = { }
    local cardNo = l_ChupaiOrder[1].card_NO
    for i=2,# l_ChupaiOrder do
        if l_ChupaiOrder[i].card_NO < cardNo then
           cardNo = l_ChupaiOrder[i].card_NO
        end
    end
    local three =  self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,3)  -- 获取所有的三张
    local tempthree =self:LZjudgeDoubleListFunc(aiTable, three, laizi_Num, laizipoker, mainPoker) -- 心的判断连对
    for i = 1, #tempthree do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.AIRCRAFT_CARD
        tableType.Index = 0
        for j = 1, #tempthree[i] do
              if  tempthree[i][j]%13 < 12 then
                 table.insert(tableType.Table, tempthree[i][j])
                 table.insert(tableType.ShowPoker, tempthree[i].ShowPoker[j])
              end
        end
        table.insert(AircrResult, tableType)
    end

    for i = 1, #AircrResult do
        for n =1 , mainPoker do
            local  cardnum = AircrResult[i].Table[(n-1)*3+1]%13
            if aiTable[cardnum+1][1] == 4 then        
                AircrResult[i].isTip = false
            end
        end
    end

    return AircrResult    
end

-- 四-带-俩-对-
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziBOMTwooFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local laizinum = laizi_Num
    local length =0
    local mainPoker=-1

    for index = 1, #l_ChupaiOrder do
        length = length+l_ChupaiOrder[index].num
        if l_ChupaiOrder[index].num == 4 then
            mainPoker = index
        end
    end

    if mainPoker == -1 then
        return
    end
    if l_ChupaiOrder[mainPoker].card_NO >= 12 then
        return
    end

    local BOMBTwooo = { }
    local cardNo = l_ChupaiOrder[mainPoker].card_NO
    local four =  self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,4)  -- 获取所有的4张
    local double = self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker,2)  -- 获得所有的对张
    four= self:LZChooseSoftBombFunction(four)

    for i = 1, #four do

        local tableType = self:CardTypeTable()
        tableType.Type = CardType.BOMB_TWOOO_CARD
        tableType.Index =four[i].Index
        for j = 1, #four[i] do
            table.insert(tableType.Table, four[i][j])           
            table.insert(tableType.ShowPoker, four[i].ShowPoker[j])
        end
         local mtemTree ={}
         table.insert(mtemTree,four[i])
         local cloneDouble = self:LZNotRepeatFunction(aiTable,mtemTree, double, laizipoker)

        for m = 1, #cloneDouble do
           if #tableType.Table == length then
                break
           end
            for n = 1, #tableType.Table do
                if n == #tableType.Table and cloneDouble[m][1]>= 0 then  -- 往最后添加
                    table.insert(tableType.Table, cloneDouble[m][1])
                    table.insert(tableType.Table, cloneDouble[m][2])
                    table.insert(tableType.ShowPoker, cloneDouble[m].ShowPoker[1])
                    table.insert(tableType.ShowPoker, cloneDouble[m].ShowPoker[2])
                end
               if #tableType.Table == length then
                    break
               end
            end
        end
        if #tableType.Table == length then
            table.insert(BOMBTwooo, tableType)
        end
    end
 
    return BOMBTwooo
end
-- 写-入-数-据-，并且-保-证-写-入-的数-据-是-唯-一的
function DdzLZLogicObject:LZfindOnlyFunction(tableType,single,length)
          for m =1,#single  do

            if length == #tableType.Table then
               break
            end
            for mn=1, #tableType.Table do
                if   single[m][1] == tableType.Table[mn] then
                     single[m][1] =-1
                    break
                end
            end

            if single[m][1] >= 0 then
                for n = 1, #tableType.Table do
                    if n == #tableType.Table then
                        table.insert(tableType.Table, single[m][1])
                        table.insert(tableType.ShowPoker, single[m].ShowPoker[1])
                    end
                end
            end
        end
        return tableType
end

-- 飞-机-带-对-
-- aiTable   筛选的表 默认是自己整个手牌
-- aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- laizi_Num  癞子牌的个数
-- 癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziAircraftDoubleFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local length = 0
    local count = 0

    -- 所有牌数
    local  mainPoker = 0 --有效的飞机个数也就是三的个数

    for index = 1, #l_ChupaiOrder do
        length = length + l_ChupaiOrder[index].num
    end
    mainPoker = length /5
    if length % 5 ~= 0 then
        return
    end
    if l_ChupaiOrder[#l_ChupaiOrder].card_NO >= 11 then
        -- AAA--管牌逻辑的处理，没有比带AAA更大的飞机了
        return
    end

    local AircraftDouble = { }
    local cardNo = -1
    for i=1,#l_ChupaiOrder do
        if 3 == l_ChupaiOrder[i].num then
            if cardNo < 0 then
               cardNo = l_ChupaiOrder[i].card_NO
            end
            if cardNo > l_ChupaiOrder[i].card_NO then
               cardNo = l_ChupaiOrder[i].card_NO -- 获取最小的飞机主牌
            end
        end
    end
    local three =  self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,3)  -- 获取所有的三张
    local tempthree =self:LZjudgeDoubleListFunc(aiTable, three, laizi_Num, laizipoker, mainPoker) -- xin的判断连对
    local double = self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker,2)  -- 获得所有的对张
    

  for i=1, #tempthree do
     count = 0
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.AIRCRAFT_DOBULE_CARD
        tableType.Index = tempthree[i].Index
        for j = 1, #tempthree[i] do
            if  tempthree[i][j]%13 < 12 then
                table.insert(tableType.Table, tempthree[i][j])
                table.insert(tableType.ShowPoker, tempthree[i].ShowPoker[j])
            end
        end
         local mtemTree ={}
         table.insert(mtemTree,tempthree[i])
         local cloneDouble = self:LZNotRepeatFunction(aiTable,mtemTree, double, laizipoker)

     for n =1,#cloneDouble do 
         if cloneDouble[n][1] >= 0 and count < mainPoker then
            count = count+1
            table.insert(tableType.Table, cloneDouble[n][1])
            table.insert(tableType.Table, cloneDouble[n][2])
            table.insert(tableType.ShowPoker, cloneDouble[n].ShowPoker[1])
            table.insert(tableType.ShowPoker, cloneDouble[n].ShowPoker[2])
         end
     end 
     table.insert(AircraftDouble, tableType)
  end
 
    for i = 1, #AircraftDouble do
        if length ~= #AircraftDouble[i].Table then  -- 防止提示的时候提示的牌不对，这样的好处是匹配上的牌也可以出就是不能提示
            AircraftDouble[i].isTip = false
        end
        for n =1 , mainPoker do
            local  cardnum = AircraftDouble[i].Table[(n-1)*3+1]%13
            if aiTable[cardnum+1][1] == 4 then        
                AircraftDouble[i].isTip = false
            end
        end
    end
    return AircraftDouble    
end

-- 飞-机-带-单
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziAircraftSingleFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local length = 0

    -- 所有牌数
    local  mainPoker = 0 --有效的飞机个数也就是三的个数

    for index = 1, #l_ChupaiOrder do
        length = length + l_ChupaiOrder[index].num
    end
    mainPoker = length /4
    if length % 4 ~= 0 then
        return
    end
    if l_ChupaiOrder[#l_ChupaiOrder].card_NO >= 11 then
        -- AAA--管牌逻辑的处理，没有比带AAA更大的飞机了
        return
    end

    local AircraftSingle = { }
    local cardNo = -1

    for i=1,#l_ChupaiOrder do
        if 3 == l_ChupaiOrder[i].num then
            if cardNo < 0 then
               cardNo = l_ChupaiOrder[i].card_NO
            end
            if cardNo > l_ChupaiOrder[i].card_NO then
               cardNo = l_ChupaiOrder[i].card_NO -- 获取最小的飞机主牌
            end
        end
    end
 
    local three =  self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,3)  -- 获取所有的三张
    local tempthree =self:LZjudgeDoubleListFunc(aiTable, three, laizi_Num, laizipoker, mainPoker) -- xin的判断连对
    local single = self:LZGetAllTpyeFunc(aiTable, -1, laizi_Num, laizipoker,1)  -- 获得所有的单张    
    local bench= self:LZGetBenchFunction(aiTable,single)

    for i = 1, #tempthree do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.AIRCRAFT_SINGLE_CARD
        tableType.Index = 0
        for j = 1, #tempthree[i] do
            if  tempthree[i][j]%13 < 12 then
                table.insert(tableType.Table, tempthree[i][j]) --把飞机主牌写入
                table.insert(tableType.ShowPoker, tempthree[i].ShowPoker[j])
            end
        end
      
        tableType = self:LZfindOnlyFunction(tableType,single,length)
            if #tableType.Table < length then -- 当写入的数据小于需要的长度时，需要从后备数据中添加数据
                 tableType = self:LZfindOnlyFunction(tableType,bench,length)
            end

           if  length ==#tableType.Table then
               table.insert(AircraftSingle, tableType)
           end
    end

    for i = 1, #AircraftSingle do
        for n =1 , mainPoker do
            local  cardnum = AircraftSingle[i].Table[(n-1)*3+1]%13
            if aiTable[cardnum+1][1] == 4 then        
                AircraftSingle[i].isTip = false
            end
        end
    end
    return AircraftSingle    
end


function DdzLZLogicObject:LZaddLaiziAndSortFunction(aiTable,tempArray,laizipoker,aiTable)
     local temp = clone(tempArray)

     -- 因为除了单牌的情况下需要添加癞子牌
     local havelaizi = false
     for i =1, #temp do
         if  temp[i].Index == laizipoker then
              havelaizi = true
         end
     end
 
    if not havelaizi and laizipoker >0 then  -- 因为是癞子牌加一，因此不会有0的情况

            local tableType = {   }
            tableType.Array={}
            tableType.ShowPoker={}
            tableType.Index = laizipoker
            tableType.IsLaizi = true
            for i = 2, 5 do
                if aiTable[laizipoker][i] >= 0 then
                    table.insert(tableType, aiTable[laizipoker][i])
                    table.insert(tableType.Array,aiTable[laizipoker][i])
                    table.insert(tableType.ShowPoker,aiTable[laizipoker][i]%13)
                    table.insert(temp, tableType)
                    break
                end
            end
    end

    local poker_num = -1
    local cha  =0
    local num  = #temp
    if num >0 then
      poker_num =#temp[1]
    end

    for i = 1, num do
        if temp[i].Index == laizipoker  and laizipoker >0 then
            temp[i].IsLaizi = true
            cha =1
            for m1=1,poker_num do
                temp[i][m1] = nil
                temp[i].ShowPoker[m1] =nil 
                temp[i].Array[m1] =nil 
            end
            
            for j = 2, 5 do
                if  laizipoker >0 and  aiTable[laizipoker][j] >= 0 then
                    table.insert(temp[i], aiTable[laizipoker][j])
                    table.insert(temp[i].Array, aiTable[laizipoker][j])
                    table.insert(temp[i].ShowPoker, aiTable[laizipoker][j] % 13)
                end
            end
            break
        end
    end
   
    for i = 1, num do
        temp[i].card_NO = { }
        if temp[i][1]< 52 then
            temp[i].card_NO= temp[i][1] % 13
        else
            temp[i].card_NO= temp[i][1] % 13+13
        end
        
    end

    for k3 = 1, num do
        if  temp[k3].IsLaizi == true then
            local tem = temp[num]
            temp[num] = temp[k3]
            temp[k3] = tem
            break
        end
    end



    for k1 = 1, num - cha  do -- 如果没有癞子则不减
        for k2 = 1, num - cha -1 do
            if temp[k2].card_NO > temp[k2 + 1].card_NO then
                local t = temp[k2]
                temp[k2] = temp[k2 + 1]
                temp[k2 + 1] = t
            end
        end
    end

    for i = 1, num do
        if temp[i].card_NO == 12 and laizipoker ~= temp[i].Index then  -- 获取顺子的时候不会有2，但是当2作为癞子的时候可以
            for j = i, num do
                temp[j] = temp[j + 1]
            end
            temp[num] = nil
            break
        end
    end

    return temp
end

function DdzLZLogicObject:LZCardToShowFunction(result,pokerNumber)

    local num = #result
    if num  == 0  then
      return result
    end

    local length = #result[1]
    local laizinum = result.laizinum

    for k1 = 1, num do
        if result[k1][1] + length < 12 then
            for i = 1, length do
                for m = 1, pokerNumber do
                    table.insert(result[k1].show, result[k1][1] + i - 1)
                end
            end
        elseif 12 - length > 0 then
            for i = 1, length do
                for m = 1, pokerNumber do
                    table.insert(result[k1].show, 11 -(i - 1))
                end
            end

        end

    end

end

-- 获-取-连--对
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker
function DdzLZLogicObject:LZGetLaiziDoubleListFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local z_num =0
    for i=1,#l_ChupaiOrder do
        z_num=z_num+l_ChupaiOrder[i].num
    end
    local length = z_num/2
    if length < 3 then
        return
    end

    if l_ChupaiOrder[#l_ChupaiOrder].card_NO > 11 then  -- 如果值大于A则返回--因为有自己出牌的情况，
        return 
    end

    local listDouble = { }
    local cardNo = l_ChupaiOrder[1].card_NO
    for i=2,# l_ChupaiOrder do
        if l_ChupaiOrder[i].card_NO < cardNo then
           cardNo = l_ChupaiOrder[i].card_NO  -- 获取最小的连对牌值
        end
    end
    local temp = self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker, 2)
    -- 获取所有的对
    local templist =self:LZjudgeDoubleListFunc(aiTable, temp, laizi_Num, laizipoker, length) -- 用来测试连对
    
    -- 在查找的牌中中查找满足条件的
     for i = 1, #templist do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.COMPANY_CARD
        for k = 1, #templist[i] do
            table.insert(tableType.Table, templist[i][k])
            table.insert(tableType.ShowPoker, templist[i].ShowPoker[k])
        end
        table.insert(listDouble, tableType)
    end
    return listDouble
end

 function DdzLZLogicObject:LZIsListFunc(l_ChupaiOrder)
    local laiziNum = l_ChupaiOrder.laizinum
    local num  = #l_ChupaiOrder
    local max = 0
    local min = 0
    local mnum = 0

    for index = num-laiziNum , 1, -1 do
 
            if max == 0 then
                max = l_ChupaiOrder[index]
            else
                min = l_ChupaiOrder[index]

                if min >= 0 and(max - 1 - min) > 0 then
                    mnum = mnum + max - 1 - min
                end
                max = min
            end

    end

    if min == 0 then
        -- 仅有一张牌的情况
        if laiziNum == 4 then
            return true
        else
            return false
        end
    end
    
    return mnum <= laiziNum
 end

-- 获-取-连
-- @aiTable   筛选的表 默认是自己整个手牌
-- @aiOutPokersIndex 最后时候出的有效牌值(上一手(即癞子后的牌))--l_ChupaiOrder
-- @laizi_Num  癞子牌的个数
-- @癞子牌的标号是 laizipoker(是加一的情况)
function DdzLZLogicObject:LZGetLaiziListFunction(aiTable, aiOutPokersIndex, laizi_Num, laizipoker)

    local l_ChupaiOrder = aiOutPokersIndex
    local length = #l_ChupaiOrder
    if length < 5 then
        return
    end

    if l_ChupaiOrder[length].card_NO >= 11 then
        -- 最大的链子到A
        return 
    end

    local list = { }
    local cardNo = l_ChupaiOrder[1].card_NO
    for i=2,# l_ChupaiOrder do
        if l_ChupaiOrder[i].card_NO < cardNo then
           cardNo = l_ChupaiOrder[i].card_NO
        end
    end
    local temp = self:LZGetAllTpyeFunc(aiTable, cardNo, laizi_Num, laizipoker,1)
    local tmp = self:LZaddLaiziAndSortFunction(aiTable,temp,laizipoker,aiTable)
       
    local templist =self:LZGetListFunction(tmp,length)
     -- 在查找的牌中中查找满足条件的

    for i = 1, #templist do
        local tableType = self:CardTypeTable()
        tableType.Type = CardType.CONNECT_CARD
        for k = 1, #templist[i] do
            table.insert(tableType.Table, templist[i].array[k])
            table.insert(tableType.ShowPoker, templist[i].show[k])
        end
        table.insert(list, tableType)
    end

    return list
end

-- 获-取-顺-子
function DdzLZLogicObject:LZGetListFunction(tmp, length)
    local num = #tmp
    local pokerNumber = -1
    local laizinum = 0
    if num> 0 then
       pokerNumber = #tmp[1]
        if  tmp[num][1]%13 == ui.CardTableDialog.hLaiziCard then
            laizinum=#tmp[num]
        end
    end

    local result = { }
    if laizinum>0 and  num + laizinum - 1 < length then
        return { }
    elseif laizinum==0 and  num  < length then
        return { }
    end

    for m1 = 1, num do
        while true do
            local endNum = 0
            local tempArray = { }
            tempArray.array = { }
            tempArray.laizinum = 0
            tempArray.is_Laizigou = false
            tempArray.show = { }

            local maxNum = tmp[m1][1] % 13 + length - 1
            if maxNum >= 12 then
                -- 最大顺牌不能为2
                maxNum = 11
            end
           if ui.CardTableDialog.hLaiziCard ==tmp[num][1] % 13  then
              num =num-1
           end
            for m2 = 1, num do  --因为最后一个是癞子
                local nonum = 0
                if tmp[m2][1] <52 then  -- 要考虑王的情况
                     nonum =tmp[m2][1] % 13 
                else
                    nonum=tmp[m2][1] % 13 +13
                end

                if nonum > maxNum  then -- 如果此时的值大于最大值则取前面一个值
                    endNum = m2-1
                    break
                elseif nonum == maxNum then  -- 如果此时的值相同则取这个值
                    endNum = m2
                    break
                else
                    endNum = m2
                end

                if endNum >= m1+length-1 then  -- 最大的值为A的情况
                   endNum = m1+length-1
                end

            end

            if length - (endNum-m1+1) > laizinum then
                break
            end

            for j = m1, endNum do
                for m = 1, pokerNumber do
                    if tmp[j][m]<52 then
                        table.insert(tempArray.array, tmp[j][m])
                        table.insert(tempArray, tmp[j][m] % 13)
                        tempArray.is_Laizigou = tmp[j].IsLaizi
                    end
                end
            end

            for k = 1, length - (endNum-m1+1) do
                if tmp[#tmp][k]<52 then
                    table.insert(tempArray.array, tmp[#tmp][k])
                    table.insert(tempArray, tmp[#tmp][k] % 13)
                    tempArray.is_Laizigou = tmp[#tmp].IsLaizi
                    tempArray.laizinum = k
                end
            end
                if #tempArray == length then-- 长度判断，防止长度不够
                    if self:LZIsListFunc(tempArray) then
                        table.insert(result, tempArray)
                    end
                end
            break
        end
    end
    self:LZCardToShowFunction(result, pokerNumber)
    return result
end

return DdzLZLogicObject.new()