
--排-序,利-用-lua-的-table-主要-是-底-牌-需-要-排-序-还有出牌要排序
--@return 排-好-序-的-牌-的-数-组-这-个-函-数-并-不-修-改-原-来-牌-数-组-的-顺-序
function _G.CardSordFunc(cards)
    local sorted = {}
    for _, card in next, cards do sorted[#sorted + 1] = card end
    table.sort(sorted)
    return sorted
end

--取-整-运-算
function _G.MathFloor(num)
    return math.floor(num)
end
--输入的对应关系是
--大王小王 黑桃A红桃A草花A方片A 黑桃2红桃2草花2方片2 黑桃3红桃3草花3方片3 ...
--2   3     4    5    6   7     8    9   10   11    12   13   14  15

--内部的对应关系是,用于内部比较大小,绝对值系统.即2的绝对值要大于A的绝对值
--大王小王 黑桃2红桃2草花2方片2 黑桃A红桃A草花A方片A  黑桃3红桃3草花3方片3 黑桃4红桃4草花4方片4 ...
-- 65  64   60  61   62   63    56   57   58  59    12   13   14   15   16  17   18   19

--将-内-部-的绝-对-值-,修-改-成外-部-的-牌的-编-号
local function DDZunAbsoluteFunc(card)
    if card < 56 then
        return card
    elseif card > 55 and card < 64 then --输入的是2或者A
        return card - 52
    elseif card == 65 then --输入大王
        return 2
    elseif card == 64 then --输入小王
        return 3
    end
end


--将--内-部-的-绝-对-值-,全-部-修-改-成-外部-的-牌-的-编号
local function DDZunAbsoluteAllFunc(cards)--{54,65,55}
    local res = {}
    for i = #cards, 1, -1 do res[#res + 1] = DDZunAbsoluteFunc(cards[i]) end
    return res
end


--比-较-大-小-的函数
local function DDCompareBSFunc(a, b)
    return b < a
end


--将-外-部-数-据的-牌-编-号-,-变-成内-部-方-便-比-较-大-小的--绝对值
local function DDZAbsoluteFunc(card)
    if card > 11 then
        return card
    elseif card < 12 and card > 3 then --输入的是2或者A
        return card + 52
    elseif card == 2 then --输入大王
        return 65
    elseif card == 3 then --输入小王
        return 64
    end
end

--将-外-部-数-据-的牌-编-号-变-成内-部-方-便-比-较-大-小-的-绝-对值
local function DDZAbsoluteAllFunc(cards)
    local res = {}
    for _, card in next, cards do res[#res + 1] = DDZAbsoluteFunc(card) end
    return res
end

--是-不-是-三-张-牌
local function DDZIsThreeFunc(cards)
    if #cards == 3 then --3张
        local v1 = _G.MathFloor(cards[1]/4)
        local v2 = _G.MathFloor(cards[2]/4)
        local v3 = _G.MathFloor(cards[3]/4)
        if v1 == v2 and v2 == v3 then
            return true
        end
    end
end

--是-不--是-对-牌
local function DDZIsTwoCardFunc(cards)
    if #cards == 2 and _G.MathFloor(cards[1]/4) == _G.MathFloor(cards[2]/4) and cards[1] > 3 then
        return true
    end
end

--排-序,按-照-人-的习-惯
--由-于-牌-是按-照-2-55，黑-桃-红-桃草-花-方-片-排-序
--将-大-王-小王-黑-A-红-A-花-A方-A-黑-2红-2花2方2...的顺序-修改-成- -大王小王黑2红2花2方2黑A红A
local function DDZHumanSortCardFunc(cards)
    local absolutelies = DDZAbsoluteAllFunc(cards) -- 克隆并将输入的牌编号转换成绝对值
    table.sort(absolutelies) -- 从大到小的排序

    local sorted = DDZunAbsoluteAllFunc(absolutelies)
    return sorted
end

--判-断-是-不是-王-炸-弹
local function DDZIsKingBombFunc(cards)
    if #cards == 2 then --2张
        if (cards[1] == 2 and cards[2] == 3) or (cards[1] == 3 and cards[2] == 2) then
            return true
    end
    end
end

--是-否-为-普通-的-四-张-炸弹
local function DDZIsFourBombFunc(cards)
    if #cards == 4 then --4张
        for index = 1, 3 do
            if _G.MathFloor(cards[index]/4) ~= _G.MathFloor(cards[index+1]/4) then
                return
            end
    end
    return true
    end
end

--判-断-牌-是否-为-炸-弹
local function DDZIsBombFunc(cards)
    if DDZIsKingBombFunc(cards) or DDZIsFourBombFunc(cards) then
        return true
    end
end

--是-不-是-三-带-- 一
--@return --如果不是三带二,返回0
--如果是三带二,返回该三带二的绝对值,比如3335,返回3的内部绝对值
local function DDZIsThreePlusOneFunc(cards)
    local res = 0
    if #cards ~= 4 then return res end
    --先排序
    local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
    --222 3
    if _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[2]/4)==_G.MathFloor(tcards[3]/4) then
        res = _G.MathFloor(tcards[1]/4)
        --2 333
    elseif _G.MathFloor(tcards[2]/4)==_G.MathFloor(tcards[3]/4) and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4) then
        res = _G.MathFloor(tcards[2]/4)
    end

    return res
end

--是-不-是-三-带-二,
--@return 如果不是三带二,返回0.如果是三带二,返回该三带二的绝对值,比如33355,返回3的绝对值
local function DDZIsThreePlusTwoFunc(cards)
    local res = 0
    if #cards ~= 5 then return res end

    local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
    --333 22
    if((tcards[5] ~= 65 and tcards[5] ~= 64) --不能带对王
        and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[2]/4)==_G.MathFloor(tcards[3]/4)
        and _G.MathFloor(tcards[4]/4)==_G.MathFloor(tcards[5]/4)) then

        res = _G.MathFloor(tcards[1]/4)
        --22 333
    elseif ((tcards[5]~=65 and tcards[5]~=64) --不能带对王
        and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4) and _G.MathFloor(tcards[4]/4)==_G.MathFloor(tcards[5]/4)
        and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4)) then

        res = _G.MathFloor(tcards[3]/4)
    end

    return res
end

--是-不-是-顺-子
--@return 如-果-是顺-着,返-回该-顺-子-的-起始-牌-的-内部-绝-对值,否则返回0
local function DDZIsFloorFunc(cards)
    if #cards <= 4 then return 0 end

    local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
    --至少以3开始,以A结束
    if not (tcards[1]>11 and tcards[#tcards]<60) then return 0 end
    --前一张的除4余数和后一张的除4余数之差应该是1
    local card, nCard, dis
    for i = 1, #tcards-1 do
        local card = tcards[i]
        local nCard = tcards[i+1]
        local dis = _G.MathFloor(nCard/4) - _G.MathFloor(card/4)

        if dis~=1 then --不满足,直接跳出
            return 0
        end
    end
    return _G.MathFloor(tcards[1]/4)
end

--是不是三顺
--@return 如果是顺着,返回该顺子的起始牌的内部绝对值,否则返回0
local function DDZIsThreeFloorFunc(cards)
    if not (#cards > 5 and (#cards)%3 == 0) then return 0 end
    local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
    --至少以3开始,以A结束
    if not (tcards[1]>11 and tcards[#tcards]<60) then return 0 end
    --前一张的除4余数和后一张的除4余数之差应该是1
    -- 555 666 999
    -- 4,5,6,48,49,50,52,53,54,36,37,38
    -- 36,37,38,48,49,50,52,53,54,56,57,58
    local card, nCard, dis
    for index = 1, #tcards-3, 3 do
        local card = tcards[index]
        local nCard = tcards[index+3]
        local dis = _G.MathFloor(nCard/4) - _G.MathFloor(card/4)

        if dis ~= 1 then return 0 end

        if(_G.MathFloor(card/4)~=_G.MathFloor(tcards[index+1]/4) or _G.MathFloor(card/4)~=_G.MathFloor(tcards[index+2]/4)
            or _G.MathFloor(nCard/4)~=_G.MathFloor(tcards[index+4]/4) or _G.MathFloor(nCard/4)~=_G.MathFloor(tcards[index+5]/4)) then --必须成对
            return 0
        end
    end

    return _G.MathFloor(tcards[1]/4)
end

--是-不-是-双-顺
--@return 如-果-是顺-着-,-返-回该-顺-子的-起-始-牌-的内-部-绝-对-值,否则返回0
local function DDZIsTwoFloorFunc(cards)
    if not (#cards > 5 and (#cards)%2 == 0) then return 0 end
    --先排序,并转换成绝对值
    local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
    --至少以3开始,以A结束
    if not (tcards[1]>11 and tcards[#tcards]<60) then return 0 end
    --前一张的除4余数和后一张的除4余数之差应该是1
    local card, nCard, dis
    for i = 1, #tcards-2, 2 do
        local card = tcards[i]
        local nCard = tcards[i+2]
        local dis = _G.MathFloor(nCard/4) - _G.MathFloor(card/4)
        if dis~=1 then return 0 end

        if(_G.MathFloor(card/4) ~= _G.MathFloor(tcards[i+1]/4)
            or _G.MathFloor(nCard/4) ~= _G.MathFloor(tcards[i+3]/4)) then --必须成对
            return 0
        end
    end

    return _G.MathFloor(tcards[1]/4)
end

--是-不-是-飞-机,六-带-四,
--@return 如-果-符合-返-回开始-三-张牌-的-绝对--值,比如3334445566,返回3的绝-对值-,否-则-返-回0
local function DDZIsSixPlusFourFunc(cards)
    local l_iBegin = 0
    if #cards ~= 10 then return 0 end
    --先排序,并转换成绝对值
    local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
    --有3种模式,以第一张牌开始,以第三张牌开始,以第五张牌开始
    --333444 5555
    if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
        and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4) and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
        and tcards[6] < 60 -- 2和王是不能连的
        and (_G.MathFloor(tcards[4]/4) - _G.MathFloor(tcards[3]/4) == 1) --两个三张牌之间要相接
        and _G.MathFloor(tcards[7]/4)==_G.MathFloor(tcards[8]/4) and _G.MathFloor(tcards[9]/4)==_G.MathFloor(tcards[10]/4) and tcards[9] < 64) --剩下的要是两对,且不是王对
    then

        l_iBegin = _G.MathFloor(tcards[1]/4)
        --22 333444 55
    elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4) and  _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
        and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4) and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
        and tcards[8] < 60 -- 2和王是不能连的
        and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1) --两个三张牌之间要相接
        and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[9]/4)==_G.MathFloor(tcards[10]/4) and tcards[9] < 64)  --剩下的要是两对,且不是王对
    then

        l_iBegin = _G.MathFloor(tcards[3]/4)
        --AA22 333444
    elseif _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4) and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
        and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4) and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
        and tcards[10] < 60 -- 2和王是不能连的
        and (_G.MathFloor(tcards[8]/4) - _G.MathFloor(tcards[7]/4)) == 1 --两个三张牌之间要相接
        and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4) --剩下的要是两对
    then

        l_iBegin = _G.MathFloor(tcards[5]/4)
    end

    return l_iBegin
end

--是-不-是-飞机-,-九-带-六
--@return 如-果-符合-返-回-开-始-三张-牌-的-绝对-值,比如333444555678,返回3的绝对值,否则返回0
local function DDZIsNinePlusSixFunc(cards)
    local l_iBegin = 0
    if(#cards == 15 ) then --15张
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))

        --333444555 666677
        if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4) and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4) and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and tcards[9] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[4]/4) - _G.MathFloor(tcards[3]/4) == 1) and (_G.MathFloor(tcards[7]/4) - _G.MathFloor(tcards[6]/4) == 1) --两个三张牌之间要相接
            and _G.MathFloor(tcards[10]/4)==_G.MathFloor(tcards[11]/4) and _G.MathFloor(tcards[12]/4)==_G.MathFloor(tcards[13]/4)
            and _G.MathFloor(tcards[14]/4)==_G.MathFloor(tcards[15]/4) and tcards[15]<64 --剩下的要是两对,且不是王对
            ) then

            l_iBegin = _G.MathFloor(tcards[1]/4)
            --22 333444555 6666
        elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4) and  _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4) and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4) and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and tcards[11] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1)  and (_G.MathFloor(tcards[9]/4) - _G.MathFloor(tcards[8]/4) == 1)--两个三张牌之间要相接
            and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[12]/4)==_G.MathFloor(tcards[13]/4)
            and _G.MathFloor(tcards[14]/4)==_G.MathFloor(tcards[15]/4) and tcards[15]<64 --剩下的要是两对,且不是王对
            ) then

            l_iBegin = _G.MathFloor(tcards[3]/4)
            --2222 333444555 66
        elseif(_G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4) and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4) and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4) and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4)
            and tcards[13] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[8]/4) - _G.MathFloor(tcards[7]/4) == 1) and (_G.MathFloor(tcards[11]/4) - _G.MathFloor(tcards[10]/4) == 1) --两个三张牌之间要相接
            and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[14]/4)==_G.MathFloor(tcards[15]/4) and tcards[15]<64 --剩下的要是两对,且不是王对
            ) then

            l_iBegin = _G.MathFloor(tcards[5]/4)
            --223333 444555666
        elseif(_G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4) and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4) and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4) and _G.MathFloor(tcards[14]/4) == _G.MathFloor(tcards[15]/4)
            and tcards[15] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[10]/4) - _G.MathFloor(tcards[9]/4) == 1) and (_G.MathFloor(tcards[13]/4) - _G.MathFloor(tcards[12]/4) == 1) --两个三张牌之间要相接
            and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4)==_G.MathFloor(tcards[6]/4) --剩下的要是两对,且不是王对
            ) then

            l_iBegin = _G.MathFloor(tcards[7]/4)
        end
    end
    return l_iBegin
end

--是-不-是-带单-张-的-飞-机,九-带-三
--@return -如-果符-合-返-回开-始-三张-牌的-绝-对-值,比如333444555678,返回3的绝对值,否则返回0
local function DDZIsNinePlusThreeFunc(cards)
    local l_iBegin = 0
    if(#cards == 12 ) then --12张
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
        --333444555 666
        if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4) and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4) and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and tcards[9] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[4]/4) - _G.MathFloor(tcards[3]/4) == 1) and (_G.MathFloor(tcards[7]/4) - _G.MathFloor(tcards[6]/4) == 1) --三个三张牌之间要相接
            )then

            l_iBegin = _G.MathFloor(tcards[1]/4)
            --2 333444555 66
        elseif(_G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4) and  _G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4) and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4) and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and tcards[10] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[5]/4) - _G.MathFloor(tcards[4]/4) == 1) and _G.MathFloor(tcards[8]/4) - _G.MathFloor(tcards[7]/4) == 1  --三个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[2]/4)
            --22 333444555 6
        elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4) and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4) and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4) and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and tcards[11] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[9]/4) - _G.MathFloor(tcards[8]/4) == 1) and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1) --三个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[3]/4)
            --222 333444555
        elseif(_G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4) and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4) and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4) and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and tcards[12] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[7]/4) - _G.MathFloor(tcards[6]/4) == 1) and(_G.MathFloor(tcards[10]/4) - _G.MathFloor(tcards[9]/4) == 1) --三个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[4]/4)
        end
    end
    return l_iBegin
end

--是-不-是带-单-张-的飞-机,六带二
--@return 如果符合返回开始三张牌的绝对值,比如33344456,返回3的绝对值,否则返回0
local function DDZIsSixPlusTwoFunc(cards)
    local l_iBegin = 0
    if(#cards == 8) then --8张
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))

        --有3种模式,以第一张牌开始,以第三张牌开始,以第五张牌开始
        --333444 55
        if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4) and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and tcards[6] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[4]/4) - _G.MathFloor(tcards[3]/4) == 1) --两个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[1]/4)
            --2 333444 5
        elseif(_G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4) and  _G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4) and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and tcards[7] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[5]/4) - _G.MathFloor(tcards[4]/4) == 1) --两个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[2]/4)
            --22 333444
        elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4) and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4) and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and tcards[8] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1) --两个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[3]/4)
        end
    end
    return l_iBegin
end

--是-不-是四-代--两-张
--@return 返回-四张-的-内部-绝-对-值,比如444423,返回4的绝对值
local function DDZIsFourPlusTwoFunc(cards)
    local l_iBegin = 0
    if(#cards==6) then --6张
        --先排序
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
        local v1=_G.MathFloor(tcards[1]/4)
        local v2=_G.MathFloor(tcards[2]/4)
        local v3=_G.MathFloor(tcards[3]/4)
        local v4=_G.MathFloor(tcards[4]/4)
        local v5=_G.MathFloor(tcards[5]/4)
        local v6=_G.MathFloor(tcards[6]/4)
        -- 2222 33
        if(v1==v2 and v2==v3 and v3==v4) then
            l_iBegin = v1
            -- 2 3333 4
        elseif (v2==v3 and v3==v4 and v4==v5) then
            l_iBegin = v2
            -- 22 3333
        elseif (v3==v4 and v4==v5 and v5==v6) then
            l_iBegin = v3
        end
    end
    return l_iBegin
end

--四-带-二-有-三-种-模-式
--是-不-是四-带-四-对-
--@return 返-回-四张---的内-部绝-对-值,比如44442233,返回4的绝对值
local function DDZIsFourPlusFourFunc(cards)
    local l_iBegin = 0
    -- 四带二对
    if(#cards==8) then --8张
        --先排序
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))

        local v1=_G.MathFloor(tcards[1]/4)
        local v2=_G.MathFloor(tcards[2]/4)
        local v3=_G.MathFloor(tcards[3]/4)
        local v4=_G.MathFloor(tcards[4]/4)
        local v5=_G.MathFloor(tcards[5]/4)
        local v6=_G.MathFloor(tcards[6]/4)
        local v7=_G.MathFloor(tcards[7]/4)
        local v8=_G.MathFloor(tcards[8]/4)

        --3333 4455
        if((v1==v2 and v2==v3 and v3==v4 ) and tcards[8]<64) then --前4张相同
            if(v5==v6 and v6==v7 and v7==v8) then --后四张也相同
                l_iBegin = v5
        elseif(v5==v6 and v7==v8) then --后四张不同,但是是两对
            l_iBegin = v1
        end
        --33 4444 55
        elseif (v1==v2 and v3==v4 and v4==v5 and v5==v6 and v7==v8 and tcards[8]<64) then
            l_iBegin = v3
            --3344 5555
        elseif (v1==v2 and v3==v4 and v5==v6 and v6==v7 and v7==v8) then
            l_iBegin = v5
        end
    end

    return l_iBegin
end

--是-不-是-四-顺
--@return 如-果-是-顺-着-,返回-该-顺子-的-最-小起-始-牌-的-内部-绝-对-值-,否-则-返-回0；
local function DDZIsFourFloorFunc(cards)
    if(#cards > 7 and (#cards)%4 == 0) then --8张起连
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
        --至少以3开始,以A结束
        if(tcards[1]>11 and tcards[#tcards]<60) then
            --前一张的除4余数和后一张的除4余数之差应该是1
            -- 555 666 999
            -- 4,5,6,48,49,50,52,53,54,36,37,38
            -- 36,37,38,48,49,50,52,53,54,56,57,58
            for index=1,#tcards-4,4 do
                local card = tcards[index]
                local nextCard = tcards[index+4]
                local v = _G.MathFloor(nextCard/4) - _G.MathFloor(card/4)

                if(v~=1)then --不满足,直接跳出
                    return 0
                end

                if(_G.MathFloor(card/4)~=_G.MathFloor(tcards[index+1]/4)
                    or _G.MathFloor(card/4)~=_G.MathFloor(tcards[index+2]/4)
                    or _G.MathFloor(card/4)~=_G.MathFloor(tcards[index+3]/4)
                    or _G.MathFloor(nextCard/4)~=_G.MathFloor(tcards[index+5]/4)
                    or _G.MathFloor(nextCard/4)~=_G.MathFloor(tcards[index+6]/4)
                    or _G.MathFloor(nextCard/4)~=_G.MathFloor(tcards[index+7]/4)) then --必须成对
                    return 0
                end
            end
            return _G.MathFloor(tcards[1]/4)
        end
    end
    return 0
end

--是-不-是-8-带-4
--@return -返-回最-小-4-张-的内-部-绝-对值-,比如333344445678,返回3的绝对值,否则返回0；
local function DDZIsEightPlusFourFunc(cards)
    local l_iBegin = 0
    if(#cards == 8 ) then --8张
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))

        --有5种模式,以第一张牌开始,以第二张牌开始,以第三张牌开始,以第四张牌开始,以第五张牌开始
        --33334444 5566
        if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4)
            and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and tcards[8] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[5]/4) - _G.MathFloor(tcards[4]/4) == 1) --两个四张牌之间要相接
            ) then
            for i=9,11,1 do
                if _G.MathFloor(tcards[i]/4) ~= _G.MathFloor(tcards[i+1]/4) then
                    l_iBegin = _G.MathFloor(tcards[1]/4)
                end
            end
            --2 33334444 555
        elseif(_G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and tcards[9] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1) --两个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[2]/4)
            --22 33334444 55
        elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and tcards[10] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[7]/4) - _G.MathFloor(tcards[6]/4) == 1) --两个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[3]/4)
            --222 33334444 5
        elseif(_G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and tcards[11] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[8]/4) - _G.MathFloor(tcards[7]/4) == 1) --两个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[4]/4)
            --2222 33334444
        elseif(_G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[11]/4)
            and tcards[12] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[9]/4) - _G.MathFloor(tcards[8]/4) == 1) --两个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[5]/4)
        end
    end
    return l_iBegin
end

--是-不-是-12-带-4
--@return 返-回-最-小3-张-的-内-部绝-对-值,比如33344455566678910,返回3的绝对值,否则返回0；
local function DDZisTwelvePlusFourFunc(cards)
    local l_iBegin = 0
    if(#cards == 16 ) then --16张
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))

        --333444555666 78910
        if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4) and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4) and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4) and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4) and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and tcards[12] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[4]/4) - _G.MathFloor(tcards[3]/4) == 1)
            and (_G.MathFloor(tcards[7]/4) - _G.MathFloor(tcards[6]/4) == 1)
            and (_G.MathFloor(tcards[10]/4) - _G.MathFloor(tcards[9]/4) == 1)--四个三张牌之间要相接
            )then

            l_iBegin = _G.MathFloor(tcards[1]/4)
            --2 333444555666 789
        elseif(_G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4) and  _G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4) and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4) and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4) and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4)
            and tcards[13] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[5]/4) - _G.MathFloor(tcards[4]/4) == 1)
            and (_G.MathFloor(tcards[8]/4) - _G.MathFloor(tcards[7]/4) == 1)
            and (_G.MathFloor(tcards[11]/4) - _G.MathFloor(tcards[10]/4) == 1)--四个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[2]/4)
            --22 333444555666 89
        elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4) and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4) and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4) and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4) and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4)
            and tcards[14] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[9]/4) - _G.MathFloor(tcards[8]/4) == 1)
            and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1)
            and (_G.MathFloor(tcards[12]/4) - _G.MathFloor(tcards[11]/4) == 1)--四个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[3]/4)
            --222 333444555666 9
        elseif(_G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4) and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4) and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4) and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4) and _G.MathFloor(tcards[14]/4) == _G.MathFloor(tcards[15]/4)
            and tcards[15] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[7]/4) - _G.MathFloor(tcards[6]/4) == 1)
            and(_G.MathFloor(tcards[10]/4) - _G.MathFloor(tcards[9]/4) == 1)
            and(_G.MathFloor(tcards[13]/4) - _G.MathFloor(tcards[12]/4) == 1)--四个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[4]/4)
            --2222 333444555666
        elseif(_G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4) and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4) and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4) and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4)
            and _G.MathFloor(tcards[14]/4) == _G.MathFloor(tcards[15]/4) and _G.MathFloor(tcards[15]/4) == _G.MathFloor(tcards[16]/4)
            and tcards[16] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[8]/4) - _G.MathFloor(tcards[7]/4) == 1)
            and(_G.MathFloor(tcards[11]/4) - _G.MathFloor(tcards[10]/4) == 1)
            and(_G.MathFloor(tcards[14]/4) - _G.MathFloor(tcards[13]/4) == 1)--四个三张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[5]/4)
        end
    end
    return l_iBegin
end

--是-不-是-12-带6-
--@return 返回-最-小-4张-的-内-部绝-对-值-,比如-333344445555678910JQ,返回3的绝对值,否则返回0；；
local function DDZIsTwelvePlusSixFunc(cards)
    local l_iBegin = 0
    if(#cards == 18 ) then --18张
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
        --有7种模式,以第一张牌开始,以第二张牌开始,以第三张牌开始,以第四张牌开始,以第五张牌开始,以第六张牌开始，以第七张牌开始，
        --33334444555 666677
        if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4)
            and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and tcards[12] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[5]/4) - _G.MathFloor(tcards[4]/4) == 1)
            and (_G.MathFloor(tcards[9]/4) - _G.MathFloor(tcards[8]/4) == 1) --三个四张牌之间要相接
            ) then
            l_iBegin = _G.MathFloor(tcards[1]/4)
            --2 333344445555 66667
        elseif(_G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4)
            and tcards[13] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1)
            and (_G.MathFloor(tcards[10]/4) - _G.MathFloor(tcards[9]/4) == 1) --三个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[2]/4)
            --22 333344445555 6666
        elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4)
            and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4)
            and tcards[14] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[7]/4) - _G.MathFloor(tcards[6]/4) == 1)
            and (_G.MathFloor(tcards[11]/4) - _G.MathFloor(tcards[10]/4) == 1)--三个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[3]/4)
            --222 333344445555 666
        elseif(_G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4)
            and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4)
            and _G.MathFloor(tcards[14]/4) == _G.MathFloor(tcards[15]/4)
            and tcards[15] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[8]/4) - _G.MathFloor(tcards[7]/4) == 1)
            and (_G.MathFloor(tcards[12]/4) - _G.MathFloor(tcards[11]/4) == 1)--三个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[4]/4)
            --2222 333344445555 66
        elseif(_G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4)
            and _G.MathFloor(tcards[14]/4) == _G.MathFloor(tcards[15]/4)
            and _G.MathFloor(tcards[15]/4) == _G.MathFloor(tcards[16]/4)
            and tcards[16] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[9]/4) - _G.MathFloor(tcards[8]/4) == 1)
            and (_G.MathFloor(tcards[13]/4) - _G.MathFloor(tcards[12]/4) == 1)--三个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[5]/4)
            --A2222 333344445555 6
        elseif(_G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[14]/4) == _G.MathFloor(tcards[15]/4)
            and _G.MathFloor(tcards[15]/4) == _G.MathFloor(tcards[16]/4)
            and _G.MathFloor(tcards[16]/4) == _G.MathFloor(tcards[17]/4)
            and tcards[17] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[10]/4) - _G.MathFloor(tcards[9]/4) == 1)
            and (_G.MathFloor(tcards[14]/4) - _G.MathFloor(tcards[13]/4) == 1)--三个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[6]/4)
            --AA2222 333344445555
        elseif(_G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[15]/4) == _G.MathFloor(tcards[16]/4)
            and _G.MathFloor(tcards[16]/4) == _G.MathFloor(tcards[17]/4)
            and _G.MathFloor(tcards[17]/4) == _G.MathFloor(tcards[18]/4)
            and tcards[18] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[11]/4) - _G.MathFloor(tcards[10]/4) == 1)
            and (_G.MathFloor(tcards[15]/4) - _G.MathFloor(tcards[14]/4) == 1) --三个四张牌之间要相接
            ) then

            l_iBegin = _G.MathFloor(tcards[7]/4)
        end
    end
    return l_iBegin
end

--是-不-是-8-带-8
--@return 返回-最-小-4张-的-内-部-绝对-值,比如3333444455667788,返回3的绝对值,否则返回0；
local function DDZIsEightPlusEightFunc(cards)
    local l_iBegin = 0
    if(#cards == 16 ) then --16张
        --先排序,并转换成绝对值
        local tcards =  _G.CardSordFunc(DDZAbsoluteAllFunc(cards))
        --有5种模式,以第一张牌开始,以第三张牌开始,以第五张牌开始,以第七张牌开始,以第久张牌开始
        --33334444 55556666
        if(_G.MathFloor(tcards[1]/4) == _G.MathFloor(tcards[2]/4)
            and _G.MathFloor(tcards[2]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[3]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and tcards[8] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[5]/4) - _G.MathFloor(tcards[4]/4) == 1) --两个三张牌之间要相接
            and _G.MathFloor(tcards[7]/4)==_G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[9]/4)==_G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[11]/4)==_G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[13]/4)==_G.MathFloor(tcards[14]/4)
            and tcards[14] < 64 --剩下的要是四对,且不是王对
            ) then

            for i=10,14,4 do
                if _G.MathFloor(tcards[i]/4) ~= _G.MathFloor(tcards[i+1]/4) then
                    l_iBegin = _G.MathFloor(tcards[1]/4)
                end
            end

            --22 33334444 555566
        elseif(_G.MathFloor(tcards[3]/4) == _G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[4]/4) == _G.MathFloor(tcards[5]/4)
            and _G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and tcards[10] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[6]/4) - _G.MathFloor(tcards[5]/4) == 1) --两个三张牌之间要相接

            and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4)
            and _G.MathFloor(tcards[11]/4)==_G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[13]/4)==_G.MathFloor(tcards[14]/4)
            and _G.MathFloor(tcards[15]/4)==_G.MathFloor(tcards[16]/4)
            and tcards[16] < 64  --剩下的要是四对,且不是王对
            ) then

            l_iBegin = _G.MathFloor(tcards[3]/4)
            --AA22 33334444 5555
        elseif(_G.MathFloor(tcards[5]/4) == _G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[6]/4) == _G.MathFloor(tcards[7]/4)
            and _G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and tcards[12] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[9]/4) - _G.MathFloor(tcards[8]/4) == 1) --两个四张牌之间要相接
            and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4)
            and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[13]/4)==_G.MathFloor(tcards[14]/4)
            and _G.MathFloor(tcards[15]/4)==_G.MathFloor(tcards[16]/4)
            and tcards[16] < 64  --剩下的要是四对,且不是王对
            ) then
            l_iBegin = _G.MathFloor(tcards[5]/4)
            --AAAA22 33334444 55
        elseif(_G.MathFloor(tcards[7]/4) == _G.MathFloor(tcards[8]/4)
            and _G.MathFloor(tcards[8]/4) == _G.MathFloor(tcards[9]/4)
            and _G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[12]/4) == _G.MathFloor(tcards[13]/4)
            and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4)
            and tcards[14] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[11]/4) - _G.MathFloor(tcards[10]/4) == 1) --两个四张牌之间要相接
            and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4)
            and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4)==_G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[15]/4)==_G.MathFloor(tcards[16]/4)
            and tcards[16] < 64  --剩下的要是四对,且不是王对
            ) then
            l_iBegin = _G.MathFloor(tcards[7]/4)
            --AAAA2222 33334444
        elseif(_G.MathFloor(tcards[9]/4) == _G.MathFloor(tcards[10]/4)
            and _G.MathFloor(tcards[10]/4) == _G.MathFloor(tcards[11]/4)
            and _G.MathFloor(tcards[11]/4) == _G.MathFloor(tcards[12]/4)
            and _G.MathFloor(tcards[13]/4) == _G.MathFloor(tcards[14]/4)
            and _G.MathFloor(tcards[14]/4) == _G.MathFloor(tcards[15]/4)
            and _G.MathFloor(tcards[15]/4) == _G.MathFloor(tcards[16]/4)
            and tcards[16] < 60 -- 2和王是不能连的
            and (_G.MathFloor(tcards[13]/4) - _G.MathFloor(tcards[12]/4) == 1) --两个四张牌之间要相接
            and _G.MathFloor(tcards[1]/4)==_G.MathFloor(tcards[2]/4)
            and _G.MathFloor(tcards[3]/4)==_G.MathFloor(tcards[4]/4)
            and _G.MathFloor(tcards[5]/4)==_G.MathFloor(tcards[6]/4)
            and _G.MathFloor(tcards[7]/4)==_G.MathFloor(tcards[8]/4) --剩下的要是四对
            ) then
            l_iBegin = _G.MathFloor(tcards[9]/4)
        end

    end
    return l_iBegin
end

-- -默-认-是-生-产环-境-的-加载-方-式
--模--块-化-编程-，这-里是-放-暴露-给-外-部的-函-数-和变-量
_G.doudizhuGL={
    DDZHumanSortCardFunc = DDZHumanSortCardFunc,
    DDZIsBombFunc=DDZIsBombFunc,
    DDZAbsoluteFunc = DDZAbsoluteFunc,
    DDZAbsoluteAllFunc = DDZAbsoluteAllFunc,
    DDZunAbsoluteFunc = DDZunAbsoluteFunc,
    DDZunAbsoluteAllFunc = DDZunAbsoluteAllFunc,
    DDCompareBSFunc = DDCompareBSFunc,
    DDZIsTwoCardFunc = DDZIsTwoCardFunc,
    DDZIsThreeFunc = DDZIsThreeFunc,
    DDZIsFourBombFunc = DDZIsFourBombFunc,
    DDZIsKingBombFunc = DDZIsKingBombFunc,
    DDZIsThreePlusTwoFunc = DDZIsThreePlusTwoFunc,
    DDZIsThreePlusOneFunc = DDZIsThreePlusOneFunc,
    DDZIsFloorFunc = DDZIsFloorFunc,
    DDZIsTwoFloorFunc = DDZIsTwoFloorFunc,
    DDZIsThreeFloorFunc = DDZIsThreeFloorFunc,
    DDZIsSixPlusFourFunc = DDZIsSixPlusFourFunc,
    DDZIsSixPlusTwoFunc = DDZIsSixPlusTwoFunc,
    DDZIsNinePlusSixFunc = DDZIsNinePlusSixFunc,
    DDZIsNinePlusThreeFunc = DDZIsNinePlusThreeFunc,
    DDZIsFourPlusFourFunc = DDZIsFourPlusFourFunc,
    DDZIsFourPlusTwoFunc = DDZIsFourPlusTwoFunc,
    DDZIsFourFloorFunc = DDZIsFourFloorFunc,
    DDZisTwelvePlusFourFunc = DDZisTwelvePlusFourFunc,
    DDZIsEightPlusFourFunc = DDZIsEightPlusFourFunc,
    DDZIsEightPlusEightFunc = DDZIsEightPlusEightFunc,
    DDZIsTwelvePlusSixFunc = DDZIsTwelvePlusSixFunc,
}