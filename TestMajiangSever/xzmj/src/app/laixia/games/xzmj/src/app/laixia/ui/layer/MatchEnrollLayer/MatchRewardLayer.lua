

--[[
    比赛奖励界面
]]--

local MatchRewardLayer = class("MatchRewardLayer", import("...BaseView"))
function MatchRewardLayer:ctor(...)
    MatchRewardLayer.super.ctor(self)

    self:InjectView("TablePanel")

    
    self:init()
end
function MatchRewardLayer:GetCsbName()
    return "MatchRewardLayer"
end
function MatchRewardLayer:init()
    local size = self.TablePanel:getContentSize()
    size.width = size.width - 15
    size.height = size.height - 15
    self.mTableview = cc.TableView:create(size)
    self.mTableview:setDirection(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.mTableview:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.mTableview:setPosition(0,0)
    self.mTableview:setAnchorPoint(0,0)

    self.mTableview:ignoreAnchorPointForPosition(false)
    self.TablePanel:addChild(self.mTableview,1)
    self.mTableview:setDelegate()
    self.roomIdx = 1

    local function numberOfCellsInTableView(table)
        return 100
    end

    local function tableCellTouched(table,cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 85,1060
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = xzmj.layer.MatchRewardNode.new()
            item:setPositionX(item:getPositionX()+5)
            cell:addChild(item)
            cell.item = item
            -- cell:setAnchorPoint(0.5,0.5)
        end
        --cell.item:render(idx + 1)
        return cell
    end

    self.mTableview:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.mTableview:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.mTableview:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.mTableview:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.mTableview:reloadData()
    
end



function MatchRewardLayer:onShow(data) 

end 


return MatchRewardLayer

