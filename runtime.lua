json = require("rapidjson")

local UCIPinName = Controls.UCIPinName
local UCIPin = Controls.UCIPin
local TouchPanel = Controls.TouchPanel
local UCI = Controls.UCI
local UCIPage = Controls.UCIPage
local PinPadPin = Controls.PinPadPin
local PinPadDigits = Controls.PinPadDigits
local PinPadEnter = Controls.PinPadEnter
local PinPadBackspace = Controls.PinPadBackspace
local PinPadClear = Controls.PinPadClear
local AddPinName = Controls.AddPinName
local AddPinPin = Controls.AddPinPin
local AddPinSubmit = Controls.AddPinSubmit
local Status = Controls.Status

local Digits = {"1","2","3","4","5","6","7","8","9","0","*","#"}
local PinData = {}
local UCIData = {}
PollDataTimer = Timer.New()
InitTimer = Timer.New()
InitTimer:Start(5)


-- Pin Pad functions
--===========================
function ClearPinString()
  PinPadPin.String = ""
end

function Backspace()
  PinPadPin.String = string.sub(PinPadPin.String, 1, -2)
end

function SubmitPin()
  if UCIPin.String == PinPadPin.String then
    Uci.SetPage(TouchPanel.String, UCIPage.String)
    PinPadPin.String = ""
  else
    PinPadPin.String = "Incorrect Pin!"
  end
end
--===========================


-- utility functions
--===========================
function GetIndexInTable(tbl, val)
  local index={}
  for k,v in pairs(tbl) do
    index[v]=k
  end
  return index[val]
end

function checkIfTblValExists(tbl, val)
  for i, v in pairs(tbl) do 
    if v == val then 
      return true
    end
  end
  return false
end
--===========================


-- Pin functions
--===========================
function SetPin()
  local tblLength = #UCIPinName.Choices
  if checkIfTblValExists(UCIPinName.Choices, UCIPinName.String) == true then
    local index = GetIndexInTable(UCIPinName.Choices, UCIPinName.String)
    UCIPin.String = PinData[index].pin
    else 
      UCIPinName.String = UCIPinName.Choices[tblLength]
      UCIPin.String = PinData[tblLength].pin
  end
end

function AddPin()
  if AddPinName.String ~= "" and AddPinPin.String ~= "" then
    postPinData(json.encode({{
      name = AddPinName.String,
      pin =  AddPinPin.String
    }}))
    else 
      Status.String = "Please Enter a Pin Name and Pin"
  end
end

function SetPinNamesTbl(data)
  local PinNamesTbl = {}
  for i, v in ipairs(data) do 
    table.insert(PinNamesTbl, v.name)
  end
  UCIPinName.Choices = PinNamesTbl
end
--===========================


-- Status functions
--===========================
function ClearStatus()
  Status.String = ""
end

function SetStatus(code, d)
  if code == math.floor(204) then 
    Status.String = "Successfully Added Pin!"
    else  
      Status.String = json.decode(d).code..": "..json.decode(d).message
  end
end
--===========================


-- Touch Panel and UCI Info functions
--===========================
function getTouchPanels()
  local myInventory = Design.GetInventory()
  local touchScreens = {}
  for i, v in ipairs(myInventory) do 
    if v.Type == "Touch Screen" or v.Model == "UCI Viewer" then 
      table.insert(touchScreens, v.Name)
    end
  end
  TouchPanel.Choices = touchScreens 
end

function SetUCINamesTbl(data)
  local UCINamesTbl = {}
  for i, v in ipairs(data) do 
    table.insert(UCINamesTbl, v.Name)
  end
  UCI.Choices = UCINamesTbl
end

function SetUCIPage(data)
  local uciPageNames = {}
  for i, uci in ipairs(data) do
    if UCI.String == uci.Name then
      for j, page in ipairs(uci.Pages) do
        table.insert(uciPageNames, page.Name)
      end
    end
  end
  UCIPage.Choices = uciPageNames
end
--===========================


-- HTTP functions
--===========================
function handlePinGet(tbl, code, d, e) 
  PinData = json.decode(d).items
  SetPinNamesTbl(PinData)
  SetPin()
end

function getPinData() 
  HttpClient.Download { 
    Url = "http://127.0.0.1/api/v0/systems/1/ucis/pins", 
    Headers = { ["Content-Type"] = "application/json" } , 
    Timeout = 5, 
    EventHandler = handlePinGet
  }
end

function handlePinPost(tbl, code, d, e)
  print(string.format("Response Code for POST: %i\t\tErrors: %s\rData: %s",code, e or "None", d))
  SetStatus(code, d)
  getPinData()
end

function postPinData(data) 
  AddPinName.String = ""
  AddPinPin.String = ""
  HttpClient.Upload { 
    Url = "http://127.0.0.1/api/v0/systems/1/ucis/pins", 
    Method = "POST",
    Headers = { 
      ["Content-Type"] = "application/json"
    }, 
    Timeout = 5, 
    Data = data,
    EventHandler = handlePinPost
  }
end

function handleUCIGet(tbl, code, d, e)
  UCIData = json.decode(d).Ucis
  SetUCINamesTbl(UCIData)
  SetUCIPage(UCIData)
end

function getUCIData() 
  HttpClient.Download { 
    Url = "http://127.0.0.1/designs/current_design/ucis.json", 
    Headers = { ["Content-Type"] = "application/json" } , 
    Timeout = 5, 
    EventHandler = handleUCIGet
  }
end
--===========================


-- Initializing function
--===========================
function Init()
  getPinData() 
  getTouchPanels()
  getUCIData()
  ClearStatus()
  PollDataTimer:Start(1)
  InitTimer:Stop()
end
--===========================


--Event Handlers
--================================
PinPadClear.EventHandler = ClearPinString
PinPadBackspace.EventHandler = Backspace
PinPadEnter.EventHandler = SubmitPin
UCIPinName.EventHandler = SetPin
AddPinSubmit.EventHandler = AddPin
UCI.EventHandler = function()
  getUCIData()
  UCIPage.String = ""
end

for i, dig in ipairs(Digits) do
  PinPadDigits[i].EventHandler = function()
    if PinPadPin.String == "Incorrect Pin!" then
      PinPadPin.String = ''
      PinPadPin.String = PinPadPin.String..dig
    else
      PinPadPin.String = PinPadPin.String..dig
    end
  end
end

PollDataTimer.EventHandler = getPinData
InitTimer.EventHandler = Init
--===========================
