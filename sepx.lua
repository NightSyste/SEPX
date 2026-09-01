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

-- ═══════════════════════════════════════════════════════════════════
-- 🎨 NIGHT SYSTEM FARBSCHEMA (Obsidian Black, Crimson Red & Steel)
-- ═══════════════════════════════════════════════════════════════════
Library.Theme = {
    -- Backgrounds (Matte Carbon & Deep Obsidian)
    Base = Color3.fromRGB(9, 10, 14),
    Sidebar = Color3.fromRGB(12, 13, 18),
    Card = Color3.fromRGB(16, 17, 24),
    Elevated = Color3.fromRGB(22, 24, 33),
    Input = Color3.fromRGB(11, 12, 17),
    
    -- Night System Signature Accents (Crimson Red & Gunmetal Steel)
    RedPrimary = Color3.fromRGB(235, 35, 52),     -- Leuchtendes Crimson Rot
    RedLight = Color3.fromRGB(255, 65, 85),       -- Neon Edge Rot
    RedDark = Color3.fromRGB(150, 15, 28),        -- Deep Carbon Wine
    
    SteelLight = Color3.fromRGB(215, 222, 232),   -- Gebürstetes Titan / Silber
    SteelMedium = Color3.fromRGB(130, 138, 152),  -- Gunmetal Grau
    SteelDark = Color3.fromRGB(55, 60, 72),       -- Dark Metal
    
    -- Typography
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextBody = Color3.fromRGB(225, 229, 238),
    TextSecondary = Color3.fromRGB(145, 153, 168),
    TextMuted = Color3.fromRGB(85, 92, 108),
    TextDarkButton = Color3.fromRGB(255, 255, 255),
    
    StatusGreen = Color3.fromRGB(65, 225, 145),
    StatusRed = Color3.fromRGB(255, 55, 75),
    
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
    Code = "rbxassetid://10734950384",
    ChevronDown = "rbxassetid://10709790948"
}

-- Sichere Instanzerstellung
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

-- Night System Dual-Tone Stroke (Crimson Red to Gunmetal Steel)
local function addNightStroke(inst, thickness, trans, enableRotation)
    local stroke = create("UIStroke", {
        Color = Library.Theme.RedPrimary,
        Thickness = thickness or 1.1,
        Transparency = trans or 0.45,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local gradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Theme.RedPrimary),
            ColorSequenceKeypoint.new(0.35, Library.Theme.RedLight),
            ColorSequenceKeypoint.new(0.65, Library.Theme.SteelLight),
            ColorSequenceKeypoint.new(1, Library.Theme.SteelDark)
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
    return "NS-" .. string.sub(id, 1, 8)
end

-- Root GUI Container & Toast
local ScreenGui = nil
local ToastContainer = nil

local function ensureGui()
    if ScreenGui and ScreenGui.Parent then return ScreenGui end
    
    if ParentContainer:FindFirstChild("NIGHT_SYSTEM_HUB") then
        ParentContainer:FindFirstChild("NIGHT_SYSTEM_HUB"):Destroy()
    end

    ScreenGui = create("ScreenGui", {
        Name = "NIGHT_SYSTEM_HUB",
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

-- Notifier mit Night System Glow
function Library:Notify(titleOrConfig, message, isSuccess)
    ensureGui()
    local title = "Notification"
    local desc = ""
    local success = true
    local duration = 3.2
    local customIcon = nil

    if type(titleOrConfig) == "table" then
        title = titleOrConfig.Title or titleOrConfig.Name or "Night System"
        desc = titleOrConfig.Content or titleOrConfig.Description or titleOrConfig.Text or ""
        customIcon = titleOrConfig.Image or titleOrConfig.Icon
        duration = titleOrConfig.Time or titleOrConfig.Duration or 3.2
        success = (titleOrConfig.Success ~= false)
    else
        title = tostring(titleOrConfig or "Night System")
        desc = tostring(message or "")
        success = (isSuccess ~= false)
    end

    local toast = create("Frame", {
        Name = "Toast",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Library.Theme.Base,
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
            Image = customIcon or (success and Library.Icons.Check or Library.Icons.Sparkle),
            ImageColor3 = success and Library.Theme.RedPrimary or Library.Theme.SteelLight,
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
            Text = desc,
            TextColor3 = Library.Theme.TextSecondary,
            TextSize = 10.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 152
        })
    })
    addNightStroke(toast, 1.1, 0.3, false)
    toast.Parent = ToastContainer

    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.delay(duration, function()
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

-- ====================================================================
-- 🖥️ WINDOW ERSTELLUNG (NIGHT SYSTEM THEME)
-- ====================================================================
function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Name or config.Title or "NIGHT SYSTEM"
    local SubTitle = config.SubTitle or config.Subtitle or "Enterprise Edition • v3.0"
    local IntroText = config.IntroText or "NIGHT SYSTEM"
    local IntroDuration = config.IntroDuration or 4
    local EnableIntro = (config.EnableIntro ~= false)
    local CustomLogo = config.Logo or config.Icon or nil

    local gui = ensureGui()

    local Window = {
        Tabs = {},
        ActiveTab = nil,
        _isMinimized = false
    }

    -- Hauptfenster
    local MainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 840, 0, 540),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Library.Theme.Base,
        BackgroundTransparency = 0.08,
        Visible = not EnableIntro,
        ClipsDescendants = true
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 18) })
    })
    MainFrame.Parent = gui
    Window.MainFrame = MainFrame

    -- Atmosphere Red Smoke / Nebula Orbs
    local BackdropLayer = create("Frame", {
        Name = "BackdropLayer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 1
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 18) })
    })
    BackdropLayer.Parent = MainFrame

    local function createCrimsonNebulaOrb(name, color, size, pos, baseTrans)
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
                    NumberSequenceKeypoint.new(0, 0.35),
                    NumberSequenceKeypoint.new(0.5, 0.75),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
        })
        orb.Parent = BackdropLayer
        return orb
    end

    local OrbRed1 = createCrimsonNebulaOrb("OrbRed1", Library.Theme.RedPrimary, UDim2.new(0, 380, 0, 380), UDim2.new(0.12, 0, 0.2, 0), 0.58)
    local OrbRed2 = createCrimsonNebulaOrb("OrbRed2", Library.Theme.RedDark, UDim2.new(0, 420, 0, 420), UDim2.new(0.88, 0, 0.8, 0), 0.60)
    local OrbSteel = createCrimsonNebulaOrb("OrbSteel", Library.Theme.SteelDark, UDim2.new(0, 300, 0, 300), UDim2.new(0.5, 0, 0.5, 0), 0.70)

    local GlassOverlay = create("Frame", {
        Name = "GlassOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Library.Theme.Base,
        BackgroundTransparency = 0.45,
        ZIndex = 2
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 18) })
    })
    GlassOverlay.Parent = BackdropLayer

    addNightStroke(MainFrame, 1.2, 0.25, true)

    -- Sanfter Red-Smoke Drift
    local smokeStep = 0
    RunService.RenderStepped:Connect(function(dt)
        smokeStep = smokeStep + dt * 0.4
        OrbRed1.Position = UDim2.new(
            0.12 + math.sin(smokeStep * 0.7) * 0.08, 0,
            0.20 + math.cos(smokeStep * 0.5) * 0.08, 0
        )
        OrbRed2.Position = UDim2.new(
            0.88 + math.cos(smokeStep * 0.6) * 0.08, 0,
            0.80 + math.sin(smokeStep * 0.8) * 0.08, 0
        )
        for _, grad in ipairs(animatedStrokes) do
            grad.Rotation = (grad.Rotation + dt * 15) % 360
        end
    end)

    -- Window Dragging
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
        BackgroundColor3 = Color3.fromRGB(12, 13, 18),
        BackgroundTransparency = 0.35,
        ZIndex = 10
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 18) }),
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
        Size = UDim2.new(0, 240, 1, 0),
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

    -- Metallisches Night System "N" Logo Badge
    local LogoContainer = create("Frame", {
        Name = "LogoContainer",
        Size = UDim2.new(0, 34, 0, 34),
        BackgroundColor3 = Library.Theme.Elevated,
        BackgroundTransparency = 0.2,
        ZIndex = 12
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) })
    })
    addNightStroke(LogoContainer, 1.2, 0.2, true)
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
            Text = "N",
            TextColor3 = Library.Theme.RedPrimary,
            TextSize = 18,
            ZIndex = 13,
            Parent = LogoContainer
        })
    end

    local BrandTextGroup = create("Frame", {
        Name = "BrandTextGroup",
        Size = UDim2.new(0, 180, 1, 0),
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
            TextColor3 = Library.Theme.RedPrimary,
            TextSize = 9.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        })
    })
    BrandTextGroup.Parent = BrandSection

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
            Size = UDim2.new(0, 72, 0, 26),
            BackgroundColor3 = Library.Theme.Elevated,
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
                ImageColor3 = Library.Theme.RedPrimary,
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
        addNightStroke(pill, 1, 0.6, false)
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
            BackgroundColor3 = Library.Theme.Elevated,
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
        addNightStroke(btn, 1, 0.6, false)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.RedPrimary, BackgroundTransparency = 0.2 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.Elevated, BackgroundTransparency = 0.45 }):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local BodyContainer = create("Frame", {
        Name = "BodyContainer",
        Size = UDim2.new(1, 0, 1, -54),
        Position = UDim2.new(0, 0, 0, 54),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 5
    })
    BodyContainer.Parent = MainFrame
    Window.BodyContainer = BodyContainer

    local MinBtn = createNavBtn("MinBtn", Library.Icons.Minimize, function()
        Window._isMinimized = not Window._isMinimized
        if Window._isMinimized then
            BodyContainer.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 840, 0, 54)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 840, 0, 540)
            }):Play()
            task.delay(0.08, function()
                if not Window._isMinimized then BodyContainer.Visible = true end
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

    -- Sidebar (Tabs)
    local TabSidebar = create("ScrollingFrame", {
        Name = "TabSidebar",
        Size = UDim2.new(0, 185, 1, -16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundColor3 = Library.Theme.Sidebar,
        BackgroundTransparency = 0.45,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.RedPrimary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 6
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 14) }),
        create("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8)
        }),
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
    })
    addNightStroke(TabSidebar, 1, 0.6, false)
    TabSidebar.Parent = BodyContainer

    -- Page Container
    local ContentContainer = create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -217, 1, -16),
        Position = UDim2.new(0, 205, 0, 8),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 6
    })
    ContentContainer.Parent = BodyContainer

    -- ================================================================
    -- TAB SYSTEM (Window:MakeTab)
    -- ================================================================
    function Window:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or tabConfig.Title or "Tab"
        local tabIcon = tabConfig.Icon or tabConfig.Image or Library.Icons.Sparkle

        local Tab = {
            Name = tabName,
            Elements = {}
        }

        local TabPage = create("ScrollingFrame", {
            Name = "Page_" .. tabName,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.Theme.RedPrimary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 7
        }, {
            create("UIPadding", {
                PaddingTop = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 8)
            }),
            create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
        })
        TabPage.Parent = ContentContainer
        Tab.Page = TabPage

        local TabBtn = create("TextButton", {
            Name = "TabBtn_" .. tabName,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Library.Theme.Elevated,
            BackgroundTransparency = 0.75,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 7
        }, {
            create("UICorner", { CornerRadius = UDim.new(0, 10) }),
            create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8) }),
            create("ImageLabel", {
                Name = "TabIcon",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 0, 0.5, -8),
                BackgroundTransparency = 1,
                Image = tabIcon,
                ImageColor3 = Library.Theme.TextSecondary,
                ZIndex = 8
            }),
            create("TextLabel", {
                Name = "TabLabel",
                Size = UDim2.new(1, -26, 1, 0),
                Position = UDim2.new(0, 26, 0, 0),
                BackgroundTransparency = 1,
                Font = Library.Theme.FontMedium,
                Text = tabName,
                TextColor3 = Library.Theme.TextSecondary,
                TextSize = 11.5,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 8
            })
        })
        addNightStroke(TabBtn, 1, 0.8, false)
        TabBtn.Parent = TabSidebar
        Tab.Button = TabBtn

        local function activateTab()
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.Page.Visible = false
                TweenService:Create(otherTab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Elevated,
                    BackgroundTransparency = 0.75
                }):Play()
                local lbl = otherTab.Button:FindFirstChild("TabLabel")
                local ico = otherTab.Button:FindFirstChild("TabIcon")
                if lbl then lbl.TextColor3 = Library.Theme.TextSecondary end
                if ico then ico.ImageColor3 = Library.Theme.TextSecondary end
            end

            TabPage.Visible = true
            Window.ActiveTab = Tab
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Elevated,
                BackgroundTransparency = 0.15
            }):Play()
            local lbl = TabBtn:FindFirstChild("TabLabel")
            local ico = TabBtn:FindFirstChild("TabIcon")
            if lbl then lbl.TextColor3 = Library.Theme.SteelLight end
            if ico then ico.ImageColor3 = Library.Theme.RedPrimary end
        end

        TabBtn.MouseButton1Click:Connect(activateTab)

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            activateTab()
        end

        -- 1. SECTION
        function Tab:AddSection(secConfig)
            local title = type(secConfig) == "table" and (secConfig.Name or secConfig.Title) or tostring(secConfig or "Section")
            local sectionFrame = create("Frame", {
                Name = "Section_" .. title,
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                ZIndex = 8
            }, {
                create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontBold,
                    Text = string.upper(title),
                    TextColor3 = Library.Theme.RedPrimary,
                    TextSize = 10.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
            })
            sectionFrame.Parent = TabPage
            return sectionFrame
        end

        -- 2. BUTTON
        function Tab:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local btnName = btnConfig.Name or btnConfig.Title or "Button"
            local callback = btnConfig.Callback or function() end

            local btnCard = create("TextButton", {
                Name = "BtnCard_" .. btnName,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Library.Theme.Card,
                BackgroundTransparency = 0.35,
                AutoButtonColor = false,
                Text = "",
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
                create("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = btnName,
                    TextColor3 = Library.Theme.TextWhite,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                }),
                create("ImageLabel", {
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Image = Library.Icons.Sparkle,
                    ImageColor3 = Library.Theme.RedPrimary,
                    ZIndex = 9
                })
            })
            addNightStroke(btnCard, 1, 0.55, false)
            btnCard.Parent = TabPage

            btnCard.MouseEnter:Connect(function()
                TweenService:Create(btnCard, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.Elevated, BackgroundTransparency = 0.15 }):Play()
            end)
            btnCard.MouseLeave:Connect(function()
                TweenService:Create(btnCard, TweenInfo.new(0.18), { BackgroundColor3 = Library.Theme.Card, BackgroundTransparency = 0.35 }):Play()
            end)
            btnCard.MouseButton1Click:Connect(function()
                callback()
            end)

            return {
                Set = function(self, newText)
                    local lbl = btnCard:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = tostring(newText) end
                end
            }
        end

        -- 3. TOGGLE
        function Tab:AddToggle(togConfig)
            togConfig = togConfig or {}
            local togName = togConfig.Name or togConfig.Title or "Toggle"
            local state = (togConfig.Default == true)
            local callback = togConfig.Callback or function(val) end

            local togCard = create("TextButton", {
                Name = "TogCard_" .. togName,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Library.Theme.Card,
                BackgroundTransparency = 0.35,
                AutoButtonColor = false,
                Text = "",
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
                create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = togName,
                    TextColor3 = Library.Theme.TextWhite,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
            })
            addNightStroke(togCard, 1, 0.55, false)
            togCard.Parent = TabPage

            local switchBg = create("Frame", {
                Name = "SwitchBg",
                Size = UDim2.new(0, 40, 0, 20),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = state and Library.Theme.RedPrimary or Color3.fromRGB(28, 30, 40),
                ZIndex = 9
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
            switchBg.Parent = togCard

            local switchKnob = create("Frame", {
                Name = "Knob",
                Size = UDim2.new(0, 16, 0, 16),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                BackgroundColor3 = state and Library.Theme.TextWhite or Color3.fromRGB(180, 185, 200),
                ZIndex = 10
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
            switchKnob.Parent = switchBg

            local function updateToggle(newState)
                state = newState
                TweenService:Create(switchBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Library.Theme.RedPrimary or Color3.fromRGB(28, 30, 40)
                }):Play()
                TweenService:Create(switchKnob, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    BackgroundColor3 = state and Library.Theme.TextWhite or Color3.fromRGB(180, 185, 200)
                }):Play()
                pcall(callback, state)
            end

            togCard.MouseButton1Click:Connect(function()
                updateToggle(not state)
            end)

            return {
                Set = function(self, newVal)
                    updateToggle(newVal)
                end,
                Value = state
            }
        end

        -- 4. SLIDER
        function Tab:AddSlider(sldConfig)
            sldConfig = sldConfig or {}
            local sldName = sldConfig.Name or sldConfig.Title or "Slider"
            local min = sldConfig.Min or 0
            local max = sldConfig.Max or 100
            local default = sldConfig.Default or min
            local increment = sldConfig.Increment or 1
            local valueName = sldConfig.ValueName or ""
            local callback = sldConfig.Callback or function(val) end

            local currentVal = math.clamp(default, min, max)

            local sldCard = create("Frame", {
                Name = "SldCard_" .. sldName,
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = Library.Theme.Card,
                BackgroundTransparency = 0.35,
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) }),
                create("TextLabel", {
                    Size = UDim2.new(0.7, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = sldName,
                    TextColor3 = Library.Theme.TextWhite,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
            })
            addNightStroke(sldCard, 1, 0.55, false)
            sldCard.Parent = TabPage

            local valLabel = create("TextLabel", {
                Size = UDim2.new(0.3, 0, 0, 16),
                Position = UDim2.new(0.7, 0, 0, 0),
                BackgroundTransparency = 1,
                Font = Library.Theme.FontBold,
                Text = tostring(currentVal) .. valueName,
                TextColor3 = Library.Theme.RedPrimary,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 9
            })
            valLabel.Parent = sldCard

            local trackBar = create("Frame", {
                Name = "Track",
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 1, -8),
                BackgroundColor3 = Color3.fromRGB(24, 26, 36),
                ZIndex = 9
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
            trackBar.Parent = sldCard

            local fillBar = create("Frame", {
                Name = "Fill",
                Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Library.Theme.RedPrimary,
                ZIndex = 10
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library.Theme.RedLight),
                        ColorSequenceKeypoint.new(1, Library.Theme.RedDark)
                    })
                })
            })
            fillBar.Parent = trackBar

            local sldDragging = false

            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - trackBar.AbsolutePosition.X) / trackBar.AbsoluteSize.X, 0, 1)
                local rawVal = min + (max - min) * pos
                local steppedVal = math.floor(rawVal / increment + 0.5) * increment
                steppedVal = math.clamp(steppedVal, min, max)

                currentVal = steppedVal
                valLabel.Text = tostring(currentVal) .. valueName
                TweenService:Create(fillBar, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
                    Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
                }):Play()

                pcall(callback, currentVal)
            end

            trackBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sldDragging = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sldDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sldDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            return {
                Set = function(self, newVal)
                    currentVal = math.clamp(newVal, min, max)
                    valLabel.Text = tostring(currentVal) .. valueName
                    fillBar.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
                    pcall(callback, currentVal)
                end,
                Value = currentVal
            }
        end

        -- 5. DROPDOWN
        function Tab:AddDropdown(ddConfig)
            ddConfig = ddConfig or {}
            local ddName = ddConfig.Name or ddConfig.Title or "Dropdown"
            local options = ddConfig.Options or {}
            local default = ddConfig.Default or options[1] or ""
            local callback = ddConfig.Callback or function(val) end

            local currentOption = default
            local isExpanded = false

            local ddCard = create("Frame", {
                Name = "DDCard_" .. ddName,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Library.Theme.Card,
                BackgroundTransparency = 0.35,
                ClipsDescendants = true,
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 10) })
            })
            addNightStroke(ddCard, 1, 0.55, false)
            ddCard.Parent = TabPage

            local headerBtn = create("TextButton", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 9
            }, {
                create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
                create("TextLabel", {
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = ddName,
                    TextColor3 = Library.Theme.TextWhite,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 10
                }),
                create("TextLabel", {
                    Name = "SelectedLabel",
                    Size = UDim2.new(0.5, -24, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontBold,
                    Text = tostring(currentOption),
                    TextColor3 = Library.Theme.RedPrimary,
                    TextSize = 11,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 10
                }),
                create("ImageLabel", {
                    Name = "Chevron",
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Image = Library.Icons.ChevronDown,
                    ImageColor3 = Library.Theme.TextSecondary,
                    ZIndex = 10
                })
            })
            headerBtn.Parent = ddCard

            local optionList = create("Frame", {
                Name = "OptionList",
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, 42),
                BackgroundTransparency = 1,
                ZIndex = 9
            }, {
                create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                })
            })
            optionList.Parent = ddCard

            local function renderOptions()
                for _, child in ipairs(optionList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end

                for idx, opt in ipairs(options) do
                    local optBtn = create("TextButton", {
                        Name = "Opt_" .. tostring(opt),
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = (opt == currentOption) and Library.Theme.RedDark or Library.Theme.Input,
                        BackgroundTransparency = 0.3,
                        AutoButtonColor = false,
                        Text = "",
                        LayoutOrder = idx,
                        ZIndex = 10
                    }, {
                        create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                        create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
                        create("TextLabel", {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Font = (opt == currentOption) and Library.Theme.FontBold or Library.Theme.FontRegular,
                            Text = tostring(opt),
                            TextColor3 = (opt == currentOption) and Library.Theme.TextWhite or Library.Theme.TextBody,
                            TextSize = 10.5,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 11
                        })
                    })
                    optBtn.Parent = optionList

                    optBtn.MouseButton1Click:Connect(function()
                        currentOption = opt
                        local selLbl = headerBtn:FindFirstChild("SelectedLabel")
                        if selLbl then selLbl.Text = tostring(currentOption) end
                        
                        isExpanded = false
                        TweenService:Create(ddCard, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, 38)
                        }):Play()
                        renderOptions()
                        pcall(callback, currentOption)
                    end)
                end
            end

            renderOptions()

            headerBtn.MouseButton1Click:Connect(function()
                isExpanded = not isExpanded
                local targetHeight = isExpanded and (44 + #options * 32) or 38
                local chevron = headerBtn:FindFirstChild("Chevron")
                if chevron then
                    TweenService:Create(chevron, TweenInfo.new(0.2), {
                        Rotation = isExpanded and 180 or 0
                    }):Play()
                end
                TweenService:Create(ddCard, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, targetHeight)
                }):Play()
            end)

            return {
                Set = function(self, newVal)
                    currentOption = newVal
                    local selLbl = headerBtn:FindFirstChild("SelectedLabel")
                    if selLbl then selLbl.Text = tostring(currentOption) end
                    renderOptions()
                    pcall(callback, currentOption)
                end,
                Refresh = function(self, newOpts, clear)
                    options = newOpts or {}
                    if clear then currentOption = options[1] or "" end
                    local selLbl = headerBtn:FindFirstChild("SelectedLabel")
                    if selLbl then selLbl.Text = tostring(currentOption) end
                    renderOptions()
                end,
                Value = currentOption
            }
        end

        -- 6. TEXTBOX
        function Tab:AddTextbox(tbConfig)
            tbConfig = tbConfig or {}
            local tbName = tbConfig.Name or tbConfig.Title or "Textbox"
            local default = tbConfig.Default or ""
            local placeholder = tbConfig.Placeholder or "Enter text..."
            local clearOnFocus = (tbConfig.TextDisappear == true)
            local callback = tbConfig.Callback or function(val) end

            local tbCard = create("Frame", {
                Name = "TBCard_" .. tbName,
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Library.Theme.Card,
                BackgroundTransparency = 0.35,
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
                create("TextLabel", {
                    Size = UDim2.new(0.45, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = tbName,
                    TextColor3 = Library.Theme.TextWhite,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
            })
            addNightStroke(tbCard, 1, 0.55, false)
            tbCard.Parent = TabPage

            local boxContainer = create("Frame", {
                Size = UDim2.new(0.55, 0, 0, 28),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Library.Theme.Input,
                BackgroundTransparency = 0.3,
                ZIndex = 9
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
            })
            boxContainer.Parent = tbCard

            local box = create("TextBox", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Library.Theme.FontRegular,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Library.Theme.TextMuted,
                Text = default,
                TextColor3 = Library.Theme.SteelLight,
                TextSize = 10.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = clearOnFocus,
                ZIndex = 10
            })
            box.Parent = boxContainer

            box.FocusLost:Connect(function()
                pcall(callback, box.Text)
            end)

            return {
                Set = function(self, newVal)
                    box.Text = tostring(newVal)
                    pcall(callback, box.Text)
                end,
                Value = box.Text
            }
        end

        -- 7. KEYBIND
        function Tab:AddBind(bindConfig)
            bindConfig = bindConfig or {}
            local bindName = bindConfig.Name or bindConfig.Title or "Keybind"
            local default = bindConfig.Default or Enum.KeyCode.E
            local callback = bindConfig.Callback or function() end

            local currentKey = default
            local isListening = false

            local bindCard = create("Frame", {
                Name = "BindCard_" .. bindName,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Library.Theme.Card,
                BackgroundTransparency = 0.35,
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
                create("TextLabel", {
                    Size = UDim2.new(1, -80, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = bindName,
                    TextColor3 = Library.Theme.TextWhite,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
            })
            addNightStroke(bindCard, 1, 0.55, false)
            bindCard.Parent = TabPage

            local bindBtn = create("TextButton", {
                Size = UDim2.new(0, 68, 0, 24),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Library.Theme.Input,
                BackgroundTransparency = 0.3,
                Font = Library.Theme.FontBold,
                Text = currentKey.Name,
                TextColor3 = Library.Theme.RedPrimary,
                TextSize = 10,
                AutoButtonColor = false,
                ZIndex = 9
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 6) })
            })
            bindBtn.Parent = bindCard

            bindBtn.MouseButton1Click:Connect(function()
                isListening = true
                bindBtn.Text = "..."
                bindBtn.TextColor3 = Library.Theme.StatusGreen
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if isListening and not gpe then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        bindBtn.Text = currentKey.Name
                        bindBtn.TextColor3 = Library.Theme.RedPrimary
                        isListening = false
                    end
                elseif not gpe and input.KeyCode == currentKey then
                    pcall(callback)
                end
            end)

            return {
                Set = function(self, newKey)
                    currentKey = newKey
                    bindBtn.Text = currentKey.Name
                end,
                Value = currentKey
            }
        end

        -- 8. PARAGRAPH
        function Tab:AddParagraph(pConfig)
            pConfig = pConfig or {}
            local pTitle = pConfig.Title or pConfig.Name or "Info"
            local pContent = pConfig.Content or pConfig.Text or ""

            local pCard = create("Frame", {
                Name = "PCard_" .. pTitle,
                Size = UDim2.new(1, 0, 0, 54),
                BackgroundColor3 = Library.Theme.Card,
                BackgroundTransparency = 0.45,
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 10) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) }),
                create("TextLabel", {
                    Name = "Title",
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontBold,
                    Text = pTitle,
                    TextColor3 = Library.Theme.RedPrimary,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                }),
                create("TextLabel", {
                    Name = "Content",
                    Size = UDim2.new(1, 0, 0, 24),
                    Position = UDim2.new(0, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontRegular,
                    Text = pContent,
                    TextColor3 = Library.Theme.TextSecondary,
                    TextSize = 10,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
            })
            addNightStroke(pCard, 1, 0.6, false)
            pCard.Parent = TabPage

            return {
                Set = function(self, newContent)
                    local cnt = pCard:FindFirstChild("Content")
                    if cnt then cnt.Text = tostring(newContent) end
                end
            }
        end

        -- 9. LABEL
        function Tab:AddLabel(labelText)
            local lblCard = create("Frame", {
                Name = "LabelCard",
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Library.Theme.Input,
                BackgroundTransparency = 0.5,
                ZIndex = 8
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
                create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Library.Theme.FontMedium,
                    Text = tostring(labelText),
                    TextColor3 = Library.Theme.TextBody,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
            })
            lblCard.Parent = TabPage
            return {
                Set = function(self, newText)
                    local txt = lblCard:FindFirstChild("Text")
                    if txt then txt.Text = tostring(newText) end
                end
            }
        end

        return Tab
    end

    -- ================================================================
    -- 🎬 4-SEKUNDEN NIGHT SYSTEM CINEMATIC LOADER
    -- (Crimson Red Inward Screen Glow & Metallic "N" Logo Backlight)
    -- ================================================================
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

            local GlowCrimson1 = Color3.fromRGB(255, 35, 55)
            local GlowCrimson2 = Color3.fromRGB(170, 15, 30)

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

            -- 4 Crimson Inward Glows (alle 4 Seiten)
            local TopInwardGlow    = createInwardGlow("TopInwardGlow",    UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 0, 0),      GlowCrimson1, GlowCrimson2, 90)
            local RightInwardGlow  = createInwardGlow("RightInwardGlow",  UDim2.new(0, 220, 1, 0), UDim2.new(1, -220, 0, 0),   GlowCrimson1, GlowCrimson2, 180)
            local BottomInwardGlow = createInwardGlow("BottomInwardGlow", UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 1, -220),   GlowCrimson1, GlowCrimson2, 270)
            local LeftInwardGlow   = createInwardGlow("LeftInwardGlow",   UDim2.new(0, 220, 1, 0), UDim2.new(0, 0, 0, 0),      GlowCrimson1, GlowCrimson2, 0)

            TweenService:Create(TopInwardGlow,    TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(RightInwardGlow,  TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(BottomInwardGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(LeftInwardGlow,   TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()

            local breathStep = 0
            local breathingConn
            breathingConn = RunService.RenderStepped:Connect(function(dt)
                breathStep = breathStep + dt * 2.2
                local breathFactor = (math.sin(breathStep) + 1) * 0.5
                local inwardTrans = 0.0 + (1 - breathFactor) * 0.35
                TopInwardGlow.BackgroundTransparency    = inwardTrans
                RightInwardGlow.BackgroundTransparency  = inwardTrans
                BottomInwardGlow.BackgroundTransparency = inwardTrans
                LeftInwardGlow.BackgroundTransparency   = inwardTrans
            end)

            -- Metallic "N" Emblem mit Crimson Backlight
            local LogoBackglow = create("Frame", {
                Name = "LogoBackglow",
                Size = UDim2.new(0, 220, 0, 220),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.44, 0),
                BackgroundColor3 = GlowCrimson1,
                BackgroundTransparency = 0.7,
                ZIndex = 205
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                create("UIGradient", {
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.2),
                        NumberSequenceKeypoint.new(0.6, 0.7),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                })
            })
            LogoBackglow.Parent = IntroOverlay

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
                    Text = "N",
                    TextColor3 = Library.Theme.SteelLight,
                    TextSize = 140,
                    TextTransparency = 1,
                    ZIndex = 208
                })
                GiantFallbackText.Parent = GiantLogo
            end

            local IntroTitle = create("TextLabel", {
                Size = UDim2.new(0, 480, 0, 36),
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

            -- Crimson Ladebalken
            local ProgressTrack = create("Frame", {
                Name = "ProgressTrack",
                Size = UDim2.new(0, 260, 0, 5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.76, 0),
                BackgroundColor3 = Color3.fromRGB(20, 22, 30),
                BackgroundTransparency = 0.4,
                ZIndex = 210
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
            ProgressTrack.Parent = IntroOverlay

            local ProgressBar = create("Frame", {
                Name = "ProgressBar",
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Library.Theme.RedPrimary,
                ZIndex = 211
            }, {
                create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library.Theme.RedLight),
                        ColorSequenceKeypoint.new(1, Library.Theme.RedDark)
                    })
                })
            })
            ProgressBar.Parent = ProgressTrack

            task.wait(0.15)
            TweenService:Create(GiantLogo, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 300),
                ImageTransparency = 0.1
            }):Play()
            if GiantFallbackText then
                TweenService:Create(GiantFallbackText, TweenInfo.new(0.8), { TextTransparency = 0.1 }):Play()
            end
            TweenService:Create(IntroTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()

            local loadTime = math.max(1, IntroDuration - 0.5)
            TweenService:Create(ProgressBar, TweenInfo.new(loadTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(1, 0, 1, 0)
            }):Play()

            task.wait(loadTime)

            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 800, 0, 500)
            MainFrame.BackgroundTransparency = 0.7

            TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 840, 0, 540),
                BackgroundTransparency = 0.08
            }):Play()

            TweenService:Create(GiantLogo, TweenInfo.new(0.4), { ImageTransparency = 1, Size = UDim2.new(0, 340, 0, 340) }):Play()
            TweenService:Create(LogoBackglow, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
            if GiantFallbackText then TweenService:Create(GiantFallbackText, TweenInfo.new(0.4), { TextTransparency = 1 }):Play() end
            TweenService:Create(IntroTitle, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
            TweenService:Create(ProgressTrack, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(ProgressBar, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()

            TweenService:Create(TopInwardGlow,    TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(BottomInwardGlow, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(LeftInwardGlow,   TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(RightInwardGlow,  TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()

            task.wait(0.55)
            if breathingConn then breathingConn:Disconnect() end
            IntroOverlay:Destroy()

            Library:Notify({
                Title = Title,
                Content = "Night System Initialized. Welcome, " .. (LocalPlayer.DisplayName or "User"),
                Duration = 3.5
            })
        end)
    end

    -- Live Session Time & Ping Monitor
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

function Library:Init()
    return true
end

return Library
