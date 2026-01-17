-- [[ PAINEL UNIVERSAL-HUB-V1.3 ]]
-- Codename Devs: @ayuks78 & @GmAI
-- FIX: UI Visibility & Stealth Parenting

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 1. CONFIGURAÇÃO DA INTERFACE ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxGui_Update_" .. math.random(100, 999)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999 -- Garante que fica por cima

-- Função para colocar a UI em lugar seguro e visível
local function ProtectUI(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
    else
        gui.Parent = game:GetService("CoreGui")
    end
end
ProtectUI(ScreenGui)

-- [[ 2. LÓGICA DE SEGURANÇA PASSIVA ]]
-- Mantendo sem HOOKS para evitar Erro 267
getgenv().Aim_Settings = { PlayerAim = false, AutoAim = false, Smoothing = 0.35, MaxDist = 900 }
getgenv().Hitbox_Config = { Enabled = false, Size = 5, Transparency = 0.8 }

-- [[ 3. CRIAÇÃO DO PAINEL VISUAL ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Começa fechado, abre no botão
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Barra Lateral
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 140, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local UIList = Instance.new("UIListLayout", SideBar)
UIList.Padding = UDim.new(0, 2)

-- Container de Páginas
local Pages = Instance.new("Frame", MainFrame)
Pages.Size = UDim2.new(1, -150, 1, -20)
Pages.Position = UDim2.new(0, 150, 0, 10)
Pages.BackgroundTransparency = 1

local function CreatePage(name, icon)
    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.BorderSizePixel = 0

    local TabBtn = Instance.new("TextButton", SideBar)
    TabBtn.Size = UDim2.new(1, 0, 0, 45)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "  " .. icon .. " " .. name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do 
            if p:IsA("ScrollingFrame") then p.Visible = false end 
        end
        Page.Visible = true
    end)
    
    local UIListP = Instance.new("UIListLayout", Page)
    UIListP.Padding = UDim.new(0, 5)
    UIListP.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    return Page
end

local MainP = CreatePage("Main", "◇")
local EspP = CreatePage("Esp", "◇")
local SettingsP = CreatePage("Settings", "◇")
local CreditsP = CreatePage("Credits", "◇")

-- [[ 4. BOTÕES E SLIDER ]]
local function AddToggle(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = text .. " [OFF]"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local act = false
    Btn.MouseButton1Click:Connect(function()
        act = not act
        Btn.Text = text .. (act and " [ON]" or " [OFF]")
        Btn.BackgroundColor3 = act and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(20, 20, 20)
        callback(act)
    end)
end

AddToggle(MainP, "Aimbot Manual", function(v) getgenv().Aim_Settings.PlayerAim = v end)
AddToggle(MainP, "Aimbot Auto (NPC)", function(v) getgenv().Aim_Settings.AutoAim = v end)
AddToggle(MainP, "Hitbox Expander", function(v) getgenv().Hitbox_Config.Enabled = v end)

-- Slider de Studs
local SFrame = Instance.new("Frame", MainP); SFrame.Size = UDim2.new(1,-20,0,50); SFrame.BackgroundTransparency = 1
local SLab = Instance.new("TextLabel", SFrame); SLab.Size = UDim2.new(1,0,0,20); SLab.Text = "Hitbox: 5 Studs"; SLab.TextColor3 = Color3.fromRGB(180,180,180); SLab.BackgroundTransparency = 1
local SBar = Instance.new("Frame", SFrame); SBar.Size = UDim2.new(1,0,0,4); SBar.Position = UDim2.new(0,0,0,30); SBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
local SBtn = Instance.new("TextButton", SBar); SBtn.Size = UDim2.new(0,16,0,16); SBtn.Position = UDim2.new(0,0,0,-6); SBtn.BackgroundColor3 = Color3.fromRGB(100,100,100); SBtn.Text = ""
Instance.new("UICorner", SBtn).CornerRadius = UDim.new(1,0)

local drag = false
SBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
UIS.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local r = math.clamp((i.Position.X - SBar.AbsolutePosition.X)/SBar.AbsoluteSize.X, 0, 1)
        SBtn.Position = UDim2.new(r, -8, 0, -6)
        local val = math.floor(5 + (r * 20))
        getgenv().Hitbox_Config.Size = val
        SLab.Text = "Hitbox: " .. val .. " Studs"
    end
end)

-- [[ 5. FUNCIONALIDADES BACKEND ]]
local function GetTarget()
    local closest, dist = nil, 200
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then closest = v.Character.HumanoidRootPart; dist = mag end
            end
        end
    end
    return closest
end

RS.RenderStepped:Connect(function()
    if getgenv().Aim_Settings.PlayerAim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetTarget()
        if t then
            local tp = camera:WorldToViewportPoint(t.Position)
            local mp = UIS:GetMouseLocation()
            mousemoverel((tp.X-mp.X)*getgenv().Aim_Settings.Smoothing, (tp.Y-mp.Y)*getgenv().Aim_Settings.Smoothing)
        end
    end
end)

RS.Heartbeat:Connect(function()
    if getgenv().Hitbox_Config.Enabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Hitbox_Config.Size, getgenv().Hitbox_Config.Size, getgenv().Hitbox_Config.Size)
                v.Character.HumanoidRootPart.Transparency = getgenv().Hitbox_Config.Transparency
                v.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- [[ 6. BOTÃO DE ABRIR/FECHAR ]]
local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Image = "rbxassetid://6023454774" -- Ícone de Verificado
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.Active = true
OpenBtn.Draggable = true -- Você pode mover o botão pela tela

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Inicialização
MainP.Visible = true
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Universal-Hub v1.3",
    Text = "Aperte no ícone azul para abrir!",
    Duration = 5
})