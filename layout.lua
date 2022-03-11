local CurrentPage = PageNames[props["page_index"].Value]
local pinPadChars = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"}
local pinPadPos = {{86,140},{145,140},{204,140},{86,181},{145,181},{204,181},{86,223},{145,223},{204,223},{86,264},{145,264},{204,264}}

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
  table.insert(graphics,{Type = "Text", Text = "Username:", Position = {203,9}, Size = {59,16}, FontSize = 9,HTextAlign = "Left"})
  table.insert(graphics,{Type = "Text", Text = "Password:", Position = {203,25}, Size = {59,16}, FontSize = 9,HTextAlign = "Left"})
  table.insert(graphics,{Type = "Header",Text = "Pin Creation",HTextAlign = "Center",Font = "Roboto",FontSize = 16,Position = {0,230},Size = {348,16}})

  layout["UCIPinName"] = {PrettyName = "Setup~UCI Pin Name", Style = "ComboBox", Position = {15,86}, Size = {148,28}, FontSize = 14}
  layout["TouchPanel"] = {PrettyName = "Setup~Touch Panel", Style = "ComboBox", Position = {186,86}, Size = {148,28}, FontSize = 14}
  layout["UCIPin"] = {PrettyName = "Setup~UCI Pin", Style = "Text", IsReadyOnly = true, Position = {15,137}, Size = {148,28}, Color={194,194,194}, FontSize = 14}
  layout["UCI"] = {PrettyName = "Setup~UCI", Style = "ComboBox", Position = {186,137}, Size = {148,28}, FontSize = 14}
  layout["UCIPage"] = {PrettyName = "Setup~UCI Page", Style = "ComboBox", Position = {186,188}, Size = {148,28}, FontSize = 14}
  layout["AddPinName"] = {PrettyName = "Add Pin~Name", Style = "Text", Position = {15,276}, Size = {148,28}, FontSize = 14}
  layout["AddPinPin"] = {PrettyName = "Add Pin~Pin", Style = "Text", Position = {186,276}, Size = {148,28}, FontSize = 14}
  layout["AddPinSubmit"] = {PrettyName = "Add Pin~Submit", Style = "Button", Position = {15,311}, Size = {319,29}, Color = {255,255,255}, UnlinkOffColor = true, OffColor = {124,124,124}}
  layout["Status"] = {PrettyName = "Status", Style = "Text", IsReadyOnly = true, Position = {15,358}, Size = {319,30}, Color={194,194,194}, FontSize = 14}
  layout["CoreUsername"] =  {PrettyName = "Credentials~Username", Style = "Text", Position = {262,9}, Size = {78,16}, FontSize = 9}
  layout["CorePassword"] =  {PrettyName = "Credentials~Password", Style = "Text", Position = {262,25}, Size = {78,16}, FontSize = 9}

elseif CurrentPage == "Pin Pad" then
  layout["PinPadBackspace"] = {PrettyName = "Pin Pad~Backspace", Style = "Button", Position = {223,71}, Size = {38,26}, Color = {255,255,255}, UnlinkOffColor = true, OffColor = {124,124,124}}
  layout["PinPadClear"] = {PrettyName = "Pin Pad~Clear", Style = "Button", Position = {261,71}, Size = {38,26}, Color = {255,255,255}, UnlinkOffColor = true, OffColor = {124,124,124}}
  layout["PinPadPin"] = {PrettyName = "Pin Pad~Pin", Style = "Text", Position = {50,100}, Size = {249,26}, FontSize = 14}
  layout["PinPadEnter"] = {PrettyName = "Pin Pad~Enter", Style = "Button", Legend = "Enter", Position = {86,305}, Size = {176,38}, Color = {255,255,255}, UnlinkOffColor = true, OffColor = {124,124,124}, FontSize = 14}
  for i, v in ipairs(pinPadChars) do
    layout["PinPadDigits "..i] = {PrettyName = "Pin Pad~"..v, Style = "Button", Legend = v, Position = pinPadPos[i], Size = {58,40}, Color = {255,255,255}, UnlinkOffColor = true, OffColor = {124,124,124}, FontSize = 14}
  end
end

