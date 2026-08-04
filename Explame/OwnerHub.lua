-- ========================================================
--    ШПОРА / QUICK REFERENCE: OWNER HUB GUI LIBRARY v5.1
-- ========================================================

-- 1. ИНИЦИАЛИЗАЦИЯ И СОЗДАНИЕ ОКНА
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Maks14a/GUIs/refs/heads/main/Library/test.lua"))()
local Window = Library:CreateWindow("OWNER HUB")

-- 2. СОЗДАНИЕ ОБЫЧНЫХ ВКЛАДОК
local MainTab  = Window:CreateTab("Main")
local FarmTab  = Window:CreateTab("Farm")

-- 3. СОЗДАНИЕ СТАНДАРТНОЙ ВКЛАДКИ НАСТРОЕК (Создавать 1 вызовом в конце)
-- Автоматически добавляет: Тему + Сохранение темы, Анти-АФК, Выключение 3D-Рендера
Window:CreateSettingsTab()


-- ========================================================
-- 4. ШПАРОГАЛКА ПО КОМПОНЕНТАМ И ЭЛЕМЕНТАМ (ВКЛАДКА)
-- ========================================================

--- [ Разделитель / Секция ]
MainTab:AddSection("Заголовок Секции")

--- [ Текстовая Надпись (Label) ]
-- Поддерживает RichText (HTML теги: color, b, i и т.д.)
MainTab:AddLabel("Простая надпись")
MainTab:AddLabel("Цветной текст: <font color='#00FF00'>АКТИВНО</font>")

--- [ Кнопка (Button) ]
MainTab:AddButton("Активировать", function()
    print("Кнопка была нажата!")
end)

--- [ Переключатель (Toggle) ]
-- Аргументы: (Название, НачальноеСостояние, Callback)
local MyToggle = MainTab:AddToggle("Авто-Фарм", false, function(state)
    print("Состояние переключателя:", state) -- returns true или false
end)
-- Изменить состояние через код: MyToggle:Set(true)

--- [ Ползунок (Slider) ]
-- Аргументы: (Название, Мин, Макс, ПоУмолчанию, Шаг, Callback)
MainTab:AddSlider("Скорость бега", 16, 250, 16, 1, function(value)
    print("Выбрано значение:", value)
end)

--- [ Поле Ввода (Input) ]
-- Аргументы: (Название, ТекстПоУмолчанию, Callback)
MainTab:AddInput("Имя игрока", "Player1", function(text)
    print("Введенный текст:", text)
end)

--- [ Одиночный Выпадающий Список (Dropdown) ]
-- Аргументы: (Название, СписокВариантов, ВыбранныйПоУмолчанию, Callback)
local Drop = MainTab:AddDropdown("Локация", {"Спавн", "Лес", "Пещера"}, "Спавн", function(selected)
    print("Выбрана локация:", selected)
end)
-- Динамическое обновление списка из кода:
-- Drop:Refresh({"НоваяЛокация1", "НоваяЛокация2"}, "НоваяЛокация1")

--- [ Множественный Выпадающий Список (MultiDropdown) ]
-- Аргументы: (Название, СписокВариантов, Callback)
local MultiDrop = MainTab:AddMultiDropdown("Выбор предметов", {"Меч", "Щит", "Зелье"}, function(selectedMap)
    -- selectedMap возвращает таблицу вида { ["Меч"] = true, ["Зелье"] = true }
    for item, state in pairs(selectedMap) do
        print("Выбран предмет:", item)
    end
end)
-- Динамическое обновление списка из кода:
-- MultiDrop:Refresh({"Предмет1", "Предмет2"})

--- [ Назначение Клавиши (Keybind) ]
-- Аргументы: (Название, КлавишаПоУмолчанию, Callback)
MainTab:AddKeybind("Активация боя", Enum.KeyCode.E, function(key)
    print("Нажата назначена клавиша:", key.Name)
end)

-- ЦИКЛИЧНЫЙ КЕЙБИНД (Выполняется по кругу, пока зажата клавиша)
-- Параметры: Имя, Клавиша по умолч., Интервал цикла (сек), Функция в цикле, (Опционально: При смене кнопки)
MainTab:AddHoldKeybind("Авто-Атака (Зажатие)", Enum.KeyCode.F, 0.1, function()
    print("⚔️ Выполняю удар/действие в цикле...")
end, function(newKey)
    print("Клавиша авто-атаки изменена на:", newKey.Name)
end)


-- КЕЙБИНД ЗАЖАЛ / ОТПУСТИЛ (Скрипт A при нажатии, Скрипт B при отпускании)
-- Параметры: Имя, Клавиша по умолч., Функция Зажал (A), Функция Отпустил (B), (Опционально: При смене кнопки)
MainTab:AddPressReleaseKeybind("Ускорение (Shift)", Enum.KeyCode.LeftShift, function()
    -- Скрипт A (Когда ЗАЖАЛ):
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
    Library:Notify("СПРИНТ", "Ускорение включено!", 1)
end, function()
    -- Скрипт B (Когда ОТПУСТИЛ):
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    Library:Notify("СПРИНТ", "Ускорение выключено.", 1)
end)

-- МультиКейбинд
-- Параметры:
-- 1. Имя
-- 2. Клавиша по умолчанию
-- 3. Задержка цикла (в секундах)
-- 4. Функция A (НАЖАЛ — Мгновенный старт)
-- 5. Функция B (ДЕРЖИШЬ — Циклический скрипт)
-- 6. Функция C (ОТПУСТИЛ — Финал/Сброс)
-- 7. (Опционально) Функция при смене клавиши

MainTab:AddHoldPressReleaseKeybind(
    "Зарядная пушка (Комбо)", 
    Enum.KeyCode.G, 
    0.2, -- Задержка цикла удержания

    -- 🔴 Скрипт A: Мгновенно при НАЖАТИИ
    function()
        print("⚡ [A] Начат заряд энергии! Включаем звук/анимацию...")
        Library:Notify("ЗАРЯДКА", "Зарядка началась!", 1)
    end,

    -- 🟡 Скрипт B: В ЦИКЛЕ, пока клавиша зажата
    function()
        print("🔥 [B] Накапливаем +10 энергии в цикле...")
    end,

    -- 🟢 Скрипт C: Мгновенно при ОТПУСКАНИИ
    function()
        print("💥 [C] ВЫСТРЕЛ! Сбрасываем заряд.")
        Library:Notify("ВЫСТРЕЛ", "Заряд выпущен!", 1)
    end,

    -- При смене кнопки
    function(newKey)
        print("Бинд изменен на:", newKey.Name)
    end
)

-- ========================================================
-- 5. ВСПОМОГАТЕЛЬНЫЕ И ГЛОБАЛЬНЫЕ ФУНКЦИИ
-- ========================================================

--- [ Всплывающее Уведомление (Notification) ]
-- Аргументы: (Заголовок, Сообщение, ДлительностьСекунд)
Library:Notify("УСПЕХ", "Скрипт успешно подключен!", 3)

--- [ Программная смена темы ]
-- Доступные темы: "Emerald", "Ruby", "Sapphire", "Amethyst", "Amber" Важно это не обезательно использовать у нас есть все это в Window:CreateSettingsTab()
Window:SetTheme("Sapphire")
