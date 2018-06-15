

--[[
  公共按钮节点

  参数说明
  detele = 
  {
    ImageName = {"1.png","1.png","1.png","1.png"} --全路径
    Callfun,
    Type,--1 图片，2是程序字体
  }

]]--

local CommBtnNode = class("CommBtnNode", xzmj.ui.BaseView)

function CommBtnNode:ctor( _sdetele  )
    CommBtnNode.super.ctor(self)

    self.detele = _sdetele

    self:InjectView("Image9bj")
    self:InjectView("BtnImage")
    if self.detele.Type == 1 then
      self:initImageBtn()
    else
      self:initTextBtn()

    end
end

function CommBtnNode:initImageBtn( ... )
    self.mBtnTable = {}
    local count = #self.detele.ImageName
    local path2 = self.detele.ImageName[2]
    local wd = nil
    local dis = 120 -- 间距
    local stw = 50*2 -- 开始和结尾的距离
    local Image9bjHt = 84
    local ht = self.Image9bj:getContentSize().height
    local bg = cc.Sprite:create(path2)
    wd = bg:getContentSize().width
    self.Image9bj:setContentSize((wd+dis)*count-dis + stw ,ht)


    for i = 1, count do
        local pathName = self.detele.ImageName[i]
        local button = ccui.Button:create()
        button:setTouchEnabled(true)
        button:loadTextures(pathName, pathName, pathName, 0)

        button.tag = i

        local btttonH = button:getContentSize().width
        button:setPosition((wd+dis)*(i-1)+(btttonH/2) + stw/2  , ht/2)
        button:setAnchorPoint(0.5,0.5)
        button:addTouchEventListener(function(sender,eventtype)
            self:TouchBtn( sender,eventtype )
        end) 
        self:addChild(button,10)
        self.mBtnTable[#self.mBtnTable+1] = button
    end



    self:TouchBtn( self.mBtnTable[1],ccui.TouchEventType.ended )
end
function CommBtnNode:initTextBtn( ... )
    self.mBtnTable = {}
    local count = #self.detele.ImageName
    local path2 = self.detele.ImageName[2]
    local wd = nil
    local dis = 200 -- 间距
    local stw = 70*2 -- 开始和结尾的距离
    local Image9bjHt = 84
    local textSzie = 36
    local ht = self.Image9bj:getContentSize().height
    local bg =  ccui.Text:create()
          bg:setString(path2)
          bg:setFontSize(textSzie)
    wd = bg:getContentSize().width
    self.Image9bj:setContentSize((wd+dis)*count-dis + stw ,ht)


    for i = 1, count do
        local pathName = self.detele.ImageName[i]
        local button = ccui.Text:create()
        button:setTouchEnabled(true)
        button:setString(pathName)
        button.tag = i

        button:setFontSize(textSzie)
        button:setTextColor(cc.c3b(255,255,255))


        local btttonH = button:getContentSize().width
        button:setPosition((wd+dis)*(i-1)+(btttonH/2) + stw/2  , ht/2)
        button:setAnchorPoint(0.5,0.5)
        button:addTouchEventListener(function(sender,eventtype)
            self:TouchBtn( sender,eventtype )
        end) 
        self:addChild(button,10)
        self.mBtnTable[#self.mBtnTable+1] = button
    end



    self:TouchBtn( self.mBtnTable[1],ccui.TouchEventType.ended )
end


function CommBtnNode:TouchBtn( sender,eventtype )
    if eventtype == ccui.TouchEventType.ended then 
      local widthx = sender:getPositionX() 
      local heighty = sender:getPositionY() 
      self.BtnImage:setPosition(cc.p(widthx,heighty))
      if self.detele.Callfun then
        self.detele.Callfun(sender.tag)
      end
    end
end

function CommBtnNode:GteImage9bjSize(  )
  return self.Image9bj:getContentSize()
end

function CommBtnNode:GetCsbName()
    return "CommBtnNode"
end 


return CommBtnNode

