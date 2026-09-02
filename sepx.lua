--[[
    ═══════════════════════════════════════════════════════════════════
    ███████╗███████╗██████╗ ██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██╔════╝██╔══██╗╚██╗██╔╝    ██║  ██║██║   ██║██╔══██╗
    ███████╗█████╗  ██████╔╝ ╚███╔╝     ███████║██║   ██║██████╔╝
    ╚════██║██╔══╝  ██╔═══╝  ██╔██╗     ██╔══██║██║   ██║██╔══██╗
    ███████║███████╗██║     ██╔╝ ██╗    ██║  ██║╚██████╔╝██████╔╝
    ═══════════════════════════════════════════════════════════════════
    SEPX Enterprise Hub - Multi-Language Studio Edition
    Auto Roblox Language Detection (DE/EN/ES/FR/PT/RU) • Smooth 60fps Loader
    Clean Minimalist Luxury SaaS • Google Sans Typography
    ═══════════════════════════════════════════════════════════════════
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Universal Safe Container Selection
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

-- Cleanup prior instances
if ParentContainer:FindFirstChild("SEPX_Enterprise_Hub") then
    ParentContainer:FindFirstChild("SEPX_Enterprise_Hub"):Destroy()
end

-- ═══════════════════════════════════════════════════════════════════
-- 🌐 AUTO ROBLOX LANGUAGE DETECTION & LOCALIZATION
-- ═══════════════════════════════════════════════════════════════════
local detectedLang = "en"
pcall(function()
    local raw = LocalizationService.RobloxLocaleId
    if not raw or raw == "" then raw = LocalizationService.SystemLocaleId end
    if not raw or raw == "" then raw = LocalPlayer.LocaleId end
    if raw and raw ~= "" then
        detectedLang = string.lower(string.sub(raw, 1, 2))
    end
end)

local LangDict = {
    de = {
        BrandSubtitle = "Schlüssel- & Lizenzsystem",
        ActivationTitle = "Lizenzaktivierung",
        ActivationSubtitle = "Gib deinen Lizenzschlüssel ein, um fortzufahren.",
        KeyPlaceholder = "Lizenzschlüssel hier einfügen...",
        PasteBtn = "EINFÜGEN",
        LaunchBtn = "CHECK KEY",
        GetKeyBtn = "KEY HOLEN",
        Discord = "Discord",
        CopyHwid = "HWID kopieren",
        Settings = "Einstellungen",
        VipTitle = "SecretExploits VIP Lifetime",
        VipSubtitle = "Direkter Keyless-Zugriff & Premium-Funktionen",
        UpgradeBtn = "UPGRADE",
        StatusReady = "Verbunden",
        Verified = "VERIFIZIERT",
        Game = "SPIEL",
        PlaceId = "PLACE ID",
        Executor = "EXECUTOR",
        Hwid = "HWID",
        Device = "GERÄT",
        Status = "STATUS",
        CopyUserId = "USER ID KOPIEREN",
        Loading = "Lade SecretExploits Hub... %d%%",
        Preparing = "Bereite Arbeitsbereich vor...",
        Ready = "Bereit • 100%",
        Welcome = "Willkommen bei SecretExploits",
        WelcomeNotif = "SecretExploits Hub geladen. Willkommen, %s!",
        KeyRequired = "Schlüssel erforderlich",
        KeyRequiredMsg = "Bitte gib zuerst deinen SecretExploits Lizenzschlüssel ein.",
        Verifying = "Schlüssel wird geprüft",
        VerifyingMsg = "Überprüfe Lizenzstatus...",
        Success = "Erfolgreich",
        SuccessMsg = "Willkommen zurück! SecretExploits erfolgreich geladen.",
        KeyPasted = "Eingefügt",
        KeyPastedMsg = "Schlüssel aus der Zwischenablage eingefügt!",
        Copied = "Kopiert",
        CopiedMsg = "%s in die Zwischenablage kopiert!"
    },
    en = {
        BrandSubtitle = "Key & License System",
        ActivationTitle = "License Activation",
        ActivationSubtitle = "Enter your license key to unlock and launch the script.",
        KeyPlaceholder = "Paste your license key here...",
        PasteBtn = "PASTE",
        LaunchBtn = "CHECK KEY",
        GetKeyBtn = "GET KEY",
        Discord = "Discord",
        CopyHwid = "Copy HWID",
        Settings = "Settings",
        VipTitle = "SecretExploits VIP Lifetime",
        VipSubtitle = "Direct keyless access & premium features",
        UpgradeBtn = "UPGRADE",
        StatusReady = "Connected",
        Verified = "VERIFIED",
        Game = "GAME",
        PlaceId = "PLACE ID",
        Executor = "EXECUTOR",
        Hwid = "HWID",
        Device = "DEVICE",
        Status = "STATUS",
        CopyUserId = "COPY USER ID",
        Loading = "Loading SecretExploits Hub... %d%%",
        Preparing = "Preparing workspace...",
        Ready = "Ready • 100%",
        Welcome = "Welcome to SecretExploits",
        WelcomeNotif = "SecretExploits Hub initialized. Welcome, %s!",
        KeyRequired = "Key Required",
        KeyRequiredMsg = "Please enter your SecretExploits license key first.",
        Verifying = "Verifying Key",
        VerifyingMsg = "Checking license status...",
        Success = "Success",
        SuccessMsg = "Welcome back! SecretExploits loaded successfully.",
        KeyPasted = "Pasted",
        KeyPastedMsg = "License key pasted from clipboard!",
        Copied = "Copied",
        CopiedMsg = "%s copied to clipboard!"
    },
    es = {
        BrandSubtitle = "Sistema de Licencias y Claves",
        ActivationTitle = "Activación de Licencia",
        ActivationSubtitle = "Introduce tu clave para desbloquear el script.",
        KeyPlaceholder = "Pega tu clave de licencia aquí...",
        PasteBtn = "PEGAR",
        LaunchBtn = "ACTIVAR Y EJECUTAR",
        GetKeyBtn = "OBTENER CLAVE",
        Discord = "Discord",
        CopyHwid = "Copiar HWID",
        Settings = "Ajustes",
        VipTitle = "Pase Premium SEPX",
        VipSubtitle = "Acceso directo sin clave y funciones premium",
        UpgradeBtn = "MEJORAR",
        StatusReady = "Conectado",
        Verified = "VERIFICADO",
        Game = "JUEGO",
        PlaceId = "PLACE ID",
        Executor = "EJECUTOR",
        Hwid = "HWID",
        Device = "DISPOSITIVO",
        Status = "ESTADO",
        CopyUserId = "COPIAR ID DE USUARIO",
        Loading = "Cargando SEPX Hub... %d%%",
        Preparing = "Preparando espacio de trabajo...",
        Ready = "Listo • 100%",
        Welcome = "Bienvenido a SEPX",
        WelcomeNotif = "Hub inicializado. ¡Bienvenido, %s!",
        KeyRequired = "Clave requerida",
        KeyRequiredMsg = "Por favor introduce tu clave de licencia primero.",
        Verifying = "Verificando Clave",
        VerifyingMsg = "Comprobando estado de licencia...",
        Success = "Éxito",
        SuccessMsg = "¡Bienvenido! SEPX cargado con éxito.",
        KeyPasted = "Pegado",
        KeyPastedMsg = "¡Clave pegada desde el portapapeles!",
        Copied = "Copiado",
        CopiedMsg = "¡%s copiado al portapapeles!"
    },
    fr = {
        BrandSubtitle = "Système de Clés & Licences",
        ActivationTitle = "Activation de Licence",
        ActivationSubtitle = "Entrez votre clé de licence pour déverrouiller le script.",
        KeyPlaceholder = "Collez votre clé de licence ici...",
        PasteBtn = "COLLER",
        LaunchBtn = "ACTIVER ET LANCER",
        GetKeyBtn = "OBTENIR CLÉ",
        Discord = "Discord",
        CopyHwid = "Copier HWID",
        Settings = "Paramètres",
        VipTitle = "Pass Premium SEPX",
        VipSubtitle = "Accès direct sans clé & fonctionnalités premium",
        UpgradeBtn = "AMÉLIORER",
        StatusReady = "Connecté",
        Verified = "VÉRIFIÉ",
        Game = "JEU",
        PlaceId = "PLACE ID",
        Executor = "EXÉCUTEUR",
        Hwid = "HWID",
        Device = "APPAREIL",
        Status = "STATUT",
        CopyUserId = "COPIER ID UTILISATEUR",
        Loading = "Chargement de SEPX Hub... %d%%",
        Preparing = "Préparation de l'espace de travail...",
        Ready = "Prêt • 100%",
        Welcome = "Bienvenue sur SEPX",
        WelcomeNotif = "Hub initialisé. Bienvenue, %s !",
        KeyRequired = "Clé requise",
        KeyRequiredMsg = "Veuillez entrer votre clé de licence SEPX.",
        Verifying = "Vérification de la clé",
        VerifyingMsg = "Vérification de la licence...",
        Success = "Succès",
        SuccessMsg = "Bienvenue ! SEPX chargé avec succès.",
        KeyPasted = "Collé",
        KeyPastedMsg = "Clé collée depuis le presse-papiers !",
        Copied = "Copié",
        CopiedMsg = "%s copié dans le presse-papiers !"
    },
    pt = {
        BrandSubtitle = "Sistema de Licenças e Chaves",
        ActivationTitle = "Ativação de Licença",
        ActivationSubtitle = "Insira sua chave para desbloquear o script.",
        KeyPlaceholder = "Cole sua chave de licença aqui...",
        PasteBtn = "COLAR",
        LaunchBtn = "ATIVAR E INICIAR",
        GetKeyBtn = "OBTER CHAVE",
        Discord = "Discord",
        CopyHwid = "Copiar HWID",
        Settings = "Configurações",
        VipTitle = "Passe Premium SEPX",
        VipSubtitle = "Acesso direto sem chave e recursos premium",
        UpgradeBtn = "UPGRADE",
        StatusReady = "Conectado",
        Verified = "VERIFICADO",
        Game = "JOGO",
        PlaceId = "PLACE ID",
        Executor = "EXECUTOR",
        Hwid = "HWID",
        Device = "DISPOSITIVO",
        Status = "STATUS",
        CopyUserId = "COPIAR ID DO USUÁRIO",
        Loading = "Carregando SEPX Hub... %d%%",
        Preparing = "Preparando espaço de trabalho...",
        Ready = "Pronto • 100%",
        Welcome = "Bem-vindo ao SEPX",
        WelcomeNotif = "Hub inicializado. Bem-vindo, %s!",
        KeyRequired = "Chave Necessária",
        KeyRequiredMsg = "Por favor, insira sua chave primeiro.",
        Verifying = "Verificando Chave",
        VerifyingMsg = "Verificando status da licença...",
        Success = "Sucesso",
        SuccessMsg = "Bem-vindo de volta! SEPX carregado com sucesso.",
        KeyPasted = "Colado",
        KeyPastedMsg = "Chave colada da área de transferência!",
        Copied = "Copiado",
        CopiedMsg = "%s copiado para a área de transferência!"
    },
    ru = {
        BrandSubtitle = "Система Лицензий и Ключей",
        ActivationTitle = "Активация Лицензии",
        ActivationSubtitle = "Введите ваш ключ для разблокировки скрипта.",
        KeyPlaceholder = "Вставьте ключ лицензии сюда...",
        PasteBtn = "ВСТАВИТЬ",
        LaunchBtn = "АКТИВИРОВАТЬ И ЗАПУСТИТЬ",
        GetKeyBtn = "ПОЛУЧИТЬ КЛЮЧ",
        Discord = "Discord",
        CopyHwid = "Копировать HWID",
        Settings = "Настройки",
        VipTitle = "Премиум SEPX Pass",
        VipSubtitle = "Прямой доступ без ключа и премиум функции",
        UpgradeBtn = "УЛУЧШИТЬ",
        StatusReady = "Подключено",
        Verified = "ПРОВЕРЕНО",
        Game = "ИГРА",
        PlaceId = "PLACE ID",
        Executor = "ИНЖЕКТОР",
        Hwid = "HWID",
        Device = "УСТРОЙСТВО",
        Status = "СТАТУС",
        CopyUserId = "СКОПИРОВАТЬ USER ID",
        Loading = "Загрузка SEPX Hub... %d%%",
        Preparing = "Подготовка окружения...",
        Ready = "Готово • 100%",
        Welcome = "Добро пожаловать в SEPX",
        WelcomeNotif = "Хаб инициализирован. Добро пожаловать, %s!",
        KeyRequired = "Требуется ключ",
        KeyRequiredMsg = "Пожалуйста, введите лицензионный ключ.",
        Verifying = "Проверка ключа",
        VerifyingMsg = "Проверка статуса лицензии...",
        Success = "Успешно",
        SuccessMsg = "С возвращением! SEPX успешно загружен.",
        KeyPasted = "Вставлено",
        KeyPastedMsg = "Ключ вставлен из буфера обмена!",
        Copied = "Скопировано",
        CopiedMsg = "%s скопировано в буфер обмена!"
    }
}

local L = LangDict[detectedLang] or LangDict["en"]

-- ═══════════════════════════════════════════════════════════════════
-- 🎨 MODERN LUXURY STUDIO DESIGN SYSTEM (ROYAL BLUE & VIOLET)
-- ═══════════════════════════════════════════════════════════════════
local function resolveGoogleSans(weight)
    if weight == "Bold" then
        if pcall(function() return Enum.Font.ProductSansBold end) then return Enum.Font.ProductSansBold end
        if pcall(function() return Enum.Font.BuilderSansBold end) then return Enum.Font.BuilderSansBold end
        if pcall(function() return Enum.Font.MontserratBold end) then return Enum.Font.MontserratBold end
        return Enum.Font.GothamBold
    elseif weight == "Medium" then
        if pcall(function() return Enum.Font.ProductSansMedium end) then return Enum.Font.ProductSansMedium end
        if pcall(function() return Enum.Font.BuilderSansMedium end) then return Enum.Font.BuilderSansMedium end
        if pcall(function() return Enum.Font.MontserratMedium end) then return Enum.Font.MontserratMedium end
        return Enum.Font.GothamMedium
    else
        if pcall(function() return Enum.Font.ProductSans end) then return Enum.Font.ProductSans end
        if pcall(function() return Enum.Font.BuilderSans end) then return Enum.Font.BuilderSans end
        if pcall(function() return Enum.Font.Montserrat end) then return Enum.Font.Montserrat end
        return Enum.Font.Gotham
    end
end

local Theme = {
    -- High-Contrast Frosted Smoked Glass (Crystal clear text readability + rich background artwork)
    GlassDeep = Color3.fromRGB(11, 9, 20),          -- Dark Obsidian Base
    GlassSurface = Color3.fromRGB(24, 18, 40),      -- Crisp Frosted Acrylic Surface
    GlassRecessed = Color3.fromRGB(15, 12, 26),     -- High-contrast slot
    GlassElevated = Color3.fromRGB(36, 26, 60),     -- Interactive surface
    
    CardTransparency = 0.0,                         -- Base card background
    InnerTransparency = 0.35,                       -- High-contrast translucent controls
    
    -- Elegant Royal Blue & Studio Violet Palette
    VioletPrimary = Color3.fromRGB(168, 85, 247),   -- #A855F7 Studio Violet
    VioletLight = Color3.fromRGB(224, 195, 255),    -- #E0C3FF High-visibility Lavender
    VioletDark = Color3.fromRGB(126, 34, 206),      -- #7E22CE Deep Plum
    
    BluePrimary = Color3.fromRGB(59, 130, 246),     -- #3B82F6 Radiant Royal Blue
    BlueLight = Color3.fromRGB(165, 210, 255),      -- #A5D2FF High-contrast Sky Blue
    BlueDark = Color3.fromRGB(29, 78, 216),         -- #1D4ED8 Deep Ocean Blue
    
    -- Clean High-End Typography
    TextPrimary = Color3.fromRGB(255, 255, 255),    -- 100% Crisp Pure White
    TextSecondary = Color3.fromRGB(240, 244, 255),  -- Bright Crisp Platinum
    TextMuted = Color3.fromRGB(180, 190, 220),      -- Light Slate
    TextDark = Color3.fromRGB(10, 12, 24),
    
    -- Status
    StatusGreen = Color3.fromRGB(34, 197, 94),      -- #22C55E Pure Emerald
    
    -- Google Sans Typography
    FontBold = resolveGoogleSans("Bold"),
    FontMedium = resolveGoogleSans("Medium"),
    FontRegular = resolveGoogleSans("Regular"),
}

-- Comprehensive Verified Icons
local Icons = {
    Home = "rbxassetid://10723415203",       -- Lucide Home
    Shield = "rbxassetid://10723425102",     -- Lucide Shield
    Combat = "rbxassetid://10734898150",     -- Lucide Target / Crosshair
    Sword = "rbxassetid://10734898150",
    Eye = "rbxassetid://10723346959",        -- Lucide Eye
    Visuals = "rbxassetid://10723346959",
    Zap = "rbxassetid://10709819149",        -- Lucide Zap / Lightning
    Movement = "rbxassetid://10709819149",
    Grid = "rbxassetid://10734975692",       -- Lucide LayoutGrid
    Misc = "rbxassetid://10734975692",
    Settings = "rbxassetid://10734950020",   -- Lucide Settings
    Key = "rbxassetid://10709791437",
    Discord = "rbxassetid://10723405786",    -- Lucide Chat / Message
    Copy = "rbxassetid://10709790298",       -- Lucide Copy
    User = "rbxassetid://10723415903",       -- Lucide User
    Device = "rbxassetid://10734898150",
    Clock = "rbxassetid://10709790537",
    Wifi = "rbxassetid://10734950309",
    Crown = "rbxassetid://10734951847",
    Check = "rbxassetid://10709790644",
    External = "rbxassetid://10709790835",
    ChevronRight = "rbxassetid://10709790948",
    Minimize = "rbxassetid://10734896206",
    Close = "rbxassetid://10747384394",
    Sparkle = "rbxassetid://10723416200"     -- Lucide Sparkles
}

local function resolveIcon(icon)
    if not icon then return Icons.Sparkle end
    if typeof(icon) == "string" then
        if Icons[icon] then return Icons[icon] end
        if string.find(icon, "rbxassetid://") then return icon end
        local lower = string.lower(icon)
        if lower == "home" or lower == "dashboard" then return Icons.Home
        elseif lower == "combat" or lower == "sword" or lower == "shield" then return Icons.Combat
        elseif lower == "visuals" or lower == "eye" or lower == "esp" then return Icons.Eye
        elseif lower == "movement" or lower == "zap" or lower == "speed" then return Icons.Zap
        elseif lower == "misc" or lower == "miscellaneous" or lower == "grid" then return Icons.Grid
        elseif lower == "settings" or lower == "config" then return Icons.Settings
        elseif lower == "copy" then return Icons.Copy
        elseif lower == "discord" then return Icons.Discord
        elseif lower == "key" then return Icons.Key
        elseif lower == "check" then return Icons.Check
        end
    end
    return Icons.Sparkle
end

-- ═══════════════════════════════════════════════════════════════════
-- DYNAMIC SECRETEXTPLOITS LOGO & BACKGROUND ASSET LOADERS
-- ═══════════════════════════════════════════════════════════════════
local cachedLogoAsset = nil
local function getSepxLogoAsset()
    if cachedLogoAsset then return cachedLogoAsset end
    
    if writefile and (getcustomasset or getsynasset) and game.HttpGet then
        local success, result = pcall(function()
            local filename = "secretexploits_trans_logo_v3.png"
            local getAsset = getcustomasset or getsynasset
            if not isfile or not isfile(filename) then
                local imgData = game:HttpGet("https://imghost.secretexploits.xyz/f/qqj6jtleub.png")
                writefile(filename, imgData)
            end
            return getAsset(filename)
        end)
        if success and result then
            cachedLogoAsset = result
            return cachedLogoAsset
        end
    end
    return nil
end

local cachedBgAsset = nil
local function getSepxBackgroundAsset()
    if cachedBgAsset then return cachedBgAsset end
    
    if writefile and (getcustomasset or getsynasset) and game.HttpGet then
        local success, result = pcall(function()
            local filename = "secretexploits_custom_bg.png"
            local getAsset = getcustomasset or getsynasset
            if not isfile or not isfile(filename) then
                local imgData = game:HttpGet("https://imghost.secretexploits.xyz/f/nsm0rholx6.png")
                writefile(filename, imgData)
            end
            return getAsset(filename)
        end)
        if success and result then
            cachedBgAsset = result
            return cachedBgAsset
        end
    end
    return nil
end

-- Pre-fetch assets asynchronously
task.spawn(function()
    getSepxLogoAsset()
    getSepxBackgroundAsset()
end)

-- ═══════════════════════════════════════════════════════════════════
-- UTILITIES & PROCEDURAL HELPERS
-- ═══════════════════════════════════════════════════════════════════
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
local animatedGradients = {}

local function addDualToneStroke(inst, thickness, trans, enableRotation)
    local stroke = create("UIStroke", {
        Color = Theme.VioletPrimary,
        Thickness = thickness or 1.2,
        Transparency = trans or 0.25,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    local gradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.VioletPrimary),
            ColorSequenceKeypoint.new(0.45, Theme.VioletLight),
            ColorSequenceKeypoint.new(0.65, Theme.BluePrimary),
            ColorSequenceKeypoint.new(1, Theme.BlueDark)
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

local function setClipboardSafe(text)
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

-- Universal Browser Opener with multi-executor support & clipboard fallback
local function openBrowserUrl(url)
    setClipboardSafe(url)
    local opened = false
    
    pcall(function()
        if openurl then
            openurl(url)
            opened = true
        elseif open_url then
            open_url(url)
            opened = true
        elseif openlink then
            openlink(url)
            opened = true
        elseif syn and syn.open_url then
            syn.open_url(url)
            opened = true
        elseif Fluxus and Fluxus.openurl then
            Fluxus.openurl(url)
            opened = true
        end
    end)
    
    if not opened then
        pcall(function()
            if GuiService and GuiService.OpenBrowserWindow then
                GuiService:OpenBrowserWindow(url)
                opened = true
            end
        end)
    end
    
    return opened
end

local function getDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Mobile"
    elseif GuiService:IsTenFootInterface() then
        return "Console"
    else
        return "PC"
    end
end

local function getExecutorName()
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
    if POTASSIUM_LOADED or potassium then
        return "Potassium"
    elseif syn then
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
        return "Volt / Wave / UNC"
    else
        return "Universal"
    end
end

local function getHWIDString()
    if gethwid then
        local raw = gethwid()
        return string.sub(raw, 1, 14) .. "..."
    end
    local id = tostring(LocalPlayer.UserId * 1337)
    return "SEPX-" .. string.sub(id, 1, 8)
end

-- ═══════════════════════════════════════════════════════════════════
-- ROOT SCREEN GUI & NOTIFICATIONS
-- ═══════════════════════════════════════════════════════════════════
local ScreenGui = create("ScreenGui", {
    Name = "SEPX_Enterprise_Hub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 99999,
    IgnoreGuiInset = true
})
pcall(function() ScreenGui.ScreenInsets = Enum.ScreenInsets.None end)
ScreenGui.Parent = ParentContainer

-- ═══════════════════════════════════════════════════════════════════
-- 🏝️ TOP-CENTER DYNAMIC ISLAND NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════
local DynamicIslandContainer = create("Frame", {
    Name = "DynamicIslandContainer",
    Size = UDim2.new(1, 0, 0, 100),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 300
})
DynamicIslandContainer.Parent = ScreenGui

local activeIsland = nil
local activeIslandThread = nil

local function showNotification(title, message, isSuccess)
    local logoAsset = getSepxLogoAsset()
    local pulseColor = isSuccess and Theme.StatusGreen or Theme.VioletLight

    -- Dismiss previous active island smoothly if one is already visible
    if activeIsland and activeIsland.Parent then
        if activeIslandThread then
            task.cancel(activeIslandThread)
            activeIslandThread = nil
        end
        local oldIsland = activeIsland
        TweenService:Create(oldIsland, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0, -60),
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.22, function()
            if oldIsland and oldIsland.Parent then oldIsland:Destroy() end
        end)
    end

    local island = create("Frame", {
        Name = "DynamicIsland",
        Size = UDim2.new(0, 0, 0, 56),
        AutomaticSize = Enum.AutomaticSize.X,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, -70),
        BackgroundColor3 = Color3.fromRGB(15, 12, 25),
        BackgroundTransparency = 0.08,
        ClipsDescendants = true,
        ZIndex = 301,
        Parent = DynamicIslandContainer
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 22),
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8)
        }),
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 12)
        })
    })
    addDualToneStroke(island, 1.4, 0.28, true)
    activeIsland = island

    -- 1. Left SecretExploits Circular Transparent Logo Badge (38 x 38)
    local logoBadge = create("Frame", {
        Size = UDim2.new(0, 38, 0, 38),
        BackgroundColor3 = Color3.fromRGB(28, 20, 48),
        BackgroundTransparency = 0.25,
        ZIndex = 302,
        Parent = island
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    if logoAsset then
        create("ImageLabel", {
            Size = UDim2.new(1, -2, 1, -2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image = logoAsset,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 303,
            Parent = logoBadge
        })
    else
        create("ImageLabel", {
            Size = UDim2.new(0, 22, 0, 22),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image = isSuccess and Icons.Check or Icons.Sparkle,
            ImageColor3 = isSuccess and Theme.StatusGreen or Color3.fromRGB(216, 110, 255),
            ZIndex = 303,
            Parent = logoBadge
        })
    end

    -- 2. Two-Line Vertical Text Group (Title + Subtitle)
    local textGroup = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        ZIndex = 302,
        Parent = island
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 2)
        }),
        create("TextLabel", {
            Size = UDim2.new(0, 0, 0, 18),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = title or "SecretExploits",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 303
        }),
        create("TextLabel", {
            Size = UDim2.new(0, 0, 0, 16),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = message or "",
            TextColor3 = Color3.fromRGB(180, 185, 220),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 303
        })
    })

    -- 3. Far-Right Glowing Status Pulse Dot
    local pulseHolder = create("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = 302,
        Parent = island
    })
    local pulseDot = create("Frame", {
        Size = UDim2.new(0, 9, 0, 9),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = pulseColor,
        ZIndex = 303,
        Parent = pulseHolder
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    -- Animate Dropdown (Top -> Down with Spring Easing)
    island.Position = UDim2.new(0.5, 0, 0, -70)
    TweenService:Create(island, TweenInfo.new(0.44, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0, 20)
    }):Play()

    -- Spawn pulse breath animation on the dot
    task.spawn(function()
        for i = 1, 6 do
            if not island or not island.Parent then break end
            TweenService:Create(pulseDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 12, 0, 12) }):Play()
            task.wait(0.26)
            TweenService:Create(pulseDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 8, 0, 8) }):Play()
            task.wait(0.26)
        end
    end)

    -- Auto-retract after 3.2 seconds
    activeIslandThread = task.delay(3.2, function()
        if island and island.Parent then
            local tw = TweenService:Create(island, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, -70),
                BackgroundTransparency = 1
            })
            tw:Play()
            tw.Completed:Connect(function()
                if activeIsland == island then activeIsland = nil end
                island:Destroy()
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- GAME & ENVIRONMENT TELEMETRY LOADER
-- ═══════════════════════════════════════════════════════════════════
local currentGameTitle = "Universal Game"
local currentPlaceId = tostring(game.PlaceId)
local currentJobId = string.sub(game.JobId ~= "" and game.JobId or "Standalone", 1, 8)

pcall(function()
    local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    if productInfo and productInfo.Name and productInfo.Name ~= "" then
        currentGameTitle = productInfo.Name
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 💎 INDEPENDENT FLOATING WINDOW SYSTEM (KEY CARD & PROFILE CARD)
-- ═══════════════════════════════════════════════════════════════════
local customBgAsset = getSepxBackgroundAsset()

-- Glowing Violet / Magenta / Blue Loading Palette
local GlowViolet1 = Color3.fromRGB(195, 110, 255)
local GlowViolet2 = Color3.fromRGB(126, 34, 206)

-- ═══════════════════════════════════════════════════════════════════
-- 🌟 ANIMATED FLOWING ROUNDED BORDER (BLUE & LILA STARTUP PALETTE)
-- ═══════════════════════════════════════════════════════════════════
local animatedBlueLilaBorders = {}

local function addCardLoadingStreamerBorder(cardFrame, cornerRadius)
    cornerRadius = cornerRadius or 22
    
    -- 1. Outer Soft Glowing Bloom Halo (Rounded with CornerRadius + 4)
    local haloFrame = create("Frame", {
        Name = "CardGlowHalo",
        Size = UDim2.new(1, 14, 1, 14),
        Position = UDim2.new(0, -7, 0, -7),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = cardFrame
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, cornerRadius + 4) })
    })

    local haloStroke = create("UIStroke", {
        Thickness = 7,
        Transparency = 0.55,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = haloFrame
    })

    local haloGradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(59, 130, 246)),  -- Royal Blue
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(126, 34, 206)), -- Deep Purple
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(195, 110, 255)), -- Bright Lila
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(99, 102, 241)),  -- Indigo Blue
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(59, 130, 246))   -- Royal Blue
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.35),
            NumberSequenceKeypoint.new(0.30, 0.65),
            NumberSequenceKeypoint.new(0.50, 0.90),
            NumberSequenceKeypoint.new(0.70, 0.65),
            NumberSequenceKeypoint.new(1.00, 0.35)
        }),
        Rotation = 0,
        Parent = haloStroke
    })

    -- 2. Primary Rounded Glowing Streamer Stroke (Hugs cardFrame corners)
    local primaryStroke = create("UIStroke", {
        Name = "StreamerBorderStroke",
        Thickness = 3.0,
        Transparency = 0.02,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = cardFrame
    })

    local primaryGradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(59, 130, 246)),  -- Royal Blue
            ColorSequenceKeypoint.new(0.20, Color3.fromRGB(147, 51, 234)),  -- Electric Violet
            ColorSequenceKeypoint.new(0.40, Color3.fromRGB(195, 110, 255)), -- Bright Lila
            ColorSequenceKeypoint.new(0.60, Color3.fromRGB(99, 102, 241)),  -- Indigo Blue
            ColorSequenceKeypoint.new(0.80, Color3.fromRGB(165, 210, 255)), -- Cyan Light Blue
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(59, 130, 246))   -- Royal Blue
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.00),
            NumberSequenceKeypoint.new(0.25, 0.08),
            NumberSequenceKeypoint.new(0.50, 0.60),  -- Streamer trail
            NumberSequenceKeypoint.new(0.75, 0.08),
            NumberSequenceKeypoint.new(1.00, 0.00)
        }),
        Rotation = 0,
        Parent = primaryStroke
    })

    table.insert(animatedBlueLilaBorders, {
        primary = primaryGradient,
        halo = haloGradient,
        haloStroke = haloStroke
    })
end

-- ═══════════════════════════════════════════════════════════════════
-- 📱 WINDOW 1: INDEPENDENT FLOATING "KEY UI" WINDOW (760 x 520)
-- ═══════════════════════════════════════════════════════════════════
local KeyCard
local ProfileCard
local MainHubWindow
local launchMainHubUI

KeyCard = create("Frame", {
    Name = "KeyCard",
    Size = UDim2.new(0, 760, 0, 520),
    Position = UDim2.new(0.5, -560, 0.5, -260),
    BackgroundColor3 = Theme.GlassDeep,
    BackgroundTransparency = 0,
    ClipsDescendants = false,
    Visible = false,
    ZIndex = 10
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 24) })
})
KeyCard.Parent = ScreenGui

-- Add Glowing Streamer Border
addCardLoadingStreamerBorder(KeyCard, 24)

-- Seamless Full Custom Image Wallpaper (Touches 100% outer boundary, zero black margins!)
if customBgAsset then
    create("ImageLabel", {
        Name = "CardCustomBg",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = customBgAsset,
        ScaleType = Enum.ScaleType.Crop,
        ImageTransparency = 0.0,
        ZIndex = 2,
        Parent = KeyCard
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 24) })
    })

    create("Frame", {
        Name = "CardContrastTint",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.GlassDeep,
        BackgroundTransparency = 0.48,
        ZIndex = 3,
        Parent = KeyCard
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 24) })
    })
end

-- Dedicated Inner Content Container (Holds UIPadding for internal controls)
local KeyCardContent = create("Frame", {
    Name = "KeyCardContent",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 10,
    Parent = KeyCard
}, {
    create("UIPadding", {
        PaddingTop = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 26),
        PaddingRight = UDim.new(0, 26)
    })
})

-- Header (Enlarged 76x76 Logo, Brand Title, Window Controls)
local KeyHeader = create("Frame", {
    Name = "KeyHeader",
    Size = UDim2.new(1, 0, 0, 76),
    BackgroundTransparency = 1,
    ZIndex = 11
})
KeyHeader.Parent = KeyCardContent

local HeaderBrand = create("Frame", {
    Size = UDim2.new(0, 380, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 12
}, {
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 18)
    })
})
HeaderBrand.Parent = KeyHeader

-- PROMINENT ENLARGED LOGO CONTAINER (76 x 76)
local MiniLogo = create("Frame", {
    Size = UDim2.new(0, 76, 0, 76),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 13
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 18) })
})
addDualToneStroke(MiniLogo, 1.4, 0.25, true)
MiniLogo.Parent = HeaderBrand

local logoAsset = getSepxLogoAsset()
if logoAsset then
    create("ImageLabel", {
        Size = UDim2.new(1, -6, 1, -6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = logoAsset,
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 14,
        Parent = MiniLogo
    })
else
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "SEPX",
        TextColor3 = Theme.VioletPrimary,
        TextSize = 20,
        ZIndex = 14,
        Parent = MiniLogo
    })
end

local BrandTitleGroup = create("Frame", {
    Size = UDim2.new(0, 280, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 13
}, {
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "SecretExploits",
        TextColor3 = Theme.TextPrimary,
        TextSize = 23,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    }),
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = L.BrandSubtitle,
        TextColor3 = Theme.VioletLight,
        TextSize = 13.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    })
})
BrandTitleGroup.Parent = HeaderBrand

-- Window Action Buttons (Minimize / Close)
local KeyWindowActions = create("Frame", {
    Size = UDim2.new(0, 84, 1, 0),
    Position = UDim2.new(1, -84, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 12
}, {
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8)
    })
})
KeyWindowActions.Parent = KeyHeader

local function createMiniActionBtn(icon, callback)
    local btn = create("TextButton", {
        Size = UDim2.new(0, 36, 0, 36),
        BackgroundColor3 = Theme.GlassSurface,
        BackgroundTransparency = Theme.InnerTransparency,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 13
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = Theme.TextSecondary,
            ZIndex = 14
        })
    })
    addDualToneStroke(btn, 1, 0.45, false)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.VioletPrimary, BackgroundTransparency = 0.1 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.GlassSurface, BackgroundTransparency = Theme.InnerTransparency }):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local isKeyMinimized = false
local KeyCardBody -- forward declaration

local MinBtn = createMiniActionBtn(Icons.Minimize, function()
    isKeyMinimized = not isKeyMinimized
    if isKeyMinimized then
        if KeyCardBody then KeyCardBody.Visible = false end
        TweenService:Create(KeyCard, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 760, 0, 106)
        }):Play()
    else
        local tw = TweenService:Create(KeyCard, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 760, 0, 520)
        })
        tw:Play()
        task.delay(0.12, function()
            if not isKeyMinimized and KeyCardBody then
                KeyCardBody.Visible = true
            end
        end)
    end
end)
MinBtn.Parent = KeyWindowActions

local isClosing = false
local CloseBtn = createMiniActionBtn(Icons.Close, function()
    if isClosing then return end
    isClosing = true
    
    pcall(function()
        if KeyCard and KeyCard.Parent then
            local keyScale = KeyCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 1, Parent = KeyCard })
            TweenService:Create(keyScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
        end
        if ProfileCard and ProfileCard.Parent then
            local profileScale = ProfileCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 1, Parent = ProfileCard })
            TweenService:Create(profileScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
        end
    end)
    
    task.wait(0.24)
    pcall(function()
        ScreenGui:Destroy()
    end)
end)
CloseBtn.Parent = KeyWindowActions

-- Inner Body Container (Modern 2-Column Bento Split Layout, Cleanly hidden during minimize)
KeyCardBody = create("Frame", {
    Name = "KeyCardBody",
    Size = UDim2.new(1, 0, 1, -86),
    Position = UDim2.new(0, 0, 0, 86),
    BackgroundTransparency = 1,
    ClipsDescendants = false,
    ZIndex = 11,
    Parent = KeyCardContent
})

-- ═══════════════════════════════════════════════════════════════════
-- 👑 LEFT BENTO COLUMN: PREMIUM PASS & PRICING SHOWCASE (250px)
-- ═══════════════════════════════════════════════════════════════════
local LeftBentoCard = create("Frame", {
    Name = "LeftBentoCard",
    Size = UDim2.new(0, 248, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 12,
    Parent = KeyCardBody
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 18) }),
    create("UIPadding", {
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)
    })
})
addDualToneStroke(LeftBentoCard, 1.4, 0.35, true)

-- Header with Crown & Title
local VipHeaderRow = create("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 13,
    Parent = LeftBentoCard
}, {
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8)
    }),
    create("ImageLabel", {
        Size = UDim2.new(0, 22, 0, 22),
        BackgroundTransparency = 1,
        Image = Icons.Crown,
        ImageColor3 = Color3.fromRGB(245, 158, 11),
        ZIndex = 14
    }),
    create("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "SecretExploits VIP",
        TextColor3 = Theme.TextPrimary,
        TextSize = 14.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    })
})

-- Price Tag Box
local PriceTagBox = create("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    Position = UDim2.new(0, 0, 0, 36),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 13,
    Parent = LeftBentoCard
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 10) }),
    create("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 10) }),
    create("TextLabel", {
        Size = UDim2.new(0, 68, 1, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "€4.99",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    }),
    create("TextLabel", {
        Size = UDim2.new(0, 56, 1, 0),
        Position = UDim2.new(0, 62, 0, 2),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = "/ lifetime",
        TextColor3 = Theme.TextMuted,
        TextSize = 10.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    }),
    create("Frame", {
        Size = UDim2.new(0, 64, 0, 22),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(124, 58, 237),
        ZIndex = 14
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 6) }),
        create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = "50% OFF",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 9.5,
            ZIndex = 15
        })
    })
})
addDualToneStroke(PriceTagBox, 1, 0.45, false)

-- Feature Checklist with Glowing Checks
local FeatureList = create("Frame", {
    Size = UDim2.new(1, 0, 0, 140),
    Position = UDim2.new(0, 0, 0, 92),
    BackgroundTransparency = 1,
    ZIndex = 13,
    Parent = LeftBentoCard
}, {
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 5)
    })
})

local function addVipPerk(perkText)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        ZIndex = 14,
        Parent = FeatureList
    }, {
        create("ImageLabel", {
            Size = UDim2.new(0, 13, 0, 13),
            Position = UDim2.new(0, 0, 0.5, -6.5),
            BackgroundTransparency = 1,
            Image = Icons.Check,
            ImageColor3 = Theme.StatusGreen,
            ZIndex = 15
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 18, 0, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = perkText,
            TextColor3 = Theme.TextSecondary,
            TextSize = 11,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15
        })
    })
    return row
end

addVipPerk("Instant Keyless Access (No Ads)")
addVipPerk("Unlock All Exclusive Hub Tabs")
addVipPerk("Priority 24/7 VIP Support")
addVipPerk("Unlimited HWID Resets Anytime")
addVipPerk("Daily Undetected Script Updates")

-- Glowing Direct Purchase Button
local LeftVipBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 1, -42),
    BackgroundColor3 = Theme.VioletPrimary,
    AutoButtonColor = false,
    Text = "",
    ZIndex = 14,
    Parent = LeftBentoCard
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 12) }),
    create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 15
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6)
        }),
        create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundTransparency = 1,
            Image = Icons.Sparkle,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ZIndex = 16
        }),
        create("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = "BUY VIP PASS - €4.99",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 11.5,
            ZIndex = 16
        })
    })
})

LeftVipBtn.MouseEnter:Connect(function()
    TweenService:Create(LeftVipBtn, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletDark }):Play()
end)
LeftVipBtn.MouseLeave:Connect(function()
    TweenService:Create(LeftVipBtn, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletPrimary }):Play()
end)
LeftVipBtn.MouseButton1Click:Connect(function()
    openBrowserUrl("https://secretexploits.xyz/pricing")
    showNotification("👑 VIP Pass", "Link copied to clipboard (secretexploits.xyz/pricing)", true)
end)

-- ═══════════════════════════════════════════════════════════════════
-- 🔑 RIGHT BENTO COLUMN: LICENSE ACTIVATION FORM & UTILITIES
-- ═══════════════════════════════════════════════════════════════════
local RightBentoCard = create("Frame", {
    Name = "RightBentoCard",
    Size = UDim2.new(1, -262, 1, 0),
    Position = UDim2.new(0, 262, 0, 0),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 12,
    Parent = KeyCardBody
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 18) }),
    create("UIPadding", {
        PaddingTop = UDim.new(0, 18),
        PaddingBottom = UDim.new(0, 18),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20)
    })
})
addDualToneStroke(RightBentoCard, 1.4, 0.35, true)

-- Form Heading
local KeyPromptBox = create("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 13,
    Parent = RightBentoCard
}, {
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = L.ActivationTitle,
        TextColor3 = Theme.TextPrimary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    }),
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 22),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = L.ActivationSubtitle,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    })
})

-- Sleek Key Input Slot
local KeyInputSlot = create("Frame", {
    Name = "KeyInputSlot",
    Size = UDim2.new(1, 0, 0, 48),
    Position = UDim2.new(0, 0, 0, 52),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 13,
    Parent = RightBentoCard
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 12) }),
    create("ImageLabel", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 14, 0.5, -9),
        BackgroundTransparency = 1,
        Image = Icons.Key,
        ImageColor3 = Theme.VioletPrimary,
        ZIndex = 14
    })
})
local keySlotStroke = addDualToneStroke(KeyInputSlot, 1.2, 0.35, false)

local KeyTextBox = create("TextBox", {
    Name = "KeyTextBox",
    Size = UDim2.new(1, -114, 1, 0),
    Position = UDim2.new(0, 42, 0, 0),
    BackgroundTransparency = 1,
    Font = Theme.FontMedium,
    PlaceholderText = L.KeyPlaceholder,
    PlaceholderColor3 = Theme.TextMuted,
    Text = "",
    TextColor3 = Theme.VioletLight,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex = 14,
    Parent = KeyInputSlot
})

local PasteBtn = create("TextButton", {
    Name = "PasteBtn",
    Size = UDim2.new(0, 72, 0, 32),
    Position = UDim2.new(1, -82, 0.5, -16),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    Text = L.PasteBtn,
    Font = Theme.FontBold,
    TextColor3 = Theme.VioletLight,
    TextSize = 11,
    AutoButtonColor = false,
    ZIndex = 15,
    Parent = KeyInputSlot
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 8) })
})
addDualToneStroke(PasteBtn, 1, 0.45, false)

PasteBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if getclipboard then
            KeyTextBox.Text = getclipboard()
            showNotification(L.KeyPasted, L.KeyPastedMsg, true)
        end
    end)
end)

KeyTextBox.Focused:Connect(function()
    TweenService:Create(keySlotStroke, TweenInfo.new(0.2), { Transparency = 0, Thickness = 1.6 }):Play()
end)
KeyTextBox.FocusLost:Connect(function()
    TweenService:Create(keySlotStroke, TweenInfo.new(0.2), { Transparency = 0.35, Thickness = 1.2 }):Play()
end)

-- Main Radiant Action Button (ACTIVATE & LAUNCH)
local RedeemBtn = create("TextButton", {
    Name = "RedeemBtn",
    Size = UDim2.new(1, 0, 0, 46),
    Position = UDim2.new(0, 0, 0, 112),
    BackgroundColor3 = Theme.VioletPrimary,
    AutoButtonColor = false,
    Text = "",
    ZIndex = 13,
    Parent = RightBentoCard
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 12) }),
    create("UIScale", { Name = "BtnScale", Scale = 1 }),
    create("Frame", {
        Name = "BtnContent",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Active = false,
        ZIndex = 14
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        }),
        create("ImageLabel", {
            Name = "BtnIcon",
            Size = UDim2.new(0, 18, 0, 18),
            BackgroundTransparency = 1,
            Image = Icons.Check,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Active = false,
            ZIndex = 15
        }),
        create("TextLabel", {
            Name = "BtnText",
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = L.LaunchBtn,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            Active = false,
            ZIndex = 15
        })
    })
})

local isVerifyingKey = false
local redeemScale = RedeemBtn:FindFirstChild("BtnScale")
local redeemIcon = RedeemBtn:FindFirstChild("BtnIcon", true)
local redeemText = RedeemBtn:FindFirstChild("BtnText", true)

RedeemBtn.MouseEnter:Connect(function()
    if not isVerifyingKey then
        TweenService:Create(RedeemBtn, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletDark }):Play()
    end
end)
RedeemBtn.MouseLeave:Connect(function()
    if not isVerifyingKey then
        TweenService:Create(RedeemBtn, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletPrimary }):Play()
    end
end)

local function executeKeyCheck()
    if isVerifyingKey then return end
    local key = KeyTextBox.Text

    -- Button press micro-animation
    if redeemScale then
        TweenService:Create(redeemScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.96 }):Play()
        task.delay(0.09, function()
            TweenService:Create(redeemScale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end)
    end

    if key == "" then
        -- Quick error flash on input slot
        local origPos = KeyInputSlot.Position
        TweenService:Create(keySlotStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(239, 68, 68), Transparency = 0, Thickness = 1.8 }):Play()
        task.spawn(function()
            for _, off in ipairs({ -6, 6, -4, 4, 0 }) do
                KeyInputSlot.Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + off, origPos.Y.Scale, origPos.Y.Offset)
                task.wait(0.025)
            end
            task.wait(0.5)
            TweenService:Create(keySlotStroke, TweenInfo.new(0.3), { Color = Theme.VioletPrimary, Transparency = 0.35, Thickness = 1.2 }):Play()
        end)
        showNotification(L.KeyRequired, L.KeyRequiredMsg, false)
        return
    end

    -- 🌟 High-Tech Cyber Shimmer Laser Sweep (Snappy & Sleek, no ugly text change)
    isVerifyingKey = true
    
    -- Beam sweep overlay on KeyCard
    local shimmer = create("Frame", {
        Name = "KeyCardLaserShimmer",
        Size = UDim2.new(0, 100, 1.4, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(-0.2, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(192, 132, 252),
        BackgroundTransparency = 0.65,
        BorderSizePixel = 0,
        Rotation = 18,
        ZIndex = 25,
        Parent = KeyCard
    }, {
        create("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0.25),
                NumberSequenceKeypoint.new(1, 1)
            })
        })
    })

    TweenService:Create(shimmer, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1.3, 0, 0.5, 0)
    }):Play()
    task.delay(0.38, function() shimmer:Destroy() end)

    -- Button & Slot neon pulse
    TweenService:Create(RedeemBtn, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletLight }):Play()
    TweenService:Create(keySlotStroke, TweenInfo.new(0.18), { Color = Color3.fromRGB(192, 132, 252), Transparency = 0, Thickness = 2 }):Play()
    showNotification("SecretExploits", "Validating license key with server...", true)

    task.wait(0.32)

    if _G.CustomValidKeys and not _G.CustomValidKeys[key] then
        TweenService:Create(RedeemBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(239, 68, 68) }):Play()
        TweenService:Create(keySlotStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(239, 68, 68), Transparency = 0 }):Play()
        showNotification("Invalid Key", "The license key entered is not recognized.", false)
        task.wait(0.6)
        TweenService:Create(RedeemBtn, TweenInfo.new(0.25), { BackgroundColor3 = Theme.VioletPrimary }):Play()
        TweenService:Create(keySlotStroke, TweenInfo.new(0.25), { Color = Theme.VioletPrimary, Transparency = 0.35 }):Play()
        isVerifyingKey = false
        return
    end

    -- Success emerald pop
    TweenService:Create(RedeemBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(34, 197, 94) }):Play()
    TweenService:Create(keySlotStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(74, 222, 128), Transparency = 0 }):Play()
    showNotification("License Validated", "Enterprise Key Accepted • Launching Hub...", true)

    task.wait(0.35)

    if launchMainHubUI then
        launchMainHubUI()
    end
end

RedeemBtn.MouseButton1Click:Connect(executeKeyCheck)
RedeemBtn.Activated:Connect(executeKeyCheck)

-- Secondary Action (Get Key Button)
local GetKeyBtn = create("TextButton", {
    Name = "GetKeyBtn",
    Size = UDim2.new(1, 0, 0, 36),
    Position = UDim2.new(0, 0, 0, 168),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    AutoButtonColor = false,
    Text = "",
    ZIndex = 13,
    Parent = RightBentoCard
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 10) }),
    create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 14
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        }),
        create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundTransparency = 1,
            Image = Icons.External,
            ImageColor3 = Theme.VioletPrimary,
            ZIndex = 15
        }),
        create("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = L.GetKeyBtn,
            TextColor3 = Theme.TextPrimary,
            TextSize = 12,
            ZIndex = 15
        })
    })
})
addDualToneStroke(GetKeyBtn, 1.2, 0.35, false)

GetKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.25 }):Play()
end)
GetKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.18), { BackgroundColor3 = Theme.GlassElevated, BackgroundTransparency = Theme.InnerTransparency }):Play()
end)
GetKeyBtn.MouseButton1Click:Connect(function()
    openBrowserUrl("https://secretexploits.xyz/getkey")
    showNotification(L.GetKeyBtn, "Link copied to clipboard (secretexploits.xyz/getkey)", true)
end)

-- 3 Quick Utility Pills
local QuickUtilRow = create("Frame", {
    Size = UDim2.new(1, 0, 0, 36),
    Position = UDim2.new(0, 0, 0, 214),
    BackgroundTransparency = 1,
    ZIndex = 13,
    Parent = RightBentoCard
}, {
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8)
    })
})

local function createQuickPill(text, icon, widthScale, callback)
    local pill = create("TextButton", {
        Size = UDim2.new(widthScale, -6, 1, 0),
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 14
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 15
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
                Image = icon,
                ImageColor3 = Theme.BlueLight,
                ZIndex = 16
            }),
            create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Font = Theme.FontMedium,
                Text = text,
                TextColor3 = Theme.TextSecondary,
                TextSize = 11,
                ZIndex = 16
            })
        })
    })
    addDualToneStroke(pill, 1, 0.45, false)
    pill.MouseEnter:Connect(function()
        TweenService:Create(pill, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.3 }):Play()
    end)
    pill.MouseLeave:Connect(function()
        TweenService:Create(pill, TweenInfo.new(0.18), { BackgroundColor3 = Theme.GlassElevated, BackgroundTransparency = Theme.InnerTransparency }):Play()
    end)
    pill.MouseButton1Click:Connect(callback)
    return pill
end

createQuickPill(L.Discord, Icons.Discord, 0.333, function()
    openBrowserUrl("https://discord.gg/secretexploits")
    showNotification(L.Discord, "Invite copied to clipboard (discord.gg/secretexploits)", true)
end).Parent = QuickUtilRow

createQuickPill(L.CopyHwid, Icons.Copy, 0.334, function()
    local hwid = getHWIDString()
    setClipboardSafe(hwid)
    showNotification(L.Hwid, string.format(L.CopiedMsg, hwid), true)
end).Parent = QuickUtilRow

createQuickPill(L.Settings, Icons.Settings, 0.333, function()
    showNotification(L.Settings, "Config loaded.", true)
end).Parent = QuickUtilRow

-- Right Status Micro Capsule
local KeyFooterStatus = create("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 13,
    Parent = RightBentoCard
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 8) }),
    create("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 10, 0.5, -3),
        BackgroundColor3 = Theme.StatusGreen,
        ZIndex = 14
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    }),
    create("TextLabel", {
        Size = UDim2.new(1, -26, 1, 0),
        Position = UDim2.new(0, 22, 0, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = "System Protected • Ready for Activation",
        TextColor3 = Theme.VioletLight,
        TextSize = 10.5,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    })
})
addDualToneStroke(KeyFooterStatus, 1, 0.45, false)

-- ═══════════════════════════════════════════════════════════════════
-- 👤 WINDOW 2: INDEPENDENT FLOATING "PROFIL" WINDOW (320 x 520)
-- ═══════════════════════════════════════════════════════════════════
ProfileCard = create("Frame", {
    Name = "ProfileCard",
    Size = UDim2.new(0, 320, 0, 520),
    Position = UDim2.new(0.5, 230, 0.5, -260),
    BackgroundColor3 = Theme.GlassDeep,
    BackgroundTransparency = 0,
    ClipsDescendants = false,
    Visible = false,
    ZIndex = 10
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 24) })
})
ProfileCard.Parent = ScreenGui

-- Add Glowing Streamer Border
addCardLoadingStreamerBorder(ProfileCard, 24)

-- Seamless Full Custom Image Wallpaper for Profile Window (Touches 100% outer boundary, zero black margins!)
if customBgAsset then
    create("ImageLabel", {
        Name = "ProfileCustomBg",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = customBgAsset,
        ScaleType = Enum.ScaleType.Crop,
        ImageTransparency = 0.0,
        ZIndex = 2,
        Parent = ProfileCard
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 22) })
    })

    create("Frame", {
        Name = "ProfileContrastTint",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.GlassDeep,
        BackgroundTransparency = 0.48,
        ZIndex = 3,
        Parent = ProfileCard
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 22) })
    })
end

-- Dedicated Inner Content Container for Profile Controls
local ProfileCardContent = create("Frame", {
    Name = "ProfileCardContent",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 10,
    Parent = ProfileCard
}, {
    create("UIPadding", {
        PaddingTop = UDim.new(0, 18),
        PaddingBottom = UDim.new(0, 18),
        PaddingLeft = UDim.new(0, 18),
        PaddingRight = UDim.new(0, 18)
    })
})

-- Top Avatar Portrait with Dual-Tone Glowing Halo
local AvatarHolder = create("Frame", {
    Name = "AvatarHolder",
    Size = UDim2.new(0, 92, 0, 92),
    Position = UDim2.new(0.5, -46, 0, 4),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 11
}, {
    create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    create("ImageLabel", {
        Size = UDim2.new(1, -10, 1, -10),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
        ZIndex = 12
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    }),
    create("Frame", {
        Name = "OnlineBadge",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -13, 1, -13),
        BackgroundColor3 = Theme.StatusGreen,
        ZIndex = 13
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        create("UIStroke", { Color = Theme.GlassDeep, Thickness = 3 })
    })
})
addDualToneStroke(AvatarHolder, 1.6, 0.2, true)
AvatarHolder.Parent = ProfileCardContent

-- Display Name & Handle
local ProfileDisplayName = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 104),
    BackgroundTransparency = 1,
    Font = Theme.FontBold,
    Text = LocalPlayer.DisplayName or "User",
    TextColor3 = Theme.TextPrimary,
    TextSize = 16.5,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 11,
    Parent = ProfileCardContent
})

local ProfileUserTag = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 0, 127),
    BackgroundTransparency = 1,
    Font = Theme.FontMedium,
    Text = "@" .. (LocalPlayer.Name or "player"),
    TextColor3 = Theme.TextMuted,
    TextSize = 12.5,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 11,
    Parent = ProfileCardContent
})

-- Verified Member Badge
local VerifiedBadge = create("Frame", {
    Size = UDim2.new(0, 114, 0, 22),
    Position = UDim2.new(0.5, -57, 0, 150),
    BackgroundColor3 = Color3.fromRGB(22, 38, 48),
    BackgroundTransparency = 0.35,
    ZIndex = 11
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 11) }),
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6)
    }),
    create("ImageLabel", {
        Size = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
        Image = Icons.Check,
        ImageColor3 = Theme.StatusGreen,
        ZIndex = 12
    }),
    create("TextLabel", {
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = L.Verified,
        TextColor3 = Theme.StatusGreen,
        TextSize = 9.5,
        ZIndex = 12
    })
})
addDualToneStroke(VerifiedBadge, 1, 0.45, false)
VerifiedBadge.Parent = ProfileCardContent

-- Separator Line
local ProfileSep = create("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 182),
    BackgroundColor3 = Theme.VioletLight,
    BackgroundTransparency = 0.85,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = ProfileCardContent
})

-- System Specs & Telemetry List (Translucent Glass Finish)
local SpecsList = create("Frame", {
    Size = UDim2.new(1, 0, 0, 205),
    Position = UDim2.new(0, 0, 0, 192),
    BackgroundTransparency = 1,
    ZIndex = 11
}, {
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 7)
    })
})
SpecsList.Parent = ProfileCardContent

local function createProfileRow(label, val, valColor, isClickable, copyVal)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 27),
        BackgroundColor3 = Theme.GlassSurface,
        BackgroundTransparency = Theme.InnerTransparency,
        ZIndex = 12
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 9) }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
        create("TextLabel", {
            Size = UDim2.new(0.40, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = label,
            TextColor3 = Theme.VioletLight,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        }),
        create("TextLabel", {
            Size = UDim2.new(0.60, 0, 1, 0),
            Position = UDim2.new(0.40, 0, 0, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = val,
            TextColor3 = valColor or Theme.TextPrimary,
            TextSize = 11.5,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 13
        })
    })
    addDualToneStroke(row, 1, 0.50, false)
    row.Parent = SpecsList

    if isClickable and copyVal then
        local btn = create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 14,
            Parent = row
        })
        btn.MouseButton1Click:Connect(function()
            setClipboardSafe(copyVal)
            showNotification(label, string.format(L.CopiedMsg, copyVal), true)
        end)
    end
    return row
end

createProfileRow(L.Game, currentGameTitle, Theme.TextPrimary)
createProfileRow(L.PlaceId, "#" .. currentPlaceId, Theme.BlueLight, true, currentPlaceId)
createProfileRow(L.Executor, getExecutorName(), Theme.VioletLight)
createProfileRow(L.Hwid, getHWIDString(), Theme.BlueLight, true, getHWIDString())
createProfileRow(L.Device, getDeviceType(), Theme.TextSecondary)
createProfileRow(L.Status, L.StatusReady, Theme.StatusGreen)

-- Bottom Profile Quick Action
local ProfileCopyIdBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 36),
    Position = UDim2.new(0, 0, 1, -36),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    Text = L.CopyUserId,
    Font = Theme.FontBold,
    TextColor3 = Theme.VioletPrimary,
    TextSize = 11.5,
    AutoButtonColor = false,
    ZIndex = 12
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 10) })
})
addDualToneStroke(ProfileCopyIdBtn, 1.1, 0.45, false)
ProfileCopyIdBtn.Parent = ProfileCardContent

ProfileCopyIdBtn.MouseEnter:Connect(function()
    TweenService:Create(ProfileCopyIdBtn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.25 }):Play()
end)
ProfileCopyIdBtn.MouseLeave:Connect(function()
    TweenService:Create(ProfileCopyIdBtn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.GlassSurface, BackgroundTransparency = Theme.InnerTransparency }):Play()
end)
ProfileCopyIdBtn.MouseButton1Click:Connect(function()
    setClipboardSafe(tostring(LocalPlayer.UserId))
    showNotification(L.CopyUserId, string.format(L.CopiedMsg, tostring(LocalPlayer.UserId)), true)
end)

-- ═══════════════════════════════════════════════════════════════════
-- 🪟 BUTTERY-SMOOTH INDEPENDENT WINDOW DRAGGING ENGINE
-- ═══════════════════════════════════════════════════════════════════
local function makeCardDraggable(cardFrame, dragHandles)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = cardFrame.Position

            local conn
            conn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    if conn then conn:Disconnect() end
                end
            end)
        end
    end

    for _, handle in ipairs(dragHandles or { cardFrame }) do
        handle.InputBegan:Connect(onInputBegan)
    end

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            cardFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeCardDraggable(KeyCard, { KeyHeader, KeyPromptBox, KeyCard, KeyCardContent, KeyCardBody })
makeCardDraggable(ProfileCard, { ProfileCard, AvatarHolder, ProfileCardContent })

local menuToggleKeyCode = Enum.KeyCode.RightShift
local openMainHubUI
local closeMainHubUI
local toggleMenu
local ReopenCapsule

-- ═══════════════════════════════════════════════════════════════════
-- 📱 FLOATING REOPEN CAPSULE (ULTRA-CLEAN PULSE DYNAMIC ISLAND)
-- ═══════════════════════════════════════════════════════════════════
local activeLogo = getSepxLogoAsset() or logoAsset

ReopenCapsule = create("TextButton", {
    Name = "ReopenCapsule",
    Size = UDim2.new(0, 168, 0, 44),
    Position = UDim2.new(0.5, -84, 0, 20),
    BackgroundColor3 = Color3.fromRGB(15, 11, 24),
    BackgroundTransparency = 0.15,
    Text = "",
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 250,
    Parent = ScreenGui
}, {
    create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    create("UIScale", { Name = "CapsuleScale", Scale = 0.001 })
})

-- Animated Flowing Streamer Border
addCardLoadingStreamerBorder(ReopenCapsule, 22)

-- Logo Holder Badge (Left side)
local CapsuleLogoBadge = create("Frame", {
    Name = "CapsuleLogoBadge",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(0, 8, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(28, 20, 44),
    BackgroundTransparency = 0.3,
    Active = false,
    ZIndex = 252,
    Parent = ReopenCapsule
}, {
    create("UICorner", { CornerRadius = UDim.new(1, 0) })
})
addDualToneStroke(CapsuleLogoBadge, 1, 0.4, true)

if activeLogo then
    create("ImageLabel", {
        Name = "CapsuleLogoImg",
        Size = UDim2.new(1, -4, 1, -4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = activeLogo,
        ScaleType = Enum.ScaleType.Fit,
        Active = false,
        ZIndex = 253,
        Parent = CapsuleLogoBadge
    })
else
    create("TextLabel", {
        Name = "CapsuleLogoText",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "SE",
        TextColor3 = Color3.fromRGB(244, 114, 182),
        TextSize = 13,
        Active = false,
        ZIndex = 253,
        Parent = CapsuleLogoBadge
    })
end

-- Middle Text Stack
local CapsuleTextStack = create("Frame", {
    Name = "TextStack",
    Size = UDim2.new(1, -74, 1, 0),
    Position = UDim2.new(0, 46, 0, 0),
    BackgroundTransparency = 1,
    Active = false,
    ZIndex = 252,
    Parent = ReopenCapsule
}, {
    create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 17),
        Position = UDim2.new(0, 0, 0, 6),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "SecretExploits",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        Active = false,
        ZIndex = 253
    }),
    create("Frame", {
        Name = "StatusRow",
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 23),
        BackgroundTransparency = 1,
        Active = false,
        ZIndex = 253
    }, {
        create("Frame", {
            Name = "LiveDot",
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(0, 0, 0.5, -3),
            BackgroundColor3 = Theme.StatusGreen,
            BorderSizePixel = 0,
            Active = false,
            ZIndex = 254
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) })
        }),
        create("TextLabel", {
            Name = "SubTitle",
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.new(0, 11, 0, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = "Tap to show",
            TextColor3 = Color3.fromRGB(196, 181, 253),
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Active = false,
            ZIndex = 254
        })
    })
})

-- Right Chevron Indicator
local CapsuleChevron = create("ImageLabel", {
    Name = "Chevron",
    Size = UDim2.new(0, 14, 0, 14),
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    BackgroundTransparency = 1,
    Image = Icons.ChevronRight or "rbxassetid://10709790948",
    ImageColor3 = Theme.VioletLight,
    Active = false,
    ZIndex = 252,
    Parent = ReopenCapsule
})

makeCardDraggable(ReopenCapsule, { ReopenCapsule })

local reopenScale = ReopenCapsule:FindFirstChild("CapsuleScale")

ReopenCapsule.MouseEnter:Connect(function()
    TweenService:Create(ReopenCapsule, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.2 }):Play()
    if reopenScale then
        TweenService:Create(reopenScale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1.05 }):Play()
    end
    TweenService:Create(CapsuleChevron, TweenInfo.new(0.18), { Position = UDim2.new(1, -9, 0.5, 0), ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
end)

ReopenCapsule.MouseLeave:Connect(function()
    TweenService:Create(ReopenCapsule, TweenInfo.new(0.18), { BackgroundColor3 = Color3.fromRGB(15, 11, 24), BackgroundTransparency = 0.15 }):Play()
    if reopenScale then
        TweenService:Create(reopenScale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1.0 }):Play()
    end
    TweenService:Create(CapsuleChevron, TweenInfo.new(0.18), { Position = UDim2.new(1, -12, 0.5, 0), ImageColor3 = Theme.VioletLight }):Play()
end)

closeMainHubUI = function()
    if not MainHubWindow then return end
    local hubScale = MainHubWindow:FindFirstChildOfClass("UIScale")
    if hubScale then
        TweenService:Create(hubScale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
    end
    if ProfileCard and ProfileCard.Parent and ProfileCard.Visible then
        local profileScale = ProfileCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 1, Parent = ProfileCard })
        TweenService:Create(profileScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
    end
    task.wait(0.25)
    MainHubWindow.Visible = false
    if ProfileCard then ProfileCard.Visible = false end

    -- Reveal Floating Reopen Capsule with smooth spring
    if ReopenCapsule then
        ReopenCapsule.Visible = true
        if reopenScale then
            reopenScale.Scale = 0.001
            TweenService:Create(reopenScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end
    end
end

openMainHubUI = function()
    -- Hide Floating Reopen Capsule
    if ReopenCapsule and ReopenCapsule.Visible then
        if reopenScale then
            TweenService:Create(reopenScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
        end
        task.delay(0.2, function()
            if ReopenCapsule then ReopenCapsule.Visible = false end
        end)
    end

    MainHubWindow.Visible = true
    local hubScale = MainHubWindow:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 0.001, Parent = MainHubWindow })
    hubScale.Scale = 0.001
    TweenService:Create(hubScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

    if isProfileSideOpen and ProfileCard and ProfileCard.Parent then
        ProfileCard.Visible = true
        local profileScale = ProfileCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 0.001, Parent = ProfileCard })
        profileScale.Scale = 0.001
        task.delay(0.06, function()
            TweenService:Create(profileScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end)
    end
end

toggleMenu = function()
    if MainHubWindow and MainHubWindow.Visible then
        closeMainHubUI()
    else
        openMainHubUI()
    end
end

ReopenCapsule.MouseButton1Click:Connect(openMainHubUI)
ReopenCapsule.Activated:Connect(openMainHubUI)

-- ═══════════════════════════════════════════════════════════════════
-- 🚀 MAIN MASTER HUB WINDOW WITH TABS (840 x 540)
-- ═══════════════════════════════════════════════════════════════════
MainHubWindow = create("Frame", {
    Name = "MainHubWindow",
    Size = UDim2.new(0, 840, 0, 540),
    Position = UDim2.new(0.5, -420, 0.5, -270),
    BackgroundColor3 = Theme.GlassDeep,
    BackgroundTransparency = 0,
    ClipsDescendants = false,
    Visible = false,
    ZIndex = 10,
    Parent = ScreenGui
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 24) }),
    create("UIScale", { Scale = 0.001 })
})

addCardLoadingStreamerBorder(MainHubWindow, 24)

if customBgAsset then
    create("ImageLabel", {
        Name = "HubCustomBg",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = customBgAsset,
        ScaleType = Enum.ScaleType.Crop,
        ImageTransparency = 0.0,
        ZIndex = 2,
        Parent = MainHubWindow
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 24) })
    })

    create("Frame", {
        Name = "HubContrastTint",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.GlassDeep,
        BackgroundTransparency = 0.48,
        ZIndex = 3,
        Parent = MainHubWindow
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 24) })
    })
end

local MainHubContent = create("Frame", {
    Name = "MainHubContent",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 10,
    Parent = MainHubWindow
})

-- Top Header Bar (58px)
local MainHubHeader = create("Frame", {
    Name = "MainHubHeader",
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 11,
    Parent = MainHubContent
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 24) }),
    create("UIPadding", { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) })
})
addDualToneStroke(MainHubHeader, 1.2, 0.4, false)

-- Left Brand Info
local HubBrand = create("Frame", {
    Size = UDim2.new(0, 260, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 12,
    Parent = MainHubHeader
}, {
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12)
    })
})

local HubMiniLogo = create("Frame", {
    Size = UDim2.new(0, 38, 0, 38),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 13,
    Parent = HubBrand
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 10) })
})
addDualToneStroke(HubMiniLogo, 1.2, 0.3, true)

if logoAsset then
    create("ImageLabel", {
        Size = UDim2.new(1, -4, 1, -4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = logoAsset,
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 14,
        Parent = HubMiniLogo
    })
end

local HubBrandText = create("Frame", {
    Size = UDim2.new(0, 180, 0, 38),
    BackgroundTransparency = 1,
    ZIndex = 13,
    Parent = HubBrand
}, {
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "SecretExploits",
        TextColor3 = Theme.TextPrimary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    }),
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 18),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = currentGameTitle .. " • v2.4",
        TextColor3 = Theme.VioletLight,
        TextSize = 11,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    })
})

-- Header Right Controls (Profile chip + Min + Close)
local HubRightActions = create("Frame", {
    Size = UDim2.new(0, 240, 1, 0),
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 12,
    Parent = MainHubHeader
}, {
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10)
    })
})

local isProfileSideOpen = true
local toggleSideProfile

local HubUserChip = create("TextButton", {
    Name = "HubUserChip",
    Size = UDim2.new(0, 155, 0, 32),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 13,
    Parent = HubRightActions
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 16) }),
    create("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 4, 0.5, -12),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=100&h=100",
        Active = false,
        ZIndex = 14
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    }),
    create("TextLabel", {
        Size = UDim2.new(1, -62, 1, 0),
        Position = UDim2.new(0, 34, 0, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = LocalPlayer.DisplayName or "User",
        TextColor3 = Theme.TextPrimary,
        TextSize = 11.5,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Active = false,
        ZIndex = 14
    }),
    create("ImageLabel", {
        Name = "ProfileToggleIcon",
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        BackgroundTransparency = 1,
        Image = Icons.User,
        ImageColor3 = Theme.VioletLight,
        Active = false,
        ZIndex = 14
    })
})
local chipStroke = addDualToneStroke(HubUserChip, 1, 0.45, false)

HubUserChip.MouseEnter:Connect(function()
    TweenService:Create(HubUserChip, TweenInfo.new(0.15), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.25 }):Play()
end)
HubUserChip.MouseLeave:Connect(function()
    TweenService:Create(HubUserChip, TweenInfo.new(0.15), { BackgroundColor3 = Theme.GlassElevated, BackgroundTransparency = Theme.InnerTransparency }):Play()
end)

local HubMinBtn = create("TextButton", {
    Size = UDim2.new(0, 34, 0, 34),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 13,
    Parent = HubRightActions
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 10) }),
    create("ImageLabel", {
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = Icons.Minimize,
        ImageColor3 = Theme.TextSecondary,
        Active = false,
        ZIndex = 14
    })
})
addDualToneStroke(HubMinBtn, 1, 0.45, false)

local HubCloseBtn = create("TextButton", {
    Size = UDim2.new(0, 34, 0, 34),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 13,
    Parent = HubRightActions
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 10) }),
    create("ImageLabel", {
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = Icons.Close,
        ImageColor3 = Theme.TextSecondary,
        Active = false,
        ZIndex = 14
    })
})
addDualToneStroke(HubCloseBtn, 1, 0.45, false)

toggleSideProfile = function(forceState)
    if forceState ~= nil then
        isProfileSideOpen = forceState
    else
        isProfileSideOpen = not isProfileSideOpen
    end

    local hubTargetPos = isProfileSideOpen and UDim2.new(0.5, -580, 0.5, -265) or UDim2.new(0.5, -410, 0.5, -265)
    local profileTargetPos = UDim2.new(0.5, 260, 0.5, -265)
    local profileTargetSize = UDim2.new(0, 320, 0, 530)
    local hubTargetSize = UDim2.new(0, 820, 0, 530)

    TweenService:Create(MainHubWindow, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = hubTargetPos,
        Size = hubTargetSize
    }):Play()

    if ProfileCard and ProfileCard.Parent then
        local profileScale = ProfileCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 1, Parent = ProfileCard })
        if isProfileSideOpen then
            ProfileCard.Visible = true
            ProfileCard.Size = profileTargetSize
            TweenService:Create(ProfileCard, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = profileTargetPos
            }):Play()
            TweenService:Create(profileScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            showNotification("User Profile", "Side profile card opened", true)
        else
            TweenService:Create(profileScale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
            task.delay(0.25, function()
                if not isProfileSideOpen and ProfileCard then
                    ProfileCard.Visible = false
                end
            end)
            showNotification("User Profile", "Side profile card hidden", true)
        end
    end
end

HubUserChip.MouseButton1Click:Connect(function()
    toggleSideProfile()
end)

local hubMinimized = false
HubMinBtn.MouseButton1Click:Connect(function()
    hubMinimized = not hubMinimized
    local targetSize = hubMinimized and UDim2.new(0, 820, 0, 58) or UDim2.new(0, 820, 0, 530)
    TweenService:Create(MainHubWindow, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = targetSize }):Play()
    if ProfileCard and ProfileCard.Parent then
        local profileScale = ProfileCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 1, Parent = ProfileCard })
        if hubMinimized then
            TweenService:Create(profileScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
        elseif isProfileSideOpen then
            ProfileCard.Visible = true
            TweenService:Create(profileScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end
    end
end)

HubCloseBtn.MouseButton1Click:Connect(function()
    closeMainHubUI()
    showNotification("SecretExploits", "Hub minimized to floating capsule. Tap to reopen.", true)
end)

-- Main Body Layout (Sidebar on Left, Pages on Right)
local HubBody = create("Frame", {
    Name = "HubBody",
    Size = UDim2.new(1, 0, 1, -66),
    Position = UDim2.new(0, 0, 0, 66),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Parent = MainHubContent
}, {
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14)
    })
})

-- Sidebar Tabs (205px)
local SidebarTabs = create("Frame", {
    Name = "SidebarTabs",
    Size = UDim2.new(0, 205, 1, 0),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 12,
    Parent = HubBody
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 18) }),
    create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    }),
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
})
addDualToneStroke(SidebarTabs, 1.2, 0.4, true)

-- Sidebar Bottom User Profile Card Widget
local SidebarProfileSep = create("Frame", {
    Name = "SidebarProfileSep",
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Theme.VioletPrimary,
    BackgroundTransparency = 0.85,
    BorderSizePixel = 0,
    LayoutOrder = 900,
    ZIndex = 13,
    Parent = SidebarTabs
})

local SidebarProfileCard = create("TextButton", {
    Name = "SidebarProfileCard",
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Theme.GlassElevated,
    BackgroundTransparency = Theme.InnerTransparency,
    LayoutOrder = 901,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 13,
    Parent = SidebarTabs
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 10) }),
    create("ImageLabel", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 8, 0.5, -14),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=100&h=100",
        Active = false,
        ZIndex = 14
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    }),
    create("TextLabel", {
        Size = UDim2.new(1, -72, 0, 16),
        Position = UDim2.new(0, 42, 0, 6),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = LocalPlayer.DisplayName or "User",
        TextColor3 = Theme.TextPrimary,
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Active = false,
        ZIndex = 14
    }),
    create("TextLabel", {
        Size = UDim2.new(1, -72, 0, 14),
        Position = UDim2.new(0, 42, 0, 22),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = "@" .. (LocalPlayer.Name or "user"),
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Active = false,
        ZIndex = 14
    }),
    create("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        BackgroundColor3 = Theme.StatusGreen,
        Active = false,
        ZIndex = 14
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
})
addDualToneStroke(SidebarProfileCard, 1, 0.5, false)

SidebarProfileCard.MouseEnter:Connect(function()
    TweenService:Create(SidebarProfileCard, TweenInfo.new(0.15), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.25 }):Play()
end)
SidebarProfileCard.MouseLeave:Connect(function()
    TweenService:Create(SidebarProfileCard, TweenInfo.new(0.15), { BackgroundColor3 = Theme.GlassElevated, BackgroundTransparency = Theme.InnerTransparency }):Play()
end)
SidebarProfileCard.MouseButton1Click:Connect(function()
    toggleSideProfile()
end)

-- Right Pages Container
local PagesContainer = create("Frame", {
    Name = "PagesContainer",
    Size = UDim2.new(1, -217, 1, 0),
    Position = UDim2.new(0, 217, 0, 0),
    BackgroundColor3 = Theme.GlassSurface,
    BackgroundTransparency = Theme.InnerTransparency,
    ZIndex = 12,
    Parent = HubBody
}, {
    create("UICorner", { CornerRadius = UDim.new(0, 18) }),
    create("UIPadding", {
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16)
    })
})
addDualToneStroke(PagesContainer, 1.2, 0.4, true)

-- Tab Management System
local tabs = {}
local currentTab = nil
local tabCounter = 0

local function createTabPage(name)
    local page = create("ScrollingFrame", {
        Name = "Page_" .. name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.VioletPrimary,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 13,
        Parent = PagesContainer
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        create("UIPadding", { PaddingRight = UDim.new(0, 6) })
    })
    return page
end

local function addTab(tabId, title, icon)
    tabCounter = tabCounter + 1
    local page = createTabPage(tabId)
    local resolvedIcon = resolveIcon(icon)

    local tabBtn = create("TextButton", {
        Name = "TabBtn_" .. tabId,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = 1,
        LayoutOrder = tabCounter,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 13,
        Parent = SidebarTabs
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("Frame", {
            Name = "Indicator",
            Size = UDim2.new(0, 3, 0, 18),
            Position = UDim2.new(0, 4, 0.5, -9),
            BackgroundColor3 = Theme.VioletPrimary,
            BackgroundTransparency = 1,
            Active = false,
            ZIndex = 14
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) })
        }),
        create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 14, 0.5, -9),
            BackgroundTransparency = 1,
            Image = resolvedIcon,
            ImageColor3 = Theme.TextSecondary,
            Active = false,
            ZIndex = 14
        }),
        create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 38, 0, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = title,
            TextColor3 = Theme.TextSecondary,
            TextSize = 12.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            Active = false,
            ZIndex = 14
        })
    })

    local tabEntry = {
        id = tabId,
        btn = tabBtn,
        page = page,
        indicator = tabBtn:FindFirstChild("Indicator"),
        icon = tabBtn:FindFirstChild("Icon"),
        title = tabBtn:FindFirstChild("Title")
    }

    local function selectTab()
        for _, t in pairs(tabs) do
            if t.id == tabId then
                t.page.Visible = true
                TweenService:Create(t.btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.25, BackgroundColor3 = Theme.VioletDark }):Play()
                TweenService:Create(t.indicator, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
                TweenService:Create(t.icon, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
                TweenService:Create(t.title, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
            else
                t.page.Visible = false
                TweenService:Create(t.btn, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                TweenService:Create(t.indicator, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                TweenService:Create(t.icon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextSecondary }):Play()
                TweenService:Create(t.title, TweenInfo.new(0.2), { TextColor3 = Theme.TextSecondary }):Play()
            end
        end
        currentTab = tabId
    end

    tabBtn.MouseButton1Click:Connect(selectTab)
    tabBtn.Activated:Connect(selectTab)

    tabBtn.MouseEnter:Connect(function()
        if currentTab ~= tabId then
            TweenService:Create(tabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(35, 28, 50) }):Play()
            TweenService:Create(tabEntry.icon, TweenInfo.new(0.15), { ImageColor3 = Theme.TextPrimary }):Play()
            TweenService:Create(tabEntry.title, TweenInfo.new(0.15), { TextColor3 = Theme.TextPrimary }):Play()
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if currentTab ~= tabId then
            TweenService:Create(tabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(tabEntry.icon, TweenInfo.new(0.15), { ImageColor3 = Theme.TextSecondary }):Play()
            TweenService:Create(tabEntry.title, TweenInfo.new(0.15), { TextColor3 = Theme.TextSecondary }):Play()
        end
    end)

    tabs[tabId] = tabEntry
    return page
end

-- ═══════════════════════════════════════════════════════════════════
-- 🛠️ SECRETLIB ADVANCED UI COMPONENT GENERATOR SUITE
-- ═══════════════════════════════════════════════════════════════════

-- 1. Section Header
local function addSection(page, title)
    local sec = create("Frame", {
        Name = "Section_" .. tostring(title),
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        ZIndex = 13,
        Parent = page
    }, {
        create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = string.upper(tostring(title)),
            TextColor3 = Theme.VioletLight,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
        }),
        create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, -1),
            BackgroundColor3 = Theme.VioletPrimary,
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            ZIndex = 14
        })
    })
    return sec
end

-- 2. Divider
local function addDivider(page)
    local div = create("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = 13,
        Parent = page
    }, {
        create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = Theme.VioletPrimary,
            BackgroundTransparency = 0.85,
            BorderSizePixel = 0,
            ZIndex = 14
        })
    })
    return div
end

-- 3. Toggle Component
local function addToggle(page, title, desc, defaultVal, callback)
    local state = defaultVal or false
    local card = create("Frame", {
        Name = "ToggleCard",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
        create("TextLabel", {
            Size = UDim2.new(1, -60, 0, 20),
            Position = UDim2.new(0, 0, 0, 6),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = title or "Toggle",
            TextColor3 = Theme.TextPrimary,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -60, 0, 16),
            Position = UDim2.new(0, 0, 0, 26),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = desc or "",
            TextColor3 = Theme.TextMuted,
            TextSize = 10.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
        })
    })
    addDualToneStroke(card, 1, 0.45, false)

    local switch = create("TextButton", {
        Size = UDim2.new(0, 44, 0, 24),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = state and Theme.VioletPrimary or Color3.fromRGB(35, 30, 50),
        AutoButtonColor = false,
        Text = "",
        ZIndex = 14,
        Parent = card
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    local dot = create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 15,
        Parent = switch
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    local function updateState(newState)
        state = newState
        local targetColor = state and Theme.VioletPrimary or Color3.fromRGB(35, 30, 50)
        local targetDotPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        TweenService:Create(switch, TweenInfo.new(0.2), { BackgroundColor3 = targetColor }):Play()
        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = targetDotPos }):Play()
        if callback then task.spawn(callback, state) end
    end

    switch.MouseButton1Click:Connect(function()
        updateState(not state)
    end)

    return {
        Instance = card,
        Set = updateState,
        GetValue = function() return state end
    }
end

-- 4. Slider Component
local function addSlider(page, title, desc, minVal, maxVal, defaultVal, suffix, callback)
    minVal = minVal or 0
    maxVal = maxVal or 100
    local val = defaultVal or minVal
    suffix = suffix or ""
    
    local card = create("Frame", {
        Name = "SliderCard",
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) })
    })
    addDualToneStroke(card, 1, 0.45, false)

    local titleLabel = create("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title or "Slider",
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
        Parent = card
    })

    local valueLabel = create("TextLabel", {
        Size = UDim2.new(0.3, 0, 0, 20),
        Position = UDim2.new(0.7, 0, 0, 8),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = tostring(val) .. suffix,
        TextColor3 = Theme.VioletLight,
        TextSize = 12.5,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 14,
        Parent = card
    })

    local track = create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(35, 30, 50),
        ZIndex = 14,
        Parent = card
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    local fill = create("Frame", {
        Size = UDim2.new(math.clamp((val - minVal) / math.max(maxVal - minVal, 1), 0, 1), 0, 1, 0),
        BackgroundColor3 = Theme.VioletPrimary,
        ZIndex = 15,
        Parent = track
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    local sliderBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 16,
        Parent = card
    })

    local dragging = false
    local function updateSlider(input)
        local posX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(minVal + (maxVal - minVal) * posX)
        fill.Size = UDim2.new(posX, 0, 1, 0)
        valueLabel.Text = tostring(val) .. suffix
        if callback then task.spawn(callback, val) end
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    local function setValue(newVal)
        val = math.clamp(newVal, minVal, maxVal)
        local pct = (val - minVal) / math.max(maxVal - minVal, 1)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        valueLabel.Text = tostring(val) .. suffix
        if callback then task.spawn(callback, val) end
    end

    return {
        Instance = card,
        Set = setValue,
        GetValue = function() return val end
    }
end

-- 5. Dropdown Component (Expandable Glass Selector)
local function addDropdown(page, title, desc, options, defaultVal, callback)
    options = options or {}
    local currentSelected = defaultVal or (options[1] or "Select...")
    local isOpen = false

    local card = create("Frame", {
        Name = "DropdownCard",
        Size = UDim2.new(1, 0, 0, 52),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        ClipsDescendants = true,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8)
        })
    })
    addDualToneStroke(card, 1, 0.45, false)

    local headerRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        ZIndex = 14,
        Parent = card
    })

    create("TextLabel", {
        Size = UDim2.new(1, -145, 0, 18),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title or "Dropdown",
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = headerRow
    })

    create("TextLabel", {
        Size = UDim2.new(1, -145, 0, 16),
        Position = UDim2.new(0, 0, 0, 18),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = desc or "Select an option",
        TextColor3 = Theme.TextMuted,
        TextSize = 10.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = headerRow
    })

    local selectBtn = create("TextButton", {
        Size = UDim2.new(0, 135, 0, 32),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(24, 18, 38),
        BackgroundTransparency = 0.2,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 15,
        Parent = headerRow
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8) })
    })
    addDualToneStroke(selectBtn, 1, 0.45, false)

    local selectedLabel = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = tostring(currentSelected),
        TextColor3 = Theme.VioletLight,
        TextSize = 11.5,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 16,
        Parent = selectBtn
    })

    local arrowIcon = create("ImageLabel", {
        Size = UDim2.new(0, 12, 0, 12),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = Icons.Minimize,
        ImageColor3 = Theme.TextMuted,
        Rotation = 180,
        ZIndex = 16,
        Parent = selectBtn
    })

    local optionsContainer = create("Frame", {
        Name = "OptionsList",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 14,
        Parent = card
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 4)
        })
    })

    local function populateOptions(optList)
        for _, child in ipairs(optionsContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, opt in ipairs(optList) do
            local optBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = (opt == currentSelected) and Theme.VioletDark or Color3.fromRGB(24, 18, 38),
                BackgroundTransparency = (opt == currentSelected) and 0.2 or 0.5,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 15,
                Parent = optionsContainer
            }, {
                create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
                create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Theme.FontMedium,
                    Text = tostring(opt),
                    TextColor3 = (opt == currentSelected) and Color3.fromRGB(255, 255, 255) or Theme.TextSecondary,
                    TextSize = 11.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 16
                })
            })

            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.2 }):Play()
            end)
            optBtn.MouseLeave:Connect(function()
                if opt ~= currentSelected then
                    TweenService:Create(optBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(24, 18, 38), BackgroundTransparency = 0.5 }):Play()
                end
            end)

            optBtn.MouseButton1Click:Connect(function()
                currentSelected = opt
                selectedLabel.Text = tostring(opt)
                isOpen = false
                optionsContainer.Visible = false
                arrowIcon.Rotation = 180
                populateOptions(optList)
                if callback then task.spawn(callback, opt) end
            end)
        end
    end

    populateOptions(options)

    selectBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsContainer.Visible = isOpen
        arrowIcon.Rotation = isOpen and 0 or 180
    end)

    return {
        Instance = card,
        Set = function(opt)
            currentSelected = opt
            selectedLabel.Text = tostring(opt)
            populateOptions(options)
            if callback then task.spawn(callback, opt) end
        end,
        Refresh = function(newOpts)
            options = newOpts or {}
            currentSelected = options[1] or "Select..."
            selectedLabel.Text = tostring(currentSelected)
            populateOptions(options)
        end,
        GetValue = function() return currentSelected end
    }
end

-- 6. Keybind Component (Interactive Rebinding)
local function addKeybind(page, title, desc, defaultKey, callback)
    local currentKey = defaultKey or Enum.KeyCode.E
    local isBinding = false

    local card = create("Frame", {
        Name = "KeybindCard",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
        create("TextLabel", {
            Size = UDim2.new(1, -95, 0, 20),
            Position = UDim2.new(0, 0, 0, 6),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = title or "Keybind",
            TextColor3 = Theme.TextPrimary,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -95, 0, 16),
            Position = UDim2.new(0, 0, 0, 26),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = desc or "Press to trigger action",
            TextColor3 = Theme.TextMuted,
            TextSize = 10.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
        })
    })
    addDualToneStroke(card, 1, 0.45, false)

    local bindBtn = create("TextButton", {
        Size = UDim2.new(0, 80, 0, 26),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(28, 22, 42),
        BackgroundTransparency = 0.2,
        Text = string.format("[ %s ]", currentKey.Name),
        Font = Theme.FontBold,
        TextColor3 = Theme.VioletLight,
        TextSize = 11.5,
        AutoButtonColor = false,
        ZIndex = 14,
        Parent = card
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) })
    })
    addDualToneStroke(bindBtn, 1, 0.45, false)

    bindBtn.MouseButton1Click:Connect(function()
        isBinding = true
        bindBtn.Text = "[ ... ]"
        bindBtn.TextColor3 = Theme.StatusGreen
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if isBinding and not gpe then
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
                currentKey = input.KeyCode
                isBinding = false
                bindBtn.Text = string.format("[ %s ]", currentKey.Name)
                bindBtn.TextColor3 = Theme.VioletLight
                showNotification("Keybind Updated", string.format("%s set to %s", title, currentKey.Name), true)
                if callback then task.spawn(callback, currentKey, true) end
            end
        elseif not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
            if callback then task.spawn(callback, currentKey, false) end
        end
    end)

    return {
        Instance = card,
        Set = function(newKey)
            currentKey = newKey
            bindBtn.Text = string.format("[ %s ]", currentKey.Name)
        end,
        GetValue = function() return currentKey end
    }
end

-- 7. ColorPicker Component (Live RGB Swatch)
local function addColorPicker(page, title, desc, defaultColor, callback)
    local currentColor = defaultColor or Color3.fromRGB(168, 85, 247)
    local isOpen = false

    local card = create("Frame", {
        Name = "ColorPickerCard",
        Size = UDim2.new(1, 0, 0, 52),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        ClipsDescendants = true,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8)
        })
    })
    addDualToneStroke(card, 1, 0.45, false)

    local headerRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        ZIndex = 14,
        Parent = card
    })

    create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 18),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title or "Color Picker",
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = headerRow
    })

    create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16),
        Position = UDim2.new(0, 0, 0, 18),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = desc or "Click swatch to adjust color",
        TextColor3 = Theme.TextMuted,
        TextSize = 10.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = headerRow
    })

    local swatchBtn = create("TextButton", {
        Size = UDim2.new(0, 42, 0, 24),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = currentColor,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 15,
        Parent = headerRow
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) })
    })
    addDualToneStroke(swatchBtn, 1.2, 0.3, false)

    local rgbBox = create("Frame", {
        Name = "RGBControls",
        Size = UDim2.new(1, 0, 0, 90),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 14,
        Parent = card
    }, {
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 6)
        })
    })

    local r, g, b = math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)

    local function createMiniSlider(channelName, channelColor, startVal, onValChange)
        local row = create("Frame", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            ZIndex = 15,
            Parent = rgbBox
        })
        create("TextLabel", {
            Size = UDim2.new(0, 18, 1, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = channelName,
            TextColor3 = channelColor,
            TextSize = 11.5,
            ZIndex = 16,
            Parent = row
        })
        local track = create("Frame", {
            Size = UDim2.new(1, -60, 0, 6),
            Position = UDim2.new(0, 22, 0.5, -3),
            BackgroundColor3 = Color3.fromRGB(35, 30, 50),
            ZIndex = 16,
            Parent = row
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        local fill = create("Frame", {
            Size = UDim2.new(startVal / 255, 0, 1, 0),
            BackgroundColor3 = channelColor,
            ZIndex = 17,
            Parent = track
        }, {
            create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        local lbl = create("TextLabel", {
            Size = UDim2.new(0, 32, 1, 0),
            Position = UDim2.new(1, -32, 0, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = tostring(startVal),
            TextColor3 = Theme.TextPrimary,
            TextSize = 11,
            ZIndex = 16,
            Parent = row
        })
        local dragBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 18,
            Parent = row
        })
        local dragging = false
        local function update(input)
            local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local v = math.floor(pct * 255)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            lbl.Text = tostring(v)
            onValChange(v)
        end
        dragBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
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

    local function applyColor()
        currentColor = Color3.fromRGB(r, g, b)
        swatchBtn.BackgroundColor3 = currentColor
        if callback then task.spawn(callback, currentColor) end
    end

    createMiniSlider("R", Color3.fromRGB(248, 113, 113), r, function(v) r = v applyColor() end)
    createMiniSlider("G", Color3.fromRGB(74, 222, 128), g, function(v) g = v applyColor() end)
    createMiniSlider("B", Color3.fromRGB(96, 165, 250), b, function(v) b = v applyColor() end)

    swatchBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        rgbBox.Visible = isOpen
    end)

    return {
        Instance = card,
        Set = function(newCol)
            currentColor = newCol
            swatchBtn.BackgroundColor3 = currentColor
            if callback then task.spawn(callback, currentColor) end
        end,
        GetValue = function() return currentColor end
    }
end

-- 8. TextBox Component
local function addTextBox(page, title, desc, placeholder, clearOnFocus, callback)
    local card = create("Frame", {
        Name = "TextBoxCard",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
        create("TextLabel", {
            Size = UDim2.new(1, -160, 0, 20),
            Position = UDim2.new(0, 0, 0, 6),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = title or "Text Input",
            TextColor3 = Theme.TextPrimary,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -160, 0, 16),
            Position = UDim2.new(0, 0, 0, 26),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = desc or "Type your input...",
            TextColor3 = Theme.TextMuted,
            TextSize = 10.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
        })
    })
    addDualToneStroke(card, 1, 0.45, false)

    local boxFrame = create("Frame", {
        Size = UDim2.new(0, 150, 0, 30),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(24, 18, 38),
        BackgroundTransparency = 0.2,
        ZIndex = 14,
        Parent = card
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
    })
    addDualToneStroke(boxFrame, 1, 0.45, false)

    local textBox = create("TextBox", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        PlaceholderText = placeholder or "Enter text...",
        PlaceholderColor3 = Theme.TextMuted,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11.5,
        ClearTextOnFocus = clearOnFocus or false,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15,
        Parent = boxFrame
    })

    textBox.FocusLost:Connect(function(enterPressed)
        if callback then task.spawn(callback, textBox.Text, enterPressed) end
    end)

    return {
        Instance = card,
        Set = function(txt) textBox.Text = tostring(txt) end,
        GetValue = function() return textBox.Text end
    }
end

-- 9. Button Component (Ultra-Clean Modern Glass Action Card - Pulse Aesthetic)
local function addButton(page, title, desc, icon, isPrimary, callback)
    local hasDesc = desc and tostring(desc) ~= ""
    local cardHeight = hasDesc and 48 or 40
    local resolvedIcon = resolveIcon(icon)

    local card = create("TextButton", {
        Name = "ButtonCard_" .. tostring(title),
        Size = UDim2.new(1, 0, 0, cardHeight),
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 10) }),
        create("UIScale", { Name = "CardScale", Scale = 1 })
    })
    local cardStroke = addDualToneStroke(card, 1, 0.45, false)

    -- Clean Floating Icon (No bulky nested boxes!)
    local iconImg = create("ImageLabel", {
        Name = "ButtonIcon",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 12, 0.5, -9),
        BackgroundTransparency = 1,
        Image = resolvedIcon,
        ImageColor3 = Theme.VioletLight,
        Active = false,
        ZIndex = 14,
        Parent = card
    })

    -- Text Area (Generous width - ZERO squishing/truncation!)
    local textContainer = create("Frame", {
        Name = "TextContainer",
        Size = UDim2.new(1, -68, 1, 0),
        Position = UDim2.new(0, 38, 0, 0),
        BackgroundTransparency = 1,
        Active = false,
        ZIndex = 14,
        Parent = card
    })

    local titleLabel = create("TextLabel", {
        Name = "Title",
        Size = hasDesc and UDim2.new(1, 0, 0, 18) or UDim2.new(1, 0, 1, 0),
        Position = hasDesc and UDim2.new(0, 0, 0, 5) or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title or "Button",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Active = false,
        ZIndex = 15,
        Parent = textContainer
    })

    local descLabel
    if hasDesc then
        descLabel = create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 23),
            BackgroundTransparency = 1,
            Font = Theme.FontMedium,
            Text = tostring(desc),
            TextColor3 = Theme.TextMuted,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Active = false,
            ZIndex = 15,
            Parent = textContainer
        })
    end

    -- Right Minimalist Chevron / Arrow
    local chevron = create("ImageLabel", {
        Name = "Chevron",
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        BackgroundTransparency = 1,
        Image = Icons.ChevronRight or "rbxassetid://10709790948",
        ImageColor3 = Theme.TextSecondary,
        Active = false,
        ZIndex = 14,
        Parent = card
    })

    local cardScale = card:FindFirstChild("CardScale")

    -- Hover & Interactive Animations
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.18), { BackgroundColor3 = Theme.VioletDark, BackgroundTransparency = 0.25 }):Play()
        TweenService:Create(cardStroke, TweenInfo.new(0.18), { Transparency = 0.1, Color = Theme.VioletPrimary }):Play()
        TweenService:Create(iconImg, TweenInfo.new(0.18), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        TweenService:Create(chevron, TweenInfo.new(0.18), { Position = UDim2.new(1, -9, 0.5, 0), ImageColor3 = Theme.VioletLight }):Play()
    end)

    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.18), { BackgroundColor3 = Theme.GlassElevated, BackgroundTransparency = Theme.InnerTransparency }):Play()
        TweenService:Create(cardStroke, TweenInfo.new(0.18), { Transparency = 0.45, Color = Theme.VioletDark }):Play()
        TweenService:Create(iconImg, TweenInfo.new(0.18), { ImageColor3 = Theme.VioletLight }):Play()
        TweenService:Create(chevron, TweenInfo.new(0.18), { Position = UDim2.new(1, -12, 0.5, 0), ImageColor3 = Theme.TextSecondary }):Play()
    end)

    local function triggerAction()
        if cardScale then
            TweenService:Create(cardScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.98 }):Play()
            task.delay(0.09, function()
                TweenService:Create(cardScale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            end)
        end
        if callback then task.spawn(callback) end
    end

    card.MouseButton1Click:Connect(triggerAction)
    card.Activated:Connect(triggerAction)

    return {
        Instance = card,
        SetText = function(newTitle) titleLabel.Text = tostring(newTitle) end,
        SetDesc = function(newDesc) if descLabel then descLabel.Text = tostring(newDesc) end end
    }
end

-- 10. Paragraph Component
local function addParagraph(page, title, content, icon)
    local card = create("Frame", {
        Name = "ParagraphCard",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.GlassElevated,
        BackgroundTransparency = Theme.InnerTransparency,
        ZIndex = 13,
        Parent = page
    }, {
        create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        }),
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 4)
        })
    })
    addDualToneStroke(card, 1, 0.45, false)

    local titleLabel = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title or "Information",
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
        Parent = card
    })

    local contentLabel = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Font = Theme.FontMedium,
        Text = content or "",
        TextColor3 = Theme.TextSecondary,
        TextSize = 11.5,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
        Parent = card
    })

    return {
        Instance = card,
        SetTitle = function(t) titleLabel.Text = tostring(t) end,
        SetContent = function(c) contentLabel.Text = tostring(c) end
    }
end

-- Make MainHubWindow Draggable
makeCardDraggable(MainHubWindow, { MainHubHeader, MainHubWindow })

-- ═══════════════════════════════════════════════════════════════════
-- 🚀 LAUNCH TRANSITION: FROM KEY UI TO MAIN MASTER HUB
-- ═══════════════════════════════════════════════════════════════════
launchMainHubUI = function()
    -- 1. Smoothly collapse KeyCard
    if KeyCard and KeyCard.Parent then
        local keyScale = KeyCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 1, Parent = KeyCard })
        TweenService:Create(keyScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.001 }):Play()
    end

    task.wait(0.26)
    if KeyCard then KeyCard.Visible = false end

    -- 2. Ambient Energy Bloom Flare Flash
    local initGlow = create("Frame", {
        Name = "MainInitGlow",
        Size = UDim2.new(0, 40, 0, 40),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(168, 85, 247),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 150,
        Parent = ScreenGui
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
    TweenService:Create(initGlow, TweenInfo.new(0.44, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 780, 0, 780),
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.46, function() initGlow:Destroy() end)

    -- 3. Synchronized Setup for Side-by-Side Windows
    local hubTargetPos = isProfileSideOpen and UDim2.new(0.5, -580, 0.5, -265) or UDim2.new(0.5, -410, 0.5, -265)
    local profileTargetPos = UDim2.new(0.5, 260, 0.5, -265)
    local profileTargetSize = UDim2.new(0, 320, 0, 530)
    local hubTargetSize = UDim2.new(0, 820, 0, 530)

    MainHubWindow.Position = hubTargetPos
    MainHubWindow.Size = hubTargetSize
    MainHubWindow.Visible = true

    local hubScale = MainHubWindow:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 0.001, Parent = MainHubWindow })
    hubScale.Scale = 0.82
    TweenService:Create(hubScale, TweenInfo.new(0.46, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

    -- Synchronize Side Profile Card
    if ProfileCard and ProfileCard.Parent and isProfileSideOpen then
        ProfileCard.Position = profileTargetPos
        ProfileCard.Size = profileTargetSize
        ProfileCard.Visible = true
        local profileScale = ProfileCard:FindFirstChildOfClass("UIScale") or create("UIScale", { Scale = 0.001, Parent = ProfileCard })
        profileScale.Scale = 0.82
        task.delay(0.06, function()
            TweenService:Create(profileScale, TweenInfo.new(0.46, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end)
    end

    -- 4. Staggered Entrance of Header, Sidebar, and Tab Buttons
    if MainHubHeader then
        local origHeaderPos = MainHubHeader.Position
        MainHubHeader.Position = UDim2.new(origHeaderPos.X.Scale, origHeaderPos.X.Offset, 0, -22)
        TweenService:Create(MainHubHeader, TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = origHeaderPos
        }):Play()
    end

    if SidebarTabs then
        local origSidebarPos = SidebarTabs.Position
        SidebarTabs.Position = UDim2.new(origSidebarPos.X.Scale, origSidebarPos.X.Offset - 25, origSidebarPos.Y.Scale, origSidebarPos.Y.Offset)
        TweenService:Create(SidebarTabs, TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = origSidebarPos
        }):Play()

        -- Cascade tab buttons
        local tabIndex = 0
        for _, child in ipairs(SidebarTabs:GetChildren()) do
            if child:IsA("TextButton") and string.find(child.Name, "TabBtn_") then
                tabIndex = tabIndex + 1
                local origBtnPos = child.Position
                child.Position = UDim2.new(origBtnPos.X.Scale - 0.15, origBtnPos.X.Offset, origBtnPos.Y.Scale, origBtnPos.Y.Offset)
                task.delay(0.035 * tabIndex, function()
                    TweenService:Create(child, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = origBtnPos
                    }):Play()
                end)
            end
        end
    end

    showNotification("SecretExploits", "Master Hub & Side Profile Initialized • Press RightShift to hide/show.", true)
end

-- Keybind Toggle for MainHubWindow & Side Profile Card (Customizable Keybind or Insert)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.UserInputType == Enum.UserInputType.Keyboard and (input.KeyCode == menuToggleKeyCode or input.KeyCode == Enum.KeyCode.Insert) then
        toggleMenu()
    end
end)

-- 🌟 ANIMATED FLOWING BLUE & LILA ROUNDED BORDER ROTATION
local borderStep = 0
RunService.RenderStepped:Connect(function(dt)
    borderStep = borderStep + dt
    local rotSpeed = 75  -- Smooth continuous rotation in degrees/sec
    
    for _, entry in ipairs(animatedBlueLilaBorders) do
        entry.primary.Rotation = (entry.primary.Rotation + dt * rotSpeed) % 360
        entry.halo.Rotation = (entry.halo.Rotation + dt * rotSpeed) % 360
        
        -- Breathing halo glow
        local breath = (math.sin(borderStep * 2.5) + 1) * 0.5
        entry.haloStroke.Transparency = 0.45 + (1 - breath) * 0.25
    end
    
    for _, grad in ipairs(animatedStrokes) do
        grad.Rotation = (grad.Rotation + dt * 28) % 360
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 🎬 CINEMATIC STUDIO LAUNCH SEQUENCE (UNIFIED HIGH-CONTRAST LOADER)
-- ═══════════════════════════════════════════════════════════════════
local function runCinematicLaunchSequence()
    local IntroOverlay = create("Frame", {
        Name = "IntroOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 200
    })
    IntroOverlay.Parent = ScreenGui

    -- 🌟 1. Full-Screen Cinematic Darkening Backdrop
    local IntroDimBackdrop = create("Frame", {
        Name = "IntroDimBackdrop",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(5, 3, 11),
        BackgroundTransparency = 1,
        ZIndex = 200,
        Parent = IntroOverlay
    })
    TweenService:Create(IntroDimBackdrop, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0.22 }):Play()

    -- 2. Inward Glowing Light Curtains
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

    local TopInwardGlow = createInwardGlow("TopInwardGlow", UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 0, 0), GlowViolet1, GlowViolet2, 90)
    local RightInwardGlow = createInwardGlow("RightInwardGlow", UDim2.new(0, 220, 1, 0), UDim2.new(1, -220, 0, 0), Theme.BluePrimary, Theme.BlueDark, 180)
    local BottomInwardGlow = createInwardGlow("BottomInwardGlow", UDim2.new(1, 0, 0, 220), UDim2.new(0, 0, 1, -220), GlowViolet1, GlowViolet2, 270)
    local LeftInwardGlow = createInwardGlow("LeftInwardGlow", UDim2.new(0, 220, 1, 0), UDim2.new(0, 0, 0, 0), Theme.BluePrimary, Theme.BlueDark, 0)

    -- Cascading Bloom
    TweenService:Create(TopInwardGlow, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
    task.wait(0.08)
    TweenService:Create(RightInwardGlow, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
    task.wait(0.08)
    TweenService:Create(BottomInwardGlow, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
    task.wait(0.08)
    TweenService:Create(LeftInwardGlow, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()

    -- Synchronized Respiration
    local breathStep = 0
    local breathingConn
    breathingConn = RunService.RenderStepped:Connect(function(dt)
        breathStep = breathStep + dt * 2.8
        local breathFactor = (math.sin(breathStep) + 1) * 0.5
        local inwardTrans = 0.0 + (1 - breathFactor) * 0.35
        TopInwardGlow.BackgroundTransparency = inwardTrans
        RightInwardGlow.BackgroundTransparency = inwardTrans
        BottomInwardGlow.BackgroundTransparency = inwardTrans
        LeftInwardGlow.BackgroundTransparency = inwardTrans
    end)

    -- 🌟 3. Clean Transparent SecretExploits Logo (190 x 190)
    local activeLogo = getSepxLogoAsset() or logoAsset
    local GiantLogo = create("ImageLabel", {
        Name = "GiantLogo",
        Size = UDim2.new(0, 190, 0, 190),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.44, 0),
        BackgroundTransparency = 1,
        Image = activeLogo or "",
        ScaleType = Enum.ScaleType.Fit,
        ImageTransparency = 1,
        ZIndex = 208,
        Parent = IntroOverlay
    })
    
    local GiantFallbackText
    if not logoAsset then
        GiantFallbackText = create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = "SecretExploits",
            TextColor3 = GlowViolet1,
            TextSize = 36,
            TextTransparency = 1,
            ZIndex = 208,
            Parent = GiantLogo
        })
    end

    -- 🌟 4. Ultra-Sleek Minimalist Progress Line
    local ProgressTrack = create("Frame", {
        Name = "ProgressTrack",
        Size = UDim2.new(0, 220, 0, 4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.57, 0),
        BackgroundColor3 = Color3.fromRGB(30, 24, 48),
        BackgroundTransparency = 0.2,
        ZIndex = 210,
        Parent = IntroOverlay
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    local ProgressFill = create("Frame", {
        Name = "ProgressFill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 211,
        Parent = ProgressTrack
    }, {
        create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(59, 130, 246)),  -- Royal Blue
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(195, 110, 255)), -- Bright Lila
                ColorSequenceKeypoint.new(0.85, Color3.fromRGB(56, 189, 248)),  -- Sky Cyan
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))  -- Hot White Head
            })
        })
    })

    -- 🌟 5. Clean Modern Loading Status Text
    local LoadingStatusLabel = create("TextLabel", {
        Name = "LoadingStatusLabel",
        Size = UDim2.new(0, 320, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.605, 0),
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = "Loading SecretExploits... 0%",
        TextColor3 = Color3.fromRGB(215, 215, 240),
        TextSize = 12.5,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextStrokeTransparency = 0.6,
        ZIndex = 211,
        Parent = IntroOverlay
    })

    -- Smooth Expansion of Logo
    task.wait(0.05)
    TweenService:Create(GiantLogo, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        ImageTransparency = 0.0
    }):Play()
    if GiantFallbackText then
        TweenService:Create(GiantFallbackText, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            TextTransparency = 0.0
        }):Play()
    end

    -- 🌟 60 FPS ULTRA-SMOOTH FRAME-INTERPOLATED PROGRESS
    local startTime = os.clock()
    local duration = 1.3
    local currentVisualProgress = 0
    local isLoadComplete = false

    local loadConn
    loadConn = RunService.RenderStepped:Connect(function(dt)
        local elapsed = os.clock() - startTime
        local rawT = math.clamp(elapsed / duration, 0, 1)
        
        -- Smooth Quartic Ease-InOut
        local targetEased = rawT < 0.5 and (8 * rawT * rawT * rawT * rawT) or (1 - math.pow(-2 * rawT + 2, 4) / 2)
        
        -- Smooth frame delta interpolation
        currentVisualProgress = currentVisualProgress + (targetEased - currentVisualProgress) * math.clamp(dt * 15, 0, 1)
        
        ProgressFill.Size = UDim2.new(math.clamp(currentVisualProgress, 0, 1), 0, 1, 0)
        local pct = math.floor(currentVisualProgress * 100)
        LoadingStatusLabel.Text = string.format("Loading SecretExploits... %d%%", pct)
        
        if rawT >= 1 and math.abs(currentVisualProgress - 1) < 0.005 then
            isLoadComplete = true
        end
    end)

    while not isLoadComplete do
        task.wait()
    end
    if loadConn then loadConn:Disconnect() end

    ProgressFill.Size = UDim2.new(1, 0, 1, 0)
    LoadingStatusLabel.Text = "Welcome to SecretExploits"
    LoadingStatusLabel.TextColor3 = Theme.StatusGreen

    task.wait(0.22)

    -- 4. Transition into Independent Floating Dual Windows
    KeyCard.Visible = true
    ProfileCard.Visible = true
    
    KeyCard.Size = UDim2.new(0, 710, 0, 480)
    ProfileCard.Size = UDim2.new(0, 280, 0, 480)
    
    TweenService:Create(KeyCard, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 760, 0, 520)
    }):Play()
    TweenService:Create(ProfileCard, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 520)
    }):Play()

    -- Dissolve Intro
    TweenService:Create(IntroDimBackdrop, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(GiantLogo, TweenInfo.new(0.35), { ImageTransparency = 1 }):Play()
    if GiantFallbackText then TweenService:Create(GiantFallbackText, TweenInfo.new(0.35), { TextTransparency = 1 }):Play() end
    TweenService:Create(ProgressTrack, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(ProgressFill, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LoadingStatusLabel, TweenInfo.new(0.28), { TextTransparency = 1 }):Play()

    TweenService:Create(TopInwardGlow, TweenInfo.new(0.38), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(RightInwardGlow, TweenInfo.new(0.38), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(BottomInwardGlow, TweenInfo.new(0.38), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(LeftInwardGlow, TweenInfo.new(0.38), { BackgroundTransparency = 1 }):Play()

    task.wait(0.5)
    if breathingConn then breathingConn:Disconnect() end
    IntroOverlay:Destroy()

    showNotification("SecretExploits", string.format(L.WelcomeNotif, (LocalPlayer.DisplayName or "User")), true)
end

-- ═══════════════════════════════════════════════════════════════════
-- 🚀 SECRETLIB OFFICIAL UI LIBRARY ENGINE (ORION & MODERN COMPATIBLE)
-- ═══════════════════════════════════════════════════════════════════
local SecretLib = {
    Theme = Theme,
    Icons = Icons,
    ScreenGui = ScreenGui,
    Windows = {}
}

function SecretLib:Notify(config)
    local title = typeof(config) == "table" and (config.Title or config.Name or config.title) or "SecretExploits"
    local message = typeof(config) == "table" and (config.Content or config.Message or config.Text or config.message or "") or tostring(config)
    local isSuccess = typeof(config) == "table" and (config.Success or config.isSuccess or true) or true
    showNotification(title, message, isSuccess)
end
SecretLib.MakeNotification = SecretLib.Notify

function SecretLib:CreateWindow(config)
    config = config or {}
    local winTitle = config.Title or config.Name or "SecretExploits"
    local winSubTitle = config.SubTitle or config.Subtitle or config.Desc or (currentGameTitle .. " • Hub")
    local useKeySystem = config.KeySystem or false
    local keySettings = config.KeySettings or {}

    if config.Keybind or config.ToggleKey then
        menuToggleKeyCode = config.Keybind or config.ToggleKey
    end

    -- Update window header branding
    if HubBrandText then
        local titleLbl = HubBrandText:FindFirstChildOfClass("TextLabel")
        if titleLbl then titleLbl.Text = winTitle end
        local subLbl = HubBrandText:FindFirstChild("HubSubTitle", true)
        if subLbl then subLbl.Text = winSubTitle end
    end

    local Window = {
        Tabs = {},
        ActiveTab = nil,
        FirstTab = nil
    }

    function Window:CreateTab(tabConfig)
        local tabId = typeof(tabConfig) == "table" and (tabConfig.Id or tabConfig.Name or tabConfig.Title) or tostring(tabConfig)
        local tabTitle = typeof(tabConfig) == "table" and (tabConfig.Name or tabConfig.Title) or tostring(tabConfig)
        local tabIcon = typeof(tabConfig) == "table" and (tabConfig.Icon or tabConfig.icon or Icons.Sparkle) or Icons.Sparkle

        local page = addTab(string.lower(tabId), tabTitle, tabIcon)

        local Tab = {
            Page = page,
            Id = tabId
        }

        -- Section (Supports string or table)
        function Tab:CreateSection(secConfig)
            local title = typeof(secConfig) == "table" and (secConfig.Name or secConfig.Title) or tostring(secConfig)
            return addSection(page, title)
        end
        Tab.AddSection = Tab.CreateSection
        Tab.MakeSection = Tab.CreateSection

        -- Divider
        function Tab:CreateDivider()
            return addDivider(page)
        end
        Tab.AddDivider = Tab.CreateDivider
        Tab.MakeDivider = Tab.CreateDivider

        -- Toggle
        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local name = toggleConfig.Name or toggleConfig.Title or "Toggle"
            local desc = toggleConfig.Desc or toggleConfig.Description or toggleConfig.Info
            local default = (toggleConfig.Default ~= nil) and toggleConfig.Default or false
            local cb = toggleConfig.Callback or toggleConfig.callback
            return addToggle(page, name, desc, default, cb)
        end
        Tab.AddToggle = Tab.CreateToggle
        Tab.MakeToggle = Tab.CreateToggle

        -- Slider
        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local name = sliderConfig.Name or sliderConfig.Title or "Slider"
            local desc = sliderConfig.Desc or sliderConfig.Description or sliderConfig.Info
            local minVal = sliderConfig.Min or sliderConfig.min or 0
            local maxVal = sliderConfig.Max or sliderConfig.max or 100
            local default = sliderConfig.Default or sliderConfig.default or minVal
            local suffix = sliderConfig.Suffix or sliderConfig.ValueName or ""
            local cb = sliderConfig.Callback or sliderConfig.callback
            return addSlider(page, name, desc, minVal, maxVal, default, suffix, cb)
        end
        Tab.AddSlider = Tab.CreateSlider
        Tab.MakeSlider = Tab.CreateSlider

        -- Dropdown
        function Tab:CreateDropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}
            local name = dropdownConfig.Name or dropdownConfig.Title or "Dropdown"
            local desc = dropdownConfig.Desc or dropdownConfig.Description or dropdownConfig.Info
            local opts = dropdownConfig.Options or dropdownConfig.options or {}
            local default = dropdownConfig.Default or dropdownConfig.default or (opts[1] or "")
            local cb = dropdownConfig.Callback or dropdownConfig.callback
            return addDropdown(page, name, desc, opts, default, cb)
        end
        Tab.AddDropdown = Tab.CreateDropdown
        Tab.MakeDropdown = Tab.CreateDropdown

        -- Keybind
        function Tab:CreateKeybind(keybindConfig)
            keybindConfig = keybindConfig or {}
            local name = keybindConfig.Name or keybindConfig.Title or "Keybind"
            local desc = keybindConfig.Desc or keybindConfig.Description or keybindConfig.Info
            local default = keybindConfig.Default or keybindConfig.default or Enum.KeyCode.E
            local cb = keybindConfig.Callback or keybindConfig.callback
            return addKeybind(page, name, desc, default, cb)
        end
        Tab.AddKeybind = Tab.CreateKeybind
        Tab.AddBind = Tab.CreateKeybind
        Tab.MakeKeybind = Tab.CreateKeybind

        -- ColorPicker
        function Tab:CreateColorPicker(colorConfig)
            colorConfig = colorConfig or {}
            local name = colorConfig.Name or colorConfig.Title or "Color Picker"
            local desc = colorConfig.Desc or colorConfig.Description or colorConfig.Info
            local default = colorConfig.Default or colorConfig.default or Color3.fromRGB(168, 85, 247)
            local cb = colorConfig.Callback or colorConfig.callback
            return addColorPicker(page, name, desc, default, cb)
        end
        Tab.AddColorpicker = Tab.CreateColorPicker
        Tab.AddColorPicker = Tab.CreateColorPicker
        Tab.MakeColorPicker = Tab.CreateColorPicker

        -- TextBox
        function Tab:CreateTextBox(textBoxConfig)
            textBoxConfig = textBoxConfig or {}
            local name = textBoxConfig.Name or textBoxConfig.Title or "Text Input"
            local desc = textBoxConfig.Desc or textBoxConfig.Description or textBoxConfig.Info
            local placeholder = textBoxConfig.Placeholder or textBoxConfig.Default or "Enter text..."
            local clear = textBoxConfig.ClearOnFocus or textBoxConfig.TextDisappear or false
            local cb = textBoxConfig.Callback or textBoxConfig.callback
            return addTextBox(page, name, desc, placeholder, clear, cb)
        end
        Tab.AddTextbox = Tab.CreateTextBox
        Tab.AddTextBox = Tab.CreateTextBox
        Tab.MakeTextBox = Tab.CreateTextBox

        -- Button
        function Tab:CreateButton(btnConfig)
            btnConfig = btnConfig or {}
            local name = btnConfig.Name or btnConfig.Title or "Button"
            local desc = btnConfig.Desc or btnConfig.Description or btnConfig.Info
            local icon = btnConfig.Icon or btnConfig.icon or Icons.ChevronRight
            local isPrimary = btnConfig.Primary or false
            local cb = btnConfig.Callback or btnConfig.callback
            return addButton(page, name, desc, icon, isPrimary, cb)
        end
        Tab.AddButton = Tab.CreateButton
        Tab.MakeButton = Tab.CreateButton

        -- Paragraph (Supports string or table)
        function Tab:CreateParagraph(paraConfig, contentArg)
            local title = "Information"
            local content = ""
            local icon = Icons.Sparkle
            if typeof(paraConfig) == "string" then
                title = paraConfig
                content = tostring(contentArg or "")
            elseif typeof(paraConfig) == "table" then
                title = paraConfig.Title or paraConfig.Name or "Information"
                content = paraConfig.Content or paraConfig.Text or ""
                icon = paraConfig.Icon or paraConfig.icon or Icons.Sparkle
            end
            return addParagraph(page, title, content, icon)
        end
        Tab.AddParagraph = Tab.CreateParagraph
        Tab.MakeParagraph = Tab.CreateParagraph

        -- Auto-activate first tab
        local lowerId = string.lower(tabId)
        if not Window.FirstTab then
            Window.FirstTab = lowerId
            task.delay(0.05, function()
                if tabs[lowerId] and tabs[lowerId].btn then
                    tabs[lowerId].page.Visible = true
                    tabs[lowerId].btn.BackgroundTransparency = 0.25
                    tabs[lowerId].btn.BackgroundColor3 = Theme.VioletDark
                    tabs[lowerId].indicator.BackgroundTransparency = 0
                    tabs[lowerId].icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    tabs[lowerId].title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    currentTab = lowerId
                end
            end)
        end

        Window.Tabs[tabId] = Tab
        return Tab
    end

    -- Tab Aliases (Orion compatibility)
    Window.MakeTab = Window.CreateTab
    Window.AddTab = Window.CreateTab

    function Window:Destroy()
        pcall(function() ScreenGui:Destroy() end)
    end

    function Window:Toggle()
        toggleMenu()
    end

    -- Launch Sequence (Key system vs Direct)
    if useKeySystem then
        if keySettings.Title then
            local keyTitle = KeyPromptBox:FindFirstChild("Title", true)
            if keyTitle then keyTitle.Text = keySettings.Title end
        end
        if keySettings.Subtitle or keySettings.SubTitle then
            local keySub = KeyPromptBox:FindFirstChild("Subtitle", true)
            if keySub then keySub.Text = keySettings.Subtitle or keySettings.SubTitle end
        end
        if keySettings.Note then
            local keyNote = KeyCard:FindFirstChild("Note", true)
            if keyNote then keyNote.Text = keySettings.Note end
        end

        if keySettings.Key or keySettings.Keys then
            local validKeys = {}
            if typeof(keySettings.Key) == "table" then
                for _, k in ipairs(keySettings.Key) do validKeys[tostring(k)] = true end
            elseif keySettings.Key then
                validKeys[tostring(keySettings.Key)] = true
            end
            if typeof(keySettings.Keys) == "table" then
                for _, k in ipairs(keySettings.Keys) do validKeys[tostring(k)] = true end
            end
            _G.CustomValidKeys = validKeys
        end

        task.spawn(runCinematicLaunchSequence)
    else
        -- Direct UI launch without Key Screen
        KeyCard.Visible = false
        ProfileCard.Visible = false
        task.spawn(function()
            task.wait(0.05)
            openMainHubUI()
        end)
    end

    table.insert(SecretLib.Windows, Window)
    return Window
end

-- Library Aliases (Orion compatibility)
SecretLib.MakeWindow = SecretLib.CreateWindow
SecretLib.CreateLib = SecretLib.CreateWindow
SecretLib.Init = SecretLib.CreateWindow

print(string.format("[SecretExploits Hub] Multi-Language UI Library initialized (Locale: %s).", detectedLang))

return SecretLib
