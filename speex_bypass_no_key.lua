local _kkrme9cf=(103+55)
local function _cn50j400(s)
local o={}
for i=1,#s do
o[i]=string.char(bit32.bxor(string.byte(s,i),(_kkrme9cf+((i-1)*7))%256))
end
return table.concat(o)
end
local HttpService  = game:GetService(_cn50j400("\214\209\216\195\233\164\186\185\191\190\129"))
local TweenService = game:GetService(_cn50j400("\202\210\201\214\212\146\173\189\160\180\135\142"))
local CoreGui      = game:GetService(_cn50j400("\221\202\222\214\253\180\161"))
local Players      = game:GetService(_cn50j400("\206\201\205\202\223\179\187"))
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    while not Players.LocalPlayer do
        task.wait()
    end
    LocalPlayer = Players.LocalPlayer
end
local username = LocalPlayer.Name
local userId   = LocalPlayer.UserId
local placeId  = game.PlaceId
local jobId    = game.JobId
local gameId   = game.GameId
local HOST_URL    = "https://exec.luaprotect.dev"
local WS_URL      = "wss://exec.luaprotect.dev/ws"
local SCRIPT_ID   = "3ygzzC25i2tZ4K9Z"
local SCRIPT_NAME = "Bypass"
local IS_TELEPORT_RECONNECT = "0" == _cn50j400("\175")
local HANDOFF_RUNNER_ID = ""
local HANDOFF_KEY = ""
local HANDOFF_RUN_ID = ""
local HANDOFF_SESSION_ID = ""
local SECRET_KEY  = "a035da2d6f91cc32f23b374ddc82c23d1e3b972edd2a48cd5b945eb3ccf0f18f"
local RUNNER_ID   = "fc1e08d9417e2e9ae70303a66e4976fd"
local label = (SCRIPT_NAME ~= _cn50j400("") and SCRIPT_NAME) or _cn50j400("\210\208\205\195\200\174\188\170\181\169")
local function getGuiParent()
    local parentGui = nil
    if gethui then
        pcall(function()
            local hui = gethui()
            if hui and hui.FindFirstChild then parentGui = hui end
        end)
    end
    if not parentGui then
        pcall(function()
            if CoreGui and CoreGui.FindFirstChild then parentGui = CoreGui end
        end)
    end
    if not parentGui then
        pcall(function()
            if LocalPlayer and LocalPlayer.FindFirstChild then
                parentGui = LocalPlayer:FindFirstChild(_cn50j400("\206\201\205\202\223\179\143\186\191")) or LocalPlayer:WaitForChild(_cn50j400("\206\201\205\202\223\179\143\186\191"), 5)
            end
        end)
    end
    return parentGui or CoreGui
end
local function cleanupExistingGui(name)
    pcall(function()
        local parents = {}
        if CoreGui then table.insert(parents, CoreGui) end
        if LocalPlayer then
            local pg = LocalPlayer:FindFirstChild(_cn50j400("\206\201\205\202\223\179\143\186\191"))
            if pg then table.insert(parents, pg) end
        end
        if gethui then
            pcall(function()
                local hui = gethui()
                if hui and hui ~= CoreGui then table.insert(parents, hui) end
            end)
        end
        for _, p in ipairs(parents) do
            local found = p:FindFirstChild(name)
            while found do
                found:Destroy()
                found = p:FindFirstChild(name)
            end
        end
    end)
end
cleanupExistingGui(_cn50j400("\210\208\205\227\200\174\188\170\181\169\175\142\139\172\073"))
cleanupExistingGui(_cn50j400("\210\208\205\227\200\174\188\170\181\169\160\130\129\154\111\117\106\089\117\077\065"))
cleanupExistingGui(_cn50j400("\210\208\205\227\200\174\188\170\181\169\165\133\156\150\117\105\109\112\113\070\068\069\127\074\047"))
cleanupExistingGui(_cn50j400("\210\208\205\227\200\174\188\170\181\169\167\132\156\138\111\107\107\091\115\087\067\087\081\092\039\057\061\052\012\026"))
local announcementSerial = 0
local function showAdminAnnouncement(title, message, duration, colorHex, prefix, verified)
    duration = tonumber(duration) or 8
    announcementSerial = announcementSerial + 1
    local serial = announcementSerial
    task.spawn(function()
        local parentGui = getGuiParent()
        if not parentGui then return end
        cleanupExistingGui(_cn50j400("\210\208\205\227\200\174\188\170\181\169\165\133\156\150\117\105\109\112\113\070\068\069\127\074\047"))
        local screenGui = Instance.new(_cn50j400("\205\198\222\214\223\175\143\186\191"))
        screenGui.Name = _cn50j400("\210\208\205\227\200\174\188\170\181\169\165\133\156\150\117\105\109\112\113\070\068\069\127\074\047")
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 50
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) elseif protect_gui then protect_gui(screenGui) end end)
        screenGui.Parent = parentGui
        local card = Instance.new(_cn50j400("\216\215\205\222\223"))
        card.Name = _cn50j400("\223\203\194\220\207\175\171\170\187\184\138\159\177\152\114\099")
        card.AnchorPoint = Vector2.new(0.5, 0)
        card.Position = UDim2.new(0.5, 0, 0, -100)
        card.Size = UDim2.new(1, 0, 0, 44)
        card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        card.BackgroundTransparency = 0
        card.BorderSizePixel = 0
        card.Parent = screenGui
        local gradient = Instance.new(_cn50j400("\203\236\235\193\219\165\161\170\184\169"))
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.25, 0.4),
            NumberSequenceKeypoint.new(0.75, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        })
        gradient.Parent = card
        local contentContainer = Instance.new(_cn50j400("\216\215\205\222\223"))
        contentContainer.BackgroundTransparency = 1
        contentContainer.Size = UDim2.new(1, 0, 1, 0)
        contentContainer.Parent = card
        local listLayout = Instance.new(_cn50j400("\203\236\224\218\201\181\132\174\175\178\145\159"))
        listLayout.FillDirection = Enum.FillDirection.Horizontal
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 0)
        listLayout.Parent = contentContainer
        local nameColor = Color3.fromRGB(240, 65, 65)
        if type(colorHex) == _cn50j400("\237\209\222\218\212\166") and #colorHex >= 6 then
            local cleanHex = colorHex:gsub(_cn50j400("\189"), _cn50j400(""))
            local r = tonumber(cleanHex:sub(1, 2), 16)
            local g = tonumber(cleanHex:sub(3, 4), 16)
            local b = tonumber(cleanHex:sub(5, 6), 16)
            if r and g and b then
                nameColor = Color3.fromRGB(r, g, b)
            end
        end
        local nameLabel = Instance.new(_cn50j400("\202\192\212\199\246\160\170\170\186"))
        nameLabel.Name = _cn50j400("\208\196\193\214\246\160\170\170\186")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(0, 0, 1, 0)
        nameLabel.AutomaticSize = Enum.AutomaticSize.X
        nameLabel.Font = Enum.Font.RobotoMono
        nameLabel.TextSize = 20
        nameLabel.TextColor3 = nameColor
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.Text = tostring(prefix or _cn50j400("\210\208\205\195\200\174\188\170\181\169"))
        nameLabel.LayoutOrder = 1
        nameLabel.Parent = contentContainer
        local nameStroke = Instance.new(_cn50j400("\203\236\255\199\200\174\163\170"))
        nameStroke.Color = Color3.fromRGB(0, 0, 0)
        nameStroke.Thickness = 1
        nameStroke.Parent = nameLabel
        if verified then
            local preBadgeSpacer = Instance.new(_cn50j400("\216\215\205\222\223"))
            preBadgeSpacer.Name = _cn50j400("\206\215\201\241\219\165\175\170\133\173\133\136\151\139")
            preBadgeSpacer.BackgroundTransparency = 1
            preBadgeSpacer.Size = UDim2.new(0, 5, 1, 0)
            preBadgeSpacer.LayoutOrder = 2
            preBadgeSpacer.Parent = contentContainer
            local badge = Instance.new(_cn50j400("\215\200\205\212\223\141\169\173\179\177"))
            badge.Name = _cn50j400("\200\192\222\218\220\168\173\171\148\188\128\140\151")
            badge.BackgroundTransparency = 1
            badge.Size = UDim2.new(0, 20, 0, 20)
            badge.Image = _cn50j400("\236\199\212\210\201\178\173\187\191\185\222\196\221\200\053\063\059\044\043\020\026\000\000\011")
            badge.LayoutOrder = 3
            badge.Parent = contentContainer
            local badgeSpacer = Instance.new(_cn50j400("\216\215\205\222\223"))
            badgeSpacer.Name = _cn50j400("\220\196\200\212\223\146\184\174\181\184\150")
            badgeSpacer.BackgroundTransparency = 1
            badgeSpacer.Size = UDim2.new(0, 5, 1, 0)
            badgeSpacer.LayoutOrder = 4
            badgeSpacer.Parent = contentContainer
        end
        local msgLabel = Instance.new(_cn50j400("\202\192\212\199\246\160\170\170\186"))
        msgLabel.Name = _cn50j400("\211\192\223\192\219\166\173\131\183\191\129\135")
        msgLabel.BackgroundTransparency = 1
        msgLabel.Size = UDim2.new(0, 0, 1, 0)
        msgLabel.AutomaticSize = Enum.AutomaticSize.X
        msgLabel.Font = Enum.Font.RobotoMono
        msgLabel.TextSize = 20
        msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextYAlignment = Enum.TextYAlignment.Center
        msgLabel.Text = _cn50j400("\164\133") .. tostring(message or _cn50j400(""))
        msgLabel.LayoutOrder = 5
        msgLabel.Parent = contentContainer
        local msgStroke = Instance.new(_cn50j400("\203\236\255\199\200\174\163\170"))
        msgStroke.Color = Color3.fromRGB(0, 0, 0)
        msgStroke.Thickness = 1
        msgStroke.Parent = msgLabel
        TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, 60)
        }):Play()
        task.delay(duration, function()
            if announcementSerial ~= serial or not card.Parent then return end
            local tween = TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, -100)
            })
            tween:Play()
            tween.Completed:Connect(function()
                if announcementSerial == serial and card then card:Destroy() end
            end)
        end)
    end)
end
local CONSOLE_TOAST_LIMIT = 4
local CONSOLE_TOAST_WIDTH = 340
local CONSOLE_TOAST_HEIGHT = 68
local CONSOLE_TOAST_MAX_TEXT = 1000
local consoleToastSerial = 0
local consoleToastEntries = {}
local recentConsoleOutput = {}
local function themeColor(hex, fallback)
    hex = tostring(hex or _cn50j400("")):gsub(_cn50j400("\189"), _cn50j400(""))
    if #hex ~= 6 or not hex:match(_cn50j400("\192\128\212\152\158")) then return fallback end
    return Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
end
local THEME_BG = themeColor("", Color3.fromRGB(20, 20, 20))
local PROMPT_FOR_KEY = false
local THEME_TEXT = themeColor("", Color3.fromRGB(255, 255, 255))
local THEME_ACCENT = themeColor("", nil) 
local THEME_MUTED = THEME_TEXT:Lerp(THEME_BG, 0.4)
local fontBold = Enum.Font.RobotoMono
local fontRegular = Enum.Font.RobotoMono
pcall(function()
    if not Enum.Font.RobotoMono then
        fontBold = Enum.Font.Code
        fontRegular = Enum.Font.Code
    end
end)
local function consoleOutputStyle(level)
    if level == _cn50j400("\251\215\222\220\200") then
        return {
            title = (label ~= _cn50j400("") and label ~= _cn50j400("\210\208\205\195\200\174\188\170\181\169") and label) or _cn50j400("\210\208\205\227\200\174\188\170\181\169\196\174\128\139\111\117"),
            accent = Color3.fromRGB(239, 68, 68),
            icon = _cn50j400("\236\199\212\210\201\178\173\187\191\185\222\196\221\200\048\048\058\034\047\027\030\002\001\011"),
            duration = 8
        }
    elseif level == _cn50j400("\233\196\222\221\211\175\175") then
        return {
            title = (label ~= _cn50j400("") and label ~= _cn50j400("\210\208\205\195\200\174\188\170\181\169") and label) or _cn50j400("\201\196\222\221\211\175\175"),
            accent = Color3.fromRGB(245, 158, 11),
            icon = _cn50j400("\236\199\212\210\201\178\173\187\191\185\222\196\221\200\048\048\062\044\043\022\025\000\012\006"),
            duration = 8
        }
    elseif level == _cn50j400("\237\208\207\208\223\178\187") then
        return {
            title = (label ~= _cn50j400("") and label ~= _cn50j400("\210\208\205\195\200\174\188\170\181\169") and label) or _cn50j400("\210\208\205\227\200\174\188\170\181\169"),
            accent = Color3.fromRGB(16, 185, 129),
            icon = _cn50j400("\236\199\212\210\201\178\173\187\191\185\222\196\221\200\048\048\062\044\043\026\026\007\012\011"),
            duration = 6
        }
    end
    return {
        title = (label ~= _cn50j400("") and label ~= _cn50j400("\210\208\205\195\200\174\188\170\181\169") and label) or _cn50j400("\210\208\205\227\200\174\188\170\181\169"),
        accent = THEME_ACCENT or Color3.fromRGB(59, 130, 246),
        icon = _cn50j400("\236\199\212\210\201\178\173\187\191\185\222\196\221\200\048\048\062\044\043\022\024\008\001\009"),
        duration = 6
    }
end
local function trimConsoleOutput(value)
    local text = tostring(value or _cn50j400("")):gsub(_cn50j400("\147"), _cn50j400("")):gsub(_cn50j400("\192\128\223\152"), _cn50j400("")):gsub(_cn50j400("\187\214\135\151"), _cn50j400(""))
    if #text > CONSOLE_TOAST_MAX_TEXT then
        text = text:sub(1, CONSOLE_TOAST_MAX_TEXT - 3) .. _cn50j400("\176\139\130")
    end
    return text
end
local function isConsoleError(value)
    local text = string.lower(tostring(value or _cn50j400("")))
    local errorMarkers = {
        _cn50j400("\251\215\222\220\200"), _cn50j400("\248\196\197\223\223\165"), _cn50j400("\248\196\197\223\207\179\173"), _cn50j400("\253\202\217\223\222\225\166\160\162"), _cn50j400("\253\196\194\221\213\181"), _cn50j400("\247\203\218\210\214\168\172\239\189\184\157"),
        _cn50j400("\252\196\194\221\223\165"), _cn50j400("\236\192\202\198\201\164\172"), _cn50j400("\236\196\216\214\154\173\161\162\191\169\129\143"), _cn50j400("\237\208\220\214\200\178\173\171\179\185"),
    }
    for _, marker in ipairs(errorMarkers) do
        if text:find(marker, 1, true) then return true end
    end
    return false
end
local function isConsoleSuccess(value)
    local text = string.lower(tostring(value or _cn50j400("")))
    local successMarkers = {
        _cn50j400("\253\202\194\221\223\162\188\170\178"), _cn50j400("\255\208\216\219\223\175\188\166\181\188\144\142\150"), _cn50j400("\237\208\207\208\223\178\187"), _cn50j400("\237\192\207\198\200\164\164\182"), _cn50j400("\255\208\216\219\213\179\161\181\179\185"), _cn50j400("\242\202\205\215\223\165")
    }
    for _, marker in ipairs(successMarkers) do
        if text:find(marker, 1, true) then return true end
    end
    return false
end
local function removeConsoleToast(entry, immediate)
    if not entry or entry.removed then return end
    entry.removed = true
    for index, activeEntry in ipairs(consoleToastEntries) do
        if activeEntry == entry then
            table.remove(consoleToastEntries, index)
            break
        end
    end
    if not entry.card or not entry.card.Parent then return end
    if immediate then
        entry.card:Destroy()
        return
    end
    local fadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    pcall(function()
        TweenService:Create(entry.card, fadeInfo, { BackgroundTransparency = 1, Position = UDim2.new(0, 24, 0, 0) }):Play()
        if entry.stroke then TweenService:Create(entry.stroke, fadeInfo, { Transparency = 1 }):Play() end
        if entry.iconFrame then TweenService:Create(entry.iconFrame, fadeInfo, { BackgroundTransparency = 1 }):Play() end
        if entry.iconImg then TweenService:Create(entry.iconImg, fadeInfo, { ImageTransparency = 1 }):Play() end
        TweenService:Create(entry.title, fadeInfo, { TextTransparency = 1 }):Play()
        local messageTween = TweenService:Create(entry.message, fadeInfo, { TextTransparency = 1 })
        messageTween:Play()
        messageTween.Completed:Connect(function()
            if entry.card then entry.card:Destroy() end
        end)
    end)
end
local DISABLE_NOTIFICATIONS = 0 == 1
local function showConsoleNotification(level, message)
    if DISABLE_NOTIFICATIONS then return end
    pcall(function()
        local text = trimConsoleOutput(message)
        if text == _cn50j400("") then return end
        local now = tick()
        local outputKey = tostring(level) .. _cn50j400("\164") .. text
        if recentConsoleOutput[outputKey] and now - recentConsoleOutput[outputKey] < 1.5 then return end
        recentConsoleOutput[outputKey] = now
        for key, timestamp in pairs(recentConsoleOutput) do
            if now - timestamp > 8 then recentConsoleOutput[key] = nil end
        end
        local parentGui = getGuiParent()
        if not parentGui then return end
        local screenGui = parentGui:FindFirstChild(_cn50j400("\210\208\205\227\200\174\188\170\181\169\167\132\156\138\111\107\107\091\115\087\067\087\081\092\039\057\061\052\012\026"))
        if not screenGui then
            screenGui = Instance.new(_cn50j400("\205\198\222\214\223\175\143\186\191"))
            screenGui.Name = _cn50j400("\210\208\205\227\200\174\188\170\181\169\167\132\156\138\111\107\107\091\115\087\067\087\081\092\039\057\061\052\012\026")
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            screenGui.DisplayOrder = 25
            screenGui.Parent = parentGui
        end
        local stack = screenGui:FindFirstChild(_cn50j400("\208\202\216\218\220\168\171\174\162\180\139\133\161\141\097\100\101"))
        if not stack then
            stack = Instance.new(_cn50j400("\216\215\205\222\223"))
            stack.Name = _cn50j400("\208\202\216\218\220\168\171\174\162\180\139\133\161\141\097\100\101")
            stack.AnchorPoint = Vector2.new(1, 1)
            stack.Position = UDim2.new(1, -16, 1, -16)
            stack.Size = UDim2.new(0, CONSOLE_TOAST_WIDTH, 0, 0)
            stack.AutomaticSize = Enum.AutomaticSize.Y
            stack.Active = false
            stack.BackgroundTransparency = 1
            stack.BorderSizePixel = 0
            stack.Parent = screenGui
            local sizeConstraint = Instance.new(_cn50j400("\203\236\255\218\192\164\139\160\184\174\144\153\147\144\110\115"))
            sizeConstraint.MaxSize = Vector2.new(CONSOLE_TOAST_WIDTH, 720)
            sizeConstraint.MinSize = Vector2.new(0, 0)
            sizeConstraint.Parent = stack
            local layout = Instance.new(_cn50j400("\203\236\224\218\201\181\132\174\175\178\145\159"))
            layout.Name = _cn50j400("\205\209\205\208\209\141\169\182\185\168\144")
            layout.FillDirection = Enum.FillDirection.Vertical
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 8)
            layout.Parent = stack
        end
        while #consoleToastEntries >= CONSOLE_TOAST_LIMIT do
            removeConsoleToast(consoleToastEntries[1], true)
        end
        local style = consoleOutputStyle(level)
        consoleToastSerial = consoleToastSerial + 1
        local card = Instance.new(_cn50j400("\216\215\205\222\223"))
        card.Name = _cn50j400("\221\202\194\192\213\173\173\155\185\188\151\159")
        card.LayoutOrder = consoleToastSerial
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = THEME_BG
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = stack
        local corner = Instance.new(_cn50j400("\203\236\239\220\200\175\173\189"))
        corner.CornerRadius = UDim.new(0, 3)
        corner.Parent = card
        local stroke = Instance.new(_cn50j400("\203\236\255\199\200\174\163\170"))
        stroke.Color = Color3.fromRGB(45, 45, 45)
        stroke.Transparency = 1
        stroke.Thickness = 1
        stroke.Parent = card
        local cardPadding = Instance.new(_cn50j400("\203\236\252\210\222\165\161\161\177"))
        cardPadding.PaddingTop = UDim.new(0, 12)
        cardPadding.PaddingBottom = UDim.new(0, 12)
        cardPadding.PaddingLeft = UDim.new(0, 14)
        cardPadding.PaddingRight = UDim.new(0, 12)
        cardPadding.Parent = card
        local row = Instance.new(_cn50j400("\216\215\205\222\223"))
        row.Name = _cn50j400("\204\202\219")
        row.Size = UDim2.new(1, 0, 0, 0)
        row.AutomaticSize = Enum.AutomaticSize.Y
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.Parent = card
        local rowLayout = Instance.new(_cn50j400("\203\236\224\218\201\181\132\174\175\178\145\159"))
        rowLayout.FillDirection = Enum.FillDirection.Horizontal
        rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        rowLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rowLayout.Padding = UDim.new(0, 10)
        rowLayout.Parent = row
        local iconFrame = Instance.new(_cn50j400("\216\215\205\222\223"))
        iconFrame.Size = UDim2.new(0, 24, 0, 24)
        iconFrame.BackgroundColor3 = style.accent
        iconFrame.BackgroundTransparency = 1
        iconFrame.BorderSizePixel = 0
        iconFrame.LayoutOrder = 1
        iconFrame.Parent = row
        local iconCorner = Instance.new(_cn50j400("\203\236\239\220\200\175\173\189"))
        iconCorner.CornerRadius = UDim.new(0, 3)
        iconCorner.Parent = iconFrame
        local iconImg = Instance.new(_cn50j400("\215\200\205\212\223\141\169\173\179\177"))
        iconImg.Name = _cn50j400("\215\198\195\221")
        iconImg.Size = UDim2.new(0, 16, 0, 16)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.BackgroundTransparency = 1
        iconImg.BorderSizePixel = 0
        iconImg.Image = style.icon
        iconImg.ImageColor3 = style.accent
        iconImg.ImageTransparency = 1
        iconImg.Parent = iconFrame
        local content = Instance.new(_cn50j400("\216\215\205\222\223"))
        content.Name = _cn50j400("\221\202\194\199\223\175\188")
        content.Size = UDim2.new(1, -34, 0, 0)
        content.AutomaticSize = Enum.AutomaticSize.Y
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.LayoutOrder = 2
        content.Parent = row
        local contentLayout = Instance.new(_cn50j400("\203\236\224\218\201\181\132\174\175\178\145\159"))
        contentLayout.FillDirection = Enum.FillDirection.Vertical
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 2)
        contentLayout.Parent = content
        local titleLabel = Instance.new(_cn50j400("\202\192\212\199\246\160\170\170\186"))
        titleLabel.Name = _cn50j400("\202\204\216\223\223")
        titleLabel.Size = UDim2.new(1, 0, 0, 16)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = fontBold
        titleLabel.Text = style.title
        titleLabel.TextSize = 13
        titleLabel.TextColor3 = THEME_TEXT
        titleLabel.TextTransparency = 1
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextYAlignment = Enum.TextYAlignment.Center
        titleLabel.LayoutOrder = 1
        titleLabel.Parent = content
        local messageLabel = Instance.new(_cn50j400("\202\192\212\199\246\160\170\170\186"))
        messageLabel.Name = _cn50j400("\211\192\223\192\219\166\173")
        messageLabel.Size = UDim2.new(1, 0, 0, 0)
        messageLabel.AutomaticSize = Enum.AutomaticSize.Y
        messageLabel.BackgroundTransparency = 1
        messageLabel.Font = fontRegular
        messageLabel.Text = text
        messageLabel.TextSize = 12
        messageLabel.TextColor3 = THEME_MUTED
        messageLabel.TextTransparency = 1
        messageLabel.TextWrapped = true
        messageLabel.TextTruncate = Enum.TextTruncate.None
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextYAlignment = Enum.TextYAlignment.Top
        messageLabel.LayoutOrder = 2
        messageLabel.Parent = content
        local entry = {
            card = card,
            stroke = stroke,
            iconFrame = iconFrame,
            iconImg = iconImg,
            title = titleLabel,
            message = messageLabel,
            removed = false,
        }
        table.insert(consoleToastEntries, entry)
        card.Position = UDim2.new(0, 20, 0, 0)
        local fadeIn = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(card, fadeIn, { BackgroundTransparency = 0.05, Position = UDim2.new(0, 0, 0, 0) }):Play()
        TweenService:Create(stroke, fadeIn, { Transparency = 0 }):Play()
        TweenService:Create(iconFrame, fadeIn, { BackgroundTransparency = 0.86 }):Play()
        TweenService:Create(iconImg, fadeIn, { ImageTransparency = 0 }):Play()
        TweenService:Create(titleLabel, fadeIn, { TextTransparency = 0 }):Play()
        TweenService:Create(messageLabel, fadeIn, { TextTransparency = 0 }):Play()
        task.delay(style.duration, function() removeConsoleToast(entry, false) end)
    end)
end
local function runnerWarn(message)
    local text = tostring(message or _cn50j400(""))
    warn(_cn50j400("\197") .. label .. _cn50j400("\195\133") .. text)
    local level = isConsoleError(text) and _cn50j400("\251\215\222\220\200") or _cn50j400("\233\196\222\221\211\175\175")
    showConsoleNotification(level, text)
end
local linkPanel = nil
local DISCORD_BLURPLE = THEME_ACCENT or Color3.fromRGB(88, 101, 242)
local function formatLinkCode(code)
    code = tostring(code or _cn50j400(""))
    if #code == 6 then return code:sub(1, 3) .. _cn50j400("\190") .. code:sub(4, 6) end
    return code
end
local function hideDiscordLinkPanel(linked)
    local panel = linkPanel
    if not panel then return end
    linkPanel = nil
    panel.closed = true
    pcall(function()
        if linked then
            panel.title.Text = _cn50j400("\218\204\223\208\213\179\172\239\186\180\138\128\151\157")
            panel.message.Text = _cn50j400("\205\209\205\193\206\168\166\168\246\169\140\142\210\138\099\117\103\101\104\013\004\031")
            panel.codeLabel.Text = _cn50j400("\218\202\194\214")
            panel.codeLabel.TextColor3 = Color3.fromRGB(16, 185, 129)
            panel.timer.Text = _cn50j400("")
            task.wait(1.2)
        end
        local fade = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(panel.card, fade, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 16) }):Play()
        for _, obj in ipairs(panel.card:GetDescendants()) do
            if obj:IsA(_cn50j400("\202\192\212\199\246\160\170\170\186")) or obj:IsA(_cn50j400("\202\192\212\199\248\180\188\187\185\179")) then
                TweenService:Create(obj, fade, { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
            elseif obj:IsA(_cn50j400("\215\200\205\212\223\141\169\173\179\177")) then
                TweenService:Create(obj, fade, { ImageTransparency = 1, BackgroundTransparency = 1 }):Play()
            elseif obj:IsA(_cn50j400("\203\236\255\199\200\174\163\170")) then
                TweenService:Create(obj, fade, { Transparency = 1 }):Play()
            elseif obj:IsA(_cn50j400("\216\215\205\222\223")) and obj.BackgroundTransparency < 1 then
                TweenService:Create(obj, fade, { BackgroundTransparency = 1 }):Play()
            end
        end
        task.wait(0.3)
        if panel.gui then panel.gui:Destroy() end
    end)
end
local function showDiscordLinkPanel(info, sendEvent)
    -- Discord link panel kept (not part of key system)
end
local function showKeyPromptPanel(submitCallback)
    -- Key prompt completely disabled
    if submitCallback then
        submitCallback("")
    end
end
local function getProvidedKey()
    return ""
end
local function fetchRunnerKey()
    return true
end
local function tryConnect(isInternalReconnect)
    if not isCurrentSession() then
        return nil, true, _cn50j400("\205\240\252\246\232\146\141\139\147\153")
    end
    local currentKeyCode = ""
    local success, response, retryAfter, rejectMsg = makeRequest(HOST_URL .. _cn50j400("\177\196\220\218\149\160\189\187\190\242\144\132\153\156\110"), {
        userId = userId, username = username, placeId = placeId, jobId = jobId, gameId = gameId,
        hwid = hwid, scriptId = SCRIPT_ID, scriptName = SCRIPT_NAME, executor = executor,
        keyCode = currentKeyCode, runnerId = RUNNER_ID, isReconnect = isInternalReconnect or false, sessionId = CURRENT_SESSION, runId = RUN_ID,
        caps = { chunks = true }
    }, isInternalReconnect)
    if not success then
        if response == _cn50j400("\204\228\248\246\229\141\129\130\159\137\161\175") then
            local waitTime = retryAfter or 15
            runnerWarn(_cn50j400("\204\196\216\214\154\173\161\162\191\169\129\143\210\212\032\112\111\124\104\074\068\086\024") .. waitTime .. _cn50j400("\237\133\206\214\220\174\186\170\246\175\129\159\128\128"))
            waitWithCountdown(waitTime)
            return nil, false
        elseif response == _cn50j400("\201\247\227\253\253\158\143\142\155\152") or response == _cn50j400("\217\228\225\246\229\147\141\156\130\143\173\168\166\188\068") then
            runnerWarn(rejectMsg or _cn50j400("\201\215\195\221\221\225\175\174\187\184\196\198\210\141\104\110\125\053\111\064\088\088\072\075\102\036\039\123\014\006\019\028\027\225\172\231\245\129\201\143\210\212\162\173\183\171\133\137\154\213\155\098\103\116"))
            return nil, true, nil
        elseif response == _cn50j400("\219\253\233\240\239\149\135\157\137\143\161\184\166\171\073\068\090\080\088") then
            runnerWarn(rejectMsg or _cn50j400("\199\202\217\193\154\164\176\170\181\168\144\132\128\217\105\116\046\123\115\087\010\080\072\079\052\034\034\062\006\073\022\024\012\165\248\251\243\210\136\220\213\207\173\187\166\247\192\190\129\128\142\035\107\114\123\112\083\067\064\027\043\058\112\025\017\049\076\000\015\242\248\234\248\249\193\207\146\148\224\179\166\176\252\144\137\131\145\143\114\045\123\108\076\076\066\023\081\043\032\042\122\000\004\003\025\010\247\171\225\233\197\196\199\211\213\160\234\180\160\186\133\152\128\148\112\122\062"))
            return nil, true, nil
        elseif response and response:find(_cn50j400("\205\240\252\246\232\146\141\139\147\153"), 1, true) then
            reconnectDisabled = true
            print(_cn50j400("\197") .. label .. _cn50j400("\195\133\255\198\202\164\186\188\179\185\129\143\210\155\121\039\111\053\114\070\093\084\074\031\035\053\049\056\023\029\031\005\094\247\249\253\161\129\219\219\217\205\180\162\188\190\192\149\139\150\147\109\100\116\123\107\085\003"))
            return nil, true, _cn50j400("\205\240\252\246\232\146\141\139\147\153")
        elseif response and (response:find(_cn50j400("\213\224\245\236\232\132\153\154\159\143\161\175")) or response:find(_cn50j400("\213\192\213\147\232\164\185\186\191\175\129\143"))) then
            -- Key-related rejection ignored — force continue
            runnerWarn("Key system bypassed — continuing without key")
            return nil, false
        elseif response and type(response) == _cn50j400("\237\209\222\218\212\166") and response:sub(1, 7) == _cn50j400("\220\228\226\253\255\133\242") then
            local reason = _cn50j400("\199\202\217\147\219\179\173\239\180\188\138\133\151\157\046")
            pcall(function()
                local body = response:sub(8)
                local data = HttpService:JSONDecode(body)
                if data then reason = tostring(data.message or data.reason or data.error or _cn50j400("\199\202\217\147\219\179\173\239\180\188\138\133\151\157\046")) end
            end)
            runnerWarn(reason)
            return nil, true, reason
        elseif response:find(_cn50j400("\205\224\254\229\255\147\151\138\132\143\171\185"), 1, true) then
            local serverDetail = response:gsub(_cn50j400("\192\246\233\225\236\132\154\144\147\143\182\164\160\217"), _cn50j400(""))
            runnerQuiet(_cn50j400("\205\192\222\197\223\179\232\186\184\188\146\138\155\149\097\101\098\112\060\011") .. serverDetail .. _cn50j400("\183\158\140\196\211\173\164\239\164\184\144\153\139"))
            return nil, false, _cn50j400("\202\247\237\253\233\136\141\129\130")
        elseif response:find(_cn50j400("\208\224\248\228\245\147\131\144\147\143\182\164\160"), 1, true) then
            local netDetail = response:gsub(_cn50j400("\192\235\233\231\237\142\154\132\137\152\182\185\189\171\032"), _cn50j400(""))
            runnerQuiet(_cn50j400("\208\192\216\196\213\179\163\239\179\175\150\132\128\217\114\098\111\118\116\074\068\086\024\076\035\063\034\062\016\073\088") .. netDetail .. _cn50j400("\183\158\140\196\211\173\164\239\164\184\144\153\139"))
            return nil, false, _cn50j400("\202\247\237\253\233\136\141\129\130")
        else
            runnerWarn(_cn50j400("\223\208\216\219\154\167\169\166\186\184\128\209\210") .. tostring(response))
            return nil, true
        end
    end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, response)
    if not ok or not data or not data.token then
        runnerWarn(_cn50j400("\220\196\200\147\219\180\188\167\246\175\129\152\130\150\110\116\107\047\060") .. tostring(response))
        return nil, false
    end
    MY_LAST_CONNECT_ATTEMPT = os.clock()
    if getgenv then getgenv()._luaprotect_last_connect_attempt = MY_LAST_CONNECT_ATTEMPT end
    local ws = openWebSocket(WS_URL .. _cn50j400("\161\209\195\216\223\175\245") .. data.token)
    if not ws then
        runnerWarn(_cn50j400("\221\202\217\223\222\225\166\160\162\253\139\155\151\151\032\080\107\119\079\076\073\090\093\075"))
        return nil, false
    end
    if _LP_STORE then _LP_STORE.sockets[SCRIPT_TAG] = ws end
    if SCRIPT_TAG == _cn50j400("\250\192\202\210\207\173\188") then
        if getgenv then getgenv().sentinel_ws = ws end
        if shared then shared.sentinel_ws = ws end
        if _G then _G.sentinel_ws = ws end
    end
    connectionOpenedAt = os.clock()
    local lastReportedErrors = {}
    local function sendErrorReport(errMsg, stackTrace)
        local msgKey = tostring(errMsg)
        local now = os.time()
        if lastReportedErrors[msgKey] and (now - lastReportedErrors[msgKey]) < 3 then return end
        lastReportedErrors[msgKey] = now
        pcall(function()
            if ws then
                local reportStr = HttpService:JSONEncode({ type = _cn50j400("\237\198\222\218\202\181\151\189\179\173\139\153\134"), level = _cn50j400("\251\215\222\220\200"), message = msgKey, stackTrace = tostring(stackTrace or _cn50j400("")) })
                if ws.Send then ws:Send(reportStr)
                elseif ws.send then ws:send(reportStr) end
            end
        end)
    end
    local chunkState = nil
    local wsConnections = {}
    local function bindSignal(signalName, altName, handler)
        pcall(function()
            local sig = ws[signalName] or ws[altName]
            if sig and (typeof(sig) == _cn50j400("\204\231\244\224\217\179\161\191\162\142\141\140\156\152\108") or sig.Connect) then
                local conn = sig:Connect(handler)
                if conn then table.insert(wsConnections, conn) end
            end
        end)
        pcall(function()
            if not ws[signalName] and not ws[altName] then ws[signalName] = handler; ws[altName] = handler end
        end)
    end
    local function executeScriptPayload(decryptedOrErr)
        if decryptedOrErr:sub(1, 3) == _cn50j400("\113\030\019") then
            decryptedOrErr = decryptedOrErr:sub(4)
        end
        decryptedOrErr = decryptedOrErr:gsub(_cn50j400("\187\136\137\158\159\154\245\234\141\253\191\181\215\164\093\045\043\072\033\006\119"), function(comment)
            return (comment:gsub(_cn50j400("\113\030\019"), _cn50j400("")):gsub(_cn50j400("\124\037\247\056\151\078\149"), _cn50j400("")))
        end)
        local isKickPayload = decryptedOrErr:sub(1, 21) == _cn50j400("\179\136\140\232\246\180\169\159\164\178\144\142\145\141\032\076\103\118\119\126\032")
        if isKickPayload then
            if not isCurrentSession() then return end
            local kickFn, kickErr = loadstring(decryptedOrErr)
            if not kickFn then
                runnerWarn(_cn50j400("\213\204\207\216\154\177\169\182\186\178\133\143\210\156\114\117\097\103\038\003") .. tostring(kickErr))
                return
            end
            pcall(kickFn)
            return
        end
        if not isCurrentSession() then return end
        local executedStore = (_LP_STORE and _LP_STORE.executed[SCRIPT_TAG])
        if not executedStore and SCRIPT_TAG == _cn50j400("\250\192\202\210\207\173\188") then
            executedStore = (getgenv and getgenv()._luaprotect_executed) or (shared and shared._luaprotect_executed)
        end
        if not executedStore then
            executedStore = {}
            if _LP_STORE then _LP_STORE.executed[SCRIPT_TAG] = executedStore end
            if SCRIPT_TAG == _cn50j400("\250\192\202\210\207\173\188") then
                if getgenv then getgenv()._luaprotect_executed = executedStore else shared._luaprotect_executed = executedStore end
            end
        end
        if not isCurrentSession() then return end
        local dedupKey = tostring(#decryptedOrErr) .. _cn50j400("\164") .. decryptedOrErr:sub(1, 256) .. decryptedOrErr:sub(-256)
        if executedStore[dedupKey] then
            runnerWarn(_cn50j400("\205\198\222\218\202\181\232\174\186\175\129\138\150\128\032\098\118\112\127\086\094\084\092\031\047\035\116\047\010\000\003\087\013\224\255\224\243\206\198\148\150\206\175\162\162\169\137\137\137\213\152\118\122\125\113\124\071\089\081\027\039\049\053\052\043\017\005\028\020"))
            return
        end
        local storeCount = 0
        for _ in pairs(executedStore) do storeCount = storeCount + 1 end
        if storeCount > 16 then
            for key in pairs(executedStore) do executedStore[key] = nil end
        end
        executedStore[dedupKey] = true
        local isBlockedNotice = decryptedOrErr:sub(1, 23) == _cn50j400("\179\136\140\232\246\180\169\159\164\178\144\142\145\141\032\069\098\122\127\072\079\085\101")
        local fn, err = loadstring(decryptedOrErr, _cn50j400("\163") .. tostring(SCRIPT_NAME ~= _cn50j400("") and SCRIPT_NAME or _cn50j400("\210\208\205\227\200\174\188\170\181\169")))
        if not fn then
            runnerWarn(_cn50j400("\210\202\205\215\201\181\186\166\184\186\196\142\128\139\111\117\052\053") .. tostring(err))
            sendErrorReport(_cn50j400("\210\202\205\215\201\181\186\166\184\186\196\136\157\148\112\110\098\116\104\074\069\095\024\090\052\063\059\041\088\073") .. tostring(err), debug and debug.traceback and debug.traceback() or _cn50j400(""))
            return
        end
        local execOk, execErr = pcall(fn)
        if not isBlockedNotice then
            if not execOk then
                runnerWarn(_cn50j400("\219\221\201\208\207\181\161\160\184\253\129\153\128\150\114\061\046") .. tostring(execErr))
                sendErrorReport(tostring(execErr), debug and debug.traceback and debug.traceback() or _cn50j400(""))
            end
        end
    end
    local function handleIncomingMessage(hexPayload)
        task.spawn(function()
            local decOk, decryptedOrErr = pcall(decryptXOR, hexPayload, data.token)
            if not decOk then return end
            if decryptedOrErr:sub(1, 1) == _cn50j400("\229") then
                local parseOk, parsed = pcall(HttpService.JSONDecode, HttpService, decryptedOrErr)
                if parseOk and type(parsed) == _cn50j400("\234\196\206\223\223") and parsed.lp_event == _cn50j400("\250\204\223\208\213\179\172\144\186\180\138\128\173\139\101\118\123\124\110\070\078") then
                    showDiscordLinkPanel(parsed, function(event)
                        local req = HttpService:JSONEncode(event)
                        if ws.Send then ws:Send(req) elseif ws.send then ws:send(req) end
                    end)
                    return
                end
                if parseOk and type(parsed) == _cn50j400("\234\196\206\223\223") and parsed.lp_event == _cn50j400("\250\204\223\208\213\179\172\144\186\180\138\128\173\156\114\117\097\103") then
                    showDiscordLinkError(parsed.message)
                    return
                end
                if parseOk and type(parsed) == _cn50j400("\234\196\206\223\223") and parsed.lp_event == _cn50j400("\250\204\223\208\213\179\172\144\186\180\138\128\151\157") then
                    task.spawn(hideDiscordLinkPanel, true)
                    return
                end
                if parseOk and type(parsed) == _cn50j400("\234\196\206\223\223") and parsed.lp_event == _cn50j400("\255\193\193\218\212\158\169\161\184\178\145\133\145\156\109\098\096\097") then
                    showAdminAnnouncement(parsed.title, parsed.message, parsed.duration, parsed.color, parsed.prefix, parsed.verified)
                    return
                end
                if parseOk and type(parsed) == _cn50j400("\234\196\206\223\223") and parsed.lp_event == _cn50j400("\247\203\216\214\221\179\161\187\175\130\135\131\147\149\108\098\096\114\121") then
                    task.spawn(function()
                        local nonce = tostring(parsed.nonce or _cn50j400(""))
                        local seed = tostring(parsed.seed or _cn50j400(""))
                        local tampered = false
                        local reason = _cn50j400("")
                        pcall(function()
                            if not isLowSyncExecutor then
                                if getrawmetatable and islclosure and islclosure(getrawmetatable) then tampered = true; reason = _cn50j400("\249\192\216\193\219\182\165\170\162\188\144\138\144\149\101\039\106\112\104\076\095\067") end
                                if hookmetamethod and islclosure and islclosure(hookmetamethod) then tampered = true; reason = _cn50j400("\246\202\195\216\215\164\188\174\187\184\144\131\157\157\032\099\107\097\115\086\088") end
                            end
                            if type(loadstring) ~= _cn50j400("\248\208\194\208\206\168\167\161") or type(pcall) ~= _cn50j400("\248\208\194\208\206\168\167\161") then
                                tampered = true; reason = _cn50j400("\253\202\222\214\154\166\164\160\180\188\136\152\210\154\111\117\124\096\108\087\079\085")
                            end
                            if not isLowSyncExecutor and getrawmetatable and type(game) == _cn50j400("\235\214\201\193\222\160\188\174") then
                                local metaOk, meta = pcall(getrawmetatable, game)
                                if metaOk and type(meta) == _cn50j400("\234\196\206\223\223") then
                                    local nc = rawget(meta, _cn50j400("\193\250\194\210\215\164\171\174\186\177"))
                                    if nc and islclosure and islclosure(nc) then
                                        tampered = true; reason = _cn50j400("\249\196\193\214\154\158\151\161\183\176\129\136\147\149\108\039\102\122\115\072\079\085")
                                    end
                                end
                            end
                            if getgenv then
                                local genv = getgenv()
                                if genv.dump or genv.Hydroxide or genv.SimpleSpy then
                                    tampered = true; reason = _cn50j400("\255\198\216\218\204\164\232\188\181\175\141\155\134\217\100\114\099\101\121\081\010\030\024\076\054\052\116\047\013\006\028\087\026\224\248\246\249\213\205\203")
                                end
                            end
                        end)
                        local canonicalPayload = nonce .. _cn50j400("\176") .. seed .. _cn50j400("\176") .. tostring(RUN_ID or _cn50j400("")) .. _cn50j400("\176") .. tostring(CURRENT_SESSION or _cn50j400("")) .. _cn50j400("\176") .. (tampered and _cn50j400("\175") or _cn50j400("\174"))
                        local challengeSig = sha256.hmac(SECRET_KEY, canonicalPayload)
                        local respPayload = HttpService:JSONEncode({
                            event = _cn50j400("\247\203\216\214\221\179\161\187\175\130\150\142\129\137\111\105\125\112"),
                            timestamp = os.time(),
                            challengeResponse = challengeSig,
                            tampered = tampered,
                            reason = reason
                        })
                        pcall(function()
                            if ws.Send then ws:Send(respPayload)
                            elseif ws.send then ws:send(respPayload) end
                        end)
                    end)
                    return
                end
                if parseOk and type(parsed) == _cn50j400("\234\196\206\223\223") and parsed.lp_chunk then
                    if parsed.lp_chunk == _cn50j400("\237") then
                        chunkState = { id = parsed.id, total = tonumber(parsed.total) or 0, len = tonumber(parsed.len) or 0, parts = {} }
                    elseif parsed.lp_chunk == _cn50j400("\250") and chunkState and parsed.id == chunkState.id then
                        local seq = tonumber(parsed.seq) or (#chunkState.parts + 1)
                        chunkState.parts[seq] = tostring(parsed.data or _cn50j400(""))
                    elseif parsed.lp_chunk == _cn50j400("\251") and chunkState and parsed.id == chunkState.id then
                        local full = table.concat(chunkState.parts)
                        local expectedLen = chunkState.len
                        chunkState = nil
                        if #full == expectedLen then
                            local decOkChunk, unencryptedScript = pcall(decryptXOR, full, data.token)
                            if decOkChunk then
                                executeScriptPayload(unencryptedScript)
                            else
                                runnerWarn(_cn50j400("\221\205\217\221\209\225\172\170\181\175\157\155\134\144\111\105\046\112\110\081\069\067\002\031") .. tostring(unencryptedScript))
                                sendErrorReport(_cn50j400("\253\205\217\221\209\164\172\239\165\190\150\130\130\141\032\099\107\118\110\090\090\069\081\080\040\109\050\058\011\005\021\019\068\165") .. tostring(unencryptedScript), _cn50j400(""))
                            end
                        else
                            sendErrorReport(_cn50j400("\253\205\217\221\209\164\172\239\165\190\150\130\130\141\032\117\107\116\111\080\079\092\090\083\063\109\050\058\011\005\021\019\094\173\224\246\244\198\220\199\150\208\173\184\191\184\148\132\134\220"), _cn50j400(""))
                        end
                    end
                    return
                end
            end
            executeScriptPayload(decryptedOrErr)
        end)
    end
    bindSignal(_cn50j400("\209\203\225\214\201\178\169\168\179"), _cn50j400("\241\203\193\214\201\178\169\168\179"), handleIncomingMessage)
    local closed = false
    hbThread = task.spawn(function()
        while ws and not closed do
            task.wait(30)
            if closed then break end
            if not isCurrentSession() then
                closeWebSocket(ws)
                break
            end
            local payload = HttpService:JSONEncode({ event = _cn50j400("\246\192\205\193\206\163\173\174\162"), timestamp = os.time() })
            pcall(function()
                if ws.Send then ws:Send(payload)
                elseif ws.send then ws:send(payload) end
            end)
        end
    end)
    local function onDisconnect(code, reason)
        if closed then return end
        closed = true
        if getgenv and type(getgenv()._luaprotect_last_connect_attempt) == _cn50j400("\240\208\193\209\223\179") then
            local globalAttempt = getgenv()._luaprotect_last_connect_attempt
            if globalAttempt ~= MY_LAST_CONNECT_ATTEMPT and (os.clock() - globalAttempt) < 3 then
                reconnectDisabled = true
                runnerQuiet(_cn50j400("\199\204\201\223\222\168\166\168\246\138\129\137\161\150\099\108\107\097\060\087\069\017\089\081\041\057\060\062\016\073\003\020\012\236\252\231\186\137\205\215\211\222\177\191\189\171\192\139\135\152\149\119\042\117\125\107\067\078\064\094\038\096\126"))
            end
        end
        local closeCode = tonumber(code)
        local closeReason = type(reason) == _cn50j400("\237\209\222\218\212\166") and reason or _cn50j400("")
        local function readCloseEvent(value)
            if type(value) ~= _cn50j400("\234\196\206\223\223") and type(value) ~= _cn50j400("\235\214\201\193\222\160\188\174") then return nil, nil end
            local eventCode, eventReason
            pcall(function()
                eventCode = tonumber(value.code or value.Code or value.statusCode or value.status or value.closeCode)
                eventReason = value.reason or value.Reason or value.message or value.Message
            end)
            return eventCode, eventReason and tostring(eventReason) or nil
        end
        local eventCode, eventReason = readCloseEvent(code)
        if eventCode then closeCode = eventCode end
        if eventReason and eventReason ~= _cn50j400("") then closeReason = eventReason end
        if not closeCode then
            local secondCode, secondReason = readCloseEvent(reason)
            closeCode = secondCode or tonumber(reason)
            if secondReason and secondReason ~= _cn50j400("") then closeReason = secondReason end
        end
        if closeCode == 4008 or closeReason:find(_cn50j400("\205\208\220\214\200\178\173\171\179\185"), 1, true) then
            reconnectDisabled = true
        end
        lastCloseWasBusy = closeCode == 4013 or closeCode == 4029
            or closeReason:find(_cn50j400("\255\209\140\208\219\177\169\172\191\169\157"), 1, true) ~= nil
            or closeReason:find(_cn50j400("\202\202\195\147\215\160\166\182\246\190\139\133\145\140\114\117\107\123\104"), 1, true) ~= nil
        if hbThread then task.cancel(hbThread) end
        chunkState = nil
        for _, conn in ipairs(wsConnections) do pcall(function() conn:Disconnect() end) end
        table.clear(wsConnections)
        closeWebSocket(ws)
        if _LP_STORE and _LP_STORE.sockets[SCRIPT_TAG] == ws then _LP_STORE.sockets[SCRIPT_TAG] = nil end
        if getgenv and getgenv().sentinel_ws == ws then getgenv().sentinel_ws = nil end
        if shared and shared.sentinel_ws == ws then shared.sentinel_ws = nil end
        if _G and _G.sentinel_ws == ws then _G.sentinel_ws = nil end
        if connectionOpenedAt then
            local livedSeconds = os.clock() - connectionOpenedAt
            if livedSeconds >= STABLE_CONNECTION_THRESHOLD_SECONDS then stableConnectionSeen = true end
            connectionOpenedAt = nil
        end
        local parts = {}
        if code ~= nil and type(code) == _cn50j400("\240\208\193\209\223\179") then table.insert(parts, _cn50j400("\253\202\200\214\135") .. tostring(code)) end
        if code ~= nil and type(code) == _cn50j400("\237\209\222\218\212\166") and code ~= _cn50j400("") then table.insert(parts, _cn50j400("\253\202\200\214\135") .. code) end
        if reason ~= nil and tostring(reason) ~= _cn50j400("") and type(reason) ~= _cn50j400("\235\214\201\193\222\160\188\174") then table.insert(parts, _cn50j400("\236\192\205\192\213\175\245") .. tostring(reason)) end
        local detail = (#parts > 0) and (_cn50j400("\190\141") .. table.concat(parts, _cn50j400("\178\133")) .. _cn50j400("\183")) or _cn50j400("")
        runnerQuiet(_cn50j400("\218\204\223\208\213\175\166\170\181\169\129\143") .. detail)
    end
    bindSignal(_cn50j400("\209\203\239\223\213\178\173"), _cn50j400("\241\203\207\223\213\178\173"), onDisconnect)
    local function handleIncomingError(err)
        runnerQuiet(_cn50j400("\201\246\140\214\200\179\167\189\236\253") .. tostring(err))
        onDisconnect()
    end
    bindSignal(_cn50j400("\209\203\233\193\200\174\186"), _cn50j400("\241\203\201\193\200\174\186"), handleIncomingError)
    return ws, false
end
if not fetchRunnerKey() then return end
if not IS_TELEPORT_RECONNECT then
    RUN_ID = tostring(RUNNER_ID) .. _cn50j400("\164") .. RUN_ID
end
if _LP_STORE then _LP_STORE.run_ids[SCRIPT_TAG] = RUN_ID end
if SCRIPT_TAG == _cn50j400("\250\192\202\210\207\173\188") then
    if getgenv then getgenv()._luaprotect_run_id = RUN_ID end
    if shared then shared._luaprotect_run_id = RUN_ID end
    if _G then _G._luaprotect_run_id = RUN_ID end
end
local CONTINUOUS_SESSION = "0" == _cn50j400("\175")
local teleportHandoffRegistered = false
local function registerTeleportHandoff()
    if not CONTINUOUS_SESSION or teleportHandoffRegistered then return end
    teleportHandoffRegistered = true
    for attempt = 1, 3 do
        local handoffOk, handoffBody = makeRequest(HOST_URL .. _cn50j400("\177\196\220\218\149\179\189\161\184\184\150\198\154\152\110\099\097\115\122"), {
            userId = userId, hwid = hwid, scriptId = SCRIPT_ID,
            runnerId = RUNNER_ID, sessionId = CURRENT_SESSION, runId = RUN_ID,
        }, false)
        if handoffOk and handoffBody then
            local parsedOk, handoffData = pcall(HttpService.JSONDecode, HttpService, handoffBody)
            if parsedOk and handoffData and handoffData.token then
                local relaunchUrl = HOST_URL .. _cn50j400("\177\196\220\218\149\179\189\161\184\184\150\198\128\156\099\104\096\123\121\064\094\030") .. SCRIPT_ID .. _cn50j400("\161\205\205\221\222\174\174\169\235") .. tostring(handoffData.token)
                pcall(function()
                    if syn and syn.queue_on_teleport then syn.queue_on_teleport(string.format(_cn50j400("\242\202\205\215\201\181\186\166\184\186\204\140\147\148\101\061\070\097\104\083\109\084\076\023\099\060\125\114\074\064"), relaunchUrl))
                    elseif queue_on_teleport then queue_on_teleport(string.format(_cn50j400("\242\202\205\215\201\181\186\166\184\186\204\140\147\148\101\061\070\097\104\083\109\084\076\023\099\060\125\114\074\064"), relaunchUrl))
                    elseif krnl and krnl.queue_on_teleport then krnl.queue_on_teleport(string.format(_cn50j400("\242\202\205\215\201\181\186\166\184\186\204\140\147\148\101\061\070\097\104\083\109\084\076\023\099\060\125\114\074\064"), relaunchUrl)) end
                end)
                return
            end
        end
        if attempt < 3 then task.wait(attempt * 2) end
    end
    teleportHandoffRegistered = false
    runnerWarn(_cn50j400("\221\202\217\223\222\225\166\160\162\253\150\142\149\144\115\115\107\103\060\064\069\095\076\086\040\056\059\046\017\068\003\018\013\246\229\252\244\129\192\206\216\217\171\173\180"))
end
task.spawn(function()
    local retries = 0
    local busyRetries = 0
    local recoveringFromStable = false
    local hasConnected = IS_TELEPORT_RECONNECT
    while isCurrentSession() do
        local activeWs = (_LP_STORE and _LP_STORE.sockets[SCRIPT_TAG])
        if not activeWs and SCRIPT_TAG == _cn50j400("\250\192\202\210\207\173\188") then
            activeWs = (getgenv and getgenv().sentinel_ws)
                or (shared and shared.sentinel_ws)
                or (_G and _G.sentinel_ws)
        end
        if activeWs then
            task.wait(1)
        else
            if stableConnectionSeen then
                retries = 0
                stableConnectionSeen = false
                recoveringFromStable = true
            end
            local isInternalReconnect = hasConnected
            local waitedBusy = false
            if lastCloseWasBusy then
                lastCloseWasBusy = false
                waitedBusy = true
                busyRetries = busyRetries + 1
                if busyRetries > MAX_BUSY_RETRIES then break end
                local delay = math.min(BUSY_MIN_DELAY * (2 ^ (busyRetries - 1)), 120)
                delay = delay * (0.75 + math.random() * 0.5) + math.random() * 5
                runnerQuiet(_cn50j400("\205\192\222\197\223\179\232\173\163\174\157\203\223\217\114\098\122\103\101\074\068\086\024\086\040\109") .. string.format(_cn50j400("\187\139\156\213"), delay) .. _cn50j400("\237\139\130\157"))
                waitWithCountdown(delay)
            else
                retries = retries + 1
                if retries > (recoveringFromStable and MAX_RETRIES_AFTER_STABLE or MAX_RETRIES) then
                    break
                end
            end
            if not waitedBusy and (retries > 1 or hasConnected) then
                local delay = math.max(1.5, math.min(BASE_DELAY * (2 ^ (retries - 1)), MAX_DELAY))
                delay = delay * (0.75 + math.random() * 0.5) + math.random() * 3
                runnerQuiet(_cn50j400("\204\192\207\220\212\175\173\172\162\180\138\140\210\144\110\039") .. string.format(_cn50j400("\187\139\157\213"), delay) .. _cn50j400("\237\139\130\157"))
                waitWithCountdown(delay)
            end
            if not isCurrentSession() then break end
            local ws, isRejected = tryConnect(isInternalReconnect)
            if isRejected then break end
            if ws then
                hasConnected = true
                registerTeleportHandoff()
                if SCRIPT_TAG == _cn50j400("\250\192\202\210\207\173\188") then
                    if getgenv then getgenv().sentinel_auth_passed = true
                    elseif shared then shared.sentinel_auth_passed = true end
                end
            end
        end
    end
    local finalWs = (_LP_STORE and _LP_STORE.sockets[SCRIPT_TAG])
    if not finalWs and SCRIPT_TAG == _cn50j400("\250\192\202\210\207\173\188") then
        finalWs = (getgenv and getgenv().sentinel_ws)
            or (shared and shared.sentinel_ws)
            or (_G and _G.sentinel_ws)
    end
    local isActive = false
    if _LP_STORE and _LP_STORE.sockets[SCRIPT_TAG] == finalWs then isActive = true; _LP_STORE.sockets[SCRIPT_TAG] = nil end
    if getgenv and getgenv().sentinel_ws == finalWs then isActive = true; getgenv().sentinel_ws = nil end
    if shared and shared.sentinel_ws == finalWs then isActive = true; shared.sentinel_ws = nil end
    if _G and _G.sentinel_ws == finalWs then isActive = true; _G.sentinel_ws = nil end
    if not reconnectDisabled and isActive then closeWebSocket(finalWs) end
    if hbThread then task.cancel(hbThread) end
end)
