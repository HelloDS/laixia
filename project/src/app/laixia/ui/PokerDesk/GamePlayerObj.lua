
local GameCardObject = import(".GameCardObject");
local CardType = import("..uiData.PokerType");
local CommonLgcObject = import(".CommonLgcObject")
local soundConfig =  laixia.soundcfg    

local GamePlayerObj = class("GamePlayerObj", function()
    return ccui.Layout:create()
end ) 
--aiPokers 手中的牌值
--aiSeat    座位号（创建牌座位号）
--params    参数表
    --params.isHandCard  是否是手牌
    --params.isOpen    是否明牌
    --params.isAniFinsih   是否播放动画
    --params.atlsL    左边剩余排数UI
    --params.atlsR    右边剩余排数UI
    --params.selfSeat 自己座位号
    --params.isDealBottomAni 发地主底牌动画是否完成
    --params.laiziPoker -- 癞子值
function GamePlayerObj:ctor(aiPokers, aiSeat,params)
    self:addTouchEventListener(function (sender,event)
        self:choosePokers(sender,event)
    end)
    self:setTouchEnabled(true)
    self:setAnchorPoint(cc.p(0.5, 0.5))
    self.mMaxWidth = 1360       -- 整副牌宽度
    self.mScale = 0.437         --自己手牌缩放系数
    self.mPokerWidth = 174      --扑克宽度
    self.mPokerHeight = 224     --扑克高度
    self.mMaxGap = 40 * 2.32    -- 最大牌间距（2.32缩放系数）
    self.mLayoutLength = 0      -- 自己长度
    self.mGap = 0               --牌间距
    self.mSeat = aiSeat         -- 自己的座位号
    self.mSeatPosition = nil    --自己在牌桌上摆放位置 -1：左边 0：自己 1：右边
    self.mParams = params or {} --附加参数表数据
    self.mPokerList = { }       -- 手中的牌
    self.mSelectCard = { }      -- 选则的牌
    self.mOutPokersIndex = {}  --最后一手有效牌值
    self.mOutPokekrs = {}      --最后出牌信息

    self.mX = -100              --滑动时X坐标点X
    self.mBeginX = -100         --开始滑动坐标点X
    self.mBeginPokerIndex = nil --滑动开始的牌索引
    self.mEndPokerIndex = nil   --滑动结束的牌索引
    self.mFirstPokerX = 0       --第一张牌的索引
    self.mLastPokerX = 0        --最后一张牌的索引


    self.isAniFinsih = self.mParams.isAniFinsih or false        --动画是否需要播放
    self.isDealBottomAni = self.mParams.isAniFinsih or false    --发地主底牌动画是否完成
    self.isOpen = self.mParams.isOpen or false                  --名牌状态
    self.isSlipTip = false      --是否已经有滑动选派提示
    self.isMoveSlip = false      --是否滑动选牌

    self.mPokerData = self:resetPokersTable()
    self:setPokersDataIndex(params.laiziPoker)   --设置牌数据的新索引（癞子牌值）
    self:setPokersTable(aiPokers)
    self:createPokers(aiPokers,self.mParams)
    self:setPokerPosition()
    --不是手牌，则初始化地主下角标
    if not params.isHandCard then
        self:showButtonMark()
    end
end
--重置牌表值
    -- 手中牌型模型
    -- {数量，黑，红，片，花}
    -- 3~2顺序
function GamePlayerObj:resetPokersTable()
    return {
        -- 初始化表
        { 0, - 1, - 1, - 1, - 1 },-- 3
        { 0, - 1, - 1, - 1, - 1 },-- 4
        { 0, - 1, - 1, - 1, - 1 },-- 5
        { 0, - 1, - 1, - 1, - 1 },-- 6
        { 0, - 1, - 1, - 1, - 1 },-- 7
        { 0, - 1, - 1, - 1, - 1 },-- 8
        { 0, - 1, - 1, - 1, - 1 },-- 9
        { 0, - 1, - 1, - 1, - 1 },-- 10
        { 0, - 1, - 1, - 1, - 1 },-- J
        { 0, - 1, - 1, - 1, - 1 },-- Q
        { 0, - 1, - 1, - 1, - 1 },-- K
        { 0, - 1, - 1, - 1, - 1 },-- A
        { 0, - 1, - 1, - 1, - 1 },-- 2
        { 0, - 1 },-- 小王
        { 0, - 1 }-- 大王
    }
end

function GamePlayerObj:setPokersDataIndex(laizi)
    self.mPokersDataIndex = {}
    if laizi == nil or laizi<0 or laizi > 12 then
        self.mPokersDataIndex = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
    else
        self.mPokersDataIndex = {}
        for i = 1,15 do
            if i~=laizi+1 then
                table.insert(self.mPokersDataIndex,i)
            end
        end
        table.insert(self.mPokersDataIndex,laizi+1)
    end
end
--设置手牌数据表
--aiPokers 变化的牌值
--isSub    ture 减少 false or nil 添加
function GamePlayerObj:setPokersTable(aiPokers,isSub)
    local card_color = 0
    local card_NO = 0
    for i = 1 ,#aiPokers do
        if aiPokers[i].CardValue == 52 then
            if isSub == true then
                self.mPokerData[14][2] = -1
            else
                self.mPokerData[14][2] = 52
            end
        elseif aiPokers[i].CardValue == 53 then
            if isSub == true then
                self.mPokerData[15][2] = -1
            else
                self.mPokerData[15][2] = 53
            end
        else
            card_color = math.floor(aiPokers[i].CardValue / 13) + 2
            card_NO = aiPokers[i].CardValue % 13 + 1
            -- 初始化表
            if isSub == true then
                self.mPokerData[card_NO][card_color] = -1
            else
                self.mPokerData[card_NO][card_color] = aiPokers[i].CardValue
            end
        end
    end
    for index = 1, #self.mPokerData do
        self.mPokerData[index][1] = 0
        for i = 2, #self.mPokerData[index] do
            if self.mPokerData[index][i] >= 0 then
                self.mPokerData[index][1] = self.mPokerData[index][1] + 1
            end
        end
    end
end
--
function GamePlayerObj:setOpen(aiBool)
    self.isOpen = aiBool
end
function GamePlayerObj:getIsOpen()
    return self.isOpen
end

function GamePlayerObj:getPokerList()
    return self.mPokerList
end
function GamePlayerObj:getLayoutLength()
    return self.mLayoutLength
end
-- 创建一张牌
function GamePlayerObj:createPoker(aiPoker)
    return GameCardObject.new(aiPoker)
end
function GamePlayerObj:getPokerData()
    return self.mPokerData 
end
--设置牌型
function GamePlayerObj:SetTipsTypeFunction(aiType)
    if aiType == nil then
        self.mTipsType = CardType.AUTO_CARD; 
    else
        self.mTipsType = aiType 
    end
end
function GamePlayerObj:setOutPokers(aiOutPokersIndex,aiOutPokekrs)
    self.mOutPokersIndex = aiOutPokersIndex
    self.mOutPokekrs = aiOutPokekrs
end
-- 设置所有手牌触摸
function GamePlayerObj:setAllPokersTouch(aiBool)
    for k,v in pairs(self.mPokerList) do
        v:setPokerTouch(aiBool)
    end
end
-- 获得提起的牌数
function GamePlayerObj:getSelectNum()
    local num = 0
    for k,v in pairs(self.mPokerList) do
        if v:isSelect()== true then
            num = num + 1
        end
    end
    return num
end
--设成白色
function GamePlayerObj:clearColor()
    for k,v in pairs(self.mPokerList) do
        v:setCustomColor(255,255,255)
    end
end
--设置成黑色
function GamePlayerObj:setBlack()
    for k,v in pairs(self.mPokerList) do
        v:setCustomColor(94,94,94)
    end
end
--设成蒙黑和牌复位
function GamePlayerObj:setBlackColor()
    for k,v in pairs(self.mPokerList) do
        v:setCustomColor(94,94,94)
        v:recover()
    end
end

--aiCards 提示的牌
--isTip   是不是滑动管牌提示 
--aiTable 随意出牌时，所有选择的牌
function GamePlayerObj:raiseCards(aiCards,isTip,aiTable)
    if aiTable ~= nil  then
        for k,v in pairs(aiTable) do
            self.mPokerList[v]:recover()
        end
    end
    local isRaise = false
    for k,v in pairs(aiCards) do
        if isTip == true then
            if self.mPokerList[v]:isSelect() == false then
                isRaise = true
            end
        else
            self.mPokerList[v]:raise()
        end
    end
    if isTip == true then 
        if isRaise == true then
            for k,v in pairs(aiCards) do
                self.mPokerList[v]:raise()
            end
        else
            for k,v in pairs(aiCards) do
                self.mPokerList[v]:recover()
            end        
        end
    end
end
-- 所有牌 复位
function GamePlayerObj:recover(aiTable)
    if aiTable == nil then
        aiTable = self.mPokerData
    end
    for index = #aiTable, 1, -1 do
        for i = 2, #aiTable[index] do
            if aiTable[index][i] ~= -1 then
                if self.mPokerList[aiTable[index][i]]:isSelect() == true then
                    self.mPokerList[aiTable[index][i]]:recover()
                end
            end
        end
    end
end
-- 选择的牌
-- 只有自己才用到
function GamePlayerObj:selcetPoker()
    self.mSelectCard = nil
    self.mSelectCard = { }
    for index = 1, #self.mPokerData do
        for i = 2, #self.mPokerData[index] do
            if self.mPokerData[index][i] ~= -1 then
                if self.mPokerList[self.mPokerData[index][i]]:isSelect() == true then
                    table.insert(self.mSelectCard, { ["CardValue"] = self.mPokerData[index][i] })
                end
            end
        end
    end
    return self.mSelectCard
end

-- 匹配出的癞子牌
function GamePlayerObj:pokerToLaizi(aiPoker)
    local resuTable = { }
    local ReplaceCardss = clone(laixia.LocalPlayercfg.LaixiaLaiziReplaceCards)
    local yuanshi = clone(aiPoker)
    -- 癞子匹配的牌

    if ReplaceCardss ~= nil and #ReplaceCardss > 0 then

        local length = #aiPoker
            for i = 1, length do
                for j = 1, #ReplaceCardss do
                local num =-1
                if yuanshi[i].CardValue <52 then  --考虑到有王的情况 --癞子也不可能为王
                   num = yuanshi[i].CardValue %13
                else
                   num  = yuanshi[i].CardValue %13+13
                end
                 
                    if num == ReplaceCardss[j].CardValue then
                         ReplaceCardss[j].CardValue = -1
                         yuanshi[i].CardValue= -1
                        break
                    end
                end
            end

       
        for i = 1, #aiPoker do
            local tempTable = { }
            tempTable.CardValue = -1
            tempTable.ReplaceCardss = -1

            tempTable.CardValue = aiPoker[i].CardValue

            for j = 1, length do
                if yuanshi[j].CardValue >= 0 and yuanshi[j].CardValue< 52 and tempTable.CardValue == yuanshi[j].CardValue then
                    yuanshi[j].CardValue= -1
                    for m1 = 1, #ReplaceCardss do
                        if ReplaceCardss[m1].CardValue >= 0 then
                            tempTable.ReplaceCardss = ReplaceCardss[m1].CardValue
                            ReplaceCardss[m1].CardValue=-1
                            break
                        end
                    end
                    break
                end
            end
            table.insert(resuTable, tempTable)
        end 

        for so1 =1,#resuTable  do
                    resuTable[so1].sort =-1
                if resuTable[so1].ReplaceCardss>=0  then
                    resuTable[so1].sort =resuTable[so1].ReplaceCardss
                elseif resuTable[so1].CardValue <52 then 
                    resuTable[so1].sort = resuTable[so1].CardValue%13
                else
                    resuTable[so1].sort = resuTable[so1].CardValue%13+13
                end
        end


        for so2 =1, #resuTable do
            for so3=1, #resuTable-1 do
                if resuTable[so3].sort > resuTable[so3+1].sort then
                    local temp = resuTable[so3+1]
                    resuTable[so3+1] = resuTable[so3]
                    resuTable[so3] = temp
                end
            end
        end

     else
        for i = 1, #aiPoker do
            local tempTable = { }
            tempTable.CardValue = -1
            tempTable.ReplaceCardss = -1
            tempTable.CardValue = aiPoker[i].CardValue

            table.insert(resuTable, tempTable)
        end

    end


    return resuTable

end

--创建手牌 
--玩家自己的手牌设置滑动触摸位置
function GamePlayerObj:createPokers(aiPoker,params)
    local num = #aiPoker
   
    local resutem = self:pokerToLaizi(aiPoker)
    for index = 1, num do
        self.mPokerList[resutem[index].CardValue] = GameCardObject.new(resutem[index])
        self.mPokerList[resutem[index].CardValue]:setLocalZOrder(10)
        self.mPokerList[resutem[index].CardValue]:addTo(self)
        if self.mSeat == params.selfSeat and self.isAniFinsih ~= true and self.mParams.isHandCard == true then
            self.mPokerList[resutem[index].CardValue]:setVisible(false)  
        end
        if params.isHandCard ~= true or self.mSeat ~= params.selfSeat then
            self.mPokerList[resutem[index].CardValue]:setScale(self.mScale)
        end
    end
    --玩家自己的手牌设置滑动触摸位置
    if self.mSeat == params.selfSeat  and params.isHandCard == true  then
        self:setContentSize(cc.size(self.mMaxWidth,self.mPokerHeight))
        if self.isAniFinsih ~= true then
            self:setTouchEnabled(false) 
        end 
    end  
end
function GamePlayerObj:setPokerZorder()
    local count = 0
    for index = 15, 1, -1 do
        for i = 2, #self.mPokerData[self.mPokersDataIndex[index]] do  --自己手牌的位置设置
            local indexT = self.mPokerData[self.mPokersDataIndex[index]][i]
            if indexT >= 0 then
                self.mPokerList[indexT]:setLocalZOrder(count)
                count = count + 1
            end
        end
    end
end
--设置位置
function GamePlayerObj:setPokerPosition()
    --设置一条线摆放（自己手牌和出的牌使用）
    local num = table.nums(self.mPokerList)
    local setLinePosition = function(aiGap)
        local tWidth = num * aiGap +(self.mPokerWidth - aiGap)
        local tFirstPosition =(self.mMaxWidth - tWidth) / 2
        -- 自己牌里面位置变化计数器
        local count = 0 
        for index = 15, 1, -1 do
            for i = 2, #self.mPokerData[self.mPokersDataIndex[index]] do  --自己手牌的位置设置
                local indexT = self.mPokerData[self.mPokersDataIndex[index]][i]
                if indexT >= 0 then
                    self.mPokerList[indexT]:setPosition(cc.p(tFirstPosition + aiGap * count + 88 , self.mPokerHeight * 0.5 ))
                    self.mPokerList[indexT]:recover()
                    self.mPokerList[indexT]:setLocalZOrder(count)
                    count = count + 1
                end
            end
        end 
        if self.mSeat == self.mParams.selfSeat then
            self:playDealAni(self.mParams)    
        end
    end
    local setOutLinePosition = function()
        local outPoker={}
        local count = 0 
        for index = 15, 1, -1 do
            for i = 2, #self.mPokerData[self.mPokersDataIndex[index]] do
                if self.mPokerData[self.mPokersDataIndex[index]][i] ~= -1 then
                    if ui.CardTableDialog.bDelInfoDisplay == false  then
                        local outindex = self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:getIndex();
                        if outindex.ReplaceCardss==nil or outindex.ReplaceCardss == -1 then
                            if outindex.CardValue >= 52 then
                                outindex.ReplaceCardss = outindex.CardValue%13+13
                            else
                                outindex.ReplaceCardss = outindex.CardValue%13
                            end
                        end
                        table.insert(outPoker,outindex)
                    else  -- 用于处理结算亮牌
                        self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setPosition(cc.p(34 *count, 41))
                        self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setLocalZOrder(count)
                        count = count + 1
                    end
                end
            end
        end 
        if #outPoker > 0 then
            for so1 =1,#outPoker do --对出的牌进行排序
                for so2 =1, #outPoker-1 do
                    if outPoker[so2].ReplaceCardss <outPoker[so2+1].ReplaceCardss then
                        local temp = outPoker[so2+1]
                        outPoker[so2+1]=outPoker[so2]
                        outPoker[so2]= temp
                    end
                end
            end
            count = 0 
            for show1 =1, #outPoker do -- 输出排序后的牌的位置
                self.mPokerList[outPoker[show1].CardValue]:setPosition(cc.p(34 *count, 41))
                self.mPokerList[outPoker[show1].CardValue]:setLocalZOrder(count)
                count = count + 1
            end
        end
    end

    --设置其他玩家名牌时，手牌摆放
    local setOtherPosition = function()
        local count = 0
        for index = 15 ,1,-1 do
            for i = 2,#self.mPokerData[self.mPokersDataIndex[index]] do
                local indexT = self.mPokerData[self.mPokersDataIndex[index]][i]
                if indexT>= 0 then
                    self.mPokerList[indexT]:setPosition(cc.p( count%5*29 ,-44* math.floor(count/5) ) )
                    self.mPokerList[indexT]:setLocalZOrder(count)
                    count = count + 1
                end
            end
        end 
        if count >= 5 then
            self.mLayoutLength =  29*4 + 76
        else
            self.mLayoutLength =  29*(count - 1) + 76
        end
    end
    --设置左右两边出牌位置摆放
    local setOtherOutPosition = function(aiSide)
        local outPoker={}
        local count = 0 
        if  aiSide == "LEFT" then
            for index = 15 ,1,-1 do
                for i = 2,#self.mPokerData[self.mPokersDataIndex[index]] do
                    if self.mPokerData[self.mPokersDataIndex[index]][i] >= 0 then
                        if ui.CardTableDialog.bDelInfoDisplay == false then
                            local outindex = self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:getIndex();
                            if outindex.ReplaceCardss==nil or outindex.ReplaceCardss == -1 then
                                if outindex.CardValue >= 52 then
                                    outindex.ReplaceCardss = outindex.CardValue%13+13
                               else
                                    outindex.ReplaceCardss = outindex.CardValue%13
                               end
                            end
                            table.insert(outPoker,outindex)
                        else --  用于处理最后结算的时候亮牌
                            self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setLocalZOrder(count)
                            count = count + 1
                            if count < 11 then
                                self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setPosition(cc.p(34 *(count - 1), 41))
                            else
                                self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setPosition(cc.p(34 *(count - 11), 0))
                            end
                        end
                    end
                end
            end 
            if #outPoker > 0 then
                for so1 =1,#outPoker do --对出的牌进行排序
                    for so2 =1, #outPoker-1 do
                      if outPoker[so2].ReplaceCardss <outPoker[so2+1].ReplaceCardss then
                         local temp = outPoker[so2+1]
                         outPoker[so2+1]=outPoker[so2]
                         outPoker[so2]= temp
                      end
                    end
                end
                count = 0 
                for show1 =1, #outPoker do -- 输出排序后的牌的位置
                    self.mPokerList[outPoker[show1].CardValue]:setLocalZOrder(count)
                    count = count + 1
                    if count < 11 then
                        self.mPokerList[outPoker[show1].CardValue]:setPosition(cc.p(34 *(count - 1), 41))
                    else
                        self.mPokerList[outPoker[show1].CardValue]:setPosition(cc.p(34 *(count - 11), 0))
                    end
                end	
            end
        elseif  aiSide == "RIGHT" then
            for index = 15 ,1,-1 do
                for i = 2,#self.mPokerData[self.mPokersDataIndex[index]] do
                    if self.mPokerData[self.mPokersDataIndex[index]][i] >= 0 then
                        if ui.CardTableDialog.bDelInfoDisplay == false  then
                            local outindex = self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:getIndex();
                            if outindex.ReplaceCardss==nil or outindex.ReplaceCardss == -1 then
                                if outindex.CardValue >= 52 then
                                    outindex.ReplaceCardss = outindex.CardValue%13+13
                                else
                                    outindex.ReplaceCardss = outindex.CardValue%13
                                end
                            end
                            table.insert(outPoker,outindex)
                        else -- 用于最后的结算亮牌
                            self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setLocalZOrder(count)
                            count = count + 1
                            if count < 11 then
                                self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setPosition(cc.p(34 *(count - 1), 41))
                            else
                                self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:setPosition(cc.p( 34 *(9 - num +  count), 0))
                            end
                        end
                    end
                end
            end
            if #outPoker > 0 then
                 for so1 =1,#outPoker do --对出的牌进行排序
                    for so2 =1, #outPoker-1 do
                      if outPoker[so2].ReplaceCardss <outPoker[so2+1].ReplaceCardss then
                         local temp = outPoker[so2+1]
                         outPoker[so2+1]=outPoker[so2]
                         outPoker[so2]= temp
                      end
                    end
                end
                count = 0 
                for show1 =1, #outPoker do -- 输出排序后的牌的位置
                    self.mPokerList[outPoker[show1].CardValue]:setLocalZOrder(count)
                    count = count + 1
                     if count < 11 then
                          self.mPokerList[outPoker[show1].CardValue]:setPosition(cc.p(34 *(count - 1), 41))
                     else
                         self.mPokerList[outPoker[show1].CardValue]:setPosition(cc.p( 34 *(9 - num +  count), 0))     
                     end
                end	
            end	
        end
    end
    if self.mParams.selfSeat == self.mSeat then
        local tGap = 0
        if self.mParams.isHandCard == true then
            if self.mMaxWidth >= self.mMaxGap * num +(self.mPokerWidth- self.mMaxGap) then
                tGap = self.mMaxGap-- 使用最大空隙放牌
                self.mLayoutLength = self.mMaxGap * num +(self.mPokerWidth - self.mMaxGap)
            else
                tGap =(self.mMaxWidth - self.mPokerWidth) / num-- 空隙
                self.mLayoutLength = self.mMaxWidth
            end
            self.mGap = tGap
            setLinePosition(tGap)
        else
            self.mGap = 34
            tGap = 34
            setOutLinePosition(tGap)
        end
    end 
    if self.mParams.selfSeat == (self.mSeat + 2)%3 then
        if  self.mParams.isHandCard == true then
            setOtherPosition()
        else
            setOtherOutPosition("RIGHT")
        end
    end
    if  self.mParams.selfSeat == (self.mSeat + 4)%3 then
        if  self.mParams.isHandCard == true then
            setOtherPosition()
        else
            setOtherOutPosition("LEFT")
        end
    end
    --self:showMark()
end

--播放发牌动画
function GamePlayerObj:playDealAni(aiTable)
    if self.mSeat == aiTable.selfSeat  and   aiTable.isAniFinsih ~= true and aiTable.isHandCard == true then
        --应当播放动画
    else
        return   
    end   
    local t = {}
    local count = 0;
    for index = 15,1,-1 do
        for i = 2,#self.mPokerData[self.mPokersDataIndex[index]] do
            if self.mPokerData[self.mPokersDataIndex[index]][i] >= 0 then
                table.insert(t,self.mPokerData[self.mPokersDataIndex[index]][i])
                count = count + 1
            end
        end
    end
    function ani(num)
        if num < count then
            num = num + 1
            if self.mPokerList == nil then
                --在发牌时进入后台，会有清理数据短线重连，所以要终止动画
                return
            end
            self.mPokerList[t[num]]:setLocalZOrder(num)
            transition.execute(self.mPokerList[t[num]]  , cc.FadeIn:create(0.01), {
                delay = 0.95/17,
                onComplete = function()
                    self.mPokerList[t[num]]:setVisible(true)
                    aiTable.atlsR:setString(tonumber(aiTable.atlsR:getString()) + 1 )
                    aiTable.atlsL:setString(tonumber(aiTable.atlsL:getString()) + 1 )
                    ani(num)
                end,
            })
        else
            self:setTouchEnabled(true)
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DEALANI_LANDLORDTABLE_WINDOW);
            aiTable.isAniFinsih = true
        end
    end 
    ani(0)
    self:showMark()       
end

--获得最右边的牌值
function GamePlayerObj:getMinCard()
    for i = 1,15 do
        for j = #self.mPokerData[self.mPokersDataIndex[i]],2,-1 do
            if self.mPokerData[self.mPokersDataIndex[i]][j] >= 0 then
                return self.mPokerData[self.mPokersDataIndex[i]][j]
            end
        end
    end
end

--显示地主标签
--找到最右边的那张牌并且显示地主标签
function GamePlayerObj:showMark()
    if self.mSeat == laixia.LocalPlayercfg.LaixiaLandlordSeat then
        local mark = false
        for i = 1,15 do
            for j = #self.mPokerData[self.mPokersDataIndex[i]],2,-1 do
                local indexT = self.mPokerData[self.mPokersDataIndex[i]][j]
                if indexT >= 0 then
                    self.mPokerList[indexT]:setTopMarkVisible(true)
                    mark = true
                    break -- 其实全部注释掉也是可以的
                end
            end
            if mark then
                break
            end
        end
    end 
end

function GamePlayerObj:showButtonMark()
    if self.mSeat == laixia.LocalPlayercfg.LaixiaLandlordSeat then
        local mark = false
        for i = 1,15 do
            for j = #self.mPokerData[self.mPokersDataIndex[i]],2,-1 do
                local indexT = self.mPokerData[self.mPokersDataIndex[i]][j]
                if indexT >= 0 then
                    self.mPokerList[indexT]:setBottomMarkVisible(true)
                    mark = true
                    break
                end
            end
            if mark then
                break
            end
        end
    end 
end
-- 提示
function GamePlayerObj:hintPokers(aiPokers)
    for index = 1, #aiPokers do
        self.mPokerList[aiPokers[index]]:raise()
    end
end

--出牌失败
function GamePlayerObj:resetPokersCards(aiPokers)
    for index = 1, #aiPokers do
        self.mPokerList[aiPokers[index].CardValue] =  GameCardObject.new(aiPokers[index])
        if self.mParams.selfSeat == self.mSeat then
            self.mPokerList[aiPokers[index].CardValue]:setPokerTouch(true)
        end
        self.mPokerList[aiPokers[index].CardValue]:addTo(self)
        self:setPokersTable(aiPokers)
    end
    laixia.logGame("出牌撤销")
    self:setPokerPosition()
    self:showMark()
    self:setPokerZorder()
end

--添加地主底牌操作
--aiPokers 发的三张地主底牌
--aiSeat   座位号
--aiBar    显示出牌操作条 自己时候添加，直接操作牌桌出牌条，以后可以考虑降低耦合
function GamePlayerObj:addBottomPokers(aiPokers,aiSeat,aiBar)
    if aiSeat == self.mParams.selfSeat then
        for index = 1, #aiPokers do
            self.mPokerList[aiPokers[index].CardValue] =  GameCardObject.new(aiPokers[index])
            if self.mParams.selfSeat == self.mSeat then
                self.mPokerList[aiPokers[index].CardValue]:setPokerTouch(true)
            end
            self.mPokerList[aiPokers[index].CardValue]:addTo(self)
            self:setPokersTable(aiPokers)
        end
        laixia.logGame("添加地主底牌改变自己牌位置")
        self:setPokerPosition()
        self:showMark()
        self.isDealBottomAni = true
        local count = 0
        for k,v in pairs( self.mPokerList) do
            for j = 1,3 do
                if v:getIndex().CardValue == aiPokers[j].CardValue then
                    v:setPosition(cc.p(v:getPositionX(),139))
                    transition.execute(v, cc.MoveTo:create(0.1,cc.p(v:getPositionX(),139)), {
                                delay = 0,
                                onComplete = function()
                                transition.execute(v, cc.MoveTo:create(0.1,cc.p(v:getPositionX(),114)), {
                                            delay = 0,
                                            onComplete = function()
                                                count = count + 1
                                                if count == 3 then
                                                    --显示操作按钮
                                                    if aiBar ~= nil then
                                                        aiBar:setVisible(true)
                                                    end
                                                    self.isDealBottomAni = false
                                                end
                                            end,
                                        })
                                end,
                            })
                end
            end
        end

    else
        self.mParams.atls:setString(tonumber( self.mParams.atls:getString()) + 3)
    end    
end

--删掉出牌
--aiPokers  出的牌值
--aiSeat    座位号（出牌座位号）
--params    参数表
    --params.isOpen    是否明牌
    --params.isAniFinsih   是否播放动画
    --params.atls    剩余排数UI
    --params.selfSeat 自己座位号
function GamePlayerObj:playHand(aiPokers,aiSeat,params)
    local param = function()
        if params ~= nil then
            return params
        else
            return {
                selfSeat = self.mParams.selfSeat
            }
        end
    end
    local outPokerLayer = self.new(aiPokers,aiSeat or self.mSeat ,params or param())-- 出的牌
    local seat = aiSeat or self.mSeat
    local selfSeat = function() 
        if params ~= nil then 
            return params.selfSeat or self.mParams.selfSeat
        else
            return self.mParams.selfSeat
        end  
    end 
    --移除自己出的牌
    if seat == selfSeat()  then
        self:stopBottomAni()
        for index = 1, #aiPokers do
            if self.mPokerList[aiPokers[index].CardValue] then
                self.mPokerList[aiPokers[index].CardValue]:removeFromParent()
                self.mPokerList[aiPokers[index].CardValue] = nil
            end
        end
        self:setPokersTable(aiPokers,true)
        laixia.logGame("GamePlayerObj:playHand()自己出牌改变位置 ")
        self:setPokerPosition()
    else
        if self.isOpen == true then
            for index = 1, #aiPokers do
                if self.mPokerList[aiPokers[index].CardValue] then
                    self.mPokerList[aiPokers[index].CardValue]:removeFromParent()
                    self.mPokerList[aiPokers[index].CardValue] = nil
                end
            end
            self:setPokersTable(aiPokers,true)
            self:setPokerPosition()
        end
    end
    self:showMark()
    self:setPokerZorder()
    return outPokerLayer
end

-- 牌的触摸
function GamePlayerObj:setPokerTouch(aiBool)
    --local count = 0;
    -- 自己牌里面位置变化计数器
    for index = 15, 1, -1 do
        for i = 2, #self.mPokerData[index] do
            if self.mPokerData[index][i] ~= -1 then
                self.mPokerList[self.mPokerData[index][i]]:setTouchEnabled(aiBool)
                --self.mPokerList[self.mPokerData[index][i]]:setLocalZOrder(count)
                --count = count + 1
            end
        end
    end
end
--停止发底牌动画
function GamePlayerObj:stopBottomAni()
    if self.isDealBottomAni == true then
        for i = 1,15 do
            for j = 2,#self.mPokerData[self.mPokersDataIndex[i]] do
                if self.mPokerData[self.mPokersDataIndex[i]][j] >= 0 then
                    transition.stopTarget(self.mPokerList[self.mPokerData[self.mPokersDataIndex[i]][j]])
                    self.mPokerList[self.mPokerData[self.mPokersDataIndex[i]][j]]:recover()
                end           
            end
        end
        self.isDealBottomAni = false             
    end
end

--滑动时牌上下变化动作
function GamePlayerObj:choosePokerChange(aiX)
    self:clearColor()
    if aiX < self.mLeftPokerX - self.mPokerWidth * 0.5  then
        self.mEndX = -100
    elseif aiX > self.mRightPokerX +self.mPokerWidth * 0.5  then
        self.mEndX = 2000
    else
        for index = 15 ,1,-1 do
            for i = 2,#self.mPokerData[self.mPokersDataIndex[index]] do
                if self.mPokerData[self.mPokersDataIndex[index]][i]>= 0 then
                    local x = self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:getPositionX()
                    if x - self.mPokerWidth * 0.5  <= aiX and aiX <= x - self.mPokerWidth * 0.5  + self.mGap then
                        self.mEndX = x
                    end
                end
            end
        end            
    end
    if aiX > self.mBeginX then 
        for index = 0,53 do
            if self.mPokerList[index] ~= nil then
                local x = self.mPokerList[index]:getPositionX()
                if  self.mStartX <= x and x <=  self.mEndX then
                    self.mPokerList[index]:setCustomColor(94,94,94)
                end
            end            
        end
    elseif aiX <= self.mBeginX then
        for index = 0,53 do
            if self.mPokerList[index] ~= nil then
                local x = self.mPokerList[index]:getPositionX()
                if x == self.mRightPokerX and aiX < x + self.mPokerWidth * 0.5 and self.mStartX == 2000 then
                    self.mPokerList[index]:setCustomColor(94,94,94)
                end
                if  self.mStartX >= x and x >=  self.mEndX then
                    self.mPokerList[index]:setCustomColor(94,94,94)
                end
            end            
        end        
    end
end
--
function GamePlayerObj:chooseChange(aiX)
    self:clearColor()
    if aiX < self.mLeftPokerX - self.mPokerWidth * 0.5  then
        self.mEndX = -100
    elseif aiX > self.mRightPokerX - self.mPokerWidth * 0.5 + self.mGap and aiX > self.mBeginX then
        self.mEndX = 1300
    elseif aiX > self.mRightPokerX + self.mPokerWidth * 0.5 and aiX <= self.mBeginX then
        self.mEndX = 1300
    else
        for index = 15 ,1,-1 do
            for i = 2,#self.mPokerData[self.mPokersDataIndex[index]] do
                if self.mPokerData[self.mPokersDataIndex[index]][i]>= 0 then
                    local x = self.mPokerList[self.mPokerData[self.mPokersDataIndex[index]][i]]:getPositionX()
                    if x == self.mRightPokerX and  x - self.mPokerWidth * 0.5 + self.mGap < aiX and aiX <= x + self.mPokerWidth * 0.5  then
                        self.mEndX = x  - self.mGap + 1  
                    elseif x -self.mPokerWidth * 0.5  <= aiX and aiX <= x - self.mPokerWidth * 0.5  + self.mGap then
                        self.mEndX = x
                    end
                end
            end
        end            
    end
    local selectCard = self:resetPokersTable()
    local isHaveRaise = false --是否有选取牌
    local function newTableData(aiIndex)   --创建一个选这个牌Data表
        if self.mPokerList[aiIndex.CardValue]:isSelect() == true then
            isHaveRaise = true
        end
        if aiIndex.CardValue == 52 then
            selectCard[14][2] = 52
            selectCard[14][1] = 1
        elseif aiIndex.CardValue == 53 then
            selectCard[15][2] = 53
            selectCard[15][1] = 1
        else
            local card_color = math.floor(aiIndex.CardValue / 13) + 2
            local card_NO = aiIndex.CardValue % 13 + 1
            selectCard[card_NO][card_color] = aiIndex.CardValue
            selectCard[card_NO][1] = selectCard[card_NO][1] + 1
        end        
    end;
    if aiX > self.mBeginX then 
        for index = 0,53 do
            if self.mPokerList[index] ~= nil then
                local x = self.mPokerList[index]:getPositionX()
                if  self.mStartX <= x and x <=  self.mEndX then
                    newTableData(self.mPokerList[index]:getIndex())
                end
            end            
        end
    elseif aiX <= self.mBeginX then
        for index = 0,53 do
            if self.mPokerList[index] ~= nil then
                local x = self.mPokerList[index]:getPositionX()
                if  self.mStartX  >= x and x >=  self.mEndX then
                    newTableData(self.mPokerList[index]:getIndex())
                end
            end            
        end        
    end
    if  self.isMoveSlip == true then
        local lastRaiseData = {}
        local isSelect =false       -- 获取原有上选牌的状态（有、无）
        for k,v in pairs(self.mPokerList) do
            if v:isSelect() then
                lastRaiseData[k]=1
                isSelect = true
            end 
        end
        local dataTable = CommonLgcObject:GameNewAiFunction(1,selectCard,isSelect,lastRaiseData,self.mPokerList,self.mOutPokersIndex)
        --重置牌（都下来）
        
        for k,v in pairs(self.mPokerList) do   
            if v:isSelect() then
                v:recover()
            end
        end

        --设置选择牌（上去）
        if(dataTable ~= nil) then
            for k,v in ipairs(dataTable) do 
                if self.mPokerList[v] then
                    self.mPokerList[v]:raise()
                end
            end
        end 
        --优先判定有牌选中则牌取反
    else
        for i = 1,15 do
            for j = 2,#selectCard[i] do
                if selectCard[i][j] >= 0 then
                    if self.mPokerList[selectCard[i][j]]:isSelect() == false then
                        self.mPokerList[selectCard[i][j]]:raise()
                    else
                        self.mPokerList[selectCard[i][j]]:recover()
                    end 
                end           
            end
        end        
    end
    laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_select_sheet)
end

--滑动选牌  牌宽264
function GamePlayerObj:choosePokers(sender,event)
    if event == 0 then
        self:stopBottomAni()
        self.isMoveSlip = false
        self.mBeginX = self:convertToNodeSpace(sender:getTouchBeganPosition()).x 
        self.mX = self.mBeginX
        self.mLeftPokerX = -100 
        self.mRightPokerX = 2000 
        local isLeftFind = false
        local isRightFind = false
        for index = 15 ,1,-1 do
            for i = 2,#self.mPokerData[self.mPokersDataIndex[index]] do
                if self.mPokerData[self.mPokersDataIndex[index]][i] >= 0 then
                    self.mLeftPokerX = self.mPokerList[ self.mPokerData[self.mPokersDataIndex[index]][i]]:getPositionX()
                    isLeftFind = true
                    break
                end
            end
            if isLeftFind ==  true then
                break
            end
        end
        for index = 1,15 do
            for i = #self.mPokerData[self.mPokersDataIndex[index]],2,-1 do
                if self.mPokerData[self.mPokersDataIndex[index]][i] >= 0 then
                    self.mRightPokerX = self.mPokerList[ self.mPokerData[self.mPokersDataIndex[index]][i]]:getPositionX()
                    isRightFind = true
                    break
                end
            end
            if isRightFind ==  true then
                break
            end
        end
        if self.mBeginX > self.mRightPokerX - self.mPokerWidth * 0.5 + self.mGap then
            self.mStartX = 2000
        elseif self.mBeginX < self.mLeftPokerX - self.mPokerWidth * 0.5 then
            self.mStartX = -100
        else
            for index = 0,53 do
                if self.mPokerList[index] ~= nil then
                    local x = self.mPokerList[index]:getPositionX()
                    if  x - self.mPokerWidth * 0.5 <= self.mBeginX and self.mBeginX <= x -self.mPokerWidth * 0.5 + self.mGap then
                        self.mStartX = x
                        return
                    end
                end
            end
        end
        self.mEndX = self.mStartX 
    elseif event == 1 then
        local x =  self:convertToNodeSpace(sender:getTouchMovePosition()).x
        --10 延迟变动点
        if math.abs(x - self.mX) >= 10 then
            self.mX = x
            self:choosePokerChange(x)
            self.isMoveSlip = true
        end
    else
        local x = self:convertToNodeSpace(sender:getTouchEndPosition()).x
        self:chooseChange(x)
        local isHave = false;   --↓↓↓↓控制重置 出牌按钮
        for index = 0,53 do
            if self.mPokerList[index] ~= nil then
                if self.mPokerList[index]:isSelect() == true then
                    isHave = true
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_COMPUTECART_LANDLORDTABLE_WINDOW,true)
                    break
                end
            end            
        end
        if isHave == false then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_COMPUTECART_LANDLORDTABLE_WINDOW,false)
        end  
    end
end









-- 删除出掉牌(要废掉?)
function GamePlayerObj:deleteOutPoker(aiPokers)
    local outPokerLayer = ccui.Layout:create();-- 出的牌
    for index = 1, #aiPokers do
        local poker = GameCardObject.new(aiPokers[index])
        poker:setScale(self.mScale)
        poker:addTo(outPokerLayer)
        if index < 11 then
            poker:setPosition(cc.p(34 *(index - 1), 41))
        else
            poker:setPosition(cc.p(34 *(index - 11), 0))
        end
    end
    return outPokerLayer
end

return GamePlayerObj

--endregion
