



local TaskLayer = class("TaskLayer", xzmj.ui.BaseDialog)
function TaskLayer:ctor( delete )
    TaskLayer.super.ctor(self)
    self:InjectView("Panel_Node")    
    
    -- self:InjectView("ProjectNode_1")
    -- self:InjectView("ProjectNode_2")

    self.mModel = xzmj.Model.TaskLayerModel

    self:setCanceledOnTouchOutside(true)
    self:InjectView("closebtn")
    self:OnClick(self.closebtn, function()
            self:dismiss()
    end,{["isScale"] = false, ["hasAudio"] = false})


    local poy = 337
    local pox = 464
    local node = xzmj.layer.TaskNode
    for i = 1,2 do
        local n  = node.new()
        if i == 2 then
            pox = 828
        end
        n:setPosition( pox,poy )
        n:UpdateDate1(self.mModel.Telie[i],self.mModel.MiaoShu[i])
        self:addChild( n )        
    end
    self:init()


end

function TaskLayer:GetCsbName()
    return "TaskLayer"
end 

function TaskLayer:init()
end

return TaskLayer

