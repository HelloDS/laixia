local MyBagWindow = class("MyBagWindow", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;  
local Packet = import("....net.Packet")

function MyBagWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.isTouched = false
end

function MyBagWindow:getName()  
    return "MyBagWindow"
end

function MyBagWindow:onInit()
    self.super:onInit(self)
    self.mIsShow = false
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_TOOLSBOX_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_TOOLBOX_WINDOW,handler(self,self.updateWindow))
end
--点击查看详情
function MyBagWindow:onClickToShow(sender, eventtype)
    if eventtype == ccui.TouchEventType.began then      
    elseif eventtype == ccui.TouchEventType.moved then
        self:GetWidgetByName("Mybag_guangxiao",sender):setVisible(false)
    elseif eventtype == ccui.TouchEventType.ended then
        self:GetWidgetByName("Mybag_guangxiao",sender):setVisible(true)
        if self.isPrevious == nil then
            self.isPrevious = sender
        elseif self.isPrevious == sender then
            return
        else
            if self.isPrevious == nil then
                self.isPrevious = sender
            else
                self:GetWidgetByName("Mybag_guangxiao",self.isPrevious):setVisible(false)
                self.isPrevious = sender
            end
        end
        self.Text_tou:setVisible(false)
        self.Text_cishu:setVisible(false)
        self.Text_wei:setVisible(false)

        local itemMsg = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",sender.ItemID)
        self:GetWidgetByName("Mybag_Libao_Title_desc"):setString(itemMsg.ItemName)
        self:GetWidgetByName("Mybag_Libao_Desc"):setString(itemMsg.ItemDesc)
        --这里显示物品的图标
        local icon = self:GetWidgetByName("Image_Detail_Icon")
        local icon_copy = self:GetWidgetByName("Image_Detail_Icon_copy")
        icon_copy:removeAllChildren()
        self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
        self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
        local sprite
        local baoming_Array = string.split(itemMsg.ImagePath ,'/')
        if #baoming_Array > 1 then
            sprite = display.newSprite(itemMsg.ImagePath)
            sprite:setScale(1)  
            sprite:setAnchorPoint(cc.p(0.5,0.5))
            sprite:setPosition(cc.p(0,0))
            sprite:addTo(icon_copy)     
            self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(true) 
            self:GetWidgetByName("Mybag_Libao_Title_desc"):setVisible(true)
            self:GetWidgetByName("Mybag_Libao_Desc"):setVisible(true)
        else
           --icon:removeAllChildren()
            --ImagePath字段 道具大icon############
            icon:loadTexture(itemMsg.ImagePath, 1)
            icon:setScale(1)            
            self:GetWidgetByName("Image_Detail_Icon"):setVisible(true)
        end
        
        -- 是否是任务红包
        if sender.ItemID == 13002 then
            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
            print("111111111111111111111111111111111111111")
            self.Text_tou:setVisible(true)
            self.Text_cishu:setVisible(true)
            self.Text_wei:setVisible(true)
            --self.numberNode = 0
            self.curTaskProgress = 0
            self.maxTaskProgress = 0   

            if laixiaddz.LocalPlayercfg.LaixiaTaskList ~= nil then
                for k,v in pairs(laixiaddz.LocalPlayercfg.LaixiaTaskList) do
                    local ItemId = string.split(v.taskGoods,":")[1] or "0"
                    if ItemId == "13002" then
                        local curNum = string.split(v.curNum,",")
                        for index, value in pairs(curNum) do
                            local temp = string.split(value,":")
                            if #temp>1 then
                                self.curTaskProgress = self.curTaskProgress+ tonumber( temp[3])
                            end
                        end
                      
                        local missionNum = string.split(v.missionNum,",")
                        for index, value in pairs(missionNum) do
                            local temp = string.split(value,":")
                            if #temp>1 then
                                self.maxTaskProgress =  tonumber(temp[3])
                                break
                            end
                        end
                    end
                end
            end

            -- self:GetWidgetByName("Mybag_Libao_Num"):setVisible(false)
            self.Text_cishu:setString(self.curTaskProgress.."/"..self.maxTaskProgress)
        end

        --self:GetWidgetByName("Image_Detail_Icon"):loadTexture(itemMsg.ImagePath, 1)
        self.curItemID = sender.ItemID
        self.curItemObjectID = sender.ItemObjectID
        if sender.ItemID == 1021 then --1021的周卡 不显示使用按钮
             self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
        else
            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(true)
        end
    end   
end
function MyBagWindow:guanbi(sender,eventtype)
    self.Panel_3:setVisible(false)
end
--红包专属的确认按钮（实现红包的兑换以及使用）
function MyBagWindow:onUse1(sende,eventtype)
    if eventtype == ccui.TouchEventType.ended then  
        if self.isTouched == true then
            return
        end
        self.isTouched = true
        local sender = {}
        sender.ItemID = self.curItemID
        sender.ItemObjectID  = self.curItemObjectID
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local itemMsg = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",sender.ItemID);
        if (self.CheckBox_duihuan:isSelected() == nil and self.CheckBox_hongbao:isSelected() == nil) or (self.CheckBox_duihuan:isSelected() == false and self.CheckBox_hongbao:isSelected() == false) then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"请选择领取方式")
            self.Panel_3:setVisible(false)
        end
        if self.CheckBox_duihuan:isSelected() == true then  
            local CSUseProp = Packet.new("CSUseProp", _LAIXIA_PACKET_CS_UsePacksID)
            CSUseProp:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
            CSUseProp:setValue("GameID", laixia.config.GameAppID)
            CSUseProp:setValue("ItemID", itemMsg.ItemID)
            CSUseProp:setValue("type", 1)
            laixia.net.sendHttpPacketAndWaiting(CSUseProp);
            if itemMsg.isDisapear == 1 then
                self.Panel_3:setVisible(false)
                self.isPrevious = nil
                --清除右边数据
                self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                self.Mybag_Libao_Title_desc:setString("")
            end
                -- laixiaddz.LocalPlayercfg.LaixiaPlayerGold = laixiaddz.LocalPlayercfg.LaixiaPlayerGold + self.duihuanNum
        elseif self.CheckBox_hongbao:isSelected() == true then
            if laixiaddz.LocalPlayercfg.LaixiaPhoneNum=="" then
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"请点击游戏头像进行手机绑定")
                self.Panel_3:setVisible(false)
                self.isTouched = false
                return
            end
            if tonumber(string.sub(sender.ItemID,3,4)) >= 11 then
                local unionid = cc.UserDefault:getInstance():getStringForKey("unionid")
                local pid = sender.ItemID
               --local unionid = crypto.md5(newAccount)
               --local pid = crypto.md5(sender.ItemID)
                local jc = cc.XMLHttpRequest:new()
                jc:registerScriptHandler( function() 
                    local array =  jc.response
                    local json = require("framework.json");
                    local array1 = json.decode(array);
                    if array1.code>0 then --xhr.code >0代表此用户信息存在 <0此用户信息不存在 msg代表具体原因
                        print(array1.msg)
                        local CSUseProp = Packet.new("CSUseProp", _LAIXIA_PACKET_CS_UsePacksID)
                        CSUseProp:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
                        CSUseProp:setValue("GameID", laixia.config.GameAppID)
                        CSUseProp:setValue("ItemID", itemMsg.ItemID)
                        CSUseProp:setValue("type", 0)
                        laixia.net.sendHttpPacketAndWaiting(CSUseProp);
                        if itemMsg.isDisapear == 1 then
                            self.Panel_3:setVisible(false)
                            self.isPrevious = nil
                            --清除右边数据
                            self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                            self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                            self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                            self.Mybag_Libao_Title_desc:setString("")
                        end
                    else
                        print(array1.msg)
                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MONEY_WINDOW,"请关注微信服务号:" .. laixiaddz.LocalPlayercfg.LaixiaWechatServiceNum)
                        self.Panel_3:setVisible(false)
                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
                    end
                end)
                jc.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                local URL = string.format("http://wx.laixia.com/wxuserIfExsit?unionid=%s",unionid)
                jc:open("GET", URL,true)
                jc:send()               
            else
                local unionid = cc.UserDefault:getInstance():getStringForKey("unionid")
                local pid = sender.ItemID
               --local unionid = crypto.md5(newAccount)
               --local pid = crypto.md5(sender.ItemID)
                local jc = cc.XMLHttpRequest:new()
                jc:registerScriptHandler( function() 
                    local array =  jc.response
                    local json = require("framework.json");
                    local array1 = json.decode(array);
                    if array1.code>0 then --xhr.code >0代表此用户信息存在 <0此用户信息不存在 msg代表具体原因
                        print(array1.msg)
                        --第一阶段成功
                        --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,array1.msg)
                        --TIPS
                        local xhr = cc.XMLHttpRequest:new()
                        xhr:registerScriptHandler( function() 
                            --表示XMLHttpRequest对象的状态
                            --服务器返回的http状态码
                            local array3 =  xhr.response
                            local json = require("framework.json")
                            local array2 = json.decode(array3)
                            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MONEY_WINDOW,array2.msg)
                            if array2.code == 1 then
                                print("使用成功")
                                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
                                 -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"使用成功!")
                                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MONEY_WINDOW,"红包使用成功，请前往公众号领取!")
                                 --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TOOLSBOX_WINDOW);

                                if itemMsg.isDisapear == 1 then
                                    self.Panel_3:setVisible(false)
                                    self.isPrevious = nil
                                    --清除右边数据
                                    self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                                    self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                                    self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                                    self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                                    self.Mybag_Libao_Title_desc:setString("")
                                    self:sendToMyBagPacket()
                                end
                            end
                        end)
                        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                        local accessTokenURL = string.format("http://wx.laixia.com/posthb?unionid=%s&propid=%s&objectid=%s&phone=%s",unionid,pid,sender.ItemObjectID,laixiaddz.LocalPlayercfg.LaixiaPhoneNum)
                        xhr:open("GET", accessTokenURL,true)
                        xhr:send()
                    else
                        print(array1.msg)
                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MONEY_WINDOW,"请关注微信服务号:" .. laixiaddz.LocalPlayercfg.LaixiaWechatServiceNum)
                        self.Panel_3:setVisible(false)
                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
                        --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,array1.msg)
                    end
                end)
                jc.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                local URL = string.format("http://wx.laixia.com/wxuserIfExsit?unionid=%s",unionid)
                jc:open("GET", URL,true)
                jc:send()
            end
        end
        self.isTouched = false
    end
end
function MyBagWindow:onUse(sende,eventtype)
    if eventtype == ccui.TouchEventType.ended then  
        local sender = {}
        sender.ItemID = self.curItemID
        sender.ItemObjectID  = self.curItemObjectID
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local itemMsg = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",sender.ItemID);
        self.duihuanNum = 0
    
        if  sender.ItemID == 13002 then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"请前往游戏场完成任务")
            return
        end
        
        if itemMsg.ItemType == 7 then
            --等级礼包使用的时候
            if itemMsg.GetLimit == 1 and laixiaddz.LocalPlayercfg.LaixiaPlayerLevel<itemMsg.LimitNumber then
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "您当前等级不足，需要"..itemMsg.LimitNumber.."级才能领取哦。")
            else
                local CSUseProp = Packet.new("CSUseProp", _LAIXIA_PACKET_CS_UsePacksID)
                CSUseProp:setValue("GameID", laixia.config.GameAppID)
                CSUseProp:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
                CSUseProp:setValue("ItemID", itemMsg.ItemID)
                CSUseProp:setValue("type", 0)
                laixia.net.sendHttpPacketAndWaiting(CSUseProp);
            end
        else
            local dataTable = {}
            dataTable.ID = itemMsg.ItemID
            dataTable.ObjID = sender.ItemObjectID
            dataTable.page = "MyBagWindow"
            if itemMsg.isDelivery == 1 then
                if itemMsg.DeliveryFunctionID == 1 then
                    --游戏大厅
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MAININTERFACE_WINDOW)
                elseif itemMsg.DeliveryFunctionID == 2 then
                    --游戏场界面
                    laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW
                    local stream = Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
                    stream:setValue("RoomType", 2)
                    laixia.net.sendPacketAndWaiting(stream)
                elseif itemMsg.DeliveryFunctionID == 3 then
                    --比赛场界面
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
                    laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW
    
                    local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
                    CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
                    CSMatchListPacket:setValue("PageType", 1 )
                    laixia.net.sendPacketAndWaiting(CSMatchListPacket)
                elseif itemMsg.DeliveryFunctionID == 4 then
                    --自建桌界面
                    laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_PACKET_CREATESELFBUILF
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_PACKET_CREATESELFBUILF)
                end
            else 
                --不跳转
                if itemMsg.ItemType == 1 then
                    --货币
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,itemMsg.ItemDesc)
                    if itemMsg.isDisapear == 1 then
                        self.isPrevious = nil
                        --清除右边数据
                        self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                        self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                        self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                        self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                        self.Mybag_Libao_Title_desc:setString("")
                     end
                elseif itemMsg.ItemType == 2 then
                    --门票
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,itemMsg.ItemDesc)
                    --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
                    if itemMsg.isDisapear == 1 then
                        self.isPrevious = nil
                        --清除右边数据
                        self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                        self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                        self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                        self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                        self.Mybag_Libao_Title_desc:setString("")
                    end
                elseif itemMsg.ItemType == 3 then
                    -- ObjectEventDispatch:dispatchEvent{
                    --     name = _laixiaddz_EVENT_SHOW_RECONNECTIONTIPS_WINDOW,
                    --     data = {},   
                    --     waitType = 1
                    -- }
                    if itemMsg.ItemID == 9998 or (itemMsg.ItemID >=30000 and itemMsg.ItemID <40000)  then
                        if laixiaddz.LocalPlayercfg.LaixiaPhoneNum=="" then
                             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"请点击游戏头像进行手机绑定")
                             return
                        end
                        --检测公众号
                        --获取unionid 
                        local unionid = cc.UserDefault:getInstance():getStringForKey("unionid")
                        local pid = sender.ItemID
                        local jc = cc.XMLHttpRequest:new()
                        jc:registerScriptHandler( function()
                            local array = jc.response
                            local json = require("framework.json")
                            local array1 = json.decode(array)
                            if array1.code>0 then -- 代表此用户信息存在 <0此用户信息不存在 msg代表具体原因
                                print("array1.msg")--第一阶段成功
                                --弹出 兑换信息界面 填写信息
                                local data1 = {}
                                data1.ID = sender.ItemID
                                data1.ObjID = sender.ItemObjectID
                                data1.page = "MyBagWindow"
                                data1.isDisapear = itemMsg.isDisapear
                                --------------laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow = "MyBagWindow"
                                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_REDEEMENTITY_WINDOW,data1)
                                if itemMsg.isDisapear == 1 then
                                    self.isPrevious = nil
                                    --清除右边数据
                                    self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                                    self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                                    self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                                    self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                                    self.Mybag_Libao_Title_desc:setString("")
                                    self:sendToMyBagPacket()
                                end
                            else
                                print(array1.msg)
                                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"请关注公众号:" .. laixiaddz.LocalPlayercfg.LaixiaWechatServiceNum)
                                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
                                --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,array1.msg)
                                ----------弹出 温馨提示界面 显示公众号label 隐藏请绑定手机号label 
                                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EXCHANGETISHI_WINDOW, 2)
                                 --  local data1 = {}
                                 -- data1.ID = sender.ItemID
                                 -- data1.ObjID = sender.ItemObjectID
                                 -- data1.page = "MyBagWindow"
                                 -- data1.isDisapear = itemMsg.isDisapear
                                 -- --------------laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow = "MyBagWindow"
                                 -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_REDEEMENTITY_WINDOW,data1)
                                 if itemMsg.isDisapear == 1 then
                                    self.isPrevious = nil
                                    --清除右边数据
                                    self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                                    self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                                    self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                                    self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                                    self.Mybag_Libao_Title_desc:setString("")
                                    self:sendToMyBagPacket()
                                 end
                            end
                        end)
                        jc.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                        local URL = string.format("http://wx.laixia.com/wxuserIfExsit?unionid=%s",unionid)
                        jc:open("GET", URL,true)
                        jc:send()
                    else
                        if string.sub(sender.ItemID,1,2) == "15" and itemMsg.ObtainItemIDList ~= nil then
                            self:AddWidgetEventListenerFunction("Button_guanbi",handler(self, self.guanbi));
                            local duihuanText = self:GetWidgetByName("Text_num",self.Panel_3)  
                            local lingquName = self:GetWidgetByName("Text_linghongbao",self.Panel_3)
                            local duihuanArr = string.split(itemMsg.ObtainItemIDList, ",")
                            for index, value in pairs(duihuanArr) do
                                local temp = string.split(value,":")
                                if #temp>1 then
                                    self.duihuanNum = tonumber(temp[2])
                                    if temp[1] == "1001" then
                                        duihuanText:setString(self.duihuanNum.."金币")
                                    elseif temp[1] == "1002" then
                                        duihuanText:setString(self.duihuanNum.."来豆")
                                    end
                                end
                            end
                            lingquName:setString("领取"..itemMsg.ItemName)
                            self.CheckBox_hongbao = self:GetWidgetByName("CheckBox_hongbao")
                            self.CheckBox_duihuan = self:GetWidgetByName("CheckBox_duihuan")
                            if (self.CheckBox_duihuan:isSelected() == nil and self.CheckBox_hongbao:isSelected() == nil) or (self.CheckBox_duihuan:isSelected() == false and self.CheckBox_hongbao:isSelected() == false) then
                                self.CheckBox_hongbao:setSelected(true)
                            end
                            self.Panel_3:setVisible(true)
                            local function callback(sender, eventType)  
                                if eventType == ccui.CheckBoxEventType.selected then  
                                    if sender == self.CheckBox_hongbao then  
                                        self.CheckBox_duihuan:setSelected(false) 
                                    else                      
                                        self.CheckBox_hongbao:setSelected(false)  
                                    end  
                                elseif eventType == ccui.CheckBoxEventType.unselected then  
                                    if sender == self.CheckBox_hongbao then  
                                        self.CheckBox_duihuan:setSelected(true)  
                                    else      
                                        self.CheckBox_hongbao:setSelected(true)       
                                    end  
                                end  
                            end  
                            self.CheckBox_hongbao:addEventListener(callback)  
                            self.CheckBox_duihuan:addEventListener(callback) 

                            self:AddWidgetEventListenerFunction("Button_queding", handler(self, self.onUse1))
                        --红包、京东卡不兑换，直接领取的时候
                        elseif string.sub(sender.ItemID,1,2) == "15" and itemMsg.ObtainItemIDList == nil then                          
                            --检测公众号
                            if laixiaddz.LocalPlayercfg.LaixiaPhoneNum=="" then
                                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"请点击游戏头像进行手机绑定")
                                self.Panel_3:setVisible(false)
                                return
                            end
                            --京东卡
                            if tonumber(string.sub(sender.ItemID,3,4)) >= 11 then             
                                local unionid = cc.UserDefault:getInstance():getStringForKey("unionid")
                                local pid = sender.ItemID
                                local jc = cc.XMLHttpRequest:new()
                                jc:registerScriptHandler( function() 
                                    local array =  jc.response
                                    local json = require("framework.json");
                                    local array1 = json.decode(array);
                                    if array1.code>0 then --xhr.code >0代表此用户信息存在 <0此用户信息不存在 msg代表具体原因
                                        print(array1.msg)
                                        local CSUseProp = Packet.new("CSUseProp", _LAIXIA_PACKET_CS_UsePacksID)
                                        CSUseProp:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
                                        CSUseProp:setValue("GameID", laixia.config.GameAppID)
                                        CSUseProp:setValue("ItemID", itemMsg.ItemID)
                                        CSUseProp:setValue("type", 0)
                                        laixia.net.sendHttpPacketAndWaiting(CSUseProp);
                                        if itemMsg.isDisapear == 1 then
                                            self.Panel_3:setVisible(false)
                                            self.isPrevious = nil
                                            --清除右边数据
                                            self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                                            self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                                            self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                                            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                                            self.Mybag_Libao_Title_desc:setString("")
                                        end
                                    else
                                        print(array1.msg)
                                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MONEY_WINDOW,"请关注微信服务号:" .. laixiaddz.LocalPlayercfg.LaixiaWechatServiceNum)
                                        self.Panel_3:setVisible(false)
                                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
                                    end
                                end)
                                jc.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                                local URL = string.format("http://wx.laixia.com/wxuserIfExsit?unionid=%s",unionid)
                                jc:open("GET", URL,true)
                                jc:send()
                            else
                                --红包
                                local unionid = cc.UserDefault:getInstance():getStringForKey("unionid")
                                local pid = sender.ItemID
                               --local unionid = crypto.md5(newAccount)
                               --local pid = crypto.md5(sender.ItemID)
                                local jc = cc.XMLHttpRequest:new()
                                jc:registerScriptHandler( function() 
                                    local array =  jc.response
                                    local json = require("framework.json");
                                    local array1 = json.decode(array);
                                    if array1.code>0 then --xhr.code >0代表此用户信息存在 <0此用户信息不存在 msg代表具体原因
                                        print(array1.msg)
                                        --第一阶段成功
                                        --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,array1.msg)
                                        --TIPS
                                        local xhr = cc.XMLHttpRequest:new()
                                        xhr:registerScriptHandler( function() 
                                            --表示XMLHttpRequest对象的状态
                                            --服务器返回的http状态码
                                            local array3 =  xhr.response
                                            local json = require("framework.json")
                                            local array2 = json.decode(array3)
                                            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MONEY_WINDOW,array2.msg)
                                            if array2.code == 1 then
                                                print("使用成功")
                                                if itemMsg.isDisapear == 1 then
                                                    self.Panel_3:setVisible(false)
                                                    self.isPrevious = nil
                                                    --清除右边数据
                                                    self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                                                    self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                                                    self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                                                    self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                                                    self.Mybag_Libao_Title_desc:setString("")
                                                    self:sendToMyBagPacket()
                                                end
                                            end
                                        end)
                                        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                                        local accessTokenURL = string.format("http://wx.laixia.com/posthb?unionid=%s&propid=%s&objectid=%s&phone=%s",unionid,pid,sender.ItemObjectID,laixiaddz.LocalPlayercfg.LaixiaPhoneNum)
                                        xhr:open("GET", accessTokenURL,true)
                                        xhr:send()
                                    else
                                        print(array1.msg)
                                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MONEY_WINDOW,"请关注微信服务号:" .. laixiaddz.LocalPlayercfg.LaixiaWechatServiceNum)
                                        self.Panel_3:setVisible(false)
                                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
                                    end
                                end)
                                jc.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
                                local URL = string.format("http://wx.laixia.com/wxuserIfExsit?unionid=%s",unionid)
                                jc:open("GET", URL,true)
                                jc:send()
                            end
                        end
                    end
                elseif itemMsg.ItemType == 4 then
                    --碎片类
                     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,itemMsg.ItemDesc)
                    if itemMsg.isDisapear == 1 then
                        self.isPrevious = nil
                        --清除右边数据
                        self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                        self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                        self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                        self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                        self.Mybag_Libao_Title_desc:setString("")
                    end
                elseif itemMsg.ItemType == 5 then 
                    --商城商品 
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,itemMsg.ItemDesc)
                    if itemMsg.isDisapear == 1 then
                        self.isPrevious = nil
                        --清除右边数据
                        self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
                        self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
                        self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
                        self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
                        self.Mybag_Libao_Title_desc:setString("")
                    end
                 else
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,itemMsg.ItemDesc)
                end
            end
        end
    end
end

function MyBagWindow:sendToMyBagPacket()
    local CSPackItems = Packet.new("CSPackItems", _LAIXIA_PACKET_CS_PackItemsID)
    CSPackItems:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end


function MyBagWindow:onShow()
    -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDES_BAGTIPS_WINDOW) --隐藏背包tips
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDES_BAGRED_WINDOW) --隐藏红点
    if not self.mIsShow then

        -- 任务红包全新添加的
        self.Text_tou = self:GetWidgetByName("Text_tou")
        self.Text_cishu = self:GetWidgetByName("Text_cishu")
        self.Text_wei = self:GetWidgetByName("Text_wei")
        self.Text_tou:setVisible(false)
        self.Text_cishu:setVisible(false)
        self.Text_wei:setVisible(false)

        self.BG = self:GetWidgetByName("dikuang")
        self.BG:setTouchEnabled(true)
        self.BG:setTouchSwallowEnabled(true)

        self:AddWidgetEventListenerFunction("Button_MyBag_ShurDown",handler(self, self.shutDown));
        self.ButtonArray ={}
        
        if laixia.config.isAudit then
            self:GetWidgetByName("Mybag_Label_All_Font"):setVisible(false)
            self:GetWidgetByName("Mybag_Label_All_Back"):setVisible(false)
            self:GetWidgetByName("Mybag_Label_Tools_Font"):setVisible(false)
            self:GetWidgetByName("Mybag_Label_Tools_Back"):setVisible(false)
            self:GetWidgetByName("Mybag_Label_Exchange__Font"):setVisible(false)
            self:GetWidgetByName("Mybag_Label_Exchange__Back"):setVisible(false)
            self:GetWidgetByName("Mybag_Label_Ticket__Font"):setVisible(false)
            self:GetWidgetByName("Mybag_Label_Ticket__Back"):setVisible(false)
            self:GetWidgetByName("Image_21"):setVisible(false)
        else
            --全部道具前景 --标号为1
            self.Mybag_Label_All_Font = self:GetWidgetByName("Mybag_Label_All_Font")
            self.Mybag_Label_All_Font:setVisible(false)
            table.insert(self.ButtonArray,self.Mybag_Label_All_Font)
            
            --全部道具后景 --标号为2
            self.Mybag_Label_All_Back = self:GetWidgetByName("Mybag_Label_All_Back")
            self.Mybag_Label_All_Back:addTouchEventListener(handler(self, self.showAllIteam))
            self.Mybag_Label_All_Back:setVisible(false)
            table.insert(self.ButtonArray,self.Mybag_Label_All_Back)
            --道具前景 --标号为3
            self.Mybag_Label_Tools_Font = self:GetWidgetByName("Mybag_Label_Tools_Font")
            self.Mybag_Label_Tools_Font:setVisible(false)
            table.insert(self.ButtonArray,self.Mybag_Label_Tools_Font)
            --道具后景 --标号为4
            self.Mybag_Label_Tools_Back = self:GetWidgetByName("Mybag_Label_Tools_Back")
            self.Mybag_Label_Tools_Back:setVisible(false)
            self.Mybag_Label_Tools_Back:addTouchEventListener(handler(self, self.showTools))
            table.insert(self.ButtonArray,self.Mybag_Label_Tools_Back)
       

             --门票前景 --标号为5
            self.Mybag_Label_Ticket_Font = self:GetWidgetByName("Mybag_Label_Ticket__Font")
            self.Mybag_Label_Ticket_Font:setVisible(false)
           table.insert(self.ButtonArray,self.Mybag_Label_Ticket_Font)
            --门票后景 --标号为6
            self.Mybag_Label_Ticket_Back = self:GetWidgetByName("Mybag_Label_Ticket__Back")
            self.Mybag_Label_Ticket_Back:setVisible(false)
            self.Mybag_Label_Ticket_Back:addTouchEventListener(handler(self, self.showMenpiao))
           table.insert(self.ButtonArray,self.Mybag_Label_Ticket_Back)

            --兑换前景  --标号为7     
            self.Mybag_Label_Exchange__Font = self:GetWidgetByName("Mybag_Label_Exchange__Font")
            self.Mybag_Label_Exchange__Font:setVisible(false)
           table.insert(self.ButtonArray,self.Mybag_Label_Exchange__Font)
            --兑换后景 --标号为8
            self.Mybag_Label_Exchange__Back = self:GetWidgetByName("Mybag_Label_Exchange__Back")
            self.Mybag_Label_Exchange__Back:setVisible(false)
            self.Mybag_Label_Exchange__Back:addTouchEventListener(handler(self, self.showExchange))
            table.insert(self.ButtonArray,self.Mybag_Label_Exchange__Back)
        end

        --列表容器
        self.mListViewLibao = self:GetWidgetByName("Mybag_LibaoList")
        self.Mybag_daojuList = self:GetWidgetByName("Mybag_daojuList")
        self.Mybag_menpiaoList = self:GetWidgetByName("Mybag_menpiaoList")
        self.Mybag_duijiangList = self:GetWidgetByName("Mybag_duijiangList")
        ----------------------------------------------------------------------------------------------------        
        --加载的控件
        self.mLibaoCell = self:GetWidgetByName("Panel_Cell");
        self.Panel_3 = self:GetWidgetByName("Panel_3");
        self.Panel_3:setVisible(false)
        
        for i=0,4 do 
            self:GetWidgetByName("Mybag_SingleLibao_0" .. i , self.mLibaoCell ):setVisible(false)
        end
        --快速开始
--        self:AddWidgetEventListenerFunction("Button_Start", handler(self, self.onQuickStart))
--        if laixiaddz.LocalPlayercfg.LaixiaPropsData and #laixiaddz.LocalPlayercfg.LaixiaPropsData>0 then
--            self:hideTips()
--        else
--            self:showTips()
--        end
        --把右边数据清空
        self.Mybag_Libao_Title_desc = self:GetWidgetByName("Mybag_Libao_Title_desc")
        self.Mybag_Libao_Title_desc:enableOutline(cc.c4b(123,6,0,255),2)
        self.Mybag_Libao_Desc = self:GetWidgetByName("Mybag_Libao_Desc")
        -- self.Mybag_Libao_Desc:enableOutline(cc.c4b(112,41,79,255),1)


        self:GetWidgetByName("Mybag_Libao_Desc"):setString("")
        self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
        self.Mybag_Libao_Title_desc:setString("")
        
        self:AddWidgetEventListenerFunction("Mybag_Libao_Use", handler(self, self.onUse)); --绑定使用函数

        self.mIsShow = true
    end
end

function MyBagWindow:updateWindow()
    if self.mIsShow then
        --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BAGRED_WINDOW)

        --数据保存在laixiaddz.LocalPlayercfg.LaixiaPropsData 变量中
        local propsItems = laixiaddz.LocalPlayercfg.LaixiaPropsData 

        -- 遍历是否有任务红包（如果有的话就把它放到第一个位置）
        for k,v in pairs(propsItems) do
            local temp = {}
            if v.ItemID == 13002 and k ~= 1 then
                temp = propsItems[1]
                propsItems[1] = propsItems[k]
                propsItems[k] = temp
            end
        end

        --四个UINode数组
        self.mUINodeArray = {};
        self.daojuUINodeArray = {};
        self.menpiaoUINodeArray = {}
        self.duijiangUINodeArray = {};


        --四个UIitemMsg数组
        self.mUIItemMsgArray = { }
        --道具 门票 兑奖
        self.mMenpiaoArray = {}
        self.mDuijiangArray = {}
        self.mDaojuArray = {}

        -- 标记一下当前的道具 (按钮注释了 这个也没什么用了)       
        self:showOnlyButton(1)

        local itemMsg = laixiaddz.JsonTxtData:queryTable("items")

        for i,v in ipairs(propsItems) do
            local itemData =itemMsg:query("ItemID",v.ItemID)
            if itemData then
                if itemData.ItemType == 2 then
                    table.insert(self.mMenpiaoArray,v)
                --elseif itemData.ItemType == 7 or itemData.ItemType==0 or itemData.ItemType==2 then
                elseif itemData.ItemType == 3 then
                    table.insert(self.mDuijiangArray,v)
                else
                    --table.insert(self.mDaojuArray,v)
                end
                table.insert(self.mUIItemMsgArray,v)
            end
        end
        
        self.mListViewLibao:removeAllItems()
        self.Mybag_duijiangList:removeAllItems()
        self.Mybag_menpiaoList:removeAllItems()
        self.Mybag_daojuList:removeAllItems()

        self:addItems();
        if (self.mUINodeArray[1] ~= nil) then
            self.Index = 1
--            self:hideTips()
        else
--            self:showTips()
        end
        self:showAllIteam()
    end
end


function MyBagWindow:onQuickStart(sender, eventtype)
    -- 快速开始按钮回调函数
    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW,0)
    end
end

--显示唯一的前景按钮
function MyBagWindow:showOnlyButton(index)
   laixia.UItools.onShowOnly(index,self.ButtonArray)    
end


--显示所有物品
function MyBagWindow:showAllIteam(sender, eventType)
    -- if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(1)
        self.mListViewLibao:setVisible(true)
        self.Mybag_daojuList:setVisible(false)
        self.Mybag_menpiaoList:setVisible(false)
        self.Mybag_duijiangList:setVisible(false)
       --清除右边数据
        if self.isPrevious ~= nil then
            self:GetWidgetByName("Mybag_guangxiao",self.isPrevious):setVisible(false)
            self.isPrevious = nil
            self:GetWidgetByName("Mybag_Libao_Desc"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
            self.Mybag_Libao_Title_desc:setVisible(false) 
        end
    -- end
end

--显示道具
function MyBagWindow:showTools(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(3)
        self.mListViewLibao:setVisible(false)
        self.Mybag_daojuList:setVisible(true)
        self.Mybag_menpiaoList:setVisible(false)
        self.Mybag_duijiangList:setVisible(false)
        --清除右边数据
        if self.isPrevious ~= nil then
            self:GetWidgetByName("Mybag_guangxiao",self.isPrevious):setVisible(false)
            self.isPrevious = nil
            self:GetWidgetByName("Mybag_Libao_Desc"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
            self.Mybag_Libao_Title_desc:setVisible(false) 
        end
    end
end

--显示门票
function MyBagWindow:showMenpiao(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(5)
        self.mListViewLibao:setVisible(false)
        self.Mybag_daojuList:setVisible(false)
        self.Mybag_menpiaoList:setVisible(true)
        self.Mybag_duijiangList:setVisible(false)
        --清除右边数据
        if self.isPrevious ~= nil then
            self:GetWidgetByName("Mybag_guangxiao",self.isPrevious):setVisible(false)
            self.isPrevious = nil
            self:GetWidgetByName("Mybag_Libao_Desc"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
            self.Mybag_Libao_Title_desc:setVisible(false) 
        end
    end
end

--显示兑换
function MyBagWindow:showExchange(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:showOnlyButton(7)
        self.mListViewLibao:setVisible(false)
        self.Mybag_daojuList:setVisible(false)
        self.Mybag_menpiaoList:setVisible(false)
        self.Mybag_duijiangList:setVisible(true)
        --清除右边数据
        if self.isPrevious ~= nil then
            self:GetWidgetByName("Mybag_guangxiao",self.isPrevious):setVisible(false)
            self.isPrevious = nil
            self:GetWidgetByName("Mybag_Libao_Desc"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon"):setVisible(false)
            self:GetWidgetByName("Image_Detail_Icon_copy"):setVisible(false)
            self:GetWidgetByName("Mybag_Libao_Use"):setVisible(false)
            self.Mybag_Libao_Title_desc:setVisible(false) 
        end
    end
end


-- 礼品盒为空时显示提示
function MyBagWindow:showTips()
    self:GetWidgetByName("Image_Tips"):setVisible(true)
end

--  礼品盒为空时隐藏提示
function MyBagWindow:hideTips()
    self:GetWidgetByName("Image_Tips"):setVisible(false)
end

function MyBagWindow:shutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print("this is shutdown")
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

--添加item数据和节点到表中
function MyBagWindow:addItems()
    --定义一个局部变量 保存Item数

    local itemNumber
    --for listViewIndex=1,4 do
    for listViewIndex=1,4 do-----现在只走listViewIndex==1（就是显示全部Item）
        local dataArray = {}
        local dataArrays = {}

        
        if listViewIndex==1 then
            dataArrays = self.mUIItemMsgArray
        elseif listViewIndex==2 then
            dataArrays = self.mDaojuArray
        elseif listViewIndex == 3 then
            dataArrays = self.mMenpiaoArray
        elseif listViewIndex==4 then
            dataArrays = self.mDuijiangArray
        end

        -- dataArrays[1] = {ItemID = 1501,ItemCount = 5,EffTime = 0}
        -- dataArrays[2] = {ItemID = 1001,ItemCount = 6,EffTime = 0}        
        for i=1,#dataArrays do
        local itemid = dataArrays[i].ItemID
            local itemMsg = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",itemid); 

            if itemMsg.isPile == 0 then
                for j=1,dataArrays[i].ItemCount do
                    dataArray[#dataArray+1] = clone(dataArrays[i])
                    dataArray[#dataArray].ItemCount = 1
                end
            else
                if itemMsg.PileNum >= dataArrays[i].ItemCount then
                     dataArray[#dataArray+1] = clone(dataArrays[i])
                else 
                    local counts = dataArrays[i].ItemCount
                    local num1 =  math.floor(dataArrays[i].ItemCount / itemMsg.PileNum)
                    local num2 =  counts % itemMsg.PileNum
                    for j=1,num1 do
                         dataArray[#dataArray+1] = clone(dataArrays[i])
                        dataArray[#dataArray].ItemCount = itemMsg.PileNum
                        --  dataArrays[i].ItemCount = itemMsg.PileNum
                        -- table.insert(dataArray,dataArrays[i])
                    end

                    local num2 =  counts % itemMsg.PileNum
                    if (num2 ~= 0) then
                        num1 = num1+1
                        dataArray[#dataArray+1] = clone(dataArrays[i])
                        dataArray[#dataArray].ItemCount = num2
                    end   
                end
            end
        end
     

        self.dataArrayss = dataArray

        if listViewIndex == 1 then
            itemNumber = #dataArray
        elseif listViewIndex == 2 then
            itemNumber = #dataArray
        elseif listViewIndex == 3 then
            itemNumber = #dataArray
        elseif listViewIndex == 4 then
            itemNumber = #dataArray
        end

--------获取有几行控件 最后一行控件有几个item
        --totalNumber 用来记录有几行 向下取整(返回小于参数x的最大整数)
        local totalNumber =  math.floor(itemNumber / 5)
        --numberMod   用来最后一行的Item的个数
        local numberMod =  itemNumber% 5

        local addModelNumber = totalNumber
        --如果最后一行的Item的个数~=0 那么行+1(因为上面是向下取整的)
        if (numberMod ~= 0) then 
            addModelNumber = totalNumber + 1
        end
--------

--------控件

        --遍历行
        for i=1,addModelNumber do 
            local model = self.mLibaoCell:clone()
            if listViewIndex==1 then
                self.mListViewLibao:pushBackCustomItem(model);
            elseif listViewIndex==2 then
                self.Mybag_daojuList:pushBackCustomItem(model);
            elseif listViewIndex == 3 then
                self.Mybag_menpiaoList:pushBackCustomItem(model);
            elseif listViewIndex==4 then
                self.Mybag_duijiangList:pushBackCustomItem(model);
            end

            local size = model:getContentSize()
            local length =  size.width/5
            local pointstart = size.width/8

            for j=0,4 do 
                local idx = j
                --index = 当前是所有控件中的第几个 注意:i从1，j从0开始
                local index = 5*(i-1) + j+1
                if (dataArray[index] ~=nil and dataArray[index].ItemCount >= 0 )then
                    local itemMsg = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",dataArray[index].ItemID);
                    --取出克隆的基础容器(行)上的item(列)
                    local btnModel = self:GetWidgetByName("Mybag_SingleLibao_0" .. idx , model)
                    self.model_ = btnModel
                    local index = 5*(i-1) + j+1
                    if (dataArray[index] ~=nil and dataArray[index].ItemCount >= 0 )then
                        btnModel:show()
                        btnModel:setTag(index)
                        if listViewIndex == 1 then
                            self.mUINodeArray[#self.mUINodeArray + 1] = btnModel
                        elseif listViewIndex == 2 then
                            self.daojuUINodeArray[#self.daojuUINodeArray + 1] = btnModel
                        elseif listViewIndex == 3 then
                            self.menpiaoUINodeArray[#self.menpiaoUINodeArray + 1] = btnModel
                        elseif listViewIndex == 4 then
                            self.duijiangUINodeArray[#self.duijiangUINodeArray + 1] = btnModel
                        end    
                        --重新保存取出克隆的基础容器(行)上的item(列)           
                        local model_sender = self:GetWidgetByName("Mybag_SingleLibao_0"..idx,model)
                        --取出item的id保存
                        model_sender.ItemID = dataArray[index].ItemID
                        --取出itemObjectID 保存
                        model_sender.ItemObjectID = dataArray[index].ItemObjectID
                        --添加item的按钮监听
                        --self:AddWidgetEventListenerFunction("Mybag_SingleLibao_0"..idx, handler(self, self.onClickToShow),model); --绑定使用函数
                        -- self.isLight = false
                        self:AddWidgetEventListenerFunction("Mybag_SingleLibao_0" .. idx,handler(self, self.onClickToShow),model)
                        self:GetWidgetByName("Mybag_guangxiao", self.model_):setVisible(false)
                    end
                end
            end
        end

        -- 填充
        for i = 1, itemNumber do
            --self:AddWidgetEventListenerFunction("Mybag_SingleLibao_0" .. i,handler(self, self.onClickToShow),model)
            self:addItem(i, dataArray[i],listViewIndex);
        end
    end
end 

--添加Item到界面上 并设置Item上的节点
function MyBagWindow:addItem(index, item,tabIndex)
    local dataArray = {}
    if tabIndex==1 then
        dataArray = self.dataArrayss
    elseif tabIndex==2 then
        dataArray = self.dataArrayss
    elseif tabIndex == 3 then
        dataArray = self.dataArrayss
    elseif tabIndex==4 then
        dataArray = self.dataArrayss
    end
    local itemData =laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",item.ItemID);
    if (itemData ~= nil) then
        -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BAGTIPS_WINDOW)
        if tabIndex == 1 then
            self.control = self.mUINodeArray[index];
        elseif tabIndex == 2 then
            self.control = self.daojuUINodeArray[index]
        elseif tabIndex == 3 then
            self.control = self.menpiaoUINodeArray[index]
        elseif tabIndex == 4 then
            self.control = self.duijiangUINodeArray[index]
        end
        self.control:setTag(index);

        local name = self:GetWidgetByName("Text_wupinming",self.control)
        name:setString(itemData.ItemName)



        --图片图标
        local icon = self:GetWidgetByName("Mybag_Circle_Icon", self.control)
        self:GetWidgetByName("Mybag_Circle_Icon", self.control):setVisible(false)
        local baoming_Array = string.split(itemData.ImagePath ,'/')
        icon:removeAllChildren()
        if #baoming_Array >1 then
            local sprite = display.newSprite(itemData.ImagePath)
            sprite:setScale(0.4)  
            sprite:setAnchorPoint(cc.p(0.5,0.5))
            sprite:setPosition(cc.p(0,0))
            sprite:addTo(icon)
        else
           
            
            --ImagePath字段 道具大icon############
            icon:loadTexture(itemData.ImagePath, 1)
            icon:setScale(0.5)            
        end
        self:GetWidgetByName("Mybag_Circle_Icon", self.control):setVisible(true)



        --PresentItemID1 和 BaseCount 基础加多少 后面还有个额外加多少
        --if itemData.PresentItemID1 == 1003 then
        -- if itemData.ItemID == 1001 then
        --      local sicon =  "red_packet_"..itemData.BaseCount..".png"
        --      local count = ccui.ImageView:create(sicon,1)
        --      count:setPosition(78,60)
        --      count:setLocalZOrder(100)
        --      count:addTo(icon)
        --  end
        --end

        --物品数量
        local BT_use = self:GetWidgetByName("Mybag_Libao_Use");
        self.Image_27 = self:GetWidgetByName("Image_27")
        self.Image_27:setVisible(false)

        --1002只显示数量  五个类型中哪几种只不显示use？？？？？？？？
        -- if dataArray[index].ItemID == 1002 then
        --    BT_use:setVisible(false)
        -- end 

        --如果effTime不是永久有效
        if dataArray[index].EffTime > 0 and itemData.isPile==0 then
            self:GetWidgetByName("Image_27", self.control):setVisible(true)
            self:GetWidgetByName("Text_18", self.control):setVisible(true)
            local diff = dataArray[index].EffTime/1000 - os.time()
            local time1 = math.floor(diff/60/60/24)
            print("time1")
            --local day = dataArray[index].EffTime   
            self.Image_27:setVisible(true)
            self:GetWidgetByName("Text_18", self.control):setString(time1.."天")
            self:GetWidgetByName("Mybag_Libao_Num", self.control):setVisible(false)  --显示道具数量
        else
            self:GetWidgetByName("Image_27", self.control):setVisible(false)
            self:GetWidgetByName("Mybag_Libao_Num", self.control):setString(dataArray[index].ItemCount)
        end

        --如果可赠送
--        if itemData.isGiver ~= nil and 1 == itemData.isGiver then
--           local bt_Present =  self:GetWidgetByName("Mybag_Libao_Present", self.control) 
--           bt_Present:setVisible(true)
--           bt_Present.ItemID = self.mUIItemMsgArray[index].ItemID
--           bt_Present.ItemObjectID = self.mUIItemMsgArray[index].ItemObjectID
--           bt_Present.ItemNum = self.mUIItemMsgArray[index].ItemCount
--           self:GetWidgetByName("Label_Present",bt_Present):setString("赠送")
--           bt_Present:addTouchEventListener(handler(self, self.onPresent))
--        else
--           self:GetWidgetByName("Mybag_Libao_Present", self.control) :setVisible(false)
--        end
    end
end 

--赠送函数
function MyBagWindow:onPresent(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local data ={}
        data.itemID = sender.ItemID
        data.itemObjID =  sender.ItemObjectID
        data.ItemNum =  sender.ItemNum
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_PRESENT_WINDOW,data);
    end
end

function MyBagWindow:onDestroy()
    self.mIsShow = false
    self.isPrevious = nil
end

return MyBagWindow.new()
