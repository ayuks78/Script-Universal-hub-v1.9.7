-- [[ UNIVERSAL-HUB v2.7 - INFINITE EDITION ]]
-- @ayuks78 & @GmAI
-- FOCO: ESP ESTILO IY | AIMBOT FORTE SEM FOV | HITBOX REAL

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ CONFIGURAÇÃO DE ELITE ]]
getgenv().Config = {
    Aimbot = false,
    Hitbox = false,
    Esp = false,
    Noclip = false,
    MaxDist = 700,
    AimPart = "UpperTorso", -- Mira no Tronco para não errar
    AimSmooth = 1 -- 1 = Instantâneo (Forte)
}

-- [[ INTERFACE ARRASTÁVEL ]]
local UI = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 580, 0, 320); Main.Position = UDim2.new(0.5, -290, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local RGB = Instance.new("Frame", Main)
RGB.Size = UDim2.new(1, 0, 0, 3); RGB.Position = UDim2.new(0, 0, 1, -3); RGB.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -160, 1, -20); Container.Position = UDim2.new(0, 150, 0, 10); Container.BackgroundTransparency = 1

local Tabs = {}
function NewTab(name, id)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0); P.Visible = (id == 1); P.BackgroundTransparency = 1; P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, -20, 0, 35); B.Position = UDim2.new(0, 10, 0, 50 + (id-1)*42); B.Text = name; B.BackgroundColor3 = (id == 1) and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(20, 20, 25); B.TextColor3 = Color3.fromRGB(255, 255, 255); B.Font = "GothamBold"; B.TextSize = 11; Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.P.Visible = false; v.B.BackgroundColor3 = Color3.fromRGB(20, 20, 25) end
        P.Visible = true; B.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end)
    Tabs[id] = {P = P, B = B}
    return P
end

function AddToggle(parent, text, key)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 42); f.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", f)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextXAlignment = 0; l.BackgroundTransparency = 1; l.Font = "GothamBold"; l.TextSize = 11
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 36, 0, 18); b.Position = UDim2.new(1, -48, 0.5, -9); b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    b.MouseButton1Click:Connect(function()
        getgenv().Config[key] = not getgenv().Config[key]
        TS:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = getgenv().Config[key] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 45)}):Play()
    end)
end

local T1 = NewTab("Main", 1); local T2 = NewTab("Visual", 2); local T3 = NewTab("Misc", 3)
AddToggle(T1, "Aimbot Forte (Sticky)", "Aimbot"); AddToggle(T1, "Hitbox Pro v3", "Hitbox")
AddToggle(T2, "ESP Infinite (Box/Name)", "Esp")
AddToggle(T3, "Noclip Ghost", "Noclip")

-- [[ MOTOR DE ESP (ESTILO INFINITE YIELD) ]]
local function CreateESP(plr)
    local folder = Instance.new("Folder", UI); folder.Name = "ESP_" .. plr.Name
    
    local bgui = Instance.new("BillboardGui", folder)
    bgui.AlwaysOnTop = true; bgui.Size = UDim2.new(0, 200, 0, 50); bgui.Adornee = plr.Character:WaitForChild("Head")
    bgui.ExtentsOffset = Vector3.new(0, 3, 0)
    
    local nametag = Instance.new("TextLabel", bgui)
    nametag.Size = UDim2.new(1, 0, 1, 0); nametag.BackgroundTransparency = 1; nametag.TextColor3 = plr.TeamColor.Color
    nametag.TextStrokeTransparency = 0; nametag.Font = "GothamBold"; nametag.TextSize = 14
    
    local box = Instance.new("BoxHandleAdornment", folder)
    box.Size = Vector3.new(4, 6, 4); box.AlwaysOnTop = true; box.ZIndex = 10; box.Adornee = plr.Character:WaitForChild("HumanoidRootPart")
    box.Transparency = 0.6; box.Color3 = plr.TeamColor.Color
    
    RS.RenderStepped:Connect(function()
        if getgenv().Config.Esp and plr.Character and plr.Character:FindFirstChild("Head") then
            local dist = math.floor((lp.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
            nametag.Text = plr.Name .. " | Vida: " .. math.floor(plr.Character.Humanoid.Health) .. "% | Studs: " .. dist .. "m"
            folder.Name = "ESP_" .. plr.Name; bgui.Enabled = true; box.Visible = true
        else
            bgui.Enabled = false; box.Visible = false
        end
    end)
end

-- Gerenciar ESP para novos players
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(1); if p ~= lp then CreateESP(p) end end) end)
for _, p in pairs(Players:GetPlayers()) do if p ~= lp and p.Character then CreateESP(p) end end

-- [[ AIMBOT FORTE (STICKY) ]]
local function GetClosest()
    local target, dist = nil, getgenv().Config.MaxDist
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild(getgenv().Config.AimPart) and v.Character.Humanoid.Health > 0 then
            local pos, vis = camera:WorldToViewportPoint(v.Character[getgenv().Config.AimPart].Position)
            local mag = (v.Character[getgenv().Config.AimPart].Position - lp.Character[getgenv().Config.AimPart].Position).Magnitude
            if mag < dist then
                target = v; dist = mag
            end
        end
    end
    return target
end

RS.RenderStepped:Connect(function()
    if getgenv().Config.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosest()
        if t then
            camera.CFrame = CFrame.new(camera.CFrame.Position, t.Character[getgenv().Config.AimPart].Position)
        end
    end
    
    if getgenv().Config.Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Config.HitSize, getgenv().Config.HitSize, getgenv().Config.HitSize)
                v.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- Noclip
RS.Stepped:Connect(function()
    if getgenv().Config.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- Botão de Minimizar
local MinBtn = Instance.new("ImageButton", UI)
MinBtn.Size = UDim2.new(0, 45, 0, 45); MinBtn.Position = UDim2.new(0, 15, 0.5, -22); MinBtn.Image = "rbxassetid://6023454774"; MinBtn.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Instance.new("UICorner", MinBtn)
MinBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)