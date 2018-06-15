--[[
    大厅主界面层

]]
local TaskLayer = class("TaskLayer" ,function()
    return display.newLayer("TaskLayer")
end)
local isshow = false

--[[
    构造函数
]]
function TaskLayer:ctor()
    if isshow == true then
        return
    end
    self:init()
end

--[[
    初始化
]]
function TaskLayer:init()
--初始化界面
    local csbNode = cc.CSLoader:createNode("new_ui/TaskLayer.csb")
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.cx,display.cy)
    self:addChild(csbNode)
    self.rootNode = csbNode
    _G.adapPanel_root(csbNode)

    self.Button_everyday = _G.seekNodeByName(self.rootNode,"Button_everyday")
    self.Button_everyday:addTouchEventListener(handler(self,self.onEveryday))
    self.Button_challenge = _G.seekNodeByName(self.rootNode,"Button_challenge")
    self.Button_challenge:addTouchEventListener(handler(self,self.onChallenge))
    self.Button_threeday = _G.seekNodeByName(self.rootNode,"Button_threeday")
    self.Button_threeday:addTouchEventListener(handler(self,self.onThreeday))
    self.ListView_task = _G.seekNodeByName(self.rootNode,"ListView_task")
    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self, self.onBack))

    local function onNodeEvent(event)
        if "enter" == event then
            isshow = true
        elseif "exit" == event then
            isshow = false
        end
    end
    self:registerScriptHandler(onNodeEvent)

end
--[[
    挑战任务
]]
function TaskLayer:onChallenge()
end
--[[
    三日任务是什么鬼？
]]
function TaskLayer:onThreeday()
end
--[[
    每日任务
]]
function TaskLayer:onEveryday()
end
--[[
    --关闭界面
]]
function TaskLayer:onBack()
    self.rootNode:removeFromParent()
    self.rootNode = nil
end
return TaskLayer