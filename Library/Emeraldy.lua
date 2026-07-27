-- ========================================================
--             OWNER HUB GUI LIBRARY v3.5 (EMERALD)
-- ========================================================
local Library = {}

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

function Library:CreateWindow(hubTitle)
    if game:GetService("CoreGui"):FindFirstChild("OwnerHub_Core") then
        game:GetService("CoreGui").OwnerHub_Core:Destroy()
    end

    local C_BG = Color3.fromRGB(15, 17, 21)
    local C_CARD = Color3.fromRGB(24, 27, 34)
    local C_INPUT = Color3.fromRGB(33, 37, 47)
    local C_ACCENT = Color3.fromRGB(16, 185, 129)
    local C_RED = Color3.fromRGB(220, 38, 38)
    local C_OFF = Color3.fromRGB(42, 47, 60)
    local C_TEXT = Color3.fromRGB(240, 242, 245)
    local C_BORDER = Color3.fromRGB(45, 52, 65)

    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name, ScreenGui.ResetOnSpawn = "OwnerHub_Core", false

    local MainFrame = Instance.new("CanvasGroup", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = C_BG
    MainFrame.Position = UDim2.new(0.08, 0, 0.2, 0)
    MainFrame.Size = UDim2.new(0, 270, 0, 520)
    MainFrame.ClipsDescendants = true
    MainFrame.GroupTransparency = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color, MainStroke.Thickness, MainStroke.Transparency = C_ACCENT, 1.5, 0.3

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

    -- Анимация скрытия/открытия (RightControl)
    local guiVisible, isAnimating = true, false
    UIS.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightControl then
            if isAnimating then return end
            guiVisible = not guiVisible
            isAnimating = true

            if guiVisible then
                MainFrame.Visible = true
                TS:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                local t = TS:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0})
                t:Play()
                t.Completed:Connect(function() isAnimating = false end)
            else
                TS:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85}):Play()
                local t = TS:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1})
                t:Play()
                t.Completed:Connect(function()
                    if not guiVisible then MainFrame.Visible = false end
                    isAnimating = false
                end)
            end
        end
    end)

    -- Шапка
    local Header = Instance.new("Frame", MainFrame)
    Header.BackgroundTransparency, Header.Size = 1, UDim2.new(1, 0, 0, 45)
    local Title = Instance.new("TextLabel", Header)
    Title.BackgroundTransparency, Title.Position, Title.Size, Title.Font, Title.Text, Title.RichText, Title.TextColor3, Title.TextSize, Title.TextXAlignment = 1, UDim2.new(0, 16, 0, 0), UDim2.new(1, -32, 1, 0), Enum.Font.GothamBold, hubTitle or "OWNER HUB", true, C_TEXT, 16, Enum.TextXAlignment.Left

    -- Контейнер
    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.BackgroundTransparency, Container.Position, Container.Size = 1, UDim2.new(0, 12, 0, 50), UDim2.new(1, -24, 1, -55)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.ScrollBarThickness = 4
    Container.ScrollBarImageColor3 = C_ACCENT
    Container.BorderSizePixel = 0

    local UIList = Instance.new("UIListLayout", Container)
    UIList.SortOrder, UIList.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 8)

    local WindowObj = { Container = Container }

    -- Заголовок / Метка
    function WindowObj:AddLabel(text, color)
        local Frame = Instance.new("Frame", Container)
        Frame.BackgroundTransparency, Frame.Size = 1, UDim2.new(1, 0, 0, 20)

        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.RichText, Label.TextColor3, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, 0), Enum.Font.GothamBold, text, true, color or C_ACCENT, 13, Enum.TextXAlignment.Left
    end

    -- Переключатель (Toggle)
    function WindowObj:AddToggle(name, defaultState, callback)
        local Frame = Instance.new("Frame", Container)
        Frame.BackgroundColor3, Frame.Size = C_CARD, UDim2.new(1, 0, 0, 38)
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        
        local Stroke = Instance.new("UIStroke", Frame)
        Stroke.Color, Stroke.Thickness = defaultState and C_ACCENT or C_BORDER, 1

        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextColor3, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 12, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.GothamMedium, name, C_TEXT, 13, Enum.TextXAlignment.Left

        local SwitchBg = Instance.new("TextButton", Frame)
        SwitchBg.Text, SwitchBg.AutoButtonColor, SwitchBg.Position, SwitchBg.Size, SwitchBg.BackgroundColor3 = "", false, UDim2.new(1, -48, 0.5, -10), UDim2.new(0, 36, 0, 20), defaultState and C_ACCENT or C_OFF
        Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame", SwitchBg)
        Circle.Size, Circle.Position, Circle.BackgroundColor3 = UDim2.new(0, 14, 0, 14), defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local state = defaultState
        SwitchBg.MouseButton1Click:Connect(function()
            state = not state
            TS:Create(Circle, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
            TS:Create(SwitchBg, TweenInfo.new(0.15), {BackgroundColor3 = state and C_ACCENT or C_OFF}):Play()
            TS:Create(Stroke, TweenInfo.new(0.15), {Color = state and C_ACCENT or C_BORDER}):Play()
            if callback then callback(state) end
        end)
    end

    -- КНОПКА-ТОГГЛЕР
    function WindowObj:AddButtonToggle(name, defaultState, callback)
        local Button = Instance.new("TextButton", Container)
        Button.Name = name .. "_ButtonToggle"
        Button.Size = UDim2.new(1, 0, 0, 38)
        Button.BackgroundColor3 = defaultState and C_ACCENT or C_RED
        Button.AutoButtonColor = false
        Button.Font = Enum.Font.GothamBold
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 13

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
        local Stroke = Instance.new("UIStroke", Button)
        Stroke.Color = defaultState and Color3.fromRGB(10, 140, 95) or Color3.fromRGB(160, 20, 20)
        Stroke.Thickness = 1.2

        local state = defaultState
        Button.MouseButton1Click:Connect(function()
            state = not state
            TS:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = state and C_ACCENT or C_RED }):Play()
            TS:Create(Stroke, TweenInfo.new(0.15), { Color = state and Color3.fromRGB(10, 140, 95) or Color3.fromRGB(160, 20, 20) }):Play()
            if callback then callback(state) end
        end)
    end

    -- Поле ввода
    function WindowObj:AddInput(labelText, defaultText, callback)
        local Frame = Instance.new("Frame", Container)
        Frame.BackgroundColor3, Frame.Size = C_CARD, UDim2.new(1, 0, 0, 38)
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", Frame).Color = C_BORDER

        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextColor3, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 12, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.Font.GothamMedium, labelText, C_TEXT, 13, Enum.TextXAlignment.Left

        local Box = Instance.new("TextBox", Frame)
        Box.BackgroundColor3, Box.Position, Box.Size, Box.Font, Box.Text, Box.TextColor3, Box.TextSize, Box.ClearTextOnFocus = C_INPUT, UDim2.new(0.5, 0, 0.5, -11), UDim2.new(0.5, -10, 0, 22), Enum.Font.GothamBold, defaultText, C_TEXT, 12, false
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
        Box.FocusLost:Connect(function() if callback then callback(Box.Text) end end)
    end

    -- ОДИНОЧНЫЙ ДРОПДАУН (SINGLE-SELECT)
    function WindowObj:AddDropdown(name, list, default, callback)
        list = list or {}
        local selected = default or list[1] or "Ничего"

        local Frame = Instance.new("Frame", Container)
        Frame.BackgroundColor3, Frame.Size = C_CARD, UDim2.new(1, 0, 0, 38)
        Frame.ClipsDescendants = true
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        local Stroke = Instance.new("UIStroke", Frame)
        Stroke.Color = C_BORDER

        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextColor3, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 12, 0, 0), UDim2.new(0.45, 0, 0, 38), Enum.Font.GothamMedium, name, C_TEXT, 13, Enum.TextXAlignment.Left

        local DropBtn = Instance.new("TextButton", Frame)
        DropBtn.BackgroundColor3, DropBtn.Position, DropBtn.Size, DropBtn.Font, DropBtn.Text, DropBtn.TextColor3, DropBtn.TextSize = C_INPUT, UDim2.new(0.45, 0, 0, 8), UDim2.new(0.55, -8, 0, 22), Enum.Font.GothamBold, tostring(selected) .. "  ▼", C_TEXT, 11
        DropBtn.TextTruncate = Enum.TextTruncate.AtEnd
        Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

        local DropHolder = Instance.new("ScrollingFrame", Frame)
        DropHolder.BackgroundTransparency, DropHolder.Position, DropHolder.Size = 1, UDim2.new(0, 8, 0, 38), UDim2.new(1, -16, 0, 0)
        DropHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
        DropHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
        DropHolder.ScrollBarThickness = 3
        DropHolder.ScrollBarImageColor3 = C_ACCENT
        DropHolder.BorderSizePixel = 0

        local ListLayout = Instance.new("UIListLayout", DropHolder)
        ListLayout.SortOrder, ListLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

        local isOpen = false
        local function toggleDrop()
            isOpen = not isOpen
            local targetHeight = math.min(#list * 26, 120)
            TS:Create(Frame, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, isOpen and (44 + targetHeight) or 38) }):Play()
            TS:Create(DropHolder, TweenInfo.new(0.15), { Size = UDim2.new(1, -16, 0, isOpen and targetHeight or 0) }):Play()
        end

        DropBtn.MouseButton1Click:Connect(toggleDrop)

        local function buildList(newList)
            list = newList or list
            for _, c in ipairs(DropHolder:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for _, option in ipairs(list) do
                local Btn = Instance.new("TextButton", DropHolder)
                Btn.BackgroundColor3, Btn.Size, Btn.Font, Btn.Text, Btn.TextColor3, Btn.TextSize = C_INPUT, UDim2.new(1, -6, 0, 22), Enum.Font.GothamMedium, tostring(option), C_TEXT, 11
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

        local DropObj = {}
        function DropObj:Refresh(newList, newDefault)
            buildList(newList)
            if newDefault then
                selected = newDefault
                DropBtn.Text = tostring(selected) .. "  ▼"
            end
        end

        return DropObj
    end

    -- МНОГОПОЛЬЗОВАТЕЛЬСКИЙ ДРОПДАУН (МУЛЬТИ-ВЫБОР)
    function WindowObj:AddMultiDropdown(name, list, callback)
        list = list or {}
        local selectedMap = {}

        local Frame = Instance.new("Frame", Container)
        Frame.BackgroundColor3, Frame.Size = C_CARD, UDim2.new(1, 0, 0, 38)
        Frame.ClipsDescendants = true
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
        local Stroke = Instance.new("UIStroke", Frame)
        Stroke.Color = C_BORDER

        local Label = Instance.new("TextLabel", Frame)
        Label.BackgroundTransparency, Label.Position, Label.Size, Label.Font, Label.Text, Label.TextColor3, Label.TextSize, Label.TextXAlignment = 1, UDim2.new(0, 12, 0, 0), UDim2.new(0.45, 0, 0, 38), Enum.Font.GothamMedium, name, C_TEXT, 13, Enum.TextXAlignment.Left

        local DropBtn = Instance.new("TextButton", Frame)
        DropBtn.BackgroundColor3, DropBtn.Position, DropBtn.Size, DropBtn.Font, DropBtn.Text, DropBtn.TextColor3, DropBtn.TextSize = C_INPUT, UDim2.new(0.45, 0, 0, 8), UDim2.new(0.55, -8, 0, 22), Enum.Font.GothamBold, "Выбрано: 0  ▼", C_TEXT, 11
        DropBtn.TextTruncate = Enum.TextTruncate.AtEnd
        Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

        local DropHolder = Instance.new("ScrollingFrame", Frame)
        DropHolder.BackgroundTransparency, DropHolder.Position, DropHolder.Size = 1, UDim2.new(0, 8, 0, 38), UDim2.new(1, -16, 0, 0)
        DropHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
        DropHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
        DropHolder.ScrollBarThickness = 3
        DropHolder.ScrollBarImageColor3 = C_ACCENT
        DropHolder.BorderSizePixel = 0

        local ListLayout = Instance.new("UIListLayout", DropHolder)
        ListLayout.SortOrder, ListLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

        local isOpen = false
        local function toggleDrop()
            isOpen = not isOpen
            local targetHeight = math.min(#list * 26, 120)
            TS:Create(Frame, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, isOpen and (44 + targetHeight) or 38) }):Play()
            TS:Create(DropHolder, TweenInfo.new(0.15), { Size = UDim2.new(1, -16, 0, isOpen and targetHeight or 0) }):Play()
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
                local isSelected = selectedMap[option] or false
                local Btn = Instance.new("TextButton", DropHolder)
                Btn.BackgroundColor3 = isSelected and C_ACCENT or C_INPUT
                Btn.Size, Btn.Font, Btn.Text, Btn.TextColor3, Btn.TextSize = UDim2.new(1, -6, 0, 22), Enum.Font.GothamMedium, (isSelected and "[✓] " or "[ ] ") .. tostring(option), C_TEXT, 11
                Btn.TextTruncate = Enum.TextTruncate.AtEnd
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                Btn.MouseButton1Click:Connect(function()
                    if selectedMap[option] then
                        selectedMap[option] = nil
                        Btn.BackgroundColor3 = C_INPUT
                        Btn.Text = "[ ] " .. tostring(option)
                    else
                        selectedMap[option] = true
                        Btn.BackgroundColor3 = C_ACCENT
                        Btn.Text = "[✓] " .. tostring(option)
                    end
                    updateTitle()
                    if callback then callback(selectedMap) end
                end)
            end
            updateTitle()
        end

        buildList(list)

        local DropObj = {}
        function DropObj:Refresh(newList)
            buildList(newList)
        end

        return DropObj
    end

    return WindowObj
end

return Library
