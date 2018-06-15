local TPBankruptcyPackage = class("TPBankruptcyPackage", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg;     
local Packet = import("....net.Packet") 
local laixia = laixia;
local db2 = laixia.JsonTxtData;
local itemDBM

function TPBankruptcyPackage:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end
function TPBankruptcyPackage:getName()
    return "TPBankruptcyPackage"
end

function TPBankruptcyPackage:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_BANKRUPTBAG_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_BANKRUPTBAG_WINDOW, handler(self, self.sendRequest))
end

function TPBankruptcyPackage:sendRequest()
    local CSBankruptBag = Packet.new("CSBankruptBag", _LAIXIA_PACKET_CS_BankruptBagID)
    CSBankruptBag:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSBankruptBag:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacket(CSBankruptBag)  
end
function TPBankruptcyPackage:onShow(msg)
    if msg and msg.data then
        self.mCallFunc = msg.data.OnCallFunc
    end
    self:AddWidgetEventListenerFunction("Button_GamePacksBus_Quit", handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("Button_Receive", handler(self, self.onShop))
    itemDBM = db2:queryTable("items");
    self.mItemID = laixia.LocalPlayercfg.LaixiaBankruptItemID
    self:showDetail()
end

function TPBankruptcyPackage:onShutDown(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if self.callFunc ~= nil then
            self.callFunc(true)
        else
            if self.mCallFunc~= nil then 
                self.mCallFunc(true)
            end 
           self:destroy()
        end
    end  
end
function TPBankruptcyPackage:onShop(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_ORDERINFO_WINDOW,{id=self.mItemID})
        self:destroy()
    end
end


function TPBankruptcyPackage:showDetail()

    local goods = laixia.JsonTxtData:queryTable("shop"):query("itemsID",self.mItemID)
    local price = 0 
    if goods.Type == 1 then 
        self.mItemID = goods.itemsID
        price = goods.price
    else
        self:destroy()
        return 
    end
    self:GetWidgetByName("BitmapLabel_Price"):setString(price)
    local Itemsdata = itemDBM:query("ItemID",self.mItemID)
    local coins = Itemsdata.BaseCount
    if Itemsdata.AddCount and Itemsdata.AddCount~=0 then 
        coins = coins + Itemsdata.AddCount
    end
    self:GetWidgetByName("BitmapLabel_Gold"):setString(coins.."金币")
end


return TPBankruptcyPackage.new()
