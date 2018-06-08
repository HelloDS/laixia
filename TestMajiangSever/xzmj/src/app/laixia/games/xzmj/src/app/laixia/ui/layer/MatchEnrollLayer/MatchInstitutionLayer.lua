

--[[
    比赛说明界面
]]--

local MatchInstitutionLayer = class("MatchInstitutionLayer", xzmj.ui.BaseDialog)
function MatchInstitutionLayer:ctor(...)
    MatchInstitutionLayer.super.ctor(self)

    self:InjectView("TablePanel")
    self:InjectView("ComBtnNode")
    self:InjectView("CloseBtn")
    self:OnClick(self.CloseBtn, function()
            self:dismiss()
    end,{["isScale"] = false, ["hasAudio"] = false})


    self:initCommbtn()
end
function MatchInstitutionLayer:GetCsbName()
    return "MatchInstitutionLayer"
end


--[[
    初始化公用按钮
]]--
function MatchInstitutionLayer:initCommbtn( ... )
    
    local path = "games/xzmj/common/txt/"
    local delete = {
                    Type = 1,
                    ImageName = {path.."bsxq_2.png",path.."bsjl_2.png",path.."bssz_2.png"},
                    Callfun = function ( _id )
                        self:ChickCommBtn(_id )
                    end
                    }
    local layer = xzmj.layer.CommBtnNode
    self.mCommBtnNode = layer.new(delete)
    self.mCommBtnNode:setAnchorPoint(0.5,0.5)
    self.mCommBtnNode:setScale(0.76)
    local size = self.mCommBtnNode:GteImage9bjSize()
    self.mCommBtnNode:setPosition(cc.p(-size.width/2+85,-size.height/2+10))
    self.ComBtnNode:addChild( self.mCommBtnNode )
end


function MatchInstitutionLayer:ChickCommBtn( _id )
    print("=============".._id)
    if _id == 1 then
        if self.mMatchDetailsLayer == nil then
            local layer = xzmj.layer.MatchDetailsLayer
            self.mMatchDetailsLayer = layer.new()
            self.mMatchDetailsLayer._id = _id
            self.mMatchDetailsLayer:setPositionX(-100)
            self.TablePanel:addChild( self.mMatchDetailsLayer )
        end
    elseif _id == 2 then
        if self.mMatchRewardLayer == nil then
            local layer = xzmj.layer.MatchRewardLayer
            self.mMatchRewardLayer = layer.new()
            self.mMatchRewardLayer:setPosition(cc.p(-101,-38))
            self.mMatchRewardLayer._id = _id
            self.TablePanel:addChild( self.mMatchRewardLayer )
        end
    elseif _id == 3 then
        self:initTableView()
    end

    if self.mTableview then
        self.mTableview:setVisible( _id == 3 )
    end
    
    if self.mMatchRewardLayer then
        self.mMatchRewardLayer:setVisible( _id == 2 )
    end

    if self.mMatchDetailsLayer then
        self.mMatchDetailsLayer:setVisible( _id == 1 )
    end



end


function MatchInstitutionLayer:initTableView()
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
            item = xzmj.layer.MatchInstitutionNode.new()
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



function MatchInstitutionLayer:onShow(data) 

end 


return MatchInstitutionLayer

