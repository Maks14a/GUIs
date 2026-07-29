-- ========================================================
--         OWNER HUB GUI LIBRARY v5.0 (HORIZONTAL + THEMES)
-- ========================================================
local Library = {}

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Готовые цветовые палитры (Полный перекрас интерфейса)
Library.Themes = {
    Emerald  = { Accent = Color3.fromRGB(16, 185, 129), BG = Color3.fromRGB(15, 17, 21),  Card = Color3.fromRGB(24, 27, 34),  Input = Color3.fromRGB(33, 37, 47), Text = Color3.fromRGB(240, 242, 245), Border = Color3.fromRGB(45, 52, 65),  Off = Color3.fromRGB(42, 47, 60) },
    Ruby     = { Accent = Color3.fromRGB(239, 68, 68),  BG = Color3.fromRGB(20, 14, 16),  Card = Color3.fromRGB(32, 22, 26),  Input = Color3.fromRGB(45, 30, 35), Text = Color3.fromRGB(250, 240, 242), Border = Color3.fromRGB(65, 40, 48),  Off = Color3.fromRGB(50, 35, 40) },
    Sapphire = { Accent = Color3.fromRGB(59, 130, 246), BG = Color3.fromRGB(14, 17, 24),  Card = Color3.fromRGB(22, 27, 39),  Input = Color3.fromRGB(30, 38, 54), Text = Color3.fromRGB(240, 245, 255), Border = Color3.fromRGB(40, 52, 75),  Off = Color3.fromRGB(35, 45, 60) },
    Amethyst = { Accent = Color3.fromRGB(168, 85, 247), BG = Color3.fromRGB(18, 14, 24),  Card = Color3.fromRGB(28, 22, 39),  Input = Color3.fromRGB(39, 30, 54), Text = Color3.fromRGB(245, 240, 255), Border = Color3.fromRGB(55, 40, 75),  Off = Color3.fromRGB(45, 35, 60) },
    Amber    = { Accent = Color3.fromRGB(245, 158, 11), BG = Color3.fromRGB(20, 17, 14),  Card = Color3.fromRGB(34, 27, 22),  Input = Color3.fromRGB(47, 38, 30), Text = Color3.fromRGB(255, 245, 240), Border = Color3.fromRGB(65, 52, 40),  Off = Color3.fromRGB(50, 42, 35) }
}

-- Работа с Файловой Системой Эксплойта
local CONFIG_FOLDER = "OwnerHub"
local CONFIG_FILE = "OwnerHub/config.json"

local function SaveConfig(data)
    pcall(function()
        if isfolder and not isfolder(CONFIG_FOLDER) and makefolder then
            makefolder(CONFIG_FOLDER)
        end
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        end
    end)
end

local function LoadConfig()
    local result = nil
    pcall(function()
        if isfolder and isfolder(CONFIG_FOLDER) and isfile and isfile(CONFIG_FILE) and readfile then
            result = HttpService:JSONEncode(readfile(CONFIG_FILE))
        end
    end)
    return result or {}
end

-- Уведомления
function Library:Notify(titleText, msgText, duration)
    duration = duration or 3.5
    local CoreGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    
    local NotifGui = CoreGui:FindFirstChild("OwnerHub_Notif")
    if not NotifGui then
        NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "OwnerHub_Notif"
        NotifGui.ResetOnSpawn = false
        NotifGui.Parent = CoreGui
    end

    local C = Library.CurrentTheme or Library.Themes.Emerald
    local Card = Instance.new("Frame", NotifGui)
    Card.Size = UDim2.new(0, 300, 0, 60)
    Card.Position = UDim2.new(0.5, -150, 0, -80)
    Card.BackgroundColor3 = C.Card
    Card.ClipsDescendants = true
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color = C.Accent
    Stroke.Thickness = 1.5

    local Title = Instance.new("TextLabel", Card)
    Title.Size = UDim2.new(1, -20, 0, 24)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText or "УВЕДОМЛЕНИЕ"
    Title.TextColor3 = C.Accent
    Title.TextSize = 14

    local Msg = Instance.new("TextLabel", Card)
    Msg.Size = UDim2.new(1, -20, 0, 20)
    Msg.Position = UDim2.new(0, 10, 0, 30)
    Msg.BackgroundTransparency = 1
    Msg.Font = Enum.Font.GothamMedium
    Msg.Text = msgText or ""
    Msg.TextColor3 = C.Text
    Msg.TextSize = 12

    TS:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()

    task.delay(duration, function()
        local tweenOut = TS:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -150, 0, -80)
        })
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
    local C = Library.Themes[themeName] or Library.Themes.Emerald
    Library.CurrentTheme = C

    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name, ScreenGui.ResetOnSpawn = "OwnerHub_Core", false

    -- ГОРИЗОНТАЛЬНЫЙ РАЗМЕР (560x350)
    local MainFrame = Instance.new("CanvasGroup", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = C.BG
    MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 560, 0, 350)
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color, MainStroke.Thickness, MainStroke.Transparency = C.Accent, 1.5, 0.3

    local UIScale = Instance.new("UIScale", MainFrame)

    -- Перетаскивание
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

    -- Горячая клавиша скрытия (RightControl)
    local guiVisible, isAnimating = true, false
    UIS.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightControl then
            if isAnimating then return end
            guiVisible = not guiVisible
            isAnimating = true
            if guiVisible then
                MainFrame.Visible = true
                TS:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                local t = TS:Create(MainFrame, TweenInfo.new(0.15), {GroupTransparency = 0})
                t:Play()
                t.Completed:Connect(function() isAnimating = false end)
            else
                TS:Create(UIScale, TweenInfo.new(0.15), {Scale = 0.85}):Play()
                local t = TS:Create(MainFrame, TweenInfo.new(0.15), {GroupTransparency = 1})
                t:Play()
                t.Completed:Connect(function()
                    if not guiVisible then MainFrame.Visible = false end
                    isAnimating = false
                end)
            end
        end
    end)

    -- Верхняя шапка
    local Header = Instance.new("Frame", MainFrame)
    Header.BackgroundTransparency, Header.Size = 1, UDim2.new(1, 0, 0, 40)
    local Title = Instance.new("TextLabel", Header)
    Title.BackgroundTransparency, Title.Position, Title.Size, Title.Font, Title.Text, Title.RichText, Title.TextColor3, Title.TextSize, Title.TextXAlignment = 1, UDim2.new(0, 14, 0, 0), UDim2.new(1, -28, 1, 0), Enum.Font.GothamBold, hubTitle or "OWNER HUB", true, C.Text, 15, Enum.TextXAlignment.Left

    -- БОКОВАЯ ПАНЕЛЬ ТАБОВ (LEFT SIDEBAR)
    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundTransparency = 1
    Sidebar.Position = UDim2.new(0, 10, 0, 45)
    Sidebar.Size = UDim2.new(0, 130, 1, -55)
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.ScrollBarThickness = 0

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 6)

    -- ПРАВАЯ ОБЛАСТЬ КОНТЕНТА (MAIN CONTAINER)
    local ContainerFolder = Instance.new("Frame", MainFrame)
    ContainerFolder.Name = "Containers"
    ContainerFolder.BackgroundTransparency = 1
    ContainerFolder.Position = UDim2.new(0, 150, 0, 45)
    ContainerFolder.Size = UDim2.new(1, -160, 1, -55)

    local WindowObj = {
        Tabs = {},
        ActiveTab = nil,
        CurrentThemeName = themeName,
        ThemeUpdaters = {} -- Система полной динамической смены темы
    }

    -- Регистратор объектов для смены темы
    function WindowObj:RegisterThemeUpdater(fn)
        table.insert(WindowObj.ThemeUpdaters, fn)
        fn(Library.CurrentTheme)
    end

    -- Метод обновления всех цветов при выборе темы
    function WindowObj:SetTheme(newThemeName)
        if Library.Themes[newThemeName] then
            WindowObj.CurrentThemeName = newThemeName
            local newC = Library.Themes[newThemeName]
            Library.CurrentTheme = newC

            MainFrame.BackgroundColor3 = newC.BG
            MainStroke.Color = newC.Accent
            Title.TextColor3 = newC.Text

            savedConfig.Theme = newThemeName
            SaveConfig(savedConfig)

            for _, updater in ipairs(WindowObj.ThemeUpdaters) do
                updater(newC)
            end

            Library:Notify("ТЕМА ИЗМЕНЕНА", "Текущая тема: " .. newThemeName, 2)
        end
    end

    function WindowObj:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Name = tabName .. "_TabBtn"
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = C.Card
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = tabName
        TabBtn.TextColor3 = C.Text
        TabBtn.TextSize = 12
        TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabBtnStroke = Instance.new("UIStroke", TabBtn)
        TabBtnStroke.Color = C.Border
        TabBtnStroke.Thickness = 1

        local ContentFrame = Instance.new("ScrollingFrame", ContainerFolder)
        ContentFrame.Name = tabName .. "_Container"
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ContentFrame.ScrollBarThickness = 3
        ContentFrame.ScrollBarImageColor3 = C.Accent
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Visible = false

        local UIList = Instance.new("UIListLayout", ContentFrame)
        UIList.SortOrder, UIList.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 8)

        local TabObj = { Frame = ContentFrame }

        local function RefreshTabColors(theme)
            ContentFrame.ScrollBarImageColor3 = theme.Accent
            if WindowObj.ActiveTab == TabObj then
                TabBtn.BackgroundColor3 = theme.Accent
                TabBtnStroke.Color = theme.Accent
                TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TabBtn.BackgroundColor3 = theme.Card
                TabBtnStroke.Color = theme.Border
                TabBtn.TextColor3 = theme.Text
            end
        end

        WindowObj:RegisterThemeUpdater(RefreshTabColors)

        local function ActivateTab()
            for _, t in pairs(WindowObj.Tabs) do
                t.Frame.Visible = false
            end
            ContentFrame.Visible = true
            WindowObj.ActiveTab = TabObj
            
            for _, updater in ipairs(WindowObj.ThemeUpdaters) do
                updater(Library.CurrentTheme)
            end
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)
        table.insert(WindowObj.Tabs, { Btn = TabBtn, Frame = ContentFrame, Stroke = TabBtnStroke, TabObj = TabObj })

        if #WindowObj.Tabs == 1 then
            ActivateTab()
        end

        ----------------------------------------------------
        -- ЭЛЕМЕНТЫ ВКАДОК
        ----------------------------------------------------
        function TabObj:AddLabel(text, color)
            local Frame = Instance.new("Frame", ContentFrame)
            Frame.BackgroundTransparency, Frame.Size = 1, UDim2.new(1, 0, 0, 20)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.RichText, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, 0), Enum.Font.GothamBold, text, true, 12, Enum.TextXAlignment.Left

            WindowObj:RegisterThemeUpdater(function(theme)
                Label.TextColor3 = color or theme.Accent
            end)
        end

        function TabObj:AddButton(name, callback)
            local Button = Instance.new("TextButton", ContentFrame)
            Button.Size = UDim2.new(1, 0, 0, 36)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.GothamBold
            Button.Text = name
            Button.TextSize = 12
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Button)
            Stroke.Thickness = 1

            WindowObj:RegisterThemeUpdater(function(theme)
                Button.BackgroundColor3 = theme.Card
                Button.TextColor3 = theme.Text
                Stroke.Color = theme.Border
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
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local Stroke = Instance.new("UIStroke", Frame)
            Stroke.Thickness = 1

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(1, -55, 1, 0), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local SwitchBg = Instance.new("TextButton", Frame)
            SwitchBg.Text, SwitchBg.AutoButtonColor, SwitchBg.Position, SwitchBg.Size = "", false, UDim2.new(1, -44, 0.5, -9), UDim2.new(0, 34, 0, 18)
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame", SwitchBg)
            Circle.Size, Circle.Position, Circle.BackgroundColor3 = UDim2.new(0, 12, 0, 12), defaultState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local state = defaultState

            local function applyStateColors(theme)
                theme = theme or Library.CurrentTheme
                Frame.BackgroundColor3 = theme.Card
                Label.TextColor3 = theme.Text
                Circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                SwitchBg.BackgroundColor3 = state and theme.Accent or theme.Off
                Stroke.Color = state and theme.Accent or theme.Border
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

        function TabObj:AddInput(labelText, defaultText, callback)
            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local FrameStroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.Font.GothamMedium, labelText, 12, Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox", Frame)
            Box.Position, Box.Size, Box.Font, Box.Text, Box.TextSize, Box.ClearTextOnFocus = UDim2.new(0.5, 0, 0.5, -10), UDim2.new(0.5, -8, 0, 20), Enum.Font.GothamBold, defaultText, 11, false
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

            WindowObj:RegisterThemeUpdater(function(theme)
                Frame.BackgroundColor3 = theme.Card
                FrameStroke.Color = theme.Border
                Label.TextColor3 = theme.Text
                Box.BackgroundColor3 = theme.Input
                Box.TextColor3 = theme.Text
            end)

            Box.FocusLost:Connect(function() if callback then callback(Box.Text) end end)
        end

        function TabObj:AddDropdown(name, list, default, callback)
            list = list or {}
            local selected = default or list[1] or "Ничего"

            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.ClipsDescendants = true
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local FrameStroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(0.45, 0, 0, 36), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local DropBtn = Instance.new("TextButton", Frame)
            DropBtn.Position, DropBtn.Size, DropBtn.Font, DropBtn.Text, DropBtn.TextSize = UDim2.new(0.45, 0, 0, 7), UDim2.new(0.55, -6, 0, 22), Enum.Font.GothamBold, tostring(selected) .. "  ▼", 11
            DropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

            local DropHolder = Instance.new("ScrollingFrame", Frame)
            DropHolder.BackgroundTransparency, DropHolder.Position, DropHolder.Size = 1, UDim2.new(0, 6, 0, 36), UDim2.new(1, -12, 0, 0)
            DropHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
            DropHolder.ScrollBarThickness = 3
            DropHolder.BorderSizePixel = 0

            local ListLayout = Instance.new("UIListLayout", DropHolder)
            ListLayout.SortOrder, ListLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

            WindowObj:RegisterThemeUpdater(function(theme)
                Frame.BackgroundColor3 = theme.Card
                FrameStroke.Color = theme.Border
                Label.TextColor3 = theme.Text
                DropBtn.BackgroundColor3 = theme.Input
                DropBtn.TextColor3 = theme.Text
                DropHolder.ScrollBarImageColor3 = theme.Accent
            end)

            local isOpen = false
            local function toggleDrop()
                isOpen = not isOpen
                local targetHeight = math.min(#list * 26, 120)
                TS:Create(Frame, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, isOpen and (42 + targetHeight) or 36) }):Play()
                TS:Create(DropHolder, TweenInfo.new(0.15), { Size = UDim2.new(1, -12, 0, isOpen and targetHeight or 0) }):Play()
            end

            DropBtn.MouseButton1Click:Connect(toggleDrop)

            local function buildList(newList)
                list = newList or list
                for _, c in ipairs(DropHolder:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, option in ipairs(list) do
                    local Btn = Instance.new("TextButton", DropHolder)
                    Btn.Size, Btn.Font, Btn.Text, Btn.TextSize = UDim2.new(1, -6, 0, 22), Enum.Font.GothamMedium, tostring(option), 11
                    Btn.TextTruncate = Enum.TextTruncate.AtEnd
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                    WindowObj:RegisterThemeUpdater(function(theme)
                        Btn.BackgroundColor3 = theme.Input
                        Btn.TextColor3 = theme.Text
                    end)

                    Btn.MouseButton1Click:Connect(function()
                        selected = option
                        DropBtn.Text = tostring(selected) .. "  ▼"
                        toggleDrop()
                        if callback then callback(selected) end
                    end)
                end
            end

            buildList(list)

            return {
                Refresh = function(_, newList, newDefault)
                    buildList(newList)
                    if newDefault then
                        selected = newDefault
                        DropBtn.Text = tostring(selected) .. "  ▼"
                    end
                end
            }
        end

        function TabObj:AddMultiDropdown(name, list, callback)
            list = list or {}
            local selectedMap = {}

            local Frame = Instance.new("Frame", ContentFrame)
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.ClipsDescendants = true
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
            local FrameStroke = Instance.new("UIStroke", Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 10, 0, 0), UDim2.new(0.45, 0, 0, 36), Enum.Font.GothamMedium, name, 12, Enum.TextXAlignment.Left

            local DropBtn = Instance.new("TextButton", Frame)
            DropBtn.Position, DropBtn.Size, DropBtn.Font, DropBtn.Text, DropBtn.TextSize = UDim2.new(0.45, 0, 0, 7), UDim2.new(0.55, -6, 0, 22), Enum.Font.GothamBold, "Выбрано: 0  ▼", 11
            DropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

            local DropHolder = Instance.new("ScrollingFrame", Frame)
            DropHolder.BackgroundTransparency, DropHolder.Position, DropHolder.Size = 1, UDim2.new(0, 6, 0, 36), UDim2.new(1, -12, 0, 0)
            DropHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
            DropHolder.ScrollBarThickness = 3
            DropHolder.BorderSizePixel = 0

            local ListLayout = Instance.new("UIListLayout", DropHolder)
            ListLayout.SortOrder, ListLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

            WindowObj:RegisterThemeUpdater(function(theme)
                Frame.BackgroundColor3 = theme.Card
                FrameStroke.Color = theme.Border
                Label.TextColor3 = theme.Text
                DropBtn.BackgroundColor3 = theme.Input
                DropBtn.TextColor3 = theme.Text
                DropHolder.ScrollBarImageColor3 = theme.Accent
            end)

            local isOpen = false
            local function toggleDrop()
                isOpen = not isOpen
                local targetHeight = math.min(#list * 26, 120)
                TS:Create(Frame, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, isOpen and (42 + targetHeight) or 36) }):Play()
                TS:Create(DropHolder, TweenInfo.new(0.15), { Size = UDim2.new(1, -12, 0, isOpen and targetHeight or 0) }):Play()
            end

            DropBtn.MouseButton1Click:Connect(toggleDrop)

            local function updateTitle()
                local count = 0
                for _ in pairs(selectedMap) do count = count + 1 end
                DropBtn.Text = "Выбрано: " .. tostring(count) .. "  ▼"
            end

            local function buildList(newList)
                list = newList or list
                for _, c in ipairs(DropHolder:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, option in ipairs(list) do
                    local Btn = Instance.new("TextButton", DropHolder)
                    Btn.Size, Btn.Font, Btn.Text, Btn.TextSize = UDim2.new(1, -6, 0, 22), Enum.Font.GothamMedium, tostring(option), 11
                    Btn.TextTruncate = Enum.TextTruncate.AtEnd
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                    local function applyBtnColor(theme)
                        theme = theme or Library.CurrentTheme
                        Btn.BackgroundColor3 = selectedMap[option] and theme.Accent or theme.Input
                        Btn.TextColor3 = theme.Text
                    end

                    WindowObj:RegisterThemeUpdater(applyBtnColor)

                    Btn.MouseButton1Click:Connect(function()
                        if selectedMap[option] then
                            selectedMap[option] = nil
                        else
                            selectedMap[option] = true
                        end
                        applyBtnColor(Library.CurrentTheme)
                        updateTitle()
                        if callback then callback(selectedMap) end
                    end)
                end
                updateTitle()
            end

            buildList(list)

            return { Refresh = function(_, newList) buildList(newList) end }
        end

        return TabObj
    end

    return WindowObj
end

return Library
