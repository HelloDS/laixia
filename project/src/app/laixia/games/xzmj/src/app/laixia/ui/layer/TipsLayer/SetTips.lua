

--[[
    麻将牌  上下的出牌
]]--
local SetTips = class("SetTips",import("...BaseDialog"))
SetTips.path = "games/xzmj/setLayer/"
SetTips.kai = "kai.png"
SetTips.guan = "guan.png"
function SetTips:ctor( data)
    SetTips.super.ctor(self)

    self:InjectView("Button_effect_on")
    self:InjectView("Button_music_on")
    self:InjectView("Button_shake_on")
    self:setCanceledOnTouchOutside(true)
    
    self:OnClick(self.Button_effect_on, function()
        print("Button_effect_on")
        local pt = self.path.."guan.png"
        self.Button_effect_on:loadTextures(pt, pt, pt, 0)

    end,{["isScale"] = false, ["hasAudio"] = false})


    self:OnClick(self.Button_music_on, function()
        print("Button_music_on")

    end,{["isScale"] = false, ["hasAudio"] = false})


    self:OnClick(self.Button_shake_on, function()
        print("Button_music_on")

    end,{["isScale"] = false, ["hasAudio"] = false})

	  	
end

function SetTips:GetCsbName()
    return "SetTips"
end 




return SetTips

