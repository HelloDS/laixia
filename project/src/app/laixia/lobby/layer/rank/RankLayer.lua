--
-- Author: Feng
-- Date: 2018-05-03 14:58:18
--
local UItools = require("common.tools.UITools")
local RankLayer = class("RankLayer" , import("common.base.BaseDialog"))
local isshow = false

function RankLayer:ctor( delete )
    if isshow == true then
        return
    end    
    RankLayer.super.ctor(self, "new_ui/RankLayer.csb")
    self.mdelete = delete
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

    self.rankType = 1 
    self:initTbview()
    self:sendRequestGoldList()
    self:init()
end

--请求金币榜
function RankLayer:sendRequestGoldList()
    local stream = laixia.Packet.new("CSRank","LXG_COUNT_RANK" )
    stream:setReqType("get")
    stream:setValue("uid",laixia.LocalPlayercfg.LaixiaPlayerID)
    stream:setValue("game_id", 1)
    stream:setValue("type", self.rankType)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        print("xxxxxxxxxx" .. event.dm_error)

        key = ""
        local function PrintTable(table , level)
          level = level or 1
          local indent = ""
          for i = 1, level do
            indent = indent.."  "
          end

          if key ~= "" then
            print(indent..key.." ".."=".." ".."{")
          else
            print(indent .. "{")
          end

          key = ""
          for k,v in pairs(table) do
             if type(v) == "table" then
                key = k
                PrintTable(v, level + 1)
             else
                local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
              print(content)  
              end
          end
          print(indent .. "}")

        end
        --PrintTable(event)

        if event.dm_error == 0 then
            print("request RankLayer Success")
            self.data = event.data.UserRankList
            --PrintTable(self.data)
            self.oneRank = event.data.PersonRank.rank
            self.mTableview:reloadData()
            self:initPersonInfo()
        else
            print("request RankLayer Faile")
        end
    end)
end

--[[
    个人中心
]]
function RankLayer:requestPersonCenterData()
    local stream =  laixia.Packet.new("person", "LXG_COUNT_INFO")
    stream:setReqType("get")
    stream:setValue("uids", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1.dm_error == 0 then
            self.isShow = true
            self:onGotoPersonCenter(data1)
            self:show()
        else
            scene:popUpTips(data1.error_msg)
            self:show()
            
        end  
    end)
end

function RankLayer:onGotoPersonCenter(packet)
    if #packet.data == 0 then
            packet.data[1] = {}
    end
    local data = packet.data[1]

    if data then
        laixia.LocalPlayercfg.LaixiaGameTotal = data.vices or 0  
        laixia.LocalPlayercfg.LaixiaBisaiNum = data.total or 0 
        laixia.LocalPlayercfg.LaixiaPlayerVictoryTimes = data.win_vices or 0
        laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes = data.runnerup or 0
        laixia.LocalPlayercfg.LaixiaPlayerRate = data.probability or 0
        laixia.LocalPlayercfg.LaixiaBisaiSecond = data.champions or 0
    else
        laixia.LocalPlayercfg.LaixiaGameTotal = 0
        laixia.LocalPlayercfg.LaixiaBisaiNum = 0
        laixia.LocalPlayercfg.LaixiaPlayerVictoryTimes = 0
        laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes = 0
        laixia.LocalPlayercfg.LaixiaPlayerRate = 0
        laixia.LocalPlayercfg.LaixiaBisaiSecond = 0
    end
    self.Text_count:setString(laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes)
end

function RankLayer:init()
    
    --self:initdata()
    self.Button_Close = _G.seekNodeByName(self.rootNode,"Button_fanhui")
    self.Button_Close:addTouchEventListener(handler(self, self.onback))

    self.Button_jinbibang = _G.seekNodeByName(self.rootNode,"Button_jinbibang")
    self.Button_jinbibang_select = _G.seekNodeByName(self.rootNode,"Button_jinbibang_select")
    self.Button_guanjunbang = _G.seekNodeByName(self.rootNode,"Button_guanjunbang")
    self.Button_guanjunbang_select = _G.seekNodeByName(self.rootNode,"Button_guanjunbang_select")
    self.Button_jinbibang_select:addTouchEventListener(handler(self, self.selectbtn))
    self.Button_guanjunbang_select:addTouchEventListener(handler(self, self.selectbtn))


    self.Text_Now = _G.seekNodeByName(self.rootNode,"Button_jinbibang_select")
    self.Image_content = _G.seekNodeByName(self.Panel_content,"Image_content")

    --个人信息
    self.Image_touxiang_bg = _G.seekNodeByName(self.rootNode, "Image_touxiang_bg")
    self.Image_touxiang_bg:setVisible(false)
    self.Image_touxiang = _G.seekNodeByName(self.rootNode, "Image_touxiang")
    self.Image_touxiang:setVisible(false)
    self.Text_rank = _G.seekNodeByName(self.rootNode, "Text_Now")
    self.Image_rank = _G.seekNodeByName(self.rootNode, "Image_rank")
    self.Image_rank:setVisible(false)
    self.Image_NoNum = _G.seekNodeByName(self.rootNode, "Image_NoNum")
    self.Image_NoNum:setVisible(false)
    self.Text_nick = _G.seekNodeByName(self.rootNode, "Text_nick")
    self.Text_count = _G.seekNodeByName(self.rootNode, "Text_count")

    self.Image_gold = _G.seekNodeByName(self.rootNode, "Image_gold")
    self.Image_gold:setVisible(false)
    self.Text_21 = _G.seekNodeByName(self.rootNode, "Text_21")
    self.Text_21:setVisible(false)

end

function RankLayer:initTbview()
    self.ListView_Ranking_List = _G.seekNodeByName(self.rootNode,"ListView_Ranking_List")
    local size = self.ListView_Ranking_List:getContentSize()
    self.mTableview = cc.TableView:create(size)
    self.mTableview:setDirection(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.mTableview:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.mTableview:setPosition(0,0)
    self.mTableview:setAnchorPoint(0,0)
    self.mTableview:ignoreAnchorPointForPosition(false)
    self.ListView_Ranking_List:addChild(self.mTableview,1)
    self.mTableview:setDelegate()

    self.mTableview:registerScriptHandler( handler(self, self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL);           --滚动时的回掉函数 
    self.mTableview:registerScriptHandler( handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX);             --列表项的尺寸  
    self.mTableview:registerScriptHandler( handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX);              --创建列表项  
    self.mTableview:registerScriptHandler( handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW); --列表项的数量
    self.mTableview:registerScriptHandler(  handler(self, self.tableCellTouched),cc.TABLECELL_TOUCHED)
   
end

function RankLayer:tableCellTouched(table)

end

--滚动时的回掉函数
function RankLayer:scrollViewDidScroll(table)  
end  

--列表项的数量
function RankLayer:numberOfCellsInTableView(table)
    return #self.data
end

function RankLayer:cellSizeForTable(table)
    return 92, 636
end

function RankLayer:tableCellAtIndex(table, idx)  
    local index = idx + 1;  
    local cell = table:dequeueCell()
    local item
    if nil == cell then
        cell = cc.TableViewCell:new()
        item = require("lobby.layer.rank.RankNode").new()
        cell:addChild(item)
        cell.item = item
        --更新每个cell的数据
        print("bbbbbbbbbbbbbb===========" .. index)
        -- cell.item:addChild(item)
    end
     cell.item:UpdateData(self.data[#self.data - index + 1],self.rankType)
    return cell 
end 

function RankLayer:UpdateTabview( ... )
    self.mTableview:reloadData()
end


--[[
    设置自己的排行榜信息   
]]--
function RankLayer:initPersonInfo()
    --只需要一个自己的排名的字段  类型2缺一个锦标赛冠军次数字段
    --
    --金币图标
    self.Image_gold = _G.seekNodeByName(self.rootNode, "Image_gold")
    self.Text_21 = _G.seekNodeByName(self.rootNode, "Text_21")
    self.Image_touxiang_bg:setVisible(true)

    --头像
    self:addHead()
    --玩家名称
    self.Text_nick:setString(laixia.LocalPlayercfg.LaixiaPlayerNickname)
    if self.rankType == 1 then
        self.Image_gold:setVisible(true)
        self.Text_21:setVisible(false)
        --金币数量
        self.Text_count:setString(laixia.LocalPlayercfg.LaixiaGoldCoin)
        self.Button_jinbibang:setVisible(true)
        self.Button_jinbibang_select:setVisible(false)
        self.Button_guanjunbang:setVisible(false)
        self.Button_guanjunbang_select:setVisible(true)
    else
        self.Image_gold:setVisible(false)
        self.Text_21:setVisible(true)
        self.Text_count:setString(laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes)
        self.Button_jinbibang:setVisible(false)
        self.Button_jinbibang_select:setVisible(true)
        self.Button_guanjunbang:setVisible(true)
        self.Button_guanjunbang_select:setVisible(false)
    end

    if 0 < tonumber(self.oneRank) and tonumber(self.oneRank) <= 3 then--图片排名
        self.Image_rank:loadTexture("new_ui/RankList/jiangpai_" .. self.oneRank .. ".png")
        self.Text_rank:setVisible(false)
        self.Image_rank:setVisible(true)
        self.Image_NoNum:setVisible(false)
    elseif 3 < tonumber(self.oneRank) and tonumber(self.oneRank) <=50 then--数字排名
        self.Text_rank:setString(self.oneRank)
        self.Text_rank:setVisible(true)
        self.Image_rank:setVisible(false)
        self.Image_NoNum:setVisible(false)
    else--暂未上榜
        print("aaaaaaaaaaaaaa")
        self.Text_rank:setVisible(false)
        self.Image_rank:setVisible(false)
        self.Image_NoNum:setVisible(true)
    end
end

function RankLayer:addHead()
    local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
    local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png"
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    if (fileExist) then
        path = localIconName
    end
    self:addHeadIcon(self.Image_touxiang_bg,path)
end

function RankLayer:addHeadIcon(head_btn,path)
    if (head_btn == nil or head_btn == "") then
        return
    end
    local templet = "images/touxiangkuang_now.png"
    UItools.addHead(head_btn, path, templet)
   
end

--[[
    跳转函数
]]--
function RankLayer:selectbtn(sender,eventType)
     _G.onTouchButton(sender,eventType)

    if eventType == ccui.TouchEventType.ended then
        if sender:getName() == "Button_jinbibang_select" then
            print("金币榜")
            if self.rankType ~= 1 then
                self.rankType = 1
                self:sendRequestGoldList()

            end
            
        elseif sender:getName() == "Button_guanjunbang_select" then 
            print("冠军榜")
            if self.rankType ~= 2 then
                self.rankType = 2
                self:sendRequestGoldList()
                self:requestPersonCenterData()
            end
        end
    end
end

function RankLayer:onClose( ... )
    laixia.LocalPlayercfg.LunBoindex = 1
end

function RankLayer:onback(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:onClose()
        self:removeFromParent()
    end
end

return RankLayer














