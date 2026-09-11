local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local WEB_URL = "https://michel-script-key-system.pages.dev" 
local KEY_FILE = "MichelKey_V5.txt"
local EXPIRE_TIME = 7 * 3600 -- 7 Jam (25.200 Detik)

-- Parent UI Safe
local function GetSafeParent()
    local success, result = pcall(function() return CoreGui end)
    if success and result and typeof(result) == "Instance" then
        return CoreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui", 5)
end

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
    loadstring(game:HttpGet('https://raw.githubusercontent.com/MichelLyJow/MichelScriptv2/refs/heads/main/script.lua'))()
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
