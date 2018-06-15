--比赛详情页
local laixia = laixia;
local Env = APP_ENV;

local soundConfig =  laixiaddz.soundcfg;    
local EffectDict = laixia.EffectDict;
local EffectAni =  laixia.EffectAni; 
local Packet =  import("....net.Packet") 
local scene = cc.Director:getInstance():getRunningScene()

local laixia = laixia;  
local db2 = laixiaddz.JsonTxtData;
local itemDBM
   
local GameListDetailWindow = class("GameListDetailWindow", import("...CBaseDialog"):new())-- 
local scheduler = require "framework.scheduler"

function GameListDetailWindow:ctor(...)  
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function GameListDetailWindow:getName()
    return "GameListWindow_detail" -- csb = Game__Detail.csb
end

function GameListDetailWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MATCHLISTDETAIL_WINDOW , handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW , handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_JOIN_MATCHJOIN_WINDOW,handler(self,self.updateSignUp)) --更新报名的进度
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_QUIT_MATCHJOIN_WINDOW,handler(self,self.updateQuit)) --更新 退出报名的按钮
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_WITHDRAW_MATCHJOIN_WINDOW,handler(self,self.quitRegistrationFun)) --退出报名
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW,handler(self,self.sendRegistration)) --注册比赛
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_PROGRESSBARMATCH_WINDOW,handler(self,self.updateProgressBar))
    --ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_COSTWINDOW,handler(self,self.ShutDownSign2))-- 影藏报名花费窗口
end

function GameListDetailWindow:init_LiftUI()
    local str = self.matchInfo.RoomName:gsub("金币",laixiaddz.utilscfg.CoinType());
    -- self:GetWidgetByName("GameDetail_Lebel_Title"):setString(str)
    -- local reward = self.matchInfo.RankRds[1].Reward[1]
    -- local ItemsdataReward = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",reward.ID);
    -- if reward.Num==1 then
    --         local icon = self:GetWidgetByName("GameDetail_Image_Sign")
    --         icon:loadTexture(ItemsdataReward.ImagePath,1)
    --         if ItemsdataReward.PresentItemID1 == 1003 then  --如果是微信红包
    --              local sicon =  "red_packet_"..ItemsdataReward.BaseCount..".png"
    --              local count = ccui.ImageView:create(sicon,1)
    --              count:setPosition(78,60)
    --              count:setLocalZOrder(100)
    --              count:addTo(icon)
    --         end
    -- else
    --     self:GetWidgetByName("GameDetail_Image_Sign"):setVisible(true)
    --     self:GetWidgetByName("GameDetail_Sign_board"):setVisible(true)
    --     self:GetWidgetByName("GameDetail_Image_Sign"):loadTexture(ItemsdataReward.ImagePath,1)
    -- end
    -- self:GetWidgetByName("GameDetail_Sign_Label"):setString(reward.Num)
end

function GameListDetailWindow:init_RightUI()
    self:initReward()
    self:init_Msg()
    self:init_Details()

end
------------------------------------比赛奖励---------------------------------------------------------
function GameListDetailWindow:initReward()
    local str = ""

    
    self.ListView_1:setVisible(true)
    self.ListView_1:removeAllItems()
    dump(self.matchInfo.RankRds)
    if not self.matchInfo.RankRds then return end
    for i, v in pairs(self.matchInfo.RankRds) do
        local model = self.Panel_12:clone()
        self.ListView_1:pushBackCustomItem(model)
        self:GetWidgetByName("Label_MingCi", model):setString(v.field or "0-0")
        self:GetWidgetByName("Lebel_JiangLi",model):setString(v.award or "0")



        -- local Label_mingci = self:GetWidgetByName("Label_MingCi", model)
        --local Image_mingci = self:GetWidgetByName("Image_MingCi", model)
        --Image_mingci:setVisible(false)

        -- if v.RankStart == v.RankEnd then
        --     str = "第" .. v.RankEnd .. "名"
        --     -- if v.RankEnd <= 3 then
        --     --     -- --Image_mingci:setVisible(true)
        --     --     -- -- Image_mingci:loadTexture("rank_num"..v.RankEnd..".png",1)
        --     --     -- Image_mingci:loadTexture("res/new_ui/GameListDetailWindow/huangguan_"..v.RankEnd..".png")
        --     --     if v.RankEnd==1 then
        --     --         self:GetWidgetByName("Label_MingCi",Image_mingci):setString("冠军")
        --     --     elseif v.RankEnd==2 then
        --     --         self:GetWidgetByName("Label_MingCi",Image_mingci):setString("亚军")
        --     --     elseif v.RankEnd==3 then
        --     --         self:GetWidgetByName("Label_MingCi",Image_mingci):setString("季军")
        --     --     end
        --     -- end
        -- elseif v.RankEnd > 2000 then
        --     str = "第" .. v.RankStart .. "-最后1" .. "名"
        -- else
        --     str = "第" .. v.RankStart .. "-" .. v.RankEnd .. "名"
        -- end
        -- local str = v.field
        -- Label_mingci:setString(str)
        --奖励东西
--        str =""
--        for j, m in pairs(v.Reward) do
--            local ItemsdataReward = itemDBM:query("ItemID",m.ID);
--            if ItemsdataReward == nil then
--               return
--            end
--            if m.ID == 1001 or m.ID == 1002 then
--                if str == "" then
--                    local wan =  laixiaddz.helper.numeralRules_2(m.Num)
--                    str = ItemsdataReward.ItemName..wan
--                else 
--                    local wan =  laixiaddz.helper.numeralRules_2(m.Num)
--                    str = str .. "," .. ItemsdataReward.ItemName..wan
--                end
--            else
--                if str == "" then
--                    str = ItemsdataReward.ItemName.." X"..m.Num
--                else 
--                    str = str .. "," .. ItemsdataReward.ItemName.." X"..m.Num
--                end
--            end
--        end
--        str = str:gsub("金币",laixia.utilscfg.CoinType())
--        self:GetWidgetByName("Lebel_JiangLi", model):setString(str)
          -- self:GetWidgetByName("Lebel_JiangLi",model):setString(v.award)
    end
end


function GameListDetailWindow:ButtonCallback1_1()
    if #self.matchInfo.Baomingfei == 1 then
         self.indexCost = self.matchInfo.Baomingfei[1].payment_info[1].id
         laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
    elseif #self.matchInfo.Baomingfei == 2 then
        self.Button_1_1:setVisible(false)
        self.Button_1_2:setVisible(true)
        self.Button_2_1:setVisible(true)
        self.Button_2_2:setVisible(false)
        self.Button_3_1:setVisible(false)
        self.Button_3_2:setVisible(false)
        self.indexCost = self.matchInfo.Baomingfei[1].payment_info[1].id
        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
    elseif #self.mathInfo.Baomingfei == 3 then  
        self.Button_1_1:setVisible(false)
        self.Button_1_2:setVisible(true)
        self.Button_2_1:setVisible(true)
        self.Button_2_2:setVisible(false)
        self.Button_3_1:setVisible(true)
        self.Button_3_2:setVisible(false)   
        self.indexCost = self.matchInfo.Baomingfei[1].payment_info[1].id 
        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
    end
end

function GameListDetailWindow:ButtonCallback1_2()

end

function GameListDetailWindow:ButtonCallback2_1()
    if #self.matchInfo.Baomingfei == 1 then
         
    elseif #self.matchInfo.Baomingfei == 2 then
        self.Button_1_1:setVisible(true)
        self.Button_1_2:setVisible(false)
        self.Button_2_1:setVisible(false)
        self.Button_2_2:setVisible(true)
        self.Button_3_1:setVisible(false)
        self.Button_3_2:setVisible(false)
        self.indexCost = self.matchInfo.Baomingfei[2].payment_info[1].id
        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[2].payment_info[1].id
    elseif #self.mathInfo.Baomingfei == 3 then  
        self.Button_1_1:setVisible(true)
        self.Button_1_2:setVisible(false)
        self.Button_2_1:setVisible(false)
        self.Button_2_2:setVisible(true)
        self.Button_3_1:setVisible(true)
        self.Button_3_2:setVisible(false)  
        self.indexCost = self.matchInfo.Baomingfei[2].payment_info[1].id  
        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[2].payment_info[1].id
    end

end

function GameListDetailWindow:ButtonCallback2_2()

end

function GameListDetailWindow:ButtonCallback3_1() 
    self.Button_1_1:setVisible(true)
    self.Button_1_2:setVisible(false)
    self.Button_2_1:setVisible(true)
    self.Button_2_2:setVisible(false)
    self.Button_3_1:setVisible(false)
    self.Button_3_2:setVisible(true)   
    self.indexCost = self.matchInfo.Baomingfei[3].payment_info[1].id     
    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[3].payment_info[1].id
end

function GameListDetailWindow:ButtonCallback3_2()

end

------------------比赛详情-----------------
function GameListDetailWindow:init_Msg()
    -- self:matchCoinInfo()
    -- self.Button_1_1_ = self:GetWidgetByName("Button_1_1")
    -- self:AddWidgetEventListenerFunction("Button_1_1", handler(self, self.ButtonCallback1_1)) 
    -- self.Button_1_2_ = self:GetWidgetByName("Button_1_2")
    -- self:AddWidgetEventListenerFunction("Button_1_2", handler(self, self.ButtonCallback1_2))
    -- self.Button_2_1_ = self:GetWidgetByName("Button_2_1")
    -- self:AddWidgetEventListenerFunction("Button_2_1", handler(self, self.ButtonCallback2_1))
    -- self.Button_2_2_ = self:GetWidgetByName("Button_2_2")
    -- self:AddWidgetEventListenerFunction("Button_2_2", handler(self, self.ButtonCallback2_2)) 
    -- self.Button_3_1_ = self:GetWidgetByName("Button_3_1")
    -- self:AddWidgetEventListenerFunction("Button_3_1", handler(self, self.ButtonCallback3_1)) 
    -- self.Button_3_2_ = self:GetWidgetByName("Button_3_2")
    -- self:AddWidgetEventListenerFunction("Button_3_2", handler(self, self.ButtonCallback3_2)) 
    -- self.Button_1_1_:setVisible(false)
    -- self.Button_1_2_:setVisible(false)
    -- self.Button_2_1_:setVisible(false)
    -- self.Button_2_2_:setVisible(false)
    -- self.Button_3_1_:setVisible(false)
    -- self.Button_3_2_:setVisible(false)


    -- function checkbox_callback(event)
    --     --dump(event)
    --     --  当前选择的序号 之前选择的序号  
    --     if event.selected == 1 then
    --         self.indexCost = self.matchInfo.Baomingfei[1].ID
    --     elseif event.selected ==2 then
    --         self.indexCost = self.matchInfo.Baomingfei[2].ID
    --     elseif event.selected == 3 then
    --         self.indexCost = self.matchInfo.Baomingfei[3].ID
    --     else
    --         self.indexCost = self.matchInfo.Baomingfei[1].ID
    --     end
    -- end

    self.Node_1 = self:GetWidgetByName("Node_1")
    self.Node_1:setVisible(false)
    -- self.roundTypeRadioGroup = ccui.RadioButtonGroup:create()
    -- self.roundTypeRadioGroup:addEventListener(function(senderBtn, index, eventType)
    --     if eventType == ccui.RadioButtonEventType.selected then
    --         gt.log("name: = " .. senderBtn:getName() .. " selected")
    --     elseif eventType == ccui.RadioButtonEventType.unselected then
    --         gt.log("name: = " .. senderBtn:getName() .. " unselected")
    --     end
    -- end)
    -- self.roundTypeRadioGroup:setPosition(cc.p(-50, 0))
    -- self.Node_1:addChild(self.roundTypeRadioGroup)
    -- -- 构建checkbox单个选择组,从8局开始
    -- for i = 1, 3 do
    --     --local roundTypeNode = gt.seekNodeByName(self, "Node_roundType_" .. i)
    --     local radioBtn = ccui.RadioButton:create("res/new_ui/GameDetail/deng_2.png", "res/new_ui/GameDetail/deng_1.png",
    --                                 "res/new_ui/GameDetail/deng_2.png", "res/new_ui/GameDetail/deng_1.png", "res/new_ui/GameDetail/deng_2.png")--ccui.TextureResType.plistType
    --     radioBtn:setName("Radio_roundType_" .. i)
    --     radioBtn:setTag(i)
    --     self.roundTypeRadioGroup:addRadioButton(radioBtn)
    --     self.Node_1:addChild(radioBtn)
    -- end
    ------------------------------------------------------
    -- self.Image_bg4 = self:GetWidgetByName("Image_bg4")
    
    -- local param = {off = "res/new_ui/GameDetail/deng_2.png",on = "res/new_ui/GameDetail/deng_1.png",off_pressed = "res/new_ui/GameDetail/deng_2.png",on_pressed = "res/new_ui/GameDetail/deng_1.png"}
    -- self.checkgroup = cc.ui.UICheckBoxButtonGroup.new(display.TOP_TO_BOTTOM)                       
    -- :addButton(cc.ui.UICheckBoxButton.new(param)               -- 在group中添加第一个radio_button  
    --     :setButtonLabelOffset(0, 20)  
    --     :align(display.LEFT_CENTER))  
    -- :addButton(cc.ui.UICheckBoxButton.new(param)               -- 在group中添加第二个radio_button  
    --     :setButtonLabelOffset(0, 20)  
    --     :align(display.LEFT_CENTER))  
    -- :addButton(cc.ui.UICheckBoxButton.new(param)               -- 在group中添加第二个radio_button  
    --     :setButtonLabelOffset(0, 20)  
    --     :align(display.LEFT_CENTER))
    -- :setButtonsLayoutMargin(10, 10, 10, 10)                -- 此四个参数为top, right, bottom, left,设置group中每个按钮的边缘位置  
    -- :onButtonSelectChanged(checkbox_callback)  
    -- self.checkgroup:setPosition(cc.p(-50, 0))
    -- self.checkgroup:getButtonAtIndex(1):setButtonSelected(true)
    -- self.Node_1:addChild(self.checkgroup)

---------------------------------------------------------------
    --//
    local str1 = ""
    local str2 = ""
    local str3 = ""

    -- laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
    if not self.matchInfo.Baomingfei then return end
    if #self.matchInfo.Baomingfei == 1 then
        local Itemsdata = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id));
        if tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) == 0 then
            str1 = "免费"
            self.indexCost = 0
            laixiaddz.LocalPlayercfg.LaixiaJoinGame = 0
        else
            self.indexCost = self.matchInfo.Baomingfei[1].payment_info[1].id
            laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
            str1 = Itemsdata.ItemName.." X"..self.matchInfo.Baomingfei[1].payment_info[1].num
            str1 = str1:gsub("金币",laixiaddz.utilscfg.CoinType());
        end
        --选则参与比赛方式的按钮
        --只有1种 就显示一种带点
        --//
        -- self.Button_1_1:setVisible(false)
        -- self.Button_1_2:setVisible(true)
        -- self.Button_2_1:setVisible(false)
        -- self.Button_2_2:setVisible(false)
        -- self.Button_3_1:setVisible(false)
        -- self.Button_3_2:setVisible(false)
        --//

        self.Text_b_6:setString(str1)
        self.Text_b_6:setVisible(true)
        --self.Image_b_6:setVisible(true)
        self.Text_b_7:setVisible(false)
        --self.Image_b_7:setVisible(false)
        self.Text_b_8:setVisible(false)
        --self.Image_b_8:setVisible(false)
    elseif #self.matchInfo.Baomingfei == 2 then
        -- print("self.matchInfo.Baomingfei[1].payment_info[1].id = ",self.matchInfo.Baomingfei[1].payment_info[1][1].id)
        -- local arr = self.matchInfo.Baomingfei
        -- dump(arr)
        local itemDBM = db2:queryTable("items");
        local Itemsdata1 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id));
        print("self.matchInfo.Baomingfei[1].payment_info[1].id = ",self.matchInfo.Baomingfei[1].payment_info[1].id)
        print("Itemsdata1 = ",Itemsdata1)
        local Itemsdata2 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id));
        str1 = Itemsdata1.ItemName.."X"..self.matchInfo.Baomingfei[1].payment_info[1].num
        str1 = str1:gsub("金币",laixiaddz.utilscfg.CoinType());
        self.Text_b_6:setVisible(true)
        --self.Image_b_6:setVisible(true)
        self.Text_b_6:setString(str1)

        str2 = Itemsdata2.ItemName.."X"..self.matchInfo.Baomingfei[2].payment_info[1].num
        str2 = str2:gsub("金币",laixiaddz.utilscfg.CoinType());
        self.Text_b_7:setVisible(true)
        --self.Image_b_7:setVisible(true)
        self.Text_b_7:setString(str2)

        self.Text_b_8:setVisible(false)
        --self.Image_b_8:setVisible(false)

        -- if laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[1].payment_info[1].id then
        --     --有两种 默认显示第一种 
        --     self.Button_1_1:setVisible(false)
        --     self.Button_1_2:setVisible(true)
        --     self.Button_2_1:setVisible(true)
        --     self.Button_2_2:setVisible(false)
        --     self.Button_3_1:setVisible(false)
        --     self.Button_3_2:setVisible(false)
        -- elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[2].payment_info[1].id then
        --     --有两种 默认显示第一种 
        --     self.Button_1_1:setVisible(true)
        --     self.Button_1_2:setVisible(false)
        --     self.Button_2_1:setVisible(false)
        --     self.Button_2_2:setVisible(true)
        --     self.Button_3_1:setVisible(false)
        --     self.Button_3_2:setVisible(false)
        -- else
        --     --有两种 默认显示第一种 
        --     self.Button_1_1:setVisible(false)
        --     self.Button_1_2:setVisible(true)
        --     self.Button_2_1:setVisible(true)
        --     self.Button_2_2:setVisible(false)
        --     self.Button_3_1:setVisible(false)
        --     self.Button_3_2:setVisible(false)
        -- end  
    elseif #self.matchInfo.Baomingfei == 3 then
        local Itemsdata1 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id));
        local Itemsdata2 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id));
        local Itemsdata3 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[3].payment_info[1].id));
        str1 = Itemsdata1.ItemName.."X"..self.matchInfo.Baomingfei[1].payment_info[1].num
        str1 = str1:gsub("金币",laixiaddz.utilscfg.CoinType());
        self.Text_b_6:setString(str1)

        str2 = Itemsdata2.ItemName.."X"..self.matchInfo.Baomingfei[2].payment_info[1].num
        str2 = str2:gsub("金币",laixiaddz.utilscfg.CoinType());
        self.Text_b_7:setString(str2)

        str3 = Itemsdata3.ItemName.."X"..self.matchInfo.Baomingfei[3].payment_info[1].num
        str3 = str3:gsub("金币",laixiaddz.utilscfg.CoinType());
        self.Text_b_8:setString(str3)
        self.Text_b_6:setVisible(true)
        --self.Image_b_6:setVisible(true)
        self.Text_b_7:setVisible(true)
        --self.Image_b_7:setVisible(true)
        self.Text_b_8:setVisible(true)
        --self.Image_b_8:setVisible(true)
        --//
        -- if laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[1].payment_info[1].id then
        --     --有两种 默认显示第一种 
        --     self.Button_1_1:setVisible(false)
        --     self.Button_1_2:setVisible(true)
        --     self.Button_2_1:setVisible(true)
        --     self.Button_2_2:setVisible(false)
        --     self.Button_3_1:setVisible(true)
        --     self.Button_3_2:setVisible(false)
        -- elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[2].payment_info[1].id then
        --     --有两种 默认显示第一种 
        --     self.Button_1_1:setVisible(true)
        --     self.Button_1_2:setVisible(false)
        --     self.Button_2_1:setVisible(false)
        --     self.Button_2_2:setVisible(true)
        --     self.Button_3_1:setVisible(true)
        --     self.Button_3_2:setVisible(false)
        -- elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[3].payment_info[1].id then
        --     --有两种 默认显示第一种 
        --     self.Button_1_1:setVisible(true)
        --     self.Button_1_2:setVisible(false)
        --     self.Button_2_1:setVisible(true)
        --     self.Button_2_2:setVisible(false)
        --     self.Button_3_1:setVisible(false)
        --     self.Button_3_2:setVisible(true)
        -- else
        --     --有两种 默认显示第一种 
        --     self.Button_1_1:setVisible(false)
        --     self.Button_1_2:setVisible(true)
        --     self.Button_2_1:setVisible(true)
        --     self.Button_2_2:setVisible(false)
        --     self.Button_3_1:setVisible(false)
        --     self.Button_3_2:setVisible(false)
        -- end
        --//
    else
        str1 = "免费" 
        self.Text_b_6:setString(str1)
        self.Text_b_6:setVisible(true)

        self.Text_b_7:setVisible(false)
        --self.Image_b_7:setVisible(false)
        self.Text_b_8:setVisible(false)
        --self.Image_b_8:setVisible(false)

        self.Text_b_6:setString(str1)
        self.Text_b_6:setVisible(true)
        --self.Image_b_6:setVisible(true)
        self.Text_b_7:setVisible(false)
        --self.Image_b_7:setVisible(false)
        self.Text_b_8:setVisible(false)
        --self.Image_b_8:setVisible(false)

    end
    --//
   
    -- if #self.matchInfo.Baomingfei == 1 then
    --     print("11111111111111111111")
    --     local Itemsdata = itemDBM:query("ItemID",self.matchInfo.Baomingfei[1].payment_info[1].id);
    --     if self.matchInfo.Baomingfei[1].payment_info[1].num == 0 then
    --         str1 = "免费"
    --     else
    --         str1 = self.matchInfo.Baomingfei[1].payment_info[1].num..Itemsdata.ItemName
    --         str1 = str1:gsub("金币",laixia.utilscfg.CoinType());
    --     end
    --     self.Text_b_6:setString(str1)
    --     self.Text_b_6:setVisible(true)
    --     self.Image_b_6:setVisible(true)
    --     self.Text_b_7:setVisible(false)
    --     self.Image_b_7:setVisible(false)
    --     self.Text_b_8:setVisible(false)
    --     self.Image_b_8:setVisible(false)
    -- elseif #self.matchInfo.Baomingfei == 2 then
    --      print("22222222222222")
    --     local Itemsdata1 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[1].payment_info[1].id);
    --     local Itemsdata2 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[2].payment_info[1].id);
    --     str1 = self.matchInfo.Baomingfei[1].payment_info[1].num..Itemsdata1.ItemName
    --     str1 = str1:gsub("金币",laixia.utilscfg.CoinType());
    --     self.Text_b_6:setVisible(true)
    --     self.Image_b_6:setVisible(true)
    --     self.Text_b_6:setString(str1)

    --     str2 = self.matchInfo.Baomingfei[2].payment_info[1].num..Itemsdata2.ItemName
    --     str2 = str2:gsub("金币",laixia.utilscfg.CoinType());
    --     self.Text_b_7:setVisible(true)
    --     self.Image_b_7:setVisible(true)
    --     self.Text_b_7:setString(str2)

    --     self.Text_b_8:setVisible(false)
    --     self.Image_b_8:setVisible(false)
    -- elseif #self.matchInfo.Baomingfei == 3 then
    --      print("33333333333333333")
    --     local Itemsdata1 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[1].payment_info[1].id);
    --     local Itemsdata2 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[2].payment_info[1].id);
    --     local Itemsdata3 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[3].payment_info[1].id);
    --     str1 = self.matchInfo.Baomingfei[1].payment_info[1].num..Itemsdata1.ItemName
    --     str1 = str1:gsub("金币",laixia.utilscfg.CoinType());
    --     self.Text_b_6:setString(str1)

    --     str2 = self.matchInfo.Baomingfei[2].payment_info[1].num..Itemsdata2.ItemName
    --     str2 = str2:gsub("金币",laixia.utilscfg.CoinType());
    --     self.Text_b_7:setString(str2)

    --     str3 = self.matchInfo.Baomingfei[3].payment_info[1].num..Itemsdata3.ItemName
    --     str3 = str3:gsub("金币",laixia.utilscfg.CoinType());
    --     self.Text_b_8:setString(str3)
    --     self.Text_b_6:setVisible(true)
    --     self.Image_b_6:setVisible(true)
    --     self.Text_b_7:setVisible(true)
    --     self.Image_b_7:setVisible(true)
    --     self.Text_b_8:setVisible(true)
    --     self.Image_b_8:setVisible(true)
    -- else
    --     str1 = "免费" 
    -- end

    -- if #self.matchInfo.Baomingfei >= 1 then
    --     local Itemsdata = itemDBM:query("ItemID",self.matchInfo.Baomingfei[1].payment_info[1].id);
    --     if self.matchInfo.Baomingfei[1].payment_info[1].num == 0 then
    --         str = "免费"
    --     else
    --         str = self.matchInfo.Baomingfei[1].payment_info[1].num..Itemsdata.ItemName
    --         str = str:gsub("金币",laixia.utilscfg.CoinType());
    --     end
    -- else
    --     str = "免费" 
    --     self.Text_b_6:setString(str1)
    -- end

    --self:GetWidgetByName("Label_baomingjine"):setString(str)
    
    -- self.Image_b_7:setVisible(false)
    -- self.Image_b_8:setVisible(false)
    -- self.Text_b_7:setVisible(false)
    -- self.Text_b_8:setVisible(false)

    if self.matchInfo.RoomType == 2 then
        self.Image_1:setVisible(true)
        self.Image_2:setVisible(true) 
        self.Image_3:setVisible(true) 
        -- self.Image_4:setVisible(true) 
        self.Image_5:setVisible(true)
        self.Image_6:setVisible(true) 
        self.Image_7:setVisible(true)
        self.Text_1:setVisible(true)
        self.Text_2:setVisible(true)
        self.Text_3:setVisible(true) 
        -- self.Text_4:setVisible(true) 
        self.Text_5:setVisible(true) 
        self.Text_6:setVisible(true)
        self.Text_7:setVisible(true) 
        self.Text_7:setString("报名人数")
        self.Image_b_1:setVisible(true) 
        self.Image_b_2:setVisible(true)
        -- self.Image_b_3:setVisible(true)
        -- self.Image_b_4 :setVisible(true)
        self.Image_b_5:setVisible(true) 
        --//
        --self.Image_b_6:setVisible(true) 
        --self.Image_b_7:setVisible(true) 
        --self.Image_b_8:setVisible(true)
        --// 
        self.Label_kaisaishijian:setVisible(true) 
        self.Text_b_2:setVisible(true)
        self.Text_b_3:setVisible(true) 
        self.Text_b_4:setVisible(true)
        self.Text_b_5:setVisible(true)
        --// 
        self.Text_b_6:setVisible(true) 
       --self.Text_b_7:setVisible(true) 
       --self.Text_b_8:setVisible(true) 
       --//
        self.Text_b_9:setVisible(true) 
        self.Text_b_10:setVisible(true) 
        -- self.Text_b_11:setVisible(true) 
        -- self.Text_b_12:setVisible(true) 
        --self.Text_b_13:setVisible(true)

        self.Image_33:setVisible(false)
        self.Image_35:setVisible(false)
        self.Image_36:setVisible(false)
        self.Label_maohao_1:setVisible(false)
        self.Label_maohao_2:setVisible(false)

        -- if self.pageType == 2 then
        --     --进度条 比赛剩余开始时间隐藏
        --     self.Image_load_bg1:setVisible(false)
        --     self.progressBarBG:setVisible(true)
        --     self.Image_ProgressBar_BG:setVisible(true)
        --     self.progressBar_front:setVisible(true)
        --     self.Label_ProgressBar:setVisible(true)
        --     self.ProgressBar_BaoMing:setVisible(true)
        -- else
        --     --进度条 比赛剩余开始时间隐藏
        --     self.Image_load_bg1:setVisible(false)
        --     self.progressBarBG:setVisible(false)
        --     self.Image_ProgressBar_BG:setVisible(false)
        --     self.progressBar_front:setVisible(false)
        --     self.Label_ProgressBar:setVisible(false)
        --     self.ProgressBar_BaoMing:setVisible(false)
        -- end
        self.Image_load_bg1:setVisible(false)
        self.Image_ProgressBar_BG:setVisible(true)
        self.Label_ProgressBar:setVisible(true)
        self.progressBarBG:setVisible(true)
        self.progressBar_front:setVisible(true)
        self.ProgressBar_BaoMing:setVisible(true)

        --self.Label_kaisaitiaojian:setString("满"..self.matchInfo.JoinMaxLimit.."人开赛")
        self:updateProgressBar()

        --self:GetWidgetByName("Image_jinbiaosaiBg"):setVisible(false)
        --self:GetWidgetByName("Label_kaisaishijianwenzi"):setVisible(false)
    elseif self.matchInfo.RoomType == 1 then
        self.Image_1:setVisible(true)
        self.Image_2:setVisible(true) 
        self.Image_3:setVisible(true) 
        -- self.Image_4:setVisible(true) 
        self.Image_5:setVisible(true)
        self.Image_6:setVisible(true) 
        self.Image_7:setVisible(true)
        self.Text_1:setVisible(true)
        self.Text_2:setVisible(true)
        self.Text_3:setVisible(true) 
        -- self.Text_4:setVisible(true) 
        self.Text_5:setVisible(true) 
        self.Text_6:setVisible(true)
        self.Text_7:setVisible(true) 
        self.Text_7:setString("开赛时间")
        self.Image_b_1:setVisible(true) 
        self.Image_b_2:setVisible(true)
        -- self.Image_b_3:setVisible(true)
        -- self.Image_b_4 :setVisible(true)
        self.Image_b_5:setVisible(true) 
        --//
        --self.Image_b_6:setVisible(true) 
        --//
        --self.Image_b_7:setVisible(true) 
        --self.Image_b_8:setVisible(true) 

        self.Label_kaisaishijian:setVisible(true) 
        self.Text_b_2:setVisible(true)
        self.Text_b_3:setVisible(true) 
        self.Text_b_4:setVisible(true)
        self.Text_b_5:setVisible(true) 
        --//
        self.Text_b_6:setVisible(true) 
        --//
        -- self.Text_b_7:setVisible(true) 
        -- self.Text_b_8:setVisible(true) 
        self.Text_b_9:setVisible(true) 
        self.Text_b_10:setVisible(true) 
        -- self.Text_b_11:setVisible(true) 
        -- self.Text_b_12:setVisible(true) 
        --self.Text_b_13:setVisible(true)

        

        self.Image_33:setVisible(true)
        self.Image_35:setVisible(true)
        self.Image_36:setVisible(true)
        self.Label_maohao_1:setVisible(true)
        self.Label_maohao_2:setVisible(true)
        -- if self.pageType == 2 then
        --     --进度条 比赛剩余开始时间隐藏
        --     self.Image_load_bg1:setVisible(false)
        --     self.progressBarBG:setVisible(true)
        --     self.Image_ProgressBar_BG:setVisible(true)
        --     self.progressBar_front:setVisible(true)
        --     self.Label_ProgressBar:setVisible(true)
        --     self.ProgressBar_BaoMing:setVisible(true)
        -- else
        --     --进度条 比赛剩余开始时间隐藏
        --     self.Image_load_bg1:setVisible(false)
        --     self.progressBarBG:setVisible(false)
        --     self.Image_ProgressBar_BG:setVisible(false)
        --     self.progressBar_front:setVisible(false)
        --     self.Label_ProgressBar:setVisible(false)
        --     self.ProgressBar_BaoMing:setVisible(false)
        -- end
        self.Image_load_bg1:setVisible(false)
        self.Image_ProgressBar_BG:setVisible(false)
        self.Label_ProgressBar:setVisible(false)
        self.progressBarBG:setVisible(false)
        self.progressBar_front:setVisible(false)
        self.ProgressBar_BaoMing:setVisible(false)

        --self:GetWidgetByName("Image_jinbiaosaiBg"):setVisible(true)
        --self:GetWidgetByName("Label_kaisaishijianwenzi"):setVisible(true)

        -- self:updateMatchTime()
    end
end

--[[
 * 进度条更新
 * @param  msg = {data = {CurJoin(当前人数)}}
--]]
function GameListDetailWindow:updateProgressBar(msg)
    if not self.mIsShow then return end
    -- 牌桌人数
    local num = 0
    if self.matchInfo.SelfJoin == 1 then
        num = 1
    end
    if msg and msg.data then
        -- 消息推送
        num = msg.data.CurJoin
    end
    self.CurJoin = num
    if self.matchInfo.RoomType == 2 then
        -- 人满开赛模式
        local numMax = self.matchInfo.JoinMaxLimit
        local str =  num.."/"..numMax
        if num > numMax then
            str = numMax.."/"..numMax
        end
        if self.Label_ProgressBar and self.ProgressBar_BaoMing then
            self.Label_ProgressBar:setString(str)
            self.ProgressBar_BaoMing:setPercentage(math.floor(num/numMax*100))
        end
    end
end


-- TODO  REMOVE↓
-- -- 更新进度条
-- function GameListDetailWindow:updateProgressBar(msg)
--     if self.mIsShow == true then
--         if self.matchInfo.RoomType==1 then
--             self.matchInfo.JoinMaxLimit = msg.data.JoinLimit
--             self.matchInfo.CurJoinNum = msg.data.CurJoin
--             self:updateProgressBar()
--         end
--     end
-- end
-- --    self.Label_kaisaitiaojian:setVisible(true)
--     -- self.Label_info_dingshi_baomingrenshu:setVisible(false)
--     --Label_info_dingshi_baomingrenshu 这个改成比赛时间了
--     if 1 == self.matchInfo.SelfJoin then
--         self.mValue = self.matchInfo.CurJoinNum
--         self.mLimit = self.matchInfo.JoinMaxLimit
--         if self.pageType == 2 then
--             --进度条 比赛剩余开始时间隐藏
--             self.progressBarBG:setVisible(true)
--             self.progressBar_front:setVisible(true)
--             self.Label_ProgressBar:setVisible(true)
--         else
--             --进度条 比赛剩余开始时间隐藏
--             self.progressBarBG:setVisible(false)
--             self.progressBar_front:setVisible(false)   
--             self.Label_ProgressBar:setVisible(false) 

--         end
--         local str =  self.mValue.."/"..self.mLimit
--         if self.mValue > self.mLimit then
--             str = self.mLimit.."/"..self.mLimit
--         end
--         self.Label_ProgressBar:setString(str)
--         self.ProgressBar_BaoMing:setPercentage(math.floor(self.mValue/self.mLimit*100))
--     else
--         self.mValue = self.matchInfo.CurJoinNum--0--math.random(0,self.matchInfo.JoinMaxLimit)
--         self.mLimit = self.matchInfo.JoinMaxLimit
--         if self.pageType == 2 then
--             --进度条 比赛剩余开始时间隐藏
--             self.progressBarBG:setVisible(true)
--             self.progressBar_front:setVisible(true)
--             self.Label_ProgressBar:setVisible(true)
--         else
--             --进度条 比赛剩余开始时间隐藏
--             self.progressBarBG:setVisible(false)
--             self.progressBar_front:setVisible(false)
--             self.Label_ProgressBar:setVisible(false)
--         end
--         -- self.progressBarBG :setVisible(true)
--         -- self.progressBar_front:setVisible(true)
--         -- self.Label_ProgressBar:setVisible(true)
--         local str =  self.mValue.."/"..self.mLimit
--         if self.mValue > self.mLimit then
--             str = self.mLimit.."/"..self.mLimit
--         end
--         self.Label_ProgressBar:setString(str)
--         self.ProgressBar_BaoMing:setPercentage(math.floor(self.mValue/self.mLimit*100))
--         --self.Label_ProgressBar:setString(self.mValue.."/"..self.mLimit)
        
--         -- self.Label_info_dingshi_baomingrenshu:setString(self.mValue.."/"..self.mLimit)
--     end

-- --倒计时相关初始化
-- function GameListDetailWindow:updateMatchTime()
    -- self.Label_kaisaitiaojian:setVisible(true)
    -- self.Label_info_dingshi_baomingrenshu:setVisible(true)
    -- self.Label_info_dingshi_baomingrenshu:setString(self.matchInfo.CurNum.."人")
-- end

function GameListDetailWindow:init_Details(data)
    ---右边数据信息
    if self.matchInfo.RoomType == 1 then
        --人满开赛
        --self:GetWidgetByName("Label_baomingtiaojian_value"):setString("所有玩家")
        --比赛条件
        --self.Text_b_5:setString("所有玩家")
        local db2 = laixiaddz.JsonTxtData;
        local itemDBM = db2:queryTable("items");
        --如果新加的字段 == 所有玩家  否则== 渠道专享
        self.Text_b_5:setString("所有玩家")
        -- if self.matchInfo.Conds then
        --     for key, var in pairs(self.matchInfo.Conds) do
        --         if var.ID <0 then
        --            self.Text_b_5:setString("渠道专享")
        --            break
        --         end
        --     end
        -- end
--        if self.matchInfo.Conds[1].payment_info[1].id ~= -1 then
--            self.Text_b_5:setString("所有玩家")
--        else
--           -- local Itemsdata = itemDBM:query("ItemID",self.matchInfo.Conds[1].payment_info[1].id)
--            self.Text_b_5:setString("渠道专享")--("" .. self.matchInfo.Conds[1].payment_info[1].num .. Itemsdata.ItemName)
--        end
        self:GetWidgetByName("Label_kaisaishijian"):setString(os.date("%H:%M",self.matchInfo.BeginTime).."-"..os.date("%H:%M",self.matchInfo.EndTime))
        --self:GetWidgetByName("Label_kaisaishijian"):setString("满" .. self.matchInfo.JoinMaxLimit .. "开赛")
    elseif self.matchInfo.RoomType == 2 then
        local beginHour = os.date("%H",self.matchInfo.BeginTime)
        local beginMinute = os.date("%M",self.matchInfo.BeginTime)
        local baomingEndHour = os.date("%H",self.matchInfo.BeginTime)
        local baomingEndMinute = os.date("%M",self.matchInfo.BeginTime)
        
        local str = baomingEndHour..":"..baomingEndMinute
        --self:GetWidgetByName("Label_baomingtiaojian_value"):setString(str)
        self:GetWidgetByName("Label_kaisaishijian"):setString(str)
       --定点开赛:报名时间————开赛时间
        local str = ""
        local BeginTime = self.matchInfo.BeginTime
        local CurTime = self.matchInfo.CurTime
        local hour = tostring(os.date("%H",BeginTime))
        local minute = tostring(os.date("%M",BeginTime))
        local day = ""
        if os.date("%d", BeginTime) ~= os.date("%d", CurTime) then                
            day = os.date("%d日", BeginTime)
        end
        str =day .. hour .. ":" .. minute
        local StartTime = self.matchInfo.BeginTime
        local hour1 = tostring(os.date("%H",StartTime))
        local minute1 = tostring(os.date("%M",StartTime))
        local day1 = ""
        if os.date("%d", StartTime) ~= os.date("%d", CurTime) then                
            day1 = os.date("%d日", StartTime)
        end
        str =str.."—".. day1 .. hour1 .. ":" .. minute1
       -- self:GetWidgetByName("Label_baomingtiaojian_value"):setString(str)
        --mtt报名条件
        local db2 = laixiaddz.JsonTxtData;
        local itemDBM = db2:queryTable("items");
        --如果新加的字段 == 所有玩家  否则== 渠道专享
--        if self.matchInfo.Conds[1].payment_info[1].id ~= -1 then
--            self.Text_b_5:setString("所有玩家")
--        else
--            --local Itemsdata = itemDBM:query("ItemID",self.matchInfo.Conds[1].payment_info[1].id)
--            self.Text_b_5:setString("渠道专享")--("" .. self.matchInfo.Conds[1].payment_info[1].num .. Itemsdata.ItemName)
--        end
        self.Text_b_5:setString("所有玩家")
        -- for key, var in pairs(self.matchInfo.Conds) do
        --     if var.ID <0 then
        --         self.Text_b_5:setString("渠道专享")
        --         break
        --     end
        -- end

        
        --开赛时间-当前时间
        local time = os.time()
        local nowdata = tonumber(os.date("%d", self.matchInfo.CurTime))
        local CountDown = tonumber(os.date("%d",self.matchInfo.BeginTime)) --temp[i].CurTime
        local daydiff = CountDown - nowdata
--        local CountDown = self.matchInfo.BeginTime-self.matchInfo.CurTime
--        local hour = math.floor(CountDown/3600)
--        local day = ""
        --if hour >= 24 then
        if daydiff>=3 then
            self:GetWidgetByName("Label_kaisaishijian"):setString(os.date("%m",self.matchInfo.BeginTime).."月"..os.date("%d",self.matchInfo.BeginTime).."日")
            --if math.floor(hour/24)<3 and  math.floor(hour/24)>=2 then
        elseif daydiff>=2 then
                self:GetWidgetByName("Label_kaisaishijian"):setString("后天")
        elseif daydiff>=1 then
            --elseif math.floor(hour/24)<2 and  math.floor(hour/24)>=1 then
                self:GetWidgetByName("Label_kaisaishijian"):setString("明天")
            --else     
            --end 
        else
            --self.Label_kaisaishijian:setString("今天"..os.date("%H",self.matchInfo.BeginTime)..":"..os.date("%M",self.matchInfo.BeginTime))
            if math.abs(self.matchInfo.BeginTime - self.matchInfo.EndTime)<60 then -- 开始时间和结束时间有4s的误差 所以不相等 ？？？？？？？？？？？？？？
                self:GetWidgetByName("Label_kaisaishijian"):setString("今天" .. os.date("%H:%M",self.matchInfo.BeginTime))
            else
                self:GetWidgetByName("Label_kaisaishijian"):setString(os.date("%H:%M",self.matchInfo.BeginTime).."-"..os.date("%H:%M",self.matchInfo.EndTime))
            end
        end
        
    end

    --初始积分
    --self:GetWidgetByName("Label_chushijifen_value"):setString(self.matchInfo.InitCoin)
    -- #self.matchInfo.Stages == 1
    --if #self.matchInfo.Stages == 1 then
        --之前的赛制
        -- print("000000000000000")
        -- self.Text_b_3:setVisible(true)
        -- self.Text_b_3:setString(string.split(self.matchInfo.match_format[1],"决赛:")[2])
        -- self.Text_b_9:setVisible(false)
        -- self.Text_b_10:setVisible(false)

        -- self.Label_jiasai_value:setVisible(false)
        -- self.Label_yusai_value:setVisible(false)
        -- self.Label_yusai:setVisible(false)
        -- self.Label_jiasai:setVisible(false)
        -- self.Label_juesai:setVisible(true)
        -- self.Label_juesai_value:setVisible(true)
        --self.Label_juesai_value:setString(string.split(self.matchInfo.Stages[1],"决赛:")[2])
        --local ponity = self.Label_juesai:getPositionY()
        -- self.Label_juesai:setPositionY(ponity)
        -- self.Label_juesai_value:setPositionY(ponity)

    -- elseif #self.matchInfo.Stages == 2 then
    --     --之前的赛制
    --     print("111111111111")
    --     self.Text_b_3:setVisible(true)
    --     self.Text_b_3:setString(string.split(self.matchInfo.match_format[1],"预赛:")[2])
    --     self.Text_b_9:setVisible(true)
    --     self.Text_b_9:setString(string.split(self.matchInfo.match_format[2],"决赛:")[2])
    --     self.Text_b_10:setVisible(false)

        -- self.Label_jiasai_value:setVisible(false)
        -- self.Label_jiasai:setVisible(false)
        -- self.Label_yusai_value:setVisible(true)
        -- self.Label_yusai:setVisible(true)
        -- self.Label_juesai:setVisible(true)
        -- self.Label_juesai_value:setVisible(true)

        -- self.Label_yusai_value:setString(string.split(self.matchInfo.Stages[1],"预赛:")[2])
        -- self.Label_juesai_value:setString(string.split(self.matchInfo.Stages[2],"决赛:")[2])
        -- local ponity = self.Label_juesai:getPositionY()
        -- self.Label_juesai:setPositionY(ponity)
        -- self.Label_juesai_value:setPositionY(ponity)
    -- else
    --     --之前的赛制
    --     print("3333333333")
    --     self.Text_b_3:setVisible(true)
    --     self.Text_b_3:setString(string.split(self.matchInfo.match_format[1],"预赛:")[2])
    --     self.Text_b_9:setVisible(true)
    --     self.Text_b_9:setString(string.split(self.matchInfo.match_format[2],"加赛:")[2])
    --     self.Text_b_10:setVisible(true)
    --     self.Text_b_10:setString(string.split(self.matchInfo.match_format[3],"决赛:")[2])

        -- self.Label_jiasai_value:setVisible(true)
        -- self.Label_yusai_value:setVisible(true)
        -- self.Label_yusai:setVisible(true)
        -- self.Label_jiasai:setVisible(true)
        -- self.Label_juesai:setVisible(true)
        -- self.Label_juesai_value:setVisible(true)
        -- self.Label_yusai_value:setString(string.split(self.matchInfo.Stages[1],"预赛:")[2])
        -- self.Label_jiasai_value:setString(string.split(self.matchInfo.Stages[2],"加赛:")[2])
        -- self.Label_juesai_value:setString(string.split(self.matchInfo.Stages[3],"决赛:")[2])
    --end
    

end

function GameListDetailWindow:updateButton()
    self.GameDetail_Button_Begined:setVisible(false)
    self.GameDetail_Button_Quit:setVisible(false)
    self.GameDetail_Button_ToBegin:setVisible(false)
    if self.matchInfo then
        self.GameDetail_Button_Register:setVisible(1 == self.matchInfo.State)
        self:GetWidgetByName("Button_No_start"):setVisible(0 == self.matchInfo.State)
    else
        self.GameDetail_Button_Register:setVisible(false)
        self:GetWidgetByName("Button_No_start"):setVisible(false)
    end
    -- if not self.matchInfo then
    --     self.GameDetail_Button_ToBegin:setVisible(false)
    --     self.GameDetail_Button_Register:setVisible(false)
    --     self:GetWidgetByName("Button_No_start"):setVisible(true)
    -- else
    --     if 2 == self.matchInfo.State or 1 == self.matchInfo.SelfJoin then
    --         -- 报名了
    --         self.GameDetail_Button_ToBegin:setVisible(false)
    --         self.GameDetail_Button_Register:setVisible(false)
    --         if self.matchInfo.RoomType == 2 then -- 人满开赛不能有关闭叉子
    --             self:GetWidgetByName("GameDetail_Button_ShutDown"):setVisible(false)
    --         elseif self.matchInfo.RoomType == 1 then
    --             self:GetWidgetByName("GameDetail_Button_ShutDown"):setVisible(true)
    --         end
    --     elseif 0 == self.matchInfo.State then
    --         -- 不能报名
    --         self.GameDetail_Button_ToBegin:setVisible(false)
    --         self.GameDetail_Button_Register:setVisible(false)
    --         self:GetWidgetByName("Button_No_start"):setVisible(true)
    --     else
    --         -- 可报名
    --         self.GameDetail_Button_ToBegin:setVisible(false)
    --         self.GameDetail_Button_Register:setVisible(true)
    --         self:GetWidgetByName("Button_No_start"):setVisible(false)
    --     end

--         --已报名 修123(后台应该发过来sng的报名状态 1/other)
--         if 1 == self.matchInfo.SelfJoin then
--             self.GameDetail_Button_ToBegin:setVisible(false)
--             self.GameDetail_Button_Register:setVisible(false)
--             self.GameDetail_Button_Begined:setVisible(false)
--             self.GameDetail_Button_Quit:setVisible(true)

--             self.showButton  = self.GameDetail_Button_Quit


--             if self.matchInfo.RoomType == 2 then -- 人满开赛不能有关闭叉子
--                 self:GetWidgetByName("GameDetail_Button_ShutDown"):setVisible(false)
--             elseif self.matchInfo.RoomType == 1 then
--                 self:GetWidgetByName("GameDetail_Button_ShutDown"):setVisible(true)
--             end
--         else
--             if 2 == self.matchInfo.State then        --如果是报名中 sng的state只有2这个状态  也就是sng 重连上来的 SelfJoin 和 State两个参数必须正确    
--                 self.GameDetail_Button_ToBegin:setVisible(false)
--                 self.GameDetail_Button_Register:setVisible(true)
--                 self.GameDetail_Button_Quit:setVisible(false)
--                 self.GameDetail_Button_Begined:setVisible(false)
-- --                self.GameDetail_Button_Register:setPosition( self.Image_Button_MidPoint:getPosition())
--                 self.showButton  = self.GameDetail_Button_Register
--             elseif 4 == self.matchInfo.State or 3 == self.matchInfo.State then --按钮状态  已经开始  3比赛中  1比赛开始前
--                 --self:GetWidgetByName("Image_jinbiaosaiBg"):setVisible(false)
-- --                self.GameDetail_Button_ToBegin:setVisible(true)
--                 self.GameDetail_Button_Begined:setVisible(true)
--                 self.GameDetail_Button_Register:setVisible(false)
--                 self.GameDetail_Button_Quit:setVisible(false)
--                 --self:GetWidgetByName("Label_kaisaishijianwenzi"):setVisible(false)
--                 --self:GetWidgetByName("Label_kaisaitiaojian_temp"):setVisible(false)
--             else    --报名前或者比赛中
--                 self.GameDetail_Button_ToBegin:setVisible(false)
--                 self.showButton  = self.GameDetail_Button_ToBegin
                
--                 --self:GetWidgetByName("Image_jinbiaosaiBg"):setVisible(false)

--                 self.GameDetail_Button_Register:setVisible(false)
--                 self.GameDetail_Button_Quit:setVisible(false)
--             end
--         end
    -- end
end

function GameListDetailWindow:onShow(mesg)
    if not self.mIsShow then
        self.matchInfo = mesg.data
        self.GameDetail_Button_ToBegin = self:GetWidgetByName("GameDetail_Button_ToBegin")
        self:AddWidgetEventListenerFunction("GameDetail_Button_ToBegin", handler(self, self.toBegin)) --即将开始

        self:AddWidgetEventListenerFunction("GameDetail_Button_ShutDown", handler(self, self.shutdown))  --关闭按钮

        self.GameDetail_Button_Register = self:GetWidgetByName("GameDetail_Button_Register")
        self:AddWidgetEventListenerFunction("GameDetail_Button_Register", handler(self, self.registration)) --报名

        self.GameDetail_Button_Quit = self:GetWidgetByName("GameDetail_Button_Quit")
        self:AddWidgetEventListenerFunction("GameDetail_Button_Quit",handler(self, self.quitRegistration)) --退赛
        
        self.GameDetail_Button_Begined = self:GetWidgetByName("GameDetail_Button_Begined")
        self:AddWidgetEventListenerFunction("GameDetail_Button_Begined",handler(self,self.Begined))
        self:updateButton()

        self:schedulerTick()
        self:startTimer()
        self:updateLineNum()
        self:startLineNumTimer()
        self.Panel_baoming = self:GetWidgetByName("Panel_baoming")
        self.Panel_baoming:setVisible(false)
        --title match_des
        self.BG1 = self:GetWidgetByName("Image_bg1")
        self.BG1:setTouchEnabled(true)
        self.BG1:setTouchSwallowEnabled(true)
        self.BG2 = self:GetWidgetByName("Image_dbg")
        self.BG2:setTouchEnabled(true)
        self.BG2:setTouchSwallowEnabled(true)
        
        self.Text_80 = self:GetWidgetByName("Text_80")
        self.Text_80:enableOutline(cc.c4b(38,23,70,255), 2)
        self.Text_80:setVisible(true)
        self:GetWidgetByName("Image_dbt1"):setVisible(false)
        self.pageType = 2
        --用到的字段不用管 没用到的字段该显示显示 不该显示隐藏

        --比赛详情  11111111111111111111sng和mtt都显示或不显示
        self.Image_1 = self:GetWidgetByName("Image_1")
        self.Image_2 = self:GetWidgetByName("Image_2")
        self.Image_3 = self:GetWidgetByName("Image_3")
        -- self.Image_4 = self:GetWidgetByName("Image_4")
        self.Image_5 = self:GetWidgetByName("Image_5")
        self.Image_6 = self:GetWidgetByName("Image_6")
        self.Image_7 = self:GetWidgetByName("Image_7")
        self.Text_1 = self:GetWidgetByName("Text_1")
        self.Text_2 = self:GetWidgetByName("Text_2")
        self.Text_3 = self:GetWidgetByName("Text_3")
        -- self.Text_4 = self:GetWidgetByName("Text_4")
        self.Text_5 = self:GetWidgetByName("Text_5")
        self.Text_6 = self:GetWidgetByName("Text_6")
        self.Text_7 = self:GetWidgetByName("Text_7")
        self.Image_b_1 = self:GetWidgetByName("Image_b_1")
        self.Image_b_2 = self:GetWidgetByName("Image_b_2")
        -- self.Image_b_3 = self:GetWidgetByName("Image_b_3")
        -- self.Image_b_4 = self:GetWidgetByName("Image_b_4")
        self.Image_b_5 = self:GetWidgetByName("Image_b_5")
        ---//
        self.Image_b_6_ = self:GetWidgetByName("Image_b_6")
        self.Image_b_7_ = self:GetWidgetByName("Image_b_7")
        self.Image_b_8_ = self:GetWidgetByName("Image_b_8")
        --//
        self.Label_kaisaishijian = self:GetWidgetByName("Label_kaisaishijian")
        self.Text_b_2 = self:GetWidgetByName("Text_b_2")
        self.Text_b_3 = self:GetWidgetByName("Text_b_3")
        self.Text_b_4 = self:GetWidgetByName("Text_b_4")
        self.Text_b_5 = self:GetWidgetByName("Text_b_5")
        --//
        self.Text_b_6 = self:GetWidgetByName("Text_b_6")
        self.Text_b_7 = self:GetWidgetByName("Text_b_7")
        self.Text_b_8 = self:GetWidgetByName("Text_b_8")
        --//
        self.Text_b_9 = self:GetWidgetByName("Text_b_9")
        self.Text_b_10 = self:GetWidgetByName("Text_b_10")
        -- self.Text_b_11 = self:GetWidgetByName("Text_b_11")
        -- self.Text_b_12 = self:GetWidgetByName("Text_b_12")
        -- self.Text_b_13 = self:GetWidgetByName("Text_b_13")

        self.Image_1:setVisible(false)
        self.Image_2:setVisible(false) 
        self.Image_3:setVisible(false) 
        -- self.Image_4:setVisible(false) 
        self.Image_5:setVisible(false)
        self.Image_6:setVisible(false) 
        self.Image_7:setVisible(false)
        self.Text_1:setVisible(false)
        self.Text_2:setVisible(false)
        self.Text_3:setVisible(false) 
        -- self.Text_4:setVisible(false) 
        self.Text_5:setVisible(false) 
        self.Text_6:setVisible(false)
        self.Text_7:setVisible(false) 
        self.Image_b_1:setVisible(false) 
        self.Image_b_2:setVisible(false)
        -- self.Image_b_3:setVisible(false)
        -- self.Image_b_4 :setVisible(false)
        self.Image_b_5:setVisible(false) 
        --//
        -- self.Image_b_6_:setVisible(false) 
        -- self.Image_b_7_:setVisible(false) 
        -- self.Image_b_8_:setVisible(false) 
        --//
        self.Label_kaisaishijian:setVisible(false) 
        self.Text_b_2:setVisible(false)
        self.Text_b_3:setVisible(false) 
        self.Text_b_4:setVisible(false)
        self.Text_b_5:setVisible(false) 
        --//
        self.Text_b_6:setVisible(false) 
        self.Text_b_7:setVisible(false) 
        self.Text_b_8:setVisible(false) 
        --//
        self.Text_b_9:setVisible(false) 
        self.Text_b_10:setVisible(false) 
        -- self.Text_b_11:setVisible(false) 
        -- self.Text_b_12:setVisible(false) 
        -- self.Text_b_13:setVisible(false)
        
        
        --SNG3333333333333333333333333 将比赛奖励和mtt隐藏
        self.Image_load_bg1 = self:GetWidgetByName("Image_load_bg1") 

        --进度条后背景
        self.Image_ProgressBar_BG = self:GetWidgetByName("Image_ProgressBar_BG")
        --进度条前背景
        self.progressBar_front = self:GetWidgetByName("Image_ProgressBar_Front") 
        self.progressBarBG = self:GetWidgetByName("Image_load")
        self.Label_ProgressBar = self:GetWidgetByName("Label_ProgressBar")

        --progressbar
        self.Image_load_bg1:setVisible(false)
        self.progressBarBG:setVisible(false)
        self.Image_ProgressBar_BG:setVisible(false)
        self.progressBar_front:setVisible(false)
        self.Label_ProgressBar:setVisible(false)
       
        --self.Image_load = self:setVisible(false)
        --label_progressbar  
        --self.Label_ProgressBar = self:GetWidgetByName("Label_ProgressBar")

        --MTT4444444444444444444  将比赛奖励和进度条sng隐藏
        --Image_jinbiaosaiBg找这个界面 之前是1个背景 现在3个 1找这个节点 2然后这个节点做了什么操作这三个节点也做什么操作 2隐藏之前节点的代码
        --三个时间背景
        self.Text_25 = self:GetWidgetByName("Text_25")
        self.Image_33 = self:GetWidgetByName("Image_33")
        self.Image_35 = self:GetWidgetByName("Image_35")
        self.Image_36 = self:GetWidgetByName("Image_36")
        self.Label_maohao_1 = self:GetWidgetByName("Text_maohao_1")
        self.Label_maohao_2 = self:GetWidgetByName("Text_maohao_2")

        self.Text_25:setVisible(false)

        self.Label_jinbiaosaishijian1 = self:GetWidgetByName("Label_jinbiaosaishijian1") --锦标赛时间
        self.Label_jinbiaosaishijian2 = self:GetWidgetByName("Label_jinbiaosaishijian2") --锦标赛时间
        self.Label_jinbiaosaishijian3 = self:GetWidgetByName("Label_jinbiaosaishijian3") --锦标赛时间

        -- self.Image_33:setVisible(false)
        -- self.Image_35:setVisible(false)
        -- self.Image_36:setVisible(false)
        --三个时间label 用到的节点不用管


        itemDBM = db2:queryTable("items");
        -- self.GameDetail_Button_Back = self:GetWidgetByName("GameDetail_Button_Back")
        -- self:AddWidgetEventListenerFunction("GameDetail_Button_Back",handler(self, self.Back)) -- 返回按钮
        self.showButton = nil  --当前显示的按钮控件

--        self.Image_Button_LeftPoint = self:GetWidgetByName("Image_Button_LeftPoint") --左边按钮的坐标点
--        self.Image_Button_MidPoint = self:GetWidgetByName("Image_Button_MidPoint") --中间按钮的坐标点
--        self.Image_Button_RightPoint = self:GetWidgetByName("Image_Button_RightPoint") --右边按钮的坐标点

        self:AddWidgetEventListenerFunction("GameDetail_Button_Jiangli1",handler(self, self.IncentiveScheme))   --奖励方案
        self:AddWidgetEventListenerFunction("GameDetail_Button_Detail1",handler(self, self.MatchDetails)) --比赛详情

        self.GameDetail_Button_Detail1 = self:GetWidgetByName("GameDetail_Button_Detail1")
        self.GameDetail_Button_Detail2 = self:GetWidgetByName("GameDetail_Button_Detail2")
        self.GameDetail_Button_Jiangli1 = self:GetWidgetByName("GameDetail_Button_Jiangli1")
        self.GameDetail_Button_Jiangli2 = self:GetWidgetByName("GameDetail_Button_Jiangli2")

        self.Text_76 = self:GetWidgetByName("Text_76")
        self.Text_76:enableOutline(cc.c4b(141,66,0,255), 1)
        self.Text_77 = self:GetWidgetByName("Text_77")
        self.Text_77:enableOutline(cc.c4b(141,66,0,255), 1)
        self.Text_78 = self:GetWidgetByName("Text_78")
        self.Text_78:enableOutline(cc.c4b(141,66,0,255), 1)
        self.Text_79 = self:GetWidgetByName("Text_79")
        self.Text_79:enableOutline(cc.c4b(141,66,0,255), 1)
        
        

--        self.Panel_info=self:GetWidgetByName("GameDetail_Panel_SignUp")      --比赛信息页面 --报名页
        self.Panel_jiangli=self:GetWidgetByName("GameDetail_Panel_Gift")      --比赛奖励页面 --名次奖励
        self.Panel_MatchDetails=self:GetWidgetByName("GameDetail_Panel_Details")      --比赛详情页面

        self.listView = self:GetWidgetByName("GameDetail_Gift_ListView",self.Panel_jiangli)     --名次的列表
        self.mNode = self:GetWidgetByName("GameDetail_Gift_Board_Cell")               --名次的cell

        -- self.Label_juesai_value= self:GetWidgetByName("Label_juesai_value")    
        -- self.Label_jiasai_value= self:GetWidgetByName("Label_jiasai_value") 
        -- self.Label_yusai_value= self:GetWidgetByName("Label_yusai_value")  
        -- self.Label_yusai= self:GetWidgetByName("Label_yusai")    
        -- self.Label_jiasai= self:GetWidgetByName("Label_jiasai") 
        -- self.Label_juesai= self:GetWidgetByName("Label_juesai")    

        --self.Label_kaisaitiaojian = self:GetWidgetByName("Label_kaisaitiaojian")          --开赛条件
        
--        self.Label_info_dingshi_baomingrenshu = self:GetWidgetByName("Label_DingShiRenShu")--定时赛人数

        -- self.Label_jinbiaosaishijian1 = self:GetWidgetByName("Label_jinbiaosaishijian1") --锦标赛时间
        -- self.Label_jinbiaosaishijian2 = self:GetWidgetByName("Label_jinbiaosaishijian2") --锦标赛时间
        -- self.Label_jinbiaosaishijian3 = self:GetWidgetByName("Label_jinbiaosaishijian3") --锦标赛时间
        
        --self.Label_kaisaishijian = self:GetWidgetByName("Label_kaisaishijian")
        -- self.ProgressBar_BaoMing = self:GetWidgetByName("ProgressBar_BaoMing")      --info中人满的进度条
        -- self.ProgressBar_BaoMing:setVisible(false)
        ---tudo1手动创建进度条

        self.ProgressBar_BaoMing = display.newProgressTimer("res/new_ui/GameDetail/sng_jindutiao.png",display.PROGRESS_TIMER_RADIAL )
        self.progressBarBG = self:GetWidgetByName("Image_ProgressBar_BG")
        self.progressBarBG:addChild(self.ProgressBar_BaoMing) 
        self.ProgressBar_BaoMing:setPosition(self.progressBarBG:getContentSize().width/2,self.progressBarBG:getContentSize().height/2)

        --self.Label_ProgressBar = self:GetWidgetByName("Label_ProgressBar")          --info中人满的进度条文本显示
        --self.progressBarBG = self:GetWidgetByName("Image_ProgressBar_BG") 
        --self.progressBar_front = self:GetWidgetByName("Image_ProgressBar_Front")
        
        -- self.Title_Renmankaisai = self:GetWidgetByName("Image_renmankaisai")
        -- self.Title_Renmankaisai:setVisible(false)
        -- self.Title_Jinbiaosai = self:GetWidgetByName("Image_jinbiaosai")
        -- self.Title_Jinbiaosai:setVisible(false)
        
        -- self.progressBarBG:addChild(self.ProgressBar_BaoMing)
        self.mIsShow = true
    end

    -- dump(mesg)
    -- dump(self.matchInfo)
    self.god =0
    self.liquan =0
    self.CountDown = 0

    --标题
    self.Text_80:setString(self.matchInfo.RoomName)

     --比赛奖励 222222222222222222222222点击比赛奖励将其他的全部隐藏 只显示比赛奖励字段
    self.Text_68 = self:GetWidgetByName("Text_68")
    self.Text_69 = self:GetWidgetByName("Text_69")
    self.Text_68:setVisible(false)
    self.Text_69:setVisible(false)
    
    self.Panel_12 = self:GetWidgetByName("Panel_12")
    self.Panel_12:setVisible(false)
    self.ListView_1 = self:GetWidgetByName("GameDetail_Gift_ListView")
    self.ListView_1:setVisible(false)
    
--    self.ListView_1:removeAllItems()
--    for i =1,##self.matchInfo.RankRds do
--        local panel_js = self.Panel_12:clone()
--        self.ListView_1:pushBackCustomItem(panel_js)
--    end
    -----------------------------------------------------

    self.mValu = self.matchInfo.CurNum
    self.mLimi = self.matchInfo.JoinMinLimit
    self.maxLimi = self.matchInfo.JoinMaxLimit
    if self.mLimi == self.maxLimi then
        self.Text_b_2:setString((self.mLimi or 0) .. "人")    
    else
        self.Text_b_2:setString((self.mLimi or 0) .."-"..(self.maxLimi or 0).. "人")    
    end
    --比赛介绍
    self.Text_bt = self:GetWidgetByName("Text_bt")
    self.Text_bt:setString("比赛介绍：" .. self.matchInfo.match_desc)

    --比赛赛制
    self.num1 = string.split(self.matchInfo.match_format,"/r")
    print("比赛赛制比赛赛制")
    dump(self.num1)
    if #self.num1 ==1 then
        self.Text_b_3:setVisible(true)
        self.Text_b_3:setString("" .. self.num1[1])
        self.Text_b_9:setVisible(false)
        self.Text_b_10:setVisible(false)
    elseif #self.num1 == 2 then
        self.Text_b_3:setVisible(true)
        self.Text_b_3:setString("" .. self.num1[1])
        self.Text_b_9:setVisible(true)
        self.Text_b_9:setString("" .. self.num1[2])
        self.Text_b_10:setVisible(false)
    else
        self.Text_b_3:setVisible(true)
        self.Text_b_3:setString("" .. self.num1[3])
        self.Text_b_9:setVisible(true)
        self.Text_b_9:setString("" .. self.num1[2])
        self.Text_b_10:setVisible(true)
        self.Text_b_10:setString("" .. self.num1[3])
    end
    -- self.Text_b_3:setVisible(true)
    -- self.Text_b_3:setString(self.matchInfo.match_format)
    -- self.Text_b_9:setVisible(false)
    -- self.Text_b_10:setVisible(false)
  
    

    --比赛规则
    self.num2 = string.split(self.matchInfo.match_careful,"/r")
    if #self.num2 ==1 then
        -- self.Text_b_11:setVisible(true)
        -- self.Text_b_11:setString("" .. self.num2[1])
        -- self.Text_b_12:setVisible(false)
        -- self.Text_b_13:setVisible(false)
    elseif #self.num2 == 2 then
        -- self.Text_b_11:setVisible(true)
        -- self.Text_b_11:setString("" .. self.num2[1])
        -- self.Text_b_12:setVisible(true)
        -- self.Text_b_12:setString("" .. self.num2[2])
        -- self.Text_b_13:setVisible(false)
    else
        -- self.Text_b_11:setVisible(true)
        -- self.Text_b_11:setString("" .. self.num2[1])
        -- self.Text_b_12:setVisible(true)
        -- self.Text_b_12:setString("" .. self.num2[2])
        -- self.Text_b_13:setVisible(true)
        -- self.Text_b_13:setString("" .. self.num2[3])
    end
    -- self.Text_b_11:setString(self.matchInfo.match_careful)
    -- self.Text_b_12:setVisible(false)
    -- self.Text_b_13:setVisible(false)

    --定时赛的倒计时RoomType = 2人满开赛 1定时开赛

    -- if self.matchInfo.RoomType == 0 and self.matchInfo.BeginTime-self.matchInfo.CurTime>0 then
    if self.matchInfo.RoomType == 1 and self.matchInfo.BeginTime-tonumber(os.time()) > 0 then
        --self.Title_Jinbiaosai:setVisible(false)
        -- self.Title_Renmankaisai:setVisible(false)
        self.CountDown = self.matchInfo.BeginTime-tonumber(os.time()) -- self.matchInfo.BeginTime-self.matchInfo.CurTime
        self.Image_load_bg1:setVisible(false)
        self.progressBarBG:setVisible(false)
        self.progressBar_front:setVisible(false)
        self.ProgressBar_BaoMing:setVisible(false)
        self.Label_ProgressBar:setVisible(false)
       -- self:GetWidgetByName("Label_kaisaitiaojian_temp"):setVisible(false)

        self.Label_jinbiaosaishijian1:setVisible(true)
        self.Label_jinbiaosaishijian2:setVisible(true)
        self.Label_jinbiaosaishijian3:setVisible(true)

        self.Image_33:setVisible(true)
        self.Image_35:setVisible(true)
        self.Image_36:setVisible(true)
        self.Label_maohao_1:setVisible(true)
        self.Label_maohao_2:setVisible(true)
        self.Text_25:setVisible(true)
    else
        --self.Title_Renmankaisai:setVisible(true)
        --self.Title_Jinbiaosai:setVisible(false)

        if self.pageType == 2 then
            self.Image_load_bg1:setVisible(false)
            self.progressBarBG:setVisible(true)
            self.Image_ProgressBar_BG:setVisible(true)
            self.progressBar_front:setVisible(true)
            self.Label_ProgressBar:setVisible(true)
            self.ProgressBar_BaoMing:setVisible(true)
        else
            --进度条 比赛剩余开始时间隐藏
            self.Image_load_bg1:setVisible(false)
            self.progressBarBG:setVisible(false)
            self.Image_ProgressBar_BG:setVisible(false)
            self.progressBar_front:setVisible(false)
            self.Label_ProgressBar:setVisible(false)
            self.ProgressBar_BaoMing:setVisible(false)
        end

        -- self.Image_load_bg1:setVisible(false)
        -- self.progressBarBG:setVisible(true)
        -- self.Image_ProgressBar_BG:setVisible(true)
        -- self.progressBar_front:setVisible(true)
        -- self.Label_ProgressBar:setVisible(true)
        -- self.ProgressBar_BaoMing:setVisible(true)
        
        self.Label_jinbiaosaishijian1:setVisible(false)
        self.Label_jinbiaosaishijian2:setVisible(false)
        self.Label_jinbiaosaishijian3:setVisible(false)

        self.Image_33:setVisible(false)
        self.Image_35:setVisible(false)
        self.Image_36:setVisible(false)
        self.Label_maohao_1:setVisible(false)
        self.Label_maohao_2:setVisible(false)
        self.Text_25:setVisible(false)
    end

--------------------------------------------------------
--panel
    -- self.JoinRoomUI = self:GetWidgetByName("Panel_22")
    -- self.Button_true = self:GetWidgetByName("Button_true")
    -- self.Button_back = self:GetWidgetByName("Button_back")
    -- self:AddWidgetEventListenerFunction("Button_true",self.onJoinGame)
    -- self:AddWidgetEventListenerFunction("Button_back",self.onJoinGame)
    -- self.JoinRoomUI:setVisible(false)
    -- self.Button_true:setVisible(false)
    -- self.Button_back:setVisible(false)
    -- --重新设置Num
    -- self:AddWidgetEventListenerFunction("Button_ResetNum",self.onResetNum)
    -- self:AddWidgetEventListenerFunction("Button_DelNum",self.onDelNum)
    -- --密码框 输入键的监听
    -- for i = 1,10 do
    --    local num = i -1
    --    local path = "Button_".. num
    --    local node = self:GetWidgetByName(path,self.JoinRoomUI)
    --    node.Num = num
    --    node:addTouchEventListener( handler(self,self.onAddNum)) --游戏类型
    -- end
-----------------------------------------------------------
    --
    self.Panel_27 = self:GetWidgetByName("Panel_27")
    self.Panel_27:setVisible(false)
    self.TextField_1 = self:GetWidgetByName("TextField_1",self.Panel_27)
    --self.TextField_1:registerScriptEditBoxHandler(function(eventname,sender) self:editboxHandle(e
    self.editTxt = ccui.EditBox:create(cc.size(540,40),"new_ui/PersonalCenterWindow/tiao.png")  --输入框尺寸，背景图片
    self.sttr = ""
    self.editTxt:setName("edit")  
    self.editTxt:setAnchorPoint(0,0)  
    self.editTxt:setPosition(0,0)                        --设置输入框的位置  
    self.editTxt:setFontSize(30)                            --设置输入设置字体的大小  
    self.editTxt:setMaxLength(7)                             --设置输入最大长度为6  
    self.editTxt:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    self.editTxt:setFontName("simhei")                       --设置输入的字体为simhei.ttf  
    -- self.editTxt:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.editTxt:setPlaceHolder("请输入参赛码")               --设置预制提示文本  
    self.editTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)  --输入键盘返回类型，done，send，go等KEYBOARD_RETURNTYPE_DONE  
    -- self.editTxt:setInputMode(cc.EDITBOX_INPUT_MODE_ANY) --输入模型，如整数类型，URL，电话号码等，会检测是否符合  
    self.editTxt:registerScriptEditBoxHandler(function(eventname,sender) self:editboxHandle(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等  
    self.TextField_1:addChild(self.editTxt,5)  
--  editTxt:setHACenter() --输入的内容锚点为中心，与anch不同，anch是用来确定控件位置的，而这里是确定输入内容向什么方向展开(。。。说不清了。。自己测试一下)  
    self:AddWidgetEventListenerFunction("Button_ok",handler(self, self.goOK))
    self:AddWidgetEventListenerFunction("Button_quick",handler(self, self.GOback))

    self:init_LiftUI()
    self:init_RightUI()
    self:changePageUI(2) --初始化显示
    if self.matchInfo.RoomType == 2 and self.matchInfo.Sate == 2 then
        self:GetWidgetByName("GameDetail_Button_ShutDown"):setVisible(false)
    end
end

--输入框事件处理  
function GameListDetailWindow:editboxHandle(strEventName,sender)  
    if strEventName == "began" then  
        sender:setText("")                                      --光标进入，清空内容/选择全部  
    elseif strEventName == "ended" then  
        self.sttr = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
    elseif strEventName == "return" then  
        self.sttr = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
    elseif strEventName == "changed" then  
        self.sttr = sender:getText()                                                           --输入内容改变时调用   
    end  
end  

function GameListDetailWindow:GOback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Panel_27:setVisible(false)
        self.GameDetail_Button_Register:setTouchEnabled(true)
    end
end

function GameListDetailWindow:goOK(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        local mima = tostring(self.sttr)
        --如果点击了 确定按钮 并且字符串是空 提示 需要输入密码
        if self.sttr == "" then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "参赛码不能为空！")
            self.editTxt:setText("")
            return
        end
        -- 伊诺凯 前端核对给定范围的验证码
        --if 在范围内 那么 将报名码RegisterCode 发送过去 else "需要输入正确的参赛码"
        --①
        -- local sttr1 = self.sttr
        -- local sttr2 = self.sttr
        -- local sttr3 = self.sttr
        -- local str1 = tonumber(string.sub(sttr1,4,5))
        -- local str2 = tonumber(string.sub(sttr2,6,7))
        -- local str3 = string.sub(sttr3,1,3)
        --②
        -- local number1 = string.len(self.sttr)
        -- if string.upper(str3) == "YNK"  and (1 <= str1 and str1 <= 13) and (1 <= str2 and str2 <= 10) and number1==7 then
        --     self.Panel_27:setVisible(false)
        --     local reward = self.matchInfo.RankRds[1].Reward[1]
        --     local ItemsdataReward = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",reward.ID);
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW, {["RoomType"]=self.matchInfo.RoomType,["RoomID"] =self.matchInfo.RoomID})
        --     cc.UserDefault:getInstance():setDoubleForKey("matdchRoomID",self.matchInfo.RoomID)
        --     laixiaddz.LocalPlayercfg.LaixiaMatchName = self.matchInfo.RoomName
        -- else
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要输入正确的参赛码！")
        --     self.editTxt:setText("")
        -- end
        -- if mima ~= tostring(self.matchInfo.Conds[1].payment_info[1].num) then--mima ~= self.matchInfo. [] --如果mima~=后台发过来的密码 
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要输入正确的参赛码！")
        --     self.editTxt:setText("")
        -- else --否则密码相等
        --     self.Panel_27:setVisible(false)
        --     self.GameDetail_Button_Register:setTouchEnabled(true)
        --     local reward = self.matchInfo.RankRds[1].Reward[1]
        --     local ItemsdataReward = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",reward.ID);
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW, {["RoomType"]=self.matchInfo.RoomType,["RoomID"] =self.matchInfo.RoomID})
        --     cc.UserDefault:getInstance():setDoubleForKey("matdchRoomID",self.matchInfo.RoomID)
        --     laixiaddz.LocalPlayercfg.LaixiaMatchName = self.matchInfo.RoomName
        --     --laixiaddz.LocalPlayercfg.LaixiaMatchName = self:GetWidgetByName("GameDetail_Lebel_Title"):getString()
        -- end
        --前端核对 后台的验证码

    --     if mima ~= self.matchInfo.Conds[1].payment_info[1].num then--mima ~= self.matchInfo. [] --如果mima~=后台发过来的密码 
    --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要输入正确的参赛码！")
    --         self.editTxt:setText("")
    --     else --否则密码相等
    --         self.Panel_27:setVisible(false)
    --         local reward = self.matchInfo.RankRds[1].Reward[1]
    --         local ItemsdataReward = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",reward.ID);
    --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW, {["RoomType"]=self.matchInfo.RoomType,["RoomID"] =self.matchInfo.RoomID})
    --         cc.UserDefault:getInstance():setDoubleForKey("matdchRoomID",self.matchInfo.RoomID)
    --         laixiaddz.LocalPlayercfg.LaixiaMatchName = self.matchInfo.RoomName
    --         --laixiaddz.LocalPlayercfg.LaixiaMatchName = self:GetWidgetByName("GameDetail_Lebel_Title"):getString()
    --     end

    end
end

-- function GameListDetailWindow:onAddNum(sender, eventType)
--     if eventType == ccui.TouchEventType.ended then
--         laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--         -- local str=self.mJoinRoomID:getString()
--         -- local tableID = tonumber(str)
--         -- local num  = sender.Num
--         -- if tableID == nil then
--         --     self.mJoinRoomID:setString(num)
--         -- else
--         --     str = str .. num
--         --     self.mJoinRoomID:setString(str)
--         -- end
--         local flag = true
--         for i=1,6 do
--             if self:GetWidgetByName("Text_JoinRoom_id"..  i,self.JoinRoomUI):getString() == "" then
--                 self:GetWidgetByName("Text_JoinRoom_id".. i,self.JoinRoomUI):setString(sender.Num)
--                 flag = false
--                 if i == 6 then
--                   flag = true
--                 end
--                 break
--             end
--         end
--         if flag == true then
--             --输入正确进入比赛
--             --self:onJoinGame()
--         end
--     end
-- end

-- --报名
-- function GameListDetailWindow:onJoinGame(sender, eventType)
--     if eventType == ccui.TouchEventType.ended then
--         laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

--         local str=""
--         for i=1,6 do
--             str = str..self:GetWidgetByName("Text_JoinRoom_id".. i,self.JoinRoomUI):getString()
--         end

--         local mima = tonumber(str)
--         --如果点击了 确定按钮 并且字符串是空 提示 需要输入密码
--         if str == "" then
--             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要输入密码！")
--             self:onResetNum()
--             return
--         end
--         if mima ~= self.matchInfo.Conds[1]["-1"] then--mima ~= self.matchInfo. [] --如果mima~=后台发过来的密码 
--             -- local onSendJoinTable = Packet.new("onSendJoinTable", _LAIXIA_PACKET_CS_JoinTableID)
--             -- onSendJoinTable:setValue("TableID",   tableID);
--             -- laixia.net.sendPacket(onSendJoinTable)
--             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要输入正确的密码！")
--             self:onResetNum()
--         else --否则密码相等
--             laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

--             local reward = self.matchInfo.RankRds[1].Reward[1]
--             local ItemsdataReward = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",reward.ID);
            
--     --        if ItemsdataReward.PresentItemID1 == 1003 and 2 == laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform   then
--     --          ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TISHIYUWECHAT_WINDOW)
--     --           self:destroy()
--     --           return 
--     --       end
        
--             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW, {["RoomType"]=self.matchInfo.RoomType,["RoomID"] =self.matchInfo.RoomID})
--             cc.UserDefault:getInstance():setDoubleForKey("matdchRoomID",self.matchInfo.RoomID)
            
--             laixiaddz.LocalPlayercfg.LaixiaMatchName = self.matchInfo.RoomName
--             --laixiaddz.LocalPlayercfg.LaixiaMatchName = self:GetWidgetByName("GameDetail_Lebel_Title"):getString()
            
--         end
--     end
-- end

-- --重输数字
-- function GameListDetailWindow:onResetNum(sender,eventType)
--   --if eventType == ccui.TouchEventType.ended then
--         laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--         for i=1,6 do
--             self:GetWidgetByName("Text_JoinRoom_id".. i ,self.JoinRoomUI):setString("")
--         end
--   --end
-- end

-- --删除数字
-- function GameListDetailWindow:onDelNum(sender, eventType)
--     --if eventType == ccui.TouchEventType.ended then
--         laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--         -- local str=self.mJoinRoomID:getString()
--         -- local tableID = tonumber(str)
        
--         -- if tableID == nil then
--         -- else
--         --     local len = #str
--         --     local r_str = string.sub(str,1,len-1)
--         --     if r_str == "" then
--         --        r_str = "请输入桌号"
--         --     end
--         --     self.mJoinRoomID:setString(r_str)
--         -- end
--         for i=6,1,-1 do
--             -- local str = "Text_JoinRoom_id" .. i
--             if self:GetWidgetByName("Text_JoinRoom_id" .. i,self.JoinRoomUI):getString() ~= "" then
--                 self:GetWidgetByName("Text_JoinRoom_id" .. i,self.JoinRoomUI):setString("")
--                 break
--            end
--         end
--    -- end
-- end

-- function GameListDetailWindow:GoBack(sender,eventType)
--     if eventType == ccui.TouchEventType.ended then
--         self.JoinRoomUI:setVisible(false)
--         self.Button_true:setVisible(false)
--         self.Button_back:setVisible(false)
--     end
-- end


function GameListDetailWindow:changePageUI(typeInfo)
    --切换到 1:比赛信息页面2比赛详情页面3比赛奖励页面
    self.pageType = typeInfo
    --改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面改变页面
    if  typeInfo == 1  then
        self.Image_1:setVisible(false)
        self.Image_2:setVisible(false) 
        self.Image_3:setVisible(false) 
        -- self.Image_4:setVisible(false) 
        self.Image_5:setVisible(false)
        self.Image_6:setVisible(false) 
        self.Image_7:setVisible(false)
        self.Text_1:setVisible(false)
        self.Text_2:setVisible(false)
        self.Text_3:setVisible(false) 
        -- self.Text_4:setVisible(false) 
        self.Text_5:setVisible(false) 
        self.Text_6:setVisible(false)
        self.Text_7:setVisible(false) 
        self.Image_b_1:setVisible(false) 
        self.Image_b_2:setVisible(false)
        -- self.Image_b_3:setVisible(false)
        -- self.Image_b_4 :setVisible(false)
        self.Image_b_5:setVisible(false) 
        --//
        -- self.Image_b_6:setVisible(false) 
        -- self.Image_b_7:setVisible(false) 
        -- self.Image_b_8:setVisible(false) 
        --//
        self.Label_kaisaishijian:setVisible(false) 
        self.Text_b_2:setVisible(false)
        self.Text_b_3:setVisible(false) 
        self.Text_b_4:setVisible(false)
        self.Text_b_5:setVisible(false) 
        --//
        self.Text_b_6:setVisible(false) 
        self.Text_b_7:setVisible(false) 
        self.Text_b_8:setVisible(false) 
        --//
        self.Text_b_9:setVisible(false) 
        self.Text_b_10:setVisible(false) 
        -- self.Text_b_11:setVisible(false) 
        -- self.Text_b_12:setVisible(false) 
        -- self.Text_b_13:setVisible(false)

        if self.pageType == 2 then
            --进度条 比赛剩余开始时间隐藏
            self.Image_load_bg1:setVisible(false)
            self.progressBarBG:setVisible(true)
            self.Image_ProgressBar_BG:setVisible(true)
            self.progressBar_front:setVisible(true)
            self.Label_ProgressBar:setVisible(true)
            self.ProgressBar_BaoMing:setVisible(true)
        else
            --进度条 比赛剩余开始时间隐藏
            self.Image_load_bg1:setVisible(false)
            self.progressBarBG:setVisible(false)
            self.Image_ProgressBar_BG:setVisible(false)
            self.progressBar_front:setVisible(false)
            self.Label_ProgressBar:setVisible(false)
            self.ProgressBar_BaoMing:setVisible(false)
        end


        self.Image_33:setVisible(false)
        self.Image_35:setVisible(false)
        self.Image_36:setVisible(false)
        self.Label_maohao_1:setVisible(false)
        self.Label_maohao_2:setVisible(false)
        self.Text_25:setVisible(false)

        self.Label_jinbiaosaishijian1:setVisible(false)
        self.Label_jinbiaosaishijian2:setVisible(false)
        self.Label_jinbiaosaishijian3:setVisible(false)

        --//
        -- self.Button_1_1_:setVisible(false)
        -- self.Button_1_2_:setVisible(false)
        -- self.Button_2_1_:setVisible(false)
        -- self.Button_2_2_:setVisible(false)
        -- self.Button_3_1_:setVisible(false)
        -- self.Button_3_2_:setVisible(false)
        --//


        self.Text_68:setVisible(true)
        self.Text_69:setVisible(true)
        self.Panel_12:setVisible(true)

        
        --self.Panel_jiangli:setVisible(true)
        --self.Panel_MatchDetails:setVisible(false)

        --奖励界面显示
        self.GameDetail_Button_Detail1:setVisible(true)
        self.GameDetail_Button_Detail2:setVisible(false)
        self.Text_76:setVisible(false)
        self.Text_77:setVisible(true)

        self.GameDetail_Button_Jiangli1:setVisible(false)
        self.GameDetail_Button_Jiangli2:setVisible(true)
        self.Text_78:setVisible(true)
        self.Text_79:setVisible(false)

        self.GameDetail_Button_ToBegin:setVisible(false)
        self.GameDetail_Button_Register:setVisible(false)
        self.GameDetail_Button_Quit:setVisible(false)
        self.GameDetail_Button_Begined:setVisible(false)

        self:initReward()

    elseif  typeInfo == 2 then
        self.ListView_1:setVisible(false)

        self.Image_1:setVisible(true)
        self.Image_2:setVisible(true) 
        self.Image_3:setVisible(true) 
        -- self.Image_4:setVisible(true) 
        self.Image_5:setVisible(true)
        self.Image_6:setVisible(true) 
        self.Image_7:setVisible(true)
        self.Text_1:setVisible(true)
        self.Text_2:setVisible(true)
        self.Text_3:setVisible(true) 
        -- self.Text_4:setVisible(true) 
        self.Text_5:setVisible(true) 
        self.Text_6:setVisible(true)
        self.Text_7:setVisible(true) 
        self.Image_b_1:setVisible(true) 
        self.Image_b_2:setVisible(true)
        -- self.Image_b_3:setVisible(true)
        -- self.Image_b_4 :setVisible(true)
        self.Image_b_5:setVisible(true)
        --// 
        -- self.Image_b_6:setVisible(true) 
        -- self.Image_b_7:setVisible(false) 
        -- self.Image_b_8:setVisible(false) 
        --//
        self.Label_kaisaishijian:setVisible(true) 
        self.Text_b_2:setVisible(true)
        self.Text_b_3:setVisible(true) 
        self.Text_b_4:setVisible(true)
        self.Text_b_5:setVisible(true) 
        --//
        self.Text_b_6:setVisible(true) 
        self.Text_b_7:setVisible(false) 
        self.Text_b_8:setVisible(false) 
        --//
        --判断是否是sng
        if self.matchInfo.RoomType == 2 then
            if self.pageType == 2 then
                --进度条 比赛剩余开始时间隐藏
                self.Image_load_bg1:setVisible(false)
                self.progressBarBG:setVisible(true)
                self.Image_ProgressBar_BG:setVisible(true)
                self.progressBar_front:setVisible(true)
                self.Label_ProgressBar:setVisible(true)
                self.ProgressBar_BaoMing:setVisible(true)
            else
                --进度条 比赛剩余开始时间隐藏
                self.Image_load_bg1:setVisible(false)
                self.progressBarBG:setVisible(false)
                self.Image_ProgressBar_BG:setVisible(false)
                self.progressBar_front:setVisible(false)
                self.Label_ProgressBar:setVisible(false)
                self.ProgressBar_BaoMing:setVisible(false)
            end
            -- self.Image_load_bg1:setVisible(false)
            -- self.progressBarBG:setVisible(true)
            -- self.Image_ProgressBar_BG:setVisible(true)
            -- self.progressBar_front:setVisible(true)
            -- self.Label_ProgressBar:setVisible(true)
        else
        --判断是否是mtt
            self.Label_jinbiaosaishijian1:setVisible(true)
            self.Label_jinbiaosaishijian2:setVisible(true)
            self.Label_jinbiaosaishijian3:setVisible(true)

            self.Image_33:setVisible(true)
            self.Image_35:setVisible(true)
            self.Image_36:setVisible(true)
            self.Label_maohao_1:setVisible(true)
            self.Label_maohao_2:setVisible(true)
            self.Text_25:setVisible(true)
        end

        --比赛赛制
        if #self.num1 ==1 then
            self.Text_b_3:setVisible(true)
            self.Text_b_3:setString("" .. self.num1[1])
            self.Text_b_9:setVisible(false)
            self.Text_b_10:setVisible(false)
        elseif #self.num1 == 2 then
            self.Text_b_3:setVisible(true)
            self.Text_b_3:setString("" .. self.num1[1])
            self.Text_b_9:setVisible(true)
            self.Text_b_9:setString("" ..self.num1[2])
            self.Text_b_10:setVisible(false)
        else
            self.Text_b_3:setVisible(true)
            self.Text_b_3:setString("" .. self.num1[3])
            self.Text_b_9:setVisible(true)
            self.Text_b_9:setString("" .. self.num1[2])
            self.Text_b_10:setVisible(true)
            self.Text_b_10:setString("" .. self.num1[3])
        end

        --注意事项
        self.num2 = string.split(self.matchInfo.match_careful,"/r")
        if #self.num2 ==1 then
            -- self.Text_b_11:setVisible(true)
            -- self.Text_b_11:setString("" .. self.num2[1])
            -- self.Text_b_12:setVisible(false)
            -- self.Text_b_13:setVisible(false)
        elseif #self.num2 == 2 then
            -- self.Text_b_11:setVisible(true)
            -- self.Text_b_11:setString("" .. self.num2[1])
            -- self.Text_b_12:setVisible(true)
            -- self.Text_b_12:setString("" .. self.num2[2])
            -- self.Text_b_13:setVisible(false)
        else
            -- self.Text_b_11:setVisible(true)
            -- self.Text_b_11:setString("" .. self.num2[1])
            -- self.Text_b_12:setVisible(true)
            -- self.Text_b_12:setString("" .. self.num2[2])
            -- self.Text_b_13:setVisible(true)
            -- self.Text_b_13:setString("" .. self.num2[3])
        end
        --//
        -- self.num3 = string.split(self.matchInfo.Baomingfei,"/r/n")
    local str = ""
    if self.matchInfo.Baomingfei and type(self.matchInfo.Baomingfei) == "table" then
        for i=1,#self.matchInfo.Baomingfei do
            local Itemsdata = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[i].payment_info[1].id));
            if i == 1 then
                if tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) == 0 then
                    str = "免费"
                else
                    str = Itemsdata.ItemName.."X"..self.matchInfo.Baomingfei[i].payment_info[1].num
                    str = str:gsub("金币",laixiaddz.utilscfg.CoinType());
                end
                self.Text_b_6:setString(str)
                self.Text_b_6:setVisible(true)
                self.Text_b_7:setVisible(false)
                self.Text_b_8:setVisible(false)
            elseif i == 2 then 
                local Itemsdata2 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[i].payment_info[1].id));
                str = Itemsdata2.ItemName.."X"..self.matchInfo.Baomingfei[2].payment_info[1].num
                str = str:gsub("金币",laixiaddz.utilscfg.CoinType());
                self.Text_b_7:setVisible(true)
                self.Text_b_7:setString(str)
                self.Text_b_8:setVisible(false)
                if tonumber(self.matchInfo.Baomingfei[2].payment_info[1].num) == 0 then
                    self.Text_b_7:setVisible(false)
                end
            elseif i == 3 then 
                local Itemsdata1 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[i].payment_info[1].id));
                str = Itemsdata1.ItemName.."X"..self.matchInfo.Baomingfei[i].payment_info[1].num
                str = str:gsub("金币",laixiaddz.utilscfg.CoinType());
                self.Text_b_8:setString(str)
                self.Text_b_8:setVisible(true)
            end
        end
        if #self.matchInfo.Baomingfei == 0 then
            str = "免费" 
            self.Text_b_6:setString(str)
            self.Text_b_6:setVisible(true)
            self.Text_b_7:setVisible(false)
            self.Text_b_8:setVisible(false)
        end
       
    end
    --//


        self.Text_68:setVisible(false)
        self.Text_69:setVisible(false)
        self.Panel_12:setVisible(false)
--        self.Panel_info:setVisible(false)
       -- self.Panel_jiangli:setVisible(false)
        --self.Panel_MatchDetails:setVisible(true)

        self.GameDetail_Button_Detail1:setVisible(false)
        self.GameDetail_Button_Detail2:setVisible(true)
        self.Text_76:setVisible(true)
        self.Text_77:setVisible(false)

        self.GameDetail_Button_Jiangli1:setVisible(true)
        self.GameDetail_Button_Jiangli2:setVisible(false)
        self.Text_78:setVisible(false)
        self.Text_79:setVisible(true)

        self:updateButton()


        -- self.GameDetail_Button_Back:setVisible(true)

--        self.GameDetail_Button_Back:setPosition(self.Image_Button_LeftPoint:getPosition())
--        self.showButton:setPosition(self.Image_Button_RightPoint:getPosition())

    elseif typeInfo == 3 then

--        self.Panel_info:setVisible(false)
        --self.Panel_jiangli:setVisible(true)
        --self.Panel_MatchDetails:setVisible(false)

--        self:GetWidgetByName("GameDetail_Image_DetailBorder"):setVisible(false)
--        self:GetWidgetByName("GameDetail_Image_GiftBorder"):setVisible(true)
        
        -- self.GameDetail_Button_Back:setVisible(true)
--        self.GameDetail_Button_Back:setPosition(self.Image_Button_LeftPoint:getPosition())
--        self.showButton:setPosition(self.Image_Button_RightPoint:getPosition())
    end
end
--奖励方案
function GameListDetailWindow:IncentiveScheme(sender, eventtype)
    if self.mIsShow then
        if eventtype == ccui.TouchEventType.ended then
            laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            self:changePageUI(1)
        end
    end
end
--比赛详情
function GameListDetailWindow:MatchDetails(sender, eventtype)
    if self.mIsShow then
        if eventtype == ccui.TouchEventType.ended then
            laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            self:changePageUI(2)
        end
    end
end
--返回按钮
function GameListDetailWindow:Back(sender, eventtype)
    if self.mIsShow then
        if eventtype == ccui.TouchEventType.ended then
            laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            self:changePageUI(1)
        end
    end
end

--退赛
function GameListDetailWindow:quitRegistration(sender, eventtype)
    -- 退出报名回调函数
    if self.mIsLoad == false then
        return
    end
    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:quitRegistrationFun()
    end
end

--退报名
function GameListDetailWindow:quitRegistrationFun()
    local stream = Packet.new("match_out", "LXG_MATCH_CANCEL_ENROLL")
    stream:setReqType("post")
    stream:setValue("match_id", self.matchInfo.RoomID)
    stream:setValue("match_enroll_id",self.matchInfo.MatchId)
    stream:setPostData("uid", laixiaddz.LocalPlayercfg.LaixiaPlayerID)
    laixiaddz.LocalPlayercfg.LaixiaMatchRoom = self.matchInfo.RoomID
    laixiaddz.LocalPlayercfg.LaixiaMatchInsId = self.matchInfo.MatchId
    local function cb(data)
        if data.dm_error == 0 then
            ObjectEventDispatch:pushEvent("ddz_scene_update_coin")
            local match = laixiaddz.LocalPlayercfg.LaixiaMatchdata
            if #match == 0 then return end
            local red_temp = match[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms
            for i = 1, #red_temp do
                if (laixiaddz.LocalPlayercfg.LaixiaMatchRoom == red_temp[i].RoomID) then
                    laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum = laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum - 1
                    laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].Sate = 1
                    laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].SelfJoin = 0
                end
            end
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)
        else
            dump(data)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,data.error_msg)
        end
    end
    laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow ~= "GameListWindow"  then -- 如果当前界面不是比赛列表则请求比赛列表
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
    end
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "LobbyWindow" then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)      -- 请求个人详情
    end
end


-- 报名比赛
function GameListDetailWindow:sendRegistration(msg)
    -- if not laixiaddz.LocalPlayercfg.LaixiaJoinGame then
    --     -- 读取上一次报名信息
    --     laixiaddz.LocalPlayercfg.LaixiaJoinGame = cc.UserDefault:getInstance():getDoubleForKey("addGameItemId")
    --     if laixiaddz.LocalPlayercfg.LaixiaJoinGame then
    --         if tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) == 1001 and tonumber(laixiaddz.LocalPlayercfg.LaixiaJoinGame) == 1001 then
    --             if laixiaddz.LocalPlayercfg.LaixiaGoldCoin < tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) then
    --                 -- 金币不足
    --                 ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_RELIEFINFO_WINDOW)
    --                 return
    --             end
    --         elseif tonumber(self.matchInfo.Baomingfei[1].payment_info[2].id) == 1002 and tonumber(laixiaddz.LocalPlayercfg.LaixiaJoinGame) == 1002 then
    --             if laixiaddz.LocalPlayercfg.LaixiaLdCoin < tonumber(self.matchInfo.Baomingfei[1].payment_info[2].num) then
    --                 -- 来豆不足
    --                 -- return
    --             end
    --         end
    --     end
    --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"道具不足!")
    --     return
    -- end
    -- cc.UserDefault:getInstance():setDoubleForKey("addGameItemId",laixiaddz.LocalPlayercfg.LaixiaJoinGame)
    if msg.data then
        laixiaddz.LocalPlayercfg.LaixiaBmroomType = msg.data.RoomType
        laixiaddz.LocalPlayercfg.LaixiaBmroomId = msg.data.RoomID 
        local stream = Packet.new("CSMatchRegister", "LXG_MATCH_ENROLL")
        stream:setReqType("post")
        stream:setValue("match_id", msg.data.RoomID)
        stream:setValue("match_enroll_id", msg.data.MatchId)
        local baomingfei = "fee1"
        if laixiaddz.LocalPlayercfg.LaixiaJoinGame and tonumber(laixiaddz.LocalPlayercfg.LaixiaJoinGame) == 1002 then
            baomingfei = "fee2"
        end
        -- cc.UserDefault:getInstance():setDoubleForKey("addGamePaymentMethod",baomingfei)
        stream:setValue("payment_method", baomingfei)
        laixiaddz.LocalPlayercfg.LaixiaMatchRoom = msg.data.RoomID
        laixiaddz.LocalPlayercfg.LaixiaPaymentMethod = baomingfei
        laixiaddz.LocalPlayercfg.LaixiaMatchInsId =  msg.data.MatchId
        stream:setPostData("uid", laixiaddz.LocalPlayercfg.LaixiaPlayerID)

        dump(stream,"stream---GameListDetailWindow")
        local function cb(data)
            if data.dm_error == 0 then
                -- 更新当前进度
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_PROGRESSBARMATCH_WINDOW,
                    {
                        CurJoin = (self.CurJoin or 0) + 1,
                    } 
                )
                ObjectEventDispatch:pushEvent("ddz_scene_update_coin")
                local match = laixiaddz.LocalPlayercfg.LaixiaMatchdata
                if #match == 0 then return end
                local red_temp = match[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms
                for i = 1, #red_temp do
                    if (laixiaddz.LocalPlayercfg.LaixiaMatchRoom == red_temp[i].RoomID) then
                        laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum = laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum + 1
                        laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].Sate = 2
                        laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].SelfJoin = 1
                    end
                end
                self:ShutDownSign(nil, ccui.TouchEventType.ended)
                if self.matchInfo.RoomType == 2 then
                    if self:GetWidgetByName("GameDetail_Button_ShutDown") then 
                        self:GetWidgetByName("GameDetail_Button_ShutDown"):setVisible(false)
                    end
                end
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW)
            else
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,data.error_msg)
            end
        end
        laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
    end
end

-- 更新报名人数
function GameListDetailWindow:updateLineNum()
    if self.matchInfo.RoomType == 2 then -- sng
        local stream = Packet.new("UPDATE_LINE_NUM", "LXG_MATCH_USER_NUM")
        stream:setReqType("get")
        stream:setValue("match_id", self.matchInfo.RoomID)
        stream:setValue("match_enroll_id", self.matchInfo.MatchId)
        local function cb(data)
            if data.dm_error == 0 then
                -- 更新当前进度
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_PROGRESSBARMATCH_WINDOW,
                    {
                        CurJoin = data.data.wait_num,
                    } 
                )
            else
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,data.error_msg)
            end
        end
        laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
    end
end

--即将开始
function GameListDetailWindow:toBegin(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        --tips
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "报名时间："..self:GetWidgetByName("Label_baomingtiaojian_value"):getString())
    end
end

--比赛已经开始
function GameListDetailWindow:Begined(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "比赛已经开始")
    end
end

-- 显示消耗
function GameListDetailWindow:matchCoinInfo()
    self.Button_1_2_ = self:GetWidgetByName("Button_1_2")
    self.Button_2_2_ = self:GetWidgetByName("Button_2_2")
    self.Button_3_2_ = self:GetWidgetByName("Button_3_2")
    if self.matchInfo.Baomingfei then
        if type(self.matchInfo.Baomingfei) == "table" 
        and #self.matchInfo.Baomingfei == 1 
        and tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num == 0) then
            self.Button_1_2_:setVisible(true)
            return
        end
        if self.matchInfo.Baomingfei[1] then
            local info = self.matchInfo.Baomingfei[1]
            local num = 0
            if tonumber(info.payment_info[1].id) == 1001  then
                num = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
            elseif tonumber(info.payment_info[1].id) == 1002 then
                num = laixiaddz.LocalPlayercfg.LaixiaLdCoin
            elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                    if value.ItemID == info.payment_info[1].id then
                        num = value.ItemCount
                    end
                end
            end
            if tonumber(num) >= tonumber(info.payment_info[1].num) then
                self.Button_1_2_:setVisible(true)
            end
        end
        if self.matchInfo.Baomingfei[2] then
            local info = self.matchInfo.Baomingfei[2]
            local num = 0
            if tonumber(info.payment_info[1].id) == 1001  then
                num = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
            elseif tonumber(info.payment_info[1].id) == 1002 then
                num = laixiaddz.LocalPlayercfg.LaixiaLdCoin
            elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                    if value.ItemID == info.payment_info[1].id then
                        num = value.ItemCount
                    end
                end
            end
            if tonumber(num) >= tonumber(info.payment_info[1].num) then
                self.Button_3_2_:setVisible(true)
            end
        end
        -- TODO self.Button_3_2_
    end
end

--报名
--红包塞得时候提示是否是手机登陆
function GameListDetailWindow:registration(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        --父节点
        self.Image_bg_1 = self:GetWidgetByName("Image_bg_1", self.Panel_baoming)
        self.Image_bg_2 = self:GetWidgetByName("Image_bg_2", self.Panel_baoming)
        self.Image_bg_3 = self:GetWidgetByName("Image_bg_3", self.Panel_baoming)
        self.Image_bg_1:setVisible(false)
        self.Image_bg_2:setVisible(false)
        self.Image_bg_3:setVisible(false)

        --icon
        self.Image_icon_1 = self:GetWidgetByName("Image_icon", self.Image_bg_1)
        self.Image_icon_2 = self:GetWidgetByName("Image_icon", self.Image_bg_2)
        self.Image_icon_3 = self:GetWidgetByName("Image_icon", self.Image_bg_3)

        --label
        self._Text_b_6 = self:GetWidgetByName("Text_b_6", self.Image_bg_1)
        self._Text_b_7 = self:GetWidgetByName("Text_b_7", self.Image_bg_2)
        self._Text_b_8 = self:GetWidgetByName("Text_b_8", self.Image_bg_3)

        --按钮
        self.Button_1_1 = self:GetWidgetByName("Button_1_1", self.Image_bg_1)
        self.Button_1_2 = self:GetWidgetByName("Button_1_2", self.Image_bg_1)
        self.Button_2_1 = self:GetWidgetByName("Button_2_1", self.Image_bg_2)
        self.Button_2_2 = self:GetWidgetByName("Button_2_2", self.Image_bg_2)
        self.Button_3_1 = self:GetWidgetByName("Button_3_1", self.Image_bg_3)
        self.Button_3_2 = self:GetWidgetByName("Button_3_2", self.Image_bg_3)

        self.Button_quxiao = self:GetWidgetByName("Button_quxiao",self.Panel_baoming)
        self.Button_baoming = self:GetWidgetByName("Button_baoming",self.Panel_baoming)
        self:AddWidgetEventListenerFunction("Button_quxiao",handler(self, self.ShutDownSign))
        self:AddWidgetEventListenerFunction("Button_baoming",handler(self, self.registrationtosend)) --报名方式 报名按钮
        self:AddWidgetEventListenerFunction("Button_1_1", handler(self, self.buttonCallBack1_1_),self.Image_bg_1) 
        --self:AddWidgetEventListenerFunction("Button_1_2", handler(self, self.buttonCallBack1_2_),self.Image_bg_1)
        self:AddWidgetEventListenerFunction("Button_2_1", handler(self, self.buttonCallBack2_1_),self.Image_bg_2)
        --self:AddWidgetEventListenerFunction("Button_2_2", handler(self, self.ButtonCallback2_2))
        self:AddWidgetEventListenerFunction("Button_3_1", handler(self, self.buttonCallBack3_1_),self.Image_bg_3) 
        --self:AddWidgetEventListenerFunction("Button_3_2", handler(self, self.ButtonCallback3_2))

        local str1 = ""
        local str2 = ""
        local str3 = ""
        self.Number_1 = nil 
        self.Number_2 = nil
        self.Number_3 = nil
        --laixiaddz.LocalPlayercfg.LaixiaPlayerGold = 10
        if #self.matchInfo.Baomingfei == 1 then
            local Itemsdata = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id));
            if self.matchInfo.Baomingfei[1].payment_info[1].num == 0 then
                str1 = "免费"
                self.indexCost = 0
                laixiaddz.LocalPlayercfg.LaixiaJoinGame = 0
                self._Text_b_6:setString(str1)
                --从plist中拆出来的金币
                self.Image_icon_1:loadTexture("new_ui/everydaylogin/day2.png")
                self.Image_icon_1:setScale(0.5)
                self.Image_icon_1:setVisible(true)
                self.Button_1_1:setVisible(false)
                self.Button_1_2:setVisible(true)
                self.Image_bg_1:setVisible(true)
                self.Image_bg_2:setVisible(false)
                self.Image_bg_3:setVisible(false)
            else
                self.indexCost = self.matchInfo.Baomingfei[1].payment_info[1].id
                local baoming_Array1 = string.split(Itemsdata.ImagePath ,'/')
                if #baoming_Array1 > 1 then
                    self.Image_icon_1:loadTexture(Itemsdata.ImagePath)
                    self.Image_icon_1:setScale(0.5)
                else
                    self.Image_icon_1:loadTexture(Itemsdata.ImagePath, 1)
                    self.Image_icon_1:setScale(0.5)            
                end 
                str1 = Itemsdata.ItemName.."    X"..self.matchInfo.Baomingfei[1].payment_info[1].num
                --str1 = str1:gsub(Itemsdata.ItemName,laixia.utilscfg.CoinType());
                
                if tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) == 1001  then
                    self.Number_1 = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
                elseif tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) == 1002 then
                    self.Number_1 = laixiaddz.LocalPlayercfg.LaixiaLdCoin
                elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                    self.Number_1 = 0
                    for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                        if value.ItemID == tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) then --这里以后要改为判断任务红包类型
                            self.Number_1 = value.ItemCount
                        end
                    end
                end
                --如果需要的x物品数量>自己拥有的x物品的数量
                if tonumber(self.Number_1) >= tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) and tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) ~= 0 then
                    self._Text_b_6:setString(str1)
                    self.Button_1_1:setVisible(false)
                    self.Button_1_2:setVisible(true)
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                    self.baomingfei = self.matchInfo.Baomingfei[1].payment_method
                else
                    self._Text_b_6:setString(str1)
                    self.Image_icon_1:setVisible(true)
                    --self._Text_b_6:setString(Itemsdata.ItemName .. "不足")
                    self._Text_b_6:setColor(cc.c3b(159,167,188))
                    self.Button_1_1:setVisible(false)
                    self.Button_1_2:setVisible(false)
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = nil
                end
                self._Text_b_6:setVisible(true)
                self.Image_bg_1:setVisible(true)
                self.Image_bg_2:setVisible(false)
                self.Image_bg_3:setVisible(false)
            end
        elseif #self.matchInfo.Baomingfei == 2 then
            local Itemsdata1 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id));
            local Itemsdata2 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id));
            str1 = Itemsdata1.ItemName.."    X"..self.matchInfo.Baomingfei[1].payment_info[1].num
            str2 = Itemsdata2.ItemName.."    X"..self.matchInfo.Baomingfei[2].payment_info[1].num
            local baoming_Array1 = string.split(Itemsdata1.ImagePath ,'/')
            local baoming_Array2 = string.split(Itemsdata2.ImagePath ,'/')
            if #baoming_Array1 > 1 then
                self.Image_icon_1:loadTexture(Itemsdata1.ImagePath)
                self.Image_icon_1:setScale(0.5)
            else
                self.Image_icon_1:loadTexture(Itemsdata1.ImagePath, 1)
                self.Image_icon_1:setScale(0.5)            
            end 
            if #baoming_Array2 > 1 then
                self.Image_icon_2:loadTexture(Itemsdata2.ImagePath)
                self.Image_icon_2:setScale(0.5)
            else
                self.Image_icon_2:loadTexture(Itemsdata2.ImagePath, 1)
                self.Image_icon_2:setScale(0.5)            
            end 
            if tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) == 1001  then
                self.Number_1 = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
            elseif tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) == 1002 then
                self.Number_1 = laixiaddz.LocalPlayercfg.LaixiaLdCoin
            elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                self.Number_1 = 0
                for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                    if value.ItemID == self.matchInfo.Baomingfei[1].payment_info[1].id then --这里以后要改为判断任务红包类型
                        self.Number_1 = value.ItemCount
                    end
                end
            end

            if tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id) == 1001  then
                self.Number_2 = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
            elseif tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id) == 1002 then
                self.Number_2 = laixiaddz.LocalPlayercfg.LaixiaLdCoin
            elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                self.Number_2 = 0
                for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                    if value.ItemID == tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id) then --这里以后要改为判断任务红包类型
                        self.Number_2 = value.ItemCount
                    end
                end
            end

            --如果需要的x物品数量>自己拥有的x物品的数量
            --这里需要将每个物品拆开了各自判断
            -- print("self.Number_1self.Number_1 = ",self.Number_1)
            -- print("self.Number_1self.Number_2 = ",self.matchInfo.Baomingfei[1].payment_info[1].num)
            -- print("self.Number_1self.Number_3 = ",tonumber(self.Number_1) >= tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num))
            if tonumber(self.Number_1) >= tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) and tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) ~=0 then
                self._Text_b_6:setString(str1)
                self._Text_b_6:setVisible(true)
                self.Image_icon_1:setVisible(true)
                self.Button_1_1:setVisible(false)
                self.Button_1_2:setVisible(true)
                laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                self.baomingfei = self.matchInfo.Baomingfei[1].payment_method
            else
                --self.Text_b_6:setString(Itemsdata1.ItemName .. "不足")
                self._Text_b_6:setString(str1)
                self._Text_b_6:setColor(cc.c3b(159,167,188))
                self._Text_b_6:setVisible(true)
                self.Image_icon_1:setVisible(true)
                self.Button_1_1:setVisible(false)
                self.Button_1_2:setVisible(false)
                laixiaddz.LocalPlayercfg.LaixiaJoinGame = nil
            end 

            -- print("self.Number_1self.Number_1 = ",self.Number_2)
            if tonumber(self.Number_2) >= tonumber(self.matchInfo.Baomingfei[2].payment_info[1].num) and tonumber(self.matchInfo.Baomingfei[2].payment_info[1].num) ~= 0 then
                self._Text_b_7:setString(str2)
                self._Text_b_7:setVisible(true)
                self.Image_icon_2:setVisible(true)
                if tonumber(self.Number_1) >= tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) and tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) ~= 0 then
                    self.Button_2_1:setVisible(true)
                    self.Button_2_2:setVisible(false)
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                    self.baomingfei = self.matchInfo.Baomingfei[1].payment_method
                else
                    self.Button_2_1:setVisible(false)
                    self.Button_2_2:setVisible(true)
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[2].payment_info[1].id
                    self.baomingfei = self.matchInfo.Baomingfei[2].payment_method
                end
            else
                if tonumber(self.Number_1) >= tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) and tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) ~= 0 then
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                    self.baomingfei = self.matchInfo.Baomingfei[1].payment_method
                else
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = nil
                end
                self._Text_b_7:setString(str2)
                self._Text_b_7:setColor(cc.c3b(159,167,188))
                self._Text_b_7:setVisible(true)
                self.Image_icon_2:setVisible(true)
                self.Button_2_1:setVisible(false)
                self.Button_2_2:setVisible(false)
            end
            self.Image_bg_1:setVisible(true)
            self.Image_bg_2:setVisible(true)
            self.Image_bg_3:setVisible(false)
        elseif #self.matchInfo.Baomingfei == 3 then
            local Itemsdata1 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id));
            local Itemsdata2 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id));
            local Itemsdata3 = itemDBM:query("ItemID",tonumber(self.matchInfo.Baomingfei[3].payment_info[1].id));
            str1 = Itemsdata1.ItemName.."    X"..self.matchInfo.Baomingfei[1].payment_info[1].num
            str2 = Itemsdata2.ItemName.."    X"..self.matchInfo.Baomingfei[2].payment_info[1].num
            str3 = Itemsdata3.ItemName.."    X"..self.matchInfo.Baomingfei[3].payment_info[1].num
            local baoming_Array1 = string.split(Itemsdata1.ImagePath ,'/')
            local baoming_Array2 = string.split(Itemsdata2.ImagePath ,'/')
            local baoming_Array3 = string.split(Itemsdata3.ImagePath ,'/')
            if #baoming_Array1 > 1 then
                self.Image_icon_1:loadTexture(Itemsdata1.ImagePath)
                self.Image_icon_1:setScale(0.5)
            else
                self.Image_icon_1:loadTexture(Itemsdata1.ImagePath, 1)
                self.Image_icon_1:setScale(0.5)            
            end 
            if #baoming_Array2 > 1 then
                self.Image_icon_2:loadTexture(Itemsdata2.ImagePath)
                self.Image_icon_2:setScale(0.5)
            else
                self.Image_icon_2:loadTexture(Itemsdata2.ImagePath, 1)
                self.Image_icon_2:setScale(0.5)            
            end 
            if #baoming_Array3 > 1 then
                self.Image_icon_3:loadTexture(Itemsdata3.ImagePath)
                self.Image_icon_3:setScale(0.5)
            else
                self.Image_icon_3:loadTexture(Itemsdata3.ImagePath, 1)
                self.Image_icon_3:setScale(0.5)            
            end 
            if tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) == 1001  then
                self.Number_1 = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
            elseif tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) == 1002 then
                self.Number_1 = laixiaddz.LocalPlayercfg.LaixiaLdCoin
            elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                self.Number_1 = 0
                for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                    if value.ItemID == tonumber(self.matchInfo.Baomingfei[1].payment_info[1].id) then --这里以后要改为判断任务红包类型
                        self.Number_1 = value.ItemCount
                    end
                end
            end

            if tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id) == 1001  then
                self.Number_2 = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
            elseif tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id) == 1002 then
                self.Number_2 = laixiaddz.LocalPlayercfg.LaixiaLdCoin
            elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                self.Number_1 = 0
                for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                    if value.ItemID == tonumber(self.matchInfo.Baomingfei[2].payment_info[1].id) then --这里以后要改为判断任务红包类型
                        self.Number_2 = value.ItemCount
                    end
                end
            end

            if tonumber(self.matchInfo.Baomingfei[3].payment_info[1].id) == 1001  then
                self.Number_3 = laixiaddz.LocalPlayercfg.LaixiaGoldCoin
            elseif tonumber(self.matchInfo.Baomingfei[3].payment_info[1].id) == 1002 then
                self.Number_3 = laixiaddz.LocalPlayercfg.LaixiaLdCoin
            elseif laixiaddz.LocalPlayercfg.LaixiaPropsData ~= nil then
                self.Number_1 = 0
                for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
                    if value.ItemID == tonumber(self.matchInfo.Baomingfei[3].payment_info[1].id) then --这里以后要改为判断任务红包类型
                        self.Number_3 = value.ItemCount
                    end
                end
            end
            if tonumber(self.Number_1) >= tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) then 
                self._Text_b_6:setString(str1)
                self.Button_1_1:setVisible(false)
                self.Button_1_2:setVisible(true)
                laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
            else
                self._Text_b_6:setString(str1)
                self._Text_b_6:setColor(cc.c3b(159,167,188))
                self.Button_1_1:setVisible(false)
                self.Button_1_2:setVisible(false)
                laixiaddz.LocalPlayercfg.LaixiaJoinGame = nil
            end 
            self._Text_b_6:setVisible(true)
            self.Image_icon_1:setVisible(true)

            if tonumber(self.Number_2) >= tonumber(self.matchInfo.Baomingfei[2].payment_info[1].num) then
                self._Text_b_7:setString(str2)
                if tonumber(self.Number_1) < tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) then
                    self.Button_2_1:setVisible(false)
                    self.Button_2_2:setVisible(true)
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[2].payment_info[1].id
                else
                    self.Button_2_1:setVisible(true)
                    self.Button_2_2:setVisible(false)
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                end
            else
                self._Text_b_7:setString(str2)
                if tonumber(self.Number_1) >= tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) then
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                else
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = nil
                end
                self._Text_b_7:setColor(cc.c3b(159,167,188))
                self.Button_2_1:setVisible(false)
                self.Button_2_2:setVisible(false)
                --sign2 = false
            end
            self._Text_b_7:setVisible(true)
            self.Image_icon_2:setVisible(true)
            if tonumber(self.Number_3) >= tonumber(self.matchInfo.Baomingfei[3].payment_info[1].num) then
                self._Text_b_8:setString(str3)
                if tonumber(self.Number_1) < tonumber(self.matchInfo.Baomingfei[1].payment_info[1].num) and tonumber(self.Number_2) < tonumber(self.matchInfo.Baomingfei[2].payment_info[1].num) then
                    self.Button_3_1:setVisible(false)
                    self.Button_3_2:setVisible(true)
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[3].payment_info[1].id
                else
                    if tonumber(self.Number_1) >= self.matchInfo.Baomingfei[1].payment_info[1].num then
                        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                    elseif tonumber(self.Number_2) >= self.matchInfo.Baomingfei[2].payment_info[1].num then
                        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[2].payment_info[1].id
                    else
                        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[3].payment_info[1].id
                    end
                    self.Button_3_1:setVisible(true)
                    self.Button_3_2:setVisible(false)
                end
            else
                self._Text_b_8:setString(str3)
                if  tonumber(self.Number_1) >= self.matchInfo.Baomingfei[1].payment_info[1].num then
                        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
                elseif tonumber(self.Number_2) >= self.matchInfo.Baomingfei[2].payment_info[1].num then
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[2].payment_info[1].id
                else
                    laixiaddz.LocalPlayercfg.LaixiaJoinGame = nil
                end
                self._Text_b_8:setColor(cc.c3b(159,167,188))
                self.Button_3_1:setVisible(false)
                self.Button_3_2:setVisible(false)
            end
            self._Text_b_8:setVisible(true)
            self.Image_icon_1:setVisible(true)
            self.Image_bg_1:setVisible(true)
            self.Image_bg_2:setVisible(true)
            self.Image_bg_3:setVisible(true)
        else
            str1 = "免费" 
            self.indexCost = 0
            laixiaddz.LocalPlayercfg.LaixiaJoinGame = 0
            self._Text_b_6:setString(str1)
            self.Image_icon_1:loadTexture("new_ui/everydaylogin/day2.png")
            self.Image_icon_1:setScale(0.5)
            self.Image_icon_1:setVisible(true)
            self.Button_1_1:setVisible(false)
            self.Button_1_2:setVisible(true)
            self.Image_bg_1:setVisible(true)
            self.Image_bg_2:setVisible(false)
            self.Image_bg_3:setVisible(false)
        end
        --点击报名的时候将panel最后显示
        self.Panel_baoming:setVisible(true)
    end
end

function GameListDetailWindow:buttonCallBack1_1_(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Button_1_1:setVisible(false)
        self.Button_1_2:setVisible(true)
        if laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[2].payment_info[1].id then
            self.Button_2_1:setVisible(true)
            self.Button_2_2:setVisible(false)
        elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[3].payment_info[1].id then
            self.Button_3_1:setVisible(true)
            self.Button_3_2:setVisible(false)
        end
        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
        self.baomingfei = self.matchInfo.Baomingfei[1].payment_method
    end
end

function GameListDetailWindow:buttonCallBack2_1_(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Button_2_1:setVisible(false)
        self.Button_2_2:setVisible(true)
        if laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[1].payment_info[1].id then
            self.Button_1_1:setVisible(true)
            self.Button_1_2:setVisible(false)
        elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[3].payment_info[1].id then
            self.Button_3_1:setVisible(true)
            self.Button_3_2:setVisible(false)
        end
        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[2].payment_info[1].id
        self.baomingfei = self.matchInfo.Baomingfei[2].payment_method
    end
end
function GameListDetailWindow:buttonCallBack3_1_(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Button_3_1:setVisible(false)
        self.Button_3_2:setVisible(true)
        if laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[1].payment_info[1].id then
            self.Button_1_2:setVisible(false)
            self.Button_1_1:setVisible(true)
        elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == self.matchInfo.Baomingfei[2].payment_info[1].id then
            self.Button_2_1:setVisible(true)
            self.Button_2_2:setVisible(false)
        end
        laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[3].payment_info[1].id
    end
end


function GameListDetailWindow:ShutDownSign(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Panel_baoming:setVisible(false)
    end
end


-- 报名方式界面 点击报名
function GameListDetailWindow:registrationtosend(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
            self.Panel_baoming:setVisible(false)
            laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW, 
                {
                    ["RoomType"]=self.matchInfo.RoomType,
                    ["RoomID"] =self.matchInfo.RoomID,
                    ["PaymentMethod"] =self.matchInfo.Baomingfei[1].payment_method,
                    ["MatchId"] =self.matchInfo.MatchId,
                })
            cc.UserDefault:getInstance():setDoubleForKey("matdchRoomID",self.matchInfo.RoomID)


            -- if laixiaddz.LocalPlayercfg.LaixiaJoinGame == 0 then

            -- elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == 1 then
            --     if self.Number_1 < self.matchInfo.Baomingfei[1].payment_info[1].num then
            --         local Itemsdata1 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[1].payment_info[1].id)
            --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,Itemsdata1.ItemName .. "不足")
            --     end
            -- elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == 2 then
            --     if self.Number_2 < self.matchInfo.Baomingfei[1].payment_info[1].num then
            --          local Itemsdata2 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[2].payment_info[1].id)
            --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,Itemsdata2.ItemName .. "不足")
            --     end
            -- elseif laixiaddz.LocalPlayercfg.LaixiaJoinGame == 1 then
            --     if self.Number_3 < self.matchInfo.Baomingfei[1].payment_info[1].num then
            --         local Itemsdata3 = itemDBM:query("ItemID",self.matchInfo.Baomingfei[3].payment_info[1].id)
            --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,Itemsdata3.ItemName .. "不足")
            --     end
            -- end
        --     if laixiaddz.LocalPlayercfg.LaixiaJoinGame == nil then
        --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"报名所需道具不足")
        --     else
             
        --         for key, var in pairs(self.matchInfo.Conds) do
        --             if var.ID == -1 then
        --                self.Panel_27:setVisible(true)
        --                self.GameDetail_Button_Register:setTouchEnabled(false)
        --                return
        --             end
        --         end
        -- --        if self.matchInfo.Conds[1].payment_info[1].id ~= -1 then
        --             local reward = self.matchInfo.RankRds[1].Reward[1]
        --             local ItemsdataReward = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",reward.ID);
                    
        --     --        if ItemsdataReward.PresentItemID1 == 1003 and 2 == laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform   then
        --     --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TISHIYUWECHAT_WINDOW)
        --     --           self:destroy()
        --     --           return 
        --     --      end
                
        --             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW, {["RoomType"]=self.matchInfo.RoomType,["RoomID"] =self.matchInfo.RoomID})
        --             cc.UserDefault:getInstance():setDoubleForKey("matdchRoomID",self.matchInfo.RoomID)
                    
        --             laixiaddz.LocalPlayercfg.LaixiaMatchName = self.matchInfo.RoomName
        --             --laixiaddz.LocalPlayercfg.LaixiaMatchName = self:GetWidgetByName("GameDetail_Lebel_Title"):getString()
        -- --        else
        -- --            --点击报名的时候弹出密码输入框
        -- --            -- self.JoinRoomUI:setVisible(true)
        -- --            -- self.Button_true:setVisible(true)
        -- --            -- self.Button_back:setVisible(true)
        -- --
        -- --            --输入框
        -- --            self.Panel_27:setVisible(true)
        -- --
        -- --        end
        -- end
    end
end

--关闭
function GameListDetailWindow:shutdown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- laixiaddz.LocalPlayercfg.LaixiaJoinGame = self.matchInfo.Baomingfei[1].payment_info[1].id
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)
    end
end

function GameListDetailWindow:onCallBackFunction()
    if self:GetWidgetByName("GameDetail_Button_ShutDown"):isVisible() then
        self:destroy()
    end
end

function GameListDetailWindow:updateSignUp(msg)
    if self.mIsShow == true then
        self.matchInfo.SelfJoin = 1
        if msg.data.RoomType==1 then
            self.matchInfo.JoinMaxLimit = msg.data.Limit
            self.matchInfo.CurNum = msg.data.Value
        elseif msg.data.RoomType==2 then
            self.CountDown = msg.data.Value
        end
        self:init_LiftUI()
        self:init_RightUI()
        self:updateButton()

    end
end

function GameListDetailWindow:updateQuit()
    if self.mIsLoad == true then
        self.matchInfo.SelfJoin = 0
        self:init_LiftUI()
        self:init_RightUI()
        self:updateButton()
    end
end

function GameListDetailWindow:schedulerTick()
    if self.mIsShow == false then
        return
    end
    if self.matchInfo.RoomType == 1 then
        -- 更新距离定时比赛剩余时间
        local day = os.time()
        local time = self.matchInfo.BeginTime
        local sH
        local sM
        local sS
        if time > day then
            local minute = tonumber(os.date("%M",time-day))
            local second = tonumber(os.date("%S",time-day))
            sH = string.format("%.2d",((time-day)/(60*60)))
            sM = string.format("%.2d",(minute))
            sS = string.format("%.2d",(second))
        else
            sH = "00"
            sM = "00"
            sS = "00"
        end
        self.Label_jinbiaosaishijian1:setString(sH)
        self.Label_jinbiaosaishijian2:setString(sM)
        self.Label_jinbiaosaishijian3:setString(sS)
    else
        self.GameDetail_Button_Quit:setVisible(false)
        self.GameDetail_Button_Begined:setVisible(true)     
    end

    if self.matchInfo then
        local day = os.time()
        if self.matchInfo.RoomType == 1 then --mtt
            --当前时间<报名时间 or 当前时间>结束时间    【未开始】可见
            -- print(os.date("%Y.%m.%d %H:%M:%S", self.matchInfo.BeginTime))
            -- print(os.date("%Y.%m.%d %H:%M:%S", self.matchInfo.EndTime))
            if day <= self.matchInfo["JoinBTime"] or day >= self.matchInfo["JoinETime"] then
                self:GetWidgetByName("Button_No_start"):setVisible(true)
                self.GameDetail_Button_Register:setVisible(false)
                self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                self.GameDetail_Button_Quit:setVisible(false)
            else     
                 --当前时间>开赛时间 and 当前时间<结束时间    【已开赛】
                if day >= self.matchInfo["BeginTime"] and day <= self.matchInfo["EndTime"] then   --没看懂 and self.pageType == 2 
                    self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(true)
                    self.GameDetail_Button_Register:setVisible(false)
                    self:GetWidgetByName("Button_No_start"):setVisible(false)
                    self.GameDetail_Button_Quit:setVisible(false)
                else
                    -- dump(self.matchInfo)
            -- print("dfasdf3 = ",self.matchInfo.SelfJoin) 
                    if self.matchInfo["SelfJoin"] == 0 then
                        self:GetWidgetByName("Button_No_start"):setVisible(false)
                        self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                        self.GameDetail_Button_Register:setVisible(true)
                        self.GameDetail_Button_Quit:setVisible(false)
                        self.GameDetail_Button_ToBegin:setVisible(false)
                    else
                        self:GetWidgetByName("Button_No_start"):setVisible(false)
                        self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                        self.GameDetail_Button_Register:setVisible(false)
                        self.GameDetail_Button_Quit:setVisible(true)
                    end
                    --self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                end
            end
            if self.pageType ~= 2 then
                self.GameDetail_Button_Register:setVisible(false)
                self:GetWidgetByName("Button_No_start"):setVisible(false)
                self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                self.GameDetail_Button_Quit:setVisible(false)
            end 
        else -- sng  -- 问题：今天最后时刻报名了 明天的开赛时间后登的会出现什么情况
            if day <= self.matchInfo["BeginTime"] or day >= self.matchInfo["EndTime"] then
                --self:GetWidgetByName("Button_No_start"):setVisible(true)
                --修123
                if self.matchInfo["SelfJoin"] == 1 then
                    self.GameDetail_Button_Register:setVisible(false)
                    self:GetWidgetByName("Button_No_start"):setVisible(false)
                    self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                    self.GameDetail_Button_Quit:setVisible(true)
                else
                    self:GetWidgetByName("Button_No_start"):setVisible(true)
                    self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                    self.GameDetail_Button_Quit:setVisible(false)
                    self.GameDetail_Button_Register:setVisible(false)
                end
            else
                self:GetWidgetByName("Button_No_start"):setVisible(false)
                if self.pageType ~= 2 then
                    self.GameDetail_Button_Register:setVisible(false)
                else
                    --修123
                    if self.matchInfo["SelfJoin"] == 1 then
                        self.GameDetail_Button_Register:setVisible(false)
                        self:GetWidgetByName("Button_No_start"):setVisible(false)
                        self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                        self.GameDetail_Button_Quit:setVisible(true)

                    else
                        self:GetWidgetByName("Button_No_start"):setVisible(false)
                        self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
                        self.GameDetail_Button_Quit:setVisible(false)
                        self.GameDetail_Button_Register:setVisible(true)
                    end
                end
            end 
        end
    end
    if self.pageType ~= 2 then
        self.GameDetail_Button_Register:setVisible(false)
        self:GetWidgetByName("Button_No_start"):setVisible(false)
        self:GetWidgetByName("GameDetail_Button_Begined"):setVisible(false)
        self.GameDetail_Button_Quit:setVisible(false)
    end 
end

function GameListDetailWindow:startTimer()
    if not self.__Timer then
        self.__Timer = scheduler.scheduleGlobal(function()
            self:schedulerTick()
        end, 0.2) -- 时间限制
    end
end

function GameListDetailWindow:stopTimer()
    if self.__Timer then
        scheduler.unscheduleGlobal(self.__Timer)
        self.__Timer = nil
    end 
end

function GameListDetailWindow:startLineNumTimer()
    if not self.__LineTimer then
        self.__LineTimer = scheduler.scheduleGlobal(function()
            self:updateLineNum()
        end, 2) -- 时间限制
    end
end

function GameListDetailWindow:stopLineNumTimer()
    if self.__LineTimer then
        scheduler.unscheduleGlobal(self.__LineTimer)
        self.__LineTimer = nil
    end 
end

function GameListDetailWindow:onDestroy()
    self.mIsShow = false
    self.matchInfo = nil
    laixiaddz.LocalPlayercfg.LaixiaisSNG = false
    laixiaddz.LocalPlayercfg.LaixiaisMatchDetail = false
    self:stopTimer()
    self:stopLineNumTimer()
end



return GameListDetailWindow.new()

