-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Configuration
local WEB_URL = "https://michel-script-key-system.pages.dev"
local KEY_FILE = "MichelKey_V878.txt"
local EXPIRE_TIME = 7 * 3600 -- 7 Hours

-- Storage Functions
local function SaveKey(key)
    if writefile then
        pcall(function()
            local data = { key = key, time = os.time() }
            writefile(KEY_FILE, HttpService:JSONEncode(data))
        end)
    end
end

local function GetSavedKeyData()
    if isfile and readfile and isfile(KEY_FILE) then
        local success, result = pcall(function()
            return HttpService:JSONEncode(readfile(KEY_FILE))
        end)
        if success and type(result) == "table" then return result end
    end
    return nil
end

local function IsKeyValid(keyData)
    if not keyData or type(keyData) ~= "table" then return false end
    local key = keyData.key or ""
    local timestamp = keyData.time or 0
    return string.sub(key, 1, 7) == "MICHEL-" and #key == 15 and (os.time() - timestamp) < EXPIRE_TIME
end

local function LoadMainScript()
    task.wait(0.5)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/MichelLyJow/LibraryScriptMichel/refs/heads/main/script.lua'))()
end

-- Auto Load If Key Is Valid
local savedData = GetSavedKeyData()
if IsKeyValid(savedData) then
    LoadMainScript()
    return
end

-- Remove Existing UI If Found
if CoreGui:FindFirstChild("CustomKeySystemUI") then
    CoreGui.CustomKeySystemUI:Destroy()
end

-- Palette & Liquid Glass Colors
local COL_GLASS_BG    = Color3.fromRGB(255, 255, 255)
local COL_GLASS_STROKE= Color3.fromRGB(255, 255, 255)
local COL_SKY         = Color3.fromRGB(56, 189, 248)
local COL_TEXT        = Color3.fromRGB(245, 247, 250)
local COL_SUBTEXT     = Color3.fromRGB(160, 170, 190)
local COL_SUCCESS     = Color3.fromRGB(74, 222, 128)
local COL_ERROR       = Color3.fromRGB(248, 113, 113)

-- UI Building
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomKeySystemUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

if syn and syn.protect_gui then syn.protect_gui(ScreenGui)
elseif protectgui then protectgui(ScreenGui) end

local function corner(inst, radius)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, radius or 12)
    return c
end

local function stroke(inst, color, thickness, transparency)
    local s = Instance.new("UIStroke", inst)
    s.Color = color or COL_GLASS_STROKE
    s.Thickness = thickness or 1.2
    s.Transparency = transparency or 0.6
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function glassGradient(inst, transStart, transEnd)
    local g = Instance.new("UIGradient", inst)
    g.Color = ColorSequence.new(COL_GLASS_BG)
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, transStart or 0.75),
        NumberSequenceKeypoint.new(1, transEnd or 0.9)
    })
    g.Rotation = 45
    return g
end

-- Dummy Selection to remove default click selection border
local DummySelection = Instance.new("Frame")
DummySelection.BackgroundTransparency = 1
DummySelection.Size = UDim2.new(0, 0, 0, 0)

---------------------------------------------------------
-- Anti-Spam Notification Logic
---------------------------------------------------------
local isNotifShowing = false

local function ShowNotification(message, kind)
    if isNotifShowing then return end
    isNotifShowing = true

    local color = COL_SKY
    if kind == "error" then color = COL_ERROR
    elseif kind == "success" then color = COL_SUCCESS end

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 290, 0, 44)
    NotifFrame.Position = UDim2.new(0.5, -145, 0.08, -10)
    NotifFrame.BackgroundColor3 = COL_GLASS_BG
    NotifFrame.BackgroundTransparency = 0.3
    NotifFrame.ZIndex = 50
    NotifFrame.Parent = ScreenGui
    corner(NotifFrame, 10)
    stroke(NotifFrame, color, 1.2, 0.3)
    glassGradient(NotifFrame, 0.3, 0.5)

    local bar = Instance.new("Frame", NotifFrame)
    bar.Size = UDim2.new(0, 4, 1, -12)
    bar.Position = UDim2.new(0, 6, 0, 6)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    corner(bar, 4)

    local NotifText = Instance.new("TextLabel", NotifFrame)
    NotifText.Size = UDim2.new(1, -30, 1, 0)
    NotifText.Position = UDim2.new(0, 20, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = message
    NotifText.TextColor3 = COL_TEXT
    NotifText.Font = Enum.Font.GothamMedium
    NotifText.TextSize = 13
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.ZIndex = 51

    -- Animasi Masuk
    TweenService:Create(NotifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -145, 0.08, 0)
    }):Play()

    -- Durasi tampil
    task.delay(2.2, function()
        local fadeOut = TweenService:Create(NotifFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -145, 0.08, -10),
            BackgroundTransparency = 1
        })
        TweenService:Create(NotifText, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        fadeOut:Play()
        fadeOut.Completed:Wait()
        NotifFrame:Destroy()
        isNotifShowing = false
    end)
end

-- Rounded Shadow Holder
local ShadowHolder = Instance.new("Frame")
ShadowHolder.Name = "Shadow"
ShadowHolder.Size = UDim2.new(0, 420, 0, 270)
ShadowHolder.Position = UDim2.new(0.5, -210, 0.5, -131)
ShadowHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ShadowHolder.BackgroundTransparency = 0.6
ShadowHolder.BorderSizePixel = 0
ShadowHolder.ZIndex = 1
ShadowHolder.Parent = ScreenGui
corner(ShadowHolder, 18)

-- Main Panel (Liquid Glass Effect)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 270)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui
corner(MainFrame, 16)
stroke(MainFrame, COL_GLASS_STROKE, 1.2, 0.65)
glassGradient(MainFrame, 0.2, 0.45)

-- Dragging Logic
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = newPos
        ShadowHolder.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset + 4)
    end
end)

-- Header Section
local HeaderFrame = Instance.new("Frame", MainFrame)
HeaderFrame.Size = UDim2.new(1, -32, 0, 50)
HeaderFrame.Position = UDim2.new(0, 16, 0, 16)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.ZIndex = 3

local TitleLabel = Instance.new("TextLabel", HeaderFrame)
TitleLabel.Size = UDim2.new(1, -34, 0, 22)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "KEY SYSTEM"
TitleLabel.TextColor3 = COL_TEXT
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.ZIndex = 3

-- Subtitle dengan RichText & Verified Badge (Centang Biru)
local SubtitleLabel = Instance.new("TextLabel", HeaderFrame)
SubtitleLabel.Size = UDim2.new(1, -34, 0, 18)
SubtitleLabel.Position = UDim2.new(0, 0, 0, 24)
SubtitleLabel.RichText = true
SubtitleLabel.Text = "MichelLyJow " .. utf8.char(0xE000) .. " · Enter your active license key"
SubtitleLabel.TextColor3 = COL_SUBTEXT
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextSize = 12
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.ZIndex = 3

-- Minimize Button (Gunakan Hyphen "-" standar agar terbaca jelas)
local MinimizeBtn = Instance.new("TextButton", HeaderFrame)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -28, 0, 0)
MinimizeBtn.BackgroundColor3 = COL_GLASS_BG
MinimizeBtn.BackgroundTransparency = 0.8
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = COL_SUBTEXT
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 22
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.SelectionImageObject = DummySelection
MinimizeBtn.ZIndex = 3
corner(MinimizeBtn, 8)
stroke(MinimizeBtn, COL_GLASS_STROKE, 1, 0.7)

MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = COL_GLASS_BG, BackgroundTransparency = 0.5, TextColor3 = COL_TEXT}):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = COL_GLASS_BG, BackgroundTransparency = 0.8, TextColor3 = COL_SUBTEXT}):Play()
end)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShadowHolder.Visible = false
end)

-- License Input Box
local InputLabel = Instance.new("TextLabel", MainFrame)
InputLabel.Size = UDim2.new(1, -32, 0, 16)
InputLabel.Position = UDim2.new(0, 16, 0, 78)
InputLabel.Text = "LICENSE KEY"
InputLabel.TextColor3 = COL_SKY
InputLabel.Font = Enum.Font.GothamBold
InputLabel.TextSize = 10
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.BackgroundTransparency = 1
InputLabel.ZIndex = 3

local InputFrame = Instance.new("Frame", MainFrame)
InputFrame.Size = UDim2.new(1, -32, 0, 44)
InputFrame.Position = UDim2.new(0, 16, 0, 98)
InputFrame.BackgroundColor3 = COL_GLASS_BG
InputFrame.BackgroundTransparency = 0.85
InputFrame.ZIndex = 3
corner(InputFrame, 10)
glassGradient(InputFrame, 0.8, 0.9)
local InputStroke = stroke(InputFrame, COL_GLASS_STROKE, 1, 0.7)

local KeyInput = Instance.new("TextBox", InputFrame)
KeyInput.Size = UDim2.new(1, -24, 1, 0)
KeyInput.Position = UDim2.new(0, 12, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.PlaceholderText = "MICHEL-XXXXXXXX"
KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 130, 155)
KeyInput.Text = ""
KeyInput.TextColor3 = COL_TEXT
KeyInput.Font = Enum.Font.Code
KeyInput.TextSize = 14
KeyInput.ClearTextOnFocus = false
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.SelectionImageObject = DummySelection
KeyInput.ZIndex = 3

KeyInput.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.15), {Color = COL_SKY, Transparency = 0.2}):Play()
end)
KeyInput.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.15), {Color = COL_GLASS_STROKE, Transparency = 0.7}):Play()
end)

-- Action Buttons
local ApplyBtn = Instance.new("TextButton", MainFrame)
ApplyBtn.Size = UDim2.new(1, -32, 0, 42)
ApplyBtn.Position = UDim2.new(0, 16, 0, 156)
ApplyBtn.BackgroundColor3 = COL_SKY
ApplyBtn.BackgroundTransparency = 0.2
ApplyBtn.Text = "Submit Key"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 14
ApplyBtn.AutoButtonColor = false
ApplyBtn.SelectionImageObject = DummySelection
ApplyBtn.ZIndex = 3
corner(ApplyBtn, 10)
stroke(ApplyBtn, COL_GLASS_STROKE, 1.2, 0.4)

ApplyBtn.MouseEnter:Connect(function()
    TweenService:Create(ApplyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.05, Size = UDim2.new(1, -30, 0, 42), Position = UDim2.new(0, 15, 0, 156)}):Play()
end)
ApplyBtn.MouseLeave:Connect(function()
    TweenService:Create(ApplyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, Size = UDim2.new(1, -32, 0, 42), Position = UDim2.new(0, 16, 0, 156)}):Play()
end)

local GetKeyBtn = Instance.new("TextButton", MainFrame)
GetKeyBtn.Size = UDim2.new(1, -32, 0, 36)
GetKeyBtn.Position = UDim2.new(0, 16, 0, 208)
GetKeyBtn.BackgroundColor3 = COL_GLASS_BG
GetKeyBtn.BackgroundTransparency = 0.85
GetKeyBtn.Text = "Get Key Link"
GetKeyBtn.TextColor3 = COL_TEXT
GetKeyBtn.Font = Enum.Font.GothamMedium
GetKeyBtn.TextSize = 13
GetKeyBtn.AutoButtonColor = false
GetKeyBtn.SelectionImageObject = DummySelection
GetKeyBtn.ZIndex = 3
corner(GetKeyBtn, 9)
stroke(GetKeyBtn, COL_GLASS_STROKE, 1, 0.7)

GetKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.65}):Play()
end)
GetKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
end)

---------------------------------------------------------
-- TOGGLE BUTTON (Full Transparent / No Blue / No Click Box)
---------------------------------------------------------
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 20, 0.45, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxthumb://type=Asset&id=102030546943731&w=420&h=420"
ToggleBtn.ImageTransparency = 0
ToggleBtn.ClipsDescendants = true
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.AutoButtonColor = false
ToggleBtn.SelectionImageObject = DummySelection
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = ScreenGui

-- Shape: Rounded Square
corner(ToggleBtn, 14)

-- Border Neutral Glass (No Blue Accent)
local ToggleBorder = stroke(ToggleBtn, COL_GLASS_STROKE, 1.2, 0.6)

ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 56, 0, 56)}):Play()
    TweenService:Create(ToggleBorder, TweenInfo.new(0.15), {Transparency = 0.2}):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 52, 0, 52)}):Play()
    TweenService:Create(ToggleBorder, TweenInfo.new(0.15), {Transparency = 0.6}):Play()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    local newState = not MainFrame.Visible
    MainFrame.Visible = newState
    ShadowHolder.Visible = newState
end)

-- Button Functionalities
ApplyBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text

    if key == "" then
        ShowNotification("Key cannot be empty!", "error")
        TweenService:Create(InputStroke, TweenInfo.new(0.15), {Color = COL_ERROR, Transparency = 0.2}):Play()
        return
    end

    if string.sub(key, 1, 7) == "MICHEL-" and #key == 15 then
        SaveKey(key)
        TweenService:Create(InputStroke, TweenInfo.new(0.15), {Color = COL_SUCCESS, Transparency = 0.2}):Play()
        ShowNotification("Key verified, loading script...", "success")
        task.wait(1)
        ScreenGui:Destroy()
        LoadMainScript()
    else
        TweenService:Create(InputStroke, TweenInfo.new(0.15), {Color = COL_ERROR, Transparency = 0.2}):Play()
        ShowNotification("Invalid or expired key!", "error")
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(WEB_URL)
        ShowNotification("Key link copied to clipboard!", "success")
    end
end)

-- Auto Detect Clipboard Key
task.spawn(function()
    if getclipboard then
        local ok, clip = pcall(getclipboard)
        if ok and type(clip) == "string" and string.sub(clip, 1, 7) == "MICHEL-" and #clip == 15 then
            KeyInput.Text = clip
            ShowNotification("Key detected from clipboard", "success")
        end
    end
end)
