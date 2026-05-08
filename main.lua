-- [[ ЗАГРУЗКА БИБЛИОТЕКИ С ПРОВЕРКОЙ ]]
local KeyAuthApp
local success, err = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/KeyAuth/KeyAuth-Lua-Example/main/KeyAuth.lua"))()
end)

if success and err then
    KeyAuthApp = err
else
    warn("Ошибка загрузки KeyAuth: " .. tostring(err))
end

-- [[ НАСТРОЙКИ ]]
local KeyAuth_Settings = {
    ApplicationName = "Dungeon Leveling Origin",
    OwnerID = "m2dvuf0xQy",
    ApplicationSecret = "e75c1fe66a123dbce41e9728f6d7f02b34e8c8575ea5db688bd50a6d3c446597",
    Version = "1.0"
}

-- Инициализация
if KeyAuthApp then
    KeyAuthApp:init(KeyAuth_Settings.ApplicationName, KeyAuth_Settings.OwnerID, KeyAuth_Settings.ApplicationSecret, KeyAuth_Settings.Version)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ ОКНО АВТОРИЗАЦИИ ]]
local KeyWindow = Rayfield:CreateWindow({
    Name = "KeyAuth Что-бы не втыкали | Dungeon Origin",
    LoadingTitle = "Подключение к серверам...",
    LoadingSubtitle = "by PEP-0.1",
    ConfigurationSaving = { Enabled = false }
})

local AuthTab = KeyWindow:CreateTab("Вход", 4483362458)
local EnteredKey = ""

AuthTab:CreateInput({
    Name = "Лицензионный ключ",
    PlaceholderText = "Вставь ключ сюда...",
    Callback = function(Text) EnteredKey = Text end,
})

AuthTab:CreateButton({
    Name = "Активировать",
    Callback = function()
        if not KeyAuthApp then
            Rayfield:Notify({Title = "Ошибка", Content = "Библиотека KeyAuth не загружена!", Duration = 5})
            return
        end

        -- Проверка ключа
        local is_valid = KeyAuthApp:license(EnteredKey)
        
        if is_valid then
            Rayfield:Notify({Title = "Успех!", Content = "Лицензия подтверждена!", Duration = 3})
            
            task.wait(1)
            Rayfield:Destroy() -- Закрываем окно ключа
            
            task.wait(0.5)
            StartCheatMenu() -- Запускаем основной чит
        else
            Rayfield:Notify({Title = "Ошибка", Content = "Неверный ключ или время истекло!", Duration = 3})
        end
    end,
})

-- [[ ТВОЙ ОСНОВНОЙ СКРИПТ (СУДА ПЕРЕНЕСИ СВОЕ МЕНЮ) ]]
function StartCheatMenu()
    local MainRayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = MainRayfield:CreateWindow({
        Name = "Dungeon Origin | ГЛАВНОЕ МЕНЮ",
        LoadingTitle = "Загрузка чита...",
        LoadingSubtitle = "by PEP0.2",
        ConfigurationSaving = { Enabled = true, Folder = "DungeonCollector" }
    })

    local Tab = Window:CreateTab("Главная", 4483362458)
    
    Rayfield:Notify({
        Title = "Готово!",
        Content = "Приятной игры, чит активирован.",
        Duration = 5
    })

    -- Тут дальше вставляй все свои Toggles, Sliders и прочую логику, которую мы писали в начале
    print("Чит успешно запущен после проверки ключа!")
end
