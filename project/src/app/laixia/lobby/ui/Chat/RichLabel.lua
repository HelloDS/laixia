-- 富文本的实现
-- dp
-- 2016/7/5
-- 富文本实现，可以插入图片，文字，表情等，以后可扩展为语音

--[[
--测试富文本
local label = RichLabel:create(cc.size(400,120),5);
-- label:refresh({
--     {txtType = 1;   content = "恭喜玩家";       r = 255, g = 255, b = 255},
--     {txtType = 1;   content = "天下第一主";     r = 240, g = 221, b = 1},
--     {txtType = 1;   content = "在";             r = 255, g = 255, b = 255},
--     {txtType = 1;   content = "赢三张";         r = 255, g = 0,   b = 80},
--     {txtType = 1;   content = "中获得";         r = 255, g = 255, b = 255},
--     {txtType = 1;   content = "1000000";        r = 228, g = 59,  b = 239},
--     {txtType = 1;   content = "金币";           r = 255, g = 255, b = 255},
--     });
label:setFontSize(26);
label:setString("$[恭喜玩家]$$[c=FFEE01,天下第一主]$$[在]$$[c=FFEEDD,赢三张]$$[中获得]$$[c=22EE1D,1000000]$$[金币]$");
label:setPosition(cc.p(200,200));
self._img_bg:addChild(label:getRootNode());
]]

local TxtType = {
    typeTTF		= 1;	-- 系统字，可以设颜色，大小
    typeImg		= 2;   	-- 图片
-- 等等，后续可扩展
}

local RichLabel = class("RichLabel");

-- 注意size是label显示的最大范围
function RichLabel:create( size,vSpace )
    return RichLabel.new(size,vSpace);
end

-- 构造。参数分别为 绘制大小 和 行间距
function RichLabel:ctor( size,vSpace)
    self._curPosX   	= 0;								-- 当前绘制到的位置x坐标
    self._curPosY 		= size.height;						-- 当前绘制到的y坐标
    self._maxSize 		= cc.size(size.width,size.height);
    self._fixedSize		= cc.size(0,0);						-- 这个用于重新设定根节点大小
    self._vSpace 		= vSpace or 10;						-- 行间距
    self._rootNode  	= display:newLayer();--cc.LayerColor:create(cc.c4b(255,255,90,200));
    self._startFormat 	= "$[";								-- 各个标记,一个文本的格式开始
    self._endFormat		= "]$";
    self._startColor 	= "c=";								-- 开始设置颜色
    self._startFontSize = "f=";								-- 开始设置字体大小
    self._fontSize 		= 20;								-- 默认字体大小
    self._labels 		= {};								-- 存放所有label
    self._rootNode:setContentSize(size.width, size.height);
    self._rootNode:ignoreAnchorPointForPosition(true);
    -- RichLabel.__index   = self._rootNode;
    return self._rootNode;
end

-- 设置默认字体大小
function RichLabel:setFontSize( fontSize )
    self._fontSize = fontSize;
end

-- 设置位置
function RichLabel:setPosition( ... )
    self._rootNode:setPosition(...);
end

-- 设置运动轨迹
function RichLabel:runAction( action )
    self._rootNode:runAction(action);
end

-- 设置锚点
function RichLabel:setAnchorPoint( pos )
    self._rootNode:setAnchorPoint(pos);
end

function RichLabel:getContentSize( ... )
    return self._rootNode:getContentSize();
end

--设置字符串 格式 $[c=FFFFFF,f=21,玩家]$$[c=FFEEDD,f=34,在]$...
function RichLabel:setString( str )
    local index 		= 1;
    local txtArray 		= {};
    local txtItem 		= {txtType = 1;content = "";r = 255;g = 255; b =255}
    local isInFormat 	= false; 	-- 是否已经在解析字符串格式里面
    local isInColor 	= false;	-- 是否已经在设置字体颜色
    local isInFontSize 	= false; 	-- 是否已经在设置文字大小
    local newItem 		= nil;
    local contentBegin 	= index;
    while(index <= string.len(str)) do
        local subStr 	= string.sub(str,index,index + 1); 	-- 先取两个字符，看看是不是标记符
        if subStr == self._startFormat then 		-- 一对新的字符串格式标签
            isInFormat = true;
            index = index + 2;
            newItem = clone(txtItem);
            contentBegin = index;

        elseif subStr == self._endFormat then 		-- 一对新标签的结束
            isInFormat = false;
            newItem.content = string.sub(str,contentBegin,index - 1);
            table.insert(txtArray,newItem);
            newItem = nil;
            index = index + 2;

        elseif subStr == self._startColor then      -- 颜色开始
            isInColor = true;
            local colorStr = string.sub(str,index + 2,index + 8);
            newItem.r,newItem.g,newItem.b = self:castToColor(colorStr);
            index = index + 9;
            isInColor = false;
            if index > contentBegin then
                contentBegin = index;
            end

        elseif subStr == self._startFontSize then 		--字体开始
            isInColor = true;
            local endPos = string.find(str,",",index + 2);
            local fStr 	 = string.sub(str,index + 3,endPos - (index + 3));
            newItem.fontSize = fstr;
            index = endPos + 1;
            isInColor = false;
            if index > contentBegin then
                contentBegin = index;
            end

        else
            index = index + 1;
        end
    end
    -- 如果字符串不合法，就直接显示该字符串
    if #txtArray == 0 then
        txtItem.content = str;
        table.insert(txtArray,txtItem);
    end

    self:refresh(txtArray);
end

-- 获取根节点
function RichLabel:getRootNode( ... )
    return self._rootNode;
end

-- 刷新内容,args = {{txtType = 1;content = "";r = 25;g = 30; b =13;fontSize = 20},{txtType = 2; content = "ui/face.png"}}
function RichLabel:refresh( args )
    self._curPosX = 0;
    self._curPosY = self._maxSize.height;
    self._rootNode:removeAllChildren();
    for i,v in ipairs(args) do
        self:_dealOneTxt(v);
    end
    -- 重置大小和位置
    self._rootNode:setContentSize(self._fixedSize);
    for i,v in ipairs(self._rootNode:getChildren()) do
        local x,y = v:getPosition();
        v:setPositionY(y + self._fixedSize.height - self._maxSize.height);
    end
    self._rootNode:setPosition(cc.p(self._rootNode:getPosition()))
end

-- 私有函数，外部不要调用；txt = {txtType = 1;content = "";r = 25;g = 30; b =13}
function RichLabel:_dealOneTxt( txt )
    if not txt or not txt.txtType or not txt.content or txt.content == "" then 	-- 格式出错，返回
        return;
    end
    if txt.txtType == TxtType.typeTTF then		-- 系统字
        local strs = self:_splitTxt(txt.content,self._maxSize.width,self._curPosX,txt.fontSize);
        for i,v in ipairs(strs) do
            local label = cc.LabelTTF:create(v, "Arial", txt.fontSize or self._fontSize);
            local color = txt.r and cc.c3b(txt.r,txt.g,txt.b) or cc.c3b(255,255,255);
            label:setVerticalAlignment(1);
            label:setHorizontalAlignment(1);
            label:setAnchorPoint(cc.p(0,0));
            label:setColor(color);
            local posY  = self._curPosY - label:getContentSize().height - self._vSpace;
            if self._curPosX + label:getContentSize().width > self._maxSize.width then
                self._curPosX = 0;
                self._curPosY = self._curPosY - label:getContentSize().height - self._vSpace;
                posY = self._curPosY - label:getContentSize().height - self._vSpace;
                self._fixedSize.width = self._maxSize.width;
            end
            label:setPosition(cc.p(self._curPosX,posY));
            if self._fixedSize.width < self._curPosX + label:getContentSize().width then
                self._fixedSize.width = self._curPosX + label:getContentSize().width
            end
            local y = self._maxSize.height - posY;
            if self._fixedSize.height < y then
                self._fixedSize.height = y;
            end
            self._curPosX = self._curPosX + label:getContentSize().width;
            self._rootNode:addChild(label);
        end
    elseif txt.txtType == TxtType.typeImg then 	-- 图片，先不加了，抽空补齐
    end

end

-- 判断字符串能不能写成特定label放到根节点上，返回子字符串
function RichLabel:_splitTxt( strContent,limitW,curX,fontSize)
    local strIndex 	= string.len(strContent);
    local strCon 	= clone(strContent);
    local strs 		= {};
    local currentR  = 1;
    local fSize 	= fontSize or self._fontSize;
    local label 	= cc.LabelTTF:create("", "Arial", fSize);
    local curX2		= curX;
    while(strIndex > 0) do
        local str 	= string.sub(strCon,1,strIndex);
        label:setString(str);
        if label:getContentSize().width + curX2 > limitW then
            strIndex = strIndex - 1;
            if strIndex == 0 then -- 表示这一行一个字也放不下了
                table.insert(strs,"");
                curX2 = 0;
                currentR = currentR + 1;
                strIndex = string.len(strCon) or 0;
            end
        else
            table.insert(strs,str);
            strCon 	 = string.sub(strCon,strIndex + 1,-1);
            strIndex = string.len(strCon) or 0;
            curX2    = curX2 + label:getContentSize().width;
            if curX2 + fSize > limitW then -- 这一行已经写满了，再也不能放得下一个字，换行
                curX2 = 0;
            end
            currentR = currentR + 1;
        end
    end
    return strs;
end

-- 十六进制的颜色值转换成十进制的颜色值ffffff -> 255,255,255
function RichLabel:castToColor(color0x)
    local str   = tostring(color0x);
    local r     = string.sub(str,1,2);
    local g     = string.sub(str,3,4);
    local b     = string.sub(str,5,6);
    r = string.format("%d","0x"..r);
    g = string.format("%d","0x"..g);
    b = string.format("%d","0x"..b);
    return r,g,b;
end

return RichLabel;