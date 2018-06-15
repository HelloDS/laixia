
--[[
    比赛报名界面
]]--


local MatchEnrollLayer = class("MatchEnrollLayer", import("...BaseView"))
function MatchEnrollLayer:ctor(...)
    MatchEnrollLayer.super.ctor(self)

    self:InjectView("TablePanel")
    self:InjectView("ComBtnNode")
    self:InjectView("Button_back")
    
    self:initTableView()
    self:initCommbtn()


    self:OnClick(self.Button_back, function()
        print("Button_back")
        self:dismiss()
    end,{["isScale"] = false, ["hasAudio"] = false})

end
function MatchEnrollLayer:GetCsbName()
    return "MatchEnrollLayer"
end

--初始化标题栏
function MatchEnrollLayer:initCommbtn( ... )
    --接收比赛标题数据(服务器数据)
    local MatchTitle = {"全部","常规赛","红包赛","家电大奖赛","家电大奖赛"}


    local ImageName = MatchTitle
    local delete = {Type = 2,
                    ImageName =  MatchTitle,
                    Callfun = function ( _id )
                        self:ChickCommBtn(_id )
                    end
                    }
    local layer = xzmj.layer.CommBtnNode
    self.mCommBtnNode = layer.new(delete)
    self.mCommBtnNode:setAnchorPoint(0.5,0.5)
    self.mCommBtnNode:setScale(0.76)
    local size = self.mCommBtnNode:GteImage9bjSize()
    self.mCommBtnNode:setPosition(cc.p(-size.width/2+170,-size.height/2+10))
    self.ComBtnNode:addChild( self.mCommBtnNode )
end

function MatchEnrollLayer:ChickCommBtn( _id )

end


--初始化tableview
function MatchEnrollLayer:initTableView()
    local size = self.TablePanel:getContentSize()
    --size.width = size.width - 15
    size.height = size.height - 8
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
        return 134,1100
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = xzmj.layer.MatchEnrollNode.new()
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



function MatchEnrollLayer:onShow(data) 

end 


return MatchEnrollLayer

