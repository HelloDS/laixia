
laixia = laixia  or {};
local utils = {}
local dict = import(".Dict") --

function utils.DICT(ID)
    return dict[ID]
end

function utils.CoinType()
    return dict.CoinType()
end

laixiaddz.helper = import(".Helpers");


return utils
