--[[

    
]]--



local FriendLayer = class("FriendLayer", import("...BaseView"))

function FriendLayer:ctor(...)
    FriendLayer.super.ctor(self)
    self:InjectView("Panel_Node")
    
    self:init()
end

function FriendLayer:GetCsbName()
    return "FriendLayer"
end 

function FriendLayer:init()
    local size = self.Panel_Node:getContentSize()
    self.roomList = cc.TableView:create(size)
    self.roomList:setDirection(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.roomList:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.roomList:setPosition(0,0)
    self.roomList:setAnchorPoint(0,0)

    self.roomList:ignoreAnchorPointForPosition(false)
    self.Panel_Node:addChild(self.roomList,1)
    self.roomList:setDelegate()
    self.roomIdx = 1

    local function numberOfCellsInTableView(table)
        return 10
    end

    local function tableCellTouched(table,cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 90, 70
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = xzmj.layer.FriendItemNode.new()
            item:setPositionX(item:getPositionX()+5)
            cell:addChild(item)
            cell.item = item
            -- cell:setAnchorPoint(0.5,0.5)
        end
        --cell.item:render(idx + 1)
        return cell
    end

    self.roomList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.roomList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.roomList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.roomList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.roomList:reloadData()
    
end

return FriendLayer

