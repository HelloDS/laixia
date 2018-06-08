
local l_AniDataArray = import(".CocosAnimArray");

ccbControl = ccbControl or  {};
ccb = ccb or {};

local AnimationController = "CCBAnimation";
ccb[AnimationController] = ccbControl;
CCBAnimationOwner = CCBAnimationOwner or {}; --


local CocosAnimManager = class("CocosAnimManager")

function CocosAnimManager:ctor(args)
    self._buf = {};
end

function CocosAnimManager:dtor()

end


function CocosAnimManager:load()
    local len = #l_AniDataArray;
    for i,v in ipairs(l_AniDataArray) do
        self:registerAnimationData(v);
        ccb[v.Name] = ccb[v.Name] or {}
    end
end


function CocosAnimManager:registerAnimationData(v)
    self._buf[v.Name] = v;
end

function CocosAnimManager:getAnimationData(name)
    return self._buf[name]
end

function CocosAnimManager:playAnimationAt(parent,name,callback)
    local aniData = self:getAnimationData(name);
    local node = laixia.Layout.loadNode(aniData.AnimationFile)
    node:addTo(parent);
    local action = cc.CSLoader:createTimeline(aniData.AnimationFile)
    node:runAction(action)
    action:gotoFrameAndPlay(0,aniData.isLoop)
    local speed = action:getTimeSpeed()
    local startFrame = action:getStartFrame()
    local endFrame = action:getEndFrame()
    local frameNum = endFrame - startFrame
    local time = 1.0/(speed*60.0)*frameNum
    if aniData.isLoop == false then
        node:runAction(cc.Sequence:create(
                    cc.DelayTime:create(time),
                    cc.CallFunc:create(
                        function()
                            node:removeFromParent()
                        end),nil))

    end
    return node
end

function CocosAnimManager:destroy()
    for i,v in ipairs(self._buf) do
        v:release();
    end
    self._buf = {};
end
--endregion

function CocosAnimManager:doLoad(callback)
    local len = #l_AniDataArray;
    for k,v in pairs(l_AniDataArray) do
        --if(cc.FileUtils:getInstance():isFileExist(v.AnimationFile)) then
        self:registerAnimationData(v);
        ccb[v.Name] = ccb[v.Name] or {}
        if(callback ~= nil)then
            callback(v.Name);
        end
        --end
    end
end

function CocosAnimManager:getItemCount()
    return #l_AniDataArray;
end

return CocosAnimManager.new()
