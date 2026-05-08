-- [[ УПРОЩЕННАЯ ЗАГРУЗКА ]]
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("Rayfield не загрузился! Проверь интернет или инжектор.")
    return
end

-- [[ НАСТРОЙКИ KEYAUTH ]]
local KeyAuth_Settings = {
    ApplicationName = "Dungeon Leveling Origin",
    OwnerID = "m2dvuf0xQy",
    ApplicationSecret = "e75c1fe66a123dbce41e9728f6d7f02b34e8c8575ea5db688bd50a6d3c446597",
    Version = "1.0"
}

-- [[ ОКНО АВТОРИЗАЦИИ ]]
local KeyWindow = Rayfield:CreateWindow({
    Name = "KeyAuth | Dungeon Origin",
    LoadingTitle = "Подключение...",
    LoadingSubtitle = "by by PEP0.2",
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
        -- Отправляем запрос на сервер KeyAuth для проверки и активации ключа
        local is_valid, msg = KeyAuthApp:license(EnteredKey)
        
        if is_valid then
            Rayfield:Notify({Title = "Успех!", Content = "Ключ активирован!", Duration = 3})
            task.wait(1)
            Rayfield:Destroy()
            task.wait(0.5)
            StartCheatMenu() -- Запускаем основной чит
        else
            -- Если ключ неверный или уже использован другим человеком
            Rayfield:Notify({Title = "Ошибка", Content = "Статус: " .. tostring(msg), Duration = 5})
        end
    end,
})

-- [[ ТВОЙ ОСНОВНОЙ ЧИТ ]]
function StartCheatMenu()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Dungeon Origin | By PEP-0.2",
    LoadingTitle = "Пизда же есть...",
    LoadingSubtitle = "by PEP0.2",
    ConfigurationSaving = { Enabled = true, Folder = "DungeonCollector" }
})

local Tab = Window:CreateTab("Главная", 4483362458)

local Config = {
    ChestESP = true, MobESP = true, RubyESP = true,
    Hitboxes = true, HitboxSize = 27, Transparency = 0.8,
    -- Бой
    AutoAttack = false,
    AttackBind = Enum.KeyCode.R,
    UseAttackSpeed = false,
    AttackSpeedMod = 5,
    NoSlowdown = false,
    InfJump = false,
    JumpPower = 45,
    AttackRange = 28
}

-- [ТВОЯ ESP ФУНКЦИЯ]
local function ApplyLockedESP(parentPart, text, color, category)
    if not parentPart or not parentPart:IsDescendantOf(workspace) then return end
    local tag = parentPart:FindFirstChild("DungeonTag")
    if not tag then
        tag = Instance.new("BillboardGui", parentPart)
        tag.Name = "DungeonTag"
        tag.AlwaysOnTop = true
        tag.Size = UDim2.new(0, 150, 0, 50)
        tag.ExtentsOffset = Vector3.new(0, 2.5, 0)
        local label = Instance.new("TextLabel", tag)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Text = text
        label.TextColor3 = color
        label.Name = "TextLabel"
    else
        local label = tag:FindFirstChild("TextLabel")
        if label then label.Text = text; label.TextColor3 = color end
    end
end

-- [АНТИ-ЗАМЕДЛЕНИЕ]
local mt = getrawmetatable(game)
local old_newindex = mt.__newindex
setreadonly(mt, false)
mt.__newindex = newcclosure(function(t, k, v)
    if not checkcaller() and k == "WalkSpeed" and Config.NoSlowdown and v < 15.8 then
        return old_newindex(t, k, 15.84)
    end
    return old_newindex(t, k, v)
end)
setreadonly(mt, true)

-- [ЭЛЕМЕНТЫ МЕНЮ]
local AutoAttackToggle = Tab:CreateToggle({
    Name = "Авто-Атака (Клавиша R)", 
    CurrentValue = false, 
    Callback = function(v) 
        Config.AutoAttack = v 
    end
})

-- [БИНДЫ (ТВОЯ РАБОЧАЯ ЛОГИКА)]
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Config.AttackBind then
        Config.AutoAttack = not Config.AutoAttack
        -- Вот это заставит тумблер в меню переключиться:
        AutoAttackToggle:Set(Config.AutoAttack) 
        
        Rayfield:Notify({
            Title = "Auto-Attack", 
            Content = Config.AutoAttack and "ВКЛЮЧЕН" or "ВЫКЛЮЧЕН", 
            Duration = 2
        })
    end
end)

-- [ПРЫЖКИ]
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Config.InfJump then
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, Config.JumpPower, hrp.Velocity.Z) end
    end
end)

-- [КЛИКЕР (ТВОЯ ЛОГИКА + АТРИБУТЫ)]
task.spawn(function()
    local VIM = game:GetService("VirtualInputManager")
    while true do
        task.wait(0.01)
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        
        if char then
            -- СКОРОСТЬ АТАКИ И ЕЕ СБРОС
            if Config.UseAttackSpeed then
                char:SetAttribute("AttackSpeed", Config.AttackSpeedMod)
            else
                -- Если тумблер выключен, ставим стандарт 1.0 (или 1.5 по желанию)
                if char:GetAttribute("AttackSpeed") ~= 1.0 then
                    char:SetAttribute("AttackSpeed", 1.0)
                end
            end

            -- АВТО-АТАКА
            if Config.AutoAttack then
                if char:FindFirstChild("HumanoidRootPart") then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 then
                            local hrp = obj.Parent:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (char.HumanoidRootPart.Position - hrp.Position).Magnitude
                                if dist <= Config.AttackRange then
                                    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                    task.wait(0.01)
                                    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [ESP И ХИТБОКСЫ (ТВОЙ ОРИГИНАЛ)]
task.spawn(function()
    while task.wait(0.5) do
        local char = game.Players.LocalPlayer.Character
        if not char then continue end
        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(function()
                if Config.ChestESP and obj:IsA("Model") and (string.find(obj.Name, "Chest") or string.find(obj.Name, "Box")) then
                    local cp = obj:FindFirstChild("Main") or obj:FindFirstChild("Up", true) or obj:FindFirstChildOfClass("BasePart")
                    if cp then ApplyLockedESP(obj.PrimaryPart or cp, "🎁 СУНДУК", cp.Color, "Chest") end
                end
                if Config.MobESP and obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 then
                    local hrp = obj.Parent:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if Config.Hitboxes then
                            hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                            hrp.Transparency = Config.Transparency
                            hrp.CanCollide = false
                        else
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                        end
                    end
                    if obj.Parent:FindFirstChild("Head") then ApplyLockedESP(obj.Parent.Head, obj.Parent.Name, Color3.fromRGB(255, 255, 255), "Mob") end
                end
            end)
        end
    end
end)

-- [МЕНЮ - ВИЗУАЛЫ]
Tab:CreateSlider({Name = "Размер хитбокса", Range = {2, 100}, Increment = 1, CurrentValue = 27, Callback = function(v) Config.HitboxSize = v end})
Tab:CreateSlider({Name = "Прозрачность кубов", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.8, Callback = function(v) Config.Transparency = v end})
Tab:CreateToggle({Name = "ВХ на Сундуки", CurrentValue = true, Callback = function(v) Config.ChestESP = v end})
Tab:CreateToggle({Name = "ВХ на Монстров", CurrentValue = true, Callback = function(v) Config.MobESP = v end})

-- [МЕНЮ - БОЙ]
Tab:CreateSection("Боевые настройки")
Tab:CreateKeybind({
    Name = "Изменить Бинд",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function(Key) Config.AttackBind = Key end,
})
Tab:CreateToggle({Name = "Включить множитель скорости", CurrentValue = false, Callback = function(v) Config.UseAttackSpeed = v end})
Tab:CreateSlider({Name = "Скорость Атаки (Attr)", Range = {1, 30}, Increment = 0.5, CurrentValue = 5, Callback = function(v) Config.AttackSpeedMod = v end})
Tab:CreateToggle({Name = "Анти-Замедление (NoSlow)", CurrentValue = false, Callback = function(v) Config.NoSlowdown = v end})
Tab:CreateToggle({Name = "Бесконечные Прыжки", CurrentValue = false, Callback = function(v) Config.InfJump = v end})
Tab:CreateSlider({Name = "Сила Прыжка", Range = {20, 150}, Increment = 1, CurrentValue = 45, Callback = function(v) Config.JumpPower = v end})
    print("Чит успешно запущен после проверки ключа!")
end -- ЗАКРЫВАЕТ ФУНКЦИЮ StartCheatMenu
