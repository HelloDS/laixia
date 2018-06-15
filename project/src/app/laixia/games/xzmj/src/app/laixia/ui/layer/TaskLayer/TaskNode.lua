



local TaskNode = class("TaskNode", import("...BaseView"))

function TaskNode:ctor(...)
 	TaskNode.super.ctor(self)


    self:InjectView("MiaoShu")
    self:InjectView("Lingqu")
    self:InjectView("TelieText")

    if self.TelieText then
    
    end

    self:OnClick(self.Lingqu, function()
        print("Lingqu-------------")
    end,{["isScale"] = false, ["hasAudio"] = false})
end



function TaskNode:UpdateDate( data )
	print("SSSSSSS----------"..data)
	self.TelieText:setString( "888888888888" )
end

function TaskNode:UpdateDate1( telie,miaoshu )
    self.MiaoShu:setString(miaoshu)
    self.TelieText:setString(telie)

end

function TaskNode:GetCsbName()
    return "TaskNode"
end 

return TaskNode

