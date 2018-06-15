
--[[--
--界面的跳转
--]]

local MainCommand = class("MainCommand")

--[[--
--根据模块type界面跳转
--@param #string sType 模块type
--@extendData  扩展数据 比如服务器传过来的数据
--]]
function MainCommand:InTypeJumpView(sType , extendData, extendData2)
    local moduleType = xzmj.public.ModuleType
    if 1 == sType then
        local layer = nil
        layer = xzmj.layer.GameLayer.new()
        layer:Show()
    elseif 2 == sType then
        local layer = xzmj.layer.MatchEnrollLayer
        layer.new():Show()
    elseif 3 == sType then
        local layer = xzmj.layer.MatchInstitutionLayer
        layer.new():Show()
    elseif 4 == sType then
        local RechargeTip = xzmj.layer.RechargeTip.new()
        RechargeTip:Show()
        RechargeTip:toShowPopupEffert(2)
        RechargeTip:setCanceledOnTouchOutside(true)
    elseif 5 == sType then
        local layer = xzmj.layer.TaskLayer
        layer.new():Show()
    elseif 6 == sType then
        local layer = xzmj.layer.Poker_Menu
        layer.new():Show()
    elseif 7 == sType then
        local layer = xzmj.layer.talklayer
        layer.new():Show()
    elseif 8 == sType then
        local layer = xzmj.layer.GameTextTips
        layer.new():Show()
    elseif 9 == sType then
        local layer = xzmj.layer.RuleTips
        layer.new():Show()
    elseif 10 == sType then
        local playground = xzmj.layer.PlayGroundLayer.new()
        playground:Show()
    elseif 11 == sType then
        local playground = xzmj.layer.GameStartAct.new()
        playground:Show()
    elseif 12 == sType then
        local pokerdesk = xzmj.layer.PokerDeskLayer.new()
        pokerdesk:Show()
    elseif 13 == sType then
        local layer = xzmj.layer.GameSettlementLayer.new()
        layer:Show()
    end
end

--[[--
--设置界面跳转的参数
--]]
function MainCommand:setParams(params)
    self.params = params
end

return MainCommand
