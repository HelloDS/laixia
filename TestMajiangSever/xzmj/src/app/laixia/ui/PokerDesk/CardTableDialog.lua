-- region 牌桌主界面

local l_signaltm = 0          --更新游戏信号和电量时间的计时器
local l_const_signaltm = 60 --更新游戏信号和电量时间间隔
local soundConfig =  laixia.soundcfg; 

local l_hTimeObj = require("socket")
local CardTableDialog = class("CardTableDialog", import("..CBaseDialog"):new())  

local GamePlayerObj = import(".GamePlayerObj")
local l_PacketObj = import("...net.Packet")                                                  
local l_cardobj = import(".GameCardObject")
local l_OPHIDObject = import("..layer.DownloaderHead") -- 玩家（非主角）头像下载管理器 
local l_BWTObj=import("...tools.BatteryWifiTime")

local l_CardTypeObj = import("..uiData.PokerType")
local l_NorLogicObject = import(".CommonLgcObject")
local l_EDObject = import("..EffectAni.EffectDict")
local l_EAObject = import("..EffectAni.EffectAni")
--local DownloaderHead = import("..DownloaderHead")

local laixia = laixia;
local l_RoomDataMgr;

   

require "app.laixia.ui.PokerDesk.ddzLgcObject"
require "app.laixia.ui.PokerDesk.ddzAISelCard"


----自-己-手-牌-大-小265*342 -
function CardTableDialog:ctor(...)
    self.hDeskID = -1
    self.isShow = false
    self.hLaiziCard = -1 -- 因为0 是三的牌值
    self.bDelInfoDisplay = false  -- 用于显示结算时候明牌显示
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
    self.mClockTime = 0     --闹钟改变时间的本地时间
    self:SetCardTableSytle(0)
    self.isHaveDiZHu = false
end


function CardTableDialog:getName()
    return "CardTableDialog";
end  

-- 初始化
function CardTableDialog:onInit()

    self.super:onInit(self)
    printInfo("CardTableDialog:onInit")
    -- 注册事件
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_CLEAR_LANDLORDTABLE_WINDOW, handler(self, self.GameClearCardFunction))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_TALKINGINFO_WINDOW, handler(self, self.ShowTalkingFunction))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, handler(self, self.clearData))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SPRING_LANDLORDTABLE_WINDOW, handler(self, self.SpringAnimationFunction)) --结算
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_CONTINUEGOLD_LANDLORDTABLE_WINDOW,handler(self,self.OnChangeGoldContinue))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_COMPUTECART_LANDLORDTABLE_WINDOW,handler(self,self.GameSetPlayStyleFunction));

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_BEGIN_LANDLORDTABLE_WINDOW,handler(self,self.OnbeginFunction)) 
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_NOMONEY_LANDLORDTABLE_WINDOW,handler(self,self.nomoneyFunction)) --修改用户没钱已离开房间的状态
 
        
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_LANDLORDTABLE_WINDOW, handler(self, self.show))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_INITSYN_LANDLORDTABLE_WINDOW, handler(self, self.OnInitSynchronousFunction))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DEAL_LANDLORDTABLE_WINDOW, handler(self, self.OnSendDealFunction))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_CALL_LANDLORDTABLE_WINDOW, handler(self, self.GamethebeFunction))   --叫分
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_PLAY_LANDLORDTABLE_WINDOW, handler(self, self.GamePlayFunction))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOWCARD_LANDLORDTABLE_WINDOW, handler(self, self.showCardFunction)) --明牌消息
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_MANDATE_LANDLORDTABLE_WINDOW, handler(self, self.cancelHostingFunction))  --托管
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_SYNTABLESTAGE_WINDOW, handler(self, self.synchronousStepDataFunction))   --牌桌阶段同步
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_ATTRICHANGE_LANDLORDTABLE_WINDOWS, handler(self, self.attributeChangeFunction))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DEALANI_LANDLORDTABLE_WINDOW, handler(self, self.GameDealAniFunction))   --播放发牌动画


    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_CONTINUE_LANDLORDTABLE_WINDOW,handler(self,self.OnSendContinueGameFunction)) --发送继续打牌
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_EXITROOM_LANDLORDTABLE_WINDOW,handler(self,self.GameSendLeaveRoomFunction))   --发送离开房间消息
    
    --添加流局动画
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_ANIMATION_LIUJU, handler(self, self.onCreatLiuJuAniFunction))
    --初始化自建桌的ui显示   
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_SELFBUILDINGUI, handler(self, self.OnRefreshSelfBuildUIFunction))
    --继续游戏显示界面消息  
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_CONTINUESELFBUILD, handler(self, self.OnConSelfBuildFunction))
    --自建房有人退出界面显示
    ObjectEventDispatch:addEventListener(_LAIXIA_ECENT_UPDATE_UIINEXIT, handler(self, self.OnRefreshUIinExitFunction))

    --更新金、奖券数量
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATAGOLD, handler(self, self.GameRefreshGoldFunction))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_WAITTINGCARTOON_WINDOW,handler(self,self.OnWaitingAniFunction))
 
    -- ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DOWNLOAD_PICTURE_WINDOW, handler(self, self.OnNewHeadXiazaiFunction))
    --自建房大结算显示金币变化
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATEGOLD, handler(self, self.OnRefreshUIGold))

    --ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_FAILE_WINDOW,handler(self, self.FaileAnimate))
    --监听解散状态
--    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_APPLYDISMISS_WINDOW,handler(self,self.showAppleDissmissLayer))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DOWNLOAD_PICTURE_WINDOW, handler(self, self.onHeadDoSuccess))
end 
function CardTableDialog:OnChangeGoldContinue(msg)
    if self.isShow ~= true then
        return
    end
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_TABLERESULT_WINDOW)
    self.mGold:setString(laixia.helper.numeralRules_2(msg.data.Gold)) 
    self:SetCardTableSytle(msg.data.RoomID)
    local flag --断线重连时，记牌器类型
    if self.mSynchronousData ~= nil then
        for k,v in pairs(self.mSynchronousData.Players) do
            if v.PID == laixia.LocalPlayercfg.LaixiaPlayerID  and( v.CardCountTime == -1 or v.CardCountTime == 0 ) then
                flag = true
            end
        end
    end
    if flag == true then --当局记牌器清理记牌器操作操作
        self:isPlayerHaveCardCount(0)
        self.mCardCountTime = 0           
    end
    self:resetCardCountFunction() 
    
    -- laixia.soundTools.playMusic(laixia.soundcfg.SCENE_MUSIC.nomal,true);
end



function CardTableDialog:onTick(dt)
    if self.isShow then
        if self.mPokerDeskType == 4 then
            self.hMyTouxiangFrmaeWidge:setTouchEnabled(false)
            self.Image_UserInfo_Bg_02:setTouchEnabled(false)
            self.Image_UserInfo_Bg_02_:setTouchEnabled(false)
            --self.mSelfHead:setVisible(false)
        else
            self.hMyTouxiangFrmaeWidge:setTouchEnabled(true)
            self.Image_UserInfo_Bg_02:setTouchEnabled(true)
            self.Image_UserInfo_Bg_02_:setTouchEnabled(true)
        end

        -- self.Image_UserInfo_Bg_02 = self:GetWidgetByName("Image_UserInfo_Bg_02",self.mRightHeadBG)
        -- self.Image_UserInfo_Bg_02_ = self:GetWidgetByName("Image_UserInfo_Bg_02",self.Image_LeftHead)

        if laixia.LocalPlayercfg.LaixiaCurrentWindow ~= "CardTableDialog" then
            return
        end
        laixia.LocalPlayercfg.LaixiaSelfBuildIntegral = self.mGold:getString()
        self.mTimeGift= self.mTimeGift +dt
        if self.mTimeGift > 13 then
            self.mTimeGift = 0
            self:OnRefreshIconOfBag()
        end
        l_OPHIDObject:tick()
        l_signaltm = l_signaltm + dt;
        if(l_signaltm > l_const_signaltm) then
                l_signaltm = 0;  
                self.hBwtWidge:ElectricityUpdate()--没40s更新一下游戏信号和电量
                self.hBwtWidge:NetworkUpdate()
        end 
        self.hBwtWidge:TimeUpdate()
--        if self.mPokerDeskType == 4 then
--            self:GetWidgetByName("Label_Current_Ranking"):setString(laixia.LocalPlayercfg.LaixiaMatchRank.."/"..laixia.LocalPlayercfg.LaixiaMatchTotalNum) --隐藏比赛名次
--        end
        if self.mSelfTalk ~= nil  then
            if self.mSelfTalkTime  >= 3 then  -- 这里的时间不是秒,是毫秒. 
                self.mSelfTalkTime = 0
                self.mSelfTalk:removeFromParent()
                self.mSelfTalk = nil
            else
                self.mSelfTalkTime = self.mSelfTalkTime + dt
            end        
        end
        if self.mLeftTalk ~= nil  then
            if self.mLeftTalkTime  >= 3 then  -- 这里的时间不是秒,是毫秒. 
                self.mLeftTalkTime = 0
                self.mLeftTalk:removeFromParent()
                self.mLeftTalk = nil
            else
                self.mLeftTalkTime = self.mLeftTalkTime + dt
            end        
        end
        if self.mRightTalk ~= nil  then
            if self.mRightTalkTime  >= 3 then  -- 这里的时间不是秒,是毫秒. 
                self.mRightTalkTime = 0
                self.mRightTalk:removeFromParent()
                self.mRightTalk = nil
            else
                self.mRightTalkTime = self.mRightTalkTime + dt
            end        
        end
        if self.mTipsTime~= nil and self.mTipsErrorCardType and self.mTipsErrorCardType:isVisible() == true   then
            if self.mTipsTime >= self.mTipsTimeOn then
                self.mTipsErrorCardType:setVisible(false)
                self.mTipsTime = 0
            else
                self.mTipsTime = self.mTipsTime + dt
            end
        end
        if self.mTipsTime~= nil and self.mTipsBiggerCard and self.mTipsBiggerCard:isVisible() == true    then
            if self.mTipsTime >= self.mTipsTimeOn then
                self.mTipsBiggerCard:setVisible(false)
                self.mTipsTime = 0
            else
                self.mTipsTime = self.mTipsTime + dt
            end
        end
        --更新闹钟
        if self.mClock ~= nil and (self.mImgClock:isVisible() == true or self.mClock:isVisible() == true ) then
            if tonumber(self.mTime:getString()) > 0 then
                local showTime = tonumber(self.mTime:getString())
                local time = l_hTimeObj.gettime()
                if self.mStageStep ~= nil and self.mSynchronousData ~= nil then
                    local temp = math.floor((self.mStageStep.Times - self.mSynchronousData.TimesTamp)/1000)
                    if temp >= 0 then
                        self.mTime:setString( temp )
                        self.mLabelTime:setString( temp )
                        if temp ~= showTime and ( temp <= 5 and temp > 0 and temp ~= 3 ) and self.isPlay then
                            laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_event_table_count_down)
                        end
                    else
                        self.mTime:setString( 0 )
                        self.mLabelTime:setString( 0 )
                    end
                end
                self.mClockTime = time
                if showTime <= 5 then
                    self:DisplayWhichClockFunction(2)
                else
                    self:DisplayWhichClockFunction(1)
                end 
            end        
        end
        --更新牌桌同步时间戳
        if self.mSynchronousData ~= nil and  self.mLocalTime ~= nil then
            local time = l_hTimeObj.gettime()
            self.mSynchronousData.TimesTamp = self.mSynchronousData.TimesTamp +(time - self.mLocalTime) * 1000
            self.mLocalTime = time
        end

        --更新比赛场内当前排名
        if self:GetWidgetByName("Label_Current_Integral",self.mRankingBG) and self.mPokerDeskType == 4 then
            if laixia.LocalPlayercfg.LaixiaMatchStage == 1 then 
                self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名："..laixia.LocalPlayercfg.LaixiaMatchRank.."/"..laixia.LocalPlayercfg.LaixiaMatchTotalNum)
            elseif laixia.LocalPlayercfg.LaixiaMatchStage == 3 then 
                if tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) == 0 and tonumber(laixia.helper.ConvertStrToNum(self.mLeftInfoGold:getString())) == 0
                    and tonumber(laixia.helper.ConvertStrToNum(self.mRightInfoGold:getString())) == 0 then
                    self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：1/3")
                elseif tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) > tonumber(laixia.helper.ConvertStrToNum(self.mLeftInfoGold:getString())) 
                    and tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) > tonumber(laixia.helper.ConvertStrToNum(self.mRightInfoGold:getString())) then
                    self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：1/3")
                    laixia.LocalPlayercfg.NowRankinSNG = 1
                elseif tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) < tonumber(laixia.helper.ConvertStrToNum(self.mLeftInfoGold:getString())) and tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString()))< tonumber(laixia.helper.ConvertStrToNum(self.mRightInfoGold:getString())) then
                    self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：3/3")
                    laixia.LocalPlayercfg.NowRankinSNG = 3
                else
                    self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：2/3")
                    laixia.LocalPlayercfg.NowRankinSNG = 2
                end
            end 
        end   
    end
end

function CardTableDialog:initTexture()
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("new_animation/huojian0.plist","new_animation/huojian0.png")
end

function CardTableDialog:OnRefreshIconOfBag()
    if self.isShow == true then 
        laixia.UItools.udpateSuperGiftIcon(self.Button_supergift)
    end
end

--初始化自建桌数据
function CardTableDialog:InitSelfBuildFunc()
    
  local  headBG = {}
  table.insert(headBG,self.hMyTouxiangFrmaeWidge  )
  table.insert(headBG,self.mLeftHeadBG  )
  table.insert(headBG,self.mRightHeadBG )

  local ismaster = "Image_Master"
  local addFriend = "Image_AddFriend"
  local isReadly = "Label_isRealdy"

  self.mRoomIDNode =  self:GetWidgetByName("BitmapLabel_RoomID")
  self.mCountNode =  self:GetWidgetByName("BitmapLabel_Count")


  
    -- local createDel = self:GetWidgetByName("Button_CreateDel") 
    -- createDel:setVisible(false)
  if self.mSelfRoomID ~= 50  then
        self.mRoomIDNode:setVisible(false)
        self.mCountNode:setVisible(false)
        for i,v in ipairs(headBG) do
            self:GetWidgetByName(addFriend,v):setVisible(false)
            self:GetWidgetByName(isReadly,v ):setVisible(false)
       end
        --  0:常规斗地主 1：癞子斗地主 2：经典斗地主 4：比赛桌
        if 0 == self.mSelfRoomType then
            self.mPokerDeskType = 0
            -- self.Image_RoomInfo:loadTexture("table_title_huanlechang.png",1)
        elseif 1 == self.mSelfRoomType then
            self.mPokerDeskType = 1
            -- self.Image_RoomInfo:loadTexture("table_title_laizichang.png",1)
        elseif 2 == self.mSelfRoomType then
            self.mPokerDeskType = 2
            -- self.Image_RoomInfo:loadTexture("table_title_jidianchang.png",1)
        else 
            self.mPokerDeskType =4
        end
       return 
   else
     --托管置灰
    self:GetWidgetByName("Button_CancelTrusteeship"):setTouchEnabled(false)
    self:GetWidgetByName("Button_CancelTrusteeship"):setEnabled(false)
    self:GetWidgetByName("Button_CancelTrusteeship"):setBrightStyle(1)
    --改为积分图标
    self.mGoldBG :setVisible(true)
    self.mIntegralBG:setVisible(false)
    self.mRankingBG:setVisible(false)
    self:GetWidgetByName("Button_Talk"):setVisible(false)
    self.selfinfo = self:GetWidgetByName("SelfHeadInfo")
    self.selfjifen = self:GetWidgetByName("Image_GoldBG", self.selfinfo)
    self:GetWidgetByName("Image_27",self.selfjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
    -- self:GaibianShuziWenbenFunction(self.mGold,0)
  --  self:GetWidgetByName("Label_Current_Coin",self.selfjifen):setString("0")

    self.leftinfo = self:GetWidgetByName("LeftHeadPInfo")
    self.leftjifen = self:GetWidgetByName("Image_GoldBG", self.leftinfo)
    self:GetWidgetByName("Image_27_Copy",self.leftjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
   -- self:GetWidgetByName("Label_LeftInfoGold",self.leftinfo):setString("0")

    self.rightinfo = self:GetWidgetByName("RightHeadInfo")
    self.rightjifen = self:GetWidgetByName("Image_GoldBG_Copy", self.rightinfo)
    self:GetWidgetByName("Image_27_Copy_Copy",self.rightjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
   -- self:GetWidgetByName("Label_RightInfoGold",self.rightinfo):setString("0")
  end

      for i,v in ipairs(headBG) do  --显示房主图标和添加好友按钮
           if self.mSelfRoomType ~= nil   then
               
               v:setVisible(true)
               self:GetWidgetByName(ismaster,v):setVisible(false)
               self:GetWidgetByName(addFriend,v):setVisible(true)
               self:AddWidgetEventListenerFunction(addFriend, handler(self, self.OnRequestPengyou),v)-- 点击邀请好友
              --要是控件统一命名就不会出现这样的状况了
              -- if v == self.mLeftHeadBG then
              --       self.mLeftHead:removeAllChildren()
              --       self.mLeftHead:loadTexture("img_null.png",1)
              -- elseif v == self.mRightHeadBG  then 
              --       self.mRightHead:removeAllChildren() 
              --       self.mRightHead:loadTexture("img_null.png",1)  
              -- end


           else
               self:GetWidgetByName(ismaster,v):setVisible(false)
               self:GetWidgetByName(addFriend,v):setVisible(false)
           end
           self:GetWidgetByName(isReadly,v):setVisible(false)
      end
      
        if self.mMasterID == laixia.LocalPlayercfg.LaixiaPlayerID then --自建房自己是房主
            self:GetWidgetByName(ismaster,self.hMyTouxiangFrmaeWidge ):setVisible(true) 
        end

                      
        for i=1,2  do
            local infoBg = "Image_UserInfo_Bg_0"..i
            self:GetWidgetByName(infoBg,self.mLeftHeadBG):setVisible(false)
            self:GetWidgetByName(infoBg,self.mRightHeadBG):setVisible(false)
        end


        self:GetWidgetByName("Image_LeftHeadCard",self.mLeftHeadBG):setVisible(false)
        self:GetWidgetByName("Image_RightHeadCard",self.mRightHeadBG):setVisible(false)
        self.mLeftNum :setVisible(false)
        self.mRightNum:setVisible(false) 


         if self.mSelfRoomType ~= nil  then
             self:GetWidgetByName(addFriend,self.hMyTouxiangFrmaeWidge ):setVisible(false) --自建房不要自己的加号
         end

        -- local createDel = self:GetWidgetByName("Button_CreateDel")  --解散房间按钮
        -- createDel:addTouchEventListener(handler(self, self.OnSendBuildDeleteFunction))

        -- if self.mMasterID == laixia.LocalPlayercfg.LaixiaPlayerID then
        --     createDel:setVisible(true)
        -- else
        --     createDel:setVisible(false)
        -- end


        if self.hDeskID  ~= nil then
            laixia.LocalPlayercfg.LaixiaSelfBuildTable  =   self.hDeskID
            self.mRoomIDNode:setString("房间号："..self.hDeskID )
            self.mCountNode :setString("第"..self.mSelfCount.."副")
           
        else
            self.mRoomIDNode:setVisible(false)
            self.mCountNode:setVisible(false)
        end

        --  0:常规斗地主 1：癞子斗地主 2：经典斗地主 4：比赛桌
        if 0 == self.mSelfRoomType then
            self.mPokerDeskType = 0
            -- self.Image_RoomInfo:loadTexture("table_title_huanlechang.png",1)
        elseif 1 == self.mSelfRoomType then
            self.mPokerDeskType = 1
            -- self.Image_RoomInfo:loadTexture("table_title_laizichang.png",1)
        elseif 2 == self.mSelfRoomType then
            self.mPokerDeskType = 2
            -- self.Image_RoomInfo:loadTexture("table_title_jidianchang.png",1)
        else 
             self.mPokerDeskType =4
        end
end

--修1 
--设置适配
function CardTableDialog:setAdaptation()
    --大厅需要设置自适应的所有设置
    --self.bg_ = self:GetWidgetByName("BG")
    --self.bg_:setScale(display.contentScaleFactor)
    self.but_supergift = self:GetWidgetByName("Button_supergift")
    self.showtolobby_ = self:GetWidgetByName("Image_ShowToLobby")
    self.showtolobby_:setPosition(cc.p(self.showtolobby_:getPositionX(),display.top-self.showtolobby_:getContentSize().height/2-10))
    self.but_supergift:setPosition(cc.p(self.but_supergift:getPositionX(),display.top-self.but_supergift:getContentSize().height/2-8))
    --self.but_supergift:setPosition(cc.p(self.but_supergift:getPositionX(),display.top-self.but_supergift:getContentSize().height/2-4))
    --self.Panel_top = self:GetWidgetByName("Panel_top")
    --self.Panel_top:setScale(display.contentScaleFactor)
    --self.bg_:setScaleY(display.widthInPixels/display.width)
    if device.platform == "ios" then
        --暂时先 适配 iphoneX
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self:GetWidgetByName("BG"):setScaleX(2436/3*2/1280)
            local x  = display.cx + (display.widthInPixels /2 - 1280*display.contentScaleFactor/2)/2
            -- self:GetWidgetByName("Image_Panel"):setPositionX(x)
            -- self:GetWidgetByName("Panel_1"):setPositionX(x)
        end
    end
end


function CardTableDialog:onShow(msg) 
    
    -- laixia.soundTools.playMusic(laixia.soundcfg.SCENE_MUSIC.nomal,true);
    laixia.soundTools.stopMusic()
    
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_TABLERESULT_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_DAILYSIGN_WINDOW)
    --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHFLICKERWORDS_WINDOW)

    laixia.LocalPlayercfg.LaixiaisConnectCardTable = true


    
    if not self.isShow then
        self:setAdaptation()
        self.rankIcon = {}
        self:initTexture();
        
        l_RoomDataMgr =  laixia.JsonTxtData:queryTable("room_list");
        
        self.hTouxiangImageWidge =  self:GetWidgetByName("Image_Head")
        self:OnRefreshHeadIconFunction(self.hTouxiangImageWidge,laixia.LocalPlayercfg.LaixiaPlayerID,laixia.LocalPlayercfg.LaixiaPlayerHeadUse)
        self.hPanelImageWidge =  self:GetWidgetByName("Image_Panel")
        if laixia.kconfig.isYingKe == true then
            -- self:GetWidgetByName("BG"):loadTexture("new_ui/CardTableDialog/zhishiBG.png")
            self:GetWidgetByName("Image_laixiadoudizhu"):setVisible(false)
        end
        --时间 wifi 电量组件
        --local l_wifi=self:GetWidgetByName(" ")
        self.Panel_1 = self:GetWidgetByName("Panel_1")
        self.hBwtWidge=l_BWTObj.new(self.Panel_1,0,0)
        self.hBwtWidge:ElectricityUpdate()--初始化电量
        self.hBwtWidge:NetworkUpdate()--初始化信号
        self:AddWidgetEventListenerFunction("Button_Talk", handler(self, self.onTalkFunction))-- 聊天按钮

        self:GetWidgetByName("Button_Talk"):setTouchEnabled(false)
        self:GetWidgetByName("Button_Talk"):setBright(false)
        self:AddWidgetEventListenerFunction("Button_Setting", handler(self, self.onSet))
        self:AddWidgetEventListenerFunction("Button_BackToLobby", handler(self, self.onBack)) --返回大厅

        -- if self.mSelfRoomID == 9 or self.mSelfRoomID == 10 or self.mSelfRoomID == 11 then
        --     self:GetWidgetByName("Button_BackToLobby"):setTouchEnabled(false)
        --     self:GetWidgetByName("Button_BackToLobby"):setEnabled(false)
        --     self:GetWidgetByName("Button_BackToLobby"):setBrightStyle(1)
        -- end
         if self.mPokerDeskType == 8 or self.mPokerDeskType == 9 or self.mPokerDeskType == 10 or self.mPokerDeskType == 11 then
            self:GetWidgetByName("Button_BackToLobby"):setTouchEnabled(false)
            self:GetWidgetByName("Button_BackToLobby"):setEnabled(false)
            self:GetWidgetByName("Button_BackToLobby"):setBrightStyle(1)
        end
        
        self.mLeftHeadBG = self:GetWidgetByName("Image_LeftHeadBG")       
        self.mRightHeadBG = self:GetWidgetByName("Image_RightHeadBG")
        self.hMyTouxiangFrmaeWidge = self:GetWidgetByName("Image_SelfHeadBG")
        self.mRightHead = self:GetWidgetByName("Image_RightHead")
        self.Image_UserInfo_Bg_02 = self:GetWidgetByName("Image_UserInfo_Bg_02",self.mRightHeadBG)
        self.Image_UserInfo_Bg_02_ = self:GetWidgetByName("Image_UserInfo_Bg_02",self.Image_LeftHead)
        self.hRightTouxiangFrmaeWidge = self:GetWidgetByName("RightHeadInfo")
        self.hLeftTouxiangFrmaeWidge = self:GetWidgetByName("LeftHeadPInfo")

        self.mLeftLeave = self:GetWidgetByName("Image_LeftLeave")
        self.mRightLeave = self:GetWidgetByName("Image_RightLeave")

        self.mSelfHead = self:GetWidgetByName("Image_SelfHead")
        
        self:OnRefreshHeadIconFunction(self.mSelfHead,laixia.LocalPlayercfg.LaixiaPlayerID,laixia.LocalPlayercfg.LaixiaPlayerHeadUse)

        --fff
        if self.mPokerDeskType == 4 or self.mSelfRoomID == 50 then
            self.hMyTouxiangFrmaeWidge:setTouchEnabled(false)
            self.Image_UserInfo_Bg_02:setTouchEnabled(false)
            self.Image_UserInfo_Bg_02_:setTouchEnabled(false)
            -- self.mSelfHead:setVisible(false)
        end
        --if self.mPokerDeskType ~= 4 then
            
            self.hMyTouxiangFrmaeWidge:addTouchEventListener(handler(self, self.onPlayerInfoFunction)) --暂时不让查玩家在游戏中的数据
            self.Image_UserInfo_Bg_02:addTouchEventListener(handler(self, self.onPlayerInfoFunction))
            self.Image_UserInfo_Bg_02_:addTouchEventListener(handler(self, self.onPlayerInfoFunction))
        --end

        -- self.Label_selfInfoName = self:GetWidgetByName("Label_selfInfoName")
        -- self.Label_selfInfoName:setString(laixia.LocalPlayercfg.LaixiaPlayerNickname)

        self:GetWidgetByName("Image_LeftDizhu"):setVisible(false)
        self:GetWidgetByName("Image_RightDizhu"):setVisible(false)
        self:GetWidgetByName("Image_SelfDizhu"):setVisible(false)
        -- self.mLeftHeadBG:setVisible(false)
        self.mLeftHead = self:GetWidgetByName("Image_LeftHead")
        --right
        -- 
        -- self.Image_UserInfo_Bg_02_:addTouchEventListener(handler(self, self.onPlayerInfoFunction))
        -- self.Image_RoomInfo = self:GetWidgetByName("Image_RoomInfo")--场地图标--这个需要一个方法来实现不能删除
        -- self.Image_RoomInfo:setVisible(false)

        -- self.mRightHeadBG:setVisible(false)
        self.mRightHead = self:GetWidgetByName("Image_RightHead")
        --left
        -- self.Image_UserInfo_Bg_02 = self:GetWidgetByName("Image_UserInfo_Bg_02",self.mRightHeadBG)
        -- self.Image_UserInfo_Bg_02:addTouchEventListener(handler(self, self.onPlayerInfoFunction))
        
        self.mLeftHeadPoint   ={x=0,y=0}
        self.mSelfHeadPoint   ={x=0,y=0}
        self.mRightHeadPoint  ={x=0,y=0}

        
        self.mLeftHeadPoint.x,self.mLeftHeadPoint.y     = self.mLeftHead:getPosition()
        self.mSelfHeadPoint.x,self.mSelfHeadPoint.y     = self.mSelfHead:getPosition()
		self.mRightHeadPoint.x,self.mRightHeadPoint.y    = self.mRightHead:getPosition()
----------------------------------------------------------------------------------------------------------
        self.mShowBackLobby = self:GetWidgetByName("Button_ShowBackToLobby") --返回大厅的按钮
        self.mShowBackLobby:addTouchEventListener(handler(self, self.OnDisplayLobbyFunction))
        self.mShowToLobby = self:GetWidgetByName("Image_ShowToLobby") --返回大厅的界面
        self:AddWidgetEventListenerFunction("Button_rule", handler(self, self.onRule))
        self.mShowToLobby:setVisible(false)

        -- self.Button_Baoxiang = self:GetWidgetByName("Button_Baoxiang") --获取宝箱
        -- self.Button_Baoxiang:setVisible(false)
----------------------------------------------------------------------------------------------------------
        self.mThebeBar = self:GetWidgetByName("Panel_ThebeBar")-- 叫分
        self.mThebeBar:setVisible(false)
        self.mThreePoint = self:GetWidgetByName("Button_ThreePoint",self.mThebeBar) --叫地主
        self.mThreePoint:addTouchEventListener(handler(self, self.onthebeFunction))
        self.mPassPoint = self:GetWidgetByName("Button_PassPoint",self.mThebeBar) --不叫
        self.mPassPoint:addTouchEventListener(handler(self, self.onthebeFunction))
----------------------------------------------------------------------------------------------------------
        self.mPointArray = {}  --叫分数组
        self.mCallPointBar = self:GetWidgetByName("Panel_CallPoints")
        self.mCallPointBar:setVisible(false)
        for i=1,4 do
            local nodeName = "Button_CallPoint_"..i-1
            local node = self:GetWidgetByName(nodeName,self.mCallPointBar)
            table.insert(self.mPointArray , node)
            node.Point = i-1
            node:addTouchEventListener(handler(self, self.onCallPoints))
        end
        self.Button_CallPoint_0 = self:GetWidgetByName("Button_CallPoint_0",self.mCallPointBar)
        self.Button_CallPoint_1 = self:GetWidgetByName("Button_CallPoint_1",self.mCallPointBar)
        self.Button_CallPoint_2 = self:GetWidgetByName("Button_CallPoint_2",self.mCallPointBar)
        self.Button_CallPoint_3 = self:GetWidgetByName("Button_CallPoint_3",self.mCallPointBar)
----------------------------------------------------------------------------------------------------------
        self.mGrabBar = self:GetWidgetByName("Panel_GrabBar")-- 抢地主
        self.mGrabBar:setVisible(false)
        self.mGrab = self:GetWidgetByName("Button_Grab",self.mGrabBar) --抢地主
        self.mGrab:addTouchEventListener(handler(self, self.onGrabFunction))
        self.mUngrab = self:GetWidgetByName("Button_Ungrab",self.mGrabBar) --不抢
        self.mUngrab:addTouchEventListener(handler(self, self.onGrabFunction))
------------------------------------------------------------------------------------------------------------
        self.mPlayBar = self:GetWidgetByName("Panel_PlayBar")-- 出牌
        self.mPlayBar:setVisible(false)
        self.mPass = self:GetWidgetByName("Button_Pass",self.mPlayBar)-- 不出
        self.mPass_1 = self:GetWidgetByName("Button_Pass_1",self.mPlayBar)-- 不出
        self.mPass:addTouchEventListener(handler(self, self.OnPassCardFunction))

       self.resetButton = self:GetWidgetByName("Button_Reset",self.mPlayBar)
       self.resetButton_1 = self:GetWidgetByName("Button_Reset_1",self.mPlayBar)
       self.resetButton:addTouchEventListener(handler(self,self.onReelect))

        self.mPassToo = self:GetWidgetByName("Button_Pass_too",self.mPlayBar)-- 要不起
        self.mPassToo_1 = self:GetWidgetByName("Button_Pass_too_1",self.mPlayBar)-- 要不起
        self.mPassToo:addTouchEventListener(handler(self, self.OnPassCardFunction))

        self.mHint = self:GetWidgetByName("Button_Hint",self.mPlayBar)-- 提示
        self.mHint_1 = self:GetWidgetByName("Button_Hint_1",self.mPlayBar)-- 提示
        self.mHint:addTouchEventListener(handler(self, self.onHint))

        self.mPlay = self:GetWidgetByName("Button_Play",self.mPlayBar)-- 出牌
        self.mPlay_1 = self:GetWidgetByName("Button_Play_1",self.mPlayBar)-- 出牌
        self.mPlay:addTouchEventListener(handler(self, self.OnGameChuPaiFunction))

        self.mIsDouble = self:GetWidgetByName("Image_SeenCard") --名牌小图标
        self.mIsDouble:setVisible(false)
        self.mDouble = self:GetWidgetByName("Button_Double",self.mPlayBar)-- 明牌按钮
        self.mDouble:addTouchEventListener(handler(self, self.onDoubleFunction)) 

-------------------------------------------------------------------------------------------------------------
        self.mTimes = self:GetWidgetByName("AtlasLabel_Times")-- 倍数
        self.mTimes:enableOutline(cc.c4b(72,22,0,255), 2);

        self.mResultNum = self:GetWidgetByName("AtlasLabel_ResultNum")-- 底分
        self.mLeftNum = self:GetWidgetByName("AtlasLabel_leftCardNum")
        self.mLeftNum:enableOutline(cc.c4b(0,59,91,255), 2);
        self.mRightNum = self:GetWidgetByName("AtlasLabel_RightCardNum")
        self.mRightNum:enableOutline(cc.c4b(0,59,91,255), 2);
        self.mCancelTrusteeship = self:GetWidgetByName("Button_CancelTrusteeship001")-- 取消托管按钮 --需要慎重设置
        self.mCancelTrusteeship:addTouchEventListener(handler(self, self.CancelTrusteeship)) 
        self:AddWidgetEventListenerFunction("Button_CancelTrusteeship", handler(self, self.onTrusteeshipFunction))
        self:GetWidgetByName("Button_CancelTrusteeship"):setTouchEnabled(false)
        --self:GetWidgetByName("Button_CancelTrusteeship"):setEnabled(false)

------------------------------------------------------------------------------------------------------------------------        
        self.mGoldBG  = self:GetWidgetByName("Image_GoldBG") --我的金币

        self.mIntegralBG  = self:GetWidgetByName("Image_Integral") --我的积分
        self.mRankingBG  = self:GetWidgetByName("Image_Ranking") --我的排名
------------------------------------------------------------------------------------------------------------------------        
        self.mGold = self:GetWidgetByName("Label_Current_Coin",self.mGoldBG)
        self.mTipsBiggerCard = self:GetWidgetByName("Image_NoBiggerCard")  --没有打过上家的牌
        self.mTipsErrorCardType = self:GetWidgetByName("Image_ErrorCardType")  --牌型不符合规则

        self.mLeftHandle = self:GetWidgetByName("Image_LeftHandle")
        self.mRightHandle = self:GetWidgetByName("Image_RightHandle")

        self.mLeftHandleAni = self:GetWidgetByName("Image_LeftHandle_Bomb")
        self.mRightHandleAni = self:GetWidgetByName("Image_RightHandle_Bomb")

        self.mSelfHandle = self:GetWidgetByName("Image_SelfHandle")

        self.mLeftInfoName = self:GetWidgetByName("Label_LeftInfoName")
        self.mLeftInfoGold = self:GetWidgetByName("Label_LeftInfoGold")
        self.mRightInfoName = self:GetWidgetByName("Label_RightInfoName")
        self.mRightInfoGold = self:GetWidgetByName("Label_RightInfoGold")
        self:AddWidgetEventListenerFunction("Button_GoShop", handler(self, self.onGameShopFunction))-- 底边金币按钮

        -- self:GetWidgetByName("Button_GoRanking"):setVisible(false)
        -- self:AddWidgetEventListenerFunction("Button_GoRanking", handler(self, self.checkRankFunction))-- 比赛部分查看排行榜

        self.mCardCountImg = self:GetWidgetByName("Image_cardCount")  --记牌器界面

        --modify by wangtianye
        -- self.mHaveCardCountButton = self:GetWidgetByName("Button_Have_cardCount") -- 有记牌器的情况
        -- self.mHaveCardCountButton:addTouchEventListener(handler(self, self.onShowCardCountFunction))
        self.mImgClock = self:GetWidgetByName("Image_Clock")--闹钟
        self.mImgClock:setVisible(false)
        self.mLabelTime = self:GetWidgetByName("Label_Time",self.mImgClock) --闹钟上面的数字
        self.mLabelTime:enableOutline(cc.c4b(255,255,255,255), 2);

        self.mLaiziBottom =self:GetWidgetByName("Image_bottomPoker_Laizi")  -- 癞子底牌
        self.mLaiziBottom:setVisible(false)
--------------------------------------------------------------------------------------------------------------
        self.mLeftTuoguan = self:GetWidgetByName("Image_LeftTuoguan") --左边托管
        self.mLeftTuoguan:setVisible(false)
        self.mRightTuoguan = self:GetWidgetByName("Image_RightTuoguan") --右边托管
        self.mRightTuoguan:setVisible(false)
--------------------------------------------------------------------------------------------------------------

        self.Button_supergift = self:GetWidgetByName("Button_supergift") --首冲礼包啊
        self.Button_supergift:setVisible(false)
        self:AddWidgetEventListenerFunction("Button_supergift", handler(self, self.onSuperGiftFunction))   --牌桌上的超级礼包按钮

        self.Button_supergift:setOpacity(0)

        -- pokerdesk 的首充动画
        if laixia.kconfig.isYingKe == false then
            self.BG = self:GetWidgetByName("BG")
            local system = laixia.ani.CocosAnimManager
            self.chest = system:playAnimationAt(self.BG,"doudizhu_icon_chest")
            self.chest:setVisible(false)
            self.chest:setLocalZOrder(6)
            self.chest:setPositionX(self.Button_supergift:getPositionX()+self.Button_supergift:getContentSize().width/2-40)
            self.chest:setPositionY(self.Button_supergift:getPositionY()+self.Button_supergift:getContentSize().height/2-50)
        end
        if laixia.config.isAudit then
            self:GetWidgetByName("Button_supergift"):loadTextureNormal("new_ui/isAudit/shenhe_shouchong.png")
            self:GetWidgetByName("Button_supergift"):loadTexturePressed("new_ui/isAudit/shenhe_shouchong.png")
        end
        if laixia.kconfig.isYingKe == false then
            if laixia.LocalPlayercfg.isShouchong == true then
                self.Button_supergift:setVisible(true)
                self.chest:setVisible(true)
            else
                self.Button_supergift:setVisible(false)
                self.chest:setVisible(false)
            end
        end
        
         if laixia.config.isAudit then
            self:GetWidgetByName("Button_supergift"):loadTextureNormal("new_ui/isAudit/shenhe_shouchong.png")
            self:GetWidgetByName("Button_supergift"):loadTexturePressed("new_ui/isAudit/shenhe_shouchong.png")
        end

        self.Button_renwu = self:GetWidgetByName("Button_renwu")
        self.Button_renwu:setVisible(false)

        
        self.winNum =  self:GetWidgetByName("BitmapLabel_WinNum")
        self.lostNum = self:GetWidgetByName("BitmapLabel_LostNum")

        self.mCardCountTable = { 
            self:GetWidgetByName("Label_cardCount3"),
            self:GetWidgetByName("Label_cardCount4"),
            self:GetWidgetByName("Label_cardCount5"),
            self:GetWidgetByName("Label_cardCount6"),
            self:GetWidgetByName("Label_cardCount7"),
            self:GetWidgetByName("Label_cardCount8"),
            self:GetWidgetByName("Label_cardCount9"),
            self:GetWidgetByName("Label_cardCount10"),
            self:GetWidgetByName("Label_cardCountJ"),
            self:GetWidgetByName("Label_cardCountQ"),
            self:GetWidgetByName("Label_cardCountK"),
            self:GetWidgetByName("Label_cardCountA"),
            self:GetWidgetByName("Label_cardCount2"),
            self:GetWidgetByName("Label_cardCountXiaoWang"),
            self:GetWidgetByName("Label_cardCountDaWang"),
        }
        self.mBottomPoker = {
            self:GetWidgetByName("Image_BottomPoker1"),
            self:GetWidgetByName("Image_BottomPoker2"),
            self:GetWidgetByName("Image_BottomPoker3"),   
            0,--发底牌改变后第一个
            0,--发底牌改变后第二个
            0,--发底牌改变后第三个
            0,
        }
        if self.mPokerDeskType == 4 then

        end 
        self.mGoldBG :setVisible(true)
        self.mIntegralBG:setVisible(false)
        self.mRankingBG:setVisible(false)
        self.Panel_waittingAni = self:GetWidgetByName("Panel_waittingAni")
        self.Panel_waittingAni:setVisible(false)

        dizhupao =l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_LANLORD_RAIN)
        dizhupao:setPosition(cc.p(-640,-360))
        dizhupao:addTo(self.Panel_waittingAni,4)
        dizhupao:setLocalZOrder(10000)


        self:GetWidgetByName("BG"):setTouchEnabled(true)
        self:GetWidgetByName("BG"):addTouchEventListener(handler(self, self.OnResetMyCardsFunction))

       
        self.mTimeGift = 0 --首冲礼包时间间隔
        self:OnRefreshIconOfBag()

-----------------------------------------------------------------------------------
        --自建桌的界面初始化
        self.mSelfRoomType = msg.data.RoomType    --自建房的类型
        self.mMasterID =  msg.data.BossID         --房主ID
        self.hDeskID  = msg.data.TableID    --自建桌桌号
        self.mSelfCount  = msg.data.Count         --自建桌当前局数
        self.mSelfRoomID = msg.data.RoomID 
        self.BaseScore = msg.data.BaseScore --底分是后台发过来的变量
        self.AppleDissTime = msg.data.AppleDissTime
--        self.isAppleDissmis = msg.data.isAppleDissmis
--        self.AppleDissUserSet = msg.data.AppleDissUserSet --有可能是因为正在申请解散房间中

        self:InitSelfBuildFunc()

-----------------------------------------------------------------------------------------
        self.isShow = true
    end


    if msg.data.isAppleDissmis == 7 then
        if ui.AppleDismissLayer.mIsShow == false then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_APPLYDISMISS_WINDOW,{data = msg.data})
        elseif ui.AppleDismissLayer.mIsShow == true then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_APPLYDISMISS_WINDOW,{data = msg.data})
        end 
--        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_APPLYDISMISS_WINDOW,{data=msg.data})
    end
    self.intoWindowsData = msg.data --可能是进入房间消息，也可能是快速开始消息
    self:SetCardTableSytle(self.intoWindowsData.RoomID)

    if self.mClock == nil then
        self:CreateClockFunction()
    end     

    if self.mSynchronousData == nil or #self.mSynchronousData.BottomCards == 0 then
       --self:OnRefreshHeadIconFunction(self.mSelfHead,nil,nil)
    end
  
    if self.mSelfRoomID ~= 50 then
         self:GaibianShuziWenbenFunction(self.mGold,laixia.LocalPlayercfg.MatchGold or laixia.LocalPlayercfg.LaixiaPlayerGold )
    end
  
    self.mPokersNumAlarmTable = {false,false,false,false,false,false} 
    self.mLeftHead:setTouchEnabled(true)
    self.mRightHead:setTouchEnabled(true)
    self.mSelfHead:setTouchEnabled(true)
    --断线重连不处理服务器返回的消息，只处理同步方法的调用
    if self.intoWindowsData.EnterType == 1 and not self.intoWindowsData.from then
        return
    end
    self.isPlay = false         --是否在打牌
    if self.mPokerDeskType == 8 or self.mPokerDeskType == 9 or self.mPokerDeskType == 10 or self.mPokerDeskType == 11 then
        self:GetWidgetByName("Button_BackToLobby"):setTouchEnabled(true)
        self:GetWidgetByName("Button_BackToLobby"):setEnabled(true)
        self:GetWidgetByName("Button_BackToLobby"):setBrightStyle(0)
    end
    self.isDealAni = false      --出牌动画完成
    self.isMingPoker = 0    --0：不名牌 1 ：名牌
    self.mTips = {}    -- 提示信息
    self.mCardType = nil-- 当前出的牌型
    self.mIndex = 1     -- 提示牌型索引
    self.nomoney=false
    self.mPreviousType = nil --上一个牌型
    self.mNowType   = nil --现在牌型
    self.IsKingBombFunction = -1     --王炸 -1:没有 0，1，2对应座位号
    self.mEffect = {}           --特效表
    self.isPlayerHaveCardCountState = 0     --记牌器状态
    self.mDiscardCards = nil        --保存自己出牌的内容与服务器出的牌做判断
    --剩余牌数报警 false没有报警过 true报警过了
    --自己还剩2张，自己还剩1张，右边玩家还剩2张，右边玩家还剩1张，左边玩家还剩2张，左边玩家还剩1张

    self.mLeftHead:removeAllChildren()
    self.mLeftLeave:setVisible(false)
    self.mRightHead:removeAllChildren()
    
    self.mRightLeave:setVisible(false)

    self.mCancelTrusteeship:setVisible(false)
    self.mCancelTrusteeship:setTouchEnabled(false) 

    self.mTipsBiggerCard:setVisible(false)
    self.mTipsErrorCardType:setVisible(false)
   
    self.mLeftHandle:setVisible(false)
    
    self.mRightHandle:setVisible(false)
    
    self.mSelfHandle:setVisible(false)

    if  self.intoWindowsData ~= nil and self.intoWindowsData.TimesTamp==nil then --这里有报错
        self.isPlayerHaveCardCountState = 0
        self:isPlayerHaveCardCount(0)
    elseif  self.intoWindowsData ~= nil  and  self.intoWindowsData.TimesTamp > self.intoWindowsData.CardCountTime then
        self.isPlayerHaveCardCountState = 0
        self:isPlayerHaveCardCount(0)
    else       --有记牌器
        self.isPlayerHaveCardCountState = 1
        self:isPlayerHaveCardCount(1)
    end
    self:resetCardCountFunction()--重置出牌器

    --现金桌和奖券桌逻辑
    if self.mPokerDeskType == 1 or self.mPokerDeskType == 2 or self.mPokerDeskType == 0 then
        if not self.intoWindowsData.EnterType or self.intoWindowsData.EnterType == 0 then
            if laixia.LocalPlayercfg.LaixiaMatchRoomType == 0 then--定时比赛
                self:OnWaitingAniFunctionForDingshiMatch()
            else
                self:OnWaitingAniFunction()
            end
        end
    end

    local mZijiang = self:GetWidgetByName("Image_SelfBuild")  --显示自建房界面
    if msg.data.RoomType == nil or self.mSelfRoomID ~= 50  then     --如果是自建桌就不播地主跑
        mZijiang:setVisible(false)
    else
        mZijiang:setVisible(true)
        self.Panel_waittingAni:setVisible(false)
        

        self.isShowZiJiangResult = false


       -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("table_bisai_jifen.png", 1)
       -- self:GetWidgetByName("Image_LeftBG"):loadTexture("table_bisai_jifen.png", 1)
       -- self:GetWidgetByName("Image_RightBG"):loadTexture("table_bisai_jifen.png", 1)
       -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("/res/new_ui/CardTableDialog/jifen_icon.png")
       -- self:GetWidgetByName("Image_LeftBG"):loadTexture("/res/new_ui/CardTableDialog/jifen_icon.png")
       -- self:GetWidgetByName("Image_RightBG"):loadTexture("/res/new_ui/CardTableDialog/jifen_icon.png")
    end
    self:GetWidgetByName("Button_GoShop"):setVisible(false)
    if self.mPokerDeskType == 4  then    --比赛场
        if self.laterAni then
            self.laterAni:removeFromParent()
            self.laterAni = nil
        end
        local system = laixia.ani.CocosAnimManager   --比赛开始动画
        self.matchGamestartAni = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_matchstart")
        self.matchGamestartAni:setLocalZOrder(5)
        --self.matchGamestartAni:setPosition(cc.p(display.cx,display.height/5*3))
        self.matchGamestartAni:setPosition(cc.p(self.hPanelImageWidge:getContentSize().width/2,display.height/5*3))
        if laixia.LocalPlayercfg.LaixiaMatchRoomType == 0 then --mtt播放第一阶段的动画
            self.root:runAction(cc.Sequence:create(
                cc.DelayTime:create(3/4),
                cc.CallFunc:create(
                    function()   
                        --第一阶段动画
                        self.firststageAni = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_firststage")
                        self.firststageAni:setLocalZOrder(5)
                        self.firststageAni:setPosition(cc.p(self.hPanelImageWidge:getContentSize().width/2,display.height/5*3))
                    end),nil))  
        end
    end
end 


--点击邀请微信好友
function  CardTableDialog:OnRequestPengyou(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)

        local tableid = self.hDeskID 

        local title = "我的房间号:" .. tableid .."，速来一战！"
        local Url = "http://wx.laixia.com/download"
        local description ="来下斗地主免费赢话费，时时赢微信红包！"
        local flag = 0 -- 0 分享好友  1 分享好友圈


        --分享链接
        if device.platform == "android" then
            local luaj = require "cocos.cocos2d.luaj"
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "wxShare"
            local javaParams = {title,Url ,description,flag }
            local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
            local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            return value
        else--苹果包
            local args = {title = title, Url =Url,description=description,flag = flag }
            local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendLinkContent", args);
            print("wangtianye")
            print(state )
            print(value)
        end
    end
end

--更-新-继-续-游-戏-的-自-建-桌-界-面
function CardTableDialog:OnConSelfBuildFunction(msg)
    self:InitSelfBuildFunc()
    self:OnRefreshSelfBuildUIFunction(msg)
end

--同-步-自建-桌-的-界-面-显-示-局-数-显-示
function CardTableDialog:OnSelfSyncFunc(msg)
    
    if msg.RoomID  == 50  then
        --自建的是癞子场还是欢乐场
         self:GetWidgetByName("Image_SelfBuild"):setVisible(true)

         if 0 == msg.RoomType then
            self.mPokerDeskType = 0
            -- self.Image_RoomInfo:loadTexture("table_title_huanlechang.png",1)
        elseif 1 == msg.RoomType then
            self.mPokerDeskType = 1
            -- self.Image_RoomInfo:loadTexture("table_title_laizichang.png",1)
        elseif 2 == msg.RoomType then
            self.mPokerDeskType = 2
            -- self.Image_RoomInfo:loadTexture("table_title_jidianchang.png",1)
        else 
             self.mPokerDeskType =4
        end

    end

    if msg.TotalInning == 0 then
       return
    end
      laixia.LocalPlayercfg.LaixiaSelfTotalInning = msg.TotalInning
      laixia.LocalPlayercfg.LaixiaSelfInning =  msg.Inning

      local Inning =  laixia.LocalPlayercfg.LaixiaSelfInning 
      if (Inning ~= false ) then
        self.mSelfCount = Inning
        self.mCountNode:setString("第"..Inning.."副")
      end

  local  headBG = {}
  table.insert(headBG,self.hMyTouxiangFrmaeWidge  )
  table.insert(headBG,self.mLeftHeadBG  )
  table.insert(headBG,self.mRightHeadBG )

   for i,v in ipairs(headBG) do 
        self:GetWidgetByName("Label_isRealdy",v ):setVisible(false)
        self:GetWidgetByName("Image_AddFriend",v ):setVisible(false)
   end
   local  myseat = nil 

    for i,v in ipairs( msg.Players)  do 
          if v.PID == laixia.LocalPlayercfg.LaixiaPlayerID then
               myseat = v.Seat
            break
         end
   end

   for i,v in ipairs( msg.Players)  do
       if msg.MasterID == v.PID then
            local seat = v.Seat
            if myseat == ( seat + 4 )%3  then
               self:GetWidgetByName("Image_Master",self.mLeftHeadBG ):setVisible(true)
            elseif myseat == ( seat + 2 )%3  then
                self:GetWidgetByName("Image_Master",self.mRightHeadBG ):setVisible(true)
            end 
       end
   end
   
   -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("table_bisai_jifen.png", 1)
   -- self:GetWidgetByName("Image_LeftBG"):loadTexture("table_bisai_jifen.png", 1)
   -- self:GetWidgetByName("Image_RightBG"):loadTexture("table_bisai_jifen.png", 1)
   
   -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("/res/new_ui/CardTableDialog/jifen_icon.png")
   -- self:GetWidgetByName("Image_LeftBG"):loadTexture("/res/new_ui/CardTableDialog/jifen_icon.png")
   -- self:GetWidgetByName("Image_RightBG"):loadTexture("/res/new_ui/CardTableDialog/jifen_icon.png")
   self:GetWidgetByName("Button_GoShop"):setVisible(false)
   
end



function CardTableDialog:OnRefreshUIinExitFunction(msg)
    local mySeat = self.mMySeatID
    local data = msg.data

    local exitSeat = data.Seat
    local exitBG = nil 

    if mySeat == ( exitSeat + 4 )%3  then

            exitBG =   self.mLeftHeadBG
            self.mLeftHead:removeAllChildren()
            self.mLeftHead:loadTexture("img_null.png",1)
            self:GetWidgetByName("Image_LeftHeadCard"):setVisible(false)
            self.mLeftNum :setVisible(false)
    elseif mySeat == ( exitSeat + 2 )%3  then

            exitBG =   self.mRightHeadBG
            self.mRightHead:removeAllChildren() 
            self.mRightHead:loadTexture("img_null.png",1)  
            self.mRightNum :setVisible(false)
            self:GetWidgetByName("Image_RightHeadCard"):setVisible(false)
    end
    --隐藏昵称和携带金币
    for i=1,2  do
        local infoBg = "Image_UserInfo_Bg_0"..i
        self:GetWidgetByName(infoBg,exitBG):setVisible(false)
    end
    self:GetWidgetByName("Label_isRealdy",exitBG ):setVisible(false)
    self:GetWidgetByName("Image_AddFriend",exitBG ):setVisible(true)
end

--发-送-解-散-牌-桌
function CardTableDialog:OnSendBuildDeleteFunction(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        -- if self.mMasterID == laixia.LocalPlayercfg.LaixiaPlayerID then
            local onSendDelTable = l_PacketObj.new("onSendJoinTable", _LAIXIA_PACKET_CS_CreateDelID)
            onSendDelTable:setValue("TableID", self.hDeskID );--self.hDeskID
            onSendDelTable:setValue("status",1)--我是房主 
            laixia.net.sendPacket(onSendDelTable)
        -- else
        --   sender:setVisible(false)
        --   ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"只有房主才能解散房间") 
        -- end
       
    end
end

--更-新-自-建-桌-的--界-面
--地-主-头-像
function CardTableDialog:OnRefreshSelfBuildUIFunction(msg)

    local ismaster = "Image_Master"
    local addFriend = "Image_AddFriend"
    local boosID = self.mMasterID --房主id

    local mySeat = 0     --自己的座位
    self.SelfPlayers = msg.data.Players
    for i,v in ipairs(msg.data.Players) do
       if v.Pid == laixia.LocalPlayercfg.LaixiaPlayerID then
             mySeat =  v.Seat
            break
       end
    end
     if self.mSelfRoomID == 50  then
         --托管置灰
        self:GetWidgetByName("Button_CancelTrusteeship"):setTouchEnabled(false)
        self:GetWidgetByName("Button_CancelTrusteeship"):setEnabled(false)
        self:GetWidgetByName("Button_CancelTrusteeship"):setBrightStyle(1)
        self:GetWidgetByName("Image_LeftDizhu"):setVisible(false)
        self:GetWidgetByName("Image_RightDizhu"):setVisible(false)
        self:GetWidgetByName("Image_SelfDizhu"):setVisible(false)

        self.mMySeatID = mySeat  --初始化自己的位置
     end

    --有人进来或者离开 需要把钱和头像和名字 去掉
    self.mLeftInfoName:setString("")
    self.mRightInfoName:setString("")
    
    for i,v in ipairs(msg.data.Players) do

        if v.Pid == laixia.LocalPlayercfg.LaixiaPlayerID then
           --self:OnRefreshHeadIconFunction(self.mSelfHead,v.Pid,v.Icon)
    
           if v.IsReady == 1 then
              self:GetWidgetByName("Label_isRealdy",self.hMyTouxiangFrmaeWidge ):setVisible(true)
           end
        elseif mySeat == ( v.Seat + 4 )%3  then
            self.mLeftInfoName:setString(laixia.helper.StringRules_6(v.Nickname))
            self:GaibianShuziWenbenFunction(self.mLeftInfoGold,v.Coin)
            self.mLeftHead.Sex=v.Sex
            self:OnRefreshHeadIconFunction(self.mLeftHead,v.Pid,v.Icon)
            --显示房主标签
            if boosID == v.Pid then
               self:GetWidgetByName(ismaster,self.mLeftHeadBG ):setVisible(true)
            end
            --显示昵称和携带金币
            for i=1,2  do
                local infoBg = "Image_UserInfo_Bg_0"..i
                self:GetWidgetByName(infoBg,self.mLeftHeadBG):setVisible(true)
            end

           if v.IsReady == 1 then
              self:GetWidgetByName("Label_isRealdy",self.mLeftHeadBG ):setVisible(true)
           end
            self:GetWidgetByName(addFriend,self.mLeftHeadBG):setVisible(false)
        elseif mySeat == ( v.Seat + 2 )%3  then
            self.mRightInfoName:setString(laixia.helper.StringRules_6(v.Nickname))
            self:GaibianShuziWenbenFunction(self.mRightInfoGold,v.Coin)
            self.mRightHead.Sex=v.Sex 
            self:OnRefreshHeadIconFunction(self.mRightHead,v.Pid,v.Icon) 
            
            if boosID == v.Pid then   --如果id号是房主，则显示ID
               self:GetWidgetByName(ismaster,self.mRightHeadBG ):setVisible(true)
            end
            
            --显示昵称和携带金币
            for i=1,2  do
                local infoBg = "Image_UserInfo_Bg_0"..i
                self:GetWidgetByName(infoBg,self.mRightHeadBG):setVisible(true)
            end
           if v.IsReady == 1 then
              self:GetWidgetByName("Label_isRealdy",self.mRightHeadBG ):setVisible(true)
           end
            self:GetWidgetByName(addFriend,self.mRightHeadBG):setVisible(false)   
        end

    end
     if self.mSelfRoomID == 50  then
         --托管置灰
        self:GetWidgetByName("Button_CancelTrusteeship"):setTouchEnabled(false)
        self:GetWidgetByName("Button_CancelTrusteeship"):setEnabled(false)
        self:GetWidgetByName("Button_CancelTrusteeship"):setBrightStyle(1)
        --改为积分图标
        self.mGoldBG :setVisible(true)
        self.mIntegralBG:setVisible(false)
        self.mRankingBG:setVisible(false)
        self:GetWidgetByName("Button_Talk"):setVisible(false)
        self.selfinfo = self:GetWidgetByName("SelfHeadInfo")
        self.selfjifen = self:GetWidgetByName("Image_GoldBG", self.selfinfo)
        self:GetWidgetByName("Image_27",self.selfjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
        -- self:GaibianShuziWenbenFunction(self.mGold,0)
      -- self:GetWidgetByName("Label_Current_Coin",self.selfjifen):setString("0")

        self.leftinfo = self:GetWidgetByName("LeftHeadPInfo")
        self.leftjifen = self:GetWidgetByName("Image_GoldBG", self.leftinfo)
        self:GetWidgetByName("Image_27_Copy",self.leftjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
       -- self:GetWidgetByName("Label_LeftInfoGold",self.leftinfo):setString("0")

        self.rightinfo = self:GetWidgetByName("RightHeadInfo")
        self.rightjifen = self:GetWidgetByName("Image_GoldBG_Copy", self.rightinfo)
        self:GetWidgetByName("Image_27_Copy_Copy",self.rightjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
       -- self:GetWidgetByName("Label_RightInfoGold",self.rightinfo):setString("0")
      end

end
--自-己-的-牌-重-置
function CardTableDialog:OnResetMyCardsFunction(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:GameSetPlayStyleFunction(false)
        self.mShowToLobby:setVisible(false)
        if self.mSelfPokers then
            self.mSelfPokers:recover()
        end
    end
end
function CardTableDialog:OnDisplayLobbyFunction(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.mShowToLobby:setVisible( not self.mShowToLobby:isVisible())
    end
end

function CardTableDialog:OnShowLabelRoundFunction(roomID)
    if roomID==50 then --自建房
        self.mTimes:setVisible(true)
        self.mResultNum:setVisible(true)
        self.mTimes:setString(0)
        self.mResultNum:setString(self.BaseScore)
        return
    end
    local roomInfo = l_RoomDataMgr:query("roomid",roomID);
    if roomInfo and roomInfo.round and roomInfo.round~=0 and  roomInfo.prize and roomInfo.prize~=0 then 
        local tips = "每" .. roomInfo.round .. "局送" .. roomInfo.prize .. "奖券"
        self.mTimes:setVisible(true)
        self.mResultNum:setVisible(true)
        self.mTimes:setString(0)
        self.mResultNum:setString(roomInfo["baseScore"])
    else
        if roomID==laixia.config.LAIXIA_SUPERROOM_ID then
            roomInfo = l_RoomDataMgr:query("roomid",1)
            self.mTimes:setVisible(true)
            self.mResultNum:setVisible(true)
            self.mTimes:setString(0)
            self.mResultNum:setString(roomInfo["baseScore"])
        else
            self.mTimes:setVisible(true)
            self.mTimes:setString(0)
        end
    end 
end

function CardTableDialog:onHeadDoSuccess(msg)
    -- if laixia.LocalPlayercfg.LaixiaCurrentWindow ~= "CardTableDialog" then
    --     return
    -- end
    local data = msg.data    
    local mHeadInUse = data.savePath
    --local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. mHeadInUse
    local fileExist = cc.FileUtils:getInstance():isFileExist(mHeadInUse)
    print(data.playerID)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        --image_rank_di:loadTexture(mHeadInUse)
        self:addHeadIcon(image_rank_di,mHeadInUse)
    end       
end
----------------------
function CardTableDialog:OnRefreshHeadIconFunction(head,id,icon)
    -- 默认头像图片路径
--    if head == self.mSelfHead then
--        id = laixia.LocalPlayercfg.LaixiaPlayerID
--    end
    -- self.rankIcon = {}
    -- self.rankIcon[tostring(id)] = head
    -- local path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"
    -- if icon ~= nil and icon ~= "" then
    --     -- local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
    --     local localIconName = cc.FileUtils:getInstance():getWritablePath() .. id..".png"
    --     local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    --     if (fileExist) then
    --         local localIconPath = localIconName
    --         self:addHeadIcon(head,localIconPath)
    --     else
    --         self:addHeadIcon(head,path)
    --         local netIconUrl = icon
    --         l_OPHIDObject:pushTask(id, netIconUrl,1)
    --     end
    -- else
    --     self:addHeadIcon(head,path)

    -- end

    --self.rankIcon = {}
    self.rankIcon[tostring(id)] = head
    local path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"
    local localIconName = cc.FileUtils:getInstance():getWritablePath() .. id..".png"
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    if fileExist then
        local localIconPath = localIconName
        self:addHeadIcon(head,localIconPath)
    elseif icon ~= nil and icon ~= "" then
        self:addHeadIcon(head,path)
        local netIconUrl = icon
        l_OPHIDObject:pushTask(id, netIconUrl,1)
    else
        self:addHeadIcon(head,path)
    end

end        

function CardTableDialog:addHeadIcon(head_btn,path)
    --local head_btn = self:GetWidgetByName("Image_Head_Frame")
    if (head_btn == nil or head_btn == "") then
        return
    end
    -- head_btn:removeAllChildren()
    local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
    laixia.UItools.addHead(head_btn, path, templet)
    -- local sprite = display.newSprite(path)
    -- sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
    -- sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
    -- sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
    -- head_btn:addChild(sprite)
end
----------------------
-- function CardTableDialog:OnRefreshHeadIconFunction(head,id,icon)
--     print("OnRefreshHeadIconFunction-----")
--     print(id)
--     if self.isShow then
--         -- 默认头像图片路径
--         local path

--         if head == self.mSelfHead then
--             path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
--             local headIcon = laixia.LocalPlayercfg.LaixiaPlayerHeadPicture;
--             local headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --头像要用的
--             --微信渠道要看头像是否有变化
--             if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--                 headIcon = nil
--                 headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--                 laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--                 laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
--                 laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")
                
--             end


--             print("self----head")
--             print(headIcon)
--             print(headIcon_new)

--             if headIcon ~= nil  and headIcon ~= "" then
--                 local testPath
--                 if string.find(headIcon,".png") then
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon
--                 else
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon..".png"
--                 end
--                 local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)
--                 if (fileExist) then
--                     path = testPath
--                 else
--                     laixia.LocalPlayercfg.LaixiaPlayerHeadPicture = nil                
--                 end
--             elseif headIcon_new ~= nil and headIcon_new ~= "" then
--                 local testPath
--                 if string.find(headIcon_new,".png") then
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png" 
--                 else
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png" 
--                 end
--                 print(testPath)

--                 local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)

--                 print(fileExist)
--                 if (fileExist) then
--                     path = testPath
--                 else
--                 --下载图片
--                     print("alexwang---CardTableDialog downloading")
--                     print(laixia.config.HEAD_URL )
--                     local headIconUrl = laixia.config.HEAD_URL 
--                     l_OPHIDObject:pushTask(id, headIconUrl,2)
--                 end
--             end
-- --              if icon and icon ~= "" then
-- -- --                local localIconName = l_OPHIDObject:SplitLastStr(icon, "/")
-- --                 local localIconName = cc.FileUtils:getInstance():getWritablePath()..id..".png"
-- --                 local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
-- --                 if (fileExist) then
-- -- --                    local localIconPath
-- -- --                    if string.find(localIconName, ".png") then
-- -- --                        localIconPath = cc.FileUtils:getInstance():getWritablePath() .. localIconName
-- -- --                    else
-- -- --                        localIconPath = cc.FileUtils:getInstance():getWritablePath() .. localIconName .. ".png"
-- -- --                    end
-- --                     path = localIconName
-- --                 else
-- --                     --下载图片
-- --                     local netIconUrl = icon
-- --                     l_OPHIDObject:pushTask(id, netIconUrl,1)
-- --                 end
-- --             end
--         else
--              path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"

-- --            --微信渠道要看头像是否有变化
--             if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--                 headIcon = nil
--                 headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--                 laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--                 laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
--                 laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")
-- --                
--             end

--             print("wangtianye -----")
--             print(id)
--             if icon and icon ~= "" then
-- --                local localIconName = l_OPHIDObject:SplitLastStr(icon, "/")
--                 local localIconName = cc.FileUtils:getInstance():getWritablePath()..id..".png"
--                 local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
--                 if (fileExist) then
--                     path = localIconName
--                 else
--                     --下载图片
--                     local netIconUrl = icon
--                     l_OPHIDObject:pushTask(id, netIconUrl,1)
--                 end
--             end
--         end
--         -- -- 先删除旧头像
--          head:removeAllChildren()
--         -- -- 再添加新头像
--         local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
--         laixia.UItools.addHead(head, path, templet)
--         --  head:setScale(96/106)
--         -- local sprite = display.newSprite(path) 
--         -- sprite:setScaleX(head:getContentSize().width/sprite:getContentSize().width)
--         -- sprite:setScaleY(head:getContentSize().height/sprite:getContentSize().height)
--         -- sprite:setPosition(head:getContentSize().width/2,head:getContentSize().height/2)
--         -- head:addChild(sprite)
--     end
-- end 

function CardTableDialog:OnNewHeadXiazaiFunction(msg)

    if self.isShow then
        local data = msg.data    
        local mHeadInUse = data.savePath;
        local players = {}
        if self.SelfPlayers then --不是重连上来
        		players = self.SelfPlayers
	           for index = 1,3 do
	                if self.mMySeatID == players[index].Seat then              --我自己
	                    self.myPID = players[index].Pid -- 玩家自己的pid
	                end
	                if self.mMySeatID == (players[index].Seat + 4)%3 then       --左边玩家
	                    self.leftPID = players[index].Pid 
	                    self.mLeftHead.PID = players[index].Pid
	                    self:OnRefreshHeadIconFunction(self.mLeftHead,players[index].Pid,players[index].Icon)
	                end
	                if self.mMySeatID == (players[index].Seat + 2)%3 then        --右边玩家
	                    self.rightPID = players[index].Pid 
	                    self.mRightHead.PID = players[index].Pid
	                    self:OnRefreshHeadIconFunction(self.mRightHead,players[index].Pid,players[index].Icon)
	                end
	        	end
        elseif self.mSynchronousData then --是重连上来的
            players = self.mSynchronousData.Players
        	for index = 1,3 do
                if self.mMySeatID == players[index].Seat then              --我自己
                    self.myPID = players[index].PID -- 玩家自己的pid
                end
                if self.mMySeatID == (players[index].Seat + 4)%3 then       --左边玩家
                    self.leftPID = players[index].PID 
                    self.mLeftHead.PID = players[index].PID
                    self:OnRefreshHeadIconFunction(self.mLeftHead,players[index].PID,players[index].Icon)
                end
                if self.mMySeatID == (players[index].Seat + 2)%3 then        --右边玩家
                    self.rightPID = players[index].PID 
                    self.mRightHead.PID = players[index].PID
                    self:OnRefreshHeadIconFunction(self.mRightHead,players[index].PID,players[index].Icon)
                end
        	end
        end
        
--        if self.mLeftHead.PID == data.playerID then
--            self:OnRefreshHeadIconFunction(self.mLeftHead,data.playerID,mHeadInUse)
--        elseif self.mRightHead.PID == data.playerID then
--            self:OnRefreshHeadIconFunction(self.mRightHead,data.playerID,mHeadInUse)
--        end
    end
end

function CardTableDialog:OnWaitingAniFunction()
    if self.isShow then
        -- self.Panel_waittingAni:setVisible(true)
        if self.mSelfRoomID ~= 50 and self.mPokerDeskType ~= 4 then
            local system = laixia.ani.CocosAnimManager
            self.matchingAni = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_matching")
            self.matchingAni:setLocalZOrder(5)
            self.matchingAni:setPosition(cc.p(self.hPanelImageWidge:getContentSize().width/2,display.height/5*3))
        end
    end
end
function  CardTableDialog:OnWaitingAniFunctionForDingshiMatch()
    if self.isShow then
        -- self.Panel_waittingAni:setVisible(true)
        if self.mSelfRoomID ~= 50 and self.mPokerDeskType ~= 4 then
            local system = laixia.ani.CocosAnimManager
            self.laterAni = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_later")
            self.laterAni:setLocalZOrder(5)
            self.laterAni:setPosition(cc.p(self.hPanelImageWidge:getContentSize().width/2,display.height/5*3))
        end
    end
end

--  0:常规斗地主 1：癞子斗地主 2：经典斗地主 4：比赛桌
function CardTableDialog:SetCardTableSytle(info)
    if info ~= nil then
        self.mRoomID = info
        if info == 1 or info == 2 or info == 3 or info == 4 or info == laixia.config.LAIXIA_SUPERROOM_ID then
            self.mPokerDeskType = 0
            self:OnShowLabelRoundFunction(info)
            -- self.Image_RoomInfo:loadTexture("table_title_huanlechang.png",1)
        elseif info == 5 or info == 6 or info == 7 or info == 8 then
            self.mPokerDeskType = 1
            self:OnShowLabelRoundFunction(info)
            -- self.Image_RoomInfo:loadTexture("table_title_laizichang.png",1)
        elseif info == 9 or info == 10 or info == 11 or info == 12 then
            self.mPokerDeskType = 2
            self:OnShowLabelRoundFunction(info)
            -- self.Image_RoomInfo:loadTexture("table_title_jidianchang.png",1)
        elseif info == 50 then   --自建桌
            -- self.Image_RoomInfo:loadTexture("img_null.png",1)
            --这里也要显示底分
            self:OnShowLabelRoundFunction(info)
        elseif info ==127 then  --比赛
            self.mPokerDeskType = 4
            -- self.Image_RoomInfo:loadTexture("table_title_bisaichang.png",1)
        end
    else
        -- self.Image_RoomInfo:setVisible(false)
        self.mPokerDeskType = 0
    end
end

function CardTableDialog:onDestroy()
    laixia.soundTools.stopMusic()
    if self.dizhupao then
        self.dizhupao:setVisible(false)
        self.dizhupao:removeFromParent()
        self.dizhupao = nil
    end
    self.root:stopAllActions()
    self:clearData()
    self.isShow = false
    self.isHaveDiZHu = false
    self:SetCardTableSytle(0)
    self.hDeskID = -1
    self.mTipsErrorCardType = nil
    self.mTipsBiggerCard = nil
    self.mTipsErrorCardType = nil
    self.mLeftHandle = nil
    self.mRightHandle = nil 
    self.mSelfHandle = nil 
    self.mPlay = nil 
    self.mLeftNum = nil 
    self.mRightNum = nil
    self.hMyTouxiangFrmaeWidge = nil
    self.mSelfHead = nil
    self.mLeftHead = nil
    self.mLeftHeadBG = nil
    self.mLeftLeave = nil
    self.mRightHeadBG = nil
    self.mRightHead = nil
    self.mRightHeadRole = nil
    self.mRightLeave = nil
    self.mThebeBar = nil
    self.mThreePoint = nil
    self.mPassPoint = nil
    self.mGrabBar = nil
    self.mGrab = nil
    self.mUngrab = nil
    self.mPlayBar = nil
    self.mPass = nil
    self.mHint = nil
    self.mPlay = nil
    self.mDouble = nil
    self.mTimes = nil
    self.mResultNum = nil
    self.mCancelTrusteeship = nil
    self.mTaskClose = nil
    self.mTaskGiftNum = nil
    self.mTaskDes = nil
    self.mTaskProgress = nil
    self.mTask = nil
    self.mTaskTipNum = nil
    self.hTouxiangImageWidge = nil
    self.mGold = nil
    self.isShowThebeBar = nil

    self.mHaveCardCountButton = nil 
    self.mCardCountImg = nil
    self.mCardCountTable = nil  --自身是个表
    self.mRightInfoGold = nil
    self.mRightHeadRole = nil
    if self.mTime ~= nil then
        self.mTime:removeFromParent()
        self.mTime = nil
    end
    self.mClock = nil 
    if self.mScheduler ~= nil then
        scheduler.unscheduleGlobal(self.mScheduler)
        self.mScheduler = nil
    end
    if  self.mEffectLight ~= nil then 
        self.mEffectLight:removeFromParent()
        self.mEffectLight = nil  
    end
    self.mClockAni = nil
    self.nomoney = false
    self.mDeskResult = nil
    self.mRoomID = 0
    laixia.LocalPlayercfg.LaixiaRoomID = 0
    laixia.LocalPlayercfg.LaixiaisConnectCardTable = false 
    self:clearTexture()
    laixia.LocalPlayercfg.LaixiaSelfBuildTable = -1 --初始化自建房ID
    laixia.LocalPlayercfg.LaixiaSelfTotalInning = 0 --初始化自建房次数
    laixia.LocalPlayercfg.LaixiaSelfInning =  0
end 

function CardTableDialog:clearTexture()
    self:HideAnimationFunction()

    -- display.removeSpriteFramesWithFile( "qiangdaodizhu1.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("qiangdaodizhu1.png")
    
    -- display.removeSpriteFramesWithFile( 'new_animation/liandui0.plist')
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey('new_animation/liandui0.png')
    
    -- display.removeSpriteFramesWithFile( 'new_animation/feiji0.plist')
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey('new_animation/feiji0.png')

    -- display.removeSpriteFramesWithFile( 'new_animation/shunzi0.plist')
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey('new_animation/shunzi0.png')


    -- display.removeSpriteFramesWithFile( "new_animation/zhadan0.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("new_animation/zhadan0.png")
    
    -- display.removeSpriteFramesWithFile( "new_animation/huojian0.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("new_animation/huojian0.png")
    

    -- display.removeSpriteFramesWithFile( "ming.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ming.png")
    
    -- display.removeSpriteFramesWithFile( "win_big.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("win_big.png")
    


    -- display.removeSpriteFramesWithFile( "ccbResources/shengli/shengli.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbResources/shengli/shengli.png")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbResources/shengli/guang.png")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbResources/shengli/hstar.png")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbResources/shengli/sidai.png")
    -- display.removeSpriteFramesWithFile( "ccbResources/shibai/shibai.plist")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbResources/shibai/shibai.png")
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("ccbResources/shibai/sidai.png")

    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("baozha.png")
end

function CardTableDialog:clearData(msg)
    if self.isShow ~= true then
        return
    end
    if self.mTipsBiggerCard ~= nil then
        self.mTipsBiggerCard:setVisible(false)
    end
    if self.mTipsErrorCardType ~= nil then
        self.mTipsErrorCardType:setVisible(false)
    end
    if self.mLeftHandle ~= nil then
        self.mLeftHandle:setVisible(false)
    end
    if self.mRightHandle ~= nil then
        self.mRightHandle:setVisible(false)
    end
    if self.mSelfHandle ~= nil then
        self.mSelfHandle:setVisible(false)
    end

    self:OnRecHeadSizeFunction(self.mSelfHead )
    self:OnRecHeadSizeFunction(self.mLeftHead)
    self:OnRecHeadSizeFunction(self.mRightHead)
    --self:OnRefreshHeadIconFunction(self.mSelfHead,nil,nil)

    self.mLeftHead.PID = -1
    self.mRightHead.PID = -1

    if self.mLeftNum ~= nil then
        self.mLeftNum:setString(0)
        self.mLeftNum:setVisible(false)
    end
    if self.mRightNum ~= nil then
        self.mRightNum:setString(0)
        self.mRightNum:setVisible(false)
    end

    self.isDownState = 0  --0:初始化 1 触发降级条件
    self.isDealAni = false
    self.isHaveDiZHu = false
    self.mNowType   = nil
    self.mPreviousType = nil 
    self.mIndex = 1
    self.mTips = {}
    self.mCardType = nil
    self.mNewOutType = 0

    self.mLocalTime = nil
    self.mBottomPID = -1
    self.mOutPokersIndex = nil
    self.mDiscardCards = nil
    if self.mSelfPokers ~= nil then
        --防止选中的牌没有删掉
        self.mSelfPokers.mPokerList = {}
        self.mSelfPokers:removeFromParent()
        self.mSelfPokers = nil
    end
    if self.mLeftPlayerPoker ~= nil then
        self.mLeftPlayerPoker:removeFromParent()
        self.mLeftPlayerPoker = nil
    end
    if self.mRightPlayerPoker ~= nil then
        self.mRightPlayerPoker:removeFromParent()
        self.mRightPlayerPoker = nil
    end
    if self.mSelfOutPokersLayer ~= nil then
        self.mSelfOutPokersLayer:removeFromParent()
        self.mSelfOutPokersLayer = nil
    end
    if self.mRightPlayerOutPokersLayer ~= nil then
        self.mRightPlayerOutPokersLayer:removeFromParent()
        self.mRightPlayerOutPokersLayer = nil
    end
    if self.mLeftPlayerOutPokersLayer ~= nil then
        self.mLeftPlayerOutPokersLayer:removeFromParent()
        self.mLeftPlayerOutPokersLayer = nil
    end
    if  self.mSelfPlayerClearPokersLayer ~= nil then
        self.mSelfPlayerClearPokersLayer:removeFromParent()
        self.mSelfPlayerClearPokersLayer = nil
    end
    if self.mRightPlayerClearPokersLayer ~= nil then
        self.mRightPlayerClearPokersLayer:removeFromParent()
        self.mRightPlayerClearPokersLayer = nil
    end
    if  self.mLeftPlayerClearPokersLayer ~= nil then
        self.mLeftPlayerClearPokersLayer:removeFromParent()
        self.mLeftPlayerClearPokersLayer = nil
    end
    if self.mSelfTalk ~= nil then
        self.mSelfTalk:removeFromParent()
        self.mSelfTalk = nil  
    end
    if self.mRightTalk ~= nil then
        self.mRightTalk:removeFromParent()
        self.mRightTalk = nil  
    end
    if self.mLeftTalk ~= nil then
        self.mLeftTalk:removeFromParent()
        self.mLeftTalk = nil  
    end
    if self.matchingAni then
        self.matchingAni:removeFromParent()
        self.matchingAni = nil
    end
    if self.laterAni then
        self.laterAni:removeFromParent()
        self.laterAni = nil
    end
    self:HideAnimationFunction()
    self.mEffect = nil
    self.mEffect = {}
    if self.mPokersNumAlarmTable ~= nil then
        for index = 1,#self.mPokersNumAlarmTable do
            self.mPokersNumAlarmTable[index] = false
        end
    end
    self.mClockTime = 0
    self.mStageStep = nil
    laixia.LocalPlayercfg.LaixiaOutCards = nil
    laixia.LocalPlayercfg.LaixiaOutCardsIndex = nil
    self.mDeskResult = nil
    self.mSynchronousData = nil 
    self.mStageStep = nil
    self.IsKingBombFunction = -1
    self.mMySeatID = -1
    laixia.LocalPlayercfg.LaixiaMySeat = -1
    laixia.LocalPlayercfg.LaixiaLandlordSeat = -1

    laixia.LocalPlayercfg.LaixiaOutCardsCount = 0
    self.intoWindowsData = nil


    if self:GetWidgetByName("Image_BottomPoker1") ~= nil and self:GetWidgetByName("Image_BottomPoker2") ~= nil and self:GetWidgetByName("Image_BottomPoker3") ~= nil then
        self:GetWidgetByName("Image_BottomPoker1"):setVisible(true)
        self:GetWidgetByName("Image_BottomPoker2"):setVisible(true)
        self:GetWidgetByName("Image_BottomPoker3"):setVisible(true)
    end
    for i = 4,7 do
        if self.mBottomPoker ~= nil and self.mBottomPoker[i] ~= 0 then
            self.mBottomPoker[i]:removeFromParent()
            self.mBottomPoker[i] = 0
        end
    end

    for i = 1,3 do
        self.mBottomPoker[i]:setPositionX(637+(i-2)*56)
    end
    self.bDelInfoDisplay = false
    laixia.LocalPlayercfg.LaixiaLaiziReplaceCards={} -- 清理牌桌的时候一定要吧癞子匹配的牌清理了，否则会出现数值污染
    self.hLaiziCard =-1
    if (self.mPokerDeskType ~=1 and self.mPokerDeskType ~=2 and self.mPokerDeskType ~=0) and self.mTimes  ~= nil then
        self.mTimes:setVisible(false)
    end
    if (self.mPokerDeskType ~=1 and self.mPokerDeskType ~=2 and self.mPokerDeskType ~=0) and self.mResultNum  ~= nil then
        self.mResultNum:setVisible(false)
    end
    if self.mLeftNum ~= nil then
        self.mLeftNum:setVisible(false)
    end
    if self.mRightNum ~= nil then
        self.mRightNum:setVisible(false)
    end
    if self.mClock ~= nil  then
        self:DisplayWhichClockFunction(0)
    end
    if self.mRightNumAlarm ~= nil then
        self.mRightNumAlarm:removeFromParent()
        self.mRightNumAlarm = nil
    end
    if self.mLeftNumAlarm ~= nil then
        self.mLeftNumAlarm:removeFromParent()
        self.mLeftNumAlarm = nil
    end

    if self.mLeftHeadBG ~= nil then
        self.mLeftHeadBG:setVisible(false)
    end
    if self.mRightHeadBG ~= nil then
        self.mRightHeadBG:setVisible(false)
    end

    if self.mRightHeadRole ~= nil then
        self.mRightHeadRole:setVisible(false)
    end

    if self.mCallPointBar ~= nil then
        self:ChangeTouchbarFunction(self.mCallPointBar, false)
    end


    if self.mPointArray ~= nil and (#self.mPointArray >0 )  then
      for i=2 ,#self.mPointArray do
          local bt = self.mPointArray[i]
          bt:setTouchEnabled(true)
          bt: setBright(true)
          local num = i -1 
          -- local icon = self:GetWidgetByName("Image_Button",bt)
          -- local imgPath =  "table_btn_"..num.."fen.png"   
          -- icon:loadTexture(imgPath,1)
            self:ChangButBrightFunction(true,bt)
      end
      
    end
    if self.mThebeBar ~= nil then
        self:ChangeTouchbarFunction(self.mThebeBar, false)
    end
    if self.mGrabBar ~= nil then
        self:ChangeTouchbarFunction(self.mGrabBar, false)
    end
    if self.mPlayBar ~= nil then
        self:ChangeTouchbarFunction(self.mPlayBar, false)
    end 
    if self.mIsDouble~= nil then 
        self.mIsDouble:setVisible(false)
    end 

    if self.mLeftTuoguan ~= nil then 
        self.mLeftTuoguan:setVisible(false)
    end 

    if self.mRightTuoguan ~= nil then 
        self.mRightTuoguan:setVisible(false)
    end 

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CHANGE_BUYRECORDER_WINDOW,false); 

end

function CardTableDialog:OnInitSynchronousFunction(msg)
    -- laixia.soundTools.playMusic(laixia.soundcfg.SCENE_MUSIC.nomal,true);
    self.isPlay = true      --正在打牌
    if self.mPokerDeskType == 8 or self.mPokerDeskType == 9 or self.mPokerDeskType == 10 or self.mPokerDeskType == 11 then
        self:GetWidgetByName("Button_BackToLobby"):setTouchEnabled(false)
        self:GetWidgetByName("Button_BackToLobby"):setEnabled(false)
        self:GetWidgetByName("Button_BackToLobby"):setBrightStyle(1)
    end
    self.nomoney=false
    self.isDownState = 0
    self.isDealAni = false      --出牌动画完成
    self.isMingPoker = 0    --0：不名牌 1 ：名牌
    self.mTips = {}    -- 提示信息
    self.mCardType = nil-- 当前出的牌型
    self.mIndex = 1     -- 提示牌型索引
    self.hLaiziCard =-1
    self.mPreviousType = nil --上一个牌型
    self.mNowType   = nil --现在牌型
    self.IsKingBombFunction = -1     --王炸 -1:没有 0，1，2对应座位号
    self.mEffect = {}           --特效表


    self.bDelInfoDisplay = false -- 防止出现数值污染
    laixia.LocalPlayercfg.LaixiaLaiziReplaceCards={} 
    self.mDiscardCards = nil
    if self.isShow ~= true then
        local tCardCountTime
        for i = 1,3 do
            if msg.data.Players[i].PID == laixia.LocalPlayercfg.LaixiaPlayerID then
                tCardCountTime = msg.data.Players[i].CardCountTime
                break
            end 
        end
        local t = {
            Status = 0,
            EnterType = 1,
            TimesTamp = msg.data.TimesTamp,
            CardCountTime = tCardCountTime,
            RoomID = msg.data.RoomID,
            RoomType = msg.data.RoomType,        --添加为了自建桌的字段
            TableID = msg.data.TableID,
            BossID = msg.data.MasterID,
            Count = msg.data.Inning,
            from = "Synchronous"
        }
        self:show({data = t})
    end


       
    self.mSynchronousData = msg.data
    self:SetCardTableSytle(self.mSynchronousData.RoomID)
    self.hDeskID = self.mSynchronousData.TableID
    self.isMingPoker = msg.data.Ming
    self.mStageStep = {   
                        State = msg.data.Stage,
                        Seat = msg.data.CurrentSeat,
                        Times = msg.data.Time*1000 + msg.data.TimesTamp
                        }
    
    self.mLocalTime = l_hTimeObj.gettime()  --本地时间

    self.mSetp =  msg.data.Stage
    self.mLeftHeadBG:setVisible(true)
    self.mRightHeadBG:setVisible(true)
    if msg.data.Info and msg.data.Info~="" then
    end
    --隐藏动画
    self.Panel_waittingAni:setVisible(false)

    for k,v in ipairs(msg.data.Players) do
        --更新地主的pid
        if msg.data.BottomSeat == v.Seat then
            self.mBottomPID = v.PID
        end
        if v.PID == laixia.LocalPlayercfg.LaixiaPlayerID then
            self.mMySeatID = v.Seat
            self.mSelfHead.Sex =v.Sex

            self.mCardCountTime = v.CardCountTime
            if v.CardCountTime > msg.data.TimesTamp or  v.CardCountTime == -1 then
                self.isPlayerHaveCardCountState = 1
                self:isPlayerHaveCardCount(1)
            else
                self.isPlayerHaveCardCountState = 0
                self:isPlayerHaveCardCount(0)
            end
            if  v.CardCountTime ~= 0 then
                self:resetCardCountFunction()
                self:changeCardCountFunction(l_NorLogicObject:OutCountIndexFunction(v.PlayCards,v.PlayerCards ))
            end
            if v.Trust == 1 then
                self.mCancelTrusteeship:setVisible(true)
                self.mCancelTrusteeship:setTouchEnabled(true)
            elseif v.Trust == 0 then 
                self.mCancelTrusteeship:setVisible(false)
                self.mCancelTrusteeship:setTouchEnabled(false)
            end
        elseif laixia.LocalPlayercfg.LaixiaMySeat == ( v.Seat + 4 )%3  then
            self.mLeftInfoName:setString(laixia.helper.StringRules_6(v.Nickname))
            self:GaibianShuziWenbenFunction(self.mLeftInfoGold,v.Coin)
            self.mLeftHead.Sex=v.Sex
            local cards  = v.PlayCards

            for i=1,2  do
                local infoBg = "Image_UserInfo_Bg_0"..i
                self:GetWidgetByName(infoBg,self.mLeftHeadBG):setVisible(true)
            end
            if v.Trust == 1 then
                self.mLeftTuoguan:setVisible(true)
            elseif v.Trust == 0 then 
                self.mLeftTuoguan:setVisible(false)
            end

        elseif laixia.LocalPlayercfg.LaixiaMySeat == ( v.Seat + 2 )%3  then
            self.mRightInfoName:setString(laixia.helper.StringRules_6(v.Nickname))
            self:GaibianShuziWenbenFunction(self.mRightInfoGold,v.Coin)
            self.mRightHead.Sex=v.Sex 
            local cards  = v.PlayCards

            for i=1,2  do
                local infoBg = "Image_UserInfo_Bg_0"..i
                self:GetWidgetByName(infoBg,self.mRightHeadBG):setVisible(true)
            end
            if v.Trust == 1 then
                self.mRightTuoguan:setVisible(true)
            elseif v.Trust == 0 then 
                self.mRightTuoguan:setVisible(false)
            end               
        end
    end
    --叫牌阶段
    if msg.data.Stage == 1 then 
        if msg.data.CurChip == nil then
            print("接锅")
        end
        for i=1, msg.data.CurChip do 
           local bt = self.mPointArray[i+1]
           bt:setTouchEnabled(false)
           bt:setBright(false)
           self:ChangButBrightFunction(false,bt)
        end
    end

    

    if msg.data.isJixu == 1 then --点过继续了
        self.jixuyouxi = 1
        self:OnWaitingAniFunction()
    else
        self.jixuyouxi = 0
    end

    if msg.data.Stage == 3 then
        local count = 0 --
        local topSeatIndex = -1  --上家牌索引
        local nextSeatIndex = -1 --下家牌索引
        local currSeatIndex = -1
        local isHavePlay = false
        for i = 1,3 do
            if msg.data.CurrentSeat == (msg.data.Players[i].Seat + 4)%3 then
                topSeatIndex = i             
            elseif msg.data.CurrentSeat == (msg.data.Players[i].Seat + 2)%3 then
                nextSeatIndex = i
            elseif msg.data.CurrentSeat == msg.data.Players[i].Seat then
                currSeatIndex = i
            end
        end
        laixia.LocalPlayercfg.LaixiaOutCards = {}                       
        laixia.LocalPlayercfg.LaixiaOutCards.Cards = msg.data.Players[topSeatIndex].PlayCards--msg.data.Players[topSeatIndex].DeskCards
        if #laixia.LocalPlayercfg.LaixiaOutCards.Cards == 0 then
           laixia.LocalPlayercfg.LaixiaOutCards.Cards = msg.data.Players[nextSeatIndex].PlayCards
        end

        laixia.LocalPlayercfg.LaixiaOutCards.Seat = msg.data.Players[topSeatIndex].Seat
        laixia.LocalPlayercfg.LaixiaOutCardsIndex = {}
        if #msg.data.Players[topSeatIndex].DeskCards == 0 then
            count  = 1
        else
            isHavePlay = true
            laixia.LocalPlayercfg.LaixiaOutCardsCount = 1 
            laixia.LocalPlayercfg.LaixiaOutCardsIndex = laixia.LocalPlayercfg.LaixiaOutCards.Cards
        end
        if isHavePlay == false then
            if #laixia.LocalPlayercfg.LaixiaOutCards.Cards == 0 then
                count  = 2    --2表示是首发，这块判断太复杂了0706
                laixia.LocalPlayercfg.LaixiaOutCardsCount = 0
            else
                isHavePlay = true
                laixia.LocalPlayercfg.LaixiaOutCardsCount = 1 
                laixia.LocalPlayercfg.LaixiaOutCardsIndex = laixia.LocalPlayercfg.LaixiaOutCards.Cards
            end
        end
        laixia.LocalPlayercfg.LaixiaOutCards.count = count
    end
    self.hTouxiangImageWidge:setVisible(true)


    self.mRightNum:setVisible(true)  
    self.mLeftNum:setVisible(true)      
    self:GetWidgetByName("Image_LeftHeadCard"):setVisible(true)
    self:GetWidgetByName("Image_RightHeadCard"):setVisible(true) 
    self:GetWidgetByName("Button_Talk"):setTouchEnabled(true)
    self:GetWidgetByName("Button_Talk"):setBright(true)
    -- 审核
    if laixia.config.isAudit then
        self:GetWidgetByName("Button_Talk"):setVisible(false)
    end
    self.mLeftLeave:setVisible(false)--初始化拍桌的时候吧托管置成否
    self.mRightLeave:setVisible(false)

    local laizi =self.mSynchronousData.Laizi  -- 这块用来处理底牌的癞子牌
    if laizi ~= nil and laizi>=0 and laizi<=13 then
       self.hLaiziCard = laizi

       local laizit={}
       laizit.CardValue = laizi  

        self.mBottomPoker[7]= l_cardobj.new(laizit)
        self.mBottomPoker[7]:addTo(self.mLaiziBottom:getParent())
        self.mBottomPoker[7]:setPosition(self.mLaiziBottom:getPosition())
        self.mBottomPoker[7]:setScale(0.2)

         for i = 1,3 do
            if self.mBottomPoker[3+i] == 0 then
                self.mBottomPoker[i]:setPositionX(637+(i-2)*56)--630-56+(i-1)*28)
                self.mBottomPoker[i]:setLocalZOrder(i*10)    
            else
                self.mBottomPoker[3+i]:setPositionX(637+(i-2)*56)--630-56+(i-1)*28)
                self.mBottomPoker[3+i]:setLocalZOrder(i*10)              
            end
            self.mBottomPoker[i]:setVisible(false)
        end

    end
    self.mTimes:setVisible(true) 
    self.mResultNum:setVisible(true) 
    self.mLeftNum:setVisible(true)
    self.mRightNum:setVisible(true) 
    self:showHandPokers()
    self:showTimesAndResult()
    self:GameDisplayBarStateFunction()
    self:DisplayOutCardFunction()
    self:showPlayerInfo()
    self:DisplayBottomCardFunction()
    if self.mPokerDeskType == 4 then
        
        self.mGoldBG:setVisible(true)
        self.mIntegralBG:setVisible(false)
        self.mRankingBG:setVisible(true)
        self:GetWidgetByName("Button_Talk"):setVisible(false)

        ----
            self.selfinfo = self:GetWidgetByName("SelfHeadInfo")
            self.selfjifen = self:GetWidgetByName("Image_GoldBG", self.selfinfo)
            self:GetWidgetByName("Image_27",self.selfjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")

            self.leftinfo = self:GetWidgetByName("LeftHeadPInfo")
            self.leftjifen = self:GetWidgetByName("Image_GoldBG", self.leftinfo)
            self:GetWidgetByName("Image_27_Copy",self.leftjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")

            self.rightinfo = self:GetWidgetByName("RightHeadInfo")
            self.rightjifen = self:GetWidgetByName("Image_GoldBG_Copy", self.rightinfo)
            self:GetWidgetByName("Image_27_Copy_Copy",self.rightjifen ):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
        ----
        laixia.LocalPlayercfg.LaixiaSelfBuildIntegral = self.mGold:getString()
        self:GetWidgetByName("Label_Current_Integral",self.mIntegralBG):setString(self.mGold:getString())

        if laixia.LocalPlayercfg.LaixiaMatchStage == 1 then 
            self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名："..laixia.LocalPlayercfg.LaixiaMatchRank.."/"..laixia.LocalPlayercfg.LaixiaMatchTotalNum)
        elseif laixia.LocalPlayercfg.LaixiaMatchStage == 3 then 
            if tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) == 0 and tonumber(laixia.helper.ConvertStrToNum(self.mLeftInfoGold:getString())) == 0
             and tonumber(laixia.helper.ConvertStrToNum(self.mRightInfoGold:getString())) == 0 then
                self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：1/3")
            elseif tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) > tonumber(laixia.helper.ConvertStrToNum(self.mLeftInfoGold:getString())) 
                and tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) > tonumber(laixia.helper.ConvertStrToNum(self.mRightInfoGold:getString())) then
                self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：1/3")
                -- self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：1/3")
                laixia.LocalPlayercfg.NowRankinSNG = 1
            elseif tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) < tonumber(laixia.helper.ConvertStrToNum(self.mLeftInfoGold:getString())) 
            and tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString()))< tonumber(laixia.helper.ConvertStrToNum(self.mRightInfoGold:getString())) then
                self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：3/3")
                laixia.LocalPlayercfg.NowRankinSNG = 3
            else
                self:GetWidgetByName("Label_Current_Integral",self.mRankingBG):setString("当前排名：2/3")
                laixia.LocalPlayercfg.NowRankinSNG = 2
            end
        end 

        -----------
        -----------
        if laixia.LocalPlayercfg.LaixiaMatchStage == 1 or laixia.LocalPlayercfg.LaixiaMatchStage == 2 then
            if laixia.LocalPlayercfg.LaixiaMatchStage == 1 then
                if tonumber(laixia.helper.ConvertStrToNum(self.mGold:getString())) <tonumber(laixia.helper.ConvertStrToNum(self.mResultNum:getString())) * 6 then
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "如果积分低于0，您将被淘汰出局")
                end
            end

            -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("gold_icon.png", 1) --比赛积分图标
            -- self:GetWidgetByName("Image_LeftBG"):loadTexture("gold_icon.png", 1)--比赛积分图标
            -- self:GetWidgetByName("Image_RightBG"):loadTexture("gold_icon.png", 1)--比赛积分图标
            --注
            -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("res/new_ui/CardTableDialog/jifen_icon.png")
            -- self:GetWidgetByName("Image_LeftBG"):loadTexture("res/new_ui/CardTableDialog/jifen_icon.png")
            -- self:GetWidgetByName("Image_RightBG"):loadTexture("res/new_ui/CardTableDialog/jifen_icon.png")
        else
            if laixia.LocalPlayercfg.LaixiaMatchStage == 3 then
                if laixia.LocalPlayercfg.LaixiaMatchlastStage ~= laixia.LocalPlayercfg.LaixiaMatchStage and laixia.LocalPlayercfg.mOfflineMatch == false then
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHFLICKERWORDS_WINDOW, "决赛开始：定局积分")
                end
            end
            -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("gold_icon.png", 1)
            -- self:GetWidgetByName("Image_LeftBG"):loadTexture("gold_icon.png", 1)
            -- self:GetWidgetByName("Image_RightBG"):loadTexture("gold_icon.png", 1)
            --注
            -- self:GetWidgetByName("Image_GoldIcon"):loadTexture("res/new_ui/CardTableDialog/jifen_icon.png")
            -- self:GetWidgetByName("Image_LeftBG"):loadTexture("res/new_ui/CardTableDialog/jifen_icon.png")
            -- self:GetWidgetByName("Image_RightBG"):loadTexture("res/new_ui/CardTableDialog/jifen_icon.png")
        end
        if laixia.LocalPlayercfg.LaixiaMatchName == "" then
            if laixia.LocalPlayercfg.LaixiaMatchlastStage ~= laixia.LocalPlayercfg.LaixiaMatchStage then
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "")
                laixia.LocalPlayercfg.LaixiaMatchlastStage = laixia.LocalPlayercfg.LaixiaMatchStage
            end

            if laixia.LocalPlayercfg.LaixiaMatchDifen < tonumber(self.mResultNum:getString()) then
                laixia.LocalPlayercfg.LaixiaMatchDifen=tonumber(self.mResultNum:getString())
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "底分已增长至" .. self.mResultNum:getString())
            end
        end
        if laixia.LocalPlayercfg.LaixiaMatchName ~= "" then
            if laixia.LocalPlayercfg.mOfflineMatch == true then
                laixia.LocalPlayercfg.mOfflineMatch = false
            elseif laixia.LocalPlayercfg.LaixiaMatchRoomType == 1 then
--                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, laixia.LocalPlayercfg.LaixiaMatchName .. "开始")   -- 进入什么比赛飘字end
            end
             cc.UserDefault:getInstance():setStringForKey("MatchName", laixia.LocalPlayercfg.LaixiaMatchName )
            --laixia.LocalPlayercfg.LaixiaMatchName = ""
        end
        laixia.LocalPlayercfg.LaixiaMatchDifen=tonumber(self.mResultNum:getString())
        laixia.LocalPlayercfg.LaixiaMatchlastStage = laixia.LocalPlayercfg.LaixiaMatchStage
    else
        self.mIntegralBG:setVisible(false)
        self.mRankingBG:setVisible(false)
        self.mGoldBG :setVisible(true)
    end

    if msg.data.Stage > 0 then
        local time = math.floor((self.mStageStep.Times - self.mSynchronousData.TimesTamp)/1000)
        self:DisplayWhichClockFunction(1,time) 
    end
------------------------------------------------------------------------------------------
    local stageStep = {
        ["State"] = msg.data.Stage,
        ["Seat"] = msg.data.CurrentSeat,
        ["Times"] = msg.data.Time,
    }
    if self.mSelfRoomID == 50 then
        self:GetWidgetByName("Button_CancelTrusteeship"):setTouchEnabled(false)
        self:GetWidgetByName("Button_CancelTrusteeship"):setEnabled(false)
        self:GetWidgetByName("Button_CancelTrusteeship"):setBrightStyle(1)
    else
        self:GetWidgetByName("Button_CancelTrusteeship"):setTouchEnabled(true)
    end
    --自建桌的局数显示
    self:OnSelfSyncFunc(msg.data)

end

function CardTableDialog:HideAnimationFunction(aiType)
    if self.isShow ~= true or type(self.mEffect) ~= "table"  then
        return
    end
    for k,v in pairs( self.mEffect ) do
        transition.stopTarget(v)
        v:removeFromParent()
        self.mEffect[k] = nil
    end
end


function CardTableDialog:GaibianShuziWenbenFunction(aiLable,aiGold)
    -- if aiGold < 10000000 then
    --     aiLable:setString(aiGold)
    -- elseif  aiGold < 100000000 then 
    --     aiLable:setString(string.format("%.2f",aiGold/10000).."万") 
    -- else 
    --     aiLable:setString(string.format("%.2f",aiGold/100000000).."亿")                                                                   
    -- end
    aiLable:setString(laixia.helper.numeralRules_2(aiGold))
end

-- 显-示-比-赛-结-算-界-面
function CardTableDialog:ShowResultMatchFunction(mesg) 
    local data = mesg

    for i, v in ipairs(data) do
        local str =""
        local node =nil
        --local  atlasNum
        local atlasNum = ccui.Text:create()
        atlasNum:setFontSize(35)
        atlasNum:setAnchorPoint(0.5,0.5)
        atlasNum:setTextHorizontalAlignment(1)
        atlasNum:setTextVerticalAlignment(1)


        if self.myPID == v.PID then
            self.mGold:setString(v.CurrentGold)
            --self.mGold:setString(laixia.helper.numeralRules_2(v.CurrentGold))
            if v.Chip > 0 then
                str = v.Chip
                --atlasNum = self.winNum
                atlasNum:setString("+"..str)      
            else
                local strNumber = string.split(v.Chip, "-")
                str = strNumber[2]
                if v.Chip == 0 then
                    str = 0
                end
                --atlasNum = self.lostNum:clone()
                atlasNum:setString("-"..str)
            end
            atlasNum:setAnchorPoint(cc.p(0,0.5))
            atlasNum:setPosition(cc.p(200,180))
            transition.fadeOut(atlasNum, {time = 1.5})
        end
        if self.rightPID == v.PID then
           self.mRightInfoGold :setString(v.CurrentGold)
           if v.Chip > 0 then
                str = v.Chip
                --atlasNum = self.winNum:clone()
                atlasNum:setString("+"..str)
            else

                    local strNumber = string.split(v.Chip, "-")
                    str = strNumber[2]
                    if v.Chip == 0 then
                        str = 0
                    end
                    --atlasNum = self.lostNum:clone()
                    atlasNum:setString("-"..str)
            end
            atlasNum:setAnchorPoint(cc.p(0,0.5))
            atlasNum:setPosition(cc.p(1090-atlasNum:getContentSize().width,616))
            transition.fadeOut(atlasNum, {time = 1.5})
        end
        if self.leftPID == v.PID then
           self.mLeftInfoGold:setString(v.CurrentGold)
           if v.Chip > 0 then
                str = v.Chip
                --atlasNum = self.winNum:clone()
                atlasNum:setString("+"..str)
            else

                    local strNumber = string.split(v.Chip, "-")
                    str = strNumber[2]
                    if v.Chip == 0 then
                        str = 0
                    end
                    --atlasNum = self.lostNum:clone()
                    atlasNum:setString("-"..str)
            end
            atlasNum:setAnchorPoint(cc.p(0,0.5))
            atlasNum:setPosition(cc.p(200,616))
            transition.fadeOut(atlasNum, {time = 1.5})
        end
        atlasNum:addTo(self.hPanelImageWidge,5)
               transition.execute(atlasNum, cc.DelayTime:create(2), {
                    delay = 2,
                    onComplete = function()
                        atlasNum:removeFromParent()
                        atlasNum = nil
                    end,
                }) 

    end
end

function CardTableDialog:SpringAnimationFunction(aiData)
    if self.isShow ~= true then
        return
    end
    if self.mStageStep then
        self.mStageStep.State = 5
    end
    self:DisplayWhichClockFunction(0)
--    aiData.data.jixu = self.jixuyouxi
    local misLandloreWin = false --地主是否获胜
    if type(aiData.data) == "table" then
        self.mDeskResult = aiData.data
        self.isWinByDeskResult = false
        for i = 1,3 do
            if laixia.LocalPlayercfg.LaixiaPlayerID == self.mDeskResult.CSBalance[i].PID and self.mDeskResult.CSBalance[i].Chip >= 0  then
                self.isWinByDeskResult = true
            end
        end

        if self.mDeskResult.Status == 1 then
            misLandloreWin = true
        end

        laixia.soundTools.stopMusic()
        if self.isWinByDeskResult then
            laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_event_table_win);
        else
            laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_event_table_lost);
        end
        --显示钱变动和剩余牌的情况
        if (self.mPokerDeskType == 1 or self.mPokerDeskType == 2 or self.mPokerDeskType == 0) then
            self:ChangeGoldFunction(self.mDeskResult)
        else
            self:HideInfoByEndFunction()
        end
    end

    local onShowAnimationfun = cc.CallFunc:create(function ()
         --流局
        if self.mDeskResult.CSBalance[1].Chip==0 and self.mDeskResult.CSBalance[2].Chip==0 and self.mDeskResult.CSBalance[3].Chip==0 then

            local mAnimation = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_LIUJU)
            mAnimation:addTo(self.hPanelImageWidge,5) 

        -- elseif self.isWinByDeskResult == true then  --胜利
        --     local system = laixia.ani.CocosAnimManager
        --     local node = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_victory")
        --     node:setLocalZOrder(10)
        --     node:setPositionX(display.cx)
        --     node:setPositionY(display.top)
        -- else                                          --失败
        --     local system = laixia.ani.CocosAnimManager
        --     local node = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_lost")
        --     node:setLocalZOrder(10)
        --     node:setPositionX(display.cx)
        --     node:setPositionY(display.top)
          elseif (misLandloreWin == true) and (self.isWinByDeskResult == true) then  --地主胜利
                local mAnimation = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_LANDLORD_WIN)
                mAnimation:addTo(self.hPanelImageWidge,5) 
          elseif (misLandloreWin == false) and (self.isWinByDeskResult == false)  then   --地主失败
                local mAnimation = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_LANDLORD_LOST)
                mAnimation:addTo(self.hPanelImageWidge,5) 
          elseif (misLandloreWin == false) and (self.isWinByDeskResult == true)  then   --农民获胜
                local mAnimation = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_FARMER_WIN)
                mAnimation:addTo(self.hPanelImageWidge,5) 
          else
                local mAnimation = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_FARMER_LOST)
                mAnimation:addTo(self.hPanelImageWidge,5) 
        end
end)

    --春天动画
    if  self.mDeskResult.Spring == 1 and aiData.data ~= "springOver" and  aiData.data ~= "heighOver" then

        -- -- #######
        local system = laixia.ani.CocosAnimManager
        local node = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_spring")
        node:setLocalZOrder(5)
        node:setPositionX(self.hPanelImageWidge:getContentSize().width/2)
        node:setPositionY(display.cy)
        self.root:runAction(cc.Sequence:create(
                    cc.DelayTime:create(5/6),
                    cc.CallFunc:create(
                        function()
                            --退出继续显示更新
                            if (self.mPokerDeskType == 1 or self.mPokerDeskType == 2 or self.mPokerDeskType == 5 or self.mPokerDeskType == 0 ) then
                                self:createResultDataFunction(self.mDeskResult)
                            end
                        end)))
        -- local srpingAni = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_SPRING)
        -- srpingAni:addTo(self.hPanelImageWidge,5) 
        -- srpingAni:setPosition(cc.p(640,400))

    else
        if (self.mPokerDeskType == 1 or self.mPokerDeskType == 2 or self.mPokerDeskType == 5 or self.mPokerDeskType == 0 ) then
            --播放动画，2秒后弹出结算页面

            if type(aiData.data) == "table" then
                self.root:runAction(cc.Sequence:create(
                    --onShowAnimationfun,
                    cc.DelayTime:create(5/6),
                    cc.CallFunc:create(
                        function()
                            --退出继续显示更新
                            self:createResultDataFunction(self.mDeskResult)
                        end)))
            else
                --退出继续显示更新
                self:createResultDataFunction(self.mDeskResult)
            end
        else
            self:ShowResultMatchFunction(self.mDeskResult["CSBalance"])
        end          
    end  
    self.mTipsErrorCardType:setVisible(false)
    self.mTipsBiggerCard:setVisible(false)
    
    self:GetWidgetByName("Image_LeftDizhu"):setVisible(false)
    self:GetWidgetByName("Image_RightDizhu"):setVisible(false)
    self:GetWidgetByName("Image_SelfDizhu"):setVisible(false)
end

function CardTableDialog:ShowTalkingFunction(mesg)
    if self.isShow ~= true then
        return
    end

    if self.mMySeatID == mesg.data.seatId then
        if self.mSelfTalk ~= nil then
            self.mSelfTalk:removeFromParent()
            self.mSelfTalk = nil
        end
        self:talkInfoFunction(mesg.data.chatType,mesg.data.info,mesg.data.seatId)
    elseif self.mMySeatID ==(mesg.data.seatId + 4) % 3 then
        if self.mLeftTalk ~= nil then
            self.mLeftTalk:removeFromParent()
            self.mLeftTalk = nil
        end
        self:talkInfoFunction(mesg.data.chatType,mesg.data.info,mesg.data.seatId)
    elseif self.mMySeatID ==(mesg.data.seatId + 2) % 3 then
        if self.mRightTalk ~= nil then
            self.mRightTalk:removeFromParent()
            self.mRightTalk = nil
        end
        self:talkInfoFunction(mesg.data.chatType,mesg.data.info,mesg.data.seatId)
    end
end

function CardTableDialog:talkInfoFunction(aiType,aiInfo,aiSeat)  --aiSeat已经转换，已经是相对于自己的位置
    if self.isShow ~= true then
        return
    end
    if self.mMySeatID == aiSeat then
        self.mSelfTalkTime = 0
        self.mSelfTalk = ccui.Layout:create()
        self.hPanelImageWidge:addChild(self.mSelfTalk,4)
    elseif self.mMySeatID == (aiSeat + 2)%3 then
        self.mRightTalkTime = 0
        self.mRightTalk = ccui.Layout:create()
        self.hPanelImageWidge:addChild(self.mRightTalk,4)
    elseif self.mMySeatID == (aiSeat + 4)%3 then
        self.mLeftTalkTime = 0
        self.mLeftTalk = ccui.Layout:create()
        self.hPanelImageWidge:addChild(self.mLeftTalk,4)
    end
    local width = 0;
    if 1 == aiType then
        local  Image_Talking =  self:GetWidgetByName("Image_Talking")
        Image_Talking:setVisible(true)
        --self:GetWidgetByName("Label_talk_msg",Image_Talking):setVisible(true)
        local talkText = ccui.Text:create()
        talkText:setString(aiInfo)
        talkText:setFontSize(26)
        local size = talkText:getContentSize()
        local bgWidth = size.width +25
 
        if self.mMySeatID == aiSeat then
            local talkBG = self:GetWidgetByName("Image_Self_Talk_BG",Image_Talking):clone()
            --talkBG:setContentSize(bgWidth+500,77)
            talkBG:setVisible(true)
            self.mSelfTalk:addChild(talkBG)
            local msg = self:GetWidgetByName("Label_Self_talk_msg",Image_Talking):clone()
            msg:setString(aiInfo)
            self.mSelfTalk:addChild(msg)
        elseif self.mMySeatID == (aiSeat + 2)%3 then            
            local talkBG = self:GetWidgetByName("Image_Right_Talk_BG",Image_Talking):clone()
            --talkBG:setContentSize(bgWidth,77)
            talkBG:setVisible(true)
            self.mRightTalk:addChild(talkBG)
            --self:GetWidgetByName("Label_talk_msg",Image_Talking):setString(aiInfo)
            local msg = self:GetWidgetByName("Label_Right_talk_msg",Image_Talking):clone()
            msg:setString(aiInfo)
            self.mRightTalk:addChild(msg)
        elseif self.mMySeatID == (aiSeat + 4)%3 then
            local talkBG = self:GetWidgetByName("Image_Left_Talk_BG",Image_Talking):clone()
            --talkBG:setContentSize(bgWidth,77)
            talkBG:setVisible(true)
            self.mLeftTalk:addChild(talkBG)
            --self:GetWidgetByName("Label_talk_msg",Image_Talking):setString(aiInfo)
            local msg = self:GetWidgetByName("Label_Left_talk_msg",Image_Talking):clone()
            msg:setString(aiInfo)
            self.mLeftTalk:addChild(msg)
        end
        -- 修改内容
    elseif 0 == aiType then
        -- 代表表情  
        local talkingBG = self:GetWidgetByName("Image_Talking")
        talkingBG:setVisible(true)
        --self:GetWidgetByName("Label_talk_msg",talkingBG):setVisible(false)
        local face_path ="new_ui/Chat/"..aiInfo..".png" --table_chat_expression"..aiInfo .. ".png"
       
        if self.mMySeatID == aiSeat then
            local face = self:GetWidgetByName("Image_Self_Talk_BG",talkingBG):clone()
            face:setVisible(false)
            face:setContentSize(100,100)
            face:setPosition(150,150)
            --self:GetWidgetByName("Image_face",face):loadTexture(face_path,1)
            local imageface = self:GetWidgetByName("Image_Self_face",talkingBG):clone()
            imageface:loadTexture(face_path)
            imageface:setLocalZOrder(10000)
            self.mSelfTalk:addChild(imageface)    
            face:setScale(0.1)
            transition.execute(imageface, cc.ScaleTo:create(0.2,-1.2,1.2), {
                delay = 0,
                easing = "bounceInOut",
                onComplete = function()
                    print("move completed")
                end,
            })
        elseif self.mMySeatID == (aiSeat + 2)%3 then
            local face = self:GetWidgetByName("Image_Right_Talk_BG",talkingBG):clone()
            face:setVisible(false)
            face:setContentSize(100,100)
            face:setPosition(150,150)
            local imageface = self:GetWidgetByName("Image_Right_face",talkingBG):clone()
            imageface:loadTexture(face_path)
            imageface:setLocalZOrder(10000)
            self.mRightTalk:addChild(imageface) 
            face:setScale(0.1)
            transition.execute(imageface, cc.ScaleTo:create(0.2,1.2,1.2), {
                delay = 0,
                easing = "bounceInOut",
                onComplete = function()
                    print("move completed")
                end,
            })
        elseif self.mMySeatID == (aiSeat + 4)%3 then
            local face = self:GetWidgetByName("Image_Left_Talk_BG",talkingBG):clone()
            face:setVisible(false)
            face:setContentSize(100,100)
            face:setPosition(150,150)
             local imageface = self:GetWidgetByName("Image_Left_face",talkingBG):clone()
            imageface:loadTexture(face_path)
            imageface:setLocalZOrder(10000)
            self.mLeftTalk:addChild(imageface) 
            
            face:setScale(-0.1)
            transition.execute(imageface, cc.ScaleTo:create(0.2,-1.2,1.2), {
                delay = 0,
                easing = "bounceInOut",
                onComplete = function()
                    print("move completed")
                end,
            })
        end
    end
end

--播放出牌后音效
--aiSex 0：男 1：女
--aiType  音效类型
--aiPokerIndex 牌值（单、对、三张、王炸必填）
function CardTableDialog:playSound(aiSex,aiType,aiPokerIndex)
        local SEX = ""
        if aiSex == 0 then
            SEX = "man"
        else
            SEX = "woman"
        end
        if aiType == l_CardTypeObj.SINGLE_CARD then
            if aiPokerIndex == 0 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_0"])
            elseif aiPokerIndex == 1 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_1"])
            elseif aiPokerIndex == 2 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_2"])
            elseif aiPokerIndex == 3 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_3"])
            elseif aiPokerIndex == 4 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_4"])
            elseif aiPokerIndex == 5 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_5"])
            elseif aiPokerIndex == 6 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_6"])
            elseif aiPokerIndex == 7 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_7"])
            elseif aiPokerIndex == 8 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_8"])
            elseif aiPokerIndex == 9 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_9"])
            elseif aiPokerIndex == 10 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_10"])
            elseif aiPokerIndex == 11 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_11"])
            elseif aiPokerIndex == 12 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_12"])
            elseif aiPokerIndex == 13 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_13"])
            else
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_14"])
            end
        elseif aiType == l_CardTypeObj.DOUBLE_CARD then
            if aiPokerIndex == 0 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_0"])
            elseif aiPokerIndex == 1 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_1"])
            elseif aiPokerIndex == 2 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_2"])
            elseif aiPokerIndex == 3 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_3"])
            elseif aiPokerIndex == 4 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_4"])
            elseif aiPokerIndex == 5 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_5"])
            elseif aiPokerIndex == 6 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_6"])
            elseif aiPokerIndex == 7 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_7"])
            elseif aiPokerIndex == 8 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_8"])
            elseif aiPokerIndex == 9 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_9"])
            elseif aiPokerIndex == 10 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_10"])
            elseif aiPokerIndex == 11 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_11"])
            else
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_two_pieces_12"])
            end
        elseif aiType == l_CardTypeObj.THREE_CARD then
            if aiPokerIndex == 0 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_0"])
            elseif aiPokerIndex == 1 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_1"])
            elseif aiPokerIndex == 2 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_2"])
            elseif aiPokerIndex == 3 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_3"])
            elseif aiPokerIndex == 4 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_4"])
            elseif aiPokerIndex == 5 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_5"])
            elseif aiPokerIndex == 6 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_6"])
            elseif aiPokerIndex == 7 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_7"])
            elseif aiPokerIndex == 8 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_8"])
            elseif aiPokerIndex == 9 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_9"])
            elseif aiPokerIndex == 10 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_10"])
            elseif aiPokerIndex == 11 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_11"])
            else
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_triplet_12"])
            end
        elseif aiType == l_CardTypeObj.THREE_ONE_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_3_with_1"])
        elseif aiType == l_CardTypeObj.THREE_TWO_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_3_with_2"])
        elseif aiType == l_CardTypeObj.BOMB_CARD or aiType == l_CardTypeObj.SOFT_BOMB_CARD or aiType == l_CardTypeObj.LAIZI_BOMB_CARD or aiType == l_CardTypeObj.ROCKET_CARD then
            if aiPokerIndex == 13 or aiPokerIndex == 14 then
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_king_bomb"])
            else
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_bomb"])
            end
        elseif aiType == l_CardTypeObj.BOMB_TWO_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_4_with_2"])
        elseif aiType == l_CardTypeObj.CONNECT_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_straight"])
        elseif aiType == l_CardTypeObj.COMPANY_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_even_straight"])
        elseif aiType == l_CardTypeObj.AIRCRAFT_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_airplane"])
        elseif aiType == l_CardTypeObj.AIRCRAFT_SINGLE_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_airplaneDaichibang"])
        elseif aiType == l_CardTypeObj.AIRCRAFT_DOBULE_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_airplaneDaichibang"])
        elseif aiType == l_CardTypeObj.BOMB_TWOOO_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_4_with_2_2"])
        else
            --错误牌型
        end
end

function CardTableDialog:playPassSound(aiSex)
        local typeIndex = math.random(1,2) 
        
       local SEX = ""
       if aiSex == 0 then
           SEX = "man"
       else
           SEX = "woman"
       end
        if   typeIndex == 1 then 
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_pass_1"])
        elseif  typeIndex == 2 then 
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_pass_2"])
        else
            laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_pass_3"])
        end

end

function CardTableDialog:funcRocketRise()
    local parent = self.hPanelImageWidge
    local posX,posY = 0,0
    local scale = 1
   
    local size = self.hPanelImageWidge:getContentSize()
    posX,posY = size.width/2,size.height/2

    -- #################
    local system = laixia.ani.CocosAnimManager
    local node = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_rocket")
    node:setLocalZOrder(4)
    node:setPositionX(parent:getContentSize().width/2)
    node:setPositionY(parent:getContentSize().height/2)
    
    -- local system = laixia.ani.CObjectAnimationManager;
    -- local rocketRise =l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_ROCK)
    -- rocketRise:addTo(parent,4)

end
-- 王-炸-的-动-画
function CardTableDialog:showHuoJianAni()
        -- #################
    local system = laixia.ani.CocosAnimManager
    self.rocket = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_rocket")
    self.rocket:setLocalZOrder(4)
    self.rocket:pos(self.hPanelImageWidge:getContentSize().width/2,display.height/5*3)
    self.hPanelImageWidge:runAction(cc.Sequence:create(
    cc.DelayTime:create(0.2),
    cc.CallFunc:create(function() 
            if device.platform == "android" and laixia.LocalPlayercfg.LaixiaIsShake == 1 then
                local luaj = require "cocos.cocos2d.luaj"
                local params = { 700 }
                local state, value = luaj.callStaticMethod(JAVA_SHAKE_CLASSPATH, "gameShake", params, "(I)V")
            elseif device.platform == "ios" then
                local luaoc = require("cocos.cocos2d.luaoc")
                local ok,ret = luaoc.callStaticMethod("GetGeneralInfo", "gameShake")
            end
        end)))
    -- self.hPanelImageWidge:runAction(cc.Sequence:create(
    --     cc.CallFunc:create(function() 
    --         self:funcRocketRise()
    --     end),
    --     cc.DelayTime:create(1),
    --     cc.CallFunc:create(function() 
    --         self:RocketDownFunction()
    --     end),
    --     cc.DelayTime:create(0.12),
    --     cc.CallFunc:create(function() 
            
    --     end)
    -- ))
end


function CardTableDialog:CardEffectFunction(aiType)
    if self.isShow ~= true then
        return
    end
    local outPokersData = laixia.LocalPlayercfg.LaixiaOutCards
    
    if aiType ~= l_CardTypeObj.ERROR_CARD  then  -- 为何分开写
        self.mCardType = aiType
    else
        self.mCardType= l_CardTypeObj.AUTO_CARD
    end

    if #outPokersData.Cards > 0 then
        self.mNewOutType = laixia.LocalPlayercfg.LaixiaOutCardsCount
       if  aiType == l_CardTypeObj.ROCKET_CARD and #outPokersData.Cards > 0 then
            self:HideAnimationFunction()
            -- laixia.soundTools.playMusic(laixia.soundcfg.SCENE_MUSIC.boom,true);
            local seat = outPokersData.Seat
            self:showHuoJianAni()
        elseif aiType ==l_CardTypeObj.BOMB_CARD or aiType == l_CardTypeObj.BOMB_CARD or aiType == l_CardTypeObj.SOFT_BOMB_CARD or aiType == l_CardTypeObj.LAIZI_BOMB_CARD  and #outPokersData.Cards > 0 then 
            self:HideAnimationFunction()
            local seat = outPokersData.Seat
            laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_bomb) 
            -- laixia.soundTools.playMusic(laixia.soundcfg.SCENE_MUSIC.boom,true);
            if device.platform == "android" and laixia.LocalPlayercfg.LaixiaIsShake == 1 then
                local params = { 700 }
                local state, value = luaj.callStaticMethod(JAVA_SHAKE_CLASSPATH, "gameShake", params, "(I)V")
            elseif device.platform == "ios" then
    		        local ok,ret = luaoc.callStaticMethod("GetGeneralInfo", "gameShake")
            end 

            -- ###########  
            local system = laixia.ani.CocosAnimManager
            self.bomb = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_bomb")
            self.bomb:setLocalZOrder(5)
            self.bomb:pos(self.hPanelImageWidge:getContentSize().width/2 ,display.height/5*3)
            -- cc.SpriteFrameCache:getInstance():addSpriteFrames("new_animation/zhadan0.plist","new_animation/zhadan0.png")
            -- local system = laixia.ani.CObjectAnimationManager;
            -- self.mEffect.BOMB_CARD =  l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_XIAOZHADAN)
            -- self.mEffect.BOMB_CARD:addTo(self.hPanelImageWidge,4)
            -- self.mEffect.BOMB_CARD:setLocalZOrder(5)
            
        elseif  aiType == l_CardTypeObj.AIRCRAFT_SINGLE_CARD or aiType == l_CardTypeObj.AIRCRAFT_DOBULE_CARD or aiType == l_CardTypeObj.AIRCRAFT_CARD   then
            laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_airplane)
            self:HideAnimationFunction()    

            -- ###########
            local system = laixia.ani.CocosAnimManager
            local node = system:playAnimationAt(self.Panel_1,"doudizhu_plane")
            node:setLocalZOrder(100)
            node:setPositionX(self.Panel_1:getContentSize().width/2)
            node:setPositionY(display.height/5*3)

            -- cc.SpriteFrameCache:getInstance():addSpriteFrames('new_animation/feiji0.plist','new_animation/feiji0.png')
            -- self.mEffect.AIRCRAFT_CARD = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_FEIJI)
            -- self.mEffect.AIRCRAFT_CARD:addTo(self.hPanelImageWidge,4)

        elseif aiType == l_CardTypeObj.COMPANY_CARD then
            laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_straight)
            self:HideAnimationFunction()   
            -- cc.SpriteFrameCache:getInstance():addSpriteFrames('new_animation/liandui0.plist','new_animation/liandui0.png')
            --现在连对动画
            local system = laixia.ani.CocosAnimManager
            local node = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_pair")
            node:setLocalZOrder(5)
            node:setPositionX(self.hPanelImageWidge:getContentSize().width/2)
            node:setPositionY(display.height/5*3)
            -- --原连对动画
            -- cc.SpriteFrameCache:getInstance():addSpriteFrames('new_animation/liandui0.plist','new_animation/liandui0.png')
            -- self.mEffect.COMPANY_CARD = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_LIANDUI)
            -- self.mEffect.COMPANY_CARD:addTo(self.hPanelImageWidge,4)
            -- self.mEffect.COMPANY_CARD:setLocalZOrder(5)

        elseif aiType == l_CardTypeObj.CONNECT_CARD then
            self:HideAnimationFunction()    

            -- ###########
            local system = laixia.ani.CocosAnimManager
            local node = system:playAnimationAt(self.Panel_1,"doudizhu_shunzi")
            node:setLocalZOrder(100)
            node:setPositionX(self.Panel_1:getContentSize().width/2)
            node:setPositionY(display.height/5*3)
            -- cc.SpriteFrameCache:getInstance():addSpriteFrames('new_animation/shunzi0.plist','new_animation/shunzi0.png')
            -- self.mEffect.CONNECT_CARD = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_SHUNZI)
            -- self.mEffect.CONNECT_CARD:addTo(self.hPanelImageWidge,4)
            -- self.mEffect.CONNECT_CARD:setLocalZOrder(5)
        end
    end
    --2次没人管上 重置管上次数
    if laixia.LocalPlayercfg.LaixiaOutCards.count >= 2 then
        laixia.LocalPlayercfg.LaixiaOutCardsCount = 0
    end
    if aiType ~= l_CardTypeObj.ERROR_CARD  then
        self.mPreviousType = aiType
      else
        self.mCardType= l_CardTypeObj.AUTO_CARD
    end

end

function CardTableDialog:RocketDownFunction()
    local system = laixia.ani.CObjectAnimationManager;
    local size = self.hPanelImageWidge:getContentSize()

    local off1,off2=5,2
    self.hPanelImageWidge:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function() 
            if device.platform == "android" and laixia.LocalPlayercfg.LaixiaIsShake == 1 then
                local luaj = require "cocos.cocos2d.luaj"
                local params = { 700 }
                local state, value = luaj.callStaticMethod(JAVA_SHAKE_CLASSPATH, "gameShake", params, "(I)V")
            elseif device.platform == "ios" then
                    local ok,ret = luaoc.callStaticMethod("GetGeneralInfo", "gameShake")
            end
        end),
        cc.MoveBy:create(0.05,cc.p(off1,off1)), 
        cc.MoveBy:create(0.1,cc.p(-off1,-off1)),
        cc.MoveBy:create(0.05,cc.p(off2,off2)),
        cc.MoveBy:create(0.05,cc.p(-off2,-off2)),
        cc.MoveBy:create(0.05,cc.p(off1,off1)), 
        cc.MoveBy:create(0.1,cc.p(-off1,-off1)),
        cc.MoveBy:create(0.05,cc.p(off2,off2)),
        cc.MoveBy:create(0.05,cc.p(-off2,-off2)),
        cc.MoveBy:create(0.05,cc.p(off1,off1)), 
        cc.MoveBy:create(0.1,cc.p(-off1,-off1)),
        cc.MoveBy:create(0.05,cc.p(off2,off2)),
        cc.MoveBy:create(0.05,cc.p(-off2,-off2))
     ))

end

-- 创---建--闹--钟--动---画
function CardTableDialog:CreateClockFunction()
    if self.mClock ~= nil then
        return
    end
    --闹钟上面的数字
    self.mTime = self.mLabelTime:clone()
    self.mTime:setPosition(cc.p(-5,-16))
    self.mClock = ccui.Layout:create()
    self.mClock:setLocalZOrder(5)

    local system = laixia.ani.CocosAnimManager
    self.mClockAni = system:playAnimationAt(self.mClock,"doudizhu_alarmclock")
    
    -- local system = laixia.ani.CObjectAnimationManager;
    -- self.mClockAni = system:playAnimationAt(self.mClock,"paizhuo_naozhong","Default Timeline",
    -- function() 
    -- end )
    self.mClockAni:setPosition(45,16)
    self.mTime:addTo(self.mClock)
    local px,py = self.mTime:getPosition()
    self.mTime:setPosition(px+50,py+38)
    self.mClock:setVisible(false)
    self.mClock:addTo(self.hPanelImageWidge)
    self.mClock:setPosition(cc.p(-1280, -1280))
end


-- 全-部-初-始-化-为-农民
function CardTableDialog:onShowFarmerHead(mHead,mSex)
      -- mHead:removeAllChildren()
      -- local sx, sy = mHead:getPosition()    
      -- if mSex == 0 then   
           -- mHead:loadTexture("table_famer_boy.png",1)
           -- mHead:setContentSize(116,110) 
      -- else
           -- mHead:loadTexture("table_famer_girl.png",1)
           -- mHead:setContentSize(126,117)
           -- mHead:setPosition(sx-4,sy-4)
      -- end
      mHead:setVisible(false)
      
end

--恢-复-头-像-尺-寸
function CardTableDialog:OnRecHeadSizeFunction(mHead)
   -- mHead:removeAllChildren()   
   -- mHead:setContentSize(96,96)

   if mHead == self.mSelfHead and self.mSelfHeadPoint ~= nil then
       mHead :setPosition(self.mSelfHeadPoint.x,self.mSelfHeadPoint.y) 
    elseif mHead == self.mRightHead and self.mRightHeadPoint ~= nil then 
       mHead :setPosition(self.mRightHeadPoint.x,self.mRightHeadPoint.y)
    elseif mHead == self.mLeftHead and self.mLeftHeadPoint ~= nil then 
       mHead :setPosition(self.mLeftHeadPoint.x,self.mLeftHeadPoint.y)
   end
end

--显示地主图标
function CardTableDialog:OnDisplayLandHeadFunction(mHead,mSex)
--   mHead:removeAllChildren()
--   local sx, sy = mHead:getPosition()   
--   if mSex == 0 then   
--        mHead:loadTexture("table_dizhu_boy.png",1)
--        mHead:setContentSize(120,125)
--        mHead:setPositionY(sy-4)
--   else
--        mHead:loadTexture("table_dizhu_girl.png",1)
--        mHead:setContentSize(136,113)
--        mHead:setPosition(sx-8,sy+2)
--   end
    
    local system = laixia.ani.CocosAnimManager
    self.dzanimmal = system:playAnimationAt(mHead,"doudizhu_yan")
    self.dzanimmal:setLocalZOrder(5)
    self.dzanimmal:setAnchorPoint(cc.p(0.5,0.5))
    self.dzanimmal:setPosition(mHead:getContentSize().width/2+10,0)--cc.p(math.abs(self.dzanimmal:getPositionX()),math.abs(self.dzanimmal:getPositionY())))
    mHead:setVisible(true)
end
--显示地主动画
-- function CardTableDialog:OnDisplayLandHeadAniFunction(pestsix,pestsiy)
--         local system = laixia.ani.CocosAnimManager
--         self.matchGamestartAni = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_yan")
--         self.matchGamestartAni:setLocalZOrder(5)
--         self.matchGamestartAni:setPosition(pestsix,pestsiy)    
-- end
-- 发底牌 --显示地主头像
function CardTableDialog:OnSendDealFunction(msg)
    if self.isShow ~= true then
        return
    end
    local tDeal = msg.data

    if #tDeal.Cards == 3 then
        -- 发地主底牌
        self:onChangePlayerImgFunction(tDeal.Seats)
        for i = 1,3 do
            if self.mSynchronousData.Players[i].Seat ==  tDeal.Seats then
                self.mBottomPID = self.mSynchronousData.Players[i].PID
            end
        end
        self:dealBottomPokersFunction(tDeal)
        local tBottomCards = tDeal.Cards
        --地主叫牌，3张牌的翻牌动画
        local function action(aiActor,aiCardValue,index)
            transition.execute(aiActor, cc.ScaleTo:create(0.3,0,0.33,1), {
                delay = 0,
                onComplete = function()
                    local x,y = aiActor:getPosition()
                    local parent = aiActor:getParent()
                    aiActor:setVisible(false)
                    aiActor:setScale(0.33,0.33)
                    local temptable ={}
                    temptable.CardValue=aiCardValue
                    self.mBottomPoker[index+3] = l_cardobj.new(temptable)
                              :pos(x,y)
                              :addTo(parent)
                    self.mBottomPoker[index+3]:setLocalZOrder(index*10) 
                    self.mBottomPoker[index+3]:setScale(0,0.2)
                    self.mBottomPoker[index+3]:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0.33,0.33,1),
                        cc.CallFunc:create(function()
							local fanpai =l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_FANPAI)
                                fanpai:addTo(self.mBottomPoker[index+3],5) 
                                fanpai:setPosition(cc.p(-640,-440))

                            end)
                        ))
                end,
            })
        end
        for i = 1,3 do
            action(self.mBottomPoker[i],tBottomCards[i].CardValue,i)
        end
    else
        laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_deal_card)
        self.isShowThebeBar = false
        self.isDealAni = false
        self:dealHandPokersFunction(tDeal)
        -- 发手牌
        if tDeal.Reelect == 1 then
            self:cancelHostingFunction()
            self:resetCardCountFunction()
            self:changeCardCountFunction(l_NorLogicObject:OutCountIndexFunction(tDeal.Cards))
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ANIMATION_LIUJU)          
        end
    end
end

-- 更新"闹钟"的位置  
-- 1： 轮到自己出牌 出现三个按钮时的位置  2： 轮到自己出牌  只有一个按钮时
-- 3： 叫地主or抢地主时 4：轮到左边玩家出牌时   5： 轮到右边玩家出牌时 6轮到自己叫地主的时候
function CardTableDialog:RefreshClockPostionFunction(status)
    local posArr = {
        cc.p(0,390+50),
        cc.p(0,390+50),
        cc.p(0,390+50),
        cc.p(-340,465),
        cc.p(358,465),
        cc.p(-140,340),
    }
    if self.mClock== nil or self.mImgClock == nil then 
        return 
    end 
    if not posArr[status] then 
        return 
    end 
    local pos= posArr[status]
    self.mClock:setPosition(cc.p(pos.x+645 - 65,pos.y ))--- 60))
    self.mImgClock:setPosition(cc.p(pos.x+640-16,pos.y+20))---10))
end

--玩家是否有记牌器  1：有记牌器    0：没有
function CardTableDialog:isPlayerHaveCardCount(status)
    -- if status and status == 1 then 
    --     if self.mRoomID ==50  then
    --        self.mCardCountImg:setVisible(false)
    --        self.Button_supergift:setVisible(false)
    --        -- self.mHaveCardCountButton:setVisible(false)
    --     else
    --         -- self.mHaveCardCountButton:setVisible(true)
    --         self.mCardCountImg:setVisible(not self.mCardCountImg:isVisible())
    --     end

    -- else
    --     self.mCardCountImg:setVisible(false)
    --      if self.mRoomID ==50  then
    --         -- self.mHaveCardCountButton:setVisible(false)
    --         self.Button_supergift:setVisible(false)
    --      end
    -- end
    self.mCardCountImg:setVisible(false)
end 

function CardTableDialog:onCreatLiuJuAniFunction()
    if self.mIsShow then
        -- local node = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_LIUJU)
        -- node:addTo(self.hPanelImageWidge,4)
    end 
end
-- status : 0：两个闹钟都不显示
--   1：只显示图片  不显示动画
--   2：只显示动画 不显示图片
--  3：移除动画 并且不显示图片
-- time  显示在闹钟上的时间
function CardTableDialog:DisplayWhichClockFunction(status,time)
    if self.mClock == nil or self.mImgClock == nil then 
        return 
    end 
    if status == 0 then 
        self.mClock:setVisible(false)
        self.mImgClock:setVisible(false)
    elseif status ==1 then 
        self.mClock:setVisible(false)
        self.mImgClock:setVisible(true)
    elseif status ==2 then 
        self.mClock:setVisible(true)
        self.mImgClock:setVisible(false)
    elseif status == 3 then 
        self.mClock:removeFromParent()
        self.mClock = nil
        self.mImgClock:setVisible(false)
    end 
    if not time then 
        return 
    else
        self.mTime:setString(time)
        self.mLabelTime:setString(time)
    end
end

-- 更新"不出"按钮的状态 1：最左边&可点  2：居中&可点(换成要不起的按钮)  3：最左边&不可点  4：不显示  
function CardTableDialog:RefreshPassBtnStateFunction(status)
    local defalutX = 370 
    local centerX = 640
    if status == 4 then  
        self.mPass:setVisible(false)
        self.mPassToo:setVisible(false)

        self.mPass_1:setVisible(false)
        self.mPassToo_1:setVisible(false)
    elseif status == 2 then 
        self.mPass:setVisible(false)
        self.mPassToo:setVisible(true)

        self.mPass_1:setVisible(false)
        self.mPassToo_1:setVisible(false)
        self.mPassToo:setPosition(cc.p(380,63))
        -- self.mPassToo:setPosition(640-68,self.mPassToo:getPositionY())
    else
        self.mPassToo:setVisible(false)
        self.mPass:setVisible(true)
        if status == 1 then  --可点
            self:ChangButBrightFunction(true,self.mPass,"table_button_buchu.png")
        else    -- 置灰
            self:ChangButBrightFunction(false,self.mPass,"table_button_unbuchu.png")
        end 
    end
end

--修改按钮状态和现实文字--@按钮状态--@按钮--@文字替换的图片地址
function CardTableDialog:ChangButBrightFunction(ButtonBright,Button,picturePath)
     Button:setTouchEnabled(ButtonBright)
     Button:setBright(ButtonBright)
     -- self:GetWidgetByName("Image_Button",Button):loadTexture(picturePath,1)
     -- self:GetWidgetByName("Image_Button",Button):setScale(0.8)

    local name = ""
    if Button == self.mPass then
        name = "Button_Pass"
    elseif Button == self.mPassToo then
        name = "Button_Pass_too"
    elseif Button == self.resetButton then
        name = "Button_Reset"
    elseif Button == self.mHint then
        name = "Button_Hint"
    elseif Button == self.mPlay then
        name = "Button_Play"
    elseif Button == self.mPointArray[1] then
        name = "Button_CallPoint_0"
    elseif Button == self.mPointArray[2] then
        name = "Button_CallPoint_1"
    elseif Button == self.mPointArray[3] then
        name = "Button_CallPoint_2"
    elseif Button == self.mPointArray[4] then
        name = "Button_CallPoint_3"
    end
    self:GetWidgetByName(name):setVisible(ButtonBright)
    self:GetWidgetByName(name.."_1"):setVisible(not ButtonBright)
    -- elseif Button == self.mDouble then

end

-- 是否显示提示按钮  state:1 显示&可点  3 显示&不可点  4 不显示
function CardTableDialog:IsDiaplayHintFunction(status)
    if status == 4 then 
        self.mHint:setVisible(false)

        self.mHint_1:setVisible(false)
    else
        self.mHint:setVisible(true)
        if status == 1 then 
            self:ChangButBrightFunction(true,self.mHint,"table_button_tishi.png")
        else
            self:ChangButBrightFunction(false,self.mHint,"table_button_untishi.png")
        end
    end
end

-- 是否显示"明牌" 按钮state:1 显示&可点  3 显示&不可点  4 不显示
-- 因为现在不显示名牌按钮了
function CardTableDialog:IsDiaplayDoubleFunction(status)
--    local px,py = self.mDouble:getPosition()
--    if status == 4 then 
--        self.mDouble:setVisible(false)
--        -- self.mPlay:setPositionX(930)
--        -- self.mHint:setPositionX(700)
--    else
--        -- self.mPlay:setPositionX(810)
--        -- self.mHint:setPositionX(470)
--        if status == 1 then 
--            self:ChangButBrightFunction(true,self.mDouble,"table_button_mingpai.png")
--        else
--            self:ChangButBrightFunction(false,self.mDouble,"table_button_mingpai.png")
--        end
--        self.mDouble:setVisible(false)
--    end
end 

-- 更新"出牌"按钮的状态 1：最右边&可点  2：居中&可点  3：最右边&不可点  4：不显示   5 居中&不可点
function CardTableDialog:RefreshPlayBtnStateFunction(status)
    local defalutX = 910 -200
    local centerX = 640
    local isBright = false 
    if status == 4 then  
        self.mPlay:setVisible(false)

        self.mPlay_1:setVisible(false)
    else
        self.mPlay:setVisible(true)
        if status == 1 or status == 2 then  --可点
            self:ChangButBrightFunction(true,self.mPlay,"table_button_chupai.png")
        else    -- 置灰
            self:ChangButBrightFunction(false,self.mPlay,"table_button_unchupai.png")
        end 

    end
end
--刷新重选按状态
function CardTableDialog:RefreshResetBtnStateFunction(status)
    if status == 4 then
        self.resetButton:setVisible(false)

        self.resetButton_1:setVisible(false)
    else
        self.resetButton:setVisible(true)
        if status == 1 then
            self:ChangButBrightFunction(true,self.resetButton,"table_button_chongxuan.png")
        else
            self:ChangButBrightFunction(false,self.resetButton,"table_button_unchongxua.png")
        end 
    end
end
-- 发手牌
function CardTableDialog:dealHandPokersFunction(aiDeal)
    
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHRANK_WINDOW) --隐藏中间的等级界面
    self:DisplayWhichClockFunction(0)
    local tDeal = aiDeal
    self.mLeftHandle:setVisible(false)
    self.mRightHandle:setVisible(false)
    self.mSelfHandle:setVisible(false)   

    if tDeal.Seats == self.mMySeatID then
        if self.mSelfPokers ~= nil then
            self.mSelfPokers:removeFromParent()
            self.mSelfPokers = nil
        end
        self.mLeftNum:setString(0)
        self.mLeftNum:setVisible(true)
        self.mRightNum:setString(0)
        self.mRightNum:setVisible(true)
        self:GetWidgetByName("Image_LeftHeadCard"):setVisible(true)
        self:GetWidgetByName("Image_RightHeadCard"):setVisible(true) 
        if self.matchingAni then
            self.matchingAni:removeFromParent()
            self.matchingAni = nil
        end
        if self.laterAni then
            self.laterAni:removeFromParent()
            self.laterAni = nil
        end
        --游戏开始时的动画
        if self.mPokerDeskType == 4 and laixia.LocalPlayercfg.LaixiaMatchlastStage ~= laixia.LocalPlayercfg.LaixiaMatchStage then    --比赛场
                local system = laixia.ani.CocosAnimManager
                self.secondstageAni = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_secondstage")
                self.secondstageAni:setLocalZOrder(5)
                self.secondstageAni:setPosition(cc.p(self.hPanelImageWidge:getContentSize().width/2,display.height/5*3))
        elseif self.mSelfRoomID == 9 or self.mSelfRoomID == 10 or self.mSelfRoomID == 11 then   --游戏场
            local system = laixia.ani.CocosAnimManager
            self.gamestartAni = system:playAnimationAt(self.hPanelImageWidge,"doudizhu_gamestart")
            self.gamestartAni:setLocalZOrder(5)
            self.gamestartAni:setPosition(cc.p(self.hPanelImageWidge:getContentSize().width/2,display.height/5*3))
        end
        self.mSelfPokers = GamePlayerObj.new(tDeal.Cards, self.mMySeatID,{isHandCard = true, isAniFinsih = false, atlsL = self.mLeftNum,atlsR = self.mRightNum,selfSeat = self.mMySeatID, isDealBottomAni = false})
        self.mSelfPokers:addTo(self.hPanelImageWidge)
        self.mSelfPokers:setLocalZOrder(3)
        self.mSelfPokers:setPosition(cc.p(640,self.mSelfPokers:getContentSize().height * 0.5+54))
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CHANGE_BUYRECORDER_WINDOW,true);

        self:changeCardCountFunction( l_NorLogicObject:OutCountIndexFunction(tDeal.Cards))
    end
    if self.mMySeatID ==(tDeal.Seats + 2) % 3 then
        -- 右边牌
        if self.mRightPlayerPoker ~= nil then
            self.mRightPlayerPoker:removeFromParent()
            self.mRightPlayerPoker = nil
        end
        self.mRightPlayerPoker = GamePlayerObj.new(tDeal.Cards, tDeal.Seats,{isHandCard = true, isAniFinsih = true,selfSeat = self.mMySeatID, isDealBottomAni = true})
        self.mRightPlayerPoker:addTo(self.hPanelImageWidge)
        self.mRightPlayerPoker:setLocalZOrder(2)
        self.mRightPlayerPoker:setPosition(cc.p(1167, 293))
        self.mRightPlayerPoker:setVisible(false)
        self.mRightNum:setString(20)
    end
    if self.mMySeatID ==(tDeal.Seats + 4) % 3 then
        -- 右边牌
        if self.mLeftPlayerPoker ~= nil then
            self.mLeftPlayerPoker:removeFromParent()
            self.mLeftPlayerPoker = nil
        end
        self.mLeftPlayerPoker = GamePlayerObj.new(tDeal.Cards, tDeal.Seats,{isHandCard = true, isAniFinsih = true,selfSeat = self.mMySeatID, isDealBottomAni = true})
        self.mLeftPlayerPoker:addTo(self.hPanelImageWidge)
        self.mLeftPlayerPoker:setLocalZOrder(2)
        self.mLeftPlayerPoker:setPosition(cc.p(113, 293))
        self.mLeftPlayerPoker:setVisible(false)
        self.mLeftNum:setString(20)
    end
end

-- 发地主底牌
function CardTableDialog:dealBottomPokersFunction(aiDeal)
    local players = self.mSynchronousData.Players
    local baseValue = self.mSynchronousData.BaseValue

    if self.mMySeatID == aiDeal.Seats then
        self.mSelfPokers:addBottomPokers(aiDeal.Cards,aiDeal.Seats,self.mPlayBar)
        laixia.LocalPlayercfg.isDealBottomAni = true
        if self.mCancelTrusteeship:isVisible() == true then
            self.mSelfPokers:setBlack()
        end
        --改变人物头像
        if table.nums(self.mSelfPokers:getPokerList()) == 20 then
            if self.isMingPoker == 1 then
                self:IsDiaplayDoubleFunction(4) 
            else
                self:IsDiaplayDoubleFunction(1) 
            end
            self:RefreshPassBtnStateFunction(4)
            self:IsDiaplayHintFunction(3)
        end
        self:changeCardCountFunction(l_NorLogicObject:OutCountIndexFunction(aiDeal.Cards))
    elseif self.mMySeatID ==(aiDeal.Seats + 4) % 3 then
        self.mLeftNum:setString(tonumber(self.mLeftNum:getString()) + #aiDeal.Cards)
    elseif self.mMySeatID ==(aiDeal.Seats + 2) % 3 then
        self.mRightNum:setString(tonumber(self.mRightNum:getString()) + #aiDeal.Cards)
    end
end

function CardTableDialog:GameTableShowFen(mNode,mType,mChip)
       if mType == 0 then
            if mChip == 1 then
                mNode:loadTexture("new_ui/CardTableDialog/table_1fen.png")
            elseif mChip == 2 then
                mNode:loadTexture("new_ui/CardTableDialog/table_2fen.png")
            elseif mChip == 3 then
                if self.mSynchronousData.TableType == 0 then
                   mNode:loadTexture("new_ui/CardTableDialog/table_3fen.png") 
                else
                   mNode:loadTexture("table_jiaodizhu.png",1) 
                end
            else
                mNode:loadTexture("new_ui/CardTableDialog/table_bujiao.png")
            end
        elseif mType == 1 then
            if  mChip == 4 then
                mNode:loadTexture("table_qiangdizhu.png",1)  
            else
                mNode:loadTexture("table_buqiang.png",1)  
            end         
        end
end

-- 叫分 --1分
function CardTableDialog:GamethebeFunction(msg)

    if self.isShow ~= true then
        return
    end
    local thebeData = msg.data
    local synchronousData = self.mSynchronousData;
    if thebeData == nil then
        return
    end
    for i = 1,3 do
        if synchronousData == nil then
            break
        end
        if synchronousData.Players[i].Seat == thebeData.Seat then
                if thebeData.Chip == 0 then
                    if thebeData.Type == 0 then --不叫
                        if synchronousData.Players[i].Sex == 0 then
                            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_landlord_man_call_no)
                        else
                            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_landlord_call_no)
                        end
                    else
                        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_landlord_call_grab_no)
                    end
                elseif thebeData.Chip == 1 then
                    if synchronousData.Players[i].Sex == 0 then
                        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_click_man_fen_1)
                    else
                        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_click_woman_fen_1)
                    end
                elseif thebeData.Chip == 2 then
                    if synchronousData.Players[i].Sex == 0 then
                        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_click_man_fen_2)
                    else
                        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_click_woman_fen_2)
                    end
                elseif thebeData.Chip == 3 then
                    -- if 2 == synchronousData.RoomType then
                        if synchronousData.Players[i].Sex == 0 then
                            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_click_man_fen_3)
                        else
                            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_click_woman_fen_3)
                        end
                    -- else
                    --     laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_landlord_call_3)
                    -- end
                elseif thebeData.Chip == 4 then
                    if math.random(2) == 1 then 
                        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_landlord_call_grab)
                    else
                        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_landlord_call_grab_me)
                    end
                end
        end
    end
    if  thebeData.Seat == self.mMySeatID then
        self:GameTableShowFen(  self.mSelfHandle,  thebeData.Type,  thebeData.Chip)
        --self:OnDisplayLandHeadAniFunction(self.mSelfHandle:getPositionX(),self.mSelfHandle:getPositionY())
        self.mSelfHandle:setVisible(true)
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
    end
    if ( thebeData.Seat + 4)%3 == self.mMySeatID then
        self:GameTableShowFen(  self.mLeftHandle,  thebeData.Type,  thebeData.Chip)
        --self:OnDisplayLandHeadAniFunction(self.mLeftHandle:getPositionX(),self.mSelfHandle:getPositionY())
        self.mSelfHandle:setVisible(false)
        self.mLeftHandle:setVisible(true)
        self.mRightHandle:setVisible(false)
    end
    if ( thebeData.Seat + 2)%3 == self.mMySeatID then
        self:GameTableShowFen(  self.mRightHandle,  thebeData.Type,  thebeData.Chip)
        --self:OnDisplayLandHeadAniFunction(self.mRightHandle:getPositionX(),self.mSelfHandle:getPositionY())
        self.mSelfHandle:setVisible(false)
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(true)
    end
    
    if thebeData.Type == 0 then
        for i=1, thebeData.Chip do
            if i <= 2 then
               local bt = self.mPointArray[i+1]
               bt:setTouchEnabled(false)
               bt: setBright(false)
               --上面显示的字 颜色
               -- local icon = self:GetWidgetByName("Image_Button",bt)
               -- local imgPath =  "table_btn_"..i.."fengrey.png"
               -- icon:loadTexture(imgPath,1) 
               self:ChangButBrightFunction(false,bt)
            end 
        end

    end
    if self.mStageStep ~= nil and self.mStageStep.State == 3 and self.mSetp == 2 then
        self.mSelfHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
        self.mLeftHandle:setVisible(false)
    end
    if self.mStageStep~= nil then
        self.mSetp = self.mStageStep.State
    end
    if thebeData.Chip == 4 then
        self.mTimes:setString(tonumber(self.mTimes:getString()) * 2)
    end
    if thebeData.Chip == 1 or thebeData.Chip == 2 or thebeData.Chip == 3 then
        self.mTimes:setString(thebeData.Chip)
    -- else
    --     self.mTimes:setString("1")
    end
    if thebeData.Constraint == 1 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"无人叫地主，随机一人成为地主") 
        self.mTimes:setString("1")          
    end
    --偶尔服务器阶段3同步消息会先回来（容错处理）
    if self.mStageStep ~= nil  and self.mStageStep.State == 3 then
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
        self.mSelfHandle:setVisible(false) 
    end
end

--出--牌--处--理-逻--辑
function CardTableDialog:GamePlayFunction()
    if self.isShow ~= true then
        return
    end
    self.mSelfHandle:setVisible(false)
    self.mLeftHandle:setVisible(false)
    self.mRightHandle:setVisible(false)
    local outPokersData = laixia.LocalPlayercfg.LaixiaOutCards or {}
    local outPokersIndex = laixia.LocalPlayercfg.LaixiaOutCardsIndex or {}
    if #outPokersData.Cards > 0 and self.mMySeatID~=outPokersData.Seat then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_play)
    end
    if self.mSelfPokers ~= nil then
        self.mSelfPokers:setOutPokers(laixia.LocalPlayercfg.LaixiaOutCardsIndex or {},laixia.LocalPlayercfg.LaixiaOutCards or {})
    end
    if self.mSynchronousData==nil then --modify by wangtianye
        return
    end
    local Players = self.mSynchronousData.Players
    local matchType =clone(outPokersIndex)
    if #outPokersData.ReplaceCardss>0 then
        matchType =outPokersData.ReplaceCardss
    end
    local outType = l_NorLogicObject:MatchCardTypeFunction(matchType,self.hLaiziCard,self.mCardType)
    self:CardEffectFunction(outType)
    if l_NorLogicObject:IsKingBombFunction(outPokersData.Cards) == true then
        self.mPreviousType = "otherType"
    end
    local sex = 0
    for index = 1,3 do
        if Players[index].Seat ==  outPokersData.Seat then
            sex = Players[index].Sex
            break
        end        
    end
    local soundPoker ={}
    if #outPokersData.ReplaceCardss>0 then
       soundPoker=outPokersData.ReplaceCardss
    else
       soundPoker=outPokersData.Cards
    end
    self:selectPlaySoundFunction(sex,outType,soundPoker,outPokersData)
    --播放就剩1、2张牌了的逻辑
    local playWarning = function(num,cell1,cell2)
        if num == 2 and cell1 == false then
            cell1 = true
            if sex == 0 then
                laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_warning_last_two)
            else
                laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_w_warning_last_two)
            end
        elseif num == 1 and cell2 == false then
            cell2 = true
            if sex == 0 then
                laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_warning_last_one)
            else
                laixia.soundTools.playSound(laixia.soundcfg.EVENT_SOUND.ui_evevt_w_warning_last_one)
            end            
        end
    end
    if self.mMySeatID == outPokersData.Seat then
        self.mRightHandle:setVisible(false)
        self:DisplayWhichClockFunction(1)
        if self.mRightPlayerOutPokersLayer ~= nil then
            self.mRightPlayerOutPokersLayer:removeFromParent()
            self.mRightPlayerOutPokersLayer = nil
        end

        --是否还原老的牌 如果出牌后服务器返回的出牌不一致，则出的牌退回，并按照服务器的出牌处理
        if self.mDiscardCards and #self.mDiscardCards>0 then

            local flag =false   
            if #outPokersData.Cards>0 then
                local countTemp = 0
                for k,v in ipairs(self.mDiscardCards) do
                    for k1,v1 in ipairs(outPokersData.Cards) do
                        if v.CardValue==v1.CardValue then
                            countTemp = countTemp +1
                        end
                    end
                end
                if countTemp ~= #outPokersData.Cards or countTemp~=#self.mDiscardCards then
                    flag =true
                end
            else
                flag =true   
            end
            if flag then    --还原出牌
                local log = "self.mDiscardCards=="
                for k,v in ipairs(self.mDiscardCards) do
                    log = log.."  "..v.CardValue
                end

                self.mSelfPokers:resetPokersCards(self.mDiscardCards)
                if self.mCancelTrusteeship:isVisible() then
                    self.mCancelTrusteeship:setTouchEnabled(true)
                    if self.mSelfPokers ~= nil then
                        self.mSelfPokers:setAllPokersTouch(false)
                    end
                    self.mSelfPokers:setTouchEnabled(false)
                    self.mSelfPokers:setBlackColor()
                end
                if self.mSelfOutPokersLayer~=nil then
                    self.mSelfOutPokersLayer:removeFromParent()
                    self.mSelfOutPokersLayer = nil
                end
            end
            self.mDiscardCards = nil
        end

        if #outPokersData.Cards == 0 then
            self.mSelfHandle:loadTexture("new_ui/CardTableDialog/table_buchu.png")
            self.mSelfHandle:setVisible(true)
        else
            --用于处理托管下的自动出牌  
            if self.mSelfOutPokersLayer == nil then
                playWarning(table.nums(self.mSelfPokers:getPokerList())-#outPokersData.Cards,self.mPokersNumAlarmTable[1],self.mPokersNumAlarmTable[2])
                self.mSelfOutPokersLayer = self.mSelfPokers:playHand(outPokersData.Cards)
                self.mSelfOutPokersLayer:addTo(self.hPanelImageWidge, 3):pos(640 - (#outPokersData.Cards-1) * 17, 330)            
            else
                playWarning(table.nums(self.mSelfPokers:getPokerList()),self.mPokersNumAlarmTable[1],self.mPokersNumAlarmTable[2])
            end
        end
        self.mTipsBiggerCard:setVisible(false)
        self.mTipsErrorCardType:setVisible(false)
        if self.mCancelTrusteeship:isVisible() == true then
            if self.mSelfPokers~=nil then
                self.mSelfPokers:setTouchEnabled(false)
                self.mSelfPokers:setBlackColor()
            end
        else
            if self.mSelfPokers~=nil then
                self.mSelfPokers:setTouchEnabled(true)  --没有托管按钮打开触摸，清除黑色
                self.mSelfPokers:clearColor()
                self.mSelfPokers:recover()
            end
        end
    end
    if self.mMySeatID ==(outPokersData.Seat + 2) % 3 then
        self.mLeftHandle:setVisible(false)
        if self.mRightPlayerOutPokersLayer ~= nil then
            self.mRightPlayerOutPokersLayer:removeFromParent()
            self.mRightPlayerOutPokersLayer = nil
        end
        if self.mLeftPlayerOutPokersLayer ~= nil then
            self.mLeftPlayerOutPokersLayer:removeFromParent()
            self.mLeftPlayerOutPokersLayer = nil
        end
        --不出牌
        if #outPokersData.Cards == 0 then
            self.mRightHandle:loadTexture("new_ui/CardTableDialog/table_buchu.png")
            self.mRightHandle:setVisible(true)
        elseif self.mRightPlayerPoker ~= nil  and self.mRightPlayerPoker:getIsOpen() == true  then
            playWarning(tonumber(self.mRightNum:getString())-#outPokersData.Cards,self.mPokersNumAlarmTable[3],self.mPokersNumAlarmTable[4])
            local PlayCardsNum = nil
            self.mRightPlayerOutPokersLayer = self.mRightPlayerPoker:playHand(outPokersData.Cards)
            self:changeCardCountFunction(l_NorLogicObject:OutCountIndexFunction(outPokersData.Cards))
            local x,y = self:GetWidgetByName("Image_RightShowPosition"):getPosition()
            self.mRightPlayerPoker:setPosition(cc.p(x - self.mRightPlayerPoker:getLayoutLength() +76 , y-49))
            if #outPokersData.Cards < 11 then
                self.mRightPlayerOutPokersLayer:setPosition(cc.p(974 - (#outPokersData.Cards-1) * 35, 500))
            else
                self.mRightPlayerOutPokersLayer:setPosition(cc.p(610, 500))
            end
            self.mRightPlayerOutPokersLayer:addTo(self.hPanelImageWidge, 3)   
        else
            playWarning(tonumber(self.mRightNum:getString())-#outPokersData.Cards,self.mPokersNumAlarmTable[3],self.mPokersNumAlarmTable[4])
            self.mRightPlayerOutPokersLayer =  GamePlayerObj.new(outPokersData.Cards,outPokersData.Seat,{selfSeat = self.mMySeatID })
            self:changeCardCountFunction(l_NorLogicObject:OutCountIndexFunction(outPokersData.Cards))
            if #outPokersData.Cards < 11 then
                self.mRightPlayerOutPokersLayer:setPosition(cc.p(974 - (#outPokersData.Cards-1) * 35, 500))
            else
                self.mRightPlayerOutPokersLayer:setPosition(cc.p(610, 500))
            end   
            self.mRightPlayerOutPokersLayer:addTo(self.hPanelImageWidge, 3)
        end
        self.mRightNum:setString(tonumber(self.mRightNum:getString()) - #outPokersData.Cards)
        if tonumber(self.mRightNum:getString()) <= 2 and self.mRightNumAlarm == nil then
            local x,y = self:GetWidgetByName("Image_RightTuoguan"):getPosition()
            self.mRightNumAlarm = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_ALARM)
            self.mRightNumAlarm:setPosition(cc.p(x-88,y-57))
            self.mRightNumAlarm:addTo(self.hPanelImageWidge,4)
        end
    end
    if self.mMySeatID ==(outPokersData.Seat + 4) % 3 then
        self.mLeftHandle:setVisible(false)
        if self.mLeftPlayerOutPokersLayer ~= nil then
            self.mLeftPlayerOutPokersLayer:removeFromParent()
            self.mLeftPlayerOutPokersLayer = nil
        end
        if self.mSelfOutPokersLayer ~= nil then
            self.mSelfOutPokersLayer:removeFromParent()
            self.mSelfOutPokersLayer = nil
        end
        if #outPokersData.Cards == 0 then
            self.mLeftHandle:loadTexture("new_ui/CardTableDialog/table_buchu.png")
            self.mLeftHandle:setVisible(true)
        elseif self.mLeftPlayerPoker ~= nil  and self.mLeftPlayerPoker:getIsOpen() == true  then
            playWarning(tonumber(self.mLeftNum:getString())-#outPokersData.Cards,self.mPokersNumAlarmTable[5],self.mPokersNumAlarmTable[6])
            local PlayCardsNum = nil
            self.mLeftPlayerOutPokersLayer = self.mLeftPlayerPoker:playHand(outPokersData.Cards)
            self:changeCardCountFunction((l_NorLogicObject:OutCountIndexFunction(outPokersData.Cards)))
            local x,y = self:GetWidgetByName("Image_LeftShowPosition"):getPosition()
            self.mLeftPlayerPoker:setPosition((cc.p(x , y-49)))  
            self.mLeftPlayerOutPokersLayer:setPosition(cc.p(314, 500))    
            self.mLeftPlayerOutPokersLayer:addTo(self.hPanelImageWidge, 3)                                
        else
            playWarning(tonumber(self.mLeftNum:getString())-#outPokersData.Cards,self.mPokersNumAlarmTable[5],self.mPokersNumAlarmTable[6])
            self.mLeftPlayerOutPokersLayer =  GamePlayerObj.new(outPokersData.Cards,outPokersData.Seat,{selfSeat = self.mMySeatID })
            self:changeCardCountFunction(l_NorLogicObject:OutCountIndexFunction(outPokersData.Cards))
            self.mLeftPlayerOutPokersLayer:setPosition(cc.p(314, 500))    
            self.mLeftPlayerOutPokersLayer:addTo(self.hPanelImageWidge, 3) 
        end
        self.mLeftNum:setString(tonumber(self.mLeftNum:getString()) - #outPokersData.Cards)
        if tonumber(self.mLeftNum:getString()) <= 2 and self.mLeftNumAlarm == nil then
            local x,y = self:GetWidgetByName("Image_LeftTuoguan"):getPosition()
            self.mLeftNumAlarm = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_ALARM)
            self.mLeftNumAlarm:setPosition(cc.p(x+58,y-57))
            self.mLeftNumAlarm:addTo(self.hPanelImageWidge,4)
        end
        
        if self.mSelfPokers ~= nil then --左边玩家最后一手牌时，自己手牌已经没有了
            --@aiType    筛选的牌型
            --@aiTable   筛选的表 默认是自己整个手牌
            --@aiOutPokersIndex 最后时候出的有效牌值
            --@aiOutPokers       出的牌值
            --@self.hLaiziCard  --癞子牌的编号
            matchType =clone(outPokersIndex)
            outType = l_NorLogicObject:MatchCardTypeFunction(matchType,self.hLaiziCard,self.mCardType)
            local aiType=outType
            local aiTable =self.mSelfPokers:getPokerData()
            local aiOutPokersIndex =clone(laixia.LocalPlayercfg.LaixiaOutCardsIndex) or {}
            local aiOutPokers=laixia.LocalPlayercfg.LaixiaOutCards or {}
             if     #laixia.LocalPlayercfg.LaixiaLaiziReplaceCards >0 then
                aiOutPokersIndex =clone(laixia.LocalPlayercfg.LaixiaLaiziReplaceCards)
            end
            self.mTips = l_NorLogicObject:tipsFunction(aiType,aiTable, aiOutPokersIndex,aiOutPokers,self.hLaiziCard)    --提示信息
        end
        --存在结算消息过来后出出牌消息（容错处理）
        local tmpData = laixia.LocalPlayercfg.LaixiaOutCards 
        if  #self.mTips == 0 and   laixia.LocalPlayercfg.LaixiaOutCards ~= nil and laixia.LocalPlayercfg.LaixiaOutCards.count  ~= 2 and self.mSelfPokers ~= nil then
            self.mTipsTime  = 0
            self.mTipsTimeOn = 30
            if not self.mCancelTrusteeship:isVisible() then
                self.mTipsBiggerCard:setVisible(true)
            end
            self.mTipsBiggerCard:setLocalZOrder(200)
            self.mSelfPokers:setTouchEnabled(false)
            self.mSelfPokers:setBlackColor()
        end
    end
----偶尔服务器阶段3同步消息会先回来（容错处理）
    if (self.mLeftNum:getString() == "20" or self.mRightNum:getString() == "20" or( self.mSelfPokers ~= nil and #self.mSelfPokers:getPokerList() == 20))  and self.mStageStep.State == 3  then
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
        self.mSelfHandle:setVisible(false)            
    end   
    self.isDealAni = true
end

--根据出--牌播--放出牌--音效
function CardTableDialog:selectPlaySoundFunction(sex,aiOutType,aiCards,aiOutPokersData)
    local outPokersData = aiOutPokersData
    self.mOutPokersIndex = l_NorLogicObject:OutCardSortFunction(clone(aiCards))
    if #aiCards == 0 then
        self:playPassSound(sex)        
    elseif  laixia.LocalPlayercfg.LaixiaOutCardsCount == 1 then
        self:playSound(sex,aiOutType, self.mOutPokersIndex[1].card_NO )  
        if aiOutType ==  l_CardTypeObj.BOMB_CARD and ( self.mOutPokersIndex[1].card_NO == 14 or self.mOutPokersIndex[1].card_NO == 15 ) then
            self.IsKingBombFunction = outPokersData.Seat    --王炸Pass     
        end
    elseif self.mPreviousType == l_CardTypeObj.ROCKET_CARD then
        self:playSound(sex,l_CardTypeObj.BOMB_CARD,13 ) --王炸Pass
        self.IsKingBombFunction = outPokersData.Seat
    elseif  self.mCardType == self.mPreviousType  and self.mPreviousType >= l_CardTypeObj.SOFT_BOMB_CARD then
        self:playSound(sex,l_CardTypeObj.BOMB_CARD )
    elseif #aiCards ~= 0 then
        if  math.random(2) == 1 and ( self.mCardType == l_CardTypeObj.SINGLE_CARD or self.mCardType == l_CardTypeObj.DOUBLE_CARD or self.mCardType ~= l_CardTypeObj.THREE_CARD  ) then
            self:playSound(sex,self.mCardType ,self.mOutPokersIndex[1].card_NO)       
        else
            local typeIndex = math.random(1,2)  
            local SEX = ""
            if sex == 0 then
                SEX = "man"
            else
                SEX = "woman"
            end
            if  typeIndex == 1 then 
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_big_you_1"])
            elseif  typeIndex == 2 then 
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_big_you_2"])
            else
                laixia.soundTools.playSound(laixia.soundcfg.POKER_SOUND[SEX.."_big_you_3"])
            end
        end
    end
end

--明--牌
function CardTableDialog:showCardFunction(msg) 
    if self.isShow ~= true then
        return
    end
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_TALKING_WINDOW)
    self.isMingPoker = 1
    local players = self.mSynchronousData.Players
    self.mShowPoker = msg.data  
    for i = 1,3 do
       if  self.mShowPoker.Seat == players[i].Seat then
            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_landlord_w_open_hand)
       end
       break
    end
    if self.mShowPoker.Seat == self.mMySeatID then
        -- 自己
        self.mSelfPokers:setOpen(true)
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
        local openPoker = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_OPENPOKER)
        openPoker:addTo(self.hPanelImageWidge,5) 
        self:GameDisplayBarFunction(4)
    elseif self.mShowPoker.Seat ==(self.mMySeatID + 4) % 3 then
        -- 右边
        if self.mRightPlayerPoker ~= nil then
            self.mRightPlayerPoker:removeFromParent()
            self.mRightPlayerPoker = nil
        end
        local aiT =
        {
            isHandCard = true,
            selfSeat = self.mMySeatID,
            isOpen = true,
            laiziPoker= self.hLaiziCard -- 癞子牌值
        }
        self.mRightPlayerPoker = GamePlayerObj.new(self.mShowPoker.CardArray, self.mShowPoker.Seat, aiT)
        self.mRightPlayerPoker:addTo(self.hPanelImageWidge)
        self.mRightPlayerPoker:setLocalZOrder(2)
        local x,y = self:GetWidgetByName("Image_RightShowPosition"):getPosition()
        self.mRightPlayerPoker:setPosition(cc.p(x - self.mRightPlayerPoker:getLayoutLength() + 76 , y-49))
        self.mRightPlayerPoker:setVisible(true)
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
        local openPoker = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_OPENPOKER)
        openPoker:addTo(self.hPanelImageWidge,5) 

    elseif self.mShowPoker.Seat ==(self.mMySeatID + 2) % 3 then
        -- 左边
        if self.mLeftPlayerPoker ~= nil then
            self.mLeftPlayerPoker:removeFromParent()
            self.mLeftPlayerPoker = nil
        end
        local x,y = self:GetWidgetByName("Image_LeftShowPosition"):getPosition()
        local aiT =
        {
            isHandCard = true,
            selfSeat = self.mMySeatID,
            isOpen = true,
            laiziPoker= self.hLaiziCard -- 癞子牌值
        }
        self.mLeftPlayerPoker = GamePlayerObj.new(self.mShowPoker.CardArray, self.mShowPoker.Seat, aiT)
        self.mLeftPlayerPoker:addTo(self.hPanelImageWidge)
        self.mLeftPlayerPoker:setLocalZOrder(2)
        self.mLeftPlayerPoker:setPosition(cc.p(x , y-49))
        self.mLeftPlayerPoker:setVisible(true)
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
        local openPoker = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_OPENPOKER)
        openPoker:addTo(self.hPanelImageWidge,5) 

    end
    self.mTimes:setString(tonumber(self.mTimes:getString())* 2)
end

-- 牌桌阶段同步消息
function CardTableDialog:synchronousStepDataFunction(msg)
    if self.isShow ~= true then
        return
    end

    self.mStageStep = msg.data
    if  self.mRoomID ==50 then
        self.mStageStep.Times =   self.mSynchronousData.TimesTamp + 20*1000
    end   
    local laizi = self.mStageStep.Laizi
    if laizi ~= nil and laizi>=0 and laizi<=13 then
       self.hLaiziCard = laizi
       self:DisplayLaiziFunction(self.hLaiziCard)
    end 
    if self.mSynchronousData ~= nil then
        local time = math.floor((self.mStageStep.Times - self.mSynchronousData.TimesTamp)/1000)
        self.mTime:setString(time)
        self.mLabelTime:setString(time)
    end
    self.mClockTime = l_hTimeObj.gettime()
    if self.mMySeatID ==(self.mStageStep.Seat + 4) % 3 then
        self.mIndex = 1
    end
   if msg.data.State == 1 then
        for i = 1,7 do
           if self.mBottomPoker[i] ~= 0 then
               self.mBottomPoker[i]:setScale(1)    
           end
        end
   end
    self:GameDisplayBarStateFunction()
end

function CardTableDialog:showPlayerInfo()
    if self.mSynchronousData == nil or  self.isShow ~= true then
        return
    end
    local players = self.mSynchronousData.Players
    local bottomSeat = laixia.LocalPlayercfg.LaixiaLandlordSeat;
    for index = 1,3 do
        if self.mMySeatID == players[index].Seat then              --我自己
            self.myPID = players[index].PID -- 玩家自己的pid
        end
        if self.mMySeatID == (players[index].Seat + 4)%3 then       --左边玩家
            self.leftPID = players[index].PID 
            self.mLeftHead.PID = players[index].PID
            self:OnRefreshHeadIconFunction(self.mLeftHead,players[index].PID,players[index].Icon)
        end
        if self.mMySeatID == (players[index].Seat + 2)%3 then        --右边玩家
            self.rightPID = players[index].PID 
            self.mRightHead.PID = players[index].PID
            self:OnRefreshHeadIconFunction(self.mRightHead,players[index].PID,players[index].Icon)
        end
    end
end


function CardTableDialog:cancelHostingFunction(msg)
    if self.isShow ~= true then
        return
    end
    if msg == nil then
        if self.mCancelTrusteeship:isVisible() then
            if self.mSelfPokers ~= nil then
                self.mSelfPokers:setAllPokersTouch(false)
                self.mSelfPokers:setTouchEnabled(false)
                self.mSelfPokers:setBlackColor()
            end
        end
        return
    elseif msg.data == nil then
        self.mCancelTrusteeship:setVisible(false)
        self.mCancelTrusteeship:setTouchEnabled(false) 
        if self.mTipsErrorCardType:isVisible() == false then
            if self.mSelfPokers ~= nil then
                self.mSelfPokers:setTouchEnabled(true)
                self.mSelfPokers:clearColor()
            end
        end
        return        
    end
    if self.mMySeatID == msg.data.Seat then
        if msg.data.Trusteeship == 1 or msg.data.Trusteeship == 2 or msg.data.Trusteeship == 3 then
            self.mCancelTrusteeship:setVisible(true)
            self.mCancelTrusteeship:setTouchEnabled(true)
            if self.mSelfPokers ~= nil then
                self.mSelfPokers:setAllPokersTouch(false)
                self.mSelfPokers:setTouchEnabled(false)
                self.mSelfPokers:setBlackColor()
            end
        else
            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
            self.mCancelTrusteeship:setVisible(false)
            self.mCancelTrusteeship:setTouchEnabled(false)
            if self.mSelfPokers ~= nil then
                self.mSelfPokers:setAllPokersTouch(false)
            end
            if self.mTipsErrorCardType:isVisible() == false then
                if self.mSelfPokers ~= nil then
                    self.mSelfPokers:setTouchEnabled(true)
                    self.mSelfPokers:clearColor()
                end
            end
            self:GameDisplayBarStateFunction()
        end
    elseif self.mMySeatID == (msg.data.Seat + 2)%3 then
        if msg.data.Trusteeship == 1 or msg.data.Trusteeship == 2 or msg.data.Trusteeship == 3 then
            self.mRightLeave:setVisible(true)
            self.mRightTuoguan:setVisible(true)
            if msg.data.Trusteeship == 2 then
                self:GetWidgetByName("Image_underline", self.mRightHeadBG):setVisible(true) 
            end
        else
            self:GetWidgetByName("Image_underline", self.mRightHeadBG):setVisible(false)
            self.mRightLeave:setVisible(false)
            self.mRightTuoguan:setVisible(false)
        end
    elseif self.mMySeatID == (msg.data.Seat + 4)%3 then
        if msg.data.Trusteeship == 1 or msg.data.Trusteeship == 2 or msg.data.Trusteeship == 3 then
            self.mLeftLeave:setVisible(true)
            self.mLeftTuoguan:setVisible(true)
            if msg.data.Trusteeship == 2 then
                self:GetWidgetByName("Image_underline", self.mLeftHeadBG):setVisible(true)
            end
        else
            self:GetWidgetByName("Image_underline", self.mLeftHeadBG):setVisible(false)
            self.mLeftLeave:setVisible(false)
            self.mLeftTuoguan:setVisible(false)
        end        
    end
end


function CardTableDialog:DisplayLaiziFunction(aiData)
    if self.isShow then  
        local pokerValue = aiData%13 + 3 
        local laizit={}
        laizit.CardValue = aiData    
        self.mBottomPoker[7]= l_cardobj.new(laizit)
        self.mBottomPoker[7]:addTo(self.mLaiziBottom:getParent())
        local x,y = self:GetWidgetByName("Image_laiziPoint"):getPosition()
        self.mBottomPoker[7]:setPosition(x,y)
        self:DisplayLaiziAnctionFunction(self.mBottomPoker[7]) 

        for i = 1,3 do
            if self.mBottomPoker[3+i]== 0 then
                self.mBottomPoker[i]:setPositionX(637+(i-2)*56)--630-64+(i-1)*34)
                self.mBottomPoker[i]:setLocalZOrder(i*10)    
            else
                self.mBottomPoker[3+i]:setPositionX(637+(i-2)*56)--630-64+(i-1)*34)
                self.mBottomPoker[3+i]:setLocalZOrder(i*10)              
            end
            self.mBottomPoker[i]:setVisible(false)
        end
    end
end
--参-数-为-地--主-的-座-位
--地主头像
function CardTableDialog:onChangePlayerImgFunction(mBottomSeat)

        -- 发地主底牌
        -- self:onShowFarmerHead(self.mSelfHead,self.mSelfHead.Sex)
        -- self:onShowFarmerHead(self.mRightHead,self.mRightHead.Sex)
        -- self:onShowFarmerHead(self.mLeftHead,self.mLeftHead.Sex)
        self:onShowFarmerHead(self:GetWidgetByName("Image_RightDizhu"))
        self:onShowFarmerHead(self:GetWidgetByName("Image_LeftDizhu"))
        self:onShowFarmerHead(self:GetWidgetByName("Image_SelfDizhu"))
        self.isHaveDiZHu = true
        local mLandlord = nil  --tDeal.ButtomSeat --地主座位
        if mBottomSeat == self.mMySeatID then --因为  self.mMySeatID 先赋值了可以使用
            self.mSelfHandle:setVisible(false)
            --self:OnDisplayLandHeadFunction(self.mSelfHead,self.mSelfHead.Sex)
            self:OnDisplayLandHeadFunction(self:GetWidgetByName("Image_SelfDizhu"),self.mSelfHead.Sex)
        elseif ( mBottomSeat + 2)%3 == self.mMySeatID then
            self.mRightHandle:setVisible(false)
            --self:OnDisplayLandHeadFunction(self.mRightHead,self.mRightHead.Sex)
            self:OnDisplayLandHeadFunction(self:GetWidgetByName("Image_RightDizhu"),self.mSelfHead.Sex)
        elseif ( mBottomSeat + 4)%3 == self.mMySeatID then
            self.mLeftHandle:setVisible(false)
            --self:OnDisplayLandHeadFunction(self.mLeftHead,self.mLeftHead.Sex)
            self:OnDisplayLandHeadFunction(self:GetWidgetByName("Image_LeftDizhu"),self.mSelfHead.Sex)
        end
end

-- 同--步-数-据--时的-底-牌-显-示 
function CardTableDialog:DisplayBottomCardFunction(aiData)
    if not self.mSynchronousData or not self.isShow then
        return
    end
    if #self.mSynchronousData.BottomCards > 0 then
        for i = 1,3 do
            self.mBottomPoker[3 + i] = l_cardobj.new(self.mSynchronousData.BottomCards[i])
            self.mBottomPoker[3 + i]:addTo(self.mBottomPoker[i]:getParent())

            self.mBottomPoker[3 + i]:setScale(0.33)
            self.mBottomPoker[3+i]:setPosition(self.mBottomPoker[i]:getPosition())
            self.mBottomPoker[3+i]:setLocalZOrder(i*10) 
        end
        self:onChangePlayerImgFunction(laixia.LocalPlayercfg.LaixiaLandlordSeat)
    end
end

-- 同-步-数-据-中-的-显-示-手-牌
function CardTableDialog:showHandPokers()
    if not self.mSynchronousData or not self.isShow then
        return
    end   
    local SynchronousData = self.mSynchronousData
    local tPlayer = SynchronousData.Players

    for k,v in ipairs(tPlayer) do
        if v.PID == laixia.LocalPlayercfg.LaixiaPlayerID then
            self:GaibianShuziWenbenFunction(self.mGold,v.Coin)
            laixia.LocalPlayercfg.MatchGold = v.Coin    --短线重连时，赋值
            break
        end
    end

    if SynchronousData.Stage == 0 then
        return
    end
    

    -- 判断自己的左右玩家位置  （？+3 （+ 1右）（-1左））%3
    self.isDealAni = true
    for k,v in ipairs(tPlayer) do
        if self.mMySeatID == v.Seat then
            if self.mSelfPokers then
                self.mSelfPokers.mPokerList = {}
                self.mSelfPokers:removeFromParent()
                self.mSelfPokers = nil
            end
            --名牌处理逻辑
            local aiT = {}
            if SynchronousData.Ming == 1 and SynchronousData.BottomSeat == v.Seat then
                aiT = 
                {
                    isHandCard = true,
                    isOpen = true,
                    isAniFinsih = true,
                    selfSeat = self.mMySeatID,
                    laiziPoker= self.hLaiziCard
                }
            else
                aiT = 
                {
                    isHandCard = true,
                    isOpen = false,
                    isAniFinsih = true,
                    selfSeat = self.mMySeatID,
                    laiziPoker= self.hLaiziCard
                }
            end
            self.mSelfPokers = GamePlayerObj.new(v.PlayerCards, v.Seat,aiT)
            self.mSelfPokers:addTo(self.hPanelImageWidge)
            self.mSelfPokers:showMark()
            self.mSelfPokers:setLocalZOrder(2)
            self.mSelfPokers:setPosition(cc.p(640, self.mSelfPokers:getContentSize().height * 0.5+54))
            self.mSelfPokers:setTouchEnabled(true)
            self.mSelfPokers:clearColor()
            self.mSelfPokers:setOutPokers(laixia.LocalPlayercfg.LaixiaOutCardsIndex or {} ,laixia.LocalPlayercfg.LaixiaOutCards or {})
            if v.MaxCard == 2 then
                self.mPokersNumAlarmTable[1] = true
            elseif v.MaxCard == 1 then
                self.mPokersNumAlarmTable[1] = true
                self.mPokersNumAlarmTable[2] = true
            end
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CHANGE_BUYRECORDER_WINDOW,true);
        end
        if self.mMySeatID ==(v.Seat + 2) % 3 then
            -- 右边牌
            if v.MaxCard > 0 then
                local aiT = {}
                if SynchronousData.Ming == 1 and SynchronousData.BottomSeat == v.Seat then
                    aiT = 
                    {
                        isHandCard = true,
                        isOpen = true,
                        isAniFinsih = true,
                        selfSeat = self.mMySeatID,
                        laiziPoker= self.hLaiziCard
                    }
                else
                    aiT = 
                    {
                        isHandCard = true,
                        isOpen = false,
                        isAniFinsih = true,
                        selfSeat = self.mMySeatID,
                        laiziPoker= self.hLaiziCard
                    }
                end
                if self.mRightPlayerPoker ~= nil then
                    self.mRightPlayerPoker:removeFromParent()
                    self.mRightPlayerPoker = nil
                end
                self.mRightPlayerPoker = GamePlayerObj.new(v.PlayerCards, v.Seat, aiT)
                self.mRightPlayerPoker:addTo(self.hPanelImageWidge)
                self.mRightPlayerPoker:setLocalZOrder(2)
                local x,y = self:GetWidgetByName("Image_RightShowPosition"):getPosition()
                self.mRightPlayerPoker:setPosition(cc.p(x - self.mRightPlayerPoker:getLayoutLength() + 76 , y-49))
            end
            if v.MaxCard <= 2 then
                if self.mRightNumAlarm ~= nil then
                    self.mRightNumAlarm:removeFromParent()
                end
                local x,y = self:GetWidgetByName("Image_RightTuoguan"):getPosition()
                self.mRightNumAlarm = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_ALARM)
                self.mRightNumAlarm:setPosition(cc.p(x-88,y-57))
                self.mRightNumAlarm:addTo(self.hPanelImageWidge,4)                
            end
            self.mRightNum:setString(v.MaxCard)
            if v.MaxCard == 2 then
                self.mPokersNumAlarmTable[3] = true
            elseif v.MaxCard == 1 then
                self.mPokersNumAlarmTable[3] = true
                self.mPokersNumAlarmTable[4] = true
            end
        end
        if self.mMySeatID ==(v.Seat + 4) % 3 then
            -- 左边牌
            if v.MaxCard > 0 then
                local aiT = {}
                if SynchronousData.Ming == 1 and SynchronousData.BottomSeat == v.Seat then
                    aiT = 
                    {
                        isHandCard = true,
                        isOpen = true,
                        isAniFinsih = true,
                        selfSeat = self.mMySeatID,
                        laiziPoker= self.hLaiziCard
                    }
                else
                    aiT = 
                    {
                        isHandCard = true,
                        isOpen = false,
                        isAniFinsih = true,
                        selfSeat = self.mMySeatID,
                        laiziPoker= self.hLaiziCard
                    }
                end
                if self.mLeftPlayerPoker ~= nil then
                    self.mLeftPlayerPoker:removeFromParent()
                    self.mLeftPlayerPoker = nil
                end
                self.mLeftPlayerPoker = GamePlayerObj.new(v.PlayerCards, v.Seat, aiT)
                self.mLeftPlayerPoker:addTo(self.hPanelImageWidge)
                self.mLeftPlayerPoker:setLocalZOrder(2)
                local x,y = self:GetWidgetByName("Image_LeftShowPosition"):getPosition()
                self.mLeftPlayerPoker:setPosition(cc.p(x, y-49))
            end
            if v.MaxCard <= 2 then
                if self.mLeftNumAlarm ~= nil then
                    self.mLeftNumAlarm:removeFromParent()
                end
                local x,y = self:GetWidgetByName("Image_LeftTuoguan"):getPosition()
                self.mLeftNumAlarm = l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_ALARM)
                self.mLeftNumAlarm:setPosition(cc.p(x+58,y-57))
                self.mLeftNumAlarm:addTo(self.hPanelImageWidge,4)                
            end
            self.mLeftNum:setString(v.MaxCard)
            if v.MaxCard == 2 then
                self.mPokersNumAlarmTable[5] = true
            elseif v.MaxCard == 1 then
                self.mPokersNumAlarmTable[5] = true
                self.mPokersNumAlarmTable[6] = true
            end
        end
    end

end

function CardTableDialog:DisplayAndSortLaiziFunction(tPlayer)
    if  self.mSelfPokers then
        self.mSelfPokers.mPokerList = {}
        self.mSelfPokers:removeFromParent()
        self.mSelfPokers = nil
    end
    local aiT = 
    {
        isHandCard = true,
        isOpen = false,
        isAniFinsih = true,
        selfSeat = self.mMySeatID,
        laiziPoker= self.hLaiziCard
    }
    print("laizi ===", self.hLaiziCard)
    self.mSelfPokers = GamePlayerObj.new(tPlayer.Cards, tPlayer.Seats,aiT)
    self.mSelfPokers:showMark()
    self.mSelfPokers:addTo(self.hPanelImageWidge)
    self.mSelfPokers:setLocalZOrder(2)
    self.mSelfPokers:setPosition(cc.p(640, self.mSelfPokers:getContentSize().height * 0.5 + 54))
    self.mSelfPokers:setTouchEnabled(true)
    self.mSelfPokers:clearColor()
    self.mSelfPokers:setOutPokers(laixia.LocalPlayercfg.LaixiaOutCardsIndex or {} ,laixia.LocalPlayercfg.LaixiaOutCards or {})
end


function CardTableDialog:DisplayLaiziAnctionFunction(laizipoker) -- 播放癞子牌动画
        local system = laixia.ani.CObjectAnimationManager;
        local orbitfront = cc.OrbitCamera:create(1, 1, 0, 90, -90, 0, 0)


       local functio1= cc.CallFunc:create(function ()
                                   local fanpai =l_EAObject:createAni(l_EDObject._ID_DICT_TYPE_DESK_FANPAI)
                                   fanpai:addTo(laizipoker,5) 
                                   fanpai:setPosition(cc.p(-640,-440)) 
                                end)

        local move = cca.moveTo(0.3,self.mLaiziBottom:getPosition())
        local scaleto =cc.ScaleTo:create(0.3,0.33)
        laizipoker:runAction(cc.Sequence:create(
                                cc.CallFunc:create(function ()
                                self:DisplayAndSortLaiziFunction(self:FindLaiziSortFunction()) 
                                end),
                                orbitfront,
                                functio1,
                                cc.ScaleTo:create(1.5,1),
                                scaleto,
                                move
                                 ))
end


-- 显-示-同-步--出-的-牌
function CardTableDialog:DisplayOutCardFunction()
    local SynchronousData = self.mSynchronousData
    if SynchronousData.Stage ~= 3 then
        -- 出牌阶段
        return
    end
    local tPlayer = SynchronousData.Players
    for index = 1, #tPlayer do
        local outPokersData = tPlayer[index].PlayCards 
        if #outPokersData > 0 then
            if self.mMySeatID == tPlayer[index].Seat and SynchronousData.CurrentSeat ~= tPlayer[index].Seat then
                if self.mSelfOutPokersLayer ~= nil then
                    self.mSelfOutPokersLayer:removeFromParent()
                    self.mSelfOutPokersLayer = nil
                end
                self.mSelfOutPokersLayer = GamePlayerObj.new(outPokersData,tPlayer[index].Seat,{selfSeat = self.mMySeatID })
                self.mSelfOutPokersLayer:setPosition(cc.p(640 - (#outPokersData -1 ) * 17, 330))
                self.mSelfOutPokersLayer:addTo(self.hPanelImageWidge, 3)
            end
            if self.mMySeatID ==(tPlayer[index].Seat + 2) % 3 and SynchronousData.CurrentSeat ~= tPlayer[index].Seat  then
                if self.mRightPlayerOutPokersLayer ~= nil then
                    self.mRightPlayerOutPokersLayer:removeFromParent()
                    self.mRightPlayerOutPokersLayer = nil
                end
                self.mRightPlayerOutPokersLayer = GamePlayerObj.new(outPokersData,tPlayer[index].Seat,{selfSeat = self.mMySeatID })
                if #outPokersData < 11 then
                    self.mRightPlayerOutPokersLayer:setPosition(cc.p(954 - (#outPokersData-1) * 17, 500))
                else
                    self.mRightPlayerOutPokersLayer:setPosition(cc.p(580, 500))
                end 
                self.mRightPlayerOutPokersLayer:addTo(self.hPanelImageWidge, 3)
            end
            if self.mMySeatID ==(tPlayer[index].Seat + 4) % 3 and SynchronousData.CurrentSeat ~= tPlayer[index].Seat  then
                if self.mLeftPlayerOutPokersLayer ~= nil then
                    self.mLeftPlayerOutPokersLayer:removeFromParent()
                    self.mLeftPlayerOutPokersLayer = nil
                end
                self.mLeftPlayerOutPokersLayer =  GamePlayerObj.new(outPokersData,tPlayer[index].Seat,{selfSeat = self.mMySeatID })
                self.mLeftPlayerOutPokersLayer:setPosition(cc.p(314, 500))
                self.mLeftPlayerOutPokersLayer:addTo(self.hPanelImageWidge, 3)
            end
        end
    end
    --
    if laixia.LocalPlayercfg.LaixiaOutCards ~= nil then
        self.mCardType = l_NorLogicObject:MatchCardTypeFunction(clone(laixia.LocalPlayercfg.LaixiaOutCardsIndex),self.hLaiziCard,self.mCardType)
            --aiType    筛选的牌型
            --aiTable   筛选的表 默认是自己整个手牌
            --aiOutPokersIndex 最后时候出的有效牌值
            --aiOutPokers       出的牌值
            --self.hLaiziCard  --癞子牌的编号
            local aiType=self.mCardType
            local aiTable =self.mSelfPokers:getPokerData()
            local aiOutPokersIndex =clone(laixia.LocalPlayercfg.LaixiaOutCardsIndex) or {} 
            local aiOutPokers=laixia.LocalPlayercfg.LaixiaOutCards or {}
             if     #laixia.LocalPlayercfg.LaixiaLaiziReplaceCards >0 then
                aiOutPokersIndex =clone(laixia.LocalPlayercfg.LaixiaLaiziReplaceCards)
            end
            self.mTips = l_NorLogicObject:tipsFunction(aiType,aiTable, aiOutPokersIndex,aiOutPokers,self.hLaiziCard) 
    end
end

--结-算-时-调-整-显-示-金-和-奖券
function CardTableDialog:ChangeGoldFunction(msg)
    if self.isShow ~= true then
        return
    end
    local deskResult = msg
    local taskNum = self.mSynchronousData.Cond;
    local player = self.mSynchronousData.Players
    self.mTimes:setString(deskResult.DoubuleValue)
    for index = 1, #deskResult.CSBalance do
        --更新任务信息
        if laixia.LocalPlayercfg.LaixiaPlayerID == deskResult.CSBalance[index].PID then
            self:GaibianShuziWenbenFunction(self.mGold,deskResult.CSBalance[index].CurrentGold)
        end
        --更新左右玩家的金
        for i = 1,3 do
            if player[i].PID == deskResult.CSBalance[index].PID then
                if self.mMySeatID == 0 then
                    --self:GaibianShuziWenbenFunction(self.mselfGold,deskResult.CSBalance[index].CurrentGold)
                end 
                if self.mMySeatID == ( player[i].Seat + 4)%3 then
                    self:GaibianShuziWenbenFunction(self.mLeftInfoGold,deskResult.CSBalance[index].CurrentGold)
                end
                if self.mMySeatID == ( player[i].Seat + 2)%3 then
                    self:GaibianShuziWenbenFunction(self.mRightInfoGold,deskResult.CSBalance[index].CurrentGold)
                end 
                break
            end
        end
    end
   --结算界面数字变化（加减数据）
   --aiNum金变化
   --aiSeat -1左边玩家  0 自己  1 右边玩家
   --aiCurrSeat 座位号
   --isWin  地主输赢true：赢 false：输
   local reslutNum = function(aiNum,aiSeat,aiCurrSeat,isWin)
        local atlasNum
        if isWin == true then
            if aiCurrSeat == laixia.LocalPlayercfg.LaixiaLandlordSeat then
                atlasNum = self.winNum:clone()
                if self.mSelfRoomID == 50  then
                   atlasNum:setString("+"..aiNum.."积分")
                else
                   atlasNum:setString("+"..aiNum.."金币")
                end
                
            else
                atlasNum = self.lostNum:clone()
                if self.mSelfRoomID == 50  then
                    atlasNum:setString(aiNum.."积分")
                else
                     atlasNum:setString(aiNum.."金币")
                end
            end
        else
            if aiCurrSeat ~= laixia.LocalPlayercfg.LaixiaLandlordSeat then
                atlasNum = self.winNum:clone()
                if self.mSelfRoomID == 50  then
                   atlasNum:setString("+"..aiNum.."积分")
                else
                   atlasNum:setString("+"..aiNum.."金币")
                end                
            else
                atlasNum = self.lostNum:clone()
                if self.mSelfRoomID == 50  then
                   atlasNum:setString(aiNum.."积分")
                else
                   atlasNum:setString(aiNum.."金币")
                end
                
            end            
        end
        atlasNum:setAnchorPoint(cc.p(0,0.5))
        if aiSeat == -1 then
            atlasNum:setPosition(cc.p(200,636))

        elseif aiSeat == 0 then
            atlasNum:setPosition(cc.p(200,180))
     
        elseif aiSeat == 1 then
            atlasNum:setPosition(cc.p(1090-atlasNum:getContentSize().width,636))
            
        end 
        --atlasNum:addTo(self.hPanelImageWidge,5)

        transition.execute(atlasNum, cc.DelayTime:create(2), {
                    delay = 2,
                    onComplete = function()
                        atlasNum:removeFromParent()
                        atlasNum = nil

                        self.mGoldChangeTable = {0,0,0,0,0,0}    --初始化表数据
                    end,
                }) 
        return   atlasNum
   end 
   --判断用户输赢
   local index0
   for i = 1,3 do
        for j = 1,3 do
            if deskResult.CSBalance[i].PID == player[j].PID then
                if laixia.LocalPlayercfg.LaixiaLandlordSeat == player[j].Seat then
                    if deskResult.CSBalance[i].Chip > 0 then
                        index0 = true
                    else
                        index0 = false
                    end
                    break
                end
            end
        end
   end
   --显示金变化效果
   self.mGoldChangeTable = {0,0,0,0,0,0}    --存储结算UI对象
   for i = 1,3 do
        for j = 1,3 do
            if deskResult.CSBalance[i].PID == player[j].PID then
                if player[j].Seat == self.mMySeatID then
                   self.mGoldChangeTable[1] = reslutNum(deskResult.CSBalance[i].Chip,0,player[j].Seat,index0)
                end
                if self.mMySeatID == (player[j].Seat + 4)%3 then--左
                   self.mGoldChangeTable[2] = reslutNum(deskResult.CSBalance[i].Chip,-1,player[j].Seat,index0)
                end
                if self.mMySeatID == (player[j].Seat + 2)%3 then--右
                   self.mGoldChangeTable[3] = reslutNum(deskResult.CSBalance[i].Chip,1,player[j].Seat,index0)
                end
                break                
            end 
        end
   end
   self:HideInfoByEndFunction()
end

function CardTableDialog:createResultDataFunction(data)
    --结算界面表
    local result = {}
    --msg.data.CSBalance
    result.player = {{},{},{}}
    result.BaseValue = data.BaseValue  --胜负的底分
    result.times = data.DoubuleValue  --倍数
    result.spriting = data.Spring --是否春天
    result.difen = data.difen --叫的分数
    result.boomTimes  = data.boomTimes --炸弹书
    result.jixu = data.jixu
    result.RooketTimes = data.RooketTimes

    local islandlordWin = false --地主是否胜利
    local landlordGold = 0
    for i = 1,3 do
        if self.mBottomPID ==  data.CSBalance[i].PID  then
            landlordGold = data.CSBalance[i].Chip 
            if data.CSBalance[i].Chip > 0 then
                islandlordWin = true
            else
                islandlordWin = false
            end
            break
        end
    end

    for i = 1,3  do
        if self.myPID == data.CSBalance[i].PID then
            self.mGold:setString(laixia.helper.numeralRules_2(data.CSBalance[i].CurrentGold))
            --self.mGold:setString(data.CSBalance[i].CurrentGold)
        elseif self.rightPID == data.CSBalance[i].PID then
            --self.mRightInfoGold:setString(data.CSBalance[i].CurrentGold)
            self.mRightInfoGold:setString(laixia.helper.numeralRules_2(data.CSBalance[i].CurrentGold))
        elseif self.leftPID ==data.CSBalance[i].PID then
           --self.mLeftInfoGold:setString(data.CSBalance[i].CurrentGold)
           self.mLeftInfoGold:setString(laixia.helper.numeralRules_2(data.CSBalance[i].CurrentGold))
        end
    end
    
    local value = function(aiPlayer,index)
        aiPlayer.rmpf = self.mSynchronousData.Players[index].rxpm
        aiPlayer.sex = self.mSynchronousData.Players[index].Sex
        aiPlayer.statusID = 0
        aiPlayer.Nickname = self.mSynchronousData.Players[index].Nickname
        aiPlayer.PID  = self.mSynchronousData.Players[index].PID 
        aiPlayer.Icon = self.mSynchronousData.Players[index].Icon
        for j = 1,3 do
            if data.CSBalance[j].PID == self.mSynchronousData.Players[index].PID  then
                aiPlayer.changeGold = data.CSBalance[j].Chip
                aiPlayer.haveGold = data.CSBalance[j].CurrentGold
                if self.mSynchronousData.Players[index].PID == self.mBottomPID and islandlordWin == true then
                    aiPlayer.isLandlord = 1
                    aiPlayer.isWin = 1
                    if self.mSynchronousData.Players[index].Coin == data.CSBalance[j].Chip then
                        aiPlayer.statusID = 1
                    end
                elseif self.mSynchronousData.Players[index].PID == self.mBottomPID and islandlordWin == false then
                    aiPlayer.isLandlord = 1
                    aiPlayer.isWin = 0
                    if self.mSynchronousData.Players[index].Coin + data.CSBalance[j].Chip <= 0 then
                        aiPlayer.statusID = 3
                    end
                elseif self.mSynchronousData.Players[index].PID ~= self.mBottomPID and islandlordWin == true then
                    aiPlayer.isLandlord = 0
                    aiPlayer.isWin = 0
                    if data.CSBalance[j].Chip + landlordGold == 0 then
                        aiPlayer.statusID = 2
                    elseif data.CSBalance[j].CurrentGold <= 0 then 
                        aiPlayer.statusID = 3
                    end
                elseif self.mSynchronousData.Players[index].PID ~= self.mBottomPID and islandlordWin == false then
                    aiPlayer.isLandlord = 0
                    aiPlayer.isWin = 1
                    if data.CSBalance[j].Chip == 0 then
                        aiPlayer.statusID = 2
                    end
                end
                break  
            end  
        end
    end
    for i = 1,3 do
        if self.mMySeatID == self.mSynchronousData.Players[i].Seat then
            value(result.player[1],i)
            if laixia.LocalPlayercfg.LaixiaPlayerID == self.mBottomPID and islandlordWin == true then
                result.state  = 1
            elseif laixia.LocalPlayercfg.LaixiaPlayerID == self.mBottomPID and islandlordWin == false then
                result.state  = 2
            elseif laixia.LocalPlayercfg.LaixiaPlayerID ~= self.mBottomPID and islandlordWin == true then
                result.state  = 4
            elseif laixia.LocalPlayercfg.LaixiaPlayerID ~= self.mBottomPID and islandlordWin == false then
                result.state  = 3
            end
        elseif self.mMySeatID == (self.mSynchronousData.Players[i].Seat + 2)%3 then
            value(result.player[2],i)
        elseif self.mMySeatID == (self.mSynchronousData.Players[i].Seat + 4)%3 then
            value(result.player[3],i)
        end
    end


    result.jixu = 0 --可以继续
    --关闭商城和超级礼包页面和购买记牌器页面
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_SHOP_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_SUPERGIFT_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_BUYRECORDER_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_USEINFO_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_SETUP_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_HELP_WINDOW)

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_TALKING_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_REDEEMGIFT_WINDOW)

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_INCREASEGOLD_WINDOW)
    --显示结算界面
   self:GetWidgetByName("Button_CancelTrusteeship"):setTouchEnabled(false)
   if self.mSelfRoomID ~= 50 then
        -----------------------------------------------------------
        if self.isShow ~= true then
        return
    end

    if self.mTipsBiggerCard ~= nil then
        self.mTipsBiggerCard:setVisible(false)
    end
    if self.mTipsErrorCardType ~= nil then
        self.mTipsErrorCardType:setVisible(false)
    end
    if self.mLeftHandle ~= nil then
        self.mLeftHandle:setVisible(false)
    end
    if self.mRightHandle ~= nil then
        self.mRightHandle:setVisible(false)
    end
    if self.mSelfHandle ~= nil then
        self.mSelfHandle:setVisible(false)
    end

    self:OnRecHeadSizeFunction(self.mSelfHead )
    self:OnRecHeadSizeFunction(self.mLeftHead)
    self:OnRecHeadSizeFunction(self.mRightHead)
    --self:OnRefreshHeadIconFunction(self.mSelfHead,nil,nil)

    self.mLeftHead.PID = -1
    self.mRightHead.PID = -1

    if self.mLeftNum ~= nil then
        self.mLeftNum:setString(0)
        self.mLeftNum:setVisible(false)
    end
    if self.mRightNum ~= nil then
        self.mRightNum:setString(0)
        self.mRightNum:setVisible(false)
    end

    self.isDownState = 0  --0:初始化 1 触发降级条件
    self.isDealAni = false
    self.isHaveDiZHu = false
    self.mNowType   = nil
    self.mPreviousType = nil 
    self.mIndex = 1
    self.mTips = {}
    self.mCardType = nil
    self.mNewOutType = 0

    self.mLocalTime = nil
    self.mBottomPID = -1
    self.mOutPokersIndex = nil
    self.mDiscardCards = nil
    if self.mSelfPokers ~= nil then
        --防止选中的牌没有删掉
        self.mSelfPokers.mPokerList = {}
        self.mSelfPokers:removeFromParent()
        self.mSelfPokers = nil
    end
    if self.mLeftPlayerPoker ~= nil then
        self.mLeftPlayerPoker:removeFromParent()
        self.mLeftPlayerPoker = nil
    end
    if self.mRightPlayerPoker ~= nil then
        self.mRightPlayerPoker:removeFromParent()
        self.mRightPlayerPoker = nil
    end
    if self.mSelfOutPokersLayer ~= nil then
        self.mSelfOutPokersLayer:removeFromParent()
        self.mSelfOutPokersLayer = nil
    end
    if self.mRightPlayerOutPokersLayer ~= nil then
        self.mRightPlayerOutPokersLayer:removeFromParent()
        self.mRightPlayerOutPokersLayer = nil
    end
    if self.mLeftPlayerOutPokersLayer ~= nil then
        self.mLeftPlayerOutPokersLayer:removeFromParent()
        self.mLeftPlayerOutPokersLayer = nil
    end
    if  self.mSelfPlayerClearPokersLayer ~= nil then
        self.mSelfPlayerClearPokersLayer:removeFromParent()
        self.mSelfPlayerClearPokersLayer = nil
    end
    if self.mRightPlayerClearPokersLayer ~= nil then
        self.mRightPlayerClearPokersLayer:removeFromParent()
        self.mRightPlayerClearPokersLayer = nil
    end
    if  self.mLeftPlayerClearPokersLayer ~= nil then
        self.mLeftPlayerClearPokersLayer:removeFromParent()
        self.mLeftPlayerClearPokersLayer = nil
    end
    if self.mSelfTalk ~= nil then
        self.mSelfTalk:removeFromParent()
        self.mSelfTalk = nil  
    end
    if self.mRightTalk ~= nil then
        self.mRightTalk:removeFromParent()
        self.mRightTalk = nil  
    end
    if self.mLeftTalk ~= nil then
        self.mLeftTalk:removeFromParent()
        self.mLeftTalk = nil  
    end

    self:HideAnimationFunction()
    self.mEffect = nil
    self.mEffect = {}
    if self.mPokersNumAlarmTable ~= nil then
        for index = 1,#self.mPokersNumAlarmTable do
            self.mPokersNumAlarmTable[index] = false
        end
    end
    self.mClockTime = 0
    self.mStageStep = nil
    laixia.LocalPlayercfg.LaixiaOutCards = nil
    laixia.LocalPlayercfg.LaixiaOutCardsIndex = nil
    self.mSynchronousData = nil 
    self.mStageStep = nil
    self.IsKingBombFunction = -1
    self.mMySeatID = -1
    laixia.LocalPlayercfg.LaixiaMySeat = -1
    laixia.LocalPlayercfg.LaixiaLandlordSeat = -1

    laixia.LocalPlayercfg.LaixiaOutCardsCount = 0
    self.intoWindowsData = nil


    if self:GetWidgetByName("Image_BottomPoker1") ~= nil and self:GetWidgetByName("Image_BottomPoker2") ~= nil and self:GetWidgetByName("Image_BottomPoker3") ~= nil then
        self:GetWidgetByName("Image_BottomPoker1"):setVisible(true)
        self:GetWidgetByName("Image_BottomPoker2"):setVisible(true)
        self:GetWidgetByName("Image_BottomPoker3"):setVisible(true)
    end
    for i = 4,7 do
        if self.mBottomPoker ~= nil and self.mBottomPoker[i] ~= 0 then
            self.mBottomPoker[i]:removeFromParent()
            self.mBottomPoker[i] = 0
        end
    end

    for i = 1,3 do
        self.mBottomPoker[i]:setPositionX(637+(i-2)*56)
    end
    self.bDelInfoDisplay = false
    laixia.LocalPlayercfg.LaixiaLaiziReplaceCards={} -- 清理牌桌的时候一定要吧癞子匹配的牌清理了，否则会出现数值污染
    self.hLaiziCard =-1
    if (self.mPokerDeskType ~=1 and self.mPokerDeskType ~=2 and self.mPokerDeskType ~=0) and self.mTimes  ~= nil then
        self.mTimes:setVisible(false)
    end
    if (self.mPokerDeskType ~=1 and self.mPokerDeskType ~=2 and self.mPokerDeskType ~=0) and self.mResultNum  ~= nil then
        self.mResultNum:setVisible(false)
    end
    if self.mLeftNum ~= nil then
        self.mLeftNum:setVisible(false)
    end
    if self.mRightNum ~= nil then
        self.mRightNum:setVisible(false)
    end
    if self.mClock ~= nil  then
        self:DisplayWhichClockFunction(0)
    end
    if self.mRightNumAlarm ~= nil then
        self.mRightNumAlarm:removeFromParent()
        self.mRightNumAlarm = nil
    end
    if self.mLeftNumAlarm ~= nil then
        self.mLeftNumAlarm:removeFromParent()
        self.mLeftNumAlarm = nil
    end

    if self.mLeftHeadBG ~= nil then
        self.mLeftHeadBG:setVisible(false)
    end
    if self.mRightHeadBG ~= nil then
        self.mRightHeadBG:setVisible(false)
    end

    if self.mRightHeadRole ~= nil then
        self.mRightHeadRole:setVisible(false)
    end

    if self.mCallPointBar ~= nil then
        self:ChangeTouchbarFunction(self.mCallPointBar, false)
    end


    if self.mPointArray ~= nil and (#self.mPointArray >0 )  then
      for i=2 ,#self.mPointArray do
          local bt = self.mPointArray[i]
          bt:setTouchEnabled(true)
          bt: setBright(true)
          local num = i -1 
          -- local icon = self:GetWidgetByName("Image_Button",bt)
          -- local imgPath =  "table_btn_"..num.."fen.png"   
          -- icon:loadTexture(imgPath,1)
            self:ChangButBrightFunction(true,bt)
      end
      
    end
    if self.mThebeBar ~= nil then
        self:ChangeTouchbarFunction(self.mThebeBar, false)
    end
    if self.mGrabBar ~= nil then
        self:ChangeTouchbarFunction(self.mGrabBar, false)
    end
    if self.mPlayBar ~= nil then
        self:ChangeTouchbarFunction(self.mPlayBar, false)
    end 
    if self.mIsDouble~= nil then 
        self.mIsDouble:setVisible(false)
    end 

    if self.mLeftTuoguan ~= nil then 
        self.mLeftTuoguan:setVisible(false)
    end 

    if self.mRightTuoguan ~= nil then 
        self.mRightTuoguan:setVisible(false)
    end 

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CHANGE_BUYRECORDER_WINDOW,false); 

    result.gametype = self.mPokerDeskType

        -----------------------------------------------------------
        self.mLeftInfoGold:setString("0")
        self.mRightInfoGold:setString("0")
        self.mTimes:setString("0")
        if self:GetWidgetByName("Image_BottomPoker1") ~= nil and self:GetWidgetByName("Image_BottomPoker2") ~= nil and self:GetWidgetByName("Image_BottomPoker3") ~= nil then
            self:GetWidgetByName("Image_BottomPoker1"):setVisible(true)
            self:GetWidgetByName("Image_BottomPoker1"):setScale(1)
            self:GetWidgetByName("Image_BottomPoker2"):setVisible(true)
            self:GetWidgetByName("Image_BottomPoker2"):setScale(1)
            self:GetWidgetByName("Image_BottomPoker3"):setVisible(true)
            self:GetWidgetByName("Image_BottomPoker3"):setScale(1)
        end
        self.mLeftHead:removeAllChildren()
        self.mRightHead:removeAllChildren()
    end 
   ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_TABLERESULT_WINDOW,result)
end

-- 属-性-同-步
-- 修-改-牌-桌-倍数-低分
function CardTableDialog:attributeChangeFunction(msg)
    if self.isShow ~= true then 
        return
    end
    local changeData = msg.data
    for index = 1, #changeData.AttriChangeItem do-- 经验
        if changeData.AttriChangeItem[index].attType == 0 then-- 金钱
        elseif changeData.AttriChangeItem[index].attType == 1 then

            if  (self.mPokerDeskType == 1 or self.mPokerDeskType == 2 or self.mPokerDeskType == 0 ) then
                self:GaibianShuziWenbenFunction(self.mGold,changeData.AttriChangeItem[index].value)
            end
        elseif changeData.AttriChangeItem[index].attType == 2 then
            self.mTimes:setString(changeData.AttriChangeItem[index].value)
        end
    end
end

--牌局结束隐藏警灯名牌信息等
function CardTableDialog:HideInfoByEndFunction()
--警灯隐藏
    if self.mRightNumAlarm ~= nil then
        self.mRightNumAlarm:removeFromParent()
        self.mRightNumAlarm = nil
    end
    if self.mLeftNumAlarm ~= nil then
        self.mLeftNumAlarm:removeFromParent()
        self.mLeftNumAlarm = nil
    end
    --右边名牌隐藏
    if self.mRightPlayerPoker ~= nil then
        self.mRightPlayerPoker:removeFromParent()
        self.mRightPlayerPoker = nil
    end
    --左边名牌隐藏
    if self.mLeftPlayerPoker ~= nil then
        self.mLeftPlayerPoker:removeFromParent()
        self.mLeftPlayerPoker = nil
    end

    --左右剩余牌数值隐藏
    self.mRightNum:setVisible(false)  
    self.mLeftNum:setVisible(false) 
    --左右剩余牌图标隐藏
    self:GetWidgetByName("Image_LeftHeadCard"):setVisible(false)
    self:GetWidgetByName("Image_RightHeadCard"):setVisible(false) 
end

function CardTableDialog:barVisibleChange(aiBar)
    self:ChangeTouchbarFunction(self.mThebeBar, false)
    self:ChangeTouchbarFunction(self.mGrabBar, false)
    self:ChangeTouchbarFunction(self.mPlayBar, false)
    self:ChangeTouchbarFunction(self.mCallPointBar, false)
    self:ChangeTouchbarFunction(aiBar, true)
end

-- 每个Bar 可见、触摸变化
function CardTableDialog:ChangeTouchbarFunction(sender, aiBool)
    sender:setTouchEnabled(aiBool)
    sender:setVisible(aiBool)
    local children = sender:getChildren();
    for index = 1, #children do
        children[index]:setTouchEnabled(aiBool)
    end
end


--发-牌-动-画
function CardTableDialog:GameDealAniFunction()
    if self.isShow ~= true then
        return
    end
    self.isDealAni = true
    self:DisplayWhichClockFunction(1)
    self:GameDisplayBarStateFunction()
end

--清-算-时-亮-牌
function  CardTableDialog:GameClearCardFunction(aiData)
    if self.isShow ~= true then
        return
    end
    -- 托管初始化
    laixia.LocalPlayercfg.LaixiaisTrusteeship = false
    laixia.LocalPlayercfg.LaixiaLaiziReplaceCards={}  ---对他进行置空处理防止，最后亮牌的时候有影响
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CHANGE_BUYRECORDER_WINDOW,false);
    self.isPlay = false
      if self.mPokerDeskType == 8 or self.mPokerDeskType == 9 or self.mPokerDeskType == 10 or self.mPokerDeskType == 11 then
        self:GetWidgetByName("Button_BackToLobby"):setTouchEnabled(true)
        self:GetWidgetByName("Button_BackToLobby"):setEnabled(true)
        self:GetWidgetByName("Button_BackToLobby"):setBrightStyle(0)
    end
    self.mRightLeave:setVisible(false)
    self.mLeftLeave:setVisible(false)
    self.mLeftHandle:setVisible(false)
    self.mRightHandle:setVisible(false)
    self.mSelfHandle:setVisible(false)
    self.mCancelTrusteeship:setVisible(false) 
    self.mCancelTrusteeship:setTouchEnabled(false)
    self.mTipsErrorCardType:setVisible(false)
    self.mTipsBiggerCard:setVisible(false)
    self.mSelfPokers:clearColor()
    self.bDelInfoDisplay = true
    self:DisplayWhichClockFunction(0) --modify by wangtianye 清掉闹钟动画
    for index = 1,#aiData.data.AllClearPokers  do
        if self.mMySeatID == aiData.data.AllClearPokers[index].Seat then
            local aiT = 
            {
                selfSeat = self.mMySeatID,
                isAniFinsih = true,
                isDealBottomAni = true,
                laiziPoker= self.hLaiziCard -- 癞子牌值
            }
            self.mSelfPlayerClearPokersLayer = GamePlayerObj.new(aiData.data.AllClearPokers[index].ClearPokers,aiData.data.AllClearPokers[index].Seat,aiT)
            self.mSelfPlayerClearPokersLayer:setPosition(cc.p(640 - (#aiData.data.AllClearPokers[index].ClearPokers-1) * 17, 289))
            self.mSelfPlayerClearPokersLayer:addTo(self.hPanelImageWidge, 3) 

            if #aiData.data.AllClearPokers[index].ClearPokers ~= 0 then
                if self.mSelfOutPokersLayer ~= nil then
                    self.mSelfOutPokersLayer:removeFromParent()
                    self.mSelfOutPokersLayer = nil
                end
                if self.mSelfPokers ~= nil then
                    self.mSelfPokers:removeFromParent()
                    self.mSelfPokers = nil
                end
            end
        elseif self.mMySeatID == ( aiData.data.AllClearPokers[index].Seat + 2 )%3  then
            if #aiData.data.AllClearPokers[index].ClearPokers > 0 then
                local aiT = 
                {
                    selfSeat = self.mMySeatID,
                    isAniFinsih = true,
                    isDealBottomAni = true,
                    laiziPoker= self.hLaiziCard -- 癞子牌值
                }
                self.mRightPlayerClearPokersLayer = GamePlayerObj.new(aiData.data.AllClearPokers[index].ClearPokers,aiData.data.AllClearPokers[index].Seat,aiT)
                if #aiData.data.AllClearPokers[index].ClearPokers < 11 then
                    self.mRightPlayerClearPokersLayer:setPosition(cc.p(1102 - #aiData.data.AllClearPokers[index].ClearPokers * 34, 500))
                else
                    self.mRightPlayerClearPokersLayer:setPosition(cc.p(766, 500))
                end
                self.mRightPlayerClearPokersLayer:addTo(self.hPanelImageWidge, 3)

            end
            if #aiData.data.AllClearPokers[index].ClearPokers ~= 0  then
                if self.mRightPlayerOutPokersLayer ~= nil then
                    self.mRightPlayerOutPokersLayer:removeFromParent()
                    self.mRightPlayerOutPokersLayer = nil 
                end
                if self.mRightPlayerPoker ~= nil then
                    self.mRightPlayerPoker:removeFromParent()
                    self.mRightPlayerPoker = nil
                end
            end
        elseif self.mMySeatID == ( aiData.data.AllClearPokers[index].Seat + 4 )%3  then
            if #aiData.data.AllClearPokers[index].ClearPokers > 0 then
                local aiT = 
                {
                    selfSeat = self.mMySeatID,
                    isAniFinsih = true,
                    isDealBottomAni = true,
                    laiziPoker= self.hLaiziCard -- 癞子牌值
                }
                self.mLeftPlayerClearPokersLayer = GamePlayerObj.new(aiData.data.AllClearPokers[index].ClearPokers,aiData.data.AllClearPokers[index].Seat,aiT)
                self.mLeftPlayerClearPokersLayer:setPosition(cc.p(212, 500))
                self.mLeftPlayerClearPokersLayer:addTo(self.hPanelImageWidge, 3)

            end
            if #aiData.data.AllClearPokers[index].ClearPokers ~= 0   then
                if self.mLeftPlayerOutPokersLayer ~= nil then
                    self.mLeftPlayerOutPokersLayer:removeFromParent()
                    self.mLeftPlayerOutPokersLayer = nil 
                end
                if self.mLeftPlayerPoker ~= nil then
                    self.mLeftPlayerPoker:removeFromParent()
                    self.mLeftPlayerPoker = nil
                end
            end
        end
    end 
end


function CardTableDialog:OnRefreshUIGold(msg)
    local data = msg.data

    for i,v in ipairs(data) do
       if v.playerID == laixia.LocalPlayercfg.LaixiaPlayerID then
           self.mGold:setString(v.AllFen )
       elseif v.playerID == self.mLeftHead.PID  then
           self.mLeftInfoGold:setString(v.AllFen )
       elseif v.playerID == self.mRightHead.PID  then
           self.mRightInfoGold:setString(v.AllFen ) 
       end
    end

end

--操作条控制显示和 王炸pass
--[[
    0:等待发牌
    1：显示叫地主
    2：显示强地主
    3：王炸pass
    4：自己是地主，自己首轮出牌断线重连名牌按钮不显示（点击名牌后的效果）
    5：自己是地主，自己首轮出牌断线重连名牌按钮显示（点击名牌前的效果）
    6：自己自由出牌，没有上起的牌
    7：自己管牌时，没有上起的牌
    8：自己自由出牌，有上起的牌
    9：自己管牌时，有上起的牌
    10：自己手牌不可选状态
--]]

--发-送-出-牌-信-息
function CardTableDialog:GamesendDiscardFunction(cards,PoketType,mshowPoker)

    if PoketType == nil then
        PoketType = 0
    end
    if mshowPoker == nil  then
       mshowPoker={}
    end
    self.mDiscardCards = cards

    local packet = l_PacketObj.new("CSPlayCards", _LAIXIA_PACKET_CS_PlayCardsID)
    packet:setValue("RoomID", self.mRoomID)-- 写入包数据
    packet:setValue("TableID", self.hDeskID)
    packet:setValue("PlayCards", cards )
    packet:setValue("ReplaceCards", mshowPoker )
    packet:setValue("CardType", PoketType )
    laixia.net.sendPacketAndWaiting(packet)
    self.mCardType = l_CardTypeObj.AUTO_CARD  --置零

end

function CardTableDialog:GameDisplayBarStateFunction()
    self:ChangeTouchbarFunction(self.mThebeBar, false)
    self:ChangeTouchbarFunction(self.mGrabBar, false)
    self:ChangeTouchbarFunction(self.mPlayBar, false)
    self:ChangeTouchbarFunction(self.mCallPointBar, false) 
    local tStep
    local tCurrentSeat
    local tSynchronousData = self.mSynchronousData
    --local flag = false
    -- false:不是断线重连 true：断线重连
    -- 新→→→→牌桌阶段(0:"Idle"空闲  1:"Bid"叫分 2:"Grab"抢地主 3:"Opening"开局 4:"End"结算)
    if self.mStageStep == nil then
        for index = 1, 3 do
            if #tSynchronousData.Players[index].PlayerCards <= 0  then
                return
            end
        end
        tStep = tSynchronousData.Stage
        tCurrentSeat = tSynchronousData.CurrentSeat
        self.mTime:setString(tSynchronousData.Time)
        if tSynchronousData.Stage > 0  and tSynchronousData.Stage < 4 then
            self:DisplayWhichClockFunction(1)
        end
    else
        tStep = self.mStageStep.State
        tCurrentSeat = self.mStageStep.Seat
    end
    --出牌阶段 去掉其他阶段字提示 
    --断线重连
    if (self.mLeftNum:getString() == "20" or self.mRightNum:getString() == "20" or( laixia.LocalPlayercfg.mDeal ~= nil  and  #laixia.LocalPlayercfg.mDeal.Cards == 20) ) and tStep == 3  then
        self.mLeftHandle:setVisible(false)
        self.mRightHandle:setVisible(false)
        self.mSelfHandle:setVisible(false)            
    end
    laixia.logGame("CardTableDialog:GameDisplayBarStateFunction()-->tCurrentSeat = "..tCurrentSeat)
    laixia.logGame("CardTableDialog:GameDisplayBarStateFunction()-->tSeatID = "..self.mMySeatID)
    if tCurrentSeat == self.mMySeatID then
        if self.mSynchronousData.TableType == 0  then
           if self.mCancelTrusteeship and self.mCancelTrusteeship:isVisible() then
                self:RefreshClockPostionFunction(1)
            else
               self:RefreshClockPostionFunction(6)
            end
        else
           self:RefreshClockPostionFunction(3)
        end

        if self.mCancelTrusteeship:isVisible() == true or self.isDealAni == false then
            return
        end
        local outPokersData = laixia.LocalPlayercfg.LaixiaOutCards
        local flag = false
        if tStep == 0 then 
            self:GameDisplayBarFunction(0)
        elseif tStep == 1 then
            self:GameDisplayBarFunction(1)
        elseif tStep == 2 then
            self:GameDisplayBarFunction(2)
        elseif tStep == 3 and  self.IsKingBombFunction ~= -1 and self.IsKingBombFunction ~= self.mMySeatID then
            self:GameDisplayBarFunction(3)
            return
        elseif tStep == 3 and table.nums(self.mSelfPokers:getPokerList()) == 20 and self.isMingPoker == 1 then
            self:GameDisplayBarFunction(4)
        elseif tStep == 3 and table.nums(self.mSelfPokers:getPokerList()) == 20 and self.isMingPoker ~= 1 then
            self:GameDisplayBarFunction(5)
        elseif tStep == 3 and table.nums(self.mSelfPokers:getPokerList()) ~= 20 and outPokersData ~= nil and outPokersData.count == 2 then
            for k,v in pairs(self.mSelfPokers:getPokerList()) do
                if v:isSelect() == true then
                    self:GameDisplayBarFunction(8)
                    flag = true
                    break
                end 
            end
            if flag == false then
                self:GameDisplayBarFunction(6)
            end
        elseif tStep == 3 and table.nums(self.mSelfPokers:getPokerList()) ~= 20 and self.mSelfPokers:isTouchEnabled() == true then
            for k,v in pairs(self.mSelfPokers:getPokerList()) do
                if v:isSelect() == true then
                    self:GameDisplayBarFunction(7)
                    flag = true
                    break
                end 
            end
            if flag == false then
                self:GameDisplayBarFunction(9)
            end
        elseif  tStep == 3 and table.nums(self.mSelfPokers:getPokerList()) ~= 20 and self.mSelfPokers:isTouchEnabled() == false then 
            self:GameDisplayBarFunction(10)
        elseif   self.mTips ~=nil and #self.mTips == 0 and laixia.LocalPlayercfg.LaixiaOutCards ~= nil and laixia.LocalPlayercfg.LaixiaOutCards.count  ~= 2  then
            self:GameDisplayBarFunction(11)
        elseif   tStep == 4 then
            self:GameDisplayBarFunction(0)
        end
        self.mSelfHandle:setVisible(false)
    elseif tCurrentSeat ==(self.mMySeatID + 4) % 3 then  -- 右边
        self.mRightHandle:setVisible(false)
        self:RefreshClockPostionFunction(5)
    elseif tCurrentSeat ==(self.mMySeatID + 2) % 3 then -- 左边
        self.mLeftHandle:setVisible(false)
        self:RefreshClockPostionFunction(4)
    end
end

--按钮显示状态
function CardTableDialog:GameDisplayBarFunction(aiType)
    laixia.logGame("CardTableDialog:GameDisplayBarFunction()-->type = "..aiType)
    if aiType == 0 then 

    elseif aiType == 1 then
        if self.mSynchronousData.TableType == 0 then
            self:barVisibleChange(self.mCallPointBar)
        else
            if self.isShowThebeBar == false or  self.isShowThebeBar == nil then
                self.isShowThebeBar = true
                self:barVisibleChange(self.mThebeBar)
            end
        end

    elseif aiType == 2 then
        self:barVisibleChange(self.mGrabBar)
    elseif aiType == 3 then 
        if self.IsKingBombFunction ~= -1 and self.IsKingBombFunction ~= self.mMySeatID  then    --王炸pass
            self:GamesendDiscardFunction({})
            self.IsKingBombFunction = -1
            return        
        end
    elseif aiType == 4 then --玩家首出状态
        self.mSelfHandle:setVisible(false)
        self:barVisibleChange(self.mPlayBar)
        self:RefreshPassBtnStateFunction(3)--不出最左边 并且不可点
        self:IsDiaplayHintFunction(3)--显示提示 不可点
        self:IsDiaplayDoubleFunction(4) --明牌按钮 不理
        self:RefreshPlayBtnStateFunction(3)--出牌按钮显示 
        self:RefreshResetBtnStateFunction(3)--重选按钮灰
        self:RefreshClockPostionFunction(1)
    elseif aiType == 5 then --明牌？别人不要地主 我变成的首出 重连首出
        self.mSelfHandle:setVisible(false)
        self:barVisibleChange(self.mPlayBar)
        self:RefreshPassBtnStateFunction(3) --显示不出 不可点
        self:IsDiaplayHintFunction(3) --显示提示 不可点
        self:RefreshPlayBtnStateFunction(3) --显示出牌 不可点
        self:IsDiaplayDoubleFunction(4) --显示明牌  --yuanlaishi1
        self:RefreshResetBtnStateFunction(3) --显示重选按钮 不可点
        self:RefreshClockPostionFunction(3)
    elseif aiType == 6 then --似乎是自动出牌时的状态 
        self.mSelfHandle:setVisible(false)
        self:barVisibleChange(self.mPlayBar)
        self:RefreshPassBtnStateFunction(3)--不出最左边 并且可点
        self:IsDiaplayHintFunction(3)--显示提示 不可点
        self:RefreshPlayBtnStateFunction(3) --显示出牌 不可点
        self:RefreshResetBtnStateFunction(3)
        self:IsDiaplayDoubleFunction(4) --不显示明牌
        if self.mSelfPokers ~= nil then
            self.mSelfPokers:SetTipsTypeFunction(l_CardTypeObj.AUTO_CARD)
        end  
        self:RefreshClockPostionFunction(1) 
    elseif aiType == 7 then --轮到出牌时 并且已经选了牌
        self.mSelfHandle:setVisible(false)
        self:barVisibleChange(self.mPlayBar)
        self:RefreshPassBtnStateFunction(1)--不出显示 可点
        self:IsDiaplayHintFunction(1) --提示显示 可点
        self:RefreshPlayBtnStateFunction(1)--出牌 可点
        self:RefreshResetBtnStateFunction(1)--重置 可点
        self:IsDiaplayDoubleFunction(4)
        self:RefreshClockPostionFunction(1)     ----闹钟
    elseif aiType == 8 then --没搞清楚啥时候是这么个状态
        self.mSelfHandle:setVisible(false)
        self:barVisibleChange(self.mPlayBar)
        self:RefreshPassBtnStateFunction(3)--不出显示 并且不可点
        self:IsDiaplayHintFunction(3) --提示显示 并且不可点
        self:RefreshPlayBtnStateFunction(1) --出牌 显示 并且可点
        self:RefreshResetBtnStateFunction(1) --重选 可点
        self:IsDiaplayDoubleFunction(4)
        if self.mSelfPokers ~= nil then
            self.mSelfPokers:SetTipsTypeFunction(l_CardTypeObj.AUTO_CARD)
        end  
        self:RefreshClockPostionFunction(1)
    elseif aiType == 9 then--没选牌 轮到角色了 等待选牌
        self.mSelfHandle:setVisible(false)
        self:barVisibleChange(self.mPlayBar)
        self:RefreshPassBtnStateFunction(1) --不出按钮显示 可点
        self:IsDiaplayHintFunction(1) --提示按钮显示 可点
        self:RefreshPlayBtnStateFunction(3)--出牌显示 不可点
        self:RefreshResetBtnStateFunction(3)--重选 不可点
        self:IsDiaplayDoubleFunction(4)
        self:RefreshClockPostionFunction(1)     ----闹钟
    elseif aiType == 10 then --出的牌太大 要不起
        self.mSelfHandle:setVisible(false)
        self:barVisibleChange(self.mPlayBar)
        self:RefreshPassBtnStateFunction(2)--要不起显示 可点
        self:IsDiaplayHintFunction(4) --全都不可点
        self:RefreshPlayBtnStateFunction(4)
        self:RefreshResetBtnStateFunction(4)
        self:IsDiaplayDoubleFunction(4)
        self:RefreshClockPostionFunction(2)
    end
end

function CardTableDialog:onTrusteeshipFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
      if laixia.LocalPlayercfg.LaixiaisTrusteeship == false then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        
        --self:GetWidgetByName("Image_NoBiggerCard"):setVisible(false)
        local packet = l_PacketObj.new("CancelHosting", _LAIXIA_PACKET_CS_CancelMandateID)
        packet:setValue("RoomID", self.mRoomID)-- 写入包数据
        if self.hDeskID == nil  then
            return 
        end
        packet:setValue("TableID", self.hDeskID)-- 写入包数据
        if self.mCancelTrusteeship == sender then
            packet:setValue("isMandate", 0)-- 写入包数据
        else
            packet:setValue("isMandate", 1)-- 写入包数据
        end
        laixia.net.sendPacketAndWaiting(packet)
        laixia.LocalPlayercfg.LaixiaisTrusteeship = true
      end
    end
end

function CardTableDialog:CancelTrusteeship(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        
        self:GetWidgetByName("Image_NoBiggerCard"):setVisible(false)
        local packet = l_PacketObj.new("CancelHosting", _LAIXIA_PACKET_CS_CancelMandateID)
        packet:setValue("RoomID", self.mRoomID)-- 写入包数据
        if self.hDeskID == nil  then
            return 
        end
        packet:setValue("TableID", self.hDeskID)-- 写入包数据
        if self.mCancelTrusteeship == sender then
            packet:setValue("isMandate", 0)-- 写入包数据
        else
            packet:setValue("isMandate", 1)-- 写入包数据
        end
        laixia.net.sendPacketAndWaiting(packet)
        laixia.LocalPlayercfg.LaixiaisTrusteeship = false
    end
end


function CardTableDialog:onSuperGiftFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SENDPACKET_FIRSTGIFT)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FIRSTGIFT_WINDOW)
    end
end

function CardTableDialog:checkRankFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        laixia.LocalPlayercfg.LaixiaIsShowMatchRank = true 
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_GOMATCHRANK_WINDOW,{from=1})
    end
end


function CardTableDialog:onGameShopFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        local CreateGoon = l_PacketObj.new("CSCreateGoon", _LAIXIA_PACKET_CS_CreateGoonID)
        CreateGoon:setValue("TableID",laixia.LocalPlayercfg.LaixiaSelfBuildTable)
        laixia.net.sendPacket(CreateGoon)
    end
end
function CardTableDialog:onSet(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SETUP_WINDOW,1)
        -- ObjectEventDispatch:pushEvent()
    end
end

function CardTableDialog:showTimesAndResult()
    local tSynchronousData = self.mSynchronousData
    if tSynchronousData == nil then
        return
    end
    --发牌时显示3倍，修改了服务器数值（策划需求，其他需求需要改服务器配合）
    if tSynchronousData.DoubleValue == 0 then
        self.mTimes:setString(0)
    else
        self.mTimes:setString(tSynchronousData.DoubleValue)
    end
    self.mResultNum:setString(tSynchronousData.BaseValue)
end
function CardTableDialog:onTalkFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_TALKING_WINDOW)
    end
end

function CardTableDialog:closeFunction()
    if self.mSelfRoomID == 50 then
        if ((self.mSynchronousData==nil) or (self.isPlay==false and (#self.mSynchronousData.Players<3))) and self.mMasterID == laixia.LocalPlayercfg.LaixiaPlayerID then
            local onSendDelTable = l_PacketObj.new("onSendJoinTable", _LAIXIA_PACKET_CS_CreateDelID)
            onSendDelTable:setValue("TableID", self.hDeskID );--self.hDeskID
            onSendDelTable:setValue("Status",3)--我是房主 
            laixia.net.sendPacket(onSendDelTable)
        elseif self.mSynchronousData~=nil and #self.mSynchronousData.Players<3 then
            self:leavePokerDesk()  
        elseif self.SelfPlayers~=nil and #self.SelfPlayers<3 then
            self:leavePokerDesk()  
        else
            local goback = l_PacketObj.new("CSAppleDismiss", _LAIXIA_PACKET_CS_AppleDismissID)
            goback:setValue("TableID", self.hDeskID) 
            laixia.net.sendPacket(goback) 
        end
        return
    elseif self.mPokerDeskType == 4 then
       ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_CUEWORDSSELECT_WINDOW,
                            {  
                                OnLeftCallFun = function()
                                                    local matchid = 0
                                                    if laixia.LocalPlayercfg.LaixiaMatchID == 0 then
                                                        matchid = cc.UserDefault:getInstance():getDoubleForKey("matdchId")
                                                    else
                                                        matchid = laixia.LocalPlayercfg.LaixiaMatchID
                                                    end
                                                    local goback = l_PacketObj.new("CSExitRoom", _LAIXIA_PACKET_CS_MatchQuitDeskID)
                                                    goback:setValue("GameID", laixia.config.GameAppID)            
                                                    goback:setValue("MatchID", matchid)            
                                                    laixia.net.sendPacketAndWaiting(goback) 
                                                    laixia.LocalPlayercfg.LaixiaMatchquite = true                                                                            
                                                end,
                                OnRightCallFun = function()
                                                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_CUEWORDSSELECT_WINDOW)                                                                                  
                                                end,
                            })
        return
    end
    self:leavePokerDesk()  
end

function CardTableDialog:onBack(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        self:closeFunction()
    end
end

function CardTableDialog:leavePokerDesk()
    if self.isShow then
        if self.isPlay == true then
              if self.mPokerDeskType == 8 or self.mPokerDeskType == 9 or self.mPokerDeskType == 10 or self.mPokerDeskType == 11 then
                self:GetWidgetByName("Button_BackToLobby"):setTouchEnabled(false)
                self:GetWidgetByName("Button_BackToLobby"):setEnabled(false)
                self:GetWidgetByName("Button_BackToLobby"):setBrightStyle(1)
            end
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"牌局结束时才能退出")
        else
            if self.nomoney then
                self.nomoney = false
                if self.mPokerDeskType ==1 or self.mPokerDeskType ==2 or self.mPokerDeskType ==0 then
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)
                end
            else
                self:GameSendLeaveRoomFunction()
            end
        
        end
    end
end


function CardTableDialog:onShowCardCountFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        if self.isPlayerHaveCardCountState == 0  then
            self:isPlayerHaveCardCount(0)
        else
            self:isPlayerHaveCardCount(1)
        end
    end 
end 

--复-原-记-牌-器
function CardTableDialog:resetCardCountFunction()
    for i = 1,15 do
        if i == 14 or i == 15 then -- 大王or小王 
            self.mCardCountTable[i]:setString(1)
        else 
            self.mCardCountTable[i]:setString(4)
        end 
        self.mCardCountTable[i]:setVisible(false)
    end 
end
--记-牌-器-出-牌-变-化-和-发-地-主-牌-变-化
function CardTableDialog:changeCardCountFunction(aiTable)
 
    for i = 1,15 do
        local num = self.mCardCountTable[i]:getString() - aiTable[i]
        self.mCardCountTable[i]:setString(num)
        if num > 0 then
            self.mCardCountTable[i]:setVisible(true)  
        else
            self.mCardCountTable[i]:setVisible(false)
        end    
    end
end

-- 叫-分
function CardTableDialog:onthebeFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        local point = 0;
        if sender == self.mThreePoint then
            point = 3
        elseif sender == self.mPassPoint then
        else
            return
        end
        local packet = l_PacketObj.new("CGCallLandlord", _LAIXIA_PACKET_CS_CallBidID)
        packet:setValue("RoomID", self.mRoomID)
        -- 写入包数据
        packet:setValue("TableID", self.hDeskID)
        packet:setValue("CallType", 0)
        packet:setValue("CallChip", point)
        laixia.net.sendPacket(packet)
        self:ChangeTouchbarFunction(self.mThebeBar, false)
    end
end

-- 名-牌
function CardTableDialog:onDoubleFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        local synchronousData = self.mSynchronousData
        local packet = l_PacketObj.new("OpenPoker", _LAIXIA_PACKET_CS_ShowCardID)
        packet:setValue("RoomID", self.mRoomID)
        packet:setValue("TableID", self.hDeskID)
        laixia.net.sendPacketAndWaiting(packet)
        self.mDouble:setTouchEnabled(false)
        self.mDouble:setVisible(false)
        self.mPass:setTouchEnabled(false)
        self.mPass:setVisible(false)
        self.mIsDouble:setVisible(true)
    end
end

-- 抢--地--主
function CardTableDialog:onGrabFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        local grab = 0
        if sender == self.mGrab then
            grab = 4 
        elseif sender == self.mUngrab then
            grab = 0
        else
        end
        local packet = l_PacketObj.new("CGCallLandlord", _LAIXIA_PACKET_CS_CallBidID)
        packet:setValue("RoomID", self.mRoomID)
        -- 写入包数据
        packet:setValue("TableID", self.hDeskID)
        packet:setValue("CallType", 1)
        packet:setValue("CallChip", grab)
        laixia.net.sendPacketAndWaiting(packet)
        self:ChangeTouchbarFunction(self.mThebeBar, false)
    end
end



function CardTableDialog:FindLaiziSortFunction()
    local resultTable = { }
    local aiTable = { }
    resultTable.ButtomSeat = 2
    -- 庄家座号
    resultTable.Seats = self.mMySeatID
    resultTable.Cards = { }
    resultTable.Reelect = 0
    -- 0表示正常发牌

    if self.mSelfPokers ~= nil then
        aiTable = self.mSelfPokers:getPokerData()
        for i = 15, 1, -1 do
            if i > 13 then
                if aiTable[i][2] >= 0 then
                    table.insert(resultTable.Cards, { ["CardValue"] = aiTable[i][2] })
                end
            else
                for m = 5, 2, -1 do
                    if aiTable[i][m] >= 0 then
                        table.insert(resultTable.Cards, { ["CardValue"] = aiTable[i][m] })
                    end
                end
            end
        end
        local tag = 0
        for te = 1, #resultTable.Cards do
            if resultTable.Cards[te]["CardValue"] % 13 == self.hLaiziCard then
                tag = te
            end
        end

        for k1 = 1, tag do
            for k1 = #resultTable.Cards, 1, -1 do
                if resultTable.Cards[k1]["CardValue"] % 13 == self.hLaiziCard then
                    for tg = k1, 2, -1 do
                        local temp = resultTable.Cards[tg]
                        resultTable.Cards[tg] = resultTable.Cards[tg - 1]
                        resultTable.Cards[tg - 1] = temp
                    end
                end
            end
        end
    end
    return resultTable
end

-- 不出
function CardTableDialog:OnPassCardFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        self:GamesendDiscardFunction({})
    end
end


-- 提示
function CardTableDialog:onHint(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        self.mSelfPokers:recover()
        --没有能大上的牌
        if #self.mTips == 0 then
            self:GamesendDiscardFunction({})
            return
        end
        if self.mCancelTrusteeship:isVisible() == true then
            self.mSelfPokers:setTouchEnabled(false)
            self.mSelfPokers:setBlackColor()
        end
        self.mTipsErrorCardType:setVisible(false)
        self.mTipsBiggerCard:setVisible(false)

        local tipsNum = #self.mTips
        if self.mTips[self.mIndex].isTip == false then
            self.mIndex = self.mIndex + 1
            if self.mIndex >= tipsNum then
                self.mIndex = 1
            end
        end

        self.mSelfPokers:hintPokers(self.mTips[self.mIndex].Table )
        if self.mIndex < tipsNum then
            self.mIndex = self.mIndex + 1                                                                                       
        else
            self.mIndex = 1
        end
        self:GameSetPlayStyleFunction(true) 
    end
end

-- 出--牌
function CardTableDialog:OnGameChuPaiFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        local outPokers = self.mSelfPokers:selcetPoker()
        local mCardType=  l_NorLogicObject:MatchCardTypeFunction(outPokers,self.hLaiziCard,self.mCardType)  -- 判断出牌的牌型
        local matchResult= false -- 比较结果
        local showPoker= {} -- 癞子组成的牌型

        if laixia.LocalPlayercfg.LaixiaOutCardsIndex == nil then
            self.mCardType = nil 
        end

        local aiOutPokers = laixia.LocalPlayercfg.LaixiaOutCards or { }
        if #laixia.LocalPlayercfg.LaixiaLaiziReplaceCards > 0 then  -- 如果有收到的癞子牌，则取癞子牌（上家发送的）
            aiOutPokers = clone(laixia.LocalPlayercfg.LaixiaLaiziReplaceCards)
        end

        if self.mCardType == nil or self.mCardType == l_CardTypeObj.AUTO_CARD or self.mCardType == l_CardTypeObj.ERROR_CARD then
            -- 获取类型--用于处理两家都不出牌的情况
            self.mCardType = mCardType
            local demo = l_NorLogicObject:GetPokerDemoThreeFunc(self.mCardType, #outPokers)
            local demoTip = l_NorLogicObject:DamoToTipFunction(self.mCardType, demo)

            local aiType = self.mCardType
            local aiTable = self.mSelfPokers:getPokerData()
            local aiOutPokersIndex = clone(laixia.LocalPlayercfg.LaixiaOutCardsIndex) or { }

            local out = demo   -- 防止有牌的时候出错
            if #aiOutPokersIndex > 0 then
                out = aiOutPokersIndex
            end
            self.mTips = l_NorLogicObject:tipsFunction(aiType, aiTable, out, aiOutPokers, self.hLaiziCard)
            table.insert(self.mTips, demoTip)  -- 把示例提示放入提示中-- 防止第一手出牌的时候，没有匹配的牌型
        end
        if mCardType >= l_CardTypeObj.SOFT_BOMB_CARD and mCardType<= l_CardTypeObj.ROCKET_CARD then  --当出的牌为炸弹时候
           self.mCardType = mCardType
        end
        matchResult, showPoker = l_NorLogicObject:MatchPokersFunction(self.mCardType, self.mTips, outPokers, aiOutPokers, self.hLaiziCard)

        local mshowPoker = { }
        if matchResult == true then
            mshowPoker =l_NorLogicObject:ShowCardsFunction(self.hLaiziCard,self.mCardType, outPokers,showPoker) 
            matchResult, showPoker=  l_NorLogicObject:dellFiveFunction(mshowPoker) --剔除有五张的情况
        end

        if #outPokers > 0 and  matchResult == true  then
            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_play)    --在此处写出要替换的牌型数值和牌型
            self:GamesendDiscardFunction(outPokers, self.mCardType,mshowPoker)
            self:ChangeTouchbarFunction(self.mPlayBar, false)-- self.mSelfPoker:setSelectCardNull(false)
            --用户出牌后立即显示
            if self.mSelfOutPokersLayer ~= nil then
                self.mSelfOutPokersLayer:removeFromParent()
                self.mSelfOutPokersLayer = nil
            end
            laixia.LocalPlayercfg.LaixiaLaiziReplaceCards = showPoker
            self.mSelfOutPokersLayer = self.mSelfPokers:playHand(outPokers)
            self.mSelfOutPokersLayer:addTo(self.hPanelImageWidge, 3):pos(640 - (#outPokers-1) * 17, 330)            
            self:DisplayWhichClockFunction(0)
        else
            laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_error)
            self.mTipsTime = 0
            self.mTipsTimeOn = 2
            self.mTipsErrorCardType:setVisible(true)
            self.mTipsErrorCardType:setLocalZOrder(200)
        end 
    end
end

--设-置-出-牌-按钮--禁用状态
function CardTableDialog:GameSetPlayStyleFunction(aiShow)
    if self.isShow then
        if aiShow == true or ( type(aiShow) == "table" and  aiShow.data == true )  then
            self:ChangButBrightFunction(true,self.mPlay,"table_button_chupai.png")
            self:ChangButBrightFunction(true,self.resetButton,"table_button_chongxuan.png")
        else
            if self.mPlay:isVisible()==false and self.mPlay_1:isVisible()==false then
                return
            else
                self:ChangButBrightFunction(false,self.mPlay,"table_button_unchupai.png")
                self:ChangButBrightFunction(false,self.resetButton,"table_button_unchongxuan.png")
            end
        end
    end
end

--牌-复-位
function CardTableDialog:onReelect(sender, event)
    if (event == ccui.TouchEventType.ended) then
        self:GameSetPlayStyleFunction(false)   
        self.mSelfPokers:recover()
    end
end

--叫分（1.2.3 分）
function CardTableDialog:onCallPoints(sender, event)
    if (event == ccui.TouchEventType.ended) then
        local point = sender.Point
        if point == nil then
           point = 0
        end
        local packet = l_PacketObj.new("CGCallLandlord", _LAIXIA_PACKET_CS_CallBidID)
        packet:setValue("RoomID", self.mRoomID)
        packet:setValue("TableID", self.hDeskID)
        packet:setValue("CallType", 0)
        packet:setValue("CallChip", point)
        laixia.net.sendPacket(packet)
        self:ChangeTouchbarFunction(self.mCallPointBar, false)
    end
end


function CardTableDialog:onPlayerInfoFunction(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        if self.mPokerDeskType == 4 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"比赛中无法查看玩家信息")  
            return
        end
        if self.mSelfRoomID == 50 then
            return
        end
        local parent = sender:getParent()
        local posX,posY = parent:getPosition()
        local RankPid = nil
        local playerSex = 0

        if sender == self.Image_UserInfo_Bg_02_ then
            if self.leftPID == nil then
                return
            end
            PID = self.leftPID
            self.posX1 = self.hLeftTouxiangFrmaeWidge:getPositionX()+self.hLeftTouxiangFrmaeWidge:getContentSize().width
            self.posY1 = self.hRightTouxiangFrmaeWidge:getPositionY()+30
        elseif sender == self.Image_UserInfo_Bg_02 then
            if self.rightPID == nil then
                return
            end
            PID = self.rightPID
            self.posX1 = self.hRightTouxiangFrmaeWidge:getPositionX()-450
            self.posY1 = self.hRightTouxiangFrmaeWidge:getPositionY()+30
        else
            PID = laixia.LocalPlayercfg.LaixiaPlayerID
            self.posX1 = self.hMyTouxiangFrmaeWidge:getPositionX()+self.hMyTouxiangFrmaeWidge:getContentSize().width/2
            self.posY1 = self.hMyTouxiangFrmaeWidge:getPositionY()+self.hMyTouxiangFrmaeWidge:getContentSize().height/2
        end

        local packet = l_PacketObj.new("CGEnterLobby", _LAIXIA_PACKET_CS_TablePlayerID)
        packet:setValue("RoomID", self.mRoomID)
        packet:setValue("PlayerID", PID)
        laixia.net.sendPacketAndWaiting(packet)

        -- if self.mSynchronousData ~= nil then
        --     print("555555555555555555555555555")
        --     local players = self.mSynchronousData.Players
        --     if sender == self.mRightHead then
        --         for index = 1, 3 do
        --             if (self.mMySeatID + 4) % 3 == players[index].Seat then
        --                 RankPid = players[index].PID
        --                 playerSex = players[index].Sex
        --             end
        --         end
        --     elseif sender == self.mLeftHead then
        --         for index = 1, 3 do
        --             if (self.mMySeatID + 2) % 3 == players[index].Seat then
        --                 RankPid = players[index].PID
        --                 playerSex = players[index].Sex
        --             end
        --         end
        --     else
        --         for index = 1,3 do
        --             if self.mMySeatID == players[index].Seat then
        --                 RankPid = players[index].PID
        --                 playerSex = players[index].Sex                  
        --             end
        --         end
        --     end
        --     local px = posX 
        --     local py = posY - 80
        --     if posX < 640 then 
        --         px = posX + 300 
        --     elseif posX > 640 then 
        --         px = posX - 300 
        --     end 
        --     if posY < 360 then 
        --         py = posY + 200 
        --     end 
  
            -- local packet = l_PacketObj.new("CGEnterLobby", _LAIXIA_PACKET_CS_TablePlayerID)
            -- packet:setValue("RoomID", self.mRoomID)
            -- if RankPid == nil then
            --     packet:setValue("PlayerID", laixia.LocalPlayercfg.LaixiaPlayerID)
            -- else
            --     packet:setValue("PlayerID", RankPid)
            -- end
            -- laixia.net.sendPacketAndWaiting(packet)
--        end
    end
end

function CardTableDialog:onTaskClose(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        self.mTask:setVisible(false)
        self.mTaskClose:setTouchEnabled(false)
        self.mTaskTouch:setTouchEnabled(false)
    end
end

function CardTableDialog:nomoneyFunction()
    if self.isShow and (self.mPokerDeskType ==1 or self.mPokerDeskType ==2 or self.mPokerDeskType == 0) then
        self.nomoney=true
    end
end

--准备（继续游戏）
function CardTableDialog:onBegin(sender, event)
    if (event == ccui.TouchEventType.ended) then
        self:OnbeginFunction()
    end
end

function CardTableDialog:OnbeginFunction(msg)
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        local roomID = laixia.LocalPlayercfg:room_query_Id()
        local mRoomInfo = l_RoomDataMgr:query("roomid",laixia.LocalPlayercfg:room_query_Id());
        if mRoomInfo then
            laixia.LocalPlayercfg.LaixiaInGolds = mRoomInfo["minGold"]
        end
        local deskResult = self.mDeskResult
        local changeGold = 0
        for index = 1, #deskResult.CSBalance do
            if laixia.LocalPlayercfg.LaixiaPlayerID == deskResult.CSBalance[index].PID then
                laixia.LocalPlayercfg.MatchGold = deskResult.CSBalance[index].CurrentGold
                changeGold = deskResult.CSBalance[index].Chip
            end
        end

        self:OnSendContinueGameFunction()
        for k,v in pairs(self.mGoldChangeTable ) do
            if v and v~=0 then
                v:setVisible(false)
                v:removeFromParent()
                v = nil
            end 
        end
        self.mGoldChangeTable = {0,0,0,0,0,0}
        --地主标识隐藏
        self:GetWidgetByName("Image_LeftDizhu"):setVisible(false)
        self:GetWidgetByName("Image_RightDizhu"):setVisible(false)
        self:GetWidgetByName("Image_SelfDizhu"):setVisible(false)
        laixia.LocalPlayercfg.LaixiaisTrusteeship = false
        
         for i = 1,3 do
            if self.mBottomPoker[3+i] ~= 0 then
                self.mBottomPoker[i]:setScale(1)    
            end
         end
         --人物名字
         self.mLeftInfoName:setString("")
         self.mRightInfoName:setString("")
end

--发-送-继-续-牌-桌-匹-配-请求
function CardTableDialog:sendContinueGame()
    local packet = l_PacketObj.new("ContinueGame", _LAIXIA_PACKET_CS_ContinueGameID)
    packet:setValue("RoomID", self.mRoomID)-- 写入包数据
    packet:setValue("TableID", self.hDeskID)-- 写入包数据
    laixia.net.sendPacketAndWaiting(packet)
end

--发-送-继续-牌-桌-匹配请求
function CardTableDialog:OnSendContinueGameFunction()
    if self.nomoney then
        if self.mPokerDeskType ==1 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,0)
        elseif self.mPokerDeskType ==2 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,1)
        end
        self.nomoney = false
    else
        --根据用户的钱判断所处的房间id，并判断是否降级，如果降级显示飘字并弹出超级礼包页面
        --self.isDownState  0:初始化 1 触发降级条件
        if self.isDownState == 0 then
            local roominfo = l_RoomDataMgr:query("roomid",laixia.LocalPlayercfg:room_query_Id());
            local roominfo1 
            if self.mPokerDeskType ==1  then
                roominfo1 = l_RoomDataMgr:query("roomid",1);
            elseif self.mPokerDeskType ==2 then
                roominfo1 = l_RoomDataMgr:query("roomid",5);
            elseif  self.mPokerDeskType == 0 then
                roominfo1 = l_RoomDataMgr:query("roomid",1);
            end
            if roominfo and roominfo1 and laixia.LocalPlayercfg.MatchGold<roominfo["minGold"] and laixia.LocalPlayercfg.MatchGold>roominfo1["minGold"] then
                self.isDownState = 1
                --self:GameSendLeaveRoomFunction()
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ROOMDEMOTE_WINDOW,{roominfo.name,self.mRoomID,self.hDeskID})
            else
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_TABLERESULT_WINDOW)
                self:sendContinueGame()
            end
        elseif self.isDownState == 1 then
            self.isDownState = 0
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_TABLERESULT_WINDOW)
            self:sendContinueGame()
        end
    end
end

--发--送--离开--房间消息
function CardTableDialog:GameSendLeaveRoomFunction()
    local packet = l_PacketObj.new("CSExitRoom", _LAIXIA_PACKET_CS_ExitRoomID)
    packet:setValue("RoomID", self.mRoomID)   --写入包数据
    local tableid = -1
    if self.mRoomID == 50 and self.hDeskID ~= nil then
        tableid = self.hDeskID
    end
    packet:setValue("TableID",tableid)   --写入包数据
    laixia.net.sendPacketAndWaiting(packet)
end

function CardTableDialog:GameRefreshGoldFunction(msg)
    if self.isShow and (self.mPokerDeskType == 1 or self.mPokerDeskType == 2 or self.mPokerDeskType == 0) then
        self:GaibianShuziWenbenFunction(self.mGold,laixia.LocalPlayercfg.MatchGold)
    end
end
function CardTableDialog:onRule(sender, event)
    if event == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GAMEDESCRIBE_WINDOW,{data="bangzhu"})
    end
end

-- function CardTableDialog:showAppleDissmissLayer(data)
--     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_APPLYDISMISS_WINDOW_WINDOW,data)
-- end
function CardTableDialog:onCallBackFunction()
    self:closeFunction()
end

return CardTableDialog.new()

