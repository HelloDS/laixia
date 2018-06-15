--
-- Author: Feng
-- Date: 2018-05-03 14:58:30
--
local UItools = require("common.tools.UITools")
local DownloaderHead = require("common.DownloaderHead")

local RankNode = class("RankNode" ,function()
    return ccui.Layout:create() 
end)

function RankNode:ctor( delete )
    self.delete = delete
    self:init()
end

function RankNode:init()
    
    local pen = ccui.Layout:create() 
    self:addChild(pen)
    local csbNode = cc.CSLoader:createNode("new_ui/RankNode.csb")
    csbNode:setAnchorPoint(0, 0)
    pen:addChild(csbNode)
    self.rootNode = csbNode

    --文字排名
    self.Text_number = _G.seekNodeByName(self.rootNode,"Text_number")
    --头像背景
    self.Image_touxiang1 = _G.seekNodeByName(self.rootNode,"Image_touxiang_bg1")
    self.icon = _G.seekNodeByName(self.rootNode,"Image_touxiang1")
    self.icon:setVisible(false)
    --图片排名
    self.Image_rank = _G.seekNodeByName(self.rootNode,"Image_rank")
    --姓名
    self.Text_name = _G.seekNodeByName(self.rootNode,"Text_name")
    --金币数
    self.Text_count_cell = _G.seekNodeByName( self.rootNode,"Text_count_cell" )

    self.Image_gold_cell = _G.seekNodeByName( self.rootNode,"Image_gold_cell" ) 
    --锦标赛冠军次数
    self.Text_jbs = _G.seekNodeByName( self.rootNode,"Text_jbs" )

end

function RankNode:UpdateData(msg,type_)
    local data = msg
    if type_ == 1 then
        self.Image_gold_cell:setVisible(true)
        self.Text_jbs:setVisible(false)
    else
        self.Image_gold_cell:setVisible(false)
        self.Text_jbs:setVisible(true)
    end

    self.Text_name:setString(data.nick)
    self.Text_count_cell:setString(data.numbers)
    if tonumber(data.rank) <= 3 then
        self.Image_rank:loadTexture("new_ui/RankList/jiangpai_" .. data.rank .. ".png")
        self.Text_number:setVisible(false)
        self.Image_rank:setVisible(true)
    else
        self.Text_number:setString(data.rank)
        self.Text_number:setVisible(true)
        self.Image_rank:setVisible(false)
    end
    --先注释掉
    self:addHead(self.Image_touxiang1,data.uid,data.portrait)

end

-----------添加头像
function RankNode:addHead(image,userid,iconPath)
    -- 默认头像图片路径
    self.rankIcon = {}
    local headIcon_new = iconPath; --微信头像要用的
    
    self.rankIcon[tostring(userid)] = self.Image_touxiang1
    local path = "images/ic_morenhead"..tostring(tonumber(userid)%10)..".png"

    local localIconName = cc.FileUtils:getInstance():getWritablePath() .. userid ..".png" --laixia.LocalPlayercfg.LaixiaPlayerID
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    if (fileExist) then
        path = localIconName
        self:addHeadIcon(self.Image_touxiang1,path)
    else
        local netIconUrl = headIcon_new
        DownloaderHead:pushTask(userid, netIconUrl,2,self)
    end
    self:addHeadIcon(self.Image_touxiang1,path)
end

function RankNode:addHeadIcon(head_btn,path)
    if (head_btn == nil or head_btn == "") then
        return
    end
    local templet = "images/touxiangkuang_now.png"
    self.Image_touxiang1:removeAllChildren()
    UItools.addHead(head_btn, path, templet)
end

function RankNode:onHeadDoSuccess(msg)
    local data = msg
    print("RankNode DownSuccess...")
    local img_path = data.savePath
    --local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. data.playerID..".png";
    local fileExist = cc.FileUtils:getInstance():isFileExist(img_path)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        -- image_rank_di:removeAllChildren()
        self.Image_touxiang1:removeAllChildren()
        print("ffffffffffffffffffff")
        self:addHeadIcon(image_rank_di,img_path)
    end  
end

return RankNode