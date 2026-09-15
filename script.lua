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
    Title = "Michel Script",
    Icon = "rbxthumb://type=Asset&id=102030546943731&w=420&h=420",
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
    Misc = Window:Tab({ Title = "Misc", Icon = "wrench" })
}

local WEB_URL = "https://michel-script-key-system.pages.dev"
local KEY_FILE = "MichelKey_V99.txt"
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
    Placeholder = "Paste key here...",
    Callback = function(Value)
        currentInputKey = Value
    end
})

-- APPLY KEY BUTTON
Tabs.Misc:Button({
    Title = "Apply Key",
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
end)        if success and type(result) == "table" then
            return result
        end
    end
    return nil
end

-- Validasi Key & Expiry (7 Jam)
local function IsKeyValid(keyData)
    if not keyData or type(keyData) ~= "table" then return false end
    local key = keyData.key or ""
    local timestamp = keyData.time or 0
    
    local isFormatValid = string.sub(key, 1, 7) == "MICHEL-" and #key == 15
    local isNotExpired = (os.time() - timestamp) < EXPIRE_TIME
    
    return isFormatValid and isNotExpired
end

-- LOAD SCRIPT UTAMA
local function LoadMainScript()
    print("Key Valid! Memuat Michel Script...")
    
    local parent = GetSafeParent()
    if parent and parent:FindFirstChild("MichelKeySystem") then
        parent.MichelKeySystem:Destroy()
    end
    
    -- LOADSTRING SCRIPT UTAMA
    loadstring(game:HttpGet('https://raw.githubusercontent.com/MichelLyJow/LibraryScriptMichel/refs/heads/main/script.lua'))()
end

-- AUTO EXECUTE JIKA KEY TERSIMPAN MASIH AKTIF (BELUM 7 JAM)
local savedData = GetSavedKeyData()
if IsKeyValid(savedData) then
    LoadMainScript()
    return
end

-- HAPUS UI LAMA
local TargetParent = GetSafeParent()
if TargetParent and TargetParent:FindFirstChild("MichelKeySystem") then
    TargetParent.MichelKeySystem:Destroy()
end

-- ================= GUI (CLEAN WHITE THEME) =================
local KeySystem = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")

local SubmitBtn = Instance.new("TextButton")
local CheckBtn = Instance.new("TextButton")
local GetKeyBtn = Instance.new("TextButton")

local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local InputCorner = Instance.new("UICorner")
local InputStroke = Instance.new("UIStroke")

local SubmitCorner = Instance.new("UICorner")
local CheckCorner = Instance.new("UICorner")
local GetKeyCorner = Instance.new("UICorner")
local GetKeyStroke = Instance.new("UIStroke")

KeySystem.Name = "MichelKeySystem"
KeySystem.ResetOnSpawn = false
KeySystem.Parent = TargetParent

-- Main Frame (Serba Putih Bersih)
Main.Name = "Main"
Main.Parent = KeySystem
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.Position = UDim2.new(0.5, -140, 0.5, -110)
Main.Size = UDim2.new(0, 280, 0, 220)
Main.Active = true
Main.Draggable = true

MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

MainStroke.Parent = Main
MainStroke.Color = Color3.fromRGB(200, 200, 200)
MainStroke.Thickness = 1

-- Title
Title.Name = "Title"
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "MICHEL KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(15, 15, 15)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1

-- Input TextBox (Background Abu-abu Sangat Muda)
KeyInput.Name = "KeyInput"
KeyInput.Parent = Main
KeyInput.Position = UDim2.new(0.08, 0, 0.20, 0)
KeyInput.Size = UDim2.new(0.84, 0, 0, 32)
KeyInput.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
KeyInput.PlaceholderText = "Paste key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(15, 15, 15)
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.SourceSans

InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = KeyInput

InputStroke.Parent = KeyInput
InputStroke.Color = Color3.fromRGB(220, 220, 220)
InputStroke.Thickness = 1

-- Submit Button (Hitam Solid)
SubmitBtn.Name = "SubmitBtn"
SubmitBtn.Parent = Main
SubmitBtn.Position = UDim2.new(0.08, 0, 0.40, 0)
SubmitBtn.Size = UDim2.new(0.84, 0, 0, 30)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SubmitBtn.Text = "SUBMIT"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 13
SubmitBtn.Font = Enum.Font.SourceSansBold

SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitBtn

-- Check Button (Abu-abu Gelap Soft)
CheckBtn.Name = "CheckBtn"
CheckBtn.Parent = Main
CheckBtn.Position = UDim2.new(0.08, 0, 0.58, 0)
CheckBtn.Size = UDim2.new(0.84, 0, 0, 30)
CheckBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
CheckBtn.Text = "CHECK KEY"
CheckBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
CheckBtn.TextSize = 13
CheckBtn.Font = Enum.Font.SourceSansBold

CheckCorner.CornerRadius = UDim.new(0, 6)
CheckCorner.Parent = CheckBtn

-- Get Key Button (Putih Border)
GetKeyBtn.Name = "GetKeyBtn"
GetKeyBtn.Parent = Main
GetKeyBtn.Position = UDim2.new(0.08, 0, 0.76, 0)
GetKeyBtn.Size = UDim2.new(0.84, 0, 0, 30)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.TextColor3 = Color3.fromRGB(50, 50, 50)
GetKeyBtn.TextSize = 12
GetKeyBtn.Font = Enum.Font.SourceSansBold

GetKeyCorner.CornerRadius = UDim.new(0, 6)
GetKeyCorner.Parent = GetKeyBtn

GetKeyStroke.Parent = GetKeyBtn
GetKeyStroke.Color = Color3.fromRGB(200, 200, 200)
GetKeyStroke.Thickness = 1

-- ================= LOGIKA ACTION =================

local function VerifyKeyInput(inputKey)
    if inputKey == "" then
        SubmitBtn.Text = "Empty Key!"
        task.wait(1.5)
        SubmitBtn.Text = "SUBMIT"
        return
    end

    SubmitBtn.Text = "Verifikasi..."
    
    if string.sub(inputKey, 1, 7) == "MICHEL-" and #inputKey == 15 then
        SubmitBtn.Text = "CORRECT KEY!"
        SaveKey(inputKey)
        task.wait(0.8)
        LoadMainScript()
    else
        SubmitBtn.Text = "KEY EXPIRED / INVALID!"
        task.wait(1.5)
        SubmitBtn.Text = "SUBMIT"
    end
end

-- Submit Manual
SubmitBtn.MouseButton1Click:Connect(function()
    VerifyKeyInput(KeyInput.Text)
end)

-- Check Status Key Tersimpan
CheckBtn.MouseButton1Click:Connect(function()
    local data = GetSavedKeyData()
    if IsKeyValid(data) then
        CheckBtn.Text = "KEY ACTIVE!"
        task.wait(0.8)
        LoadMainScript()
    else
        CheckBtn.Text = "KEY EXPIRED!"
        task.wait(1.5)
        CheckBtn.Text = "CHECK KEY"
    end
end)

-- Copy Link Web
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(WEB_URL)
        GetKeyBtn.Text = "Link Copied!"
        task.wait(1.5)
        GetKeyBtn.Text = "GET KEY"
    end
end)

-- AUTO DETECT CLIPBOARD KEY
task.spawn(function()
    if getclipboard then
        local clip = getclipboard()
        if type(clip) == "string" and string.sub(clip, 1, 7) == "MICHEL-" and #clip == 15 then
            KeyInput.Text = clip
            VerifyKeyInput(clip)
        end
    end
end)
