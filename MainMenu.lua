require('middleclass')
require('loveframes')
local lf = loveframes

MainMenu = class('MainMenu')

function MainMenu:initialize()
   self.frame = lf.Create('frame')
   self.frame:SetVisible(false)
   self.frame:SetName('Main menu')
   self.frame:SetSize(250, 350)
   self.frame:Center()
   self.frame:SetY(150)
   self.frame:SetDraggable(false)
   self.frame:ShowCloseButton(false)

   self:makeButton('New Game', 50)
   self:makeButton('Continue', 125)
   self:makeButton('About', 200)
   self:makeButton('Exit', 275)
end

function MainMenu:makeButton(text, y)
   local button = lf.Create('button', self.frame)
   button:SetPos(25, y)
   button:SetSize(200, 50)
   button:SetText(text)
   return button
end

function MainMenu:show()
   self.frame:SetVisible(true)
end

function MainMenu:hide()
   self.frame:SetVisible(false)
end

return MainMenu