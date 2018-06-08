


local l_CMN = ...;


local CObjectUIInit = class("CObjectUIInit_sys",laixia.Loader)

function CObjectUIInit:ctor(...)
    local args = {...};
    self.super.ctor(self,l_CMN);
end

function CObjectUIInit:init()
    self:addLoadItem("WindowManager")
        :addLoadItem("UILayer");
    self.WindowManager:init()
end

--挂起
function CObjectUIInit:PauseFun()
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_BROADCAST_WINDOW);
    self:DelSceneFunc();
end

--恢复
function CObjectUIInit:resume()
    local scene = cc.Director:getInstance():getRunningScene()
    self:AppendSceneFunc(scene);
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BROADCASTS_WINDOW);
end

function CObjectUIInit:getItemCount()
    return self.WindowManager:getCount();
end

function CObjectUIInit:tick(dt)
    self.WindowManager:tick(dt)
end

function CObjectUIInit:AppendSceneFunc(scene)
    self.UILayer:addTo(scene);
end


function CObjectUIInit:doLoad()
    self.WindowManager:doLoad(self._loadingCallback);
end

function CObjectUIInit:DelSceneFunc()
    self.UILayer:removeFromParent();
end

function CObjectUIInit:backFromSubGame()
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)  --物理键退出
end
return CObjectUIInit.new();