-- ========================================================
--  OWNER HUB GUI LIBRARY v5.3 (FIXED KEYBIND SYSTEM)
-- ========================================================
local Library = {}

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

Library.Themes = {
    Emerald  = { Accent = Color3.fromRGB(16, 185, 129), BG = Color3.fromRGB(15, 17, 21),  Card = Color3.fromRGB(24, 27, 34),  Input = Color3.fromRGB(33, 37, 47), Text = Color3.fromRGB(240, 242, 245), Border = Color3.fromRGB(45, 52, 65),  Off = Color3.fromRGB(42, 47, 60) },
    Ruby     = { Accent = Color3.fromRGB(239, 68, 68),  BG = Color3.fromRGB(20, 14, 16),  Card = Color3.fromRGB(32, 22, 26),  Input = Color3.fromRGB(45, 30, 35), Text = Color3.fromRGB(250, 240, 242), Border = Color3.fromRGB(65, 40, 48),  Off = Color3.fromRGB(50, 35, 40) },
    Sapphire = { Accent = Color3.fromRGB(59, 130, 246), BG = Color3.fromRGB(14, 17, 24),  Card = Color3.fromRGB(22, 27, 39),  Input = Color3.fromRGB(30, 38, 54), Text = Color3.fromRGB(240, 245, 255), Border = Color3.fromRGB(40, 52, 75),  Off = Color3.fromRGB(35, 45, 60) },
    Amethyst = { Accent = Color3.fromRGB(168, 85, 247), BG = Color3.fromRGB(18, 14, 24),  Card = Color3.fromRGB(28, 22, 39),  Input = Color3.fromRGB(39, 30, 54), Text = Color3.fromRGB(245, 240, 255), Border = Color3.fromRGB(55, 40, 75),  Off = Color3.fromRGB(45, 35, 60) },
    Amber    = { Accent = Color3.fromRGB(245, 158, 11), BG = Color3.fromRGB(20, 17, 14),  Card = Color3.fromRGB(34, 27, 22),  Input = Color3.fromRGB(47, 38, 30), Text = Color3.fromRGB(255, 245, 240), Border = Color3.fromRGB(65, 52, 40),  Off = Color3.fromRGB(50, 42, 35) }
}

local CONFIG_FOLDER = "OwnerHub"
local CONFIG_FILE = "OwnerHub/config.json"

local function SaveConfig(data)
    pcall(function()
        if isfolder and not isfolder(CONFIG_FOLDER) and makefolder then makefolder(CONFIG_FOLDER) end
        if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(data)) end
    end)
end

local function LoadConfig()
    local result = nil
    pcall(function()
        if isfolder and isfolder(CONFIG_FOLDER) and isfile and isfile(CONFIG_FILE) and readfile then
            result = HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
    end)
    return result or {}
end

local function ColorToHex(color)
    return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

local function TweenColor(obj, prop, targetColor, animate)
    if not obj or not obj.Parent then return end
    if animate then
        TS:Create(obj, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[prop] = targetColor}):Play()
    else
        obj[prop] = targetColor
    end
end

function Library:Notify(titleText, msgText, duration)
    duration = duration or 3.5
    local CoreGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    
    local NotifGui = CoreGui:FindFirstChild("OwnerHub_Notif")
    if not NotifGui then
        NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "OwnerHub_Notif"
        NotifGui.ResetOnSpawn = false
        NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NotifGui.Parent = CoreGui
    end

    local C = Library.CurrentTheme or Library.Themes.Emerald
    local Card = Instance.new("Frame", NotifGui)
    Card.Size = UDim2.new(0, 280, 0, 58)
    Card.Position = UDim2.new(0.5, -140, 0, -80)
    Card.BackgroundColor3 = C.Card
    Card.ClipsDescendants = true
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color, Stroke.Thickness = C.Accent, 1.5

    local Title = Instance.new("TextLabel", Card)
    Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -20, 0, 22), UDim2.new(0, 10, 0, 6), 1
    Title.Font, Title.Text, Title.TextColor3, Title.TextSize = Enum.Font.GothamBold, titleText or "УВЕДОМЛЕНИЕ", C.Accent, 13

    local Msg = Instance.new("TextLabel", Card)
    Msg.Size, Msg.Position, Msg.BackgroundTransparency = UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 28), 1
    Msg.Font, Msg.Text, Msg.TextColor3, Msg.TextSize = Enum.Font.GothamMedium, msgText or "", C.Text, 11

    TS:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -140, 0, 20)}):Play()

    task.delay(duration, function()
        local tweenOut = TS:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -140, 0, -80)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function() Card:Destroy() end)
    end)
end

function Library:CreateWindow(hubTitle)
    if game:GetService("CoreGui"):FindFirstChild("OwnerHub_Core") then
        game:GetService("CoreGui").OwnerHub_Core:Destroy()
    end

    local savedConfig = LoadConfig()
    local themeName = savedConfig.Theme or "Emerald"
    local toggleKeyName = savedConfig.ToggleKey or "RightControl"
    local initialToggleKey = Enum.KeyCode[toggleKeyName] or Enum.KeyCode.RightControl

    local C = Library.Themes[themeName] or Library.Themes.Emerald
    Library.CurrentTheme = C

    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name, ScreenGui.ResetOnSpawn = "OwnerHub_Core", false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("CanvasGroup", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = C.BG
    MainFrame.Position = UDim2.new(0.5, -280, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 560, 0, 350)
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color, MainStroke.Thickness, MainStroke.Transparency = C.Accent, 1.5, 0.2

    local WindowToggleKey = initialToggleKey
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == WindowToggleKey then
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end)

    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, MainFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TS:Create(MainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local Header = Instance.new("Frame", MainFrame)
    Header.BackgroundTransparency, Header.Size = 1, UDim2.new(1, 0, 0, 42)

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.BackgroundTransparency, TitleLabel.Position, TitleLabel.Size = 1, UDim2.new(0, 14, 0, 0), UDim2.new(1, -100, 1, 0)
    TitleLabel.Font, TitleLabel.RichText, TitleLabel.TextSize, TitleLabel.TextXAlignment = Enum.Font.GothamBold, true, 14, Enum.TextXAlignment.Left

    local function updateTitleText(theme)
        local hex = ColorToHex(theme.Accent)
        TitleLabel.Text = (hubTitle or "OWNER HUB") .. string.format(" <font color=\"%s\">v5.3</font>", hex)
        TitleLabel.TextColor3 = theme.Text
    end
    updateTitleText(C)

    local ControlHolder = Instance.new("Frame", Header)
    ControlHolder.BackgroundTransparency, ControlHolder.Position, ControlHolder.Size = 1, UDim2.new(1, -70, 0, 8), UDim2.new(0, 60, 0, 26)

    local MinBtn = Instance.new("TextButton", ControlHolder)
    MinBtn.Size, MinBtn.Position, MinBtn.AutoButtonColor = UDim2.new(0, 26, 0, 26), UDim2.new(0, 0, 0, 0), false
    MinBtn.Font, MinBtn.Text, MinBtn.TextSize = Enum.Font.GothamBold, "—", 12
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
    local MinStroke = Instance.new("UIStroke", MinBtn)

    local CloseBtn = Instance.new("TextButton", ControlHolder)
    CloseBtn.Size, CloseBtn.Position, CloseBtn.AutoButtonColor = UDim2.new(0, 26, 0, 26), UDim2.new(0, 32, 0, 0), false
    CloseBtn.Font, CloseBtn.Text, CloseBtn.TextSize = Enum.Font.GothamBold, "X", 12
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    local CloseStroke = Instance.new("UIStroke", CloseBtn)

    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Name, Sidebar.BackgroundTransparency, Sidebar.Position, Sidebar.Size = "Sidebar", 1, UDim2.new(0, 12, 0, 48), UDim2.new(0, 135, 1, -60)
    Sidebar.CanvasSize, Sidebar.AutomaticCanvasSize, Sidebar.ScrollBarThickness = UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.Y, 0

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.SortOrder, SidebarLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 6)

    local ContainerFolder = Instance.new("Frame", MainFrame)
    ContainerFolder.Name, ContainerFolder.BackgroundTransparency, ContainerFolder.Position, ContainerFolder.Size = "Containers", 1, UDim2.new(0, 155, 0, 48), UDim2.new(1, -167, 1, -60)

    local ModalOverlay = Instance.new("Frame", MainFrame)
    ModalOverlay.Name, ModalOverlay.Size, ModalOverlay.Position = "ModalOverlay", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0)
    ModalOverlay.BackgroundColor3, ModalOverlay.BackgroundTransparency, ModalOverlay.ZIndex, ModalOverlay.Visible = Color3.fromRGB(0, 0, 0), 1, 100, false

    local ModalCard = Instance.new("Frame", ModalOverlay)
    ModalCard.Size, ModalCard.Position, ModalCard.BackgroundColor3, ModalCard.ZIndex = UDim2.new(0, 320, 0, 160), UDim2.new(0.5, -160, 0.5, -80), C.Card, 101
    Instance.new("UICorner", ModalCard).CornerRadius = UDim.new(0, 12)
    local ModalStroke = Instance.new("UIStroke", ModalCard)
    ModalStroke.Color, ModalStroke.Thickness = C.Accent, 1.5

    local ModalTitle = Instance.new("TextLabel", ModalCard)
    ModalTitle.Size, ModalTitle.Position, ModalTitle.BackgroundTransparency, ModalTitle.ZIndex = UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 10), 1, 102
    ModalTitle.Font, ModalTitle.Text, ModalTitle.TextColor3, ModalTitle.TextSize = Enum.Font.GothamBold, "ПОДТВЕРЖДЕНИЕ ВЫХОДА", C.Accent, 14

    local ModalDesc = Instance.new("TextLabel", ModalCard)
    ModalDesc.Size, ModalDesc.Position, ModalDesc.BackgroundTransparency, ModalDesc.ZIndex = UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 45), 1, 102
    ModalDesc.Font, ModalDesc.Text, ModalDesc.TextColor3, ModalDesc.TextSize, ModalDesc.TextWrapped = Enum.Font.GothamMedium, "Вы действительно хотите полностью закрыть Owner Hub?", C.Text, 12, true

    local ModalYes = Instance.new("TextButton", ModalCard)
    ModalYes.Size, ModalYes.Position, ModalYes.AutoButtonColor, ModalYes.ZIndex = UDim2.new(0, 135, 0, 32), UDim2.new(0, 15, 1, -45), false, 102
    ModalYes.Font, ModalYes.Text, ModalYes.TextSize = Enum.Font.GothamBold, "Да, закрыть", 12
    Instance.new("UICorner", ModalYes).CornerRadius = UDim.new(0, 8)

    local ModalNo = Instance.new("TextButton", ModalCard)
    ModalNo.Size, ModalNo.Position, ModalNo.AutoButtonColor, ModalNo.ZIndex = UDim2.new(0, 135, 0, 32), UDim2.new(1, -150, 1, -45), false, 102
    ModalNo.Font, ModalNo.Text, ModalNo.TextSize = Enum.Font.GothamBold, "Отмена", 12
    Instance.new("UICorner", ModalNo).CornerRadius = UDim.new(0, 8)
    local ModalNoStroke = Instance.new("UIStroke", ModalNo)

    local WindowObj = {
        Tabs = {},
        ActiveTab = nil,
        CurrentThemeName = themeName,
        ToggleKey = WindowToggleKey,
        ThemeUpdaters = {},
        IsMinimized = false
    }

    function WindowObj:RegisterThemeUpdater(fn)
        table.insert(WindowObj.ThemeUpdaters, fn)
        fn(Library.CurrentTheme, false)
    end

    function WindowObj:SetTheme(newThemeName)
        if Library.Themes[newThemeName] then
            WindowObj.CurrentThemeName = newThemeName
            local newC = Library.Themes[newThemeName]
            Library.CurrentTheme = newC

            TweenColor(MainFrame, "BackgroundColor3", newC.BG, true)
            TweenColor(MainStroke, "Color", newC.Accent, true)
            TweenColor(ModalCard, "BackgroundColor3", newC.Card, true)
            TweenColor(ModalStroke, "Color", newC.Accent, true)
            TweenColor(ModalTitle, "TextColor3", newC.Accent, true)
            TweenColor(ModalDesc, "TextColor3", newC.Text, true)
            TweenColor(ModalYes, "BackgroundColor3", newC.Accent, true)
            TweenColor(ModalYes, "TextColor3", Color3.fromRGB(255, 255, 255), true)
            TweenColor(ModalNo, "BackgroundColor3", newC.Card, true)
            TweenColor(ModalNoStroke, "Color", newC.Border, true)
            TweenColor(ModalNo, "TextColor3", newC.Text, true)

            updateTitleText(newC)

            local validUpdaters = {}
            for _, fn in ipairs(WindowObj.ThemeUpdaters) do
                local success = pcall(fn, newC, true)
                if success then table.insert(validUpdaters, fn) end
            end
            WindowObj.ThemeUpdaters = validUpdaters
        end
    end

    WindowObj:RegisterThemeUpdater(function(theme, anim)
        TweenColor(MinBtn, "BackgroundColor3", theme.Card, anim)
        TweenColor(MinBtn, "TextColor3", theme.Text, anim)
        TweenColor(MinStroke, "Color", theme.Border, anim)

        TweenColor(CloseBtn, "BackgroundColor3", theme.Card, anim)
        TweenColor(CloseBtn, "TextColor3", theme.Text, anim)
        TweenColor(CloseStroke, "Color", theme.Border, anim)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        WindowObj.IsMinimized = not WindowObj.IsMinimized
        TS:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = WindowObj.IsMinimized and UDim2.new(0, 560, 0, 42) or UDim2.new(0, 560, 0, 350)
        }):Play()
    end)

    local function toggleModal(show)
        if show then
            ModalOverlay.Visible = true
            TS:Create(ModalOverlay, TweenInfo.new(0.25), {BackgroundTransparency = 0.4}):Play()
            ModalCard.Size = UDim2.new(0, 280, 0, 140)
            TS:Create(ModalCard, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 160)}):Play()
        else
            TS:Create(ModalOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            local t = TS:Create(ModalCard, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 280, 0, 140)})
            t:Play()
            t.Completed:Connect(function() ModalOverlay.Visible = false end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(function() toggleModal(true) end)
    ModalNo.MouseButton1Click:Connect(function() toggleModal(false) end)
    ModalYes.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        Library:Notify("ВЫГРУЗКА", "Скрипт успешно выгружен.", 3)
    end)

    function WindowObj:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Name = tabName .. "_TabBtn"
        TabBtn.Size, TabBtn.Font, TabBtn.Text, TabBtn.TextSize, TabBtn.AutoButtonColor = UDim2.new(1, 0, 0, 32), Enum.Font.GothamBold, tabName, 12, false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        local TabBtnStroke = Instance.new("UIStroke", TabBtn)
        TabBtnStroke.Thickness = 1

        local ContentFrame = Instance.new("ScrollingFrame", ContainerFolder)
        ContentFrame.Name, ContentFrame.BackgroundTransparency, ContentFrame.Size = tabName .. "_Container", 1, UDim2.new(1, 0, 1, 0)
        ContentFrame.CanvasSize, ContentFrame.AutomaticCanvasSize, ContentFrame.ScrollBarThickness, ContentFrame.Visible = UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.Y, 3, false

        local ContentPadding = Instance.new("UIPadding", ContentFrame)
        ContentPadding.PaddingLeft, ContentPadding.PaddingRight, ContentPadding.PaddingTop, ContentPadding.PaddingBottom = UDim.new(0, 2), UDim.new(0, 6), UDim.new(0, 2), UDim.new(0, 6)

        local UIList = Instance.new("UIListLayout", ContentFrame)
        UIList.SortOrder, UIList.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 8)

        local TabObj = { Frame = ContentFrame }

        local function RefreshTabColors(theme, anim)
            TweenColor(ContentFrame, "ScrollBarImageColor3", theme.Accent, anim)
            if WindowObj.ActiveTab == TabObj then
                TweenColor(TabBtn, "BackgroundColor3", theme.Accent, anim)
                TweenColor(TabBtnStroke, "Color", theme.Accent, anim)
                TweenColor(TabBtn, "TextColor3", Color3.fromRGB(255, 255, 255), anim)
            else
                TweenColor(TabBtn, "BackgroundColor3", theme.Card, anim)
                TweenColor(TabBtnStroke, "Color", theme.Border, anim)
                TweenColor(TabBtn, "TextColor3", theme.Text, anim)
            end
        end

        WindowObj:RegisterThemeUpdater(RefreshTabColors)

        local function ActivateTab()
            for _, t in pairs(WindowObj.Tabs) do t.Frame.Visible = false end
            ContentFrame.Visible = true
            WindowObj.ActiveTab = TabObj
            for _, updater in ipairs(WindowObj.ThemeUpdaters) do updater(Library.CurrentTheme, true) end
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)
        table.insert(WindowObj.Tabs, { Btn = TabBtn, Frame = ContentFrame, TabObj = TabObj })

        if #WindowObj.Tabs == 1 then ActivateTab() end

        function TabObj:AddSection(text)
            local Frame = Instance.new("Frame", ContentFrame)
            Frame.BackgroundTransparency, Frame.Size = 1, UDim2.new(1, 0, 0, 22)
            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, 0), Enum.Font.GothamBold, string.upper(text), 11, Enum.TextXAlignment.Left

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Label, "TextColor3", theme.Accent, anim)
            end)
        end

        function TabObj:AddLabel(text, color)
            local Frame = Instance.new("Frame", ContentFrame)
            Frame.BackgroundTransparency, Frame.Size = 1, UDim2.new(1, 0, 0, 20)
            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.RichText, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, 0), Enum.Font.GothamMedium, text, true, 12, Enum.TextXAlignment.Left

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Label, "TextColor3", color or theme.Text, anim)
            end)
        end

        function TabObj:AddButton(name, callback)
            local Button = Instance.new("TextButton", ContentFrame)
            Button.Size, Button.AutoButtonColor, Button.Font, Button.Text, Button.TextSize = UDim2.new(1, 0, 0, 34), false, Enum.Font.GothamBold, name, 12
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Button)
            Stroke.Thickness = 1

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Button, "BackgroundColor3", theme.Card, anim)
                TweenColor(Button, "TextColor3", theme.Text, anim)
                TweenColor(Stroke, "Color", theme.Border, anim)
            end)

            Button.MouseButton1Click:Connect(function()
                TS:Create(Button, TweenInfo.new(0.08), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
                task.delay(0.1, function()
                    TS:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Library.CurrentTheme.Card}):Play()
                end)
                if callback then callback() end
            end)
        end

        function TabObj:AddToggle(name, defaultState, callback)
            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(1, -55, 1, 0), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local SwitchBg = Instance.new("TextButton", Frame)
            SwitchBg.Text, SwitchBg.AutoButtonColor, SwitchBg.Position, SwitchBg.Size = "", false, UDim2.new(1, -44, 0.5, -9), UDim2.new(0, 34, 0, 18)
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame", SwitchBg)
            Circle.Size, Circle.BackgroundColor3 = UDim2.new(0, 12, 0, 12), Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local state = defaultState

            local function applyStateColors(theme, anim)
                theme = theme or Library.CurrentTheme
                TweenColor(Frame, "BackgroundColor3", theme.Card, anim)
                TweenColor(Label, "TextColor3", theme.Text, anim)
                Circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                TweenColor(SwitchBg, "BackgroundColor3", state and theme.Accent or theme.Off, anim)
                TweenColor(Stroke, "Color", state and theme.Accent or theme.Border, anim)
            end

            WindowObj:RegisterThemeUpdater(applyStateColors)

            local function updateState(newState)
                state = newState
                TS:Create(Circle, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                TS:Create(SwitchBg, TweenInfo.new(0.15), {BackgroundColor3 = state and Library.CurrentTheme.Accent or Library.CurrentTheme.Off}):Play()
                TS:Create(Stroke, TweenInfo.new(0.15), {Color = state and Library.CurrentTheme.Accent or Library.CurrentTheme.Border}):Play()
                if callback then callback(state) end
            end

            SwitchBg.MouseButton1Click:Connect(function() updateState(not state) end)

            return { Set = function(_, val) updateState(val) end }
        end

        function TabObj:AddSlider(name, min, max, default, step, callback)
            min, max, step = min or 0, max or 100, step or 1
            local value = default or min

            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 46)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 4), UDim2.new(0.6, 0, 0, 18), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local ValLabel = Instance.new("TextLabel", Frame)
            ValLabel.BackgroundTransparency, ValLabel.Position, ValLabel.Size, ValLabel.Font, ValLabel.Text, ValLabel.TextSize, ValLabel.TextXAlignment = 1, UDim2.new(0.6, 0, 0, 4), UDim2.new(0.4, -10, 0, 18), Enum.Font.GothamBold, tostring(value), 12, Enum.TextXAlignment.Right

            local Track = Instance.new("TextButton", Frame)
            Track.Text, Track.AutoButtonColor, Track.Position, Track.Size = "", false, UDim2.new(0, 10, 0, 28), UDim2.new(1, -20, 0, 8)
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Frame, "BackgroundColor3", theme.Card, anim)
                TweenColor(Stroke, "Color", theme.Border, anim)
                TweenColor(Label, "TextColor3", theme.Text, anim)
                TweenColor(ValLabel, "TextColor3", theme.Accent, anim)
                TweenColor(Track, "BackgroundColor3", theme.Input, anim)
                TweenColor(Fill, "BackgroundColor3", theme.Accent, anim)
            end)

            local sliding = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local rawVal = min + (max - min) * pos
                value = math.floor(rawVal / step + 0.5) * step
                value = math.clamp(value, min, max)
                ValLabel.Text = tostring(value)
                TS:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)}):Play()
                if callback then callback(value) end
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true updateSlider(input) end
            end)
            UIS.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
        end

        function TabObj:AddInput(labelText, defaultText, callback)
            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local FrameStroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.Font.GothamMedium, labelText, 12, Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox", Frame)
            Box.Position, Box.Size, Box.Font, Box.Text, Box.TextSize, Box.ClearTextOnFocus = UDim2.new(0.5, 0, 0.5, -10), UDim2.new(0.5, -8, 0, 20), Enum.Font.GothamBold, defaultText or "", 11, false
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Frame, "BackgroundColor3", theme.Card, anim)
                TweenColor(FrameStroke, "Color", theme.Border, anim)
                TweenColor(Label, "TextColor3", theme.Text, anim)
                TweenColor(Box, "BackgroundColor3", theme.Input, anim)
                TweenColor(Box, "TextColor3", theme.Text, anim)
            end)

            Box.FocusLost:Connect(function() if callback then callback(Box.Text) end end)
        end

        function TabObj:AddDropdown(name, list, default, callback)
            list = list or {}
            local selected = default or list[1] or "Ничего"

            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Frame.ClipsDescendants = true
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local FrameStroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(0.45, 0, 0, 34), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local DropBtn = Instance.new("TextButton", Frame)
            DropBtn.Position, DropBtn.Size, DropBtn.Font, DropBtn.Text, DropBtn.TextSize = UDim2.new(0.45, 0, 0, 6), UDim2.new(0.55, -6, 0, 22), Enum.Font.GothamBold, tostring(selected) .. "  ▼", 11
            DropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

            local DropHolder = Instance.new("ScrollingFrame", Frame)
            DropHolder.BackgroundTransparency, DropHolder.Position, DropHolder.Size = 1, UDim2.new(0, 6, 0, 34), UDim2.new(1, -12, 0, 0)
            DropHolder.CanvasSize, DropHolder.AutomaticCanvasSize, DropHolder.ScrollBarThickness, DropHolder.BorderSizePixel = UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.Y, 3, 0

            local ListLayout = Instance.new("UIListLayout", DropHolder)
            ListLayout.SortOrder, ListLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Frame, "BackgroundColor3", theme.Card, anim)
                TweenColor(FrameStroke, "Color", theme.Border, anim)
                TweenColor(Label, "TextColor3", theme.Text, anim)
                TweenColor(DropBtn, "BackgroundColor3", theme.Input, anim)
                TweenColor(DropBtn, "TextColor3", theme.Text, anim)
                TweenColor(DropHolder, "ScrollBarImageColor3", theme.Accent, anim)
            end)

            local isOpen = false
            local function toggleDrop()
                isOpen = not isOpen
                local targetHeight = math.min(#list * 26, 120)
                TS:Create(Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, isOpen and (40 + targetHeight) or 34) }):Play()
                TS:Create(DropHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, -12, 0, isOpen and targetHeight or 0) }):Play()
            end

            DropBtn.MouseButton1Click:Connect(toggleDrop)

            local function buildList(newList)
                list = newList or list
                for _, c in ipairs(DropHolder:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _, option in ipairs(list) do
                    local Btn = Instance.new("TextButton", DropHolder)
                    Btn.Size, Btn.Font, Btn.Text, Btn.TextSize, Btn.BackgroundColor3, Btn.TextColor3 = UDim2.new(1, -6, 0, 22), Enum.Font.GothamMedium, tostring(option), 11, Library.CurrentTheme.Input, Library.CurrentTheme.Text
                    Btn.TextTruncate = Enum.TextTruncate.AtEnd
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                    Btn.MouseButton1Click:Connect(function()
                        selected = option
                        DropBtn.Text = tostring(selected) .. "  ▼"
                        toggleDrop()
                        if callback then callback(selected) end
                    end)
                end
            end
            buildList(list)

            return { Refresh = function(_, newList, newDefault) buildList(newList) if newDefault then selected = newDefault DropBtn.Text = tostring(selected) .. "  ▼" end end }
        end

        function TabObj:AddMultiDropdown(name, list, callback)
            list = list or {}
            local selectedMap = {}

            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Frame.ClipsDescendants = true
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local FrameStroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(0.45, 0, 0, 34), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local DropBtn = Instance.new("TextButton", Frame)
            DropBtn.Position, DropBtn.Size, DropBtn.Font, DropBtn.Text, DropBtn.TextSize = UDim2.new(0.45, 0, 0, 6), UDim2.new(0.55, -6, 0, 22), Enum.Font.GothamBold, "Выбрано: 0  ▼", 11
            DropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

            local DropHolder = Instance.new("ScrollingFrame", Frame)
            DropHolder.BackgroundTransparency, DropHolder.Position, DropHolder.Size = 1, UDim2.new(0, 6, 0, 34), UDim2.new(1, -12, 0, 0)
            DropHolder.CanvasSize, DropHolder.AutomaticCanvasSize, DropHolder.ScrollBarThickness, DropHolder.BorderSizePixel = UDim2.new(0, 0, 0, 0), Enum.AutomaticSize.Y, 3, 0

            local ListLayout = Instance.new("UIListLayout", DropHolder)
            ListLayout.SortOrder, ListLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Frame, "BackgroundColor3", theme.Card, anim)
                TweenColor(FrameStroke, "Color", theme.Border, anim)
                TweenColor(Label, "TextColor3", theme.Text, anim)
                TweenColor(DropBtn, "BackgroundColor3", theme.Input, anim)
                TweenColor(DropBtn, "TextColor3", theme.Text, anim)
                TweenColor(DropHolder, "ScrollBarImageColor3", theme.Accent, anim)
            end)

            local isOpen = false
            local function toggleDrop()
                isOpen = not isOpen
                local targetHeight = math.min(#list * 26, 120)
                TS:Create(Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, isOpen and (40 + targetHeight) or 34) }):Play()
                TS:Create(DropHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, -12, 0, isOpen and targetHeight or 0) }):Play()
            end

            DropBtn.MouseButton1Click:Connect(toggleDrop)

            local function updateTitle()
                local count = 0
                for _ in pairs(selectedMap) do count = count + 1 end
                DropBtn.Text = "Выбрано: " .. tostring(count) .. "  ▼"
            end

            local function buildList(newList)
                list = newList or list
                for _, c in ipairs(DropHolder:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _, option in ipairs(list) do
                    local Btn = Instance.new("TextButton", DropHolder)
                    Btn.Size, Btn.Font, Btn.Text, Btn.TextSize = UDim2.new(1, -6, 0, 22), Enum.Font.GothamMedium, tostring(option), 11
                    Btn.BackgroundColor3 = selectedMap[option] and Library.CurrentTheme.Accent or Library.CurrentTheme.Input
                    Btn.TextColor3 = Library.CurrentTheme.Text
                    Btn.TextTruncate = Enum.TextTruncate.AtEnd
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                    Btn.MouseButton1Click:Connect(function()
                        selectedMap[option] = not selectedMap[option] and true or nil
                        Btn.BackgroundColor3 = selectedMap[option] and Library.CurrentTheme.Accent or Library.CurrentTheme.Input
                        updateTitle()
                        if callback then callback(selectedMap) end
                    end)
                end
                updateTitle()
            end
            buildList(list)

            return { Refresh = function(_, newList) buildList(newList) end }
        end

        function TabObj:AddKeybind(name, defaultKey, callback)
            local currentKey = defaultKey or Enum.KeyCode.E
            local binding = false

            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(0.6, 0, 1, 0), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local BindBtn = Instance.new("TextButton", Frame)
            BindBtn.Position, BindBtn.Size, BindBtn.Font, BindBtn.Text, BindBtn.TextSize = UDim2.new(0.6, 0, 0.5, -11), UDim2.new(0.4, -8, 0, 22), Enum.Font.GothamBold, currentKey.Name, 11
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 6)

            WindowObj:RegisterThemeUpdater(function(theme, anim)
                TweenColor(Frame, "BackgroundColor3", theme.Card, anim)
                TweenColor(Stroke, "Color", theme.Border, anim)
                TweenColor(Label, "TextColor3", theme.Text, anim)
                TweenColor(BindBtn, "BackgroundColor3", theme.Input, anim)
                TweenColor(BindBtn, "TextColor3", theme.Text, anim)
            end)

            BindBtn.MouseButton1Click:Connect(function()
                binding = true
                BindBtn.Text = "..."
            end)

            UIS.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

                if binding then
                    currentKey = input.KeyCode
                    BindBtn.Text = currentKey.Name
                    binding = false
                elseif input.KeyCode == currentKey then
                    if callback then callback(currentKey) end
                end
            end)
        end

        return TabObj
    end

    function WindowObj:CreateSettingsTab()
        local SettingsTab = WindowObj:CreateTab("Settings")

        SettingsTab:AddSection("Оформление и Управление")
        
        local selectedTheme = WindowObj.CurrentThemeName
        local selectedToggleKey = WindowObj.ToggleKey

        SettingsTab:AddDropdown("Тема GUI", {"Emerald", "Ruby", "Sapphire", "Amethyst", "Amber"}, selectedTheme, function(val)
            selectedTheme = val
            WindowObj:SetTheme(val)
        end)

        SettingsTab:AddKeybind("Клавиша скрытия GUI", selectedToggleKey, function(key)
            selectedToggleKey = key
            WindowObj.ToggleKey = key
        end)

        SettingsTab:AddButton("Сохранить настройки", function()
            SaveConfig({ 
                Theme = selectedTheme,
                ToggleKey = selectedToggleKey.Name 
            })
            Library:Notify("НАСТРОЙКИ", "Тема («" .. selectedTheme .. "») и бинд («" .. selectedToggleKey.Name .. "») сохранены!", 2.5)
        end)

        SettingsTab:AddSection("Система и АФК")

        local antiAfkConn = nil
        SettingsTab:AddToggle("Анти-АФК", true, function(state)
            if state then
                if not antiAfkConn then
                    antiAfkConn = LocalPlayer.Idled:Connect(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            else
                if antiAfkConn then
                    antiAfkConn:Disconnect()
                    antiAfkConn = nil
                end
            end
        end)

        SettingsTab:AddToggle("Отключить 3D Рендер", false, function(state)
            RunService:Set3dRenderingEnabled(not state)
            Library:Notify("ГРАФИКА", state and "3D-рендер отключен." or "3D-рендер включен.", 2)
        end)

        return SettingsTab
    end

    return WindowObj
end

return Library
