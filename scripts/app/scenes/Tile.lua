local colors = {"#FFFFCC99" , "#FFFFCC66" , "#FFFFCC33" , "#FFFFCC00" , "#FFFF9966" , "#FFFF9933" , "#FFFF9900" , "#FFFF6666" , "#FFFF6633" , "#FFFF6600" , "#FFFF3300"}
local Tile = class("Tile", function ()
	return display.newNode()
end)

function Tile:ctor()
	self.locked = false  --单词操作只能合体一次
	self.data = 2
	self.rect = display.newRect(100, 100)
	self.rect:setPosition(ccp(50, 50))
	self.rect:setFill(true)
	self.lable = ui.newTTFLabel({font = "黑体" , size = 50 , align = ui.TEXT_ALIGN_CENTER , valign = ui.TEXT_VALIGN_CENTER})
	self.lable:setPosition(50 , 50)
	self:redraw()
	self:addChild(self.rect)
	self:addChild(self.lable)
end

function Tile:setData(data)
	self.data = data
	self:redraw()
end

function Tile:redraw()
	local color = hexToColor(colors[math.log(self.data , 2)])
	self.lable:setString(self.data)
	self.rect:setLineColor(ccc4FFromccc4B(color))
	self.rect:setScale(0.6)
	if self.data == 2048 then
		self.lable:setFontSize(40)
	else
		self.lable:setFontSize(50)
	end
	transition.scaleTo(self.rect, {scale = 1 , time = 0.2 , easing = "bounceOut"})
end

function effect(rect)
	transition.scaleTo(rect, {scacle = 1 , time = 0.3 , easing = "bounce"})
end

return Tile