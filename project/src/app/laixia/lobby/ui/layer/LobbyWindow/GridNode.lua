--[[
********************************************************
    @date:       2018-3-14
    @author:     zl
    @version:    1.0
    @describe:   网络布局
********************************************************
]]

local GridNode = class("GridNode", function()
    return display.newNode()
end)

--[[
可用参数有：
-   column 每一页的列数，默认为1
-   row 每一页的行数，默认为1
-   columnSpace 列之间的间隙，默认为0
-   rowSpace 行之间的间隙，默认为0
-   padding 值为一个表，页面控件四周的间隙
    -   left 左边间隙
    -   right 右边间隙
    -   top 上边间隙
    -   bottom 下边间隙
-   bCirc 页面是否循环,默认为false
-   imgDotNormal 点默认图标
-   imgDotSelected 点选中图标
-   indicatorBarHeight
]]
function GridNode:ctor(param)
    self.m_param = param
    self.m_imgDot = {
        off = param.imgDotNormal,
        off_pressed = param.imgDotNormal,
        off_disabled = param.imgDotNormal,
        on = param.imgDotSelected,
        on_pressed = param.imgDotSelected,
        on_disabled = param.imgDotSelected,    
    }
    param.viewRect = {x=0,y=0,width=param.contentSize.width,height=param.contentSize.height}
    param.indicatorBarHeight = (param.indicatorBarHeight and {param.indicatorBarHeight} or {0})[1]
    if param.imgDotNormal and param.imgDotSelected then
        param.indicatorBarHeight = ((param.indicatorBarHeight == 0) and 20 or param.indicatorBarHeight)
        self.m_dotBar = cc.ui.UICheckBoxButtonGroup.new(display.LEFT_TO_RIGHT)
            :setButtonsLayoutMargin(0, 0 , 0, 0)
            :align(display.BOTTOM_CENTER, 260, 0)
            :addTo(self)
        self.m_dotBar:setVisible(false)
        param.viewRect.height = param.viewRect.height - param.indicatorBarHeight;
    end

    self.m_pageView = cc.ui.UIPageView.new(param)
        :onTouch(handler(self, self._touchListener))
        :align(display.BOTTOM_CENTER, param.viewRect.width / 2, param.indicatorBarHeight)
        :addTo(self)
    self.m_pageView:setContentSize(cc.size(param.viewRect.width, param.viewRect.height))
    self:setContentSize(param.contentSize)
end

-- public --

--[[
    监听事件绑定
    @param listener onListener(event)
        @event 是一个表
        event.name:
            "pageChange"        翻页
            "clicked"           点击
                event.item      点击的条目
                event.itemIdx   点击的索引
]]
function GridNode:onTouch_Lobby(listener)
    self.m_eventListener = listener
    return self
end

--[[
    生成一个元素
]]
function GridNode:newItem()
    return self.m_pageView:newItem()
end

--[[
    添加一个元素由newItem生成的元素
]]
function GridNode:addItem(item)
    local oldPageCount = self.m_pageView:getPageCount()
    local newPageCount = self.m_pageView:addItem(item):getPageCount()
    if oldPageCount < newPageCount then
        self:_addDot()
    end
end

--[[
    移除一个元素
]]
function GridNode:removeItem(item)
    local oldPageCount = self.m_pageView:getPageCount()
    local newPageCount = self.m_pageView:removeItem():getPageCount()
    if oldPageCount > newPageCount then
        self:_removeDot()
    end
end

--[[
    移除所有元素
]]
function GridNode:removeAllItem()
    local oldPageCount = self.m_pageView:getPageCount()
    local newPageCount = self.m_pageView:removeAllItems():getPageCount()
    if oldPageCount > newPageCount and self.m_dotBar then
        for i=1,self.m_dotBar:getButtonsCount() do self:_removeDot() end
    end
end

--[[
    加载页面
    调用完所有addItem后调用
]]
function GridNode:reload(pageIdx)
    self.m_pageView:reload(pageIdx)
    pageIdx = (pageIdx and {pageIdx} or {1})[1]
    if self.m_dotBar and self.m_dotBar:getButtonAtIndex(pageIdx) then
        self.m_dotBar:getButtonAtIndex(pageIdx):setButtonSelected(true)
    end
end

--[[   
    取得当前页面索引
]]
function GridNode:getCurPageIdx()
    return self.m_pageView:getCurPageIdx()
end

-- private --
function GridNode:_touchListener(event)
    if event.name == "pageChange" and self.m_dotBar then
        print("GridNode:_touchListener" .. event.pageIdx)
        self.m_dotBar:getButtonAtIndex(event.pageIdx):setButtonSelected(true)
    end

    if self.m_eventListener ~= nil then
        self.m_eventListener(event)
    end
end

function GridNode:_addDot()
    if self.m_dotBar then
        self.m_dotBar:addButton(cc.ui.UICheckBoxButton.new(self.m_imgDot)
            :setButtonEnabled(false)
            :align(display.BOTTOM_CENTER))    
        local w,h = self.m_dotBar:getLayoutSize()
        self.m_dotBar:align(display.BOTTOM_CENTER, (self.m_param.contentSize.width - w) / 2, 0)
        if self.m_dotBar:getButtonsCount() > 1 then
            self.m_dotBar:setVisible(true)
        end
    end
end

function GridNode:_removeDot()
    if self.m_dotBar == nil then return end
    local n = self.m_dotBar:getButtonsCount()
    if n <= 0 then return end

    self.m_dotBar:removeButtonAtIndex(n)

    if self.m_dotBar:getButtonsCount() < 2 then
        self.m_dotBar:setVisible(false)
    end
end

return GridNode