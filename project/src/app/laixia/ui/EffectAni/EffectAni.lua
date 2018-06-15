

local EffectAni = class("EffectAni")
local EffectDict = import(".EffectDict")
local soundConfig =  laixia.soundcfg
function EffectAni:ctor(aiEffectID,aiAdder,params)
end

--aiEffectID 特效动画ID
--params    {} 其他参数
--EffectAni:createAni(EffectDict._ID_DICT_TYPE_DESK_FANPAI)
--nodeBottom:addTo(self.mInterfaceRes,4)
function EffectAni:createAni(aiEffectID,params)
    local layer = ccui.Layout:create();
    print("动画是。。。"..aiEffectID)

    if aiEffectID == EffectDict._ID_DICT_TYPE_DESK_SPRING then     --牌桌春天
        self:deskSpring(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_ALARM then     --牌桌警灯特效
        self:deskAlarm(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_LIUJU then     --牌桌流局动画
        self:deskLiuju(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_OPENPOKER then     --牌桌明牌特效
        self:deskOpenPoker(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_XIAOZHADAN then     --牌桌明牌特效
        self:deskXiaoZhadan(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_SHUNZI then     --牌桌顺子动画
        self:deskShunZi(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LANLORD_RAIN then     --地主跑
        self:deskLandlordRain(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_LIANDUI then     --地主跑
        self:deskLianDui(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_ROCK then     --火箭动画
        self:deskRocki(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_FEIJI then     --飞机动画
        self:deskFeiji(layer)         --
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_FANPAI then     --翻牌动画
        self:deskFanPai(layer)

    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_QUICKSTART then     --大厅的快速开始
        self:lobbyQuickStart(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_GAMEROOM_ROOMLIGHT then     --房间光
        self:gameRoomLight(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_LANDLORD then     --大厅的斗地主图标动画
        self:lobbyLandlord(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_MATCH then     --大厅的比赛场图标动画
        self:loobyMatch(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_2VS1 then     --大厅的二打一图标动画  （光效动画，每日登陆也在用）
        self:lobby2VS1(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_FIGHT then     --大厅的龙虎斗图标动画
        self:lobbyFight(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_THREECARD then     --大厅的三张牌图标动画
        self:lobbyThreeCard(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_TEXAS then     --大厅的德州扑克图标动画
        self:lobbyTexas(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_COMMON_LIGHT then     --光效动画，每日登陆也在用
        self:commnoLight(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_LOBBY_SELDBUILDING then     --自建房间
        self:lobbySelfBuinding(layer)
    elseif aiEffectID == EffectDict._ID_DICT_GAMETYPE_JINGDIANCHANG then     --经典场动画
        self:gameTypJDC(layer)
    elseif aiEffectID == EffectDict._ID_DICT_GAMETYPE_LAIZICHANG then     --癞子场动画
        self:gameTypeLZC(layer) --
    elseif aiEffectID == EffectDict._ID_DICT_GAMETYPE_DANJICHANG then     --单机场动画
        self:gameTypeDJC(layer)

    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_LANDLORD_WIN then     --牌桌地主获胜
        self:deskLandlordWin(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_LANDLORD_LOST then     --牌桌地主失败
        self:deskLandlordLost(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_FARMER_WIN then     --牌桌农民获胜
        self:deskFarmerWin(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_DESK_FARMER_LOST then     --牌桌农民失败
        self:deskFarmerLost(layer)


    elseif aiEffectID == EffectDict._ID_DICT_TYPE_RESULT_LOST then     --结算失败
        self:resultLost(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_RESULT_WIN then     --结算获胜
        self:resultWin(layer)
    elseif aiEffectID == EffectDict._ID_DICT_TYPE_RESULT_SPRING then     --结算春天
        self:resultSpring(layer)


    elseif aiEffectID == EffectDict._ID_DICT_TYPE_WATTING_CIRCLE then      --网络圆形等待动画
        self:connectCircle(layer)
    else
    end
    return layer
end






function EffectAni:deskSpring(aiAdder)
    laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_spring)
    local system = laixia.ani.CObjectAnimationManager;
    local chuntian = nil

    local funAction = cc.CallFunc:create(function()
        chuntian = system:playAnimationAt(aiAdder,"LandlordDesk_spring","Default Timeline",
            function()
            end )
        chuntian:setPosition(cc.p(-display.width/2,-display.height/2))
    end)

    local funAction2 = cc.CallFunc:create(function()
        chuntian:removeFromParent()
        chuntian=nil
        aiAdder:removeFromParent()
        aiAdder = nil
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SPRING_LANDLORDTABLE_WINDOW,"springOver")

    end)
    aiAdder:runAction(
        cc.Sequence:create(
            funAction ,
            cc.DelayTime:create(2),
            funAction2
        ))


end

function EffectAni:deskAlarm(aiAdder)
    laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    local system = laixia.ani.CObjectAnimationManager;
    local node = system:playAnimationAt(aiAdder,"hongdeng","Default Timeline",
        function ()
            laixia.logGame("PlayAnimation End ")
        end )
end

--创建动画并且清除

function EffectAni:createAnimationAndClean(aiAdder ,animAtionName, delayTime)
    local system = laixia.ani.CObjectAnimationManager;
    local node = nil

    local funAction = cc.CallFunc:create(function()
        node = system:playAnimationAt(aiAdder,animAtionName,"Default Timeline",
            function()
            end )
        --node:setPosition(cc.p(-display.width/2,-display.height/2))
    end)

    local funAction2 = cc.CallFunc:create(function()
        node:removeFromParent()
        node=nil
        aiAdder:removeFromParent()
        aiAdder = nil

    end)
    aiAdder:runAction(
        cc.Sequence:create(
            funAction ,
            cc.DelayTime:create(delayTime),
            funAction2
        ))
end

function EffectAni:createAnimation(aiAdder ,animAtionName)
    local system = laixia.ani.CObjectAnimationManager;
    local node = nil
    node = system:playAnimationAt(aiAdder,animAtionName,"Default Timeline",
        function()
        end )

end

function EffectAni:createCSBAnimation(aiAdder ,animAtionName)
    local system = laixia.ani.CObjectAnimationManager;
    local node = nil
    node = system:playAnimationAt(aiAdder,animAtionName,"Default Timeline",
        function()
        end )

end



function EffectAni:deskLiuju(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    self:createAnimationAndClean(aiAdder,"landlord_liuju",2)

end
--牌桌地主获胜
function EffectAni:deskLandlordWin(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    self:createAnimationAndClean(aiAdder,"landlordwin",2)
end
--牌桌地主失败
function EffectAni:deskLandlordLost(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    self:createAnimationAndClean(aiAdder,"Landlord_lost",2)
end


--牌桌农民获胜
function EffectAni:deskFarmerWin(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    self:createAnimationAndClean(aiAdder,"farmerwin",2)

end
--牌桌农民失败
function EffectAni:deskFarmerLost(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    self:createAnimationAndClean(aiAdder,"farmerlost",2)

end

--结算失败
function EffectAni:resultLost(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    -- self:createAnimation(aiAdder,"table_lose")
    local system = laixia.ani.CocosAnimManager
    node = system:playAnimationAt(aiAdder,"doudizhu_lost")
    node:setLocalZOrder(10)
    node:setPositionX(display.cx)
    node:setPositionY(display.top/4*3-200)
    aiAdder:runAction(cc.Sequence:create(
                    cc.DelayTime:create(51/60),
                    cc.CallFunc:create(
                        function()                                                        
                            self.lostloopAni = system:playAnimationAt(aiAdder,"doudizhu_lost_loop")
                            self.lostloopAni:setLocalZOrder(5)
                            self.lostloopAni:setPosition(cc.p(display.cx,display.top/4*3-200))
                        end),nil))  

end
--结算获胜
function EffectAni:resultWin(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    -- self:createAnimation(aiAdder,"table_win")
    local system = laixia.ani.CocosAnimManager
    node = system:playAnimationAt(aiAdder,"doudizhu_victory")
    node:setLocalZOrder(10)
    node:setPositionX(display.cx)
    node:setPositionY(display.top/4*3)
    aiAdder:runAction(cc.Sequence:create(
                    cc.DelayTime:create(31/60),
                    cc.CallFunc:create(
                        function()                                                        
                            self.victoryloopAni = system:playAnimationAt(aiAdder,"doudizhu_victory_loop")
                            self.victoryloopAni:setLocalZOrder(5)
                            self.victoryloopAni:setPosition(cc.p(display.cx,display.top/4*3))
                        end),nil))  
end
--结算春天
function EffectAni:resultSpring(aiAdder)
    --laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_warning)
    self:createAnimation(aiAdder,"table_spring")

end


--小炸弹
function EffectAni:deskXiaoZhadan(aiAdder)
    self:createAnimation(aiAdder,"ddz_xiaozhadan")
end

--顺子
function EffectAni:deskShunZi(aiAdder)
    self:createAnimation(aiAdder,"ddz_shunzi")
end

--地主跑
function EffectAni:deskLandlordRain(aiAdder)
    self:createAnimation(aiAdder,"Rain")
end
--连对
function EffectAni:deskLianDui(aiAdder)
    self:createAnimation(aiAdder,"ddz_liandui")
end
--火箭
function EffectAni:deskRocki(aiAdder)
    self:createAnimation(aiAdder,"ddz_huojian")
end

--飞机
function EffectAni:deskFeiji(aiAdder)
    self:createAnimation(aiAdder,"ddz_feiji")
end

--大厅快速开始
function EffectAni:lobbyQuickStart(aiAdder)
    self:createAnimation(aiAdder,"dt_kaishi")
end

--房间光
function EffectAni:gameRoomLight(aiAdder)
    self:createAnimationAndClean(aiAdder,"roomlight",5)
end

--翻牌
function EffectAni:deskFanPai(aiAdder)
    self:createAnimationAndClean(aiAdder,"laizipai",5)
end

--斗地主图标
function EffectAni:lobbyLandlord(aiAdder)
    self:createAnimation(aiAdder,"doudizhu",2.5)
end

--比赛场图标
function EffectAni:loobyMatch(aiAdder)
    self:createAnimation(aiAdder,"bisaichang",2.5)
end

--二打一图标
function EffectAni:lobby2VS1(aiAdder)
    self:createAnimationAndClean(aiAdder,"everyday_reward",2.5)
end
--
--公用光效
function EffectAni:commnoLight(aiAdder)
    self:createAnimation(aiAdder,"everyday_reward")
end
--龙虎斗图标
function EffectAni:lobbyFight(aiAdder)
    self:createAnimation(aiAdder,"longhudou",2.5)
end

--三张牌图标
function EffectAni:lobbyThreeCard(aiAdder)
    self:createAnimation(aiAdder,"sanzhangpai",2.5)
end


--德州图标
function EffectAni:lobbyTexas(aiAdder)
    self:createAnimation(aiAdder,"dezhoupuke",2.5)
end

--自建房
function EffectAni:lobbySelfBuinding(aiAdder)
    self:createAnimation(aiAdder,"lobby_zjz",2.5)
end
--经典场动画
function EffectAni:gameTypJDC(aiAdder)
    self:createAnimation(aiAdder,"jingdianchang",5)
end

--癞子场动画
function EffectAni:gameTypeLZC(aiAdder)
    self:createAnimation(aiAdder,"laizichang",5)
end

-- 单机场
function EffectAni:gameTypeDJC(aiAdder)
    self:createAnimation(aiAdder,"danjichang",5)
end

function EffectAni:deskOpenPoker(aiAdder)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ming.plist","ming.png")
    laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_evevt_open_hand)
    self:createAnimationAndClean(aiAdder,"ming",5)

end


function EffectAni:connectCircle(aiAdder)
    local system = laixia.ani.CObjectAnimationManager;
    self.colorlayer = system:playAnimationAt(aiAdder,"zhengzaijiazai","Default Timeline",
        function()
        end )
    self.colorlayer:setLocalZOrder(10000)

end




return EffectAni.new()

--endregion
