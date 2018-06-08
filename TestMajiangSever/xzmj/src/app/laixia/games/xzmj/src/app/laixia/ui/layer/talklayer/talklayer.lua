

--[[
    游戏内聊天界面
]]--
local talklayer = class("talklayer",import("...BaseDialog"))

function talklayer:ctor(...)
    talklayer.super.ctor(self)
    self:InjectView("Panel_Node")
    self:InjectView("Image_information_1")
    self:InjectView("Image_information_2")


    self:InjectView("Button_common")
    self:InjectView("Button_face")
    self:InjectView("Button_input")
    self:InjectView("Button_close")
    self:AddWidgetEventListenerFunction(self.Button_close,handler(self, self.Button_closef) )
    self:AddWidgetEventListenerFunction(self.Button_common, handler(self, self.Button_commonf) )
    self:AddWidgetEventListenerFunction(self.Button_face, handler(self, self.Button_facef) )
    self:AddWidgetEventListenerFunction(self.Button_input, handler(self, self.Button_inputf))

    self.mModel = xzmj.Model.talklayerModel

    self:InjectView("TablePanel")
    self:SetLayoutOpacity(self.TablePanel)

    self:initTableView()
    self:setCanceledOnTouchOutside(true)
end

function talklayer:Button_closef(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    print(" --Button_closef")
    self:dismiss()
  end
end

--[[ 常用按钮 ]]
function talklayer:Button_commonf(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    print(" --Button_commonf")
        self.Image_information_2:setVisible(false)
        self.Image_information_1:setVisible(true)

  end
end

--[[ 表情按钮 ]]
function talklayer:Button_facef(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Image_information_1:setVisible(false)
        self.Image_information_2:setVisible(true)
        
        if self.mEnjoyTbView == nil then
            self:initEnjoyTableView()

        end

    end
end 
--[[ 输入按钮 ]]
function talklayer:Button_inputf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print(" --Button_inputf ")
    end
end 

function talklayer:GetCsbName()
    return "talklayer"
end 

function talklayer:initTableView()
    -- local size = self.TablePanel:getContentSize()
    self.roomList = cc.TableView:create(cc.size(338,275))
    self.roomList:setDirection(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.roomList:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.roomList:setPosition(0,25)
    self.roomList:setAnchorPoint(0,0)

    self.roomList:ignoreAnchorPointForPosition(false)
    self.Image_information_1:addChild(self.roomList,1)
    self.roomList:setDelegate()
    self.roomIdx = 1

    local function numberOfCellsInTableView(table)
        local len = #self.mModel.mDailyTextTb
        return len
    end

    local function tableCellTouched(table,cell)
        --qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
        local index = cell:getIdx() + 1
    end

    local function cellSizeForTable(tableView, idx)
        return 45, 200
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = xzmj.layer.talk_info.new()
            --item:setPositionX(item:getPositionX()+5)
            cell:addChild(item)
            cell.item = item
        end
        local data = self.mModel.mDailyTextTb
        cell.item:render(data[idx + 1])
        return cell
    end

    self.roomList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.roomList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.roomList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.roomList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.roomList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.roomList:reloadData()
    
    self.mTxtTbView = self.roomList

end


function talklayer:initEnjoyTableView()
    -- local size = self.TablePanel:getContentSize()
    self.roomList = cc.TableView:create(cc.size(338,268))
    self.roomList:setDirection(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.roomList:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.roomList:setPosition(10,25)
    self.roomList:setAnchorPoint(0,0)

    self.roomList:ignoreAnchorPointForPosition(false)
    self.Image_information_2:addChild(self.roomList,1)
    self.roomList:setDelegate()
    self.roomIdx = 1


    local function numberOfCellsInTableView(table)
        local len = self.mModel.mEnjoySum / 4
        return len
    end     

    local function tableCellTouched(table,cell)
        --qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
        local index = cell:getIdx() + 1
    end

    local function cellSizeForTable(table, idx)
        return 78, 200
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = xzmj.layer.TalkEnjoyNode.new(
            {
                ["isTouchMoved"] = function()
                    return table:isTouchMoved()
                end,
            })
            --item:setPositionX(item:getPositionX()+5)
            cell:addChild(item)
            cell.item = item
        end
        --local data = self.mModel.mDailyTextTb
        cell.item:render( idx + 1)
        return cell
    end

    self.roomList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.roomList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.roomList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.roomList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.roomList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.roomList:reloadData()
    self.mEnjoyTbView = self.roomList
    
end

return talklayer

