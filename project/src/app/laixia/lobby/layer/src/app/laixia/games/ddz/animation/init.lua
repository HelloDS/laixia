
--

local CURRENT_MODULE_NAME = ...;

local AniSys = class("AniSys",laixiaddz.Loader)

function AniSys:ctor()
    self.super.ctor(self,CURRENT_MODULE_NAME);
end

function AniSys:init()
    self:addLoadItem("CObjectAnimationManager")
    self:addLoadItem("CocosAnimManager")
end

function AniSys:getItemCount()
    local count = 0;
    for k,v in pairs(self._itemArrays) do
        count = count + v:getItemCount();
    end
    return count;
end



return AniSys.new();

--endregion


