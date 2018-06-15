--region 单张牌

local GameCardObject = class ("GameCardObject",function()
    return  ccui.Layout:create()
end) 

--aiPoker 牌
--isBottomLast  地主最后一张牌
function GameCardObject:ctor(aiPoker, isBottomLast)
    if aiPoker ~= "paizheng" and aiPoker ~= "paibei" then
       
        local index =0
        local colornum = 0
        if aiPoker.CardValue~=nil  then
            index = aiPoker.CardValue % 13
            colornum=aiPoker.CardValue
        else 
            index = aiPoker % 13
            colornum=aiPoker
        end
        

        if index == ui.CardTableDialog.hLaiziCard  and aiPoker.CardValue < 52 then  -- 要处理大小王的问题
            if aiPoker.ReplaceCardss~= nil and   aiPoker.ReplaceCardss >= 0 then
                index = aiPoker.ReplaceCardss 
            end
            self.mPoker = ccui.ImageView:create("new_ui/common/new_common/paizheng.png",0)
            -- self.mIndexImage = ccui.ImageView:create("PokerNumberLZ" .. index .. ".png", 1)
            self.mIndexImage = ccui.ImageView:create("new_ui/common/poker/".."PokerNumberLZ" .. index .. ".png", 0)
            self.mIndexImage:addTo(self.mPoker)
            -- self.mIndexColor = ccui.ImageView:create("laizi_small.png", 1)
            self.mIndexColor = ccui.ImageView:create("new_ui/common/poker/".."laizi_small.png",0)
            self.mIndexColor:addTo(self.mPoker)
            -- self.mColor = ccui.ImageView:create("laizi.png", 1)
            self.mColor = ccui.ImageView:create("new_ui/common/poker/".."laizi.png",0)
            self.mColor:addTo(self.mPoker)
            self.mIndexImage:setPosition(cc.p(32, 197))
            self.mIndexColor:setPosition(cc.p(31, 147))
            self.mColor:setPosition(cc.p(120, 50))

        else

            local color = math.floor(colornum / 13)
            self.mPoker = ccui.ImageView:create("new_ui/common/new_common/paizheng.png",0)
            if color == 0 or color == 3 then
                -- self.mIndexImage = ccui.ImageView:create("PokerNumber" .. index .. "1.png", 1)
                self.mIndexImage = ccui.ImageView:create("new_ui/common/poker/".."PokerNumber" .. index .. "1.png",0)
                self.mIndexImage:setPosition(cc.p(32, 197))
                self.mIndexImage:addTo(self.mPoker)
            elseif color == 1 or color == 2 then
                -- self.mIndexImage = ccui.ImageView:create("PokerNumber" .. index .. "2.png", 1)
                self.mIndexImage = ccui.ImageView:create("new_ui/common/poker/".."PokerNumber" .. index .. "2.png",0)
                self.mIndexImage:setPosition(cc.p(32, 197))
                self.mIndexImage:addTo(self.mPoker)
            end

            if color == 0 then
                -- self.mIndexColor = ccui.ImageView:create("Colorlittle0.png", 1)
                self.mIndexColor = ccui.ImageView:create("new_ui/common/poker/".."Colorlittle0.png",0)
                -- self.mColor = ccui.ImageView:create("Color0.png", 1)
                self.mColor = ccui.ImageView:create("new_ui/common/poker/".."Color0.png",0)
            elseif color == 1 then
                -- self.mIndexColor = ccui.ImageView:create("Colorlittle1.png", 1)
                self.mIndexColor = ccui.ImageView:create("new_ui/common/poker/".."Colorlittle1.png",0)
                -- self.mColor = ccui.ImageView:create("Color1.png", 1)
                self.mColor = ccui.ImageView:create("new_ui/common/poker/".."Color1.png",0)
            elseif color == 2 then
                -- self.mIndexColor = ccui.ImageView:create("Colorlittle2.png", 1)
                self.mIndexColor = ccui.ImageView:create("new_ui/common/poker/".."Colorlittle2.png",0)
                -- self.mColor = ccui.ImageView:create("Color2.png", 1)
                self.mColor = ccui.ImageView:create("new_ui/common/poker/".."Color2.png",0)
            elseif color == 3 then
                -- self.mIndexColor = ccui.ImageView:create("Colorlittle3.png", 1)
                self.mIndexColor = ccui.ImageView:create("new_ui/common/poker/".."Colorlittle3.png",0)
                -- self.mColor = ccui.ImageView:create("Color3.png", 1)
                self.mColor = ccui.ImageView:create("new_ui/common/poker/".."Color3.png",0)
            end
            if color ~= 4 then
                self.mIndexColor:setPosition(cc.p(31, 147))
                self.mColor:setPosition(cc.p(120, 50))
                self.mIndexColor:addTo(self.mPoker)
                self.mColor:addTo(self.mPoker)
                self:setLocalZOrder(53 - index * 4 - 3 + color)
            end
            if color == 4 and index == 0 then
                -- self.mIndexImage = ccui.ImageView:create("littlejoker.png", 1)
                self.mIndexImage = ccui.ImageView:create("new_ui/common/poker/".."littlejoker.png",0)
                -- self.mColor = ccui.ImageView:create("littlejoker_man.png", 1)
                self.mColor = ccui.ImageView:create("new_ui/common/poker/".."littlejoker_man.png",0)
                self.mIndexImage:setPosition(cc.p(28, 126))
                self.mColor:setPosition(cc.p(103, 83))
                self.mIndexImage:addTo(self.mPoker)
                self.mColor:addTo(self.mPoker)
                self:setLocalZOrder(1)
            end
            if color == 4 and index == 1 then
                -- self.mIndexImage = ccui.ImageView:create("Poker_dawang_Joker.png", 1)
                self.mIndexImage = ccui.ImageView:create("new_ui/common/poker/".."Poker_dawang_Joker.png",0)
                -- self.mColor = ccui.ImageView:create("bigjoker_man.png", 1)
                self.mColor = ccui.ImageView:create("new_ui/common/poker/".."bigjoker_man.png",0)
                self.mIndexImage:setPosition(cc.p(28, 126))
                self.mColor:setPosition(cc.p(103, 83))
                self.mIndexImage:addTo(self.mPoker)
                self.mColor:addTo(self.mPoker)
                self:setLocalZOrder(0)
            end
        end
    else
        -- self.mPoker = ccui.ImageView:create(aiPoker .. ".png", 1)
        self.mPoker = ccui.ImageView:create("new_ui/common/poker/"..aiPoker .. ".png",0)

    end
    -- 出牌的地主标
    self.bottomMark = ccui.ImageView:create("new_ui/CardTableDialog/table_dizhupai.png")
    self.bottomMark:addTo(self.mPoker):pos(110, 176)
    self.bottomMark:setVisible(false)
    if isBottomLast ~= nil then
        self.bottomMark:setVisible(true)
    end
    self.mTopMark = ccui.ImageView:create("new_ui/CardTableDialog/table_dizhupai.png")
    self.mTopMark:addTo(self.mPoker):pos(110, 176):setVisible(false)

    self.mPoker:addTo(self)
    self.mPoker:addTouchEventListener( function(sender, eventType)
        self:onTouch(sender, eventType)
    end )
    self.mPoker:setTouchSwallowEnabled(false)
    
    self:setTouchSwallowEnabled(false)
    self.mIndex = aiPoker
    self.isSelected = false
    self:setPositionY(114)
end

function GameCardObject:onEnter()
    print("GameCardObject:onEnter")
end

function GameCardObject:onExit()
    print("GameCardObject:onExit")
end

function GameCardObject:getIndex()
    return self.mIndex
end

function GameCardObject:onTouch(sender,eventType)
    if eventType== 0  then
        if self.isSelected  == false then
            self:raise()
        else
            self:recover()
        end
    end
end

function GameCardObject:setPokerTouch(aiBool)
    --self.mPoker:setTouchEnabled(aiBool)
end
--提牌
function GameCardObject:raise()
    self.isSelected = true
   
    self:setPositionY(139)
end
--牌归位
function GameCardObject:recover()
    self.isSelected = false
    self:setPositionY(114)
end

function setSelect(aiBool)
    self.isSelected = aiBool
end
function GameCardObject:isSelect()
    return  self.isSelected
end

function GameCardObject:setCustomColor(aiR,aiG,aiB) 
    self.mPoker:setColor(cc.c3b(aiR,aiG,aiB))
    self.mIndexImage:setColor(cc.c3b(aiR,aiG,aiB))
    self.mColor:setColor(cc.c3b(aiR,aiG,aiB))
    if self.mIndexColor then
        self.mIndexColor:setColor(cc.c3b(aiR,aiG,aiB))
    end
    self.mTopMark:setColor(cc.c3b(aiR,aiG,aiB))
end

function GameCardObject:setTopMarkVisible(aiBool)
    self.mTopMark:setVisible(aiBool)
end

function GameCardObject:setBottomMarkVisible(aiBool)
    self.bottomMark:setVisible(aiBool)
end

return GameCardObject

--endregion
