-- Deobfuscated version of LuaProtect loader (SCRIPT_NAME = Bypass)
-- Original obfuscation: XOR with (158 + (i-1)*7) % 256
-- All _cn50j400(...) calls have been replaced with plaintext strings.

-- [Obfuscation layer removed — all strings decrypted]
local HttpService  = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local Players      = game:GetService("Players")
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
local IS_TELEPORT_RECONNECT = "0" == "1"
local HANDOFF_RUNNER_ID = ""
local HANDOFF_KEY = ""
local HANDOFF_RUN_ID = ""
local HANDOFF_SESSION_ID = ""
local SECRET_KEY  = "a035da2d6f91cc32f23b374ddc82c23d1e3b972edd2a48cd5b945eb3ccf0f18f"
local RUNNER_ID   = "fc1e08d9417e2e9ae70303a66e4976fd"
local label = (SCRIPT_NAME ~= "" and SCRIPT_NAME) or "Luaprotect"
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
                parentGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
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
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
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
cleanupExistingGui("LuaProtectKeyUI")
cleanupExistingGui("LuaProtectDiscordLink")
cleanupExistingGui("LuaProtectAnnouncementGui")
cleanupExistingGui("LuaProtectConsoleNotifications")
local announcementSerial = 0
local function showAdminAnnouncement(title, message, duration, colorHex, prefix, verified)
    duration = tonumber(duration) or 8
    announcementSerial = announcementSerial + 1
    local serial = announcementSerial
    task.spawn(function()
        local parentGui = getGuiParent()
        if not parentGui then return end
        cleanupExistingGui("LuaProtectAnnouncementGui")
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "LuaProtectAnnouncementGui"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 50
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) elseif protect_gui then protect_gui(screenGui) end end)
        screenGui.Parent = parentGui
        card = Instance.new("Frame")
        card.Name = "AnnouncementCard"
        card.AnchorPoint = Vector2.new(0.5, 0)
        card.Position = UDim2.new(0.5, 0, 0, -100)
        card.Size = UDim2.new(1, 0, 0, 44)
        card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        card.BackgroundTransparency = 0
        card.BorderSizePixel = 0
        card.Parent = screenGui
        local gradient = Instance.new("UIGradient")
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.25, 0.4),
            NumberSequenceKeypoint.new(0.75, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        })
        gradient.Parent = card
        local contentContainer = Instance.new("Frame")
        contentContainer.BackgroundTransparency = 1
        contentContainer.Size = UDim2.new(1, 0, 1, 0)
        contentContainer.Parent = card
        local listLayout = Instance.new("UIListLayout")
        listLayout.FillDirection = Enum.FillDirection.Horizontal
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 0)
        listLayout.Parent = contentContainer
        local nameColor = Color3.fromRGB(240, 65, 65)
        if type(colorHex) == "string" and #colorHex >= 6 then
            local cleanHex = colorHex:gsub("#", "")
            local r = tonumber(cleanHex:sub(1, 2), 16)
            local g = tonumber(cleanHex:sub(3, 4), 16)
            local b = tonumber(cleanHex:sub(5, 6), 16)
            if r and g and b then
                nameColor = Color3.fromRGB(r, g, b)
            end
        end
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(0, 0, 1, 0)
        nameLabel.AutomaticSize = Enum.AutomaticSize.X
        nameLabel.Font = Enum.Font.RobotoMono
        nameLabel.TextSize = 20
        nameLabel.TextColor3 = nameColor
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.Text = tostring(prefix or "Luaprotect")
        nameLabel.LayoutOrder = 1
        nameLabel.Parent = contentContainer
        local nameStroke = Instance.new("UIStroke")
        nameStroke.Color = Color3.fromRGB(0, 0, 0)
        nameStroke.Thickness = 1
        nameStroke.Parent = nameLabel
        if verified then
            local preBadgeSpacer = Instance.new("Frame")
            preBadgeSpacer.Name = "PreBadgeSpacer"
            preBadgeSpacer.BackgroundTransparency = 1
            preBadgeSpacer.Size = UDim2.new(0, 5, 1, 0)
            preBadgeSpacer.LayoutOrder = 2
            preBadgeSpacer.Parent = contentContainer
            local badge = Instance.new("ImageLabel")
            badge.Name = "VerifiedBadge"
            badge.BackgroundTransparency = 1
            badge.Size = UDim2.new(0, 20, 0, 20)
            badge.Image = "rbxassetid://15859770184"
            badge.LayoutOrder = 3
            badge.Parent = contentContainer
            local badgeSpacer = Instance.new("Frame")
            badgeSpacer.Name = "BadgeSpacer"
            badgeSpacer.BackgroundTransparency = 1
            badgeSpacer.Size = UDim2.new(0, 5, 1, 0)
            badgeSpacer.LayoutOrder = 4
            badgeSpacer.Parent = contentContainer
        end
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Name = "MessageLabel"
        msgLabel.BackgroundTransparency = 1
        msgLabel.Size = UDim2.new(0, 0, 1, 0)
        msgLabel.AutomaticSize = Enum.AutomaticSize.X
        msgLabel.Font = Enum.Font.RobotoMono
        msgLabel.TextSize = 20
        msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextYAlignment = Enum.TextYAlignment.Center
        msgLabel.Text = ": " .. tostring(message or "")
        msgLabel.LayoutOrder = 5
        msgLabel.Parent = contentContainer
        local msgStroke = Instance.new("UIStroke")
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
    hex = tostring(hex or ""):gsub("#", "")
    if #hex ~= 6 or not hex:match("^%x+$") then return fallback end
    return Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
end
local THEME_BG = themeColor("", Color3.fromRGB(20, 20, 20))
local PROMPT_FOR_KEY = "0" == "1"
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
    if level == "error" then
        return {
            title = (label ~= "" and label ~= "Luaprotect" and label) or "LuaProtect Error",
            accent = Color3.fromRGB(239, 68, 68),
            icon = "rbxassetid://10747384394",
            duration = 8
        }
    elseif level == "warning" then
        return {
            title = (label ~= "" and label ~= "Luaprotect" and label) or "Warning",
            accent = Color3.fromRGB(245, 158, 11),
            icon = "rbxassetid://10709753149",
            duration = 8
        }
    elseif level == "success" then
        return {
            title = (label ~= "" and label ~= "Luaprotect" and label) or "LuaProtect",
            accent = Color3.fromRGB(16, 185, 129),
            icon = "rbxassetid://10709790644",
            duration = 6
        }
    end
    return {
        title = (label ~= "" and label ~= "Luaprotect" and label) or "LuaProtect",
        accent = THEME_ACCENT or Color3.fromRGB(59, 130, 246),
        icon = "rbxassetid://10709752996",
        duration = 6
    }
end
local function trimConsoleOutput(value)
    local text = tostring(value or ""):gsub("\r", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if #text > CONSOLE_TOAST_MAX_TEXT then
        text = text:sub(1, CONSOLE_TOAST_MAX_TEXT - 3) .. "..."
    end
    return text
end
local function isConsoleError(value)
    local text = string.lower(tostring(value or ""))
    local errorMarkers = {
        "error", "failed", "failure", "could not", "cannot", "invalid key",
        "banned", "refused", "rate limited", "superseded",
    }
    for _, marker in ipairs(errorMarkers) do
        if text:find(marker, 1, true) then return true end
    end
    return false
end
local function isConsoleSuccess(value)
    local text = string.lower(tostring(value or ""))
    local successMarkers = {
        "connected", "authenticated", "success", "securely", "authorized", "loaded"
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
        if text == "" then return end
        local now = tick()
        local outputKey = tostring(level) .. ":" .. text
        if recentConsoleOutput[outputKey] and now - recentConsoleOutput[outputKey] < 1.5 then return end
        recentConsoleOutput[outputKey] = now
        for key, timestamp in pairs(recentConsoleOutput) do
            if now - timestamp > 8 then recentConsoleOutput[key] = nil end
        end
        local parentGui = getGuiParent()
        if not parentGui then return end
        local screenGui = parentGui:FindFirstChild("LuaProtectConsoleNotifications")
        if not screenGui then
            screenGui = Instance.new("ScreenGui")
            screenGui.Name = "LuaProtectConsoleNotifications"
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            screenGui.DisplayOrder = 25
            screenGui.Parent = parentGui
        end
        local stack = screenGui:FindFirstChild("NotificationStack")
        if not stack then
            stack = Instance.new("Frame")
            stack.Name = "NotificationStack"
            stack.AnchorPoint = Vector2.new(1, 1)
            stack.Position = UDim2.new(1, -16, 1, -16)
            stack.Size = UDim2.new(0, CONSOLE_TOAST_WIDTH, 0, 0)
            stack.AutomaticSize = Enum.AutomaticSize.Y
            stack.Active = false
            stack.BackgroundTransparency = 1
            stack.BorderSizePixel = 0
            stack.Parent = screenGui
            local sizeConstraint = Instance.new("UISizeConstraint")
            sizeConstraint.MaxSize = Vector2.new(CONSOLE_TOAST_WIDTH, 720)
            sizeConstraint.MinSize = Vector2.new(0, 0)
            sizeConstraint.Parent = stack
            local layout = Instance.new("UIListLayout")
            layout.Name = "StackLayout"
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
        local card = Instance.new("Frame")
        card.Name = "ConsoleToast"
        card.LayoutOrder = consoleToastSerial
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = THEME_BG
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = stack
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 3)
        corner.Parent = card
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(45, 45, 45)
        stroke.Transparency = 1
        stroke.Thickness = 1
        stroke.Parent = card
        local cardPadding = Instance.new("UIPadding")
        cardPadding.PaddingTop = UDim.new(0, 12)
        cardPadding.PaddingBottom = UDim.new(0, 12)
        cardPadding.PaddingLeft = UDim.new(0, 14)
        cardPadding.PaddingRight = UDim.new(0, 12)
        cardPadding.Parent = card
        local row = Instance.new("Frame")
        row.Name = "Row"
        row.Size = UDim2.new(1, 0, 0, 0)
        row.AutomaticSize = Enum.AutomaticSize.Y
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.Parent = card
        local rowLayout = Instance.new("UIListLayout")
        rowLayout.FillDirection = Enum.FillDirection.Horizontal
        rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        rowLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rowLayout.Padding = UDim.new(0, 10)
        rowLayout.Parent = row
        local iconFrame = Instance.new("Frame")
        iconFrame.Name = "IconFrame"
        iconFrame.Size = UDim2.new(0, 24, 0, 24)
        iconFrame.BackgroundColor3 = style.accent
        iconFrame.BackgroundTransparency = 1
        iconFrame.BorderSizePixel = 0
        iconFrame.LayoutOrder = 1
        iconFrame.Parent = row
        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 3)
        iconCorner.Parent = iconFrame
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 16, 0, 16)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.BackgroundTransparency = 1
        iconImg.BorderSizePixel = 0
        iconImg.Image = style.icon
        iconImg.ImageColor3 = style.accent
        iconImg.ImageTransparency = 1
        iconImg.Parent = iconFrame
        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, -34, 0, 0)
        content.AutomaticSize = Enum.AutomaticSize.Y
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.LayoutOrder = 2
        content.Parent = row
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.FillDirection = Enum.FillDirection.Vertical
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 2)
        contentLayout.Parent = content
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
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
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Name = "Message"
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
    local text = tostring(message or "")
    warn("[" .. label .. "] " .. text)
    local level = isConsoleError(text) and "error" or "warning"
    showConsoleNotification(level, text)
end
local linkPanel = nil
local DISCORD_BLURPLE = THEME_ACCENT or Color3.fromRGB(88, 101, 242)
local function formatLinkCode(code)
    code = tostring(code or "")
    if #code == 6 then return code:sub(1, 3) .. " " .. code:sub(4, 6) end
    return code
end
local function hideDiscordLinkPanel(linked)
    local panel = linkPanel
    if not panel then return end
    linkPanel = nil
    panel.closed = true
    pcall(function()
        if linked then
            panel.title.Text = "Discord linked"
            panel.message.Text = "Starting the script..."
            panel.codeLabel.Text = "Done"
            panel.codeLabel.TextColor3 = Color3.fromRGB(16, 185, 129)
            panel.timer.Text = ""
            task.wait(1.2)
        end
        local fade = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(panel.card, fade, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 16) }):Play()
        for _, obj in ipairs(panel.card:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                TweenService:Create(obj, fade, { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
            elseif obj:IsA("ImageLabel") then
                TweenService:Create(obj, fade, { ImageTransparency = 1, BackgroundTransparency = 1 }):Play()
            elseif obj:IsA("UIStroke") then
                TweenService:Create(obj, fade, { Transparency = 1 }):Play()
            elseif obj:IsA("Frame") and obj.BackgroundTransparency < 1 then
                TweenService:Create(obj, fade, { BackgroundTransparency = 1 }):Play()
            end
        end
        task.wait(0.3)
        if panel.gui then panel.gui:Destroy() end
    end)
end
local function showDiscordLinkPanel(info, sendEvent)
    local enterMode = info and info.mode == "discord"
    local function requestNewCode() sendEvent({ event = "link_code_refresh" }) end
    local code = tostring(info and info.code or "")
    local expiresAt = os.clock() + (tonumber(info and info.expiresIn) or 300)
    local servers = {}
    if info and type(info.servers) == "table" then
        for _, name in ipairs(info.servers) do table.insert(servers, tostring(name)) end
    end
    if #servers == 0 and info and info.server then table.insert(servers, tostring(info.server)) end
    local whereText
    if #servers == 1 then
        whereText = "Use /link with this code in the " .. servers[1] .. " Discord server."
    elseif #servers > 1 then
        local last = table.remove(servers)
        whereText = "Use /link with this code in any of these Discord servers: " .. table.concat(servers, ", ") .. " or " .. last .. "."
    else
        whereText = "Use /link with this code in the script's Discord server."
    end
    if enterMode then
        whereText = whereText:gsub("^Use /link with this code in", "Run /link in"):gsub("%.$", "") .. ", then enter the code it gives you here."
    end
    if linkPanel and linkPanel.card and linkPanel.card.Parent then
        if linkPanel.enterMode then
            linkPanel.message.Text = whereText
            return
        end
        linkPanel.code = code
        linkPanel.expiresAt = expiresAt
        linkPanel.refreshing = false
        linkPanel.message.Text = whereText
        linkPanel.codeLabel.Text = formatLinkCode(code)
        return
    end
    pcall(function()
        local parentGui = getGuiParent()
        if not parentGui then return end
        cleanupExistingGui("LuaProtectDiscordLink")
        local gui = Instance.new("ScreenGui")
        gui.Name = "LuaProtectDiscordLink"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 30
        gui.Parent = parentGui
        local backdrop = Instance.new("Frame")
        backdrop.Name = "Backdrop"
        backdrop.Size = UDim2.new(1, 0, 1, 0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency = 1
        backdrop.BorderSizePixel = 0
        backdrop.Active = true
        backdrop.Parent = gui
        local card = Instance.new("Frame")
        card.Name = "LinkCard"
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.new(0.5, 0, 0.5, 16)
        card.Size = UDim2.new(0, 440, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = THEME_BG
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.Parent = gui
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 3)
        local cardSize = Instance.new("UISizeConstraint")
        cardSize.MaxSize = Vector2.new(440, 600)
        cardSize.Parent = card
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(45, 45, 45)
        stroke.Transparency = 1
        stroke.Parent = card
        local pad = Instance.new("UIPadding")
        pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 22), UDim.new(0, 22)
        pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 22), UDim.new(0, 22)
        pad.Parent = card
        local list = Instance.new("UIListLayout")
        list.FillDirection = Enum.FillDirection.Vertical
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 14)
        list.Parent = card
        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 36)
        header.BackgroundTransparency = 1
        header.LayoutOrder = 1
        header.Parent = card
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, 36, 0, 36)
        iconFrame.BackgroundColor3 = DISCORD_BLURPLE
        iconFrame.BackgroundTransparency = 0.86
        iconFrame.BorderSizePixel = 0
        iconFrame.Parent = header
        Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 3)
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 22, 0, 22)
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://10709752996"
        icon.ImageColor3 = DISCORD_BLURPLE
        icon.Parent = iconFrame
        local title = Instance.new("TextLabel")
        title.Position = UDim2.new(0, 48, 0, 0)
        title.Size = UDim2.new(1, -48, 1, 0)
        title.BackgroundTransparency = 1
        title.Font = fontBold
        title.TextSize = 20
        title.TextColor3 = THEME_TEXT
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Text = "Link your Discord to play"
        title.Parent = header
        local message = Instance.new("TextLabel")
        message.Size = UDim2.new(1, 0, 0, 0)
        message.AutomaticSize = Enum.AutomaticSize.Y
        message.BackgroundTransparency = 1
        message.Font = fontRegular
        message.TextSize = 15
        message.TextColor3 = THEME_MUTED
        message.TextWrapped = true
        message.TextXAlignment = Enum.TextXAlignment.Left
        message.Text = whereText
        message.LayoutOrder = 2
        message.Parent = card
        local codeBox = Instance.new("Frame")
        codeBox.Size = UDim2.new(1, 0, 0, 64)
        codeBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        codeBox.BackgroundTransparency = 0.96
        codeBox.BorderSizePixel = 0
        codeBox.LayoutOrder = 3
        codeBox.Parent = card
        Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 3)
        local codeLabel = Instance.new(enterMode and "TextBox" or "TextLabel")
        if enterMode then
            codeLabel.PlaceholderText = "000 000"
            codeLabel.PlaceholderColor3 = THEME_MUTED
            codeLabel.ClearTextOnFocus = false
        end
        codeLabel.Position = UDim2.new(0, 16, 0, 0)
        codeLabel.Size = UDim2.new(1, -110, 1, 0)
        codeLabel.BackgroundTransparency = 1
        codeLabel.Font = Enum.Font.RobotoMono
        codeLabel.TextSize = 34
        codeLabel.TextColor3 = THEME_TEXT
        codeLabel.TextXAlignment = Enum.TextXAlignment.Left
        codeLabel.Text = enterMode and "" or formatLinkCode(code)
        codeLabel.Parent = codeBox
        local copyBtn = Instance.new("TextButton")
        copyBtn.AnchorPoint = Vector2.new(1, 0.5)
        copyBtn.Position = UDim2.new(1, -12, 0.5, 0)
        copyBtn.Size = UDim2.new(0, 80, 0, 38)
        copyBtn.BackgroundColor3 = DISCORD_BLURPLE
        copyBtn.AutoButtonColor = true
        copyBtn.Font = fontBold
        copyBtn.TextSize = 15
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Text = enterMode and "Link" or "Copy"
        copyBtn.Parent = codeBox
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 3)
        local timer = Instance.new("TextLabel")
        timer.Size = UDim2.new(1, 0, 0, 18)
        timer.BackgroundTransparency = 1
        timer.Font = fontRegular
        timer.TextSize = 13
        timer.TextColor3 = THEME_MUTED
        timer.TextXAlignment = Enum.TextXAlignment.Left
        timer.Text = ""
        timer.LayoutOrder = 5
        timer.Parent = card
        local invite = info and info.invite and tostring(info.invite) or nil
        if invite and invite ~= "" then
            local inviteRow = Instance.new("Frame")
            inviteRow.Size = UDim2.new(1, 0, 0, 40)
            inviteRow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            inviteRow.BackgroundTransparency = 0.97
            inviteRow.BorderSizePixel = 0
            inviteRow.LayoutOrder = 4
            inviteRow.Parent = card
            Instance.new("UICorner", inviteRow).CornerRadius = UDim.new(0, 3)
            local inviteLabel = Instance.new("TextLabel")
            inviteLabel.Position = UDim2.new(0, 14, 0, 0)
            inviteLabel.Size = UDim2.new(1, -110, 1, 0)
            inviteLabel.BackgroundTransparency = 1
            inviteLabel.Font = fontRegular
            inviteLabel.TextSize = 14
            inviteLabel.TextColor3 = THEME_MUTED
            inviteLabel.TextXAlignment = Enum.TextXAlignment.Left
            inviteLabel.TextTruncate = Enum.TextTruncate.AtEnd
            inviteLabel.Text = "Not in the server? " .. invite:gsub("^https?://", "")
            inviteLabel.Parent = inviteRow
            local inviteBtn = Instance.new("TextButton")
            inviteBtn.AnchorPoint = Vector2.new(1, 0.5)
            inviteBtn.Position = UDim2.new(1, -8, 0.5, 0)
            inviteBtn.Size = UDim2.new(0, 84, 0, 28)
            inviteBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            inviteBtn.BackgroundTransparency = 0.9
            inviteBtn.AutoButtonColor = true
            inviteBtn.Font = fontBold
            inviteBtn.TextSize = 13
            inviteBtn.TextColor3 = THEME_TEXT
            inviteBtn.Text = "Copy invite"
            inviteBtn.Parent = inviteRow
            Instance.new("UICorner", inviteBtn).CornerRadius = UDim.new(0, 3)
            inviteBtn.MouseButton1Click:Connect(function()
                local copied = false
                pcall(function()
                    local clip = setclipboard or toclipboard or (syn and syn.write_clipboard)
                    if clip then clip(invite); copied = true end
                end)
                inviteBtn.Text = copied and "Copied" or "Open it"
                task.delay(1.5, function() if inviteBtn.Parent then inviteBtn.Text = "Copy invite" end end)
            end)
        end
        linkPanel = {
            gui = gui, card = card, title = title, message = message,
            codeLabel = codeLabel, timer = timer, code = code,
            expiresAt = expiresAt, refreshing = false, closed = false,
            enterMode = enterMode, submitBtn = copyBtn,
        }
        local panel = linkPanel
        if enterMode then
            local function submit()
                local entered = tostring(codeLabel.Text or ""):gsub("%s+", "")
                if not entered:match("^%d%d%d%d%d%d$") then
                    timer.Text = "Enter the 6-digit code from /link."
                    return
                end
                copyBtn.Text = "..."
                timer.Text = "Checking the code..."
                sendEvent({ event = "link_code_submit", code = entered })
            end
            copyBtn.MouseButton1Click:Connect(submit)
            codeLabel.FocusLost:Connect(function(enterPressed) if enterPressed then submit() end end)
        end
        if not enterMode then copyBtn.MouseButton1Click:Connect(function()
            local copied = false
            pcall(function()
                local clip = setclipboard or toclipboard or (syn and syn.write_clipboard)
                if clip then clip(tostring(panel.code)); copied = true end
            end)
            copyBtn.Text = copied and "Copied" or "Type it"
            task.delay(1.5, function() if copyBtn.Parent then copyBtn.Text = "Copy" end end)
        end) end
        local fadeIn = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(card, fadeIn, { BackgroundTransparency = 0.03, Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
        TweenService:Create(backdrop, fadeIn, { BackgroundTransparency = 0.45 }):Play()
        TweenService:Create(stroke, fadeIn, { Transparency = 0 }):Play()
        if not enterMode then task.spawn(function()
            while not panel.closed and card.Parent do
                local left = math.max(0, math.floor(panel.expiresAt - os.clock()))
                if left > 0 then
                    timer.Text = string.format("Code expires in %d:%02d", math.floor(left / 60), left % 60)
                elseif not panel.refreshing then
                    panel.refreshing = true
                    timer.Text = "Code expired - getting a new one..."
                    pcall(requestNewCode)
                end
                task.wait(1)
            end
        end) end
    end)
end
local function showDiscordLinkError(message)
    local panel = linkPanel
    if not panel or not panel.enterMode then return end
    pcall(function()
        panel.timer.Text = tostring(message or "That code didn't work.")
        if panel.submitBtn then panel.submitBtn.Text = "Link" end
    end)
end
local function runnerPrint(message)
    local text = tostring(message or "")
    print("[" .. label .. "] " .. text)
    local level = isConsoleSuccess(text) and "success" or "info"
    showConsoleNotification(level, text)
end
local function runnerQuiet()
end
local sha256 = {}
do
    local band, rshift, lshift, bxor, bnot = bit32.band, bit32.rshift, bit32.lshift, bit32.bxor, bit32.bnot
    local add = function(...)
        local sum = 0
        for _, v in ipairs({...}) do sum = (sum + v) % 4294967296 end
        return sum
    end
    local rrotate = function(x, n)
        return bxor(rshift(x, n), lshift(x, 32 - n))
    end
    local h_init = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    }
    local k = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }
    local function str_to_bytes(str)
        local bytes = {}
        for i = 1, #str do table.insert(bytes, string.byte(str, i)) end
        return bytes
    end
    local function bytes_to_hex(bytes)
        local hex = {}
        for _, b in ipairs(bytes) do table.insert(hex, string.format("%02x", b)) end
        return table.concat(hex)
    end
    local function block_hash(block, h)
        local w = {}
        for i = 1, 16 do
            w[i] = add(lshift(block[4*i - 3], 24), lshift(block[4*i - 2], 16), lshift(block[4*i - 1], 8), block[4*i])
        end
        for i = 17, 64 do
            local s0 = bxor(bxor(rrotate(w[i-15], 7), rrotate(w[i-15], 18)), rshift(w[i-15], 3))
            local s1 = bxor(bxor(rrotate(w[i-2], 17), rrotate(w[i-2], 19)), rshift(w[i-2], 10))
            w[i] = add(w[i-16], s0, w[i-7], s1)
        end
        local a, b, c, d, e, f, g, h_val = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
        for i = 1, 64 do
            local S1 = bxor(bxor(rrotate(e, 6), rrotate(e, 11)), rrotate(e, 25))
            local ch = bxor(band(e, f), band(bnot(e), g))
            local temp1 = add(h_val, S1, ch, k[i], w[i])
            local S0 = bxor(bxor(rrotate(a, 2), rrotate(a, 13)), rrotate(a, 22))
            local maj = bxor(bxor(band(a, b), band(a, c)), band(b, c))
            local temp2 = add(S0, maj)
            h_val = g; g = f; f = e; e = add(d, temp1); d = c; c = b; b = a; a = add(temp1, temp2)
        end
        h[1] = add(h[1], a); h[2] = add(h[2], b); h[3] = add(h[3], c); h[4] = add(h[4], d)
        h[5] = add(h[5], e); h[6] = add(h[6], f); h[7] = add(h[7], g); h[8] = add(h[8], h_val)
    end
    function sha256.digest(str)
        local h = { unpack(h_init) }
        local bytes = str_to_bytes(str)
        local bit_len = #bytes * 8
        table.insert(bytes, 0x80)
        while (#bytes % 64) ~= 56 do table.insert(bytes, 0) end
        for i = 7, 0, -1 do table.insert(bytes, band(rshift(bit_len, i * 8), 0xFF)) end
        for chunk = 1, #bytes / 64 do
            local block = {}
            for i = 1, 64 do table.insert(block, bytes[(chunk-1)*64 + i]) end
            block_hash(block, h)
        end
        local result = {}
        for _, val in ipairs(h) do
            for i = 3, 0, -1 do table.insert(result, band(rshift(val, i * 8), 0xFF)) end
        end
        return result
    end
    function sha256.hmac(key, message)
        local key_bytes = str_to_bytes(key)
        if #key_bytes > 64 then key_bytes = sha256.digest(key) end
        while #key_bytes < 64 do table.insert(key_bytes, 0) end
        local ipad, opad = {}, {}
        for i = 1, 64 do ipad[i] = bxor(key_bytes[i], 0x36); opad[i] = bxor(key_bytes[i], 0x5C) end
        local inner_payload = {}
        for _, b in ipairs(ipad) do table.insert(inner_payload, string.char(b)) end
        for _, b in ipairs(str_to_bytes(message)) do table.insert(inner_payload, string.char(b)) end
        local inner_hash = sha256.digest(table.concat(inner_payload))
        local outer_payload = {}
        for _, b in ipairs(opad) do table.insert(outer_payload, string.char(b)) end
        for _, b in ipairs(inner_hash) do table.insert(outer_payload, string.char(b)) end
        return bytes_to_hex(sha256.digest(table.concat(outer_payload)))
    end
end
local HEX_NIBBLE = {}
for i = 0, 9 do HEX_NIBBLE[48 + i] = i end
for i = 0, 5 do HEX_NIBBLE[97 + i] = 10 + i; HEX_NIBBLE[65 + i] = 10 + i end
local DECRYPT_BATCH = 4096          
local DECRYPT_YIELD_EVERY = 262144  
local function decryptXOR(hexText, seedKey)
    local secret = seedKey .. SECRET_KEY
    local n = #secret
    local keyBytes = { string.byte(secret, 1, n) }
    local stream = {}
    for r = 0, n - 1 do
        stream[r] = keyBytes[((r + keyBytes[r + 1]) % n) + 1]
    end
    local bxor, char, sbyte, concat = bit32.bxor, string.char, string.byte, table.concat
    local total = #hexText
    local canYield = total > DECRYPT_YIELD_EVERY and task and task.wait
    local out = {}
    local r = 0
    local sinceYield = 0
    local i = 1
    while i <= total do
        local j = i + DECRYPT_BATCH - 1
        if j > total then j = total end
        local bytes = { sbyte(hexText, i, j) }
        local batch = {}
        local bn = 0
        for k = 1, #bytes - 1, 2 do
            local hi, lo = HEX_NIBBLE[bytes[k]], HEX_NIBBLE[bytes[k + 1]]
            if hi and lo then
                bn = bn + 1
                batch[bn] = bxor(hi * 16 + lo, stream[r])
                r = r + 1
                if r == n then r = 0 end
            end
        end
        local parts = {}
        for s = 1, bn, 1024 do
            local e = s + 1023
            if e > bn then e = bn end
            parts[#parts + 1] = char(unpack(batch, s, e))
        end
        out[#out + 1] = concat(parts)
        i = j + 1
        sinceYield = sinceYield + DECRYPT_BATCH
        if canYield and sinceYield >= DECRYPT_YIELD_EVERY then
            sinceYield = 0
            task.wait()
        end
    end
    return concat(out)
end
local hwid = "Fallback-HWID-" .. tostring(userId)
pcall(function()
    if gethwid then hwid = gethwid()
    elseif syn and syn.gethwid then hwid = syn.gethwid() end
end)
local executor = "Unknown"
pcall(function()
    local function getVal(fnName)
        if getgenv then
            local ok, val = pcall(function() return getgenv()[fnName] end)
            if ok and val ~= nil then return val end
        end
        if _G then
            local ok, val = pcall(function() return _G[fnName] end)
            if ok and val ~= nil then return val end
        end
        if shared then
            local ok, val = pcall(function() return shared[fnName] end)
            if ok and val ~= nil then return val end
        end
        local ok, val = pcall(function() return getfenv()[fnName] end)
        if ok and val ~= nil then return val end
        return nil
    end
    local idFn = getVal("identifyexecutor")
        or getVal("getexecutorname")
        or getVal("getexecutor")
        or (syn and syn.identifyexecutor)
        or (delta and delta.identifyexecutor)
        or (fluxus and fluxus.identifyexecutor)
    if type(idFn) == "function" then
        local ok, res1, res2 = pcall(idFn)
        if ok and res1 then
            if type(res1) == "string" and res1 ~= "" then
                local ver = (type(res2) == "string" and res2 ~= "") and (" " .. res2) or ""
                executor = res1 .. ver
            elseif type(res1) == "table" then
                executor = tostring(res1.name or res1.Name or res1[1] or "Unknown")
            end
        end
    end
    if executor == "Unknown" then
        local infoFn = getVal("getexecutorinfo")
        if type(infoFn) == "function" then
            local ok, info = pcall(infoFn)
            if ok and info then
                if type(info) == "table" then
                    executor = tostring(info.name or info.Name or info[1] or "Unknown")
                elseif type(info) == "string" and info ~= "" then
                    executor = info
                end
            end
        end
    end
    if executor == "Unknown" then
        if getVal("POTASSIUM_LOADED") or getVal("potassium") then executor = "Potassium"
        elseif getVal("SOLARA_LOADED") or getVal("solara") then executor = "Solara"
        elseif getVal("WAVE_LOADED") or getVal("wave") then executor = "Wave"
        elseif getVal("DELTA_LOADED") or getVal("delta") then executor = "Delta"
        elseif getVal("CODEX_LOADED") or getVal("codex") then executor = "Codex"
        elseif getVal("MACSPLOIT_LOADED") or getVal("macsploit") then executor = "MacSploit"
        elseif getVal("VELOCITY_LOADED") or getVal("velocity") then executor = "Velocity"
        elseif getVal("VOLT_LOADED") or getVal("volt") then executor = "Volt"
        elseif getVal("XENO_LOADED") or getVal("xeno") then executor = "Xeno"
        elseif getVal("SWIFT_LOADED") or getVal("swift") then executor = "Swift"
        elseif getVal("KRNL_LOADED") or getVal("krnl") then executor = "KRNL"
        elseif getVal("HYDROGEN_LOADED") or getVal("hydrogen") then executor = "Hydrogen"
        elseif getVal("FLUXUS_LOADED") or getVal("fluxus") then executor = "Fluxus"
        elseif getVal("ARCEUS_LOADED") or getVal("arceus") then executor = "Arceus"
        elseif getVal("CELERY_LOADED") or getVal("celery") then executor = "Celery"
        elseif getVal("APPLEWARE_LOADED") or getVal("appleware") then executor = "Appleware"
        elseif getVal("CUBIX_LOADED") or getVal("cubix") then executor = "Cubix"
        elseif getVal("NEZUR_LOADED") or getVal("nezur") then executor = "Nezur"
        elseif getVal("REAL_LOADED") or getVal("real") then executor = "Real"
        elseif getVal("MADIUM_LOADED") or getVal("madium") then executor = "Madium"
        elseif getVal("COSMIC_LOADED") or getVal("cosmic") then executor = "Cosmic"
        elseif syn then executor = "Synapse" end
    end
end)
local isLowSyncExecutor = false
pcall(function()
    local execLower = string.lower(tostring(executor or ""))
    isLowSyncExecutor = execLower:find("xeno", 1, true) ~= nil
        or execLower:find("solara", 1, true) ~= nil
        or execLower:find("delta", 1, true) ~= nil
        or execLower:find("potassium", 1, true) ~= nil
end)
local isEnvironmentTampered = false
pcall(function()
    if type(math) ~= "table" or type(math.floor) ~= "function" then isEnvironmentTampered = true end
    if type(string) ~= "table" or type(string.byte) ~= "function" or type(string.char) ~= "function" then isEnvironmentTampered = true end
    if type(table) ~= "table" or type(table.concat) ~= "function" or type(table.insert) ~= "function" then isEnvironmentTampered = true end
    if type(bit32) ~= "table" or type(bit32.bxor) ~= "function" then isEnvironmentTampered = true end
end)
if isEnvironmentTampered then
    SECRET_KEY = string.reverse(tostring(SECRET_KEY)) .. "_TAMPERED"
end
local SCRIPT_TAG = (SCRIPT_ID ~= "" and SCRIPT_ID ~= "3ygzzC25i2tZ4K9Z") and tostring(SCRIPT_ID) or "default"
local _LP_STORE = nil
pcall(function()
    local g = (getgenv and getgenv()) or shared or _G
    if g then
        if type(g._luaprotect_store) ~= "table" then
            g._luaprotect_store = {
                sockets = {},
                sessions = {},
                invocations = {},
                executed = {},
                keys = {},
                rids = {},
                run_ids = {}
            }
        end
        _LP_STORE = g._luaprotect_store
        if getgenv then getgenv()._luaprotect_store = _LP_STORE end
        if shared then shared._luaprotect_store = _LP_STORE end
        if _G then _G._luaprotect_store = _LP_STORE end
    end
end)
local _PARENT_WS = (_LP_STORE and _LP_STORE.sockets[SCRIPT_TAG]) or (SCRIPT_TAG == "default" and ((getgenv and getgenv().sentinel_ws) or (shared and shared.sentinel_ws) or (_G and _G.sentinel_ws)) or nil)
local _PARENT_KEY = (_LP_STORE and _LP_STORE.keys[SCRIPT_TAG]) or (SCRIPT_TAG == "default" and ((getgenv and getgenv()._luaprotect_key) or (shared and shared._luaprotect_key) or (_G and _G._luaprotect_key)) or nil)
local _PERSISTED_RUNNER_ID = (_LP_STORE and _LP_STORE.rids[SCRIPT_TAG]) or (SCRIPT_TAG == "default" and ((getgenv and getgenv()._luaprotect_rid) or (shared and shared._luaprotect_rid) or (_G and _G._luaprotect_rid)) or nil)
local _PERSISTED_RUN_ID = (_LP_STORE and _LP_STORE.run_ids[SCRIPT_TAG]) or (SCRIPT_TAG == "default" and ((getgenv and getgenv()._luaprotect_run_id) or (shared and shared._luaprotect_run_id) or (_G and _G._luaprotect_run_id)) or nil)
if IS_TELEPORT_RECONNECT then
    if HANDOFF_RUNNER_ID ~= "" then _PERSISTED_RUNNER_ID = HANDOFF_RUNNER_ID end
    if HANDOFF_KEY ~= "" then _PARENT_KEY = HANDOFF_KEY end
    if HANDOFF_RUN_ID ~= "" then _PERSISTED_RUN_ID = HANDOFF_RUN_ID end
end
local IS_NESTED_IMPORT = "0" == "1"
local IS_FRESH_FALLBACK = false
local MY_LAST_CONNECT_ATTEMPT = 0
local INVOCATION_MARKER = table.concat({
    tostring(os.time()),
    tostring(math.floor(os.clock() * 1000000)),
    tostring(math.random(100000, 999999)),
    tostring({})
}, ":")
local INVOCATION_OWNER = (getgenv and getgenv().sentinel_invocation)
    or (shared and shared.sentinel_invocation)
    or (_G and _G.sentinel_invocation)
if _LP_STORE and _LP_STORE.invocations[SCRIPT_TAG] then
    INVOCATION_OWNER = _LP_STORE.invocations[SCRIPT_TAG]
elseif SCRIPT_TAG ~= "default" then
    INVOCATION_OWNER = nil
end
if not IS_NESTED_IMPORT and not IS_TELEPORT_RECONNECT then
    if _LP_STORE then _LP_STORE.invocations[SCRIPT_TAG] = INVOCATION_MARKER end
    if SCRIPT_TAG == "default" then
        if getgenv then getgenv().sentinel_invocation = INVOCATION_MARKER end
        if shared then shared.sentinel_invocation = INVOCATION_MARKER end
        if _G then _G.sentinel_invocation = INVOCATION_MARKER end
    end
    INVOCATION_OWNER = INVOCATION_MARKER
    if _LP_STORE then _LP_STORE.executed[SCRIPT_TAG] = {} end
    if SCRIPT_TAG == "default" then
        if getgenv then getgenv()._luaprotect_executed = {} end
        if shared then shared._luaprotect_executed = {} end
        if _G then _G._luaprotect_executed = {} end
    end
end
local canUseParentImport = false
if IS_NESTED_IMPORT and not canUseParentImport then
    IS_FRESH_FALLBACK = true
end
if canUseParentImport then
    local parentImportSucceeded = false
    local requestFunc = (syn and syn.request) or request or http_request or (http and http.request)
    local childRunnerId, childKey = nil, nil
    local importCheck = nil
    local importRequestId = nil
    do
        local keyUrl = HOST_URL .. "/api/runner-key?scriptId=" .. SCRIPT_ID
        local keyBody = nil
        local IMPORT_KEY_MAX_RETRIES = 3
        for _attempt = 1, IMPORT_KEY_MAX_RETRIES do
            keyBody = nil
            importCheck = nil
            local requestTransportFailed = false
            if requestFunc then
                local ok, res = pcall(requestFunc, { Url = keyUrl, Method = "GET" })
                if ok and res then
                    importCheck = tostring(res.StatusCode or res.status or "unknown")
                    importRequestId = res.Headers and (res.Headers["X-LuaProtect-Request-Id"] or res.Headers["x-luaprotect-request-id"])
                    local statusCode = tonumber(res.StatusCode or res.status)
                    if statusCode == 200 then
                        keyBody = res.Body
                    elseif statusCode == 429 then
                        local retryAfter = 5
                        pcall(function()
                            local h = res.Headers or res.headers or {}
                            local ra = h["Retry-After"] or h["retry-after"]
                            if ra then retryAfter = tonumber(ra) or 5 end
                        end)
                        waitWithCountdown(retryAfter)
                    end
                else
                    importCheck = "request-error"
                    requestTransportFailed = true
                end
            else
                requestTransportFailed = true
            end
            if not keyBody and requestTransportFailed and statusCode ~= 429 then
                local ok, response = pcall(function() return game:HttpGet(keyUrl) end)
                if ok then keyBody = response else importCheck = importCheck or "httpget-error" end
            end
            if keyBody then break end
        end
        if keyBody then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, keyBody)
            if ok and data and data.runnerId and data.key then
                childRunnerId = tostring(data.runnerId)
                childKey = tostring(data.key)
            end
        end
    end
    if childKey and childRunnerId then
        local url = HOST_URL .. "/api/script-content/" .. SCRIPT_ID
        local timestamp = tostring(os.time())
        pcall(function()
            local serverTime = workspace:GetServerTimeNow()
            if serverTime and serverTime > 0 then timestamp = tostring(math.floor(serverTime)) end
        end)
        local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local nonce = {}
        local rng = Random.new()
        for _ = 1, 16 do
            local idx = rng:NextInteger(1, #chars)
            table.insert(nonce, chars:sub(idx, idx))
        end
        nonce = table.concat(nonce)
        local sigPayload = tostring(userId) .. "." .. tostring(hwid) .. "." .. timestamp .. "." .. nonce .. ".0"
        local signature = sha256.hmac(childKey, sigPayload)
        local body = nil
        local bodyFromSigned = false
        if requestFunc then
            local ok, res = pcall(requestFunc, { Url = url, Method = "GET", Headers = {
                ["X-Signature"] = signature, ["X-Timestamp"] = timestamp, ["X-Nonce"] = nonce,
                ["X-User-Id"] = tostring(userId), ["X-Hwid"] = tostring(hwid), ["X-Runner-Id"] = childRunnerId
            }})
            if ok and res and res.StatusCode == 200 then body = res.Body; bodyFromSigned = true end
        end
        if not body and not bodyFromSigned then
            importCheck = importCheck or "signed-request-failed"
        end
        if body then
            local refused = false
            if not bodyFromSigned then
                if body:sub(1, 1) == "{" then
                    pcall(function()
                        local data = HttpService:JSONDecode(body)
                        if data and (data.error or data.message) then
                            runnerWarn("Import error: " .. tostring(data.error or data.message))
                        end
                    end)
                    refused = true
                elseif body:sub(1, 2) == "--" then
                    runnerWarn("Import refused: " .. body:sub(1, 120))
                    refused = true
                end
            end
            if not refused then
                body = body:gsub("\239\187\191", "")
                body = body:gsub("\226\128[\139-\143]", "")
                local fn, err = loadstring(body)
                if fn then
                    parentImportSucceeded = true
                    local execOk, execErr = pcall(fn)
                    if not execOk then
                        runnerWarn("Import execution error: " .. tostring(execErr))
                    end
                else
                    runnerWarn("Import loadstring error: " .. tostring(err))
                end
            end
        else
            local suffix = importCheck and (" (API check " .. tostring(importCheck) .. (importRequestId and (", request " .. tostring(importRequestId)) or "") .. ")") or ""
            runnerQuiet("Failed to import script " .. SCRIPT_ID .. suffix)
        end
    else
        runnerQuiet("Could not mint import key for " .. SCRIPT_ID .. " - falling back to WebSocket delivery")
    end
    if parentImportSucceeded then return end
    IS_FRESH_FALLBACK = true
end
if IS_FRESH_FALLBACK and not IS_TELEPORT_RECONNECT then
    if _LP_STORE then _LP_STORE.invocations[SCRIPT_TAG] = INVOCATION_MARKER end
    if SCRIPT_TAG == "default" then
        if getgenv then getgenv().sentinel_invocation = INVOCATION_MARKER end
        if shared then shared.sentinel_invocation = INVOCATION_MARKER end
        if _G then _G.sentinel_invocation = INVOCATION_MARKER end
    end
    INVOCATION_OWNER = INVOCATION_MARKER
end
local function fetchRunnerKey()
    if SECRET_KEY and SECRET_KEY ~= "" and SECRET_KEY ~= "a035da2d6f91cc32f23b374ddc82c23d1e3b972edd2a48cd5b945eb3ccf0f18f"
       and RUNNER_ID and RUNNER_ID ~= "" and RUNNER_ID ~= "fc1e08d9417e2e9ae70303a66e4976fd" then
        if _LP_STORE then
            _LP_STORE.keys[SCRIPT_TAG] = SECRET_KEY
            _LP_STORE.rids[SCRIPT_TAG] = RUNNER_ID
        end
        if SCRIPT_TAG == "default" then
            if getgenv then
                getgenv()._luaprotect_key = SECRET_KEY
                getgenv()._luaprotect_rid = RUNNER_ID
            end
            if shared then
                shared._luaprotect_key = SECRET_KEY
                shared._luaprotect_rid = RUNNER_ID
            end
            if _G then
                _G._luaprotect_key = SECRET_KEY
                _G._luaprotect_rid = RUNNER_ID
            end
        end
        return true
    end
    if IS_TELEPORT_RECONNECT then
        if not _PERSISTED_RUNNER_ID or not _PERSISTED_RUN_ID or not _PARENT_KEY then
            runnerWarn("Cannot restore continuous session identity; please re-execute the script")
            return false
        end
        RUNNER_ID = tostring(_PERSISTED_RUNNER_ID)
        SECRET_KEY = tostring(_PARENT_KEY)
        return true
    end
    local url = HOST_URL .. "/api/runner-key"
    if SCRIPT_ID ~= "" then url = url .. "?scriptId=" .. SCRIPT_ID end
    local body = nil
    local keyCheck = nil
    local KEY_FETCH_MAX_RETRIES = 3
    for _attempt = 1, KEY_FETCH_MAX_RETRIES do
        body = nil
        keyCheck = nil
        local requestTransportFailed = false
        local requestFunc = (syn and syn.request) or request or http_request or (http and http.request)
        if requestFunc then
            local ok, res = pcall(requestFunc, { Url = url, Method = "GET" })
            if ok and res then
                keyCheck = tostring(res.StatusCode or res.status or "unknown")
                local statusCode = tonumber(res.StatusCode or res.status)
                if statusCode == 200 then
                    body = res.Body
                elseif statusCode == 429 then
                    local retryAfter = 5
                    pcall(function()
                        local h = res.Headers or res.headers or {}
                        local ra = h["Retry-After"] or h["retry-after"]
                        if ra then retryAfter = tonumber(ra) or 5 end
                    end)
                    runnerWarn("Runner key fetch rate-limited (429) - retrying in " .. retryAfter .. "s")
                    waitWithCountdown(retryAfter)
                end
            else
                keyCheck = "request-error"
                requestTransportFailed = true
            end
        else
            requestTransportFailed = true
        end
        if not body and requestTransportFailed and statusCode ~= 429 then
            local ok, response = pcall(function() return game:HttpGet(url) end)
            if ok then body = response else keyCheck = keyCheck or "httpget-error" end
        end
        if body then break end
    end
    if body then
        local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
        if ok and data and data.runnerId and data.key then
            RUNNER_ID = data.runnerId
            SECRET_KEY = data.key
            if _LP_STORE then
                _LP_STORE.keys[SCRIPT_TAG] = data.key
                _LP_STORE.rids[SCRIPT_TAG] = data.runnerId
            end
            if SCRIPT_TAG == "default" then
                if getgenv then
                    getgenv()._luaprotect_key = data.key
                    getgenv()._luaprotect_rid = data.runnerId
                end
                if shared then
                    shared._luaprotect_key = data.key
                    shared._luaprotect_rid = data.runnerId
                end
                if _G then
                    _G._luaprotect_key = data.key
                    _G._luaprotect_rid = data.runnerId
                end
            end
            return true
        end
    end
    runnerWarn("Failed to fetch runner key (API check " .. tostring(keyCheck or "unknown") .. ")")
    return false
end
pcall(function()
    local existing = (_LP_STORE and _LP_STORE.sockets[SCRIPT_TAG])
    if not existing and SCRIPT_TAG == "default" then
        existing = (getgenv and getgenv().sentinel_ws)
            or (shared and shared.sentinel_ws)
            or (_G and _G.sentinel_ws)
    end
    if existing and existing.Close then 
        pcall(function() existing:Close() end)
        task.wait(0.15)
    end
    if _LP_STORE then _LP_STORE.sockets[SCRIPT_TAG] = nil end
    if SCRIPT_TAG == "default" then
        if getgenv and getgenv().sentinel_ws == existing then getgenv().sentinel_ws = nil end
        if shared and shared.sentinel_ws == existing then shared.sentinel_ws = nil end
        if _G and _G.sentinel_ws == existing then _G.sentinel_ws = nil end
    end
end)
if SCRIPT_TAG == "default" then
    if getgenv then getgenv().sentinel_reconnect = false end
end
local function makeRequest(url, data, isReconnectFlag)
    local jsonStr = HttpService:JSONEncode(data)
    local timestamp = tostring(os.time())
    pcall(function()
        local serverTime = workspace:GetServerTimeNow()
        if serverTime and serverTime > 0 then timestamp = tostring(math.floor(serverTime)) end
    end)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local nonce = {}
    local rng = Random.new()
    for _ = 1, 16 do
        local idx = rng:NextInteger(1, #chars)
        table.insert(nonce, chars:sub(idx, idx))
    end
    nonce = table.concat(nonce)
    local reconnectBit = (isReconnectFlag and "1" or "0")
    local sigPayload = tostring(userId) .. "." .. tostring(hwid) .. "." .. timestamp .. "." .. nonce .. "." .. reconnectBit .. "." .. tostring(data.sessionId or "") .. "." .. tostring(data.runId or "")
    local signature = sha256.hmac(SECRET_KEY, sigPayload)
    local headers = {
        ["Content-Type"] = "application/json", ["User-Agent"] = "Roblox/WinInet",
        ["X-Signature"] = signature, ["X-Timestamp"] = timestamp, ["X-Nonce"] = nonce,
        ["Roblox-Place-Id"] = tostring(placeId), ["Roblox-Game-Id"] = tostring(jobId)
    }
    local requestFunc = (syn and syn.request) or request or http_request or (http and http.request)
    if requestFunc then
        local ok, res = pcall(requestFunc, { Url = url, Method = "POST", Headers = headers, Body = jsonStr })
        if ok and res then
            if res.StatusCode == 200 then return true, res.Body
            elseif res.StatusCode == 429 then
                local retryAfter = 5
                pcall(function()
                    local h = res.Headers or res.headers or {}
                    local ra = h["Retry-After"] or h["retry-after"]
                    if ra then retryAfter = tonumber(ra) or 5 end
                end)
                return false, "RATE_LIMITED", retryAfter
            elseif res.StatusCode == 409 then
                return false, "SUPERSEDED"
            elseif res.StatusCode == 423 then
                local retryAfter = 5
                local restrictCode = "WRONG_GAME"
                local restrictMsg = "This script is locked to a different game."
                pcall(function()
                    local h = res.Headers or res.headers or {}
                    local ra = h["Retry-After"] or h["retry-after"]
                    if ra then retryAfter = tonumber(ra) or 5 end
                    local data = HttpService:JSONDecode(res.Body)
                    if data then
                        if data.error then restrictCode = tostring(data.error) end
                        if data.message then restrictMsg = tostring(data.message) end
                    end
                end)
                return false, restrictCode, retryAfter, restrictMsg
            elseif res.StatusCode == 403 then return false, "BANNED:" .. tostring(res.Body)
            elseif res.StatusCode >= 500 or res.StatusCode == 408 then
                local retryAfter = 5
                pcall(function()
                    local h = res.Headers or res.headers or {}
                    local ra = h["Retry-After"] or h["retry-after"]
                    if ra then retryAfter = tonumber(ra) or 5 end
                end)
                return false, "SERVER_ERROR HTTP " .. tostring(res.StatusCode) .. ": " .. tostring(res.Body), retryAfter
            else return false, "HTTP " .. tostring(res.StatusCode) .. ": " .. tostring(res.Body) end
        end
        return false, "NETWORK_ERROR " .. tostring(res)
    end
    local ok, res = pcall(function()
        return HttpService:PostAsync(url, jsonStr, Enum.HttpContentType.ApplicationJson)
    end)
    if not ok then
        local errorText = tostring(res)
        if errorText:find("SUPERSEDED", 1, true) or errorText:find("409", 1, true) then
            return false, "SUPERSEDED"
        end
        return false, "NETWORK_ERROR " .. errorText
    end
    return ok, res
end
local function openWebSocket(wsUrl)
    if WebSocket and WebSocket.connect then local ok, ws = pcall(WebSocket.connect, wsUrl); if ok then return ws end end
    if WebSocket and WebSocket.new then local ok, ws = pcall(WebSocket.new, wsUrl); if ok then return ws end end
    if websocket and websocket.connect then local ok, ws = pcall(websocket.connect, wsUrl); if ok then return ws end end
    if syn and syn.websocket and syn.websocket.connect then local ok, ws = pcall(syn.websocket.connect, wsUrl); if ok then return ws end end
    return nil
end
local MAX_RETRIES = 1
local MAX_RETRIES_AFTER_STABLE = 7
local BASE_DELAY  = 2
local MAX_DELAY   = 60
local STABLE_CONNECTION_THRESHOLD_SECONDS = 10
local connectionOpenedAt   = nil
local stableConnectionSeen = false
local MAX_BUSY_RETRIES     = 6
local BUSY_MIN_DELAY       = 10
local lastCloseWasBusy     = false
local reconnectDisabled    = false
local hbThread = nil
local function closeWebSocket(ws)
    if not ws then return end
    pcall(function()
        if ws.Close then ws:Close()
        elseif ws.close then ws:close()
        elseif ws.Disconnect then ws:Disconnect()
        elseif ws.disconnect then ws:disconnect() end
    end)
end
local maxSession = 0
if _LP_STORE and type(_LP_STORE.sessions[SCRIPT_TAG]) == "number" then
    maxSession = _LP_STORE.sessions[SCRIPT_TAG]
elseif SCRIPT_TAG == "default" then
    if getgenv and type(getgenv().sentinel_session) == "number" then maxSession = math.max(maxSession, getgenv().sentinel_session) end
    if shared and type(shared.sentinel_session) == "number" then maxSession = math.max(maxSession, shared.sentinel_session) end
    if _G and type(_G.sentinel_session) == "number" then maxSession = math.max(maxSession, _G.sentinel_session) end
end
local CURRENT_SESSION = (IS_TELEPORT_RECONNECT and tonumber(HANDOFF_SESSION_ID)) or (IS_TELEPORT_RECONNECT and maxSession) or (maxSession + 1)
local RUN_ID = (IS_TELEPORT_RECONNECT and _PERSISTED_RUN_ID) or (tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999)) .. "-" .. tostring(CURRENT_SESSION))
if _LP_STORE then _LP_STORE.sessions[SCRIPT_TAG] = CURRENT_SESSION end
if SCRIPT_TAG == "default" then
    if getgenv then getgenv().sentinel_session = CURRENT_SESSION end
    if shared then shared.sentinel_session = CURRENT_SESSION end
    if _G then _G.sentinel_session = CURRENT_SESSION end
end
local function isCurrentSession()
    if reconnectDisabled then return false end
    if not IS_TELEPORT_RECONNECT and INVOCATION_OWNER then
        if _LP_STORE and _LP_STORE.invocations[SCRIPT_TAG] then
            if _LP_STORE.invocations[SCRIPT_TAG] ~= INVOCATION_OWNER then return false end
        elseif SCRIPT_TAG == "default" then
            if getgenv and getgenv().sentinel_invocation and getgenv().sentinel_invocation ~= INVOCATION_OWNER then return false end
            if shared and shared.sentinel_invocation and shared.sentinel_invocation ~= INVOCATION_OWNER then return false end
            if _G and _G.sentinel_invocation and _G.sentinel_invocation ~= INVOCATION_OWNER then return false end
        end
    end
    if _LP_STORE and type(_LP_STORE.sessions[SCRIPT_TAG]) == "number" then
        if _LP_STORE.sessions[SCRIPT_TAG] > CURRENT_SESSION then return false end
    elseif SCRIPT_TAG == "default" then
        if getgenv and type(getgenv().sentinel_session) == "number" and getgenv().sentinel_session > CURRENT_SESSION then return false end
        if shared and type(shared.sentinel_session) == "number" and shared.sentinel_session > CURRENT_SESSION then return false end
        if _G and type(_G.sentinel_session) == "number" and _G.sentinel_session > CURRENT_SESSION then return false end
    end
    return true
end
local function waitWithCountdown(totalSeconds)
    if totalSeconds <= 0 then return end
    for remaining = totalSeconds - 1, 0, -1 do
        if not isCurrentSession() then return end
        task.wait(1)
    end
end
if _LP_STORE and _LP_STORE.sockets[SCRIPT_TAG] then
    pcall(function() _LP_STORE.sockets[SCRIPT_TAG]:Close() end)
    _LP_STORE.sockets[SCRIPT_TAG] = nil
elseif SCRIPT_TAG == "default" then
    if getgenv and getgenv().sentinel_ws then
        pcall(function() getgenv().sentinel_ws:Close() end)
        getgenv().sentinel_ws = nil
    end
    if shared and shared.sentinel_ws then
        pcall(function() shared.sentinel_ws:Close() end)
        shared.sentinel_ws = nil
    end
    if _G and _G.sentinel_ws then
        pcall(function() _G.sentinel_ws:Close() end)
        _G.sentinel_ws = nil
    end
end
local function getProvidedKey()
    local k = nil
    pcall(function()
        if getgenv and (getgenv().script_key or getgenv().key) then k = getgenv().script_key or getgenv().key
        elseif _G and (_G.script_key or _G.key) then k = _G.script_key or _G.key
        elseif shared and (shared.script_key or shared.key) then k = shared.script_key or shared.key
        elseif getfenv then
            for level = 0, 5 do
                pcall(function()
                    local env = getfenv(level)
                    if env and (env.script_key or env.key) then k = env.script_key or env.key end
                end)
                if k then break end
            end
        end
    end)
    return k and tostring(k):gsub("^%s*(.-)%s*$", "%1") or ""
end
local isKeyPromptClosed = false
local function showKeyPromptPanel(submitCallback)
    local parentGui = getGuiParent()
    if not parentGui then return end
    cleanupExistingGui("LuaProtectKeyUI")
    local gui = Instance.new("ScreenGui")
    gui.Name = "LuaProtectKeyUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 35
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) elseif protect_gui then protect_gui(gui) end end)
    local parented = pcall(function() gui.Parent = parentGui end)
    if not parented or not gui.Parent then
        pcall(function()
            gui.Parent = (LocalPlayer and (LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5))) or CoreGui
        end)
    end
    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.Active = true
    backdrop.Parent = gui
    local card = Instance.new("Frame")
    card.Name = "KeyCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 16)
    card.Size = UDim2.new(0, 440, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = THEME_BG
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Parent = gui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 3)
    local cardSize = Instance.new("UISizeConstraint")
    cardSize.MaxSize = Vector2.new(440, 600)
    cardSize.Parent = card
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 45)
    stroke.Transparency = 1
    stroke.Parent = card
    local pad = Instance.new("UIPadding")
    pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 22), UDim.new(0, 22)
    pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 22), UDim.new(0, 22)
    pad.Parent = card
    local list = Instance.new("UIListLayout")
    list.FillDirection = Enum.FillDirection.Vertical
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 14)
    list.Parent = card
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = card
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 36, 0, 36)
    iconFrame.BackgroundColor3 = THEME_ACCENT or Color3.fromRGB(168, 85, 247)
    iconFrame.BackgroundTransparency = 0.86
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = header
    Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 3)
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://10709752996"
    icon.ImageColor3 = THEME_ACCENT or Color3.fromRGB(168, 85, 247)
    icon.Parent = iconFrame
    local title = Instance.new("TextLabel")
    title.Position = UDim2.new(0, 48, 0, 0)
    title.Size = UDim2.new(1, -84, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = fontBold
    title.TextSize = 20
    title.TextColor3 = THEME_TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = (SCRIPT_NAME ~= "" and SCRIPT_NAME) or "Authentication Required"
    title.Parent = header
    local closeBtn = Instance.new("TextButton")
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.Position = UDim2.new(1, 0, 0.5, 0)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = fontBold
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = THEME_MUTED
    closeBtn.Text = "\21"
    closeBtn.Parent = header
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, 0, 0, 0)
    message.AutomaticSize = Enum.AutomaticSize.Y
    message.BackgroundTransparency = 1
    message.Font = fontRegular
    message.TextSize = 15
    message.TextColor3 = THEME_MUTED
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.Text = "Please enter your access key to continue."
    message.LayoutOrder = 2
    message.Parent = card
    local codeBox = Instance.new("Frame")
    codeBox.Size = UDim2.new(1, 0, 0, 52)
    codeBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    codeBox.BackgroundTransparency = 0.96
    codeBox.BorderSizePixel = 0
    codeBox.LayoutOrder = 3
    codeBox.Parent = card
    Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 3)
    local inputBox = Instance.new("TextBox")
    inputBox.Position = UDim2.new(0, 16, 0, 0)
    inputBox.Size = UDim2.new(1, -114, 1, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.Font = fontRegular
    inputBox.TextSize = 15
    inputBox.TextColor3 = THEME_TEXT
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.PlaceholderText = "Paste your key here..."
    inputBox.PlaceholderColor3 = THEME_MUTED
    inputBox.Text = ""
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = codeBox
    local submitBtn = Instance.new("TextButton")
    submitBtn.AnchorPoint = Vector2.new(1, 0.5)
    submitBtn.Position = UDim2.new(1, -8, 0.5, 0)
    submitBtn.Size = UDim2.new(0, 84, 0, 36)
    submitBtn.BackgroundColor3 = THEME_ACCENT or Color3.fromRGB(168, 85, 247)
    submitBtn.AutoButtonColor = true
    submitBtn.Font = fontBold
    submitBtn.TextSize = 15
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Text = "Continue"
    submitBtn.Parent = codeBox
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 3)
    local timer = Instance.new("TextLabel")
    timer.Size = UDim2.new(1, 0, 0, 18)
    timer.BackgroundTransparency = 1
    timer.Font = fontRegular
    timer.TextSize = 13
    timer.TextColor3 = THEME_MUTED
    timer.TextXAlignment = Enum.TextXAlignment.Left
    timer.Text = ""
    timer.LayoutOrder = 4
    timer.Parent = card
    local function closeOut()
        isKeyPromptClosed = true
        pcall(function()
            local fade = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            TweenService:Create(card, fade, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 16) }):Play()
            TweenService:Create(backdrop, fade, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(stroke, fade, { Transparency = 1 }):Play()
            for _, obj in ipairs(card:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    TweenService:Create(obj, fade, { TextTransparency = 1 }):Play()
                elseif obj:IsA("ImageLabel") then
                    TweenService:Create(obj, fade, { ImageTransparency = 1 }):Play()
                end
            end
            task.wait(0.25)
            gui:Destroy()
        end)
    end
    closeBtn.MouseButton1Click:Connect(function()
        submitCallback("")
        closeOut()
    end)
    local function doSubmit()
        local text = inputBox.Text:gsub("^%s*(.-)%s*$", "%1")
        if text ~= "" then
            submitBtn.Text = "..."
            timer.Text = "Checking key..."
            submitCallback(text)
            closeOut()
        end
    end
    submitBtn.MouseButton1Click:Connect(doSubmit)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            doSubmit()
        end
    end)
    local fadeIn = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(card, fadeIn, { BackgroundTransparency = 0.03, Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
    TweenService:Create(backdrop, fadeIn, { BackgroundTransparency = 0.45 }):Play()
    TweenService:Create(stroke, fadeIn, { Transparency = 0 }):Play()
end
local function tryConnect
(isInternalReconnect)
    if not isCurrentSession() then
        return nil, true, "SUPERSEDED"
    end
    local currentKeyCode = getProvidedKey()
    local success, response, retryAfter, rejectMsg = makeRequest(HOST_URL .. "/api/auth/token", {
        userId = userId, username = username, placeId = placeId, jobId = jobId, gameId = gameId,
        hwid = hwid, scriptId = SCRIPT_ID, scriptName = SCRIPT_NAME, executor = executor,
        keyCode = currentKeyCode, runnerId = RUNNER_ID, isReconnect = isInternalReconnect or false, sessionId = CURRENT_SESSION, runId = RUN_ID,
        caps = { chunks = true }
    }, isInternalReconnect)
    if not success then
        if response == "RATE_LIMITED" then
            local waitTime = retryAfter or 15
            runnerWarn("Rate limited - waiting " .. waitTime .. "s before retry")
            waitWithCountdown(waitTime)
            return nil, false
        elseif response == "WRONG_GAME" or response == "GAME_RESTRICTED" then
            runnerWarn(rejectMsg or "Wrong game - this script is locked to a different game")
            return nil, true, nil
        elseif response == "EXECUTOR_RESTRICTED" then
            runnerWarn(rejectMsg or "Your executor is not approved for this script. Your account is NOT suspended - the script owner only allows specific executors.")
            return nil, true, nil
        elseif response and response:find("SUPERSEDED", 1, true) then
            reconnectDisabled = true
            print("[" .. label .. "] Superseded by a newer executor run; stopping reconnects.")
            return nil, true, "SUPERSEDED"
        elseif response and (response:find("KEY_REQUIRED") or response:find("Key Required")) then
            local providedKey = getProvidedKey()
            if providedKey == "" and PROMPT_FOR_KEY then
                local enteredKey
                local done = false
                showKeyPromptPanel(function(k)
                    enteredKey = k
                    done = true
                end)
                while not done do task.wait(0.1) end
                if enteredKey and enteredKey ~= "" then
                    if getgenv then getgenv().script_key = enteredKey end
                    if _G then _G.script_key = enteredKey end
                    local ok, fatal, reason = tryConnect(isInternalReconnect)
                    if not ok then
                        if getgenv and getgenv().script_key == enteredKey then getgenv().script_key = nil end
                        if _G and _G.script_key == enteredKey then _G.script_key = nil end
                    end
                    return ok, fatal, reason
                end
            end
            local msg
            if providedKey == "" then
                msg = "No key set. Use: script_key = \"YOUR_KEY\" then re-execute."
            else
                local serverMsg = ""
                pcall(function()
                    local data = HttpService:JSONDecode(response)
                    if data and (data.message or data.error) then serverMsg = data.message or data.error end
                end)
                msg = "Invalid key: \"" .. providedKey .. "\". " .. (serverMsg ~= "" and serverMsg or "Key not recognised.")
            end
            runnerWarn(msg)
            return nil, true, nil
        elseif response and type(response) == "string" and response:sub(1, 7) == "BANNED:" then
            local reason = "You are banned."
            pcall(function()
                local body = response:sub(8)
                local data = HttpService:JSONDecode(body)
                if data then reason = tostring(data.message or data.reason or data.error or "You are banned.") end
            end)
            runnerWarn(reason)
            return nil, true, reason
        elseif response:find("SERVER_ERROR", 1, true) then
            local serverDetail = response:gsub("^SERVER_ERROR ", "")
            runnerQuiet("Server unavailable (" .. serverDetail .. "); will retry")
            return nil, false, "TRANSIENT"
        elseif response:find("NETWORK_ERROR", 1, true) then
            local netDetail = response:gsub("^NETWORK_ERROR ", "")
            runnerQuiet("Network error reaching server (" .. netDetail .. "); will retry")
            return nil, false, "TRANSIENT"
        else
            runnerWarn("Auth failed: " .. tostring(response))
            return nil, true
        end
    end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, response)
    if not ok or not data or not data.token then
        runnerWarn("Bad auth response: " .. tostring(response))
        return nil, false
    end
    MY_LAST_CONNECT_ATTEMPT = os.clock()
    if getgenv then getgenv()._luaprotect_last_connect_attempt = MY_LAST_CONNECT_ATTEMPT end
    local ws = openWebSocket(WS_URL .. "?token=" .. data.token)
    if not ws then
        runnerWarn("Could not open WebSocket")
        return nil, false
    end
    if _LP_STORE then _LP_STORE.sockets[SCRIPT_TAG] = ws end
    if SCRIPT_TAG == "default" then
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
                local reportStr = HttpService:JSONEncode({ type = "script_report", level = "error", message = msgKey, stackTrace = tostring(stackTrace or "") })
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
            if sig and (typeof(sig) == "RBXScriptSignal" or sig.Connect) then
                local conn = sig:Connect(handler)
                if conn then table.insert(wsConnections, conn) end
            end
        end)
        pcall(function()
            if not ws[signalName] and not ws[altName] then ws[signalName] = handler; ws[altName] = handler end
        end)
    end
    local function executeScriptPayload(decryptedOrErr)
        if decryptedOrErr:sub(1, 3) == "\239\187\191" then
            decryptedOrErr = decryptedOrErr:sub(4)
        end
        decryptedOrErr = decryptedOrErr:gsub("%-%-%[=%[ [^%]]*%]=%]", function(comment)
            return (comment:gsub("\239\187\191", ""):gsub("\226\128[\139-\143]", ""))
        end)
        local isKickPayload = decryptedOrErr:sub(1, 21) == "-- [LuaProtect Kick]\n"
        if isKickPayload then
            if not isCurrentSession() then return end
            local kickFn, kickErr = loadstring(decryptedOrErr)
            if not kickFn then
                runnerWarn("Kick payload error: " .. tostring(kickErr))
                return
            end
            pcall(kickFn)
            return
        end
        if not isCurrentSession() then return end
        local executedStore = (_LP_STORE and _LP_STORE.executed[SCRIPT_TAG])
        if not executedStore and SCRIPT_TAG == "default" then
            executedStore = (getgenv and getgenv()._luaprotect_executed) or (shared and shared._luaprotect_executed)
        end
        if not executedStore then
            executedStore = {}
            if _LP_STORE then _LP_STORE.executed[SCRIPT_TAG] = executedStore end
            if SCRIPT_TAG == "default" then
                if getgenv then getgenv()._luaprotect_executed = executedStore else shared._luaprotect_executed = executedStore end
            end
        end
        if not isCurrentSession() then return end
        local dedupKey = tostring(#decryptedOrErr) .. ":" .. decryptedOrErr:sub(1, 256) .. decryptedOrErr:sub(-256)
        if executedStore[dedupKey] then
            runnerWarn("Script already executed in this session; skipping duplicate execution")
            return
        end
        local storeCount = 0
        for _ in pairs(executedStore) do storeCount = storeCount + 1 end
        if storeCount > 16 then
            for key in pairs(executedStore) do executedStore[key] = nil end
        end
        executedStore[dedupKey] = true
        local isBlockedNotice = decryptedOrErr:sub(1, 23) == "-- [LuaProtect Blocked]"
        local fn, err = loadstring(decryptedOrErr, "=" .. tostring(SCRIPT_NAME ~= "" and SCRIPT_NAME or "LuaProtect"))
        if not fn then
            runnerWarn("Loadstring error: " .. tostring(err))
            sendErrorReport("Loadstring compilation error: " .. tostring(err), debug and debug.traceback and debug.traceback() or "")
            return
        end
        if not isBlockedNotice then
        end
        local execOk, execErr = pcall(fn)
        if not isBlockedNotice then
            if not execOk then
                runnerWarn("Execution error: " .. tostring(execErr))
                sendErrorReport(tostring(execErr), debug and debug.traceback and debug.traceback() or "")
            else
            end
        end
    end
    local function handleIncomingMessage(hexPayload)
        task.spawn(function()
            local decOk, decryptedOrErr = pcall(decryptXOR, hexPayload, data.token)
            if not decOk then return end
            if decryptedOrErr:sub(1, 1) == "{" then
                local parseOk, parsed = pcall(HttpService.JSONDecode, HttpService, decryptedOrErr)
                if parseOk and type(parsed) == "table" and parsed.lp_event == "discord_link_required" then
                    showDiscordLinkPanel(parsed, function(event)
                        local req = HttpService:JSONEncode(event)
                        if ws.Send then ws:Send(req) elseif ws.send then ws:send(req) end
                    end)
                    return
                end
                if parseOk and type(parsed) == "table" and parsed.lp_event == "discord_link_error" then
                    showDiscordLinkError(parsed.message)
                    return
                end
                if parseOk and type(parsed) == "table" and parsed.lp_event == "discord_linked" then
                    task.spawn(hideDiscordLinkPanel, true)
                    return
                end
                if parseOk and type(parsed) == "table" and parsed.lp_event == "admin_announcement" then
                    showAdminAnnouncement(parsed.title, parsed.message, parsed.duration, parsed.color, parsed.prefix, parsed.verified)
                    return
                end
                if parseOk and type(parsed) == "table" and parsed.lp_event == "integrity_challenge" then
                    task.spawn(function()
                        local nonce = tostring(parsed.nonce or "")
                        local seed = tostring(parsed.seed or "")
                        local tampered = false
                        local reason = ""
                        pcall(function()
                            if not isLowSyncExecutor then
                                if getrawmetatable and islclosure and islclosure(getrawmetatable) then tampered = true; reason = "getrawmetatable detour" end
                                if hookmetamethod and islclosure and islclosure(hookmetamethod) then tampered = true; reason = "hookmetamethod detour" end
                            end
                            if type(loadstring) ~= "function" or type(pcall) ~= "function" then
                                tampered = true; reason = "core globals corrupted"
                            end
                            if not isLowSyncExecutor and getrawmetatable and type(game) == "userdata" then
                                local metaOk, meta = pcall(getrawmetatable, game)
                                if metaOk and type(meta) == "table" then
                                    local nc = rawget(meta, "__namecall")
                                    if nc and islclosure and islclosure(nc) then
                                        tampered = true; reason = "game __namecall hooked"
                                    end
                                end
                            end
                            if getgenv then
                                local genv = getgenv()
                                if genv.dump or genv.Hydroxide or genv.SimpleSpy then
                                    tampered = true; reason = "active script dumper / spy tool detected"
                                end
                            end
                        end)
                        local canonicalPayload = nonce .. "." .. seed .. "." .. tostring(RUN_ID or "") .. "." .. tostring(CURRENT_SESSION or "") .. "." .. (tampered and "1" or "0")
                        local challengeSig = sha256.hmac(SECRET_KEY, canonicalPayload)
                        local respPayload = HttpService:JSONEncode({
                            event = "integrity_response",
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
                if parseOk and type(parsed) == "table" and parsed.lp_chunk then
                    if parsed.lp_chunk == "s" then
                        chunkState = { id = parsed.id, total = tonumber(parsed.total) or 0, len = tonumber(parsed.len) or 0, parts = {} }
                    elseif parsed.lp_chunk == "d" and chunkState and parsed.id == chunkState.id then
                        local seq = tonumber(parsed.seq) or (#chunkState.parts + 1)
                        chunkState.parts[seq] = tostring(parsed.data or "")
                    elseif parsed.lp_chunk == "e" and chunkState and parsed.id == chunkState.id then
                        local full = table.concat(chunkState.parts)
                        local expectedLen = chunkState.len
                        chunkState = nil
                        if #full == expectedLen then
                            local decOkChunk, unencryptedScript = pcall(decryptXOR, full, data.token)
                            if decOkChunk then
                                executeScriptPayload(unencryptedScript)
                            else
                                runnerWarn("Chunk decryption error: " .. tostring(unencryptedScript))
                                sendErrorReport("chunked script decryption failed: " .. tostring(unencryptedScript), "")
                            end
                        else
                            sendErrorReport("chunked script reassembly failed (length mismatch)", "")
                        end
                    end
                    return
                end
            end
            executeScriptPayload(decryptedOrErr)
        end)
    end
    bindSignal("OnMessage", "onmessage", handleIncomingMessage)
    local closed = false
    hbThread = task.spawn(function()
        while ws and not closed do
            task.wait(30)
            if closed then break end
            if not isCurrentSession() then
                closeWebSocket(ws)
                break
            end
            local payload = HttpService:JSONEncode({ event = "heartbeat", timestamp = os.time() })
            pcall(function()
                if ws.Send then ws:Send(payload)
                elseif ws.send then ws:send(payload) end
            end)
        end
    end)
    local function onDisconnect(code, reason)
        if closed then return end
        closed = true
        if getgenv and type(getgenv()._luaprotect_last_connect_attempt) == "number" then
            local globalAttempt = getgenv()._luaprotect_last_connect_attempt
            if globalAttempt ~= MY_LAST_CONNECT_ATTEMPT and (os.clock() - globalAttempt) < 3 then
                reconnectDisabled = true
                runnerQuiet("Yielding WebSocket to another script (executor limit detected).")
            end
        end
        local closeCode = tonumber(code)
        local closeReason = type(reason) == "string" and reason or ""
        local function readCloseEvent(value)
            if type(value) ~= "table" and type(value) ~= "userdata" then return nil, nil end
            local eventCode, eventReason
            pcall(function()
                eventCode = tonumber(value.code or value.Code or value.statusCode or value.status or value.closeCode)
                eventReason = value.reason or value.Reason or value.message or value.Message
            end)
            return eventCode, eventReason and tostring(eventReason) or nil
        end
        local eventCode, eventReason = readCloseEvent(code)
        if eventCode then closeCode = eventCode end
        if eventReason and eventReason ~= "" then closeReason = eventReason end
        if not closeCode then
            local secondCode, secondReason = readCloseEvent(reason)
            closeCode = secondCode or tonumber(reason)
            if secondReason and secondReason ~= "" then closeReason = secondReason end
        end
        if closeCode == 4008 or closeReason:find("Superseded", 1, true) then
            reconnectDisabled = true
        end
        lastCloseWasBusy = closeCode == 4013 or closeCode == 4029
            or closeReason:find("at capacity", 1, true) ~= nil
            or closeReason:find("Too many concurrent", 1, true) ~= nil
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
        if code ~= nil and type(code) == "number" then table.insert(parts, "code=" .. tostring(code)) end
        if code ~= nil and type(code) == "string" and code ~= "" then table.insert(parts, "code=" .. code) end
        if reason ~= nil and tostring(reason) ~= "" and type(reason) ~= "userdata" then table.insert(parts, "reason=" .. tostring(reason)) end
        local detail = (#parts > 0) and (" (" .. table.concat(parts, ", ") .. ")") or ""
        runnerQuiet("Disconnected" .. detail)
    end
    bindSignal("OnClose", "onclose", onDisconnect)
    local function handleIncomingError(err)
        runnerQuiet("WS error: " .. tostring(err))
        onDisconnect()
    end
    bindSignal("OnError", "onerror", handleIncomingError)
    return ws, false
end
if not fetchRunnerKey() then return end
if not IS_TELEPORT_RECONNECT then
    RUN_ID = tostring(RUNNER_ID) .. ":" .. RUN_ID
end
if _LP_STORE then _LP_STORE.run_ids[SCRIPT_TAG] = RUN_ID end
if SCRIPT_TAG == "default" then
    if getgenv then getgenv()._luaprotect_run_id = RUN_ID end
    if shared then shared._luaprotect_run_id = RUN_ID end
    if _G then _G._luaprotect_run_id = RUN_ID end
end
local CONTINUOUS_SESSION = "0" == "1"
local teleportHandoffRegistered = false
local function registerTeleportHandoff()
    if not CONTINUOUS_SESSION or teleportHandoffRegistered then return end
    teleportHandoffRegistered = true
    for attempt = 1, 3 do
        local handoffOk, handoffBody = makeRequest(HOST_URL .. "/api/runner-handoff", {
            userId = userId, hwid = hwid, scriptId = SCRIPT_ID,
            runnerId = RUNNER_ID, sessionId = CURRENT_SESSION, runId = RUN_ID,
        }, false)
        if handoffOk and handoffBody then
            local parsedOk, handoffData = pcall(HttpService.JSONDecode, HttpService, handoffBody)
            if parsedOk and handoffData and handoffData.token then
                local relaunchUrl = HOST_URL .. "/api/runner-reconnect/" .. SCRIPT_ID .. "?handoff=" .. tostring(handoffData.token)
                pcall(function()
                    if syn and syn.queue_on_teleport then syn.queue_on_teleport(string.format("loadstring(game:HttpGet(%q))()", relaunchUrl))
                    elseif queue_on_teleport then queue_on_teleport(string.format("loadstring(game:HttpGet(%q))()", relaunchUrl))
                    elseif krnl and krnl.queue_on_teleport then krnl.queue_on_teleport(string.format("loadstring(game:HttpGet(%q))()", relaunchUrl)) end
                end)
                return
            end
        end
        if attempt < 3 then task.wait(attempt * 2) end
    end
    teleportHandoffRegistered = false
    runnerWarn("Could not register continuous-session handoff")
end
task.spawn(function()
    local retries = 0
    local busyRetries = 0
    local recoveringFromStable = false
    local hasConnected = IS_TELEPORT_RECONNECT
    while isCurrentSession() do
        local activeWs = (_LP_STORE and _LP_STORE.sockets[SCRIPT_TAG])
        if not activeWs and SCRIPT_TAG == "default" then
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
                runnerQuiet("Server busy - retrying in " .. string.format("%.0f", delay) .. "s...")
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
                runnerQuiet("Reconnecting in " .. string.format("%.1f", delay) .. "s...")
                waitWithCountdown(delay)
            end
            if not isCurrentSession() then break end
            local ws, isRejected = tryConnect(isInternalReconnect)
            if isRejected then break end
            if ws then
                hasConnected = true
                registerTeleportHandoff()
                if SCRIPT_TAG == "default" then
                    if getgenv then getgenv().sentinel_auth_passed = true
                    elseif shared then shared.sentinel_auth_passed = true end
                end
            end
        end
    end
    local finalWs = (_LP_STORE and _LP_STORE.sockets[SCRIPT_TAG])
    if not finalWs and SCRIPT_TAG == "default" then
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
