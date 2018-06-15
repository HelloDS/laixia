-- 玩家聊天
-- 玩家聊天是以node的方式加入到指定节点上的，外部调用只需要
-- ChatMain:create(),即可

local  ChatMain = class("ChatMain");


-- 根节点，座位编号
function ChatMain:ctor(parentNode,pos,gameId,optChatBtnType)
    if not parentNode then
        return;
    end
    self._rootNode          = ccs.GUIReader:getInstance():widgetFromBinaryFile("ui/");             -- 根节点

    self._startTime         = 0;                    -- 计时器起点
    self._chatType          = optChatBtnType or 1;  -- 聊天按钮类型
    self:init();
end

function ChatMain:init( ... )
    self._startTime = os.time();
    self._rootNode:schedule(handler(self,self.onTick),1/30);    -- 启动计时
end

function ChatMain:show( ... )
-- body
end

-- 设置聊天历史弹窗是否可见
function ChatMain:setChatHisVisible( ... )
-- body
end

-- 设置外部聊天框是否可见
function ChatMain:setOutChatVisible( isVisible )
-- body
end

-- 计时器
function ChatMain:onTick(dt)
    local currentTime = os.time();
    --获取本地时间
    local time = currentTime - self._startTime;--累积时间(秒)
    if  time >= 1 then
        self._startTime = currentTime;
        self:update();
    end
end

function ChatMain:destroy( ... )
    self._rootNode:stopAllActions();
    MonitorSystem:removeEventListenersByTag(self._downLoadTag);    -- 特殊处理
end

return ChatMain;