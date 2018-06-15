





--[[
    使用实例
    local delete = 
    {
        [1] = {path = "games/xzmj/common/icon/biaoqian_1.png",text = "我有10个"},
        [2] = {path = "games/xzmj/common/icon/biaoqian_2.png",text = "我有11个"},
        [3] = {path = "games/xzmj/common/icon/biaoqian_3.png",text = "我有258个"},
        [4] = {path = "games/xzmj/common/icon/biaoqian_4.png",text = "我有300个"}

    }
    
    local node = xzmj.Layout.CreateItemNode( delete )
    node:setPosition(200,200)
    self:addChild( node )
]]--




local ItemNode = class("ItemNode", xzmj.ui.BaseView)

function ItemNode:ctor( delete )
    ItemNode.super.ctor(self)
    self.delete = delete
    self:InjectView("Image")
    self:InjectView("Text")
    self:UpdateDate()
end

function ItemNode:GetCsbName()
    return "ItemNode"
end 

function ItemNode:UpdateDate()
    self.Image:loadTexture(self.delete.path)
    self.Text:setString(self.delete.text)

end 

--[[
  delete = 
  {
    [1] = { "path" = "1.png",text = "200个" },
  }
  ]]--
function ItemNode.CreateItemNode( delete )
    local node = cc.Node:create()
    local jianju = 120
    local count = #delete
    if count <=0 then
      print("create_ItemNode-----error----count<=0")
      return
    end   

    for i = 1,count do
      local de = ItemNode.new( delete[i] )
      de:setAnchorPoint(0,0)
      de:setPositionX((i-1)*jianju)
      node:addChild( de )
    end
    return node
end

return ItemNode

