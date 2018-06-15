--[[
    说明: 弹窗基类, 自带半透明背景, 所有继承的弹窗不需要再增加透明背景


]]--

local BaseDialog = class("BaseDialog", import(".PopupWindowWrapper"))

function BaseDialog:ctor()
    BaseDialog.super.ctor(self)
    self.isPopup = true -- 你是否需要弹窗

    self:setContentSize(xzmj.winSize.width, xzmj.winSize.height)
end
--注册边框样式，  zIndex为z轴深度，zIndex如果不填，则边框添加到内容的最上面
--可以注册多个styleBorder
function BaseDialog:registStyleBorder(styleBorder , zIndex)
    if styleBorder ~=nil then
        if zIndex ==nil then
            self:addChild(styleBorder)
        else
            self:addChild(styleBorder , zIndex)
        end

    end
end

function BaseDialog:Show()
    xzmj.runningScene.dialogStack:push( self )
end



function  BaseDialog:dismissAll()
    xzmj.runningScene:disissAllDialog()
end

function BaseDialog:isShowing()
    
end

function BaseDialog:setOnDismissListener(listener)
    self._dismissListener = listener
end

return BaseDialog
