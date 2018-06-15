



local MatchEnrollNode = class("MatchEnrollNode", import("...BaseView"))
function MatchEnrollNode:ctor(...)
    MatchEnrollNode.super.ctor(self)

    self:InjectView("Biaoti")
    self:InjectView("RenShu")
    self:InjectView("JJkais")
    self:InjectView("KaisTime")
    self:InjectView("Jinbi")
    self:InjectView("Laidou")
    self:InjectView("MianFei")
    self:InjectView("CanSaiQuan")
    self:InjectView("TuiSai")
    self:InjectView("BaoMing")

    self:OnClick(self.TuiSai, function()
        print("TuiSai")

    end,{["isScale"] = false, ["hasAudio"] = false})


    self:OnClick(self.BaoMing, function()
        print("BaoMing")
        xzmj.MainCommand:InTypeJumpView(3)

    end,{["isScale"] = false, ["hasAudio"] = false})


end

function MatchEnrollNode:init()

end


function MatchEnrollNode:GetCsbName()
    return "MatchEnrollNode"
end


function MatchEnrollNode:UpdateDate( data ) 
	self.Biaoti:setString(data.aaa)
	self.RenShu:setString(data.ccc)
	self.JJkais:setString("")
	self.KaisTime:setString("")
	self.Jinbi:setString("")
	self.Laidou:setString("")
	self.MianFei:setString("")
	self.CanSaiQuan:setVisible(false)
	self.TuiSai:setVisible(false)

end 


return MatchEnrollNode

