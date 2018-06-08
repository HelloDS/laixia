--
-- Author: Feng
-- Date: 2018-05-03 14:58:18
--
local sch  = require "framework.scheduler"

local ActivityLayer = class("ActivityLayer" , import("common.base.BaseDialog"))
local isshow = false

local this = ActivityLayer
function ActivityLayer:ctor( delete )
    if isshow == true then
        return
    end    
    ActivityLayer.super.ctor(self, "new_ui/ActivityLayer.csb")
    self.mdelete = delete
    self:init()
    if self.mdelete and self.mdelete >=1 then
        self:changePage( self.mdelete  )
    end

    local function onNodeEvent(event)
        if "enter" == event then
            isshow = true
        elseif "exit" == event then
            isshow = false
        end
    end
    self:registerScriptHandler(onNodeEvent)

end

function ActivityLayer:init()
    
  self.mPathArray = {
        "new_ui/activity/guanggaotu.png",
        "new_ui/activity/guanggaotu.png",
        "new_ui/activity/guanggaotu.png"
        }

    self:initdata()
    self.ListView_Acctivity_Button = _G.seekNodeByName(self.rootNode,"ListView_Acctivity_Button")
    self.Button_Close = _G.seekNodeByName(self.rootNode,"Button_Close")
    self.Button_Close:addTouchEventListener(handler(self, self.onback))
    self.PageView_content = _G.seekNodeByName(self.rootNode,"PageView_content")
    self.Panel_content = _G.seekNodeByName(self.PageView_content,"Panel_content")
    self.Image_content = _G.seekNodeByName(self.Panel_content,"Image_content")
    self.PageView_content:addEventListener(handler(self, self.onPageViewEvent))

    self.Button_com = _G.seekNodeByName(self.Panel_content,"Button_com")


    self:StarRunAtion()
end



function ActivityLayer:initdata()
  self.mAllListViewNode = {}
  self.mTitleArr = {"iphoneX活动"}
  self.mNowTag = 1
end

--[[
  判断和加载pageviews
]]--
function ActivityLayer:StarRunAtion(  )
    
    local data = laixia.LocalPlayercfg.LaixiaActivityTitleArr
    if data ~= nil then
        self.mTitleArr = data
    end

    self.ListView_Acctivity_Button:setItemsMargin(12)


    for i = 1,#self.mTitleArr do
      if self.mTitleArr[i] then
        local ActivityNode = require("lobby.layer.activity.ActivityNode").new()
        ActivityNode.tag = i
        ActivityNode:Update( self )
        ActivityNode:changeTitle(self.mTitleArr[i] )
        ActivityNode.mTitle = self.mTitleArr[i]
        ActivityNode:setContentSize(cc.size(154,50))
        self.ListView_Acctivity_Button:pushBackCustomItem(ActivityNode)    
        table.insert( self.mAllListViewNode, ActivityNode)
      end
    end


    ---- 遍历缓存的路径 找出总数
    local tbdata = laixia.LocalPlayercfg.LaixiaActivityLunBoPath
    if tbdata then
        local sum = 0
        for k,v in pairs(tbdata) do
            for k1,v1 in pairs(v) do
                sum = sum + 1
            end
        end
        ---- 下载完成的数量大于等于 缓存的总数
        if laixia.LocalPlayercfg.LaixiaActivityLunBoPathLen >= sum then
        end
        self.mPathArray = laixia.LocalPlayercfg.LaixiaActivityLunBoPath[1]
    end




    for k,v in pairs(self.mAllListViewNode) do
      if v then
        if v.tag ~= 1 then
          v:setBtnOpacity(false)
        end
      end
    end


    self:updatePageView()
    self:changePage(1)

    local function Updatefun(  )
        self.PageView_content:scrollToPage(2)
    end
    local delay = cc.DelayTime:create(3)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create( Updatefun ))
    self.PageView_content:runAction(cc.RepeatForever:create(sequence))


end

function ActivityLayer:changePage(tag)

    if tag <= 0 then
        return
    end

    if laixia.LocalPlayercfg.LaixiaActivityLunBoPath == nil then
        return
    end

    if laixia.LocalPlayercfg.LaixiaActivityLunBoPath[tag] == nil then
        return
    end

    self.mPathArray = laixia.LocalPlayercfg.LaixiaActivityLunBoPath[tag]
    if #self.mPathArray <=2 then
        for i = 1,3 do
            if self.mPathArray[i] ==  nil then
                self.mPathArray[i] = self.mPathArray[1]
            end
        end
    end 

    self.mNowTag = tag

    for k,v in pairs(self.mAllListViewNode) do
      if v then
        v:setBtnOpacity( false )
      end
    end
    for i = #self.PageView_content:getPages() -1, 0, -1 do       
        local node = self.PageView_content:getPage(i)
        self:UpdatePage( node )
    end
    self.PageView_content:scrollToPage(2)
    self.mAllListViewNode[tag]:setBtnOpacity(true)

end


--当前显示的页码(1 ~ pages)
local pageIdx = 1

function ActivityLayer:addPage(pIdx, iIdx, bClone)
 
    local newPage = nil
    if not bClone then
        newPage = self.PageView_content:getPage(0)
    else
        newPage = self.PageView_content:getPage(0):clone()
    end

    newPage:setTag(pIdx)

    self:UpdatePage( newPage )


    self.PageView_content:insertPage(newPage, iIdx)
 
end
 
function ActivityLayer:UpdatePage(  node )
    if node == nil then
        return
    end

    local adImg = node:getChildByName("Image_content")
    adImg:loadTexture(self.mPathArray[self.mNowTag])
    local Button_com = node:getChildByName("Button_com")
    local Text_1_Copy = Button_com:getChildByName("Text_1_Copy")
    Button_com:addTouchEventListener(handler(self, self.Button_comf))
    Button_com.Title = self.mTitleArr[ self.mNowTag ]
    Text_1_Copy:setString( self.mTitleArr[ self.mNowTag ] )

    local node = self.mAllListViewNode[ self.mNowTag ]
    if node.mTitle and node.mTitle == "oppo推广赛" then
        Button_com:setVisible( true )
    else
        Button_com:setVisible( false )

    end

end



--[[
    跳转函数
]]--
function ActivityLayer:Button_comf(sender,eventType)
     _G.onTouchButton(sender,eventType)

    if eventType == ccui.TouchEventType.ended then
       if sender.Title then
            print(" sender.Title=== "..sender.Title)
       end
       self:ShareWx()
    end
end

--[[
    更新view
]]--
function ActivityLayer:updatePageView()

    --删除原来的页面(第一页保留用于clone)
    for i = #self.PageView_content:getPages() - 1, 1, -1 do
        self.PageView_content:removePageAtIndex(i) 
    end
    --添加新的页面(每页显示6个)
    local pages = #self.mPathArray
 
    pageIdx = 1
 
    if 1 == pages then
        self:addPage(1, 0, false)
        self.PageView_content:scrollToPage(1)

    elseif 2 == pages then
        self:addPage(2, 0, false)
        self:addPage(1, 1, true)
        self:addPage(2, 2, true)
        self.PageView_content:scrollToPage(1)
    elseif pages >= 3 then
        self:addPage(pages, 0, false)
        self:addPage(1, 1, true)
        self:addPage(2, 2, true)
        self.PageView_content:scrollToPage(1)
    end
end

--[[
    view的注册事件
]]-- 
function ActivityLayer:onPageViewEvent(sender, eventType)
    if eventType == ccui.PageViewEventType.turning then
        local pages = #self.mPathArray
        local nextPageIdx = 0
        local curPageIndex = sender:getCurPageIndex()
        if pages >= 3 then
            if curPageIndex == 0 then
                pageIdx = pageIdx - 1
                if pageIdx <= 0 then pageIdx = pages end
 
                nextPageIdx = pageIdx - 1
                if nextPageIdx <= 0 then nextPageIdx = pages end
                sender:removePageAtIndex(2)
                self:addPage(nextPageIdx, 0, true)
                --PageView的当前页索引为0,在0的位置新插入页后原来的页面0变为1;
                --PageView自动显示为新插入的页面0,我们需要显示为页面1,所以强制滑动到1.
                sender:scrollToPage(1)
                --解决强制滑动到1后回弹效果
                sender:update(10)   
            elseif curPageIndex == 2 then
                pageIdx = pageIdx + 1
                if pageIdx > pages then pageIdx = 1 end
                nextPageIdx = pageIdx + 1
                if nextPageIdx > pages then    nextPageIdx = 1 end
                sender:removePageAtIndex(0)
                self:addPage(nextPageIdx, 2, true)
                sender:scrollToPage(1)
                -- sender:update(10)
            end
        elseif pages == 2 then
            if curPageIndex == 0 then
                nextPageIdx = 0
                if 1 == pageIdx then
                    pageIdx = 2
                    nextPageIdx = 1
                else
                    pageIdx = 1
                    nextPageIdx = 2
                end
                sender:removePageAtIndex(2)
                self:addPage(nextPageIdx, 0, true)
                --PageView的当前页索引为0,在0的位置新插入页后原来的页面0变为1;
                --PageView自动显示为新插入的页面0,我们需要显示为页面1,所以强制滑动到1.
                sender:scrollToPage(1)
                --解决强制滑动到1后回弹效果
                -- sender:update(10)   
 
            elseif curPageIndex == 2 then
                nextPageIdx = 0
                if 1 == pageIdx then
                    pageIdx = 2
                    nextPageIdx = 1
                else
                    pageIdx = 1
                    nextPageIdx = 2
                end
                sender:removePageAtIndex(0)
                self:addPage(nextPageIdx, 2, true)
            end
        end
    end
end


function ActivityLayer:onClose( ... )
    laixia.LocalPlayercfg.LunBoindex = 1
end

function ActivityLayer:onback(sender,eventType)
     _G.onTouchButton(sender,eventType)

    if eventType == ccui.TouchEventType.ended then
        self:onClose()
        self:removeFromParent()
    end
end

--[[
    分享回调
]]--
function ActivityLayer:ShareWx( ... )
    local a  = 1
    if a > 0 then  -- 暂时屏蔽
        return
    end
    --分享链接
    local title = "请关注公众号"..laixia.LocalPlayercfg.LaixiaWechatServiceNum
    local Url = "http://wx.laixia.com/download"
    local description ="来下斗地主免费赢大奖，时时赢微信红包！"
    local flag = 0 -- 0 分享好友  1 分享好友圈
    if device.platform == "android" then
        local luaj = require "cocos.cocos2d.luaj"
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "wxShare"
        local javaParams = {title,Url ,description,flag } -- 参数是4个string 带一个int 返回值为void
        local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
        local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        return value
    elseif device.platform == "ios" then--苹果包
        local args = {title = title, Url =Url,description=description,flag = flag }
        local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendLinkContent", args);
    end
end




--=====================================下面是网络下载逻辑=================--


function ActivityLayer.GetUrlAndDown(  )
  
    local stream =  laixia.Packet.new("mail", "LXG_ACTIVE_COLLECTIONS")
    stream:setReqType("get")
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event)
        local data1 = event
        if data1.dm_error == 0 then
            this.SetDownData( data1 )
        else    
            print("ActivityLayer=====后端返回数据错误====")
        end 
    end)
end


function ActivityLayer.SetDownData( data )
    if data == nil then
        return
    end
    laixia.LocalPlayercfg.LaixiaActivityLunBoPath = {}
    laixia.LocalPlayercfg.LaixiaActivityTitleArr = {}
    laixia.LocalPlayercfg.LaixiaActivityLunBoPathLen = 0
    local index = 0
    local active_index = 0
    for k,v in pairs(data.data) do
        if v and v.title then
          index = index + 1 
          laixia.LocalPlayercfg.LaixiaActivityLunBoPath[index] = {}
          laixia.LocalPlayercfg.LaixiaActivityTitleArr[index] = v.title
          local sum = 1
          for i = 1,5 do
              local url = v["poll_url"..i]
              local urlcopy = url
              if url and string.sub(urlcopy, 1,4 ) == "http"  then
                  local imgName = this.SplitLastStr(urlcopy, "/")
                  local savePath = cc.FileUtils:getInstance():getWritablePath() .. imgName
                  laixia.LocalPlayercfg.LaixiaActivityLunBoPath[index][sum] = savePath
                  this.DownImage( url )
                  sum = sum + 1
              end
          end
        end
        if v and v.active_url and string.sub(v.active_url, 1,4 ) == "http" then
            active_index = active_index + 1
            local url = v.active_url
            local imgName = this.SplitLastStr(url, "/")
            local savePath = cc.FileUtils:getInstance():getWritablePath() .. imgName
            local data = laixia.LocalPlayercfg.LaixiaLunBoPath
            laixia.LocalPlayercfg.LaixiaLunBoPath[active_index] = savePath
            this.DownImage( url )                    
        end
    end
    

end




function ActivityLayer.DownImage( url )
    if url == nil or url == "null" then
      return
    end
    local request = network.createHTTPRequest(function(event)
          this.onResponsePost(event,url)
    end, url, "GET")

    request:setTimeout(5)
    request:start()
end
--切出最后一个
function ActivityLayer.SplitLastStr(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    local ret = nil
    while true do  
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
            ret = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            nSplitArray[nSplitIndex] = ret
            break  
       end
       
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end  
    return ret  
end
--下载事件回调
function ActivityLayer.onResponsePost(event,url)
    local request = event.request
    
    if event.name == "failed" then
        return
    end
    if event.name ~= "completed" then 
        return 
    end
    local code = request:getResponseStatusCode()
    if (code ~= 200) then 
        print("error------code------"..code)
        return 
    elseif code == 200 then
      -- 下载成功
        laixia.LocalPlayercfg.LaixiaActivityLunBoPathLen  = laixia.LocalPlayercfg.LaixiaActivityLunBoPathLen + 1
    
    end
    local data = request:getResponseData()
    local size = #data
    local imgName = this.SplitLastStr(url, "/")
    local savePath = cc.FileUtils:getInstance():getWritablePath() .. imgName
    io.writefile(savePath, data)
end




return ActivityLayer














