--用于整理癞子逻辑

local l_LZLogicObj= import(".DdzLZLogicObject")
local l_PaiXing = import("..uiData.PokerType");

local CommonLgcObject = class("CommonLgcObject",function()
    return {}
end)

function CommonLgcObject:ctor()
       self.mTipsType=l_PaiXing.AUTO_CARD
end

--记-牌-器-用-于更-新-数据- -出牌-数-据-统-计
function CommonLgcObject:OutCountIndexFunction(aiPokers,aiPokers2)
    dump("OutCountIndexFunction")
    
    local l_index = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}   --3,4,5,6,7,8,9,10,J,Q,K,A,2,小王，大王
    local setOutCountIndexFunction = function(aiP)
        local num = #aiP
        for i = 1,num  do
           if type(aiP[i].CardValue) == "number" then
                if aiP[i].CardValue < 52 then
                    l_index[aiP[i].CardValue%13 + 1] = l_index[aiP[i].CardValue%13 + 1] + 1
                elseif aiP[i].CardValue == 52 then
                    l_index[14] = 1
                elseif aiP[i].CardValue == 53 then
                    l_index[15] = 1            
                end
           else
              local a = aiP[i].CardValue 
           end
        end
    end
    setOutCountIndexFunction(aiPokers)
    if aiPokers2 ~= nil then
        setOutCountIndexFunction(aiPokers2)        
    end
    return l_index
end

--设-置--牌-型---- 癞-子-玩-法有-可-能-几张-牌-有-多种-牌-型
function CommonLgcObject:SetTipsTypeFunction(aiParam)
    if aiParam == nil then
        self.mTipsType =l_PaiXing.AUTO_CARD
    else
        self.mTipsType = aiParam
    end
end

--验-证是-不-是王-炸
function CommonLgcObject:IsKingBombFunction(aiOutPokers)
    if (  #aiOutPokers == 2  and( ( aiOutPokers[1].CardValue == 52 and aiOutPokers[2].CardValue == 53 ) or ( aiOutPokers[2].CardValue == 52 and aiOutPokers[1].CardValue == 53 ) ) ) then
        return true
    else
        return false
    end
end

-- 固定一种类型
function CommonLgcObject:FixedPaixingFunc(lPaiXing, outPokersIndex, lengh, laiziNum)

    local tCardType = l_LZLogicObj:analyzeAirplaneFunc(outPokersIndex)
    if (lPaiXing == l_PaiXing.AUTO_CARD or lPaiXing == l_PaiXing.ERROR_CARD) then
        -- 自动类型的时候

        if l_LZLogicObj:LZIsLaiziListFunction(outPokersIndex, laiziNum) == true then
            -- 是否为癞子顺子
            self.mTipsType =(l_PaiXing.CONNECT_CARD)
            return self.mTipsType
        end

        return self:LaiziAirplaneTypeFunc(outPokersIndex, lengh, laiziNum)
    end

    if (lPaiXing == l_PaiXing.CONNECT_CARD) then
        if l_LZLogicObj:LZIsLaiziListFunction(outPokersIndex, laiziNum) == true then
            -- 是否为癞子顺子
            self.mTipsType =(l_PaiXing.CONNECT_CARD)
            return self.mTipsType
        end
    end

    if (lPaiXing == l_PaiXing.COMPANY_CARD) then
        if l_LZLogicObj:LZIsLaiziDoubleListFunction(outPokersIndex, laiziNum) == true then
            -- 是否为癞子连对
            self.mTipsType =(l_PaiXing.COMPANY_CARD)
            return self.mTipsType
        end
    end
   if (lPaiXing == l_PaiXing.THREE_TWO_CARD) then
        -- 三代二
        if l_LZLogicObj:LZIsThreeTwoCardFunction(tCardType, lengh, laiziNum) then
            self.mTipsType =(l_PaiXing.THREE_TWO_CARD)
            return self.mTipsType
        end
    end

    if (lPaiXing == l_PaiXing.BOMB_TWO_CARD) then
        -- 四带俩单张
        if l_LZLogicObj:LZIsFourTwoCard(tCardType, lengh, laiziNum) then
            self.mTipsType =(l_PaiXing.BOMB_TWO_CARD)
            return self.mTipsType
        end
    end

    if (lPaiXing == l_PaiXing.BOMB_TWOOO_CARD) then
        -- 四带俩对
        if l_LZLogicObj:LZIsFourTwoDoubleCardFunction(tCardType, lengh, laiziNum) then
            self.mTipsType =(l_PaiXing.BOMB_TWOOO_CARD)
            return self.mTipsType
        end
    end

    if (lPaiXing == l_PaiXing.AIRCRAFT_CARD) then
        -- 飞机不带
        if l_LZLogicObj:LZLaiziAircraftCardFunction(outPokersIndex, lengh, laiziNum) then
            self.mTipsType =(l_PaiXing.AIRCRAFT_CARD)
            return self.mTipsType
        end
    end

    if (lPaiXing == l_PaiXing.AIRCRAFT_SINGLE_CARD) then
        -- 飞机带单
        if l_LZLogicObj:LZLaiziAircraftSingleCardFunction(outPokersIndex, lengh, laiziNum, 1) then
            self.mTipsType =(l_PaiXing.AIRCRAFT_SINGLE_CARD)
            return self.mTipsType
        end
    end


    if (lPaiXing == l_PaiXing.AIRCRAFT_DOBULE_CARD) then
        -- 飞机带对
        if l_LZLogicObj:LZLaiziAircraftSingleCardFunction(outPokersIndex, lengh, laiziNum, 2) then
            self.mTipsType =(l_PaiXing.AIRCRAFT_DOBULE_CARD)
            return self.mTipsType
        end
    end
    self.mTipsType = l_PaiXing.ERROR_CARD
    return self.mTipsType

end

-- 小-于-五-张-牌-的情-况-下-拍-段-牌-型
function CommonLgcObject:LessFiveCardFunction(ChupaiData)

        if #ChupaiData == 1 then
                if ChupaiData[1].num == 1 then
                    self.mTipsType =(l_PaiXing.SINGLE_CARD)
                    return self.mTipsType
                elseif ChupaiData[1].num == 2 then
                    if ChupaiData[1].arr[1].CardValue == 52 or ChupaiData[1].arr[1].CardValue == 53 then
                        self.mTipsType =(l_PaiXing.ROCKET_CARD)
                        return self.mTipsType
                    else
                        self.mTipsType =(l_PaiXing.DOUBLE_CARD)
                        return self.mTipsType
                    end
                elseif ChupaiData[1].num == 3 then
                    self.mTipsType =(l_PaiXing.THREE_CARD)
                    return self.mTipsType
                elseif ChupaiData[1].num == 4 then
                    if ChupaiData[1].is_Laizigou == true then
                        self.mTipsType =(l_PaiXing.LAIZI_BOMB_CARD)
                    else
                        self.mTipsType =(l_PaiXing.BOMB_CARD)
                    end

                    return self.mTipsType
                end
        elseif #ChupaiData == 2 then
                -- is_Laizigou--癞子的属性标记--四张内分牌方法
                if (ChupaiData[1].num == 3 and ChupaiData[2].num == 1)
                    or(ChupaiData[1].num == 1 and ChupaiData[2].num == 3) then
                        if (ChupaiData[1].is_Laizigou == true or ChupaiData[2].is_Laizigou == true)and(ChupaiData[1].card_NO <13 and ChupaiData[2].card_NO <13   )  then
                            self.mTipsType =(l_PaiXing.SOFT_BOMB_CARD)
                            return self.mTipsType
                        end
                        self.mTipsType =(l_PaiXing.THREE_ONE_CARD)
                        return self.mTipsType
                elseif (ChupaiData[1].num == 1 and ChupaiData[2].num == 1)and (ChupaiData[1].arr[1].CardValue < 52 and  ChupaiData[2].arr[1].CardValue < 52)
                    and(ChupaiData[1].is_Laizigou == true  or ChupaiData[2].is_Laizigou == true) then
                    -- 一张单牌和一张癞子牌
                    self.mTipsType =(l_PaiXing.DOUBLE_CARD)
                    return self.mTipsType
                elseif (((ChupaiData[1].num == 2 and ChupaiData[2].num == 1)
                    or(ChupaiData[1].num == 1 and ChupaiData[2].num == 2))
                    and(ChupaiData[1].is_Laizigou == true or ChupaiData[2].is_Laizigou == true)) then
                    -- 三不带
                    self.mTipsType =(l_PaiXing.THREE_CARD)
                    return self.mTipsType

                elseif (((ChupaiData[1].num == 2 and ChupaiData[2].num == 2)
                    or(ChupaiData[1].num == 2 and ChupaiData[2].num == 2))
                    and(ChupaiData[1].is_Laizigou == true or ChupaiData[2].is_Laizigou == true)) then
                    -- 炸弹
                    self.mTipsType =(l_PaiXing.SOFT_BOMB_CARD)
                    return self.mTipsType
                else
                    self.mTipsType = l_PaiXing.ERROR_CARD
                    return self.mTipsType
                end
        elseif #ChupaiData == 3 then
                -- 判断是不是三带一
                if ((ChupaiData[1].num == 2 and ChupaiData[2].num == 1) or
                    (ChupaiData[2].num == 2 and ChupaiData[3].num == 1) or
                    (ChupaiData[3].num == 2 and ChupaiData[1].num == 1) and
                    ChupaiData[1].is_Laizigou == true or ChupaiData[2].is_Laizigou == true or ChupaiData[3].is_Laizigou == true) then
                    self.mTipsType = l_PaiXing.THREE_ONE_CARD
                    return self.mTipsType
                end
        else
                self.mTipsType = l_PaiXing.ERROR_CARD
                return self.mTipsType
        end

                self.mTipsType = l_PaiXing.ERROR_CARD
                return self.mTipsType
end

function CommonLgcObject:ShowCardsFunction( LaiziPoker, mCardType,cards, showTable)
    local mshowTable = { }
    local result = { }
    local pType = mCardType
    local length = 0 --有效的牌型--主体牌值飞机中，三的个数
    local mainPoker =0

    if pType == l_PaiXing.SINGLE_CARD then
        length = #showTable / 1
        mainPoker=1
    elseif pType == l_PaiXing.DOUBLE_CARD then
        length = #showTable / 2
        mainPoker=2
    elseif pType == l_PaiXing.THREE_CARD then
        length = #showTable / 3
        mainPoker=3
    elseif pType == l_PaiXing.THREE_ONE_CARD then
        length = #showTable / 4
        mainPoker=3
    elseif pType == l_PaiXing.THREE_TWO_CARD then
        length = #showTable / 5
        mainPoker=3
    elseif pType == l_PaiXing.BOMB_TWO_CARD then
        length = #showTable / 6
        mainPoker=4
    elseif pType == l_PaiXing.BOMB_TWOOO_CARD then
        length = #showTable / 8
        mainPoker=4
    elseif pType == l_PaiXing.CONNECT_CARD then
        length = #showTable / 1
        mainPoker=1
    elseif pType == l_PaiXing.COMPANY_CARD then
        length = #showTable / 2
        mainPoker=2
    elseif pType == l_PaiXing.AIRCRAFT_CARD then
        length = #showTable / 3
        mainPoker=3
    elseif pType == l_PaiXing.AIRCRAFT_SINGLE_CARD then
        length = #showTable / 4
        mainPoker=3
    elseif pType == l_PaiXing.AIRCRAFT_DOBULE_CARD then
        length = #showTable / 5
        mainPoker=3
    elseif pType == l_PaiXing.BOMB_CARD then
        length = #showTable / 4
        mainPoker=4
    elseif pType == l_PaiXing.SOFT_BOMB_CARD then
        length = #showTable / 4
        mainPoker=4
    elseif pType == l_PaiXing.LAIZI_BOMB_CARD then
        length = #showTable / 4
        mainPoker=4
    end

    if showTable == nil or #showTable ~= #cards then
        return result
    end


    for i = 1, #showTable do
        table.insert(mshowTable, { ["CardValue"] = showTable[i] })
    end

    if pType ==l_PaiXing.CONNECT_CARD or  pType ==l_PaiXing.COMPANY_CARD  then
        return mshowTable
    end
    local laizi_num = 0

    local mcards = self:OutCardSortFunction(cards, LaiziPoker)
    local mshowPoker = self:OutCardSortFunction(mshowTable, LaiziPoker)

    for tem1 = 1, #mshowPoker do
        for tem2 = 1, #mshowPoker - 1 do
            if mshowPoker[tem2].num < mshowPoker[tem2 + 1].num then
                local temp = mshowPoker[tem2]
                mshowPoker[tem2] = mshowPoker[tem2 + 1]
                mshowPoker[tem2 + 1] = temp
            end
        end
    end

    
    for n1 = 1, #mcards do
        if mcards[n1].card_NO >= 0 and mcards[n1].card_NO == LaiziPoker then
            local t = mcards[n1]
            mcards[n1] = mcards[#mcards]
            mcards[#mcards] = t
        end
    end
    
    for tem1 = 1, #mcards-1 do
        for tem2 = 1, #mcards - 2 do
            if mcards[tem2].num < mcards[tem2 + 1].num then
                local temp = mcards[tem2]
                mcards[tem2] = mcards[tem2 + 1]
                mcards[tem2 + 1] = temp
            end
        end
    end
    

local zongLength =0

    for i = 1, #mcards do
        if mcards[i].is_Laizigou == true then
            laizi_num = mcards[i].num
        end
        zongLength=zongLength+mcards[i].num
    end

    for j =1, #mcards  do
        if mcards[j].card_NO > 12 and laizi_num ==0  then 
           return result -- 用于处理没有癞子牌的情况
       end
    end
    
    if laizi_num == zongLength then
        for i=1,#cards do
            table.insert(result, { ["CardValue"] = cards[i].CardValue%13 })
        end
      return result
    end


    for k1 = 1, length do  
        for k2 = 1, #mcards do
            if mcards[k2].card_NO >= 0 and mshowPoker[k1].card_NO == mcards[k2].card_NO then

                if mainPoker >= mcards[k2].num then
                    laizi_num = laizi_num -(mainPoker-mcards[k2].num )
                end

                if LaiziPoker == mcards[k2].card_NO then-- 如果癞子作为本身了，则减去癞子牌
                   laizi_num=laizi_num- mainPoker
                end

                for i = 1, mainPoker  do
                    table.insert(result, { ["CardValue"] = mcards[k2].card_NO })
                end

               for t1 = 1, #mcards do
                    if mcards[t1].is_Laizigou == true then
                        mcards[t1].num  = laizi_num
                    end
                end
                if LaiziPoker ~= mcards[k2].card_NO then -- 防止癞子作为本身的时候重复
                    mcards[k2].num =  mcards[k2].num - mainPoker
                end

                if (mcards[k2].num) <= 0 then
                    mcards[k2].card_NO = -1
                end
               
                mshowPoker[k1].num=mshowPoker[k1].num- mainPoker

                if mshowPoker[k1].num< 0 then
                   mshowPoker[k1].card_NO = -1
                end


                for t1 = 1, #mcards do
                    if mcards[t1].is_Laizigou == true and laizi_num <= 0 then
                        mcards[t1].card_NO = -1
                    end
                end
            end
        end
    end

        for k1 = 1, length do   -- 处理癞子弥补一个全花色的情况
            if mshowPoker[k1].num ==mainPoker and  mshowPoker[k1].num <= laizi_num  then  -- 如果剩余的牌中有一个没有匹配的
                laizi_num = laizi_num -mshowPoker[k1].num
                mshowPoker[k1].num= mshowPoker[k1].num - mainPoker
                for i = 1, mainPoker  do
                    table.insert(result, { ["CardValue"] = mshowPoker[k1].card_NO })
                end

                for t1 = 1, #mcards do
                    if mcards[t1].is_Laizigou == true then
                        mcards[t1].num  = laizi_num
                    end
                end

            end
        end


    for m1 = 1, #mshowPoker do
        if mshowPoker[m1].card_NO >= 0 then
            mshowPoker[m1].card_NO = -1
            for m2 = 1, #mcards do
                if mshowPoker[m1].num == 1  then
                    if mcards[m2].num >= 1 and mcards[m2].card_NO>=0 then
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        mcards[m2].num=mcards[m2].num-1
                        break
                    end
                elseif mshowPoker[m1].num == 2 then

                    if mcards[m2].num >= 2 and mcards[m2].card_NO>=0 then
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        mcards[m2].num=mcards[m2].num-2
                        break
                    elseif mcards[m2].num ==1 and laizi_num >0  then 
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        mcards[m2].num=mcards[m2].num-1
                        laizi_num = laizi_num -1
                        mcards[#mcards].num= laizi_num
                    end

                elseif mshowPoker[m1].num == 3 then

                    if mcards[m2].num >= 3 and mcards[m2].card_NO>=0 then
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        mcards[m2].num=mcards[m2].num-3
                        break
                    end
                elseif mshowPoker[m1].num == 4 then

                    if mcards[m2].num == 4 and mcards[m2].card_NO>=0 then
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        table.insert(result, { ["CardValue"] = mcards[m2].card_NO })
                        mcards[m2].num=mcards[m2].num-4
                        break
                    end
                end

               if (mcards[m2].num) <= 0 then
                    mcards[m2].card_NO = -1
                end
               for t1 = 1, #mcards do
                    if mcards[t1].is_Laizigou == true and laizi_num <= 0 then
                        mcards[t1].card_NO = -1
                        mcards[t1].num =-1
                    end
                end

            end

        end
    end

    for i=1,#mcards do  -- 为了极限情况，当四个炸弹连出的情况下，
        if mcards[i].num >0 and mcards[i].card_NO >=0 then
           for j=1, mcards[i].num  do
               table.insert(result, { ["CardValue"] = mcards[i].card_NO })
           end
        end
    end
    return result

end


function CommonLgcObject:NotLaiziPaixingFunc(ChupaiData)
            if self:IsListFunc(ChupaiData) == true then
                self.mTipsType =(l_PaiXing.CONNECT_CARD)
                return  self.mTipsType
            end
            -- 判断连对
            if self:isDoubleListFunc(ChupaiData) == true then
                self.mTipsType =(l_PaiXing.COMPANY_CARD)
                return  self.mTipsType
            end
            -- 判断飞机类型  返回飞机类型
            return self:AirplaneTypeFunc(ChupaiData)
end

-- 对出的牌 排序
function CommonLgcObject:OutCardSortFunction(aiOutPokers,LaiziCard) --牌型排序
    -- 存放 PokerCount
    local ChupaiData = clone(aiOutPokers )
    local tCount = #ChupaiData;
    local t = { }
    if tCount <= 0 then
        print("没有玩家管自己的牌，自己随便出")
        return clone(t)
    end

    for index = 1, tCount do
        if ChupaiData[index] ~= nil then
            -- 记数 排序出的牌用
            local PokerCount =
            {
                card_NO = - 1,-- 牌值
                num = 0,-- 牌数量
                is_Laizigou = false,--是否是癞子牌
                arr = { }-- 集合牌
            }
            local poker = ChupaiData[index]
            ChupaiData[index] = nil
            PokerCount.num = 1
            if poker.CardValue>=52 then
                PokerCount.card_NO = poker.CardValue - 39
            else
                PokerCount.card_NO = poker.CardValue % 13
            end
            if PokerCount.card_NO == LaiziCard then --
               PokerCount.is_Laizigou = true      -- 非癞子玩法的时候不能有癞子牌
            end
            table.insert(PokerCount.arr, poker)
            --判断剩余的牌是否有跟他相同牌值的
            for k, v in pairs(ChupaiData) do
                if v ~= nil then
                    local poker1 = v
                    if poker.CardValue>=52 and poker1.CardValue>=52 then
                        -- 判断是不是王
                        ChupaiData[k] = nil
                        PokerCount.num = PokerCount.num + 1
                        table.insert(PokerCount.arr, poker1)
                    elseif poker.CardValue<52 and poker1.CardValue < 52 and poker1.CardValue % 13 == poker.CardValue % 13 then
                        ChupaiData[k] = nil
                        PokerCount.num = PokerCount.num + 1
                        table.insert(PokerCount.arr, poker1)
                    end
                end
            end
            table.insert(t, PokerCount)
        end
    end

    local length = #t
    if length > 1 then
        -- 对t进行排序，按牌值从小到大排序
        for i = 1, length do
            for j = 1, length - i do
                if t[j].card_NO > t[j + 1].card_NO then
                    local temp = t[j];
                    t[j] = t[j + 1]
                    t[j + 1] = temp
                end
            end
        end
        -- 按牌的数量从小到大再排一次
        for i = 1, length do
            for j = 1, length - i do
                if t[j].num > t[j + 1].num then
                    local temp = t[j];
                    t[j] = t[j + 1]
                    t[j + 1] = temp
                end
            end
        end
    end
    -- 将排序好的牌重新放入 出牌列表（ChupaiData） 中
    return  clone(t)
end

-- aiOutPokersIndex 最后一手有效牌值
--l_PaiXing 最后一手牌的牌型
function CommonLgcObject:MatchCardTypeFunction(aiOutPokersIndex,LaiziCard,lPaiXing)
    -- 牌桌内，牌型判断
  local   outPokersIndex = self:OutCardSortFunction(aiOutPokersIndex,LaiziCard)
    -- 对拍进行排序，如果牌相同则num为当前牌的个数
    local lengh = 0

    if lPaiXing == nil  then
       lPaiXing = 0 
    end

    self.mTipsType = l_PaiXing.AUTO_CARD
    -- 癞子玩法有可能几张牌有多种牌型,先清空牌型
    for index = 1, #outPokersIndex do 
        lengh = lengh + outPokersIndex[index].num
    end

    -- 牌的张数少于5张类型判断
    if lengh < 5 and lengh > 0 then
        return self:LessFiveCardFunction(outPokersIndex)
    end

    -- 牌的张数大于等于5张的类型判断
    if lengh >= 5 then
        local laizi_Num = 0
        -- 检查癞子的个数
        for index = 1, #outPokersIndex do
            if (outPokersIndex[index].is_Laizigou == true) then
                laizi_Num = outPokersIndex[index].num
            end
        end


        if laizi_Num == 0 then
            -- 正常牌型
            -- 是否为连牌牌型（单）
            return self:NotLaiziPaixingFunc(outPokersIndex)

        else  -- 确定类型的时候--为了解决同一手牌有多重牌型的
            return self:FixedPaixingFunc(lPaiXing, outPokersIndex, lengh, laizi_Num)
        end
    end
    
   self.mTipsType = l_PaiXing.ERROR_CARD
    return self.mTipsType
end

-------------------------------------------常规牌桌的判断牌型-------------------------------------------------
-- 判断是不是连对
function CommonLgcObject:isDoubleListFunc(aiOutPokersIndex)
    local outPokersIndex = aiOutPokersIndex
    local lengh = #outPokersIndex
    for index = 1, lengh do
        if outPokersIndex[index].card_NO >= 12 or lengh < 3 then
            -- 有2直接返回 不是连对
            return false
        end
    end
    -- 必须是连续的（前一张牌值加1是否等于后隔一张牌值）
    for index = 1, lengh - 1 do
        if (outPokersIndex[index].card_NO + 1) ~= outPokersIndex[index + 1].card_NO or outPokersIndex[index].num ~= 2 or outPokersIndex[index + 1].num ~= 2 then
            return false
        end
    end
    return true
end

-- 判断是不是顺子
function CommonLgcObject:IsListFunc(aiOutPokersIndex)
    local outPokersIndex = aiOutPokersIndex
    local lengh = #outPokersIndex
    if outPokersIndex[lengh].card_NO >= 12 or lengh < 5 then
        -- 有2直接返回 不是链子
        return false
    end
    -- 必须是连续的（前一张牌值加1是否等于后一张牌值）
    for index = 1, lengh - 1 do
        if (outPokersIndex[index].card_NO + 1) ~= outPokersIndex[index + 1].card_NO or outPokersIndex[index + 1].num ~= 1 or outPokersIndex[index].num ~= 1 then
            return false
        end
    end
    return true
end

-- 分析牌是否是飞机
function CommonLgcObject:analyzeAirplaneFunc(aiOutPokersIndex)
    local tCardType = {
        -- 分析飞机
        single = { },
        -- 单张
        duble = { },
        -- 对
        three = { },
        -- 三张
        four = { }-- 四张
    }
    local outPokersIndex = aiOutPokersIndex
    local lengh = #outPokersIndex

    for index = 1, lengh do
        if outPokersIndex[index].num == 1 then
            table.insert(tCardType.single, outPokersIndex[index])
        elseif outPokersIndex[index].num == 2 then
            table.insert(tCardType.duble, outPokersIndex[index])
        elseif outPokersIndex[index].num == 3 then
            table.insert(tCardType.three, outPokersIndex[index])
        elseif outPokersIndex[index].num == 4 then
            table.insert(tCardType.four, outPokersIndex[index])
        end
    end
    return tCardType
end

-- 判断是不是飞机 返回飞机类型
function CommonLgcObject:AirplaneTypeFunc(aiOutPokersIndex)
    local outPokersIndex = aiOutPokersIndex
    local lengh = 0
    for index = 1, #outPokersIndex do
        lengh = lengh + outPokersIndex[index].num
    end
    -- 分析牌是否是飞机
    local tCardType = self:analyzeAirplaneFunc(aiOutPokersIndex)
    -- 判断三带二
    if #tCardType.three == 1 and #tCardType.duble == 1 and(#tCardType.three * 3) +(#tCardType.duble * 2) == lengh then
        self.mTipsType =(l_PaiXing.THREE_TWO_CARD)
        return  self.mTipsType
    end
    -- 判断四带
    if #tCardType.three <= 0 and #tCardType.four == 1 and lengh % 2 == 0 then
        -- 四带两张不一样的单牌
        if #tCardType.four == 1 and #tCardType.single == 2 and(#tCardType.four * 4 + #tCardType.single) == lengh then
            self.mTipsType =(l_PaiXing.BOMB_TWO_CARD)
            return  self.mTipsType
        end
        -- 四带两张一样的单牌
        if #tCardType.four == 1 and #tCardType.duble == 1 and(#tCardType.four * 4 + #tCardType.duble * 2) == lengh then
            self.mTipsType =(l_PaiXing.BOMB_TWO_CARD)
            return  self.mTipsType
        end
        -- 四带对
        if #tCardType.four == 1 and #tCardType.duble == 2 and(#tCardType.four * 4 + #tCardType.duble * 2) == lengh then
            self.mTipsType =(l_PaiXing.BOMB_TWOOO_CARD)
            return  self.mTipsType
        end
    end
    -- 判断飞机
    if #tCardType.four==0 then
        local num,num1 = self:IsAirphaneListByThreeFunc(aiOutPokersIndex)
        if num1 ==0  then
            --判断飞机不带
            if #tCardType.three * 3 == lengh and(#tCardType.duble + #tCardType.single) == 0 then
                self.mTipsType =(l_PaiXing.AIRCRAFT_CARD)
                return  self.mTipsType
            --判断飞机带单包括（对拆单,3个拆单）
            elseif (#tCardType.three==(#tCardType.single+#tCardType.duble*2)) or
                (#tCardType.three-1==(#tCardType.single+#tCardType.duble*2+3))  then
               
                self.mTipsType =(l_PaiXing.AIRCRAFT_SINGLE_CARD)
                return  self.mTipsType
            --判断飞机带对
            elseif #tCardType.three==#tCardType.duble and #tCardType.single == 0 then
                self.mTipsType =(l_PaiXing.AIRCRAFT_DOBULE_CARD)
                return  self.mTipsType
            else
                self.mTipsType = l_PaiXing.ERROR_CARD
                return  self.mTipsType
            end
        elseif (num1*3+#tCardType.single+#tCardType.duble*2)==num then
            self.mTipsType =(l_PaiXing.AIRCRAFT_SINGLE_CARD)
            return  self.mTipsType
        else
            self.mTipsType = l_PaiXing.ERROR_CARD
            return  self.mTipsType
        end
    else
        local numberT,numberT1,fourNum,tempFlag = self:isAirphaneListByFourFunc(outPokersIndex)
        if numberT1==0 then
            --判断飞机带单包括（对拆单）
            if (#tCardType.three==(#tCardType.single+#tCardType.duble*2)and #tCardType.three > 1) or -- 如果一个三和一个炸弹出牌的话，容易误判所以要加上三的个数大于一，如果是连出的话是一定大于一的
                (tempFlag and #tCardType.three==(#tCardType.single+#tCardType.duble*2+4)) or
                (#tCardType.three-1==(#tCardType.single+#tCardType.duble*2+3)) then
                self.mTipsType =(l_PaiXing.AIRCRAFT_SINGLE_CARD)
                return  self.mTipsType
            --判断飞机带对包括（炸弹拆对）
            elseif tempFlag and #tCardType.three==#tCardType.duble+#tCardType.four*2 and #tCardType.single == 0 then
                self.mTipsType =(l_PaiXing.AIRCRAFT_DOBULE_CARD)
                return  self.mTipsType
            else
                self.mTipsType = l_PaiXing.ERROR_CARD
                return  self.mTipsType
            end
        elseif numberT1==1 then
            if fourNum==#tCardType.four then
                if (#tCardType.three-1==(#tCardType.single+#tCardType.duble*2+3)) then
                    self.mTipsType =(l_PaiXing.AIRCRAFT_SINGLE_CARD)
                    return  self.mTipsType
                else
                    self.mTipsType =(l_PaiXing.ERROR_CARD)
                    return  self.mTipsType
                end
            elseif fourNum+1==#tCardType.four then   
                 if (#tCardType.three==(#tCardType.single+#tCardType.duble*2+4)) then
                    self.mTipsType =(l_PaiXing.AIRCRAFT_SINGLE_CARD)
                    return  self.mTipsType
                elseif (fourNum == 0 and #tCardType.three==(#tCardType.duble+2) and #tCardType.single==0) or
                    (fourNum == 1 and tempFlag and #tCardType.three==(#tCardType.duble+4) and #tCardType.single==0) then
                    self.mTipsType =(l_PaiXing.AIRCRAFT_DOBULE_CARD)
                    return  self.mTipsType
                else
                    self.mTipsType= l_PaiXing.ERROR_CARD
                    return  self.mTipsType
                end
            end
        elseif numberT1==2 then
            if fourNum==0 and #tCardType.four==2 and #tCardType.three==4 and #tCardType.single==0 and #tCardType.duble==0 then
                self.mTipsType =(l_PaiXing.AIRCRAFT_DOBULE_CARD)
                return  self.mTipsType
            else
                self.mTipsType = l_PaiXing.ERROR_CARD
                return  self.mTipsType
            end
        else
            self.mTipsType = l_PaiXing.ERROR_CARD
            return  self.mTipsType
        end
    end
    self.mTipsType = l_PaiXing.ERROR_CARD
    return self.mTipsType
end
-- 判断飞机返回连续数量、不连续数量、连续数量中炸弹的数量和炸弹是否在序列的头或尾(包括炸弹的情况)
function CommonLgcObject:isAirphaneListByFourFunc(aiOutPokersIndex)
    local outPokersIndex = clone(aiOutPokersIndex);
    for i = 1, #outPokersIndex do
        for j = 1, #outPokersIndex - i do
            if outPokersIndex[j].card_NO > outPokersIndex[j + 1].card_NO then
                local temp = outPokersIndex[j];
                outPokersIndex[j] = outPokersIndex[j + 1]
                outPokersIndex[j + 1] = temp
            end
        end
    end 
    local tempList = {}
    local tempNO = -1   --牌值
    local index = 1 --索引
    local num =0    --总数
    local tempoutPokers = {}
    for k,v in ipairs(outPokersIndex) do
        if v.num == 3 or v.num == 4 then
            if v.card_NO~=12 then
                table.insert(tempoutPokers,v)
                num = num+1
                if tempNO == -1 then
                    tempList[index]=1
                elseif tempNO+1==v.card_NO then
                    tempList[index]=tempList[index]+1
                else
                    index = index+1
                    tempList[index]=1
                end
                tempNO =v.card_NO
            end
        end
    end
    local tempNum=0
    local allNum=1
    local beginNum = 0
    for k,v in ipairs(tempList) do
        if tempNum<v then
            tempNum=v
            beginNum = allNum
        end
        allNum = allNum + v
    end
    local fourNum=0
    local flag = false
    for i=beginNum , beginNum+tempNum-1 do
        if tempoutPokers[i].num == 4 then
            fourNum=fourNum+1
            if i==beginNum or i==beginNum+tempNum-1 then
                flag = true
            end 
        end
    end
    return tempNum,num-tempNum,fourNum,flag
end
-- 判断飞机返回连续数量和不连续数量（不包括炸弹）
function CommonLgcObject:IsAirphaneListByThreeFunc(aiOutPokersIndex)
    local outPokersIndex = clone(aiOutPokersIndex);
    for i = 1, #outPokersIndex do
        for j = 1, #outPokersIndex - i do
            if outPokersIndex[j].card_NO > outPokersIndex[j + 1].card_NO then
                local temp = outPokersIndex[j];
                outPokersIndex[j] = outPokersIndex[j + 1]
                outPokersIndex[j + 1] = temp
            end
        end
    end 
    local tempList = {}
    local tempNO = -1   --牌值
    local index = 1 --索引
    local num =0    --总数
    for k,v in ipairs(outPokersIndex) do
        if v.num == 3 then
            num = num+1
            if v.card_NO~=12 then
                if tempNO == -1 then
                    tempList[index]=1
                elseif tempNO+1==v.card_NO then
                    tempList[index]=tempList[index]+1
                else
                    index = index+1
                    tempList[index]=1
                end
                tempNO =v.card_NO
            end
        end
    end

    local tempNum=0
    for k,v in ipairs(tempList) do
        if tempNum<v then
            tempNum=v
        end
    end
    return tempNum,num-tempNum
end

function CommonLgcObject:GetPokerDemoThreeFunc(aiType, length)
    -- 当上家不出牌的时候，默认出牌，不会有提示的情况下用默认的牌型来获取提示牌型
    -- 牌型
    -- 牌的长度
    local pType = aiType
    local damo = { }
    if pType == l_PaiXing.SINGLE_CARD then  --1
        for i = 1, length do
            table.insert(damo, { CardValue = 0 })
        end
    elseif pType == l_PaiXing.DOUBLE_CARD then  --2
        for i = 1, length do
            table.insert(damo, { CardValue = 0 })
        end
    elseif pType == l_PaiXing.THREE_CARD then --3
        for i = 1, length do
            table.insert(damo, { CardValue = 0 })
        end
    elseif pType == l_PaiXing.THREE_ONE_CARD then --4
        local num = length/4
        for i = 1, num do
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 1 })
        end

    elseif pType == l_PaiXing.THREE_TWO_CARD then  --5
        local num = length/5
        for i = 1, num do
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 1 })
            table.insert(damo, { CardValue = 1 })
        end
     elseif pType == l_PaiXing.BOMB_TWO_CARD then  --6
        local num = length/6
        for i = 1, num do
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 1 })
            table.insert(damo, { CardValue = 2 })

        end
            
    elseif pType == l_PaiXing.BOMB_TWOOO_CARD then -- 7
        local num = length/8
        for i = 1, num do
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 0 })
            table.insert(damo, { CardValue = 1 })
            table.insert(damo, { CardValue = 1 })
            table.insert(damo, { CardValue = 2 })
            table.insert(damo, { CardValue = 2 })
        end

    elseif pType == l_PaiXing.CONNECT_CARD then -- 8
        for i = 1, length do
            table.insert(damo, { CardValue = i-1 })
        end
    elseif pType == l_PaiXing.COMPANY_CARD then --9
        for i = 1, length/2 do
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo, { CardValue = i-1 })
        end
    elseif pType == l_PaiXing.AIRCRAFT_CARD then --10
    local num = length/3
        for i = 1, num do
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo, { CardValue = i-1 })
        end
    elseif pType == l_PaiXing.AIRCRAFT_SINGLE_CARD then --11
       local num = length/4
       local three ={}
       local one ={}
        for i = 1, num do
            table.insert(three, { CardValue = i-1 })
            table.insert(three, { CardValue = i-1 })
            table.insert(three, { CardValue = i-1 })
            table.insert(one,{ CardValue = num+i })
        end
        for i =1,#three do
           table.insert(damo, three[i])
        end
        
        for j =1,#one  do
          table.insert(damo, one[j])
        end
    elseif pType == l_PaiXing.AIRCRAFT_DOBULE_CARD then  --12
       local num = length/5
       local three ={}
       local double ={}
        for i = 1, num do
            table.insert(three, { CardValue = i-1 })
            table.insert(three, { CardValue = i-1 })
            table.insert(three, { CardValue = i-1 })
            table.insert(double,{ CardValue = 5+i })
            table.insert(double,{ CardValue = 5+i })
        end  
        for i =1,#three do
           table.insert(damo, three[i])
        end
        
        for j =1,#double  do
          table.insert(damo, double[j])
        end
    elseif pType == l_PaiXing.SOFT_BOMB_CARD then  --13
         for i = 1, length/4 do
            table.insert(damo, { CardValue = ui.CardTableDialog.hLaiziCard })
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo, { CardValue = i-1 })
        end
    elseif pType == l_PaiXing.BOMB_CARD then  --14
         for i = 1, length/4 do
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo, { CardValue = i-1 })
            table.insert(damo,{ CardValue = i-1 })
        end
    elseif pType == l_PaiXing.LAIZI_BOMB_CARD then  --15
         for i = 1, 4 do
            table.insert(damo, { CardValue =  ui.CardTableDialog.hLaiziCard})
        end
    end
    return  damo
end

function CommonLgcObject:DamoToTipFunction(l_PaiXing, damo)

    local tableType = l_LZLogicObj:CardTypeTable()
    tableType.Type = l_PaiXing
    tableType.Index = 0

    for i = 1, #damo do
        table.insert(tableType.Table, damo[i].CardValue)
        table.insert(tableType.ShowPoker, damo[i].CardValue % 13)
    end
    return tableType
end

--判-断-是-不是-癞-子-飞-机
function CommonLgcObject:LaiziAirplaneTypeFunc(aiOutPokersIndex,lengh,laiziNum)
 local outPokersIndex =l_LZLogicObj:LZSortAllCardFunction(aiOutPokersIndex)
    --牌型排序
    local tCardType = l_LZLogicObj:analyzeAirplaneFunc(aiOutPokersIndex)
    --三代二
    if l_LZLogicObj:LZIsThreeTwoCardFunction(tCardType,lengh,laiziNum) then
          self.mTipsType =(l_PaiXing.THREE_TWO_CARD)
          return  self.mTipsType
    end
    --四带俩单张
    if l_LZLogicObj:LZIsFourTwoCard(tCardType,lengh,laiziNum) then
          self.mTipsType =(l_PaiXing.BOMB_TWO_CARD)  
          return  self.mTipsType  
    end
    --四带俩对
    if l_LZLogicObj:LZIsFourTwoDoubleCardFunction(tCardType,lengh,laiziNum)then
         self.mTipsType =(l_PaiXing.BOMB_TWOOO_CARD) 
         return  self.mTipsType  
    end
    --飞机不带
    if l_LZLogicObj:LZLaiziAircraftCardFunction(outPokersIndex,lengh, laiziNum) then
        self.mTipsType =(l_PaiXing.AIRCRAFT_CARD)  
        return  self.mTipsType
    end

    if l_LZLogicObj:LZIsLaiziDoubleListFunction(outPokersIndex, laiziNum) == true then
            -- 是否为癞子连对
            self.mTipsType =(l_PaiXing.COMPANY_CARD)
            return self.mTipsType
    end

    --飞机带单
    if l_LZLogicObj:LZLaiziAircraftSingleCardFunction(outPokersIndex, lengh, laiziNum,1) then
       self.mTipsType =(l_PaiXing.AIRCRAFT_SINGLE_CARD)
       return  self.mTipsType
    end
    --飞机带对
    if l_LZLogicObj:LZLaiziAircraftSingleCardFunction(outPokersIndex, lengh, laiziNum,2) then
       self.mTipsType =(l_PaiXing.AIRCRAFT_DOBULE_CARD)
       return  self.mTipsType
    end
    self.mTipsType = l_PaiXing.ERROR_CARD
    return  self.mTipsType 
end
--------------------------------------癞子牌型判断over-----------------------------------------------------
----------------------------------------↓↓↓↓↓↓↓出牌提示↓↓↓↓↓↓----------------------------------------


--aiType    筛选的牌型
--aiTable   筛选的表 默认是自己整个手牌
--aiOutPokersIndex 最后时候出的有效牌值
--aiOutPokers       出的牌值
--Laizipoker  --癞子牌的编号
--在癞子牌型判断的时候原本的牌张数的的判定条件将根据癞子数量进行相应的调整
function CommonLgcObject:tipsFunction(aiType,aiTable,aiOutPokersIndex,aiOutPokers,Laizipoker)
    local outPokersIndex = self:OutCardSortFunction(aiOutPokersIndex)
    local pType = aiType
    local outPokers = {}
    local laizipoker = Laizipoker+1 
     local laizi_Num = 0
    --数组的编号是从1开始的因此会有一些不同
    if laizipoker ~= 0 then
        laizi_Num = aiTable[laizipoker][1] 
    end
    -- 出的牌

    if pType == l_PaiXing.ERROR_CARD then
        print("上家作弊！！！  牌型不能匹配。")
        outPokers = {}
    elseif pType == l_PaiXing.SINGLE_CARD then  --1
        outPokers =  l_LZLogicObj:LZGetLaiziSingleFunction(aiTable, outPokersIndex) or { } 
        a= outPokers
    elseif pType == l_PaiXing.DOUBLE_CARD then--2
        outPokers =  l_LZLogicObj:LZGetLaiziDoubleFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.THREE_CARD then --3
        outPokers = l_LZLogicObj:LZGetLaiziThreeFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.THREE_ONE_CARD then--4
        outPokers = l_LZLogicObj:LZGetLaiziThreeOneFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.THREE_TWO_CARD then--5
        outPokers = l_LZLogicObj:LZGetLaiziThreeTwoFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.BOMB_TWO_CARD then--6
        outPokers = l_LZLogicObj:LZGetLaiziBOMTwoFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.BOMB_TWOOO_CARD then--7
        outPokers = l_LZLogicObj:LZGetLaiziBOMTwooFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.CONNECT_CARD then--8
        outPokers = l_LZLogicObj:LZGetLaiziListFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.COMPANY_CARD then--9
        outPokers = l_LZLogicObj:LZGetLaiziDoubleListFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.AIRCRAFT_CARD then--10
        outPokers = l_LZLogicObj:LZGetLaiziAircraftFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.AIRCRAFT_SINGLE_CARD then--11
        outPokers = l_LZLogicObj:LZGetLaiziAircraftSingleFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.AIRCRAFT_DOBULE_CARD then--12
        outPokers = l_LZLogicObj:LZGetLaiziAircraftDoubleFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.SOFT_BOMB_CARD then--13
        outPokers = l_LZLogicObj:LZGetSoftBombFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.BOMB_CARD then--14
        outPokers = l_LZLogicObj:LZGetLaiziBombFunction(aiTable, outPokersIndex, laizi_Num, laizipoker) or { }
        a= outPokers
    elseif pType == l_PaiXing.LAIZI_BOMB_CARD then--15
        outPokers = l_LZLogicObj:LZGetKingBombFunction(aiTable) or { }
    elseif  pType == l_PaiXing.AUTO_CARD  then   --预留首轮出牌提示
        self:SlipTipsFunc(aiTable,outPokersIndex,aiOutPokers)
        return
    end
    if pType < l_PaiXing.SOFT_BOMB_CARD then  --小于13
        local bomb = l_LZLogicObj:LZGetLaizuiAllBombFunction(aiTable, laizi_Num, laizipoker)
        for index = 1, #bomb do
            table.insert(outPokers, bomb[index])
        end
    end
    return outPokers
end
--滑动选牌提示
function CommonLgcObject:SlipTipsFunc(aiTable)
    local tips = {}
    local isHave = false    --是否找到提示
    local num   --提示数量
    local pokerCount = 0
    for i = 1,15 do
        pokerCount = pokerCount + aiTable[i][1]
    end

    local list = self:GetBestListFunc(aiTable,pokerCount) or {}
    num = #list
    if num > 0 then
        tips = list
        isHave = true
    end
    if isHave == false then
        local DoubleList = self:GetBestDoubleListFunc(aiTable,pokerCount) or {}
        num = #DoubleList
        if num > 0  then
            tips = DoubleList
            isHave = true
        end
    end
    if isHave == false then
        local aircraftDouble = self:GetBestAircraftDoubleFunc(aiTable,pokerCount) or {}
        num = #aircraftDouble
        if num > 0 then
            tips = aircraftDouble
            isHave = true
        end
    end
    if isHave == false then
        local aircraftSingle = self:GetBestAircraftSingleFunc(aiTable,pokerCount)or {}
        num = #aircraftSingle
        if num > 0 then
            tips = aircraftSingle
            isHave = true
        end
    end
    if isHave == false then
        local aircraft = self:GetBestAircraftFunc(aiTable,pokerCount) or {}
        num = #aircraft
        if num > 0 then
            tips = aircraft
            isHave = true
        end
    end
    if isHave == false then
        local threeTwo = self:GetBestThreeTwoFunc(aiTable,pokerCount) or {}
        num = #threeTwo
        if num > 0 then
            tips = threeTwo
            isHave = true
        end
    end
    if isHave == false then
        local threeOne = self:GetBestThreeOneFunc(aiTable,pokerCount) or {}
        num = #threeOne
        if num > 0 then
            tips = threeOne
            isHave = true
        end
    end
    if isHave == false then
        local three = self:GetBestThreeFunc(aiTable,pokerCount) or {}
        num = #three
        if num > 0 then
            tips = three
            isHave = true
        end
    end
    if isHave == false then
        local bombTwooo = self:GetBestBombTwoooFunc(aiTable,pokerCount) or {}
        num = #bombTwooo
        if num > 0 then
            tips = bombTwooo
            isHave = true
        end
    end
    if isHave == false then
        local bombTwo = self:GetBestBombTwoFunc(aiTable,pokerCount) or {}
        num = #bombTwo
        if num > 0 then
            tips = bombTwo
            isHave = true
        end
    end
    if isHave == false then
        local bomb = self:GetBestBombFunc(aiTable,pokerCount) or {}
        num = #bomb
        if num > 0 then
            tips = bomb
            isHave = true
        end
    end
    if isHave == false then
        local bouble = self:GetBestDoubleFunc(aiTable,pokerCount) or {}
        num = #bouble
        if num > 0 then
            tips = bouble
            isHave = true
        end
    end
    if isHave == false then
        local single = self:GetBestSingleFunc(aiTable,pokerCount) or {}
        num = #single
        if num > 0 then
            tips = single
            isHave = true
        end
    end
    local selectPokers = {}
    for i = 1,15 do
        for j = 2,#aiTable[i] do
            if aiTable[i][j] >= 0 then
                table.insert(selectPokers,aiTable[i][j])
            end
        end
    end
    self:raiseCards(tips,_,selectPokers)
    return tips
end



function CommonLgcObject:dellFiveFunction(outPokers) -- 把提示中的牌删除有五张的情况
    local num =0
    local tag =-1
    local flag = false
    local result={}
    if #outPokers == 0 then
       return true ,{}
    end
    for i=1, #outPokers do
        num=0
        tag =outPokers[i].CardValue

        for j=i,#outPokers  do
                if tag == outPokers[j].CardValue then
                   num= num +1
                end

                if num>=2 and tag >12 then  -- 屏蔽带对的时候有王
                    tag =-1
                    num= 0
                   return false , {}
                end

                if num > 4 then  -- 当有五张的时候屏蔽掉
                    tag =-1
                    num= 0
                    return false , {}
                end
        end        
    
    end
    for k,v in ipairs(outPokers) do
        table.insert(result,v)
        flag = true
    end
    return  flag, result
end

----------------------------------------↑↑↑↑↑↑↑分析牌型↑↑↑↑↑↑----------------------------------------

----------------------------------------↓↓↓↓↓↓↓打牌提示↓↓↓↓↓↓----------------------------------------
--牌值比较
--aiType    出牌类型
--aiTips    提示数据组
--aiOutPokers   自己选择的出牌
--aiOtherOutPokers   上家出牌
function CommonLgcObject:MatchPokersFunction(aiType, aiTips, aiOutPokers,aiOtherOutPokers,laizipoker)
local flag = false
local showPoker={}
     if #aiOutPokers ~= 2 then
        local  num = 0;
        for index = 1,#aiOutPokers do
            if aiOutPokers[index].CardValue >= 52 then  --如果是否带双王
                num = num + 1
                if num == 2 then
                    flag = false
                    return flag ,showPoker
                end
            end
        end
    end

    if aiOtherOutPokers == nil or aiOtherOutPokers.count == 2 then--如果别人家的牌是空，则可以随意出牌
         if self:MatchCardTypeFunction(aiOutPokers,laizipoker) == l_PaiXing.ERROR_CARD then
            flag = false
            return flag ,showPoker
        end
        flag = true
        if laizipoker == -1 then
            return flag ,showPoker  -- 因为有癞子牌所以不能直接出牌还要对癞子进行一下判断
        end
    end


    if self:MatchDoubleBossFunc(aiOutPokers)  == true then -- 判断是不是王炸
        flag = true
        return flag ,showPoker
    end

      local isBoom,BommShow = self:MatchBombTypeFunc(aiTips, aiOutPokers, laizipoker)
      if aiType ~= l_PaiXing.BOMB_CARD and isBoom == true then -- 如果出的是炸弹则直接返回
         return isBoom,BommShow
      end

        if aiType ==l_PaiXing.SINGLE_CARD then   --1
            return self:MatchSingleTypeFunc(aiTips, aiOutPokers,laizipoker) --比较单牌
        elseif aiType == l_PaiXing.DOUBLE_CARD then  --2
            return self:MatchDoubleTypeFunc(aiTips, aiOutPokers,laizipoker)
        elseif aiType == l_PaiXing.THREE_CARD then  --3
            return self:MatchThreeTypeFunc(aiTips, aiOutPokers,laizipoker)
        elseif aiType == l_PaiXing.THREE_ONE_CARD then--4
            return self:MatchThreeOneTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.THREE_TWO_CARD then--5
            return self:MatchThreeTwoTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.BOMB_TWO_CARD then--6
            return self:MathFourTwoTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.BOMB_TWOOO_CARD then--7
            return self:MatchFourTwoooTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.CONNECT_CARD then --8
            return self:MatchListTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.COMPANY_CARD then --9
            return self:MatchDoubleListTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.AIRCRAFT_CARD then --10
            return self:MatchAirphaneTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.AIRCRAFT_SINGLE_CARD then --11
            return self:MatchAirphaneSingleTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.AIRCRAFT_DOBULE_CARD then --12
            return self:MathcAirphaneDoubleTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.SOFT_BOMB_CARD then --13
            self:MatchBombTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.BOMB_CARD then --14
            return self:MatchBombTypeFunc(aiTips, aiOutPokers, laizipoker)
        elseif aiType == l_PaiXing.LAIZI_BOMB_CARD then --15
            self:MatchBombTypeFunc(aiTips, aiOutPokers, laizipoker)
        else
            flag = false
            return flag ,showPoker
        end
end

--王--炸
function CommonLgcObject:MatchDoubleBossFunc(aiOutPokers)
    if #aiOutPokers ~= 2 then
        return false
    end
    if (aiOutPokers[1].CardValue == 52 and aiOutPokers[2].CardValue == 53) or (aiOutPokers[2].CardValue == 52 and aiOutPokers[1].CardValue == 53) then
        return true
    else
        return false
    end
end

-- 排序
function CommonLgcObject:SortSelectPokersFunc(aiOutPokers)
    local t = { }
    -- 存放 PokerCount
    local outPokersIndex = clone(aiOutPokers)
    local tCount = #outPokersIndex;
    if tCount <= 0 then
        print("没有玩家管自己的牌，自己随便出")
        return outPokers,t
    end

    for index = 1, tCount do
        if outPokersIndex[index] ~= nil then
            -- 记数 排序出的牌用
            local PokerCount =
            {
                card_NO = - 1,
                -- 牌值
                num = 0,
                -- 牌数量
                arr = { }-- 集合牌
            }
            local poker = outPokersIndex[index]
            outPokersIndex[index] = nil
            PokerCount.num = 1
            if poker.CardValue / 13 >= 4 then
                PokerCount.card_NO = poker.CardValue - 39
            else
                PokerCount.card_NO = poker.CardValue % 13
            end
            table.insert(PokerCount.arr, poker)

            for k, v in pairs(outPokersIndex) do
                if v ~= nil then
                    local poker1 = v
                    if poker.CardValue / 13 >= 4 and poker1.CardValue / 13 >= 4 then
                        -- 判断是不是王
                        outPokersIndex[k] = nil
                        PokerCount.num = PokerCount.num + 1
                        table.insert(PokerCount.arr, poker1)
                    elseif poker1.CardValue % 13 == poker.CardValue % 13 then
                        outPokersIndex[k] = nil
                        PokerCount.num = PokerCount.num + 1
                        table.insert(PokerCount.arr, poker1)
                    end
                end
            end
            table.insert(t, PokerCount)
        end
    end

    local length = #t
    if length > 1 then
        -- 对t进行排序，按牌值从大到小排序
        for i = 1, length do
            for j = 1, length - i do
                if t[j].card_NO < t[j + 1].card_NO then
                    local temp = t[j];
                    t[j] = t[j + 1]
                    t[j + 1] = temp
                end
            end
        end
        -- 按牌的数量从大到小再排一次
        for i = 1, length do
            for j = 1, length - i do
                if t[j].num < t[j + 1].num then
                    local temp = t[j];
                    t[j] = t[j + 1]
                    t[j + 1] = temp
                end
            end
        end
    end
    local outPokers = {}
    for index = 1,#t do
        for i = 1,#t[index].arr do
            table.insert( outPokers, t[index].arr[i])
        end
    end 
    return outPokers,t
end

----------------------------------------------------癞子牌管理，包括普通牌，可以通用------------------------------------------------
--把其中的炸弹分出来
function CommonLgcObject:ChooseBombFunc(aiTips, l_PaiXing)
    local main = { }
    local bomb = { }

    for i = 1, #aiTips do
        if aiTips[i].Type == l_PaiXing then
            table.insert(main, aiTips[i])
        end
    end

    return main
end

-- 比---较-对-
function CommonLgcObject:MatchDoubleTypeFunc(aiTips, aiOutPokers,laizipoker)
    local flag=false
    local length = #aiOutPokers
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,2)
    if matchCardType ~= 2 then
        return flag, showPoker
    end

    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker = self:GameComparisonFunc(maintip, aiOutPokers, length, laizipoker)

    return flag,showPoker 
end

-- 比---较-单-牌-
function CommonLgcObject:MatchSingleTypeFunc(aiTips, aiOutPokers,laizipoker)
--aiTips 为所有提示的牌
--aiOutPokers 自己选择的牌
--laizipoker --癞子牌标号，默认没有为零
    local flag=false
    local length = #aiOutPokers
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,1)
    if matchCardType ~= 1 then
        return flag, showPoker
    end

    local maintip= self:ChooseBombFunc(aiTips, matchCardType)

    flag,showPoker = self:GameComparisonFunc(maintip, aiOutPokers, length, laizipoker)

    return flag,showPoker

end

-- 比----较-三张--
function CommonLgcObject:MatchThreeTypeFunc(aiTips, aiOutPokers,laizipoker)
    local flag=false
    local length = #aiOutPokers
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,3)
    if matchCardType ~= 3 then
        return flag, showPoker
    end
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker  = self:GameComparisonFunc(maintip, aiOutPokers, length, laizipoker)

    return flag,showPoker 
end

-- 比----较-连--
function CommonLgcObject:MatchListTypeFunc(aiTips, aiOutPokers,laizipoker)
    local flag = false
    local length = #aiOutPokers
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,8)
    if matchCardType ~= 8 then
        return flag, showPoker
    end
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker = self:ComparisonDoubleList(maintip, aiOutPokers, length,1, laizipoker)
    for i=1,#showPoker do
        if showPoker[i]>11 then
           return false,{}
        end
    end
    return flag,showPoker
end

-- 比---较-炸-弹-
function CommonLgcObject:MatchBombTypeFunc(aiTips, aiOutPokers,laizipoker)
    local flag=false
    local length = #aiOutPokers
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker)
    if matchCardType < 13 then
         return flag, showPoker
    end
    local bomb = { }
    for i = 1, #aiTips do
        if aiTips[i].Type >= 13 then
            table.insert(bomb, aiTips[i])
        end
    end
    flag,showPoker = self:GameComparisonFunc(bomb, aiOutPokers, length, laizipoker)
    return flag,showPoker
end

-- 比--较-连-对-
function CommonLgcObject:MatchDoubleListTypeFunc(aiTips, aiOutPokers, laizipoker)
    local flag = false
    local length = #aiOutPokers
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,9)
    if matchCardType ~= 9 then
        return flag, showPoker
    end
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker =self:ComparisonDoubleList(maintip, aiOutPokers, length,2, laizipoker)
    for i=1,#showPoker do
        if showPoker[i]>11 then
           return false,{}
        end
    end
    return flag,showPoker
end

-- 对---传---入的-牌-进-行-比--较---与-提-示-数-组-中-的-相-同--的-才-可-以-出
-- @ALLaiTips --所有提示数组
-- @aiOutPokers -- 自己选的牌
-- @length -- 主体牌的张数
-- @laizipoker -- 癞子牌编号
function CommonLgcObject:GameComparisonFunc(ALLaiTips, aiOutPokers, length, laizipoker)

    if laizipoker == nil then
        laizipoker = 0
    end
    local aiTips = self:SortAiTipsFunc(ALLaiTips)
    local mselectPokers = self:SortSelectPokersFunc(aiOutPokers)
    -- 对牌进行排序，这样主体牌会在前面
    if length <= 0 then
        length = #mselectPokers
    end
    local zonglength = #mselectPokers
    -- 用于全癞子的判断

    local flag = false
    local count = 0
    local showPoker = { }

    local choosepoker = 0
    local laizi_num = 0



    for k1 = 1, #mselectPokers do
        if mselectPokers[k1].CardValue < 52 then
            -- 用于处理王的问题--选择的牌有可能是王，因此在做处理的时候要做这个处理
            choosepoker =(mselectPokers[k1].CardValue) % 13
        else
            choosepoker =(mselectPokers[k1].CardValue) % 13 + 13
        end

        if laizipoker >= 0 and laizipoker == choosepoker then
            -- 癞子牌有可能为0
            -- 有效牌型中有癞子牌，则也是可行的
            laizi_num = laizi_num + 1
        end
    end

    for k, v in ipairs(aiTips) do
        local mshow = clone(v.ShowPoker)
        if count + laizi_num >= length and count > 0 then
            flag = true
            showPoker = mshow
        end

        count = 0
        -- 每一轮重新开始
        local selectPokers = clone(mselectPokers)
        if #v.ShowPoker == #selectPokers then
            for k1 = 1, #selectPokers do
                for k2 = 1, length do
        
                        local pokerNum =-1
                        if selectPokers[k1].CardValue < 52 then  -- 用于处理王的问题--选择的牌有可能是王，因此在做处理的时候要做这个处理
                            pokerNum =(selectPokers[k1].CardValue) % 13
                        else
                            pokerNum =(selectPokers[k1].CardValue) % 13 + 13
                        end

                        local outpoker =-1
                        if laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex ~= nil  then
                            if laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex[1].CardValue < 52 then  -- 用于处理王的问题--出的牌有可能是王，因此在做处理的时候要做这个处理
                                outpoker =(laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex[1].CardValue) % 13
                            else
                                outpoker =(laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex[1].CardValue) % 13 + 13
                            end
                        end

                    if laizipoker >= 0 and laizipoker  ==(pokerNum) then        -- 癞子牌有可能为0 --出来选择的牌为癞子牌
                        if laizi_num == length then                            -- 当癞子的个数等于长度--癞子作为本身时其值要大于所出的值
                            if length ~= 4 then                    -- 癞子作为本身的时候
                                if laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex ~= nil and pokerNum > outpoker then
                                    flag = true
                                    for i = 1, length do
                                        table.insert(showPoker, pokerNum)
                                    end

                                    return flag, showPoker
                                end
                                if laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex == nil then
                                    -- 王炸的情况这个为空
                                    flag = true
                                    for i = 1, length do
                                        table.insert(showPoker, pokerNum)
                                    end
                                    return flag, showPoker
                                end

                            elseif length == 4 then
                                -- 用来处理癞子炸弹--用来处理癞子炸弹的时候除了双王都可以管
                                flag = true
                                for i = 1, length do
                                    table.insert(showPoker, selectPokers[k1].CardValue % 13)
                                end
                                return flag, showPoker
                            end
                          break
                        end

                    end

                    local xuanPoker = 0
                    if selectPokers[k1].CardValue < 52 then
                        xuanPoker =(selectPokers[k1].CardValue) % 13
                    else
                        xuanPoker =(selectPokers[k1].CardValue) % 13 + 13
                    end
                    if ((selectPokers[k1].CardValue) >= 0 and xuanPoker == v.ShowPoker[k2] and xuanPoker ~= laizipoker ) then  --防止癞子重复计算
                        -- 应该叫数据同步增加
                        -- 遍历所有提示数组，取其中一组数据和自选牌进行比较，当牌值相同的时候则加一

                        count = count + 1
                        selectPokers[k1].CardValue = -1;
                        v.ShowPoker[k2] = -1
                        -- 防止重复比较
                    end
                end
                if count + laizi_num >= length and count > 0 then
                    flag = true
                    showPoker = mshow
                    return flag, showPoker

                end
            end
        else
            flag = false
        end
    end
    return flag, showPoker
end


-- 对-所--有-的--提-示--进--行-排-序
function CommonLgcObject:SortAiTipsFunc(ALLaiTips)
    local aiTips = clone(ALLaiTips)
    for i = 1, #aiTips do
        for j = 1, #aiTips - 1 do
            if aiTips[j].ShowPoker[1] ~= nil and aiTips[j + 1].ShowPoker[1] ~= nil then
                if aiTips[j].ShowPoker[1] < aiTips[j + 1].ShowPoker[1] then
                    local temp = aiTips[j];
                    aiTips[j] = aiTips[j + 1]
                    aiTips[j + 1] = temp
                end
            end
        end
    end
 return aiTips
end


-- 对-传--入-的-牌-进--行-比-较--与-提-示--数-组-中-的-相-同-的-才-可-以-出
-- @ALLaiTips --所有提示数组
-- @aiOutPokers -- 自己选的牌
-- @length -- 主体牌的张数
-- @mainPokerNum -- 主体牌的张数
-- @laizipoker -- 癞子牌编号
function CommonLgcObject:ComparisonListFunc(ALLaiTips, aiOutPokers, length, mainPokerNum, laizipoker)

    local aiTips =self:SortAiTipsFunc(ALLaiTips)

    local selectPokers = self:SortSelectPokersFunc(aiOutPokers)
    -- 对牌进行排序，这样主体牌会在前面
    local flag = false
    local showPoker = { }
    local main_num = length / mainPokerNum
    -- 主体牌连续的个数
    local minPoker = 0  -- 连牌的最小牌值
    local count = 0
    local tempShow = { }


   local laizi_num =0
    for k1 = 1, #selectPokers do
        if laizipoker >= 0 and laizipoker ==(selectPokers[k1].CardValue) % 13 then
            -- 有效牌型中有癞子牌，则也是可行的
            laizi_num = laizi_num + 1
        end

    end

    for k, v in ipairs(aiTips) do
    local mshowPoker = clone(v.ShowPoker)
        if count+laizi_num >= length and count > 0 then
            flag = true
            showPoker = mshowPoker
        end
        tempShow={}
        
        tempShow = clone(selectPokers)
        count = 0
        -- 每一轮重新开始
        if #v.ShowPoker == #tempShow then-- 飞机带单的时候还需要重新设定
            for k1 = 1, #tempShow do
                for k2 =1, length do
                    if tempShow[k1].CardValue >=0 and (tempShow[k1].CardValue % 13 ==(v.ShowPoker[k2])%13 )
                        and laizipoker ~=tempShow[k1].CardValue% 13 then
                          -- 遍历所有提示数组，取其中一组数据和自选牌进行比较，当牌值相同的时候则加一
                        count = count + 1
                        tempShow[k1].CardValue= -1
                        v.ShowPoker[k2] = -1 -- 防止重复比较
                        break
                    end
                end
                if count+laizi_num >= length and count > 0 then
                    flag = true
                    showPoker = mshowPoker
                    return flag, showPoker
                end
            end
        end
    end
    return flag, showPoker
end

function CommonLgcObject:MatchThreeOneTypeFunc(aiTips, aiOutPokers, laizipoker)
    if  #aiOutPokers ~= 4 then
        return false
    end
    local flag = false
    local length = 3
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,4)
    if matchCardType ~= 4 then
        return flag, showPoker
    end
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker = self:GameComparisonFunc(maintip, aiOutPokers, length, laizipoker)

    return flag,showPoker
end

-- ALLaiTips --所有提示数组
-- aiOutPokers -- 自己选的牌
-- length -- 主体牌的张数
-- mainPokerNum -- 主体牌的张数
-- laizipoker -- 癞子牌编号
function CommonLgcObject:ComparisonDoubleList(ALLaiTips, aiOutPokers, length, mainPokerNum, laizipoker)

    local aiTips =self:SortAiTipsFunc(ALLaiTips)
  
    local selectPokers = self:SortSelectPokersFunc(aiOutPokers)
    -- 对牌进行排序，这样主体牌会在前面
    local flag = false 
    local showPoker = { }
    local main_num = length / mainPokerNum
    -- 主体牌连续的个数
    local minPoker = 0  -- 连牌的最小牌值
    local count = 0
    local tempShow = { }

   local laizi_num =0
    for k1 = 1, #selectPokers do
        if laizipoker >= 0 and laizipoker  ==(selectPokers[k1].CardValue) % 13 then
            -- 有效牌型中有癞子牌，则也是可行的
            laizi_num = laizi_num + 1
        end
    end

    for k, v in ipairs(aiTips) do
        if count+laizi_num >= length and count > 0 then
            flag = true
            showPoker = v.ShowPoker
        end
        tempShow={}
        tempShow = clone(selectPokers)
        count = 0
        -- 每一轮重新开始
        if #v.Table == #tempShow then-- 飞机带单的时候还需要重新设定
            for k1 = 1, #tempShow do
                for k2 =1, length do
                    if tempShow[k1].CardValue>=0 and (tempShow[k1].CardValue % 13 ==(v.Table[k2]) % 13)
                        and laizipoker  ~=tempShow[k1].CardValue% 13 then
                          -- 遍历所有提示数组，取其中一组数据和自选牌进行比较，当牌值相同的时候则加一
                        count = count + 1
                        tempShow[k1].CardValue= -1
                        break
                    end
                end
                if count+laizi_num >= length and count > 0 then
                    flag = true
                    showPoker = v.ShowPoker
                    return flag, showPoker
                end
            end
        end
    end
    return flag, showPoker
end
-- 比--较--四--代--单
function CommonLgcObject:MathFourTwoTypeFunc(aiTips, aiOutPokers, laizipoker)
    local zongLength =#aiOutPokers 
    if zongLength  ~= 6 then
        return false
    end
    local flag = false
    local length = 4
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,6)
    if matchCardType ~= 6 then
        return flag, showPoker
    end

    flag ,showPoker = self:GameComparisonFunc(aiTips, aiOutPokers, length, laizipoker)
    return flag ,showPoker
end

-- 比--较--三--代--二
function CommonLgcObject:MatchThreeTwoTypeFunc(aiTips, aiOutPokers, laizipoker)
    if  #aiOutPokers ~= 5 then
        return false
    end
    local outpoker = aiOutPokers
    local selectPokers = self:SortSelectPokersFunc(aiOutPokers)
    local flag = false;
    local length = 3
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,5)
    if matchCardType ~= 5 then
        return flag, showPoker
    end
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag ,showPoker = self:GameComparisonFunc(maintip, aiOutPokers, length, laizipoker)

    return flag ,showPoker
  
end

-- 比-较-四-代-对
function CommonLgcObject:MatchFourTwoooTypeFunc(aiTips, aiOutPokers, laizipoker)
    local selectPokers,other = self:SortSelectPokersFunc(aiOutPokers)

    local flag = false
    local length = 4
    local zongLength = #selectPokers
    local showPoker ={}
    if  zongLength ~= 8 then
        return flag,showPoker
    end

    flag,showPoker = self:GameComparisonFunc(aiTips, aiOutPokers, length, laizipoker)
    local tishi = clone(aiTips)
    if flag then
        while true do
            if #tishi == 0 then
                break
            end
            flag,showPoker = self:GameComparisonFunc(tishi, aiOutPokers, length, laizipoker)
            
            if flag then
                local flag2=self:ShengyuIsDoubleFunc(aiOutPokers, showPoker, zongLength,length,laizipoker)
                    if flag2 then
                         break
                    else

                        for i =1 ,#tishi do
                             if tishi[i].ShowPoker[1]%13 == showPoker[1]%13 then
                                  tishi[i] = tishi[#tishi]
                                  tishi[#tishi] = nil 
                                  break
                             end
                        end

                    end
            end
            break
        end
    end
  
    return flag,showPoker
end
--比-较-飞-机-不-带
function CommonLgcObject:MatchAirphaneTypeFunc(aiTips, aiOutPokers, laizipoker)
    local selectPokers,other = self:SortSelectPokersFunc(aiOutPokers)
    local length = 0
    local flag = false
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,10)
    if matchCardType ~= 10 then
        return flag, showPoker
    end
    for i=1, #other do
            length = length + other[i].num
    end
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker =self:ComparisonListFunc(maintip, aiOutPokers, length,3, laizipoker)

   return flag,showPoker
end
-- 比-较-飞-机-带-单
function CommonLgcObject:MatchAirphaneSingleTypeFunc(aiTips, aiOutPokers, laizipoker)
    local selectPokers,other = self:SortSelectPokersFunc(aiOutPokers)
    local otherLen =  #selectPokers
    local flag = false
    local length = 0
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,11)
    if matchCardType ~= 11 then
        return flag, showPoker
    end
    if otherLen %4 ~= 0 then
        return  flag, showPoker
    end

    length = (otherLen/4)*3
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker = self:ComparisonListFunc(maintip, aiOutPokers, length,3, laizipoker)

   return flag,showPoker
end

function CommonLgcObject:ShengyuIsDoubleFunc(aiOutPokers, showPoker, zongLength,length,laizipoker)
    local outpoker = clone(aiOutPokers)
    local haveNum = 0
    local temp = { }
    local shenyulaizi = 0
    local hanvenum = 0
    local count =0
    for i = 1, length do     -- 把匹配上的原牌值排除
        for j = 1, zongLength do
            if showPoker[i] % 13 == outpoker[j].CardValue % 13 then
                outpoker[j].CardValue = -1
                haveNum = haveNum + 1
            end
        end
    end

    if haveNum < length then
        -- 把配套的癞子牌排除
        for lai1 = 1, length - haveNum do
            for out1 = 1, zongLength do
                if outpoker[out1].CardValue % 13 == laizipoker then
                    outpoker[out1].CardValue = -1
                    break
                end
            end
        end
    end

    for i = 1, zongLength do
        if outpoker[i].CardValue >= 0 then
            table.insert(temp, outpoker[i])
        end
    end
    hanvenum = #temp

    if hanvenum % 2 == 0 then
        for s1 = 1, hanvenum do
            for s2 = s1 + 1, hanvenum do
                if temp[s1].CardValue > temp[s2].CardValue then
                    local linshi = temp[s2]
                    temp[s2] = temp[s1]
                    temp[s1] = linshi
                end
            end
        end
        local temba, tembb = self:SortSelectPokersFunc(temp)
        -- 把剩余的癞子全部取出来
        for t1 = 1, #tembb do
            if laizipoker == tembb[t1].card_NO then
                shenyulaizi = tembb[t1].num
            end
        end
        for t3 = 1, #tembb do
            -- 配对
            if laizipoker ~= tembb[t3].card_NO and tembb[t3].num == 1  then
                shenyulaizi = shenyulaizi - 1
                count=count+1
            elseif laizipoker ~= tembb[t3].card_NO and tembb[t3].num == 3  then 
                shenyulaizi = shenyulaizi - 1
                count = count+2
            elseif laizipoker ~= tembb[t3].card_NO then 
                count =count+tembb[t3].num/2
            end
        end
    end

    if (shenyulaizi == 0 or shenyulaizi % 2 == 0)and count == math.modf(hanvenum /2 ) then
        return true
    else
        return false
    end

end

-- 比-较-飞-机-带-对
function CommonLgcObject:MathcAirphaneDoubleTypeFunc(aiTips, aiOutPokers, laizipoker)
    local selectPokers,other = self:SortSelectPokersFunc(aiOutPokers)
     
    local flag = false
    local length = 0  --飞机的长度
    local zongLength =#selectPokers
    local showPoker ={}
    local matchCardType =self:MatchCardTypeFunction(aiOutPokers,laizipoker,12)
    if matchCardType ~= 12 then
        return flag, showPoker
    end
    if zongLength %5 ~= 0 then
        return  flag, showPoker
    end
    length = (zongLength/5)*3
    local maintip= self:ChooseBombFunc(aiTips, matchCardType)
    flag,showPoker = self:ComparisonListFunc(maintip, aiOutPokers, length,3, laizipoker)

   return flag,showPoker
end

--随-便-出-牌-时-提-取-连-对
function CommonLgcObject:GetBestDoubleListFunc(aiTable,aiNum)
    local doubleList = {}
    if aiNum < 6 then
        return doubleList
    end
    local num = 0  --顺子长度
    local beginOK = 0 --开始有位置
    local overOK = 0  --结束有位置
    local count = 0   --链子计数器
    local begin = 0 --开始位置
    local over = 0  --结束位置
    for i = 1,12 do
        if aiTable[i][1] > 1 and aiTable[i][1] ~= 4 then
            begin  = i
            count = 1
            for j = i + 1,12 do
                if  aiTable[j][1] > 1 and aiTable[i][1] ~= 4 then
                    over = j
                    count = count + 1
                    if count >= 3 and count > num then
                        beginOK = over
                        overOK = begin 
                        num = count
                    end
                else
                    break
                end
            end
        end
    end
    local doubleList = {}
    local flag = 0  --标记添加几个了
    if overOK ~= 0 and beginOK ~= 0 then
        for i = overOK,beginOK do
            flag = 0
            for j = 2,5 do
                if aiTable[i][j] >=0 then
                    table.insert(doubleList,aiTable[i][j])
                    flag = flag + 1
                    if flag >= 2 then
                        break
                    end
                end
            end
        end
    end
    return doubleList
end

--随-便-出-提--取-连
function CommonLgcObject:GetBestListFunc(aiTable,aiNum)
    local list = {}
    if aiNum < 5 then
        return list
    end
    local num = 0  --顺子长度
    local beginOK = 0 --开始有位置
    local overOK = 0  --结束有位置
    local count = 0   --链子计数器
    local begin = 0 --开始位置
    local over = 0  --结束位置
    for i = 1,12 do
        if aiTable[i][1] > 0 and aiTable[i][1] ~= 4 then
            begin  = i
            count =  1
            for j =  i + 1,12 do
                if  aiTable[j][1] > 0 and aiTable[i][1] ~= 4 then
                    over = j
                    count = count + 1
                    if count >= 5 and count > num then
                        beginOK = over
                        overOK = begin 
                        num = count
                    end
                else
                    break
                end
            end
        end
    end
    if overOK ~= 0 and beginOK ~= 0 then
        for i = overOK,beginOK do
            for j = 2,5 do
                if aiTable[i][j] >=0 then
                    table.insert(list,aiTable[i][j])
                    break
                end
            end
        end
    end
    return list
end

--获-取-飞-机-主-体
function CommonLgcObject:GetBestMainAircraftFunc(aiTable,aiNum)
    local mainAircraft = {}
    local tempMainAircraft = {}
    local maxListNum = 0    --最大主体长度
    for i = 1,11 do
        if aiTable[i][1] == 3 then
            for j = i + 1,12 do
                if aiTable[j][1] == 3 then
                    table.insert(tempMainAircraft,{j-i+1,i,j})  --{飞机主体长度，飞机开始位置，飞机结束位置}
                    if j-i+1 > maxListNum then
                        maxListNum = j-i+1
                    end
                else
                    break
                end
            end
        end
    end
    --按长度排序
    for i = maxListNum,2,-1 do
        for j = 1,#tempMainAircraft do
            if tempMainAircraft[j][1] == i then
                table.insert(mainAircraft,{tempMainAircraft[j][1],tempMainAircraft[j][2],tempMainAircraft[j][3]})
            end 
        end
    end
    return mainAircraft
end

--随-便-出-牌-时-提-取-飞-机-带-单
function CommonLgcObject:GetBestAircraftSingleFunc(aiTable,aiNum)
    local aircraftSingle = {}
    if aiNum < 8 then
        return aircraftSingle
    end   
    local num = 0  --顺子长度
    local beginOK = 0 --开始有位置
    local overOK = 0  --结束有位置
    local count = 0   --链子计数器
    local begin = 0 --开始位置
    local over = 0  --结束位置

    --aiBegin   开始位置
    --aiEnd     结束位置
    --aiCount   计数
    function checkSingle(aiBegin,aiEnd,aiCount) --选对翅膀
        local single = {}
        local count = 0
        for i = 1,13 do --优先单牌
            if aiTable[i][1] ==1  and ( i > aiBegin or i < aiEnd ) then
                for j = 2,5 do
                    if aiTable[i][j] >= 0 then
                        table.insert( single,aiTable[i][j])
                        count = count + 1
                        if count >= aiCount then
                            return single
                        end
                    end
                end
            end
        end
        single = {}
        count = 0
        for i = 1,13 do --优先单牌、对牌
            if aiTable[i][1] >= 1 and aiTable[i][1] <= 2 and ( i > aiBegin or  i < aiEnd ) then
                for j = 2,5 do
                    if aiTable[i][j] >= 0 then
                        table.insert( single,aiTable[i][j])
                        count = count + 1
                        if count >= aiCount then
                            return single
                        end
                    end
                end
            end
        end
        single = {}
        count = 0
        for i = 1,13 do --不拆炸弹
            count = 0 
            if aiTable[i][1] > 0 and aiTable[i][1] ~= 4 and i > aiBegin and i < aiEnd  then
                for j = 2,5 do
                    if aiTable[i][j] >= 0 then
                        table.insert( single,aiTable[i][j])
                        count = count + 1
                        if count >= aiCount then
                            return single
                        end
                    end
                end
            end
        end
        return nil
    end
    local mainTable = self:GetBestMainAircraftFunc(aiTable,aiNum)
    local single = nil
    local mainIndex = 0
    for i = 1,#mainTable do
        if mainTable[i][1] * 4 <= aiNum then
            single = checkSingle(mainTable[i][2],mainTable[i][3],mainTable[i][1])
            if single ~= nil then--有可带翅膀
                mainIndex = i
                break   --找到一个就退出
            end
        end
    end
    if mainIndex ~= 0 then
        for i = mainTable[mainIndex][2],mainTable[mainIndex][3] do
            --没有差炸弹的，如果要拆炸弹，还取改
            for  j = 2 , 5 do
                if aiTable[i][j] >= 0 then
                    table.insert( aircraftSingle,aiTable[i][j])
                end
            end
        end
        for i = 1,#single do
            table.insert( aircraftSingle,single[i])
        end
    end
    return  aircraftSingle

end

--随-便--出-牌-提-取-飞-机-带-对
function CommonLgcObject:GetBestAircraftDoubleFunc(aiTable,aiNum)
    local aircraftDouble = {}
    if aiNum < 10 then
        return aircraftDouble
    end   
--    local num = 0  --顺子长度
--    local beginOK = 0 --开始有位置
--    local overOK = 0  --结束有位置
--    local count = 0   --链子计数器
--    local begin = 0 --开始位置
--    local over = 0  --结束位置
-- @aiBegin   开始位置
-- @aiEnd     结束位置
-- @aiCount   计数
    function checkDouble(aiBegin,aiEnd,aiCount) --选对翅膀
        local double = {}
        local num = 0
        local count = 0
        for i = 1,12 do
            count = 0
            if aiTable[i][1] == 2 then
                for j = 2,5 do
                    if aiTable[i][j] >= 0 then
                        table.insert(double,aiTable[i][j])
                        count = count + 1
                        if count >= 2 then
                            num = num + 1
                            break
                        end
                    end
                end
            end
            if num >= aiCount then
                return double
            end 
        end
        double = {}
        num = 0
        for i = 1,12 do
            count = 0 
            if aiTable[i][1] >1 and aiTable[i][1] ~= 4 and (i > aiBegin or i < aiEnd ) then
                for j = 2,5 do
                    if aiTable[i][j] >= 0 then
                        table.insert( double,aiTable[i][j])
                        count = count + 1
                        if count >= 2 then
                            num = num + 1
                            break
                        end
                    end
                end
            end
            if num >= aiCount then
                return double
            end 
        end
        return nil
    end
    local mainTable = self:GetBestMainAircraftFunc(aiTable,aiNum)
    local double = nil
    local mainIndex = 0
    for i = 1,#mainTable do
        if mainTable[i][2] * 5 <= aiNum then
            double = checkDouble(mainTable[i][2],mainTable[i][3],mainTable[i][1])
            if double ~= nil then--有可带翅膀
                mainIndex = i
                break   --找到一个就退出
            end
        end
    end
    if mainIndex ~= 0 then
        for i = mainTable[mainIndex][2],mainTable[mainIndex][3] do
            --没有差炸弹的，如果要拆炸弹，还取改
            for  j = 2 , 5 do
                if aiTable[i][j] >= 0 then
                    table.insert( aircraftDouble,aiTable[i][j])
                end
            end
        end
        for i = 1,#double do
            table.insert( aircraftDouble,double[i])
        end
    end
    return aircraftDouble

end

--随-便-出-提-取-飞-机
function CommonLgcObject:GetBestAircraftFunc(aiTable,aiNum)
    local aircraft = {}
    if aiNum < 6 then
        return aircraft
    end   
    local mainTable = self:GetBestMainAircraftFunc(aiTable,aiNum)  
    if mainTable[1] ~= nil then
        for i = mainTable[1][2],mainTable[1][3] do
            --没有差炸弹的，如果要拆炸弹，还取改
            for  j = 2 , 5 do
                if aiTable[i][j] >= 0 then
                    table.insert( aircraft,aiTable[i][j])
                end
            end
        end    
    end
    return  aircraft
end
--滑-牌-获-取-三-带-单
function CommonLgcObject:GetBestThreeOneFunc(aiTable,aiNum)
    local threeOne = {}
    if aiNum < 4 then
        return threeOne
    end
    local mainPokerIndex = 0
    local otherpokerIndex = 0
    for i = 1,13 do
        if aiTable[i][1] == 3 then
            other1PokerIndex = 0
            other2PokerIndex = 0
            local isFind = false;
            for j = 1,13 do
                if j ~= i and  aiTable[j][1] == 1  then
                    mainPokerIndex = i
                    otherpokerIndex = j
                    isFind = true;
                    break
                end
            end
            if isFind == false then
                for j = 1,13 do
                    if j ~= i and  aiTable[j][1] >= 1 and aiTable[j][1] <= 2 then
                        mainPokerIndex = i
                        otherpokerIndex = j
                        isFind = true;
                        break
                    end
                end
            end
            if isFind == false then
                for j = 1,13 do
                    if j ~= i and  aiTable[j][1] >= 1 and aiTable[j][1] ~= 4 then
                        mainPokerIndex = i
                        otherpokerIndex = j
                        break
                    end
                end
            end
        end
        if otherpokerIndex > 0 then
            break
        end
    end 
    if otherpokerIndex > 0 then
        for i = 2,5 do
            if aiTable[mainPokerIndex][i] >= 0 then
                table.insert( threeOne,aiTable[mainPokerIndex][i] )
            end
        end
        for i = 2,5 do
            if aiTable[otherpokerIndex][i] >= 0 then
                table.insert( threeOne,aiTable[otherpokerIndex][i] )
                break
            end
        end
    end
    return threeOne
end
--滑-牌-获-取-三-带-对
function CommonLgcObject:GetBestThreeTwoFunc(aiTable,aiNum)
    local threeTwo = {}
    if aiNum < 5 then
        return threeTwo
    end
    local mainPokerIndex = 0
    local otherpokerIndex = 0
    for i = 1,13 do
        if aiTable[i][1] == 3 then
            mainPokerIndex = 0
            otherpokerIndex = 0
            local isFind = false
            for j = 1,13 do
                if j ~= i and  aiTable[j][1] == 2 then
                    mainPokerIndex = i
                    otherpokerIndex = j
                    isFind = true
                    break
                end
            end
            if isFind == false then
                for j = 1,13 do
                    if j ~= i and  aiTable[j][1] >= 2 and aiTable[j][1] ~= 4 then
                        mainPokerIndex = i
                        otherpokerIndex = j
                        break
                    end
                end                
            end
        end
        if otherpokerIndex > 0 then
            break
        end
    end
    if  otherpokerIndex > 0 then
        for i = 2,5 do
            if aiTable[mainPokerIndex][i] >= 0 then
                table.insert( threeTwo,aiTable[mainPokerIndex][i] )
            end
        end
        local count = 0
        for i = 2,5 do
            if aiTable[otherpokerIndex][i] >= 0 then
                table.insert( threeTwo,aiTable[otherpokerIndex][i] )
                count = count + 1
                if count >  2 then
                    break
                end
            end
        end
    end
    return threeTwo
end

--滑-牌-获-取-三-张
function CommonLgcObject:GetBestThreeFunc(aiTable,aiNum)
    local three = {}
    if aiNum < 3 then
        return three
    end
    local mainPokerIndex = 0
    local otherpokerIndex = 0
    for i = 1,13 do
        if aiTable[i][1] == 3 then
            for j = 2,5 do
                if aiTable[i][j] >=0 then
                    table.insert( three,aiTable[i][j] )
                end
            end
            return three
        end
    end 
    return three
end
--滑-牌-获-取-四-带-单
function CommonLgcObject:GetBestBombTwoFunc(aiTable,aiNum)
    local bombTwo = {}
    if aiNum < 6 then
        return bombTwo
    end
    local mainPokerIndex = 0
    local other1PokerIndex = 0
    local other2PokerIndex = 0
    for i = 1,13 do
        if aiTable[i][1] == 4 then
            mainPokerIndex = i
            other1PokerIndex = 0
            other2PokerIndex = 0
            local isFind = false
            for j = 1,13 do
                if j ~= i and  aiTable[j][1] == 1 and other1PokerIndex == 0 then
                    other1PokerIndex = j
                    if aiTable[j][1] > 1 then
                        other2PokerIndex = j
                        isFind = true
                        break                        
                    end
                end
                if other1PokerIndex > 0 and other1PokerIndex ~= j  and j ~= i and  aiTable[j][1] == 1  then
                    other2PokerIndex = j
                    isFind = true
                    break
                end
            end
            if isFind == false then
                other1PokerIndex = 0
                other2PokerIndex = 0
                for j = 1,13 do
                    if j ~= i and aiTable[j][1] >= 1 and aiTable[j][1] <= 2 and other1PokerIndex == 0 then
                        other1PokerIndex = j
                        if aiTable[j][1] > 1 then
                            other2PokerIndex = j
                            isFind = true
                            break                        
                        end
                    end
                    if other1PokerIndex > 0 and other1PokerIndex ~= j  and j ~= i and  aiTable[j][1] >= 1 and aiTable[j][1] <= 2 then
                        other2PokerIndex = j
                        isFind = true
                        break
                    end
                end            
            end
            if isFind == false then
                other1PokerIndex = 0
                other2PokerIndex = 0
                for j = 1,13 do
                    if j ~= i and  aiTable[j][1] >0 and aiTable[j][1] ~= 4 and other1PokerIndex == 0 then
                        other1PokerIndex = j
                        if aiTable[j][1] > 1 then
                            other2PokerIndex = j
                            break                        
                        end
                    end
                    if other1PokerIndex > 0 and other1PokerIndex ~= j  and j ~= i and  aiTable[j][1] >0 and aiTable[j][1] ~= 4 then
                        other2PokerIndex = j
                        break
                    end
                end
            end
        end
        if other2PokerIndex > 0 then
            break
        end
    end
    if  other2PokerIndex > 0 then
        for i = 2,5 do
            if aiTable[mainPokerIndex][i] >= 0 then
                table.insert( bombTwo,aiTable[mainPokerIndex][i] )
            end
        end
        local count = 0
        for i = 2,5 do
            if aiTable[other1PokerIndex][i] >= 0 then
                table.insert( bombTwo,aiTable[other1PokerIndex][i] )
                count = count + 1
                if count >=  2 then
                    return bombTwo
                end
            end
        end
        for i = 2,5 do
            if aiTable[other2PokerIndex][i] >= 0 then
                table.insert( bombTwo,aiTable[other2PokerIndex][i] )
                count = count + 1
                if count >=  2 then
                    return bombTwo
                end
            end
        end
    end
    return bombTwo
end

--滑-牌-获-取-四-带-对
function CommonLgcObject:GetBestBombTwoooFunc(aiTable,aiNum)
    local bombTwooo = {}
    if aiNum < 8 then
        return bombTwooo
    end
    local mainPokerIndex = 0
    local other1PokerIndex = 0
    local other2PokerIndex = 0
    for i = 1,13 do
        if aiTable[i][1] == 4 then
            mainPokerIndex = i
            other1PokerIndex = 0
            other2PokerIndex = 0
            local isFind  = false
            for j = 1,13 do
                if j ~= i and  aiTable[j][1] ==2 and other1PokerIndex == 0 then
                    other1PokerIndex = j
                end
                if other1PokerIndex > 0 and other1PokerIndex ~= j  and j ~= i and  aiTable[j][1] == 2 then
                    other2PokerIndex = j
                    isFind = true
                    break
                end                
            end
            if isFind  == false then
                other1PokerIndex = 0
                other2PokerIndex = 0
                for j = 1,13 do
                    if j ~= i and  aiTable[j][1] >1 and aiTable[j][1] ~= 4 and other1PokerIndex == 0 then
                        other1PokerIndex = j
                    end
                    if other1PokerIndex > 0 and other1PokerIndex ~= j  and j ~= i and  aiTable[j][1] >1 and aiTable[j][1] ~= 4 then
                        other2PokerIndex = j
                        break
                    end
                end
            end
        end
        if other2PokerIndex > 0 then
            break
        end
    end 
    if other2PokerIndex > 0 then    
        for i = 2,5 do
            if aiTable[mainPokerIndex][i] >= 0 then
                table.insert( bombTwooo,aiTable[mainPokerIndex][i] )
            end
        end
        local count = 0
        for i = 2,5 do
            if aiTable[other1PokerIndex][i] >= 0 then
                table.insert( bombTwooo,aiTable[other1PokerIndex][i] )
                count = count + 1
                if count >  2 then
                    break
                end
            end
        end
        for i = 2,5 do
            if aiTable[other2PokerIndex][i] >= 0 then
                table.insert( bombTwooo,aiTable[other2PokerIndex][i] )
                count = count + 1
                if count >  4 then --已经添加了2张翅膀了
                    break
                end
            end
        end
    end
    return bombTwooo
end

--滑-牌-获-取-炸-弹
function CommonLgcObject:GetBestBombFunc(aiTable,aiNum)
    local bomb = {}
    for i = 1,13 do
        if aiTable[i][1] == 4 then
            for j = 2,5 do
                table.insert(bomb,aiTable[i][j])
            end
            return bomb
        end
    end
    if aiTable[14][1] > 0 and aiTable[15][1] > 0 then
        table.insert(bomb,aiTable[14][2] )
        table.insert(bomb,aiTable[15][2] )
        return bomb
    end
    return bomb
end
--滑-牌-选-对
function CommonLgcObject:GetBestDoubleFunc(aiTable,aiNum)
    local double = {}
    if  aiNum < 2 then
        return double
    end
    for i = 1,13 do
        if aiTable[i][1] == 2 then  --前面已经筛选过3张了 直接判定对
            for j = 2,5 do
                if aiTable[i][j] >= 0 then
                    table.insert(double,aiTable[i][j])
                end
            end
            return double
        end
    end
    return double
end
--滑-牌-选-单
function CommonLgcObject:GetBestSingleFunc(aiTable,aiNum)
    local single = {}
    if  aiNum < 1 then
        return single
    end
    for i = 1 ,15 do
        if aiTable[i][1] == 1 then  --前面已经筛选过3张了 直接判定对
            for j = 2,#aiTable[i] do
                if aiTable[i][j] >= 0 then
                    table.insert(single,aiTable[i][j])
                end
            end
            return single
        end
    end
    return single
end
----------------------------------------↑↑↑↑↑↑↑打牌提示↑↑↑↑↑↑----------------------------------------

----------------------------------------↑↑↑↑↑↑↑出牌逻辑↑↑↑↑↑↑----------------------------------------
 function CommonLgcObject:GameNewAiFunction(selectType,selectCards,isSelect,lastRaiseData,aiList,aiOutPokersIndex)
    --在游戏中使用的编码方式会将花色区分开来，黑桃3和红桃3会用不同的值表示。所以游戏调用ddzAI的函数时，ddzAI会先将传入的和牌值相关的数据转换成ddzAI的编码方式。
--            大王  小王 黑桃A红桃A 草花A方片A黑桃2红桃2草花2 方片2 黑桃3 红桃3草花3方片3 ...    黑桃K   红桃K  草花K  方片K
--[游戏编码方式]  2   3    4   5     6   7     8    9    10   11    12   13   14   15          52      53    54  55
--[ddzAI编码]   17  16  14   14    14  14    15   15   15   15    3    3    3    3  ....     13      13    13   13


    local selectDataByNewAI
    local outPokersIndex = self:OutCardSortFunction(clone(aiOutPokersIndex))
    if selectType == 1 then
        selectDataByNewAI=self:GameParmTransByNewAIFunction(1,selectCards,aiList,outPokersIndex)
    else
        selectDataByNewAI=self:GameParmTransByNewAIFunction(3,selectCards,aiList,outPokersIndex)
    end
    if selectDataByNewAI == nil or #selectDataByNewAI == 0 then
        --没有选择的牌直接退出返回
        return
    end
    local lastDataByNewAI = self:GameParmTransByNewAIFunction(2,aiList,_,outPokersIndex)
    local resByNewAI = doudizhuGL.intelletChupaiAssist(lastDataByNewAI,selectDataByNewAI)
    local res = self:GameParmTransByNewAIFunction(4,resByNewAI,aiList,outPokersIndex)
    local raiseData = {}        --最终上选牌集合

    if #resByNewAI>0 then          --划牌结果非空，则结果变为上选牌
        for k,v in pairs(res) do
            table.insert(raiseData,k)
        end
    else                           --原有上选牌与划牌进行处理（反选原则）
        local temp={}       --划牌整理格式
        for k,v in ipairs(selectCards) do
            if v[1] ~= 0 then
               for index=2,5 do
                    if v[index]~=-1 then
                        table.insert(temp,v[index])
                    end
               end
            end
        end
        
        if isSelect then            
            for k,v in ipairs(temp) do
                if lastRaiseData[v]==1 then
                    lastRaiseData[v] = 0
                else
                    lastRaiseData[v] = 1
                end
            end
            for k,v in pairs(lastRaiseData) do
                if v==1 then
                    table.insert(raiseData,k)
                end
            end
        else
            for k,v in ipairs(temp) do
                table.insert(raiseData,v)
            end
        end
    end
    return raiseData
end

function CommonLgcObject:GameParmTransByNewAIFunction(transType,data,aiList,aiOutPokersIndex)
    local res = {}
    if transType == 1 and data then  -- selectCards格式转换为AISelectCardFunc数据格式
        for k,v in ipairs(data) do
            if v[1] ~= 0 then
                if k < 12 then
                    if v[2] ~= -1 then
                            table.insert(res,12+(k-1)*4)
                    end
                    if v[3] ~= -1 then
                            table.insert(res,13+(k-1)*4)
                    end
                    if v[4] ~= -1 then
                            table.insert(res,15+(k-1)*4)
                    end
                    if v[5] ~= -1 then
                            table.insert(res,14+(k-1)*4)
                    end
                elseif k < 14 then
                    if v[2] ~= -1 then
                            table.insert(res,4+(k-12)*4)
                    end
                    if v[3] ~= -1 then
                            table.insert(res,5+(k-12)*4)
                    end
                    if v[4] ~= -1 then
                            table.insert(res,7+(k-12)*4)
                    end
                    if v[5] ~= -1 then
                            table.insert(res,6+(k-12)*4)
                    end
                elseif k ==14 then
                    if v[2] ~= -1 then
                            table.insert(res,3)
                    end
                elseif k ==15 then
                    if v[2] ~= -1 then
                            table.insert(res,2)
                    end
                end
            end
        end
    elseif transType == 2 then              --桌上的牌转为ai的牌
        local outPokersIndex = aiOutPokersIndex or { }
        for outk,outv in ipairs(outPokersIndex) do
            for k,v in ipairs(outv.arr) do
                if v.CardValue<=10 then
                    table.insert(res,12+v.CardValue*4)      --黑3到黑k
                elseif v.CardValue<=12 then
                    table.insert(res,4+(v.CardValue-11)*4)
                elseif v.CardValue<=23 then
                    table.insert(res,13+(v.CardValue-13)*4) --红3到红k
                elseif v.CardValue<=25 then
                    table.insert(res,5+(v.CardValue-24)*4)
                elseif v.CardValue<=36 then
                    table.insert(res,15+(v.CardValue-26)*4) -- 花3到花k
                elseif v.CardValue<=38 then
                    table.insert(res,7+(v.CardValue-37)*4)
                elseif v.CardValue<=49 then
                    table.insert(res,14+(v.CardValue-39)*4) -- 片3到片k
                elseif v.CardValue<=51 then
                    table.insert(res,6+(v.CardValue-50)*4)  --
                elseif v.CardValue == 52 then
                    table.insert(res,3) --小王
                elseif v.CardValue == 53 then
                    table.insert(res,2) --大王
                end
            end
        end
    elseif transType == 3 and data and #data>0 then     --手中的牌转为ai的牌
        for k,v in pairs(aiList) do   
            if k<=10 then
                table.insert(res,12+k*4)
            elseif k<=12 then
                table.insert(res,4+(k-11)*4)
            elseif k<=23 then
                table.insert(res,13+(k-13)*4)
            elseif k<=25 then
                table.insert(res,5+(k-24)*4)
            elseif k<=36 then
                table.insert(res,15+(k-26)*4)
            elseif k<=38 then
                table.insert(res,7+(k-37)*4)
            elseif k<=49 then
                table.insert(res,14+(k-39)*4)
            elseif k<=51 then
                table.insert(res,6+(k-50)*4)
            elseif k == 52 then
                table.insert(res,3)
            elseif k == 53 then
                table.insert(res,2)
            end
        end
    elseif transType == 4 and data and #data>0 then     -- ai的牌转为游戏的牌集合
        for k,v in ipairs(data[1]) do
            if v == 2 then
                res[53]=1
            elseif v==3 then
                res[52]=1
            else
                local yu = v%4
                local shang = math.floor(v/4)
                if yu==0 then
                   if shang<3 then
                      res[shang+10]=1
                   else
                      res[shang-3]=1
                   end
                elseif  yu==1 then
                   if shang<3 then
                      res[shang+23]=1
                   else
                      res[shang+10]=1
                   end
                elseif  yu==2 then
                   if shang<3 then
                      res[shang+49]=1
                   else
                      res[shang+36]=1
                   end
                elseif  yu==3 then
                   if shang<3 then
                      res[shang+36]=1
                   else
                      res[shang+23]=1
                   end
                end
            end
        end
    end
    return res
end

return CommonLgcObject.new()    
