json = require("rapidjson")

-- Controls Aliases
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
local CoreUsername = Controls.CoreUsername
local CorePassword = Controls.CorePassword

-- Variables
local BearerToken = ""

-- Timers, tables, and constants
PollDataTimer = Timer.New()
InitTimer = Timer.New()
StatusClearTimer = Timer.New()
InitTimer:Start(5)
local Digits = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"}
local PinData = {}
local UCIData = {}

-- ***Helper functions***
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
  StatusClearTimer:Stop()
end

function SetStatus(code, d)
  if code == math.floor(204) then 
    Status.String = "Successfully Added Pin!"
    else
      if json.decode(d).code and json.decode(d).message then  
        Status.String = json.decode(d).code..": "..json.decode(d).message
      end
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

function GetUCIDataAndClear()
  getUCIData()
  UCIPage.String = ""
end
--===========================


-- HTTP functions
--===========================
function ParseResponse(tbl, code, d, e)
  if tbl['Url'] == "http://127.0.0.1/designs/current_design/ucis.json" then
    UCIData = json.decode(d).Ucis
    SetUCINamesTbl(UCIData)
    SetUCIPage(UCIData)
  elseif tbl['Url'] == "http://127.0.0.1/api/v0/systems/1/ucis/pins" then 
    if code == 401.0 then -- If Access Management is enabled and a username and password is required.
      Status.String = "Username and Password Required"
      if CorePassword.String ~= "" and CoreUsername.String ~= "" then
        Login(json.encode({
          password = CorePassword.String,
          username = CoreUsername.String
        }))
      end
    elseif code == 200.0 then -- Successful pin GET
      PinData = json.decode(d).items
      SetPinNamesTbl(PinData)
      SetPin()
    elseif code == 204.0 then -- Successful pin POST
      Status.String = "Successfully Added Pin!"
      getPinData() 
      StatusClearTimer:Start(5)
    else -- Unsuccessful pin POST
      Status.String = math.floor(code)..": "..json.decode(d).message
      StatusClearTimer:Start(5) 
    end
  elseif tbl['Url'] == "http://127.0.0.1/api/v0/logon" then
    if code == 201.0 then -- Successful login
      BearerToken = "Bearer "..json.decode(d).token
      getPinData()
      Status.String = "Successful Login!"
      StatusClearTimer:Start(5)
    elseif code == 404.0 then -- Unsuccessful login
      Status.String = "Username and Password Incorrect" 
    end
  end
end

function Login(creds) 
  HttpClient.Upload { 
    Url = "http://127.0.0.1/api/v0/logon", 
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json"}, 
    Timeout = 5, 
    Data = creds,
    EventHandler = ParseResponse
  }
end

function getPinData() 
  HttpClient.Download { 
    Url = "http://127.0.0.1/api/v0/systems/1/ucis/pins", 
    Headers = { 
      ["Content-Type"] = "application/json", 
      ["Accept"] = 'application/json',
      ["Authorization"] = BearerToken
    }, 
    Timeout = 5, 
    EventHandler = ParseResponse
  }
end

function postPinData(data) 
  AddPinName.String = ""
  AddPinPin.String = ""
  HttpClient.Upload { 
    Url = "http://127.0.0.1/api/v0/systems/1/ucis/pins", 
    Method = "POST",
    Headers = { 
      ["Content-Type"] = "application/json",
      ["Accept"] = "application/json",
      ["Authorization"] = BearerToken
    }, 
    Timeout = 5, 
    Data = data,
    EventHandler = ParseResponse
  }
end

function getUCIData() 
  HttpClient.Download { 
    Url = "http://127.0.0.1/designs/current_design/ucis.json", 
    Headers = { ["Content-Type"] = "application/json" } , 
    Timeout = 5, 
    EventHandler = ParseResponse
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
UCI.EventHandler = GetUCIDataAndClear

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
StatusClearTimer.EventHandler = ClearStatus
--===========================
