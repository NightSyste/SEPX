local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Universal Safe GUI Container
local ParentContainer = nil
if gethui then
    ParentContainer = gethui()
elseif syn and syn.protect_gui then
    local pgui = Instance.new("Folder")
    syn.protect_gui(pgui)
    pgui.Parent = CoreGui
    ParentContainer = pgui
elseif CoreGui and pcall(function() return CoreGui.Name end) then
    ParentContainer = CoreGui
else
    ParentContainer = LocalPlayer:WaitForChild("PlayerGui")
end

-- Farbschema
Library.Theme = {
    ObsidianBase = Color3.fromRGB(11, 14, 20),
    ObsidianCard = Color3.fromRGB(16, 21, 30),
    ObsidianElevated = Color3.fromRGB(22, 28, 40),
    InputDark = Color3.fromRGB(13, 17, 25),
    
    GoldPrimary = Color3.fromRGB(221, 176, 116),
    GoldDark = Color3.fromRGB(182, 126, 63),
    GoldLight = Color3.fromRGB(242, 204, 153),
    
    PetrolPrimary = Color3.fromRGB(34, 104, 121),
    PetrolLight = Color3.fromRGB(45, 135, 155),
    PetrolDark = Color3.fromRGB(23, 78, 90),
    
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextBody = Color3.fromRGB(225, 232, 242),
    TextSecondary = Color3.fromRGB(150, 168, 192),
    TextMuted = Color3.fromRGB(98, 114, 136),
    TextDarkButton = Color3.fromRGB(18, 14, 8),
    
    StatusGreen = Color3.fromRGB(65, 225, 145),
    
    FontBlack = Enum.Font.GothamBold,
    FontBold = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    FontRegular = Enum.Font.Gotham
}

Library.Icons = {
    Key = "rbxassetid://10709791437",
    Shield = "rbxassetid://10734919339",
    Discord = "rbxassetid://10709790387",
    Copy = "rbxassetid://10709790298",
    Settings = "rbxassetid://10734950020",
    User = "rbxassetid://10723415903",
    Device = "rbxassetid://10734898150",
    Clock = "rbxassetid://10709790537",
    Wifi = "rbxassetid://10734950309",
    Crown = "rbxassetid://10734951847",
    Check = "rbxassetid://10709790644",
    External = "rbxassetid://10709790835",
    Minimize = "rbxassetid://10734896206",
    Close = "rbxassetid://10747384394",
    Sparkle = "rbxassetid://10734951847",
    Bolt = "rbxassetid://10734898476",
    Gamepad = "rbxassetid://10734950157",
    Code = "rbxassetid://10734950384"
}

-- Hilfsfunktionen
local function create(className, properties, children)
    local inst = Instance.new(className)
    for prop, val in pairs(properties or {}) do
        inst[prop] = val
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local animatedStrokes = {}

local function addDualToneStroke(inst, thickness, trans, enableRotation)
    local stroke = create("UIStroke", {
        Color = Library.Theme.GoldPrimary,
        Thickness = thickness or 1.1,
        Transparency = trans or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local gradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Theme.GoldPrimary),
            ColorSequenceKeypoint.new(0.45, Library.Theme.GoldLight),
            ColorSequenceKeypoint.new(0.55, Library.Theme.PetrolLight),
            ColorSequenceKeypoint.new(1, Library.Theme.PetrolPrimary)
        }),
        Rotation = 45
    })
    gradient.Parent = stroke
    stroke.Parent = inst

    if enableRotation then
        table.insert(animatedStrokes, gradient)
    end
    return stroke, gradient
end

function Library:SetClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif toclipboard then
        toclipboard(text)
        return true
    elseif syn and syn.write_clipboard then
        syn.write_clipboard(text)
        return true
    end
    return false
end

function Library:GetDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Handy (Mobile)"
    elseif GuiService:IsTenFootInterface() then
        return "Console"
    else
        return "PC"
    end
end

function Library:GetExecutor()
    if identifyexecutor then
        local success, name, ver = pcall(identifyexecutor)
        if success and name and tostring(name) ~= "" then
            return tostring(name) .. (ver and ver ~= "" and (" " .. tostring(ver)) or "")
        end
    end
    if getexecutorname then
        local success, name, ver = pcall(getexecutorname)
        if success and name and tostring(name) ~= "" then
            return tostring(name) .. (ver and ver ~= "" and (" " .. tostring(ver)) or "")
        end
    end
    if syn then
        return "Synapse X"
    elseif KRNL_LOADED then
        return "Krnl"
    elseif FLUXUS_LOADED or Fluxus then
        return "Fluxus"
    elseif is_sirhurt_closure then
        return "SirHurt"
    elseif OXYGEN_LOADED then
        return "Oxygen U"
    elseif pebc_create then
        return "ProtoSmasher"
    elseif shadow_cheats then
        return "Shadow"
    elseif gethui then
        return "Wave / UNC"
    else
        return "Universal / Studio"
    end
end

function Library:GetHWID()
    if gethwid then
        local raw = gethwid()
        return string.sub(raw, 1, 14) .. "..."
    end
    local id = tostring(LocalPlayer.UserId * 1337)
    return "SEPX-" .. string.sub(id, 1, 8)
end

-- Notification System
local ScreenGui = nil
local ToastContainer = nil

local function ensureGui()
    if ScreenGui and ScreenGui.Parent then return ScreenGui end
    
    if ParentContainer:FindFirstChild("SEPX_Enterprise_Hub") then
        ParentContainer:FindFirstChild("SEPX_Enterprise_Hub"):Destroy()
    end

    ScreenGui = create("ScreenGui", {
        Name = "SEPX_Enterprise_Hub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 99999,
        IgnoreGuiInset = true
    })
    pcall(function()
        ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    end)
    ScreenGui.Parent = ParentContainer

    ToastContainer = create("Frame", {
        Name = "ToastContainer",
        Size = UDim2.new(0, 310, 1, -40),
        Position = UDim2.new(1, -330, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = 150
    }, {
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Right
        })
    })
    ToastContainer.Parent = ScreenGui
    return ScreenGui
end

function Library:Notify(title, message, isSuccess)
    ensureGui()
    local toast = create("Frame", {
        Name = "Toast",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Library.Theme.ObsidianBase,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(1, 350, 0, 0),
        ZIndex = 151
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        }),
        create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 0, 0.5, -9),
            BackgroundTransparency = 1,
            Image = isSuccess and Library.Icons.Check or Library.Icons.Sparkle,
            ImageColor3 = isSuccess and Library.Theme.GoldPrimary or Library.Theme.PetrolLight,
            ZIndex = 152
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 18),
            Position = UDim2.new(0, 28, 0, 0),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontBold,
            Text = title,
            TextColor3 = Library.Theme.TextWhite,
            TextSize = 12.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 152
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 16),
            Position = UDim2.new(0, 28, 0, 18),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontRegular,
            Text = message,
            TextColor3 = Library.Theme.TextSecondary,
            TextSize = 10.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 152
        })
    })
    addDualToneStroke(toast, 1.1, 0.3, false)
    toast.Parent = ToastContainer

    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.delay(3.2, function()
        if toast and toast.Parent then
            local tw = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 350, 0, 0)
            })
            tw:Play()
            tw.Completed:Connect(function()
                toast:Destroy()
            end)
        end
    end)
end

-- Window Erstellung
function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "SEPX HUB"
    local SubTitle = config.SubTitle or "Enterprise Edition • v2.4"
    local IntroText = config.IntroText or "LOADED UI"
    local IntroDuration = config.IntroDuration or 4
    local EnableIntro = (config.EnableIntro ~= false)
    local CustomLogo = config.Logo or nil
    local DefaultKey = config.DefaultKey or ""

    local gui = ensureGui()

    local Window = {
        _telemetryRows = {},
        _onRedeemCallback = nil,
        _isMinimized = false
    }

    -- Telemetriedaten
    local currentGameTitle = "Universal Experience"
    local currentPlaceId = tostring(game.PlaceId)
    local currentGameId = tostring(game.GameId ~= 0 and game.GameId or game.PlaceId)

    pcall(function()
        local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
        if productInfo and productInfo.Name and productInfo.Name ~= "" then
            currentGameTitle = productInfo.Name
        end
    end)

    -- Hauptfenster
    local MainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 820, 0, 530),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Library.Theme.ObsidianBase,
        BackgroundTransparency = 0.1,
        Visible = not EnableIntro,
        ClipsDescendants = true
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 20) })
    })
    MainFrame.Parent = gui
    Window.MainFrame = MainFrame

    -- Backdrop Aurora Orbs
    local BackdropLayer = create("Frame", {
        Name = "BackdropLayer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 1
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 20) })
    })
    BackdropLayer.Parent = MainFrame

    local function createAuroraMeshOrb(name, color, size, pos, baseTrans)
        local orb = create("Frame", {
            Name = name,
            Size = size,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = pos,
            BackgroundColor3 = color,
            BackgroundTransparency = baseTrans or 0.65,
            ZIndex = 1
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) }),
            create("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.4),
                    NumberSequenceKeypoint.new(0.5, 0.75),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
        })
        orb.Parent = BackdropLayer
        return orb
    end

    local OrbGold = createAuroraMeshOrb("OrbGold", Library.Theme.GoldPrimary, UDim2.new(0, 340, 0, 340), UDim2.new(0.15, 0, 0.25, 0), 0.58)
    local OrbPetrol = createAuroraMeshOrb("OrbPetrol", Library.Theme.PetrolLight, UDim2.new(0, 400, 0, 400), UDim2.new(0.85, 0, 0.75, 0), 0.60)
    local OrbAmber = createAuroraMeshOrb("OrbAmber", Library.Theme.GoldDark, UDim2.new(0, 280, 0, 280), UDim2.new(0.5, 0, 0.9, 0), 0.65)

    local GlassOverlay = create("Frame", {
        Name = "GlassOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Library.Theme.ObsidianBase,
        BackgroundTransparency = 0.45,
        ZIndex = 2
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 20) })
    })
    GlassOverlay.Parent = BackdropLayer

    addDualToneStroke(MainFrame, 1.2, 0.3, true)

    -- Aurora Animation Drift
    local auroraStep = 0
    RunService.RenderStepped:Connect(function(dt)
        auroraStep = auroraStep + dt * 0.4
        OrbGold.Position = UDim2.new(
            0.15 + math.sin(auroraStep * 0.7) * 0.1, 0,
            0.25 + math.cos(auroraStep * 0.5) * 0.1, 0
        )
        OrbPetrol.Position = UDim2.new(
            0.85 + math.cos(auroraStep * 0.6) * 0.1, 0,
            0.75 + math.sin(auroraStep * 0.8) * 0.1, 0
        )
        OrbAmber.Position = UDim2.new(
            0.50 + math.sin(auroraStep * 0.9) * 0.12, 0,
            0.85 + math.cos(auroraStep * 0.7) * 0.08, 0
        )
        for _, grad in ipairs(animatedStrokes) do
            grad.Rotation = (grad.Rotation + dt * 18) % 360
        end
    end)

    -- Dragging Engine
    local Dragging, DragInput, DragStart, StartPos = false, nil, nil, nil

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.06, Enum.EasingStyle.Linear), {
                Position = UDim2.new(
                    StartPos.X.Scale,
                    StartPos.X.Offset + delta.X,
                    StartPos.Y.Scale,
                    StartPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)

    -- Top Navigation Bar
    local TopNav = create("Frame", {
        Name = "TopNav",
        Size = UDim2.new(1, 0, 0, 54),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(14, 18, 26),
        BackgroundTransparency = 0.4,
        ZIndex = 10
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 20) }),
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 16),
            PaddingTop = UDim.new(0, 9),
            PaddingBottom = UDim.new(0, 9)
        })
    })
    TopNav.Parent = MainFrame

    local BrandSection = create("Frame", {
        Name = "BrandSection",
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 11
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 10)
        })
    })
    BrandSection.Parent = TopNav

    local LogoContainer = create("Frame", {
        Name = "LogoContainer",
        Size = UDim2.new(0, 34, 0, 34),
        BackgroundColor3 = Library.Theme.ObsidianElevated,
        BackgroundTransparency = 0.25,
        ZIndex = 12
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 9) })
    })
    addDualToneStroke(LogoContainer, 1.2, 0.3, true)
    LogoContainer.Parent = BrandSection

    if CustomLogo then
        create("ImageLabel", {
            Size = UDim2.new(1, -6, 1, -6),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image = CustomLogo,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 13,
            Parent = LogoContainer
        })
    else
        create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBlack,
            Text = "SEPX",
            TextColor3 = Library.Theme.GoldPrimary,
            TextSize = 11,
            ZIndex = 13,
            Parent = LogoContainer
        })
    end

    local BrandTextGroup = create("Frame", {
        Name = "BrandTextGroup",
        Size = UDim2.new(0, 130, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 12
    }, {
        create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontBlack,
            Text = Title,
            TextColor3 = Library.Theme.TextWhite,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        }),
        create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 16),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontRegular,
            Text = SubTitle,
            TextColor3 = Library.Theme.GoldPrimary,
            TextSize = 9.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        })
    })
    BrandTextGroup.Parent = BrandSection

    local GameCapsule = create("TextButton", {
        Name = "GameCapsule",
        Size = UDim2.new(0, 230, 0, 26),
        Position = UDim2.new(0, 195, 0.5, -13),
        BackgroundColor3 = Library.Theme.ObsidianElevated,
        BackgroundTransparency = 0.4,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 12
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 13) }),
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8)
        }),
        create("Frame", {
            Name = "LiveDot",
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(0, 0, 0.5, -3),
            BackgroundColor3 = Library.Theme.StatusGreen,
            ZIndex = 13
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) })
        }),
        create("TextLabel", {
            Name = "GameTitleText",
            Size = UDim2.new(0.55, -10, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontBold,
            Text = currentGameTitle,
            TextColor3 = Library.Theme.TextWhite,
            TextSize = 10,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        }),
        create("Frame", {
            Name = "Divider",
            Size = UDim2.new(0, 1, 0, 12),
            Position = UDim2.new(0.56, 0, 0.5, -6),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.85,
            ZIndex = 13
        }),
        create("TextLabel", {
            Name = "PlaceIdLabel",
            Size = UDim2.new(0.42, 0, 1, 0),
            Position = UDim2.new(0.58, 4, 0, 0),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontMedium,
            Text = "ID: " .. currentPlaceId,
            TextColor3 = Library.Theme.GoldPrimary,
            TextSize = 9,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        })
    })
    addDualToneStroke(GameCapsule, 1, 0.5, false)
    GameCapsule.Parent = TopNav

    GameCapsule.MouseButton1Click:Connect(function()
        Library:SetClipboard(currentPlaceId)
        Library:Notify("Place ID Kopiert", "Place ID " .. currentPlaceId .. " in Zwischenablage!", true)
    end)

    local RightNav = create("Frame", {
        Name = "RightNav",
        Size = UDim2.new(0, 310, 1, 0),
        Position = UDim2.new(1, -310, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 12
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6)
        })
    })
    RightNav.Parent = TopNav

    local function createPillBadge(icon, labelText, valText, valColor)
        local pill = create("Frame", {
            Name = "Pill_" .. labelText,
            Size = UDim2.new(0, 68, 0, 26),
            BackgroundColor3 = Library.Theme.ObsidianElevated,
            BackgroundTransparency = 0.45,
            ZIndex = 12
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 13) }),
            create("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }),
            create("ImageLabel", {
                Size = UDim2.new(0, 11, 0, 11),
                Position = UDim2.new(0, 0, 0.5, -5.5),
                BackgroundTransparency = 1,
                Image = icon,
                ImageColor3 = Library.Theme.GoldPrimary,
                ZIndex = 13
            }),
            create("TextLabel", {
                Name = "ValText",
                Size = UDim2.new(1, -14, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Font = Library.Theme.FontMedium,
                Text = valText,
                TextColor3 = valColor or Library.Theme.TextBody,
                TextSize = 9.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13
            })
        })
        addDualToneStroke(pill, 1, 0.5, false)
        return pill
    end

    local SessionPill = createPillBadge(Library.Icons.Clock, "Session", "00:00", Library.Theme.TextWhite)
    local PingPill = createPillBadge(Library.Icons.Wifi, "Ping", "42.0 ms", Library.Theme.StatusGreen)
    SessionPill.Parent = RightNav
    PingPill.Parent = RightNav

    local function createNavBtn(name, icon, callback)
        local btn = create("TextButton", {
            Name = name,
            Size = UDim2.new(0, 26, 0, 26),
            BackgroundColor3 = Library.Theme.ObsidianElevated,
            BackgroundTransparency = 0.45,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 12
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("ImageLabel", {
                Size = UDim2.new(0, 12, 0, 12),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Image = icon,
                ImageColor3 = Library.Theme.TextSecondary,
                ZIndex = 13
            })
        })
        addDualToneStroke(btn, 1, 0.5, false)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.PetrolLight, BackgroundTransparency = 0.2 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.ObsidianElevated, BackgroundTransparency = 0.45 }):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local DashboardGrid = create("Frame", {
        Name = "DashboardGrid",
        Size = UDim2.new(1, 0, 1, -54),
        Position = UDim2.new(0, 0, 0, 54),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 5
    }, {
        create("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 16)
        })
    })
    DashboardGrid.Parent = MainFrame
    Window.DashboardGrid = DashboardGrid

    local MinBtn = createNavBtn("MinBtn", Library.Icons.Minimize, function()
        Window._isMinimized = not Window._isMinimized
        if Window._isMinimized then
            DashboardGrid.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 820, 0, 54)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 820, 0, 530)
            }):Play()
            task.delay(0.08, function()
                if not Window._isMinimized then DashboardGrid.Visible = true end
            end)
        end
    end)
    MinBtn.Parent = RightNav

    local CloseBtn = createNavBtn("CloseBtn", Library.Icons.Close, function()
        TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        gui:Destroy()
    end)
    CloseBtn.Parent = RightNav

    -- Linke Spalte (Gateway)
    local LeftColumn = create("Frame", {
        Name = "LeftColumn",
        Size = UDim2.new(0.55, -8, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Theme.ObsidianCard,
        BackgroundTransparency = 0.4,
        ZIndex = 6
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 16) }),
        create("UIPadding", {
            PaddingTop = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 14),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    addDualToneStroke(LeftColumn, 1.1, 0.4, false)
    LeftColumn.Parent = DashboardGrid

    local GatewayHeader = create("Frame", {
        Name = "GatewayHeader",
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        ZIndex = 7
    }, {
        create("ImageLabel", {
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(0, 0, 0, 2),
            BackgroundTransparency = 1,
            Image = Library.Icons.Key,
            ImageColor3 = Library.Theme.GoldPrimary,
            ZIndex = 7
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 18),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontBold,
            Text = "AUTHENTICATION GATEWAY",
            TextColor3 = Library.Theme.TextWhite,
            TextSize = 13.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 14),
            Position = UDim2.new(0, 30, 0, 18),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontRegular,
            Text = "Enter license token to authenticate execution & features",
            TextColor3 = Library.Theme.TextSecondary,
            TextSize = 9.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7
        })
    })
    GatewayHeader.Parent = LeftColumn

    local KeyBoxContainer = create("Frame", {
        Name = "KeyBoxContainer",
        Size = UDim2.new(1, 0, 0, 44),
        Position = UDim2.new(0, 0, 0, 52),
        BackgroundColor3 = Library.Theme.InputDark,
        BackgroundTransparency = 0.3,
        ZIndex = 7
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("ImageLabel", {
            Size = UDim2.new(0, 15, 0, 15),
            Position = UDim2.new(0, 12, 0.5, -7.5),
            BackgroundTransparency = 1,
            Image = Library.Icons.Shield,
            ImageColor3 = Library.Theme.PetrolLight,
            ZIndex = 8
        })
    })
    local keyStroke = addDualToneStroke(KeyBoxContainer, 1.1, 0.45, false)
    KeyBoxContainer.Parent = LeftColumn

    local KeyTextBox = create("TextBox", {
        Name = "KeyTextBox",
        Size = UDim2.new(1, -95, 1, 0),
        Position = UDim2.new(0, 38, 0, 0),
        BackgroundTransparency = 1,
        Font = Library.Theme.FontMedium,
        PlaceholderText = "Paste license token (SEPX-XXXX-XXXX)...",
        PlaceholderColor3 = Library.Theme.TextMuted,
        Text = DefaultKey,
        TextColor3 = Library.Theme.GoldLight,
        TextSize = 11.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 8
    })
    KeyTextBox.Parent = KeyBoxContainer
    Window.KeyTextBox = KeyTextBox

    local PasteBtn = create("TextButton", {
        Name = "PasteBtn",
        Size = UDim2.new(0, 46, 0, 24),
        Position = UDim2.new(1, -52, 0.5, -12),
        BackgroundColor3 = Library.Theme.ObsidianElevated,
        BackgroundTransparency = 0.3,
        Text = "PASTE",
        Font = Library.Theme.FontBold,
        TextColor3 = Library.Theme.GoldPrimary,
        TextSize = 8.5,
        AutoButtonColor = false,
        ZIndex = 9
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 6) })
    })
    PasteBtn.Parent = KeyBoxContainer

    PasteBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if getclipboard then
                KeyTextBox.Text = getclipboard()
                Library:Notify("Key Eingefügt", "Lizenzschlüssel eingefügt!", true)
            end
        end)
    end)

    KeyTextBox.Focused:Connect(function()
        TweenService:Create(keyStroke, TweenInfo.new(0.2), { Transparency = 0, Thickness = 1.4 }):Play()
    end)
    KeyTextBox.FocusLost:Connect(function()
        TweenService:Create(keyStroke, TweenInfo.new(0.2), { Transparency = 0.45, Thickness = 1.1 }):Play()
    end)

    local HeroActionGrid = create("Frame", {
        Name = "HeroActionGrid",
        Size = UDim2.new(1, 0, 0, 42),
        Position = UDim2.new(0, 0, 0, 108),
        BackgroundTransparency = 1,
        ZIndex = 7
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
    })
    HeroActionGrid.Parent = LeftColumn

    local RedeemBtn = create("TextButton", {
        Name = "RedeemBtn",
        Size = UDim2.new(0.55, -4, 1, 0),
        BackgroundColor3 = Library.Theme.GoldPrimary,
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = 1,
        ZIndex = 8
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Theme.GoldLight),
                ColorSequenceKeypoint.new(0.5, Library.Theme.GoldPrimary),
                ColorSequenceKeypoint.new(1, Library.Theme.GoldDark)
            }),
            Rotation = 45
        }),
        create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 9
        }, {
            create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6)
            }),
            create("ImageLabel", {
                Size = UDim2.new(0, 14, 0, 14),
                BackgroundTransparency = 1,
                Image = Library.Icons.Bolt,
                ImageColor3 = Library.Theme.TextDarkButton,
                ZIndex = 10
            }),
            create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Font = Library.Theme.FontBlack,
                Text = "LAUNCH / REDEEM",
                TextColor3 = Library.Theme.TextDarkButton,
                TextSize = 11,
                ZIndex = 10
            })
        })
    })
    RedeemBtn.Parent = HeroActionGrid

    RedeemBtn.MouseButton1Click:Connect(function()
        local key = KeyTextBox.Text
        if Window._onRedeemCallback then
            Window._onRedeemCallback(key)
        else
            if key == "" then
                Library:Notify("Key Erforderlich", "Bitte gib deinen Lizenzschlüssel ein.", false)
            else
                Library:Notify("Validierung", "Authentifiziere Lizenzschlüssel...", true)
                task.wait(0.8)
                Library:Notify("Zugriff Gewährt", "Willkommen bei " .. Title .. "!", true)
            end
        end
    end)

    local GetKeyBtn = create("TextButton", {
        Name = "GetKeyBtn",
        Size = UDim2.new(0.45, -4, 1, 0),
        BackgroundColor3 = Library.Theme.ObsidianElevated,
        BackgroundTransparency = 0.35,
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = 2,
        ZIndex = 8
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 9
        }, {
            create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6)
            }),
            create("ImageLabel", {
                Size = UDim2.new(0, 13, 0, 13),
                BackgroundTransparency = 1,
                Image = Library.Icons.Key,
                ImageColor3 = Library.Theme.GoldPrimary,
                ZIndex = 10
            }),
            create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Font = Library.Theme.FontBold,
                Text = "GET KEY",
                TextColor3 = Library.Theme.TextWhite,
                TextSize = 10.5,
                ZIndex = 10
            })
        })
    })
    addDualToneStroke(GetKeyBtn, 1.1, 0.4, false)
    GetKeyBtn.Parent = HeroActionGrid

    GetKeyBtn.MouseButton1Click:Connect(function()
        local link = config.GetKeyLink or "https://sepx.cc/getkey"
        Library:SetClipboard(link)
        Library:Notify("Link Kopiert", link .. " kopiert!", true)
    end)

    local UtilGrid = create("Frame", {
        Name = "UtilGrid",
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, 0, 160),
        BackgroundTransparency = 1,
        ZIndex = 7
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
    })
    UtilGrid.Parent = LeftColumn
    Window.UtilGrid = UtilGrid

    function Window:AddUtilButton(text, icon, callback)
        local btn = create("TextButton", {
            Name = "Btn_" .. text,
            Size = UDim2.new(0.33, -4, 1, 0),
            BackgroundColor3 = Library.Theme.ObsidianElevated,
            BackgroundTransparency = 0.4,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 8
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ZIndex = 9
            }, {
                create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 5)
                }),
                create("ImageLabel", {
                    Size = UDim2.new(0, 12, 0, 12),
                    BackgroundTransparency = 1,
                    Image = icon or Library.Icons.Sparkle,
                    ImageColor3 = Library.Theme.PetrolLight,
                    ZIndex = 10
                }),
                create("TextLabel", {
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = text,
                    TextColor3 = Library.Theme.TextBody,
                    TextSize = 9.5,
                    ZIndex = 10
                })
            })
        })
        addDualToneStroke(btn, 1, 0.5, false)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.PetrolPrimary, BackgroundTransparency = 0.2 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.ObsidianElevated, BackgroundTransparency = 0.4 }):Play()
        end)
        btn.MouseButton1Click:Connect(callback or function() end)
        btn.Parent = UtilGrid
        return btn
    end

    -- Standard-Buttons
    Window:AddUtilButton("Discord", Library.Icons.Discord, function()
        local discord = config.DiscordLink or "https://discord.gg/sepx"
        Library:SetClipboard(discord)
        Library:Notify("Discord Kopiert", discord .. " kopiert!", true)
    end)

    Window:AddUtilButton("Copy HWID", Library.Icons.Copy, function()
        local hwid = Library:GetHWID()
        Library:SetClipboard(hwid)
        Library:Notify("HWID Kopiert", "HWID kopiert!", true)
    end)

    Window:AddUtilButton("Config", Library.Icons.Settings, function()
        Library:Notify("Config", "Settings geladen.", true)
    end)

    local EngineStatusBanner = create("Frame", {
        Name = "EngineStatusBanner",
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, 1, -32),
        BackgroundColor3 = Color3.fromRGB(14, 22, 30),
        BackgroundTransparency = 0.35,
        ZIndex = 7
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        create("Frame", {
            Name = "StatusDot",
            Size = UDim2.new(0, 7, 0, 7),
            Position = UDim2.new(0, 12, 0.5, -3.5),
            BackgroundColor3 = Library.Theme.StatusGreen,
            ZIndex = 8
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) })
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 26, 0, 0),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontMedium,
            Text = Title .. " • " .. Library:GetExecutor() .. " • System Ready",
            TextColor3 = Library.Theme.GoldPrimary,
            TextSize = 10,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 8
        })
    })
    addDualToneStroke(EngineStatusBanner, 1, 0.5, false)
    EngineStatusBanner.Parent = LeftColumn

    -- Rechte Spalte (Profil & Live Telemetrie)
    local RightColumn = create("Frame", {
        Name = "RightColumn",
        Size = UDim2.new(0.45, -8, 1, 0),
        Position = UDim2.new(0.55, 8, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 6
    }, {
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    })
    RightColumn.Parent = DashboardGrid

    local ProfileContextCard = create("Frame", {
        Name = "ProfileContextCard",
        Size = UDim2.new(1, 0, 0, 242),
        BackgroundColor3 = Library.Theme.ObsidianCard,
        BackgroundTransparency = 0.4,
        LayoutOrder = 1,
        ZIndex = 7
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 16) }),
        create("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })
    })
    addDualToneStroke(ProfileContextCard, 1.1, 0.4, false)
    ProfileContextCard.Parent = RightColumn

    local ProfileHeader = create("Frame", {
        Name = "ProfileHeader",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        ZIndex = 8
    }, {
        create("Frame", {
            Name = "AvatarContainer",
            Size = UDim2.new(0, 44, 0, 44),
            BackgroundColor3 = Color3.fromRGB(24, 32, 46),
            BackgroundTransparency = 0.2,
            ZIndex = 8
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) }),
            create("ImageLabel", {
                Size = UDim2.new(1, -4, 1, -4),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
                ZIndex = 9
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
        })
    }),
    create("Frame", {
        Name = "IdentityTextGroup",
        Size = UDim2.new(1, -54, 1, 0),
        Position = UDim2.new(0, 54, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 8
    }, {
        create("TextLabel", {
            Size = UDim2.new(1, -65, 0, 18),
            Position = UDim2.new(0, 0, 0, 2),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontBold,
            Text = LocalPlayer.DisplayName or "User",
            TextColor3 = Library.Theme.TextWhite,
            TextSize = 13.5,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 9
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -65, 0, 14),
            Position = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontRegular,
            Text = "@" .. (LocalPlayer.Name or "player"),
            TextColor3 = Library.Theme.TextSecondary,
            TextSize = 10.5,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 9
        }),
        create("Frame", {
            Name = "VerifiedPill",
            Size = UDim2.new(0, 68, 0, 18),
            Position = UDim2.new(1, -68, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.2,
            ZIndex = 9
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 6) }),
            create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Library.Theme.FontBold,
                Text = "VERIFIED",
                TextColor3 = Library.Theme.StatusGreen,
                TextSize = 8,
                ZIndex = 10
            })
        })
    })
    ProfileHeader.Parent = ProfileContextCard
    addDualToneStroke(ProfileHeader.AvatarContainer, 1.2, 0.3, true)

    local ProfileDivider = create("Frame", {
        Name = "ProfileDivider",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 52),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        ZIndex = 8
    })
    ProfileDivider.Parent = ProfileContextCard

    local TelemetryList = create("Frame", {
        Name = "TelemetryList",
        Size = UDim2.new(1, 0, 0, 160),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundTransparency = 1,
        ZIndex = 8
    }, {
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
    })
    TelemetryList.Parent = ProfileContextCard

    function Window:AddTelemetryRow(label, value, icon, valColor)
        local count = #TelemetryList:GetChildren()
        local row = create("Frame", {
            Name = "Row_" .. label,
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Library.Theme.InputDark,
            BackgroundTransparency = 0.4,
            LayoutOrder = count + 1,
            ZIndex = 9
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 6) }),
            create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
            create("ImageLabel", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, 0, 0.5, -6),
                BackgroundTransparency = 1,
                Image = icon or Library.Icons.Sparkle,
                ImageColor3 = Library.Theme.GoldPrimary,
                ZIndex = 10
            }),
            create("TextLabel", {
                Size = UDim2.new(0.38, -16, 1, 0),
                Position = UDim2.new(0, 16, 0, 0),
                BackgroundTransparency = 1,
                Font = Library.Theme.FontMedium,
                Text = label .. ":",
                TextColor3 = Library.Theme.TextSecondary,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 10
            }),
            create("TextLabel", {
                Name = "ValueLabel",
                Size = UDim2.new(0.62, 0, 1, 0),
                Position = UDim2.new(0.38, 0, 0, 0),
                BackgroundTransparency = 1,
                Font = Library.Theme.FontBold,
                Text = value,
                TextColor3 = valColor or Library.Theme.TextWhite,
                TextSize = 10,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 10
            })
        })
        addDualToneStroke(row, 0.9, 0.6, false)
        row.Parent = TelemetryList
        Window._telemetryRows[label] = row
        return row
    end

    function Window:UpdateTelemetry(label, newValue)
        local row = Window._telemetryRows[label]
        if row then
            local valLabel = row:FindFirstChild("ValueLabel")
            if valLabel then
                valLabel.Text = tostring(newValue)
            end
        end
    end

    -- Standard Telemetriezeilen
    Window:AddTelemetryRow("Game Name", currentGameTitle, Library.Icons.Gamepad, Library.Theme.TextWhite)
    Window:AddTelemetryRow("Game ID", currentGameId, Library.Icons.Sparkle, Library.Theme.GoldLight)
    Window:AddTelemetryRow("Place ID", currentPlaceId, Library.Icons.External, Library.Theme.GoldPrimary)
    Window:AddTelemetryRow("Gerät", Library:GetDeviceType(), Library.Icons.Device, Library.Theme.TextBody)
    Window:AddTelemetryRow("Executor", Library:GetExecutor(), Library.Icons.Code, Library.Theme.StatusGreen)

    -- VIP Card
    local VipCard = create("Frame", {
        Name = "VipCard",
        Size = UDim2.new(1, 0, 1, -252),
        BackgroundColor3 = Library.Theme.ObsidianCard,
        BackgroundTransparency = 0.4,
        LayoutOrder = 2,
        ZIndex = 7
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 16) }),
        create("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })
    })
    addDualToneStroke(VipCard, 1.1, 0.35, true)
    VipCard.Parent = RightColumn

    local VipHeader = create("Frame", {
        Name = "VipHeader",
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        ZIndex = 8
    }, {
        create("Frame", {
            Name = "VipBadge",
            Size = UDim2.new(0, 60, 0, 18),
            BackgroundColor3 = Color3.fromRGB(48, 36, 20),
            BackgroundTransparency = 0.2,
            ZIndex = 8
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 4)
            }),
            create("ImageLabel", {
                Size = UDim2.new(0, 11, 0, 11),
                BackgroundTransparency = 1,
                Image = Library.Icons.Crown,
                ImageColor3 = Library.Theme.GoldLight,
                ZIndex = 9
            }),
            create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Font = Library.Theme.FontBlack,
                Text = "SEPX+",
                TextColor3 = Library.Theme.GoldPrimary,
                TextSize = 9.5,
                ZIndex = 9
            })
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 70, 0, -2),
            BackgroundTransparency = 1,
            Font = Library.Theme.FontBold,
            Text = "VIP Elite Access",
            TextColor3 = Library.Theme.TextWhite,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 8
        })
    })
    VipHeader.Parent = VipCard

    local VipDesc = create("TextLabel", {
        Name = "VipDesc",
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundTransparency = 1,
        Font = Library.Theme.FontRegular,
        Text = "Unlock 0-day scripts, instant bypass & dedicated support.",
        TextColor3 = Library.Theme.TextSecondary,
        TextSize = 9.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    })
    VipDesc.Parent = VipCard

    local UpgradeBtn = create("TextButton", {
        Name = "UpgradeBtn",
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, 1, -32),
        BackgroundColor3 = Library.Theme.GoldPrimary,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 8
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Theme.GoldLight),
                ColorSequenceKeypoint.new(0.5, Library.Theme.GoldPrimary),
                ColorSequenceKeypoint.new(1, Library.Theme.GoldDark)
            }),
            Rotation = 45
        }),
        create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 9
        }, {
            create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6)
            }),
            create("ImageLabel", {
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundTransparency = 1,
                Image = Library.Icons.External,
                ImageColor3 = Library.Theme.TextDarkButton,
                ZIndex = 10
            }),
            create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Font = Library.Theme.FontBold,
                Text = "UPGRADE TO SEPX+",
                TextColor3 = Library.Theme.TextDarkButton,
                TextSize = 10,
                ZIndex = 10
            })
        })
    })
    UpgradeBtn.Parent = VipCard

    UpgradeBtn.MouseButton1Click:Connect(function()
        local pricing = config.PricingLink or "https://sepx.cc/pricing"
        Library:SetClipboard(pricing)
        Library:Notify("Link Kopiert", pricing .. " kopiert!", true)
    end)

    -- Window Methods
    function Window:OnRedeem(callback)
        Window._onRedeemCallback = callback
    end

    function Window:SetKey(keyText)
        KeyTextBox.Text = tostring(keyText)
    end

    -- 4-Sekunden Loader Launch
    if EnableIntro then
        task.spawn(function()
            local IntroOverlay = create("Frame", {
                Name = "IntroOverlay",
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                ClipsDescendants = false,
                ZIndex = 200
            })
            IntroOverlay.Parent = gui

            local GlowGold1 = Color3.fromRGB(255, 225, 130)
            local GlowGold2 = Color3.fromRGB(220, 160, 60)
            local GlowPetrol1 = Color3.fromRGB(0, 235, 255)
            local GlowPetrol2 = Color3.fromRGB(25, 110, 150)

            local function createInwardGlow(name, size, pos, color1, color2, rot)
                local glow = create("Frame", {
                    Name = name,
                    Size = size,
                    Position = pos,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 201
                }, {
                    create("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, color1),
                            ColorSequenceKeypoint.new(0.4, color2),
                            ColorSequenceKeypoint.new(1, color2)
                        }),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.05),
                            NumberSequenceKeypoint.new(0.25, 0.35),
                            NumberSequenceKeypoint.new(0.65, 0.75),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = rot
                    })
                })
                glow.Parent = IntroOverlay
                return glow
            end

            local TopInwardGlow = createInwardGlow("TopInwardGlow", UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 0, 0), GlowGold1, GlowGold2, 90)
            local RightInwardGlow = createInwardGlow("RightInwardGlow", UDim2.new(0, 220, 1, 0), UDim2.new(1, -220, 0, 0), GlowPetrol1, GlowPetrol2, 180)
            local BottomInwardGlow = createInwardGlow("BottomInwardGlow", UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 1, -220), GlowGold1, GlowGold2, 270)
            local LeftInwardGlow = createInwardGlow("LeftInwardGlow", UDim2.new(0, 220, 1, 0), UDim2.new(0, 0, 0, 0), GlowPetrol1, GlowPetrol2, 0)

            TweenService:Create(TopInwardGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(RightInwardGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(BottomInwardGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(LeftInwardGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()

            local breathStep = 0
            local breathingConn
            breathingConn = RunService.RenderStepped:Connect(function(dt)
                breathStep = breathStep + dt * 2.2
                local breathFactor = (math.sin(breathStep) + 1) * 0.5
                local inwardTrans = 0.0 + (1 - breathFactor) * 0.35
                TopInwardGlow.BackgroundTransparency = inwardTrans
                RightInwardGlow.BackgroundTransparency = inwardTrans
                BottomInwardGlow.BackgroundTransparency = inwardTrans
                LeftInwardGlow.BackgroundTransparency = inwardTrans
            end)

            local GiantLogo = create("ImageLabel", {
                Name = "GiantLogo",
                Size = UDim2.new(0, 260, 0, 260),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.44, 0),
                BackgroundTransparency = 1,
                Image = CustomLogo or "",
                ScaleType = Enum.ScaleType.Fit,
                ImageTransparency = 1,
                ZIndex = 208
            })
            GiantLogo.Parent = IntroOverlay
            
            local GiantFallbackText
            if not CustomLogo or CustomLogo == "" then
                GiantFallbackText = create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBlack,
                    Text = "SEPX",
                    TextColor3 = GlowGold1,
                    TextSize = 100,
                    TextTransparency = 1,
                    ZIndex = 208
                })
                GiantFallbackText.Parent = GiantLogo
            end

            local IntroTitle = create("TextLabel", {
                Size = UDim2.new(0, 460, 0, 36),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.70, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBlack,
                Text = IntroText,
                TextColor3 = Library.Theme.TextWhite,
                TextSize = 28,
                TextTransparency = 1,
                ZIndex = 210
            })
            IntroTitle.Parent = IntroOverlay

            local ProgressTrack = create("Frame", {
                Name = "ProgressTrack",
                Size = UDim2.new(0, 260, 0, 5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.76, 0),
                BackgroundColor3 = Color3.fromRGB(20, 28, 40),
                BackgroundTransparency = 0.4,
                ZIndex = 210
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
            ProgressTrack.Parent = IntroOverlay

            local ProgressBar = create("Frame", {
                Name = "ProgressBar",
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Library.Theme.GoldPrimary,
                ZIndex = 211
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
            ProgressBar.Parent = ProgressTrack

            task.wait(0.15)
            TweenService:Create(GiantLogo, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 300),
                ImageTransparency = 0.2
            }):Play()
            if GiantFallbackText then
                TweenService:Create(GiantFallbackText, TweenInfo.new(0.8), { TextTransparency = 0.2 }):Play()
            end

            TweenService:Create(IntroTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()

            local loadTime = math.max(1, IntroDuration - 0.5)
            TweenService:Create(ProgressBar, TweenInfo.new(loadTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(1, 0, 1, 0)
            }):Play()

            task.wait(loadTime)

            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 780, 0, 490)
            MainFrame.BackgroundTransparency = 0.7

            TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 820, 0, 530),
                BackgroundTransparency = 0.1
            }):Play()

            TweenService:Create(GiantLogo, TweenInfo.new(0.4), { ImageTransparency = 1, Size = UDim2.new(0, 340, 0, 340) }):Play()
            if GiantFallbackText then TweenService:Create(GiantFallbackText, TweenInfo.new(0.4), { TextTransparency = 1 }):Play() end
            TweenService:Create(IntroTitle, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
            TweenService:Create(ProgressTrack, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(ProgressBar, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()

            TweenService:Create(TopInwardGlow, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(BottomInwardGlow, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(LeftInwardGlow, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(RightInwardGlow, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()

            task.wait(0.55)
            if breathingConn then breathingConn:Disconnect() end
            IntroOverlay:Destroy()

            Library:Notify(Title, "Universal Gateway Initialized. Welcome, " .. (LocalPlayer.DisplayName or "User"), true)
        end)
    end

    -- Session & Ping Monitor
    local startTime = tick()
    task.spawn(function()
        local sessionLabel = SessionPill:FindFirstChild("ValText")
        while gui and gui.Parent do
            local elapsed = math.floor(tick() - startTime)
            local mins = math.floor(elapsed / 60)
            local secs = elapsed % 60
            if sessionLabel then
                sessionLabel.Text = string.format("%02d:%02d", mins, secs)
            end
            task.wait(1)
        end
    end)

    task.spawn(function()
        local pingLabel = PingPill:FindFirstChild("ValText")
        while gui and gui.Parent do
            local ping = 42.0
            pcall(function()
                local rawPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                if rawPing then ping = rawPing end
            end)
            if pingLabel then
                pingLabel.Text = string.format("%.1f ms", ping)
            end
            task.wait(0.8)
        end
    end)

    return Window
end

return Library
