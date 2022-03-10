local CurrentPage = PageNames[props["page_index"].Value]

table.insert(graphics,{Type = "GroupBox", Fill = {220,220,220}, StrokeWidth = 1, Position = {0,0}, Size = {348,409}, CornerRadius = 8})
table.insert(graphics,{Type = "Text", Text = "UCI Pin Controller", Position = {15,9}, Size = {234,38}, FontSize = 22,HTextAlign = "Left", IsBold = true})

if CurrentPage == "Pin Setup" then
  table.insert(graphics,{Type = "Text", Text = "UCI Pin Name:", Position = {15,63}, Size = {148,23}, FontSize = 14,HTextAlign = "Left", IsBold = true})
  table.insert(graphics,{Type = "Text", Text = "Touch Panel:", Position = {186,63}, Size = {148,23}, FontSize = 14,HTextAlign = "Left", IsBold = true})
  table.insert(graphics,{Type = "Text", Text = "UCI Pin:", Position = {15,114}, Size = {148,23}, FontSize = 14,HTextAlign = "Left", IsBold = true})
  table.insert(graphics,{Type = "Text", Text = "UCI:", Position = {186,114}, Size = {148,23}, FontSize = 14,HTextAlign = "Left", IsBold = true})
  table.insert(graphics,{Type = "Text", Text = "UCI Page:", Position = {186,165}, Size = {148,23}, FontSize = 14,HTextAlign = "Left", IsBold = true})
  table.insert(graphics,{Type = "Text", Text = "Pin Name:", Position = {15,253}, Size = {148,23}, FontSize = 14,HTextAlign = "Left", IsBold = true})
  table.insert(graphics,{Type = "Text", Text = "Pin:", Position = {186,253}, Size = {148,23}, FontSize = 14,HTextAlign = "Left", IsBold = true})
  table.insert(graphics,{Type = "Header",Text = "Pin Creation",HTextAlign = "Center",Font = "Roboto",FontSize = 16,Position = {0,230},Size = {348,16}})

elseif CurrentPage == "Pin Pad" then

end

