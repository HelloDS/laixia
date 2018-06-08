

local IBaseLoader = class("IBaseLoader")

function IBaseLoader:ctor(...)
    local args = {...};
    self._cur_module_name = ...;
    self._loadingCallBack = nil;  --回调函数
    self._itemArrays = {}; -- item 表
end


--重载
function IBaseLoader:init()

end



function IBaseLoader:getItemCount()
    return table.nums(self._itemArrays);
end

function IBaseLoader:registerLoadingCallback(callback)
    self._loadingCallback = callback;
    return self;
end


function IBaseLoader:doLoad()
    for k,v in pairs(self._itemArrays) do
        v:doLoad(self._loadingCallback)
    end
end

-- Drivedcall
--self.super.doLoad(self)

function IBaseLoader:addLoadItem(itemName)
    laixia.logGame("IBaseLoader:addLoadItem "..itemName);
    if(self._itemArrays[itemName] == nil) then
        self._itemArrays[itemName] = import("."..itemName,self._cur_module_name);
        self[itemName] = self._itemArrays[itemName];
    end
    return self;
end

function IBaseLoader:getLoadItem(itemName)
    return self._itemArrays[itemName];
end

return IBaseLoader;
--endregion
