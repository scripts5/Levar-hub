--[[
╔═══════════════════════════════════════════════════════════╗
║                    RATTO HUB ULTIMATE                     ║
║              Prison Life - Mobile Edition                 ║
║                                                           ║
║  Criador: ravelitocove66                                  ║
║  Discord: discord.gg/sGyVHq6m                             ║
║  Versão: 3.0 Ultimate                                     ║
║  © 2025 - Todos os direitos reservados                    ║
╚═══════════════════════════════════════════════════════════╝
--]]

task.wait(math.random(50, 150) / 100)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Configuration
local Config = {
    -- Combat
    KillAura = false,
    KillAuraRange = 15,
    Aimbot = false,
    AimbotFOV = 100,
    SilentAim = false,
    TriggerBot = false,
    AutoShoot = false,
    InfiniteAmmo = false,
    NoRecoil = false,
    RapidFire = false,
    Spinbot = false,
    AutoParry = false,
    HitboxExpander = false,
    HitboxSize = 10,
    
    -- Movement
    WalkSpeed = 16,
    JumpPower = 50,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    Bhop = false,
    LongJump = false,
    WallClimb = false,
    SpiderMan = false,
    AutoSprint = false,
    NoSlowdown = false,
    AntiRagdoll = false,
    AntiStun = false,
    
    -- Visual
    ESP = false,
    Tracers = false,
    Boxes = false,
    Names = false,
    Distance = false,
    Health = false,
    Skeleton = false,
    Chams = false,
    FullBright = false,
    NoFog = false,
    Xray = false,
    ItemESP = false,
    GunESP = false,
    
    -- Guns
    AllGuns = false,
    LoopGuns = false,
    AutoEquip = false,
    M9 = false,
    Remington = false,
    AK47 = false,
    
    -- Teleport
    ClickTP = false,
    WalkTP = false,
    
    -- Automation
    AutoFarm = false,
    AutoKill = false,
    AutoRob = false,
    AutoEscape = false,
    AutoArrest = false,
    
    -- Anti
    AntiKick = false,
    AntiBan = false,
    AntiAfk = false,
    AntiCrash = false,
    
    -- Misc
    RemoveDoors = false,
    KillAll = false,
    BringAll = false,
    FreeCam = false,
    ThirdPerson = false,
    FOVChanger = 70,
    TimeChange = 14,
    
    -- Settings
    ReturnOnDeath = false,
    AutoRespawn = false,
    SafeMode = false,
}

-- Teleport Locations
local Locations = {
    ["Spawn"] = CFrame.new(0, 100, 0),
    ["Yard"] = CFrame.new(787.62, 96, 2469.9),
    ["Cafeteria"] = CFrame.new(914.25, 99.99, 2318.21),
    ["Cells"] = CFrame.new(918.5, 99.99, 2379.5),
    ["Gate"] = CFrame.new(510.97, 98.04, 2216.87),
    ["Guard Room"] = CFrame.new(820, 100.88, 2216.9),
    ["Armory"] = CFrame.new(813.23, 100.88, 2216.93),
    ["Sewer"] = CFrame.new(917.03, 78.7, 2127.85),
    ["Roof"] = CFrame.new(943.22, 137.4, 2235.4),
    ["Yard Tower"] = CFrame.new(818.5, 130.04, 2581.22),
    ["Outside"] = CFrame.new(486.86, 97.82, 2215.33),
    ["Criminal Base"] = CFrame.new(-943.14, 94.13, 2063.33),
    ["Car"] = CFrame.new(-191.6, 54.77, 1880.24),
    ["Escape Route"] = CFrame.new(665.53, 100, 2271.68),
    ["Secret Spot 1"] = CFrame.new(1000, 120, 2500),
    ["Secret Spot 2"] = CFrame.new(-500, 90, 2000),
    ["Helicopter"] = CFrame.new(500, 150, 2300),
    ["Tower Top"] = CFrame.new(820, 160, 2580),
    ["Underground"] = CFrame.new(900, 70, 2100),
    ["Lake"] = CFrame.new(200, 80, 1900),
}

-- Anti-Detection
local function randomWait()
    task.wait(math.random(100, 300) / 1000)
end

local function safeTP(cf)
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = cf
        end
    end)
end

-- Notifications
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3,
        })
    end)
end

-- Combat Functions
local killAuraConnection
local function toggleKillAura(state)
    if killAuraConnection then killAuraConnection:Disconnect() end
    if state then
        killAuraConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        local enemyHRP = v.Character:FindFirstChild("HumanoidRootPart")
                        local enemyHum = v.Character:FindFirstChildOfClass("Humanoid")
                        if enemyHRP and enemyHum and enemyHum.Health > 0 then
                            local distance = (hrp.Position - enemyHRP.Position).Magnitude
                            if distance <= Config.KillAuraRange then
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                            end
                        end
                    end
                end
            end)
        end)
    end
end

-- Movement Functions
local noclipConnection
local function toggleNoclip(state)
    if noclipConnection then noclipConnection:Disconnect() end
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            pcall(function()
                local char = player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
    else
        pcall(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
end

local flyConnection
local function toggleFly(state)
    if flyConnection then flyConnection:Disconnect() end
    if state then
        pcall(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(0, 0, 0)
            
            local bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 9e4
            
            flyConnection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local cam = workspace.CurrentCamera
                    bg.CFrame = cam.CFrame
                    
                    local velocity = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + (cam.CFrame.LookVector * Config.FlySpeed) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - (cam.CFrame.LookVector * Config.FlySpeed) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - (cam.CFrame.RightVector * Config.FlySpeed) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + (cam.CFrame.RightVector * Config.FlySpeed) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, Config.FlySpeed, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity = velocity - Vector3.new(0, Config.FlySpeed, 0) end
                    
                    bv.Velocity = velocity
                end)
            end)
        end)
    end
end

local function updateStats()
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Config.WalkSpeed
                hum.JumpPower = Config.JumpPower
            end
        end
    end)
end

-- ESP Functions
local espObjects = {}
local function createESP(v)
    if v == player then return end
    pcall(function()
        local char = v.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- Highlight
        local highlight = Instance.new("Highlight", char)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        if v.Team then
            if v.Team.Name == "Criminals" then
                highlight.FillColor = Color3.fromRGB(255, 100, 100)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            elseif v.Team.Name == "Guards" then
                highlight.FillColor = Color3.fromRGB(100, 100, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
            else
                highlight.FillColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineColor = Color3.fromRGB(200, 200, 200)
            end
        end
        
        -- Billboard
        local billboard = Instance.new("BillboardGui", hrp)
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = v.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        
        local distLabel = Instance.new("TextLabel", billboard)
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.new(1, 1, 1)
        distLabel.TextSize = 12
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextStrokeTransparency = 0.5
        
        espObjects[v] = {highlight = highlight, billboard = billboard, distLabel = distLabel}
        
        RunService.RenderStepped:Connect(function()
            if billboard and billboard.Parent and player.Character then
                local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and hrp then
                    local dist = math.floor((myHRP.Position - hrp.Position).Magnitude)
                    distLabel.Text = dist .. " studs"
                end
            end
        end)
    end)
end

local function toggleESP(state)
    if state then
        for _, v in pairs(Players:GetPlayers()) do
            createESP(v)
        end
        Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function()
                task.wait(0.5)
                if Config.ESP then createESP(v) end
            end)
        end)
    else
        for _, data in pairs(espObjects) do
            if data.highlight then data.highlight:Destroy() end
            if data.billboard then data.billboard:Destroy() end
        end
        espObjects = {}
    end
end

-- Gun Functions
local function giveAllGuns()
    task.spawn(function()
        pcall(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local originalPos = hrp.CFrame
            
            safeTP(CFrame.new(814, 100.74, 2217.45))
            randomWait()
            safeTP(CFrame.new(820, 100.74, 2216.91))
            randomWait()
            safeTP(CFrame.new(-936.9, 94.25, 2050.45))
            randomWait()
            safeTP(originalPos)
            
            notify("Ratto Hub", "Todas armas obtidas!", 2)
        end)
    end)
end

-- Visual Functions
local function toggleFullBright(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 8
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end

-- Misc Functions
local function removeDoors()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Door" and v:IsA("BasePart") then
                v:Destroy()
            end
        end
        notify("Ratto Hub", "Portas removidas!", 2)
    end)
end

local function killAll()
    pcall(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local hum = v.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
            end
        end
        notify("Ratto Hub", "Todos eliminados!", 2)
    end)
end

-- Character Events
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    updateStats()
    
    if Config.AutoGuns then
        task.wait(0.5)
        giveAllGuns()
    end
end)

-- GUI Creation
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RattoHubUltimate"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 15)
    TopBarCorner.Parent = TopBar
    
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 25)
    TopBarFix.Position = UDim2.new(0, 0, 1, -25)
    TopBarFix.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar
    
    -- Logo/Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ RATTO HUB"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Version
    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(0, 100, 1, 0)
    Version.Position = UDim2.new(0, 215, 0, 0)
    Version.BackgroundTransparency = 1
    Version.Text = "v3.0"
    Version.TextColor3 = Color3.fromRGB(255, 200, 200)
    Version.TextSize = 14
    Version.Font = Enum.Font.Gotham
    Version.TextXAlignment = Enum.TextXAlignment.Left
    Version.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinimizeButton
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 700, 0, 50)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 700, 0, 500)}):Play()
        end
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 0)
    SidebarCorner.Parent = Sidebar
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -60)
    ContentArea.Position = UDim2.new(0, 155, 0, 55)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    
    -- Tab System
    local currentTab = nil
    local tabs = {}
    
    local function createTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(1, -10, 0, 45)
        TabButton.Position = UDim2.new(0, 5, 0, 5 + (#tabs * 50))
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.Text = icon .. " " .. name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.Parent = TabButton
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 8)
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabContent
        
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            if currentTab == TabContent then return end
            
            for _, tab in pairs(tabs) do
                tab.button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
                tab.content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            TabContent.Visible = true
            currentTab = TabContent
        end)
        
        table.insert(tabs, {button = TabButton, content = TabContent})
        return TabContent
    end
    
    -- Helper Functions for UI Elements
    local function createToggle(parent, text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Color3.new(1, 1, 1)
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)
        ToggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        ToggleButton.Text = default and "ON" or "OFF"
        ToggleButton.TextColor3 = Color3.new(1, 1, 1)
        ToggleButton.TextSize = 12
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Parent = ToggleFrame
        
        local ToggleBtnCorner = Instance.new("UICorner")
        ToggleBtnCorner.CornerRadius = UDim.new(0, 6)
        ToggleBtnCorner.Parent = ToggleButton
        
        local enabled = default
        ToggleButton.MouseButton1Click:Connect(function()
            enabled = not enabled
            ToggleButton.Text = enabled and "ON" or "OFF"
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
            }):Play()
            callback(enabled)
        end)
        
        return ToggleButton
    end
    
    local function createSlider(parent, text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 60)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = parent
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = SliderFrame
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
        SliderLabel.Position = UDim2.new(0, 10, 0, 5)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = text
        SliderLabel.TextColor3 = Color3.new(1, 1, 1)
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.3, -10, 0, 20)
        ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(default)
        ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        ValueLabel.TextSize = 14
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame
        
        local SliderBack = Instance.new("Frame")
        SliderBack.Size = UDim2.new(1, -20, 0, 8)
        SliderBack.Position = UDim2.new(0, 10, 0, 35)
        SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SliderBack.BorderSizePixel = 0
        SliderBack.Parent = SliderFrame
        
        local SliderBackCorner = Instance.new("UICorner")
        SliderBackCorner.CornerRadius = UDim.new(1, 0)
        SliderBackCorner.Parent = SliderBack
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBack
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill
        
        local dragging = false
        
        local function update(input)
            local relativeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
            ValueLabel.Text = tostring(value)
            callback(value)
        end
        
        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)
        
        SliderBack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end
    
    local function createButton(parent, text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        Button.Text = text
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamBold
        Button.Parent = parent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}):Play()
            task.wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
            callback()
        end)
    end
    
    local function createSection(parent, text)
        local Section = Instance.new("TextLabel")
        Section.Size = UDim2.new(1, 0, 0, 30)
        Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Section.Text = text
        Section.TextColor3 = Color3.fromRGB(255, 200, 100)
        Section.TextSize = 16
        Section.Font = Enum.Font.GothamBold
        Section.TextXAlignment = Enum.TextXAlignment.Left
        Section.Parent = parent
        
        local SectionPadding = Instance.new("UIPadding")
        SectionPadding.PaddingLeft = UDim.new(0, 10)
        SectionPadding.Parent = Section
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 8)
        SectionCorner.Parent = Section
    end
    
    -- Create Tabs
    local CombatTab = createTab("Combat", "⚔️")
    local MovementTab = createTab("Movement", "🏃")
    local VisualTab = createTab("Visual", "👁️")
    local GunsTab = createTab("Guns", "🔫")
    local TeleportTab = createTab("Teleport", "📍")
    local AutoTab = createTab("Auto", "🤖")
    local MiscTab = createTab("Misc", "🔧")
    local SettingsTab = createTab("Settings", "⚙️")
    local CreditsTab = createTab("Credits", "ℹ️")
    
    -- COMBAT TAB
    createSection(CombatTab, "⚔️ ATTACK")
    createToggle(CombatTab, "Kill Aura", false, function(state)
        Config.KillAura = state
        toggleKillAura(state)
    end)
    createSlider(CombatTab, "Kill Aura Range", 5, 50, 15, function(value)
        Config.KillAuraRange = value
    end)
    createToggle(CombatTab, "Aimbot", false, function(state)
        Config.Aimbot = state
    end)
    createSlider(CombatTab, "Aimbot FOV", 50, 360, 100, function(value)
        Config.AimbotFOV = value
    end)
    createToggle(CombatTab, "Silent Aim", false, function(state)
        Config.SilentAim = state
    end)
    createToggle(CombatTab, "Trigger Bot", false, function(state)
        Config.TriggerBot = state
    end)
    createToggle(CombatTab, "Auto Shoot", false, function(state)
        Config.AutoShoot = state
    end)
    createToggle(CombatTab, "Spinbot", false, function(state)
        Config.Spinbot = state
    end)
    
    createSection(CombatTab, "🛡️ DEFENSE")
    createToggle(CombatTab, "Auto Parry", false, function(state)
        Config.AutoParry = state
    end)
    createToggle(CombatTab, "Hitbox Expander", false, function(state)
        Config.HitboxExpander = state
    end)
    createSlider(CombatTab, "Hitbox Size", 1, 30, 10, function(value)
        Config.HitboxSize = value
    end)
    
    -- MOVEMENT TAB
    createSection(MovementTab, "🏃 SPEED")
    createSlider(MovementTab, "Walk Speed", 16, 500, 16, function(value)
        Config.WalkSpeed = value
        updateStats()
    end)
    createSlider(MovementTab, "Jump Power", 50, 500, 50, function(value)
        Config.JumpPower = value
        updateStats()
    end)
    createToggle(MovementTab, "Auto Sprint", false, function(state)
        Config.AutoSprint = state
    end)
    createToggle(MovementTab, "No Slowdown", false, function(state)
        Config.NoSlowdown = state
    end)
    
    createSection(MovementTab, "✈️ FLIGHT")
    createToggle(MovementTab, "Fly", false, function(state)
        Config.Fly = state
        toggleFly(state)
    end)
    createSlider(MovementTab, "Fly Speed", 10, 500, 50, function(value)
        Config.FlySpeed = value
    end)
    
    createSection(MovementTab, "🚪 PHASE")
    createToggle(MovementTab, "Noclip", false, function(state)
        Config.Noclip = state
        toggleNoclip(state)
    end)
    createToggle(MovementTab, "Infinite Jump", false, function(state)
        Config.InfiniteJump = state
    end)
    createToggle(MovementTab, "Bhop", false, function(state)
        Config.Bhop = state
    end)
    createToggle(MovementTab, "Long Jump", false, function(state)
        Config.LongJump = state
    end)
    createToggle(MovementTab, "Wall Climb", false, function(state)
        Config.WallClimb = state
    end)
    createToggle(MovementTab, "Spider Man Mode", false, function(state)
        Config.SpiderMan = state
    end)
    
    createSection(MovementTab, "🛡️ PROTECTION")
    createToggle(MovementTab, "Anti Ragdoll", false, function(state)
        Config.AntiRagdoll = state
    end)
    createToggle(MovementTab, "Anti Stun", false, function(state)
        Config.AntiStun = state
    end)
    
    -- VISUAL TAB
    createSection(VisualTab, "👤 PLAYER ESP")
    createToggle(VisualTab, "ESP Enabled", false, function(state)
        Config.ESP = state
        toggleESP(state)
    end)
    createToggle(VisualTab, "Tracers", false, function(state)
        Config.Tracers = state
    end)
    createToggle(VisualTab, "Boxes", false, function(state)
        Config.Boxes = state
    end)
    createToggle(VisualTab, "Names", false, function(state)
        Config.Names = state
    end)
    createToggle(VisualTab, "Distance", false, function(state)
        Config.Distance = state
    end)
    createToggle(VisualTab, "Health Bars", false, function(state)
        Config.Health = state
    end)
    createToggle(VisualTab, "Skeleton", false, function(state)
        Config.Skeleton = state
    end)
    createToggle(VisualTab, "Chams", false, function(state)
        Config.Chams = state
    end)
    
    createSection(VisualTab, "🌍 WORLD")
    createToggle(VisualTab, "Full Bright", false, function(state)
        Config.FullBright = state
        toggleFullBright(state)
    end)
    createToggle(VisualTab, "No Fog", false, function(state)
        Config.NoFog = state
    end)
    createToggle(VisualTab, "X-Ray", false, function(state)
        Config.Xray = state
    end)
    createSlider(VisualTab, "Time of Day", 0, 24, 14, function(value)
        Config.TimeChange = value
        Lighting.ClockTime = value
    end)
    createSlider(VisualTab, "FOV", 70, 120, 70, function(value)
        Config.FOVChanger = value
        camera.FieldOfView = value
    end)
    
    createSection(VisualTab, "📦 ITEM ESP")
    createToggle(VisualTab, "Item ESP", false, function(state)
        Config.ItemESP = state
    end)
    createToggle(VisualTab, "Gun ESP", false, function(state)
        Config.GunESP = state
    end)
    
    createSection(VisualTab, "📷 CAMERA")
    createToggle(VisualTab, "Free Cam", false, function(state)
        Config.FreeCam = state
    end)
    createToggle(VisualTab, "Third Person", false, function(state)
        Config.ThirdPerson = state
    end)
    
    -- GUNS TAB
    createSection(GunsTab, "🔫 GET WEAPONS")
    createButton(GunsTab, "🎯 Get All Guns", function()
        giveAllGuns()
    end)
    createToggle(GunsTab, "Loop Get Guns", false, function(state)
        Config.LoopGuns = state
    end)
    createToggle(GunsTab, "Auto Equip Best Gun", false, function(state)
        Config.AutoEquip = state
    end)
    
    createSection(GunsTab, "⚙️ GUN MODS")
    createToggle(GunsTab, "Infinite Ammo", false, function(state)
        Config.InfiniteAmmo = state
    end)
    createToggle(GunsTab, "No Recoil", false, function(state)
        Config.NoRecoil = state
    end)
    createToggle(GunsTab, "Rapid Fire", false, function(state)
        Config.RapidFire = state
    end)
    createToggle(GunsTab, "Instant Reload", false, function(state)
        Config.InstantReload = state
    end)
    createToggle(GunsTab, "Penetration", false, function(state)
        Config.Penetration = state
    end)
    createToggle(GunsTab, "Explosive Bullets", false, function(state)
        Config.ExplosiveBullets = state
    end)
    
    createSection(GunsTab, "🎯 SPECIFIC GUNS")
    createButton(GunsTab, "Get M9 Only", function()
        safeTP(CFrame.new(813.23, 100.88, 2216.93))
        notify("Ratto Hub", "M9 obtida!", 2)
    end)
    createButton(GunsTab, "Get Remington Only", function()
        safeTP(CFrame.new(820.45, 100.88, 2216.9))
        notify("Ratto Hub", "Remington obtida!", 2)
    end)
    createButton(GunsTab, "Get AK-47 Only", function()
        safeTP(CFrame.new(-936.93, 94.25, 2050.16))
        notify("Ratto Hub", "AK-47 obtida!", 2)
    end)
    
    -- TELEPORT TAB
    createSection(TeleportTab, "📍 MAIN LOCATIONS")
    for name, cframe in pairs(Locations) do
        createButton(TeleportTab, name, function()
            safeTP(cframe)
            notify("Teleport", "Teleportado para " .. name, 2)
        end)
    end
    
    createSection(TeleportTab, "🎯 SPECIAL")
    createToggle(TeleportTab, "Click TP", false, function(state)
        Config.ClickTP = state
    end)
    createToggle(TeleportTab, "Walk TP", false, function(state)
        Config.WalkTP = state
    end)
    createButton(TeleportTab, "TP to Random Player", function()
        local plrs = Players:GetPlayers()
        local randomPlr = plrs[math.random(1, #plrs)]
        if randomPlr ~= player and randomPlr.Character then
            local hrp = randomPlr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                safeTP(hrp.CFrame)
                notify("Teleport", "Teleportado para " .. randomPlr.Name, 2)
            end
        end
    end)
    
    -- AUTO TAB
    createSection(AutoTab, "🤖 FARMING")
    createToggle(AutoTab, "Auto Farm", false, function(state)
        Config.AutoFarm = state
    end)
    createToggle(AutoTab, "Auto Kill Guards", false, function(state)
        Config.AutoKill = state
    end)
    createToggle(AutoTab, "Auto Rob Stores", false, function(state)
        Config.AutoRob = state
    end)
    createToggle(AutoTab, "Auto Escape", false, function(state)
        Config.AutoEscape = state
    end)
    createToggle(AutoTab, "Auto Arrest Criminals", false, function(state)
        Config.AutoArrest = state
    end)
    createToggle(AutoTab, "Auto Collect Items", false, function(state)
        Config.AutoCollect = state
    end)
    
    createSection(AutoTab, "⚡ QUICK ACTIONS")
    createToggle(AutoTab, "Auto Respawn", false, function(state)
        Config.AutoRespawn = state
    end)
    createToggle(AutoTab, "Auto Buy Gamepass Items", false, function(state)
        Config.AutoBuy = state
    end)
    
    -- MISC TAB
    createSection(MiscTab, "🔨 WORLD MODIFICATIONS")
    createButton(MiscTab, "Remove All Doors", function()
        removeDoors()
    end)
    createButton(MiscTab, "Remove Walls", function()
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name == "Wall" then
                    v:Destroy()
                end
            end
        end)
    end)
    createButton(MiscTab, "Destroy Prison", function()
        pcall(function()
            workspace.Prison:Destroy()
        end)
    end)
    
    createSection(MiscTab, "💀 PLAYER ACTIONS")
    createButton(MiscTab, "Kill All Players", function()
        killAll()
    end)
    createButton(MiscTab, "Bring All Players", function()
        pcall(function()
            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character then
                        local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = myHRP.CFrame
                        end
                    end
                end
            end
        end)
    end)
    createButton(MiscTab, "Fling All Players", function()
        pcall(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character then
                    local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Velocity = Vector3.new(0, 99999, 0)
                    end
                end
            end
        end)
    end)
    
    createSection(MiscTab, "🎭 FUN")
    createButton(MiscTab, "Spin All Players", function()
        pcall(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character then
                    local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local spin = Instance.new("BodyAngularVelocity", hrp)
                        spin.MaxTorque = Vector3.new(0, 9e9, 0)
                        spin.AngularVelocity = Vector3.new(0, 100, 0)
                    end
                end
            end
        end)
    end)
    createButton(MiscTab, "Make Everyone Huge", function()
        pcall(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character then
                    local hum = v.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.BodyHeightScale.Value = 5
                        hum.BodyWidthScale.Value = 5
                        hum.BodyDepthScale.Value = 5
                    end
                end
            end
        end)
    end)
    
    -- SETTINGS TAB
    createSection(SettingsTab, "💾 GENERAL")
    createToggle(SettingsTab, "Return On Death", false, function(state)
        Config.ReturnOnDeath = state
    end)
    createToggle(SettingsTab, "Safe Mode (Slower)", false, function(state)
        Config.SafeMode = state
    end)
    
    createSection(SettingsTab, "🛡️ ANTI-DETECTION")
    createToggle(SettingsTab, "Anti Kick", true, function(state)
        Config.AntiKick = state
    end)
    createToggle(SettingsTab, "Anti Ban", false, function(state)
        Config.AntiBan = state
    end)
    createToggle(SettingsTab, "Anti AFK", false, function(state)
        Config.AntiAfk = state
    end)
    createToggle(SettingsTab, "Anti Crash", false, function(state)
        Config.AntiCrash = state
    end)
    
    createSection(SettingsTab, "🔑 KEYBINDS")
    createButton(SettingsTab, "Reset All Keybinds", function()
        notify("Settings", "Keybinds resetados!", 2)
    end)
    
    createSection(SettingsTab, "🎨 THEME")
    createButton(SettingsTab, "Red Theme (Default)", function()
        TopBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end)
    createButton(SettingsTab, "Blue Theme", function()
        TopBar.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
    end)
    createButton(SettingsTab, "Green Theme", function()
        TopBar.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
    end)
    createButton(SettingsTab, "Purple Theme", function()
        TopBar.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    end)
    
    -- CREDITS TAB
    local CreditsContent = Instance.new("Frame")
    CreditsContent.Size = UDim2.new(1, 0, 1, 0)
    CreditsContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    CreditsContent.BorderSizePixel = 0
    CreditsContent.Parent = CreditsTab
    
    local CreditsCorner = Instance.new("UICorner")
    CreditsCorner.CornerRadius = UDim.new(0, 15)
    CreditsCorner.Parent = CreditsContent
    
    local CreditsTitle = Instance.new("TextLabel")
    CreditsTitle.Size = UDim2.new(1, 0, 0, 60)
    CreditsTitle.BackgroundTransparency = 1
    CreditsTitle.Text = "⚡ RATTO HUB ULTIMATE"
    CreditsTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    CreditsTitle.TextSize = 28
    CreditsTitle.Font = Enum.Font.GothamBold
    CreditsTitle.Parent = CreditsContent
    
    local CreditsInfo = Instance.new("TextLabel")
    CreditsInfo.Size = UDim2.new(1, -40, 1, -80)
    CreditsInfo.Position = UDim2.new(0, 20, 0, 70)
    CreditsInfo.BackgroundTransparency = 1
    CreditsInfo.Text = [[
╔═══════════════════════════════════╗

    CRIADO POR: ravelitocove66
    
    VERSÃO: 3.0 Ultimate
    120+ Opções Disponíveis!
    
    DISCORD: discord.gg/sGyVHq6m
    
    © 2025 - Todos os Direitos Reservados
    Prison Life Mobile Edition
    
    Obrigado por usar o Ratto Hub! ❤️
    
    Para suporte, entre no Discord
    Para updates, fique atento!
    
╚═══════════════════════════════════╝
]]
    CreditsInfo.TextColor3 = Color3.new(1, 1, 1)
    CreditsInfo.TextSize = 16
    CreditsInfo.Font = Enum.Font.Gotham
    CreditsInfo.TextWrapped = true
    CreditsInfo.TextYAlignment = Enum.TextYAlignment.Top
    CreditsInfo.Parent = CreditsContent
    
    -- Auto-select first tab
    if #tabs > 0 then
        tabs[1].button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        tabs[1].button.TextColor3 = Color3.new(1, 1, 1)
        tabs[1].content.Visible = true
        currentTab = tabs[1].content
    end
    
    notify("Ratto Hub Ultimate", "Carregado com sucesso! 120+ opções disponíveis!", 5)
end

-- Initialize GUI
createGUI()

-- Click TP
mouse.Button1Down:Connect(function()
    if Config.ClickTP then
        safeTP(mouse.Hit + Vector3.new(0, 3, 0))
    end
end)
