



local GameSettlementLayer = class("GameSettlementLayer", xzmj.ui.BaseDialog)
function GameSettlementLayer:ctor( delete )
    GameSettlementLayer.super.ctor(self)

    self:InjectView("Panel_Node")
    self:InjectView("Button_Close")
    self:InjectView("Button_HuanDuiShou")
    self:InjectView("Panel_5")
    self:InjectView("Image_1_Copy_Copy")    
    self.mModel = xzmj.Model.TaskLayerModel

    self:setCanceledOnTouchOutside(true)
    self:OnClick(self.Button_Close, function()
            self:dismiss()
    end,{["isScale"] = false, ["hasAudio"] = false})


    self:OnClick(self.Button_HuanDuiShou,function ()
        print("Button_HuanDuiShou====")        
    end,{["isScale"] = false, ["hasAudio"] = false})

    self:SetData()
    self:init()
end

function GameSettlementLayer:GetCsbName()
    return "GameSettlementLayer"
end 

function GameSettlementLayer:init()
    self:initTableView()
    self:ShowSP()

end


function GameSettlementLayer:SetData( data )
    self.mData = {
                [1] = { ["SettlementOptype"] = 1,["fanshu"] = 1,["addcoinnum"] = 20,},
                [2] = { ["SettlementOptype"] = 2,["fanshu"] = 1,["addcoinnum"] = 30,},
                [3] = { ["SettlementOptype"] = 3,["fanshu"] = 1,["addcoinnum"] = 40,}   
        }


end



function GameSettlementLayer:initTableView()

    local size = self.Image_1_Copy_Copy:getContentSize()
    size.height = size.height - 8
    self.mTableview = cc.TableView:create(size)
    self.mTableview:setDirection(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.mTableview:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
    self.mTableview:setPosition(0,0)
    self.mTableview:setAnchorPoint(0,0)

    self.mTableview:ignoreAnchorPointForPosition(false)
    self.Image_1_Copy_Copy:addChild(self.mTableview,1)
    self.mTableview:setDelegate()
    self.roomIdx = 1

    local function numberOfCellsInTableView(table)
        return #self.mData
    end

    local function tableCellTouched(table,cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 30,280
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = xzmj.layer.GameSettlementNode.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:UpdateDate( self.mData[idx +1 ]  )
        return cell
    end

    self.mTableview:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.mTableview:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.mTableview:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.mTableview:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.mTableview:reloadData()
    
end


--[[
    显示手牌
]]--
function GameSettlementLayer:ShowSP(  )

    self.mMySPValTb = {1,2,3,4,5,6,7,8,9,10,11,12,15}
    local datatblen = #self.mMySPValTb
    local poy = 500
    local pox = 290
    local scale = 0.6
    local jianju = 90 * scale
    for i = 1 ,datatblen do
        local menutips = xzmj.layer.MahjongNodeSXDP.new()
        menutips:setScale(0.95)
        menutips:UpdateDate( self.mMySPValTb[i] )
        menutips:setPosition( pox + (i-1) * jianju, poy)
        menutips:setScale( scale )
        self.Panel_5:addChild(menutips)
    end
end

return GameSettlementLayer

