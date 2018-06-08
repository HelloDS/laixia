--
-- Author: Feng
-- Date: 2018-04-11 15:52:52
--

local XzScene = class("XzScene", function()
    return display.newScene("XzScene")
end )


function XzScene:ctor()
end

function XzScene:init()
end

function XzScene:onEnter()
	print("XzScene onEnter")
end

function XzScene:onExit()
    print("XzScene onExit")
end

return XzScene
