
local GameHelp = class("GameHelp", import("...CBaseDialog"):new())
local soundConfig = laixia.soundcfg; 

function GameHelp:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function GameHelp:getName()
    return "GameHelp"
end

function GameHelp:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_HELP_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_HELP_WINDOW, handler(self, self.destroy))
end

function GameHelp:showRule(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:showOnlyButton(1)
        self:onShowOnlyListView(1)

        self.mGrade:setVisible(false)
        self:onShowOnlyTitle(self:GetWidgetByName("Image_GameRule_Title_Rule"))
    end
end


function GameHelp:initGameRule()
    for k, v in ipairs(self.gameInstruction) do
        if v.Type == 1 then
            local questionDiOne  = self.questionDi:clone()
            local answerDiOne = self.answerDi:clone()

            self.listViewRule:pushBackCustomItem(questionDiOne)
            self.listViewRule:pushBackCustomItem(answerDiOne)
    
            questionDiOne:setString(v.explainTitle)
            local answer2 = self:GetWidgetByName("Label_JBSM_Content",answerDiOne)
            local answerBg = answerDiOne
    
            questionDiOne:setVisible(true)
            answerDiOne:setVisible(true)
    
            answer2:setString(v.explainContent)
            local sizeHeight = (answer2:getContentSize()).height + 20
            if sizeHeight < 50 then
                sizeHeight = 50 
            end
            local sizeWidth = (answerDiOne:getContentSize()).width 
            local sizewidth2 = (answerBg:getContentSize()).width 
    
            answerDiOne:setContentSize(cc.size(sizeWidth,sizeHeight))
            answerBg:setContentSize(cc.size(sizewidth2,sizeHeight))
            answer2:setPositionY(sizeHeight/2)
        end
    end

end

function GameHelp:showGrade(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:showOnlyButton(3)
        self:onShowOnlyListView(3)

        self.mGrade:setVisible(true)

        self:onShowOnlyTitle(self:GetWidgetByName("Image_GameRule_Title_Grade"))
    end
end

function GameHelp:add_Grade(begin, over) 
    for i = begin, over do
        local v = self.levelArray[i]
        local model = self.mNode:clone()

        model:setVisible(true)
        local label_title = self:GetWidgetByName("Label_GameHelp_NodeName", model)
        label_title:setString(v.GradeTitle)
        local label_experience = self:GetWidgetByName("Label_GameHelp_NodeExperience", model)
        label_experience:setString(v.GradeExperience)
        self:GetWidgetByName("Image_GameHelp_NodeBadge", model):loadTexture(v.GradeIconPath,1)
        self.listviewGrade:pushBackCustomItem(model)
    end
end

function GameHelp:showQuestion(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:showOnlyButton(5)
        self:onShowOnlyListView(2)

        self.mGrade:setVisible(false)

        self:onShowOnlyTitle(self:GetWidgetByName("Image_GameRule_Title_Question"))
    end
end

function GameHelp:initGameQuestion()
    for k, v in ipairs(self.gameInstruction) do
        local questionDiOne  = self.questionDi:clone()
        local answerDiOne = self.answerDi:clone()

        local redDot = questionDiOne
        local answer2 = self:GetWidgetByName("Label_JBSM_Content",answerDiOne)
        local answerBg = answerDiOne

        questionDiOne:setVisible(true)
        answerDiOne:setVisible(true)
        if v.Type == 2 then
            local question = string.gsub(v.explainTitle,"金币",laixia.utilscfg.CoinType())
            redDot:setString(question)
            local ans = string.gsub(v.explainContent,"金币",laixia.utilscfg.CoinType())
            answer2:setString(ans);
            local sizeHeight = (answer2:getContentSize()).height + 20
            if sizeHeight < 50 then
                sizeHeight = 50 
            end
            local sizeWidth = (answerDiOne:getContentSize()).width 
            local sizewidth2 = (answerBg:getContentSize()).width 
            answerDiOne:setContentSize(cc.size(sizeWidth,sizeHeight))
            answerBg:setContentSize(cc.size(sizewidth2,sizeHeight))
            answer2:setPositionY(sizeHeight/2)
            self.listViewQuestion:pushBackCustomItem(questionDiOne)
            self.listViewQuestion:pushBackCustomItem(answerDiOne)

        end
    end

end

function GameHelp:showOnlyButton(index)
   laixia.UItools.onShowOnly(index,self.ButtonArray)   
end

function GameHelp:onShow()

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_SETUP_WINDOW)


    
    self.ButtonArray = {}
    table.insert(self.ButtonArray,self:GetWidgetByName("Button_GameRule_YXGZ_S"))
    local btnRule = self:GetWidgetByName("Button_GameRule_YXGZ")
    table.insert(self.ButtonArray,btnRule)

    table.insert(self.ButtonArray,self:GetWidgetByName("Button_GameRule_DJSM_S"))
    local btnGrade = self:GetWidgetByName("Button_GameRule_DJSM")
    table.insert(self.ButtonArray,btnGrade )

    table.insert(self.ButtonArray,self:GetWidgetByName("Button_GameRule_CJWT_S"))
    local btnQuestion = self:GetWidgetByName("Button_GameRule_CJWT")
    table.insert(self.ButtonArray,btnQuestion)


    btnRule:addTouchEventListener(handler(self, self.showRule))
    btnGrade:addTouchEventListener(handler(self, self.showGrade))
    btnQuestion:addTouchEventListener(handler(self, self.showQuestion))
    
    -- 关闭
    self:AddWidgetEventListenerFunction("Button_GameRule_Quit", handler(self, self.onShutDown))

    self.mIndex = 0
    self.listViewRule= self:GetWidgetByName("ListView_Rule")
    self.listViewQuestion = self:GetWidgetByName("ListView_Question")
    self.listviewGrade = self:GetWidgetByName("ListView_Grade")
    
    self.mListView_Array = {}
    table.insert(self.mListView_Array,self.listViewRule)
    table.insert(self.mListView_Array,self.listViewQuestion)
    table.insert(self.mListView_Array,self.listviewGrade)
   
    self.mNode=self:GetWidgetByName("Image_Grade")
    self.mNode:setVisible(false) 
    self.mGrade=self:GetWidgetByName("Image_Grade_Title")
    self.mGrade:setVisible(false) 

    self.questionDi = self:GetWidgetByName("Label_Rule_Title")
    self.answerDi = self:GetWidgetByName("Image_Rule_BG") 
    self.questionDi:setVisible(false)
    self.answerDi:setVisible(false)
    
    self.mIsInitGrade = true 

    self.levelArray =  laixia.JsonTxtData:queryTable("gradeArray").buf
    self.gameInstruction = laixia.JsonTxtData:queryTable("gameInstruction").buf


    self.mTitleArray ={}
    table.insert(self.mTitleArray,self:GetWidgetByName("Image_GameRule_Title_Rule"))
    table.insert(self.mTitleArray,self:GetWidgetByName("Image_GameRule_Title_Grade"))
    table.insert(self.mTitleArray,self:GetWidgetByName("Image_GameRule_Title_Question"))

    self:onShowOnlyTitle(self:GetWidgetByName("Image_GameRule_Title_Rule"))

    self:initGameRule()
    self:initGameQuestion()
    self:showOnlyButton(1)
    self:onShowOnlyListView(1)
end

function GameHelp:onShowOnlyListView(index)
    if index <= #self.mListView_Array then
        for i,v in ipairs(self.mListView_Array) do
            if index == i then
               v:setVisible(true)
            else
               v:setVisible(false)
            end
        end
    end
end

function GameHelp:onShowOnlyTitle(mTitle)
     for i,v in ipairs(self.mTitleArray) do
        if v == mTitle then
            v:setVisible(true)
        else
            v:setVisible(false)
        end
     end
end

function GameHelp:onShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
     end
end

function GameHelp:onTick()
    if self.mIsInitGrade  then
        local temp = 10
        if self.levelArray == nil then
            self.mIsInitGrade = nil
            return
        end
        if self.mIndex == #self.levelArray then
            self.mIsInitGrade = nil
            return
        end

        local old = self.mIndex + 1
        self.mIndex = self.mIndex + temp

        if self.mIndex > #self.levelArray then
            self.mIndex = #self.levelArray
            self.mIsInitGrade = nil
        end
        self:add_Grade(old, self.mIndex)
    end
  
end


function GameHelp:onDestroy()

end

return GameHelp.new()


