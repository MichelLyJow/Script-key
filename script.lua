local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI:AddTheme({
    Name = "Sky",
    Accent = Color3.fromRGB(0, 191, 255),
    Background = Color3.fromRGB(12, 16, 22),
    Outline = Color3.fromRGB(0, 191, 255),
    Text = Color3.fromRGB(245, 245, 245),
    PlaceholderText = Color3.fromRGB(120, 120, 120)
})

local Window = WindUI:CreateWindow({
    Title = "Key System",
    Icon = "key-round",
    Author = "MicheLyJow",
    Folder = "ProjectHubConfig",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Sky",
    Resizable = true,
    SideBarWidth = 170,
    User = {
        Enabled = true,
        Anonymous = false
    }
})

local Tabs = {
    Misc = Window:Tab({ Title = "Misc", Icon = "key-round" })
}

local WEB_URL = "https://michel-script-key-system.pages.dev"
local KEY_FILE = "MichelKey_V88.txt"
local EXPIRE_TIME = 7 * 3600 -- 7 Jam

-- Storage Functions
local function SaveKey(key)
    if writefile then
        pcall(function()
            local data = {
                key = key,
                time = os.time()
            }
            writefile(KEY_FILE, game:GetService("HttpService"):JSONEncode(data))
        end)
    end
end

local function GetSavedKeyData()
    if isfile and readfile and isfile(KEY_FILE) then
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(KEY_FILE))
        end)
        if success and type(result) == "table" then
            return result
        end
    end
    return nil
end

local function IsKeyValid(keyData)
    if not keyData or type(keyData) ~= "table" then return false end
    local key = keyData.key or ""
    local timestamp = keyData.time or 0
    
    local isFormatValid = string.sub(key, 1, 7) == "MICHEL-" and #key == 15
    local isNotExpired = (os.time() - timestamp) < EXPIRE_TIME
    
    return isFormatValid and isNotExpired
end

local function LoadMainScript()
    WindUI:Notify({
        Title = "Key System",
        Content = "Key Valid! Memuat Script Utama...",
        Duration = 3
    })
    task.wait(1)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/MichelLyJow/LibraryScriptMichel/refs/heads/main/script.lua'))()
end

-- Check Key Tersimpan Saat Di-execute
local savedData = GetSavedKeyData()
if IsKeyValid(savedData) then
    LoadMainScript()
    return
end

local currentInputKey = ""

-- TEXTBOX FOR KEY
Tabs.Misc:Input({
    Title = "Key Input",
    Icon = "key-round",
    Placeholder = "Paste key here...",
    Callback = function(Value)
        currentInputKey = Value
    end
})

-- APPLY KEY BUTTON
Tabs.Misc:Button({
    Title = "Apply Key",
    Icon = "key-round",
    Callback = function()
        if currentInputKey == "" then
            WindUI:Notify({ Title = "Error", Content = "Key tidak boleh kosong!", Duration = 2 })
            return
        end

        if string.sub(currentInputKey, 1, 7) == "MICHEL-" and #currentInputKey == 15 then
            SaveKey(currentInputKey)
            Window:Destroy()
            LoadMainScript()
        else
            WindUI:Notify({ Title = "Error", Content = "Key Expired / Invalid!", Duration = 2 })
        end
    end
})

-- GET KEY BUTTON
Tabs.Misc:Button({
    Title = "Get Key",
    Icon = "key-round",
    Callback = function()
        if setclipboard then
            setclipboard(WEB_URL)
            WindUI:Notify({ Title = "Copied", Content = "Link disalin ke Clipboard!", Duration = 2 })
        end
    end
})

-- AUTO DETECT CLIPBOARD KEY
task.spawn(function()
    if getclipboard then
        local clip = getclipboard()
        if type(clip) == "string" and string.sub(clip, 1, 7) == "MICHEL-" and #clip == 15 then
            WindUI:Notify({ Title = "Auto Detect", Content = "Key terdeteksi dari clipboard!", Duration = 2 })
            SaveKey(clip)
            task.wait(1)
            Window:Destroy()
            LoadMainScript()
        end
    end
end)

-- FLOATING TOGGLE BUTTON
if game:GetService("CoreGui"):FindFirstChild("WindUIToggleGui") then
    game:GetService("CoreGui").WindUIToggleGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
elseif protectgui then
    protectgui(ScreenGui)
end

ScreenGui.Name = "WindUIToggleGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

ToggleBtn.Name = "ToggleButton"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.5
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Image = "rbxthumb://type=Asset&id=102030546943731&w=420&h=420"
ToggleBtn.Active = true
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    if Window and Window.Toggle then
        Window:Toggle()
    end
end)
