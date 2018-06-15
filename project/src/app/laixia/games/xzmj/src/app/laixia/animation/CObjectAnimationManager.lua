
local l_AniDataArray = import(".CCBAnimationArray");

ccbControl = ccbControl or  {};
ccb = ccb or {};

local AnimationController = "CocosAnim";
ccb[AnimationController] = ccbControl;
CCBAnimationOwner = CCBAnimationOwner or {}; --


local CObjectAnimationManager = class("CObjectAnimationManager")

function CObjectAnimationManager:ctor(args)
    self._buf = {};
end

function CObjectAnimationManager:dtor()

end


function CObjectAnimationManager:load()
    local len = #l_AniDataArray;
    for i,v in ipairs(l_AniDataArray) do
        self:registerAnimationData(v);
        ccb[v.DocumentControllerName] = ccb[v.DocumentControllerName] or {}
    end
end


function CObjectAnimationManager:registerAnimationData(v)
    self._buf[v.Name] = v;
end

function CObjectAnimationManager:getAnimationData(name)
    return self._buf[name]
end


function CObjectAnimationManager:onComplete(node,callback)
    local target =node;
    local actions = {}
    if(callback ~= nil)then
        actions[#actions + 1] = cc.CallFunc:create(callback);
    end
    actions[#actions + 1] = cc.RemoveSelf:create()

    local action
    if #actions > 1 then
        action = transition.sequence(actions)
    else
        action = actions[1]
    end
    target:runAction(action)

end


function CObjectAnimationManager:playAnimationAt(parent,name,timeline,callback)

    if(timeline == nil) then
        timeline = "Default Timeline"
    end

    local aniData = self:getAnimationData(name);

    local node = nil
    ccb[aniData.DocumentControllerName]["onComplete"] = function()
        self:onComplete(node,callback)
    end

    node = CCBReaderLoad(aniData.AnimationFile,cc.CCBProxy:create(),CCBAnimationOwner);
    node:addTo(parent);


    local owner     = ccb[aniData.DocumentControllerName]
    local amManager = owner["mAnimationManager"];

    if amManager~= nil then
        amManager:runAnimationsForSequenceNamed(timeline);
    end
    --amManager:runAnimationsForSequenceNamedTweenDuration(timeline,1);

    return node

end


function CObjectAnimationManager:destroy()
    for i,v in ipairs(self._buf) do
        v:release();
    end
    self._buf = {};
end
--endregion

function CObjectAnimationManager:doLoad(callback)
    local len = #l_AniDataArray;
    for k,v in pairs(l_AniDataArray) do
        --if(cc.FileUtils:getInstance():isFileExist(v.AnimationFile)) then
        self:registerAnimationData(v);
        ccb[v.DocumentControllerName] = ccb[v.DocumentControllerName] or {}
        if(callback ~= nil)then
            callback(v.Name);
        end
        --end
    end
end

function CObjectAnimationManager:getItemCount()
    return #l_AniDataArray;
end

return CObjectAnimationManager.new()
