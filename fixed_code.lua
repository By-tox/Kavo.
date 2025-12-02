--============================================================--
-- //                 Manus UI Library (v2.3)                  //
-- //       (تم إصلاح StatusLabel ودعم التخطيطات المرنة)       //
-- //============================================================--

local Library = {}
Library.__index = Library

-- خدمات اللعبة الرئيسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- دالة داخلية لجعل الواجهات قابلة للسحب
local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            local conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- الدالة الرئيسية لإنشاء النافذة
function Library.new(title, subtitle)
    local self = setmetatable({}, Library)
    self.ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    self.ScreenGui.Name = "Manus_UI_v2.3_Fixed"
    self.ScreenGui.ResetOnSpawn = false

    -- زر الفتح (Image Button)
    self.OpenButton = Instance.new("ImageButton", self.ScreenGui)
    self.OpenButton.Size = UDim2.new(0, 60, 0, 60) -- اكبر شوي
    self.OpenButton.Position = UDim2.new(0, 20, 0.5, -32)
    self.OpenButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    self.OpenButton.BackgroundTransparency = 0.15
    self.OpenButton.Image = "rbxthumb://type=Asset&id=93144039493714&w=420&h=420"

    -- Rounded
    local corner = Instance.new("UICorner", self.OpenButton)
    corner.CornerRadius = UDim.new(1, 0)

    -- Stroke (Outline)
    -- لم يتم إضافة Stroke هنا، يمكن إضافته باستخدام UIStroke إذا لزم الأمر

    -- Draggable
    makeDraggable(self.OpenButton)

    -- النافذة الرئيسية
    self.Window = Instance.new("Frame", self.ScreenGui)
    self.Window.Size = UDim2.new(0, 200, 0, 60) -- حجم مبدئي
    self.Window.Position = UDim2.new(0.5, -100, 0.5, -30)
    self.Window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.Window.BackgroundTransparency = 0.15
    self.Window.Visible = false
    Instance.new("UICorner", self.Window).CornerRadius = UDim.new(0, 14)
    local windowStroke = Instance.new("UIStroke", self.Window)
    windowStroke.Thickness, windowStroke.Color = 3, Color3.fromRGB(139, 0, 0)
    makeDraggable(self.Window)

    self.OpenButton.MouseButton1Click:Connect(function() self.Window.Visible = not self.Window.Visible end)

    -- العناوين
    local titleLabel = Instance.new("TextLabel", self.Window)
    titleLabel.Size, titleLabel.Text, titleLabel.TextColor3, titleLabel.Font, titleLabel.TextSize, titleLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 22), title or "Manus UI", Color3.fromRGB(139, 0, 0), Enum.Font.Arcade, 15, 1
    local subtitleLabel = Instance.new("TextLabel", self.Window)
    subtitleLabel.Size, subtitleLabel.Position, subtitleLabel.Text, subtitleLabel.TextColor3, subtitleLabel.Font, subtitleLabel.TextSize, subtitleLabel.BackgroundTransparency, subtitleLabel.TextXAlignment = UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 0, 22), subtitle or "github.com/manus", Color3.fromRGB(255, 255, 255), Enum.Font.Arcade, 12, 1, Enum.TextXAlignment.Center

    -- حاوية الأزرار للترتيب التلقائي
    self.ButtonContainer = Instance.new("Frame", self.Window)
    self.ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
    self.ButtonContainer.Position = UDim2.new(0, 10, 0, 40)
    self.ButtonContainer.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", self.ButtonContainer)
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- رسالة الحالة (StatusLabel)
    self.StatusLabel = Instance.new("TextLabel", self.Window)
    self.StatusLabel.Size, self.StatusLabel.Position, self.StatusLabel.BackgroundTransparency, self.StatusLabel.Font, self.StatusLabel.TextSize, self.StatusLabel.TextTransparency, self.StatusLabel.ZIndex = UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 1, -22), 1, Enum.Font.SciFi, 12, 1, 2

    return self
end

-- دالة لتحديث الحالة (تم تعديلها لتكون جزءًا من المكتبة لسهولة الوصول)
function Library:updateStatus(text, color)
    local label = self.StatusLabel
    local defaultColor = Color3.fromRGB(255, 255, 255) -- لون أبيض افتراضي
    if not label then return end
    label.Text, label.TextColor3, label.TextTransparency = text, color or defaultColor, 0
    task.delay(2, function() label.TextTransparency = 1 end)
end

-- دالة داخلية لإنشاء زر فردي (تم إصلاحها)
local function createButton(parent, properties, statusLabel)
    local button = Instance.new("TextButton", parent)
    button.Text = properties.Text or ""
    button.Font = Enum.Font.Arcade
    button.TextSize = properties.TextSize or 12
    button.TextColor3 = properties.TextColor or Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = properties.BackgroundColor or Color3.fromRGB(0, 0, 0)
    button.BorderSizePixel = 0
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    local active = false
    button.MouseButton1Click:Connect(function()
        active = not active
        if properties.OnClick then
            properties.OnClick(active, statusLabel) -- statusLabel هو TextLabel، لكن الكود يستخدم ui:updateStatus
        end
    end)
    return button
end

-- دالة لإضافة صف من الأزرار (زر واحد أو اثنان)
function Library:AddButtonRow(buttonProps1, buttonProps2)
    local rowHeight = 22
    local padding = 4
    -- يجب تحديث حجم النافذة قبل إضافة الصف
    self.Window.Size = self.Window.Size + UDim2.new(0, 0, 0, rowHeight + padding)

    local rowFrame = Instance.new("Frame", self.ButtonContainer)
    rowFrame.Size = UDim2.new(1, 0, 0, rowHeight)
    rowFrame.BackgroundTransparency = 1
    
    local layout = Instance.new("UIListLayout", rowFrame)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 4)

    -- تمرير self.StatusLabel إلى دالة الإنشاء
    local btn1 = createButton(rowFrame, buttonProps1, self.StatusLabel)
    
    if buttonProps2 then
        local btn2 = createButton(rowFrame, buttonProps2, self.StatusLabel)
        -- حساب الحجم للأزرار المتجاورة
        btn1.Size = UDim2.new(0.5, -2, 1, 0)
        btn2.Size = UDim2.new(0.5, -2, 1, 0)
    else
        btn1.Size = UDim2.new(1, 0, 1, 0)
    end
end

-- دالة لإضافة زر طويل
function Library:AddFullWidthButton(properties)
    self:AddButtonRow(properties)
end

-- ==================== مثال على كيفية الاستخدام ====================

-- 1. إنشاء الواجهة
local ui = Library.new("Menu Bytox", "By bytox")

-- 2. إضافة صف يحتوي على زرين بجانب بعضهما
--=================== Start Template (تم تعديل استخدام Status) ===================--

-- متغيرات خارجية لـ "esp timer" للحفاظ على الحالة
local lockTimerESPEnabled = false
local screenGui, label, alarm

-- Row 1: Raw + Xry Base
ui:AddButtonRow(
    {
        Text = "esp players",
        OnClick = function(active, status)
            -- استخدام دالة updateStatus لتحديث الحالة
            ui:updateStatus("Raw Activated! (Toggle: " .. tostring(active) .. ")", Color3.fromRGB(0, 255, 0))
    --=== ESP + HITBOX ( RED 139,0,0 ) ===--
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local ESP_COLOR = Color3.fromRGB(139, 0, 0)
    
    local ESP_FOLDER = workspace:FindFirstChild("ESP_Players") or Instance.new("Folder", workspace)
    ESP_FOLDER.Name = "ESP_Players"
    
    -- دالة لإزالة ESP
    local function RemoveESP(player)
        for _, obj in ipairs(ESP_FOLDER:GetChildren()) do
            if obj:IsA("BillboardGui") and obj.Name == player.Name then
                obj:Destroy()
            elseif obj:IsA("SelectionBox") and obj.Name == player.Name then
                obj:Destroy()
            end
        end
    end

    -- إنشاء BillBoard لاسم اللاعب + Hitbox Outline
    local function CreateESP(player)
        if player == LocalPlayer then return end
        
        -- التأكد من عدم وجود ESP مكرر
        if ESP_FOLDER:FindFirstChild(player.Name) then return end
        
        player.CharacterAdded:Connect(function(char)
            repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
    
            local HRP = char:FindFirstChild("HumanoidRootPart")
    
            --======================
            -- اسم اللاعب فوقه
            --======================
            local Billboard = Instance.new("BillboardGui")
            Billboard.Name = player.Name -- لتسهيل الإزالة
            Billboard.Parent = ESP_FOLDER
            Billboard.Adornee = HRP
            Billboard.Size = UDim2.new(0, 200, 0, 50)
            Billboard.StudsOffset = Vector3.new(0, 3, 0)
            Billboard.AlwaysOnTop = true
    
            local NameLabel = Instance.new("TextLabel", Billboard)
            NameLabel.Size = UDim2.new(1, 0, 1, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = player.Name
            NameLabel.TextColor3 = ESP_COLOR
            NameLabel.TextStrokeTransparency = 0.5
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.TextScaled = true
    
            --======================
            -- HITBOX أحمر
            --======================
            local selection = Instance.new("SelectionBox")
            selection.Name = player.Name -- لتسهيل الإزالة
            selection.Adornee = HRP
            selection.LineThickness = 0.05
            selection.Color3 = ESP_COLOR
            selection.SurfaceTransparency = 1
            selection.Parent = ESP_FOLDER
        end)
        
        -- إذا كان اللاعب موجودًا بالفعل
        if player.Character then
            player.CharacterAdded:Fire(player.Character)
        end
    end
    
    -- دالة لتحديث حالة ESP
    local function updateESPState(enabled)
        if enabled then
            -- تطبيق ESP على كل اللاعبين الحاليين
            for _, player in ipairs(Players:GetPlayers()) do
                CreateESP(player)
            end
            
            -- إذا دخل لاعب جديد
            ESP_FOLDER.PlayerAddedConn = Players.PlayerAdded:Connect(CreateESP)
            
            -- إذا خرج لاعب
            ESP_FOLDER.PlayerRemovingConn = Players.PlayerRemoving:Connect(RemoveESP)
        else
            -- إزالة كل ESP
            ESP_FOLDER:ClearAllChildren()
            if ESP_FOLDER.PlayerAddedConn then ESP_FOLDER.PlayerAddedConn:Disconnect() end
            if ESP_FOLDER.PlayerRemovingConn then ESP_FOLDER.PlayerRemovingConn:Disconnect() end
        end
    end
    
    updateESPState(active)
        end
    },
    {
        Text = "Xry Base",
        OnClick = function(active, status)
            -- استخدام دالة updateStatus لتحديث الحالة
            ui:updateStatus("Xry Base Running! (Toggle: " .. tostring(active) .. ")", active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)) -- لون أخضر/أحمر
            
            -- ضع هذا كـ LocalScript (مثال: StarterPlayerScripts)
            local Players = game:GetService("Players")
            local workspace = game:GetService("Workspace")
            local LocalPlayer = Players.LocalPlayer
            
            -- أسماء/كلمات البحث (الحساسية للصيغة الصغيرة)
            local targets = {"base", "basepart", "yourbase"}
            
            -- مقدار التعتيم المحلي (0 = لا تغيير، 1 = كامل شفاف). "قليلا" استخدمت 0.5
            local localTransparencyModifier = 0.5
            
            -- يخزن الأجزاء التي عدلناها حتى نقدر نرجعها لو حبينا
            local modified = {}
            
            local function nameMatches(name)
                if not name then return false end
                local lower = string.lower(name)
                for _, target in ipairs(targets) do
                    if string.find(lower, target) then
                        return true
                    end
                end
                return false
            end
            
            local function isBasePart(part)
                return part:IsA("BasePart") and part.Transparency < 1 and part.CanCollide
            end
            
            local function applyXray(part)
                if not part or modified[part] then return end
                
                -- حفظ الحالة الأصلية
                modified[part] = {
                    OriginalTransparency = part.Transparency,
                    OriginalCanCollide = part.CanCollide,
                    OriginalColor = part.Color
                }
                
                -- تطبيق X-ray
                part.Transparency = localTransparencyModifier
                part.CanCollide = false
                part.Color = Color3.fromRGB(139, 0, 0) -- لون أحمر
            end
            
            local function removeXray(part)
                local original = modified[part]
                if original then
                    part.Transparency = original.OriginalTransparency
                    part.CanCollide = original.OriginalCanCollide
                    part.Color = original.OriginalColor
                    modified[part] = nil
                end
            end
            
            local function updateXray(enabled)
                if enabled then
                    -- تطبيق X-ray على الأجزاء الموجودة حاليًا
                    for _, part in ipairs(workspace:GetDescendants()) do
                        if isBasePart(part) and nameMatches(part.Name) then
                            applyXray(part)
                        end
                    end
                    
                    -- مراقبة الأجزاء الجديدة
                    workspace.DescendantAdded:Connect(function(descendant)
                        if isBasePart(descendant) and nameMatches(descendant.Name) then
                            applyXray(descendant)
                        end
                    end)
                else
                    -- إزالة X-ray
                    for part, _ in pairs(modified) do
                        removeXray(part)
                    end
                end
            end
            
            updateXray(active)
        end
    }
)

-- زر كبير: Speed v1.0
ui:AddFullWidthButton({
    Text = "Speed v1.0",
    TextSize = 14,
    OnClick = function(active, status)
        -- استخدام دالة updateStatus لتحديث الحالة
        ui:updateStatus("Speed v1.0 Active! (Toggle: " .. tostring(active) .. ")", active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)) -- لون أخضر/أحمر
        
        --Grapple speed by @rzn (No GUI)
        
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local LocalPlayer = Players.LocalPlayer
        
        local currentSpeed = 150
        local DEFAULT_SPEED = 16
        local itemID = "Grapple Hook"
        local args = {1.9832406361897787}
        
        local character, humanoid, hrp
        local speedConnection, smoothLoop, equipLoop
        
        local useItemRE = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem")
        
        local function updateCharacter()
            if not LocalPlayer.Character then
                character = LocalPlayer.CharacterAdded:Wait()
            else
                character = LocalPlayer.Character
            end
            humanoid = character:WaitForChild("Humanoid", 5)
            hrp = character:WaitForChild("HumanoidRootPart", 5)
        end
        
        local function startSpeedHack()
            if not humanoid or not hrp then return end
            if speedConnection then speedConnection:Disconnect() end
        
            speedConnection = RunService.Heartbeat:Connect(function()
                -- لا حاجة للتحقق من `enabled` هنا، سيتم فصل الاتصال عند الإيقاف
                local dir = humanoid.MoveDirection.Magnitude > 0 and humanoid.MoveDirection.Unit or Vector3.new()
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X * currentSpeed, hrp.AssemblyLinearVelocity.Y, dir.Z * currentSpeed)
                task.wait(0.05)
            end)
        end
        
        local function stopSpeedHack()
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
        end
        
        local function buyItem()
            pcall(function()
                ReplicatedStorage.Packages.Net["RF/CoinsShopService/RequestBuy"]:InvokeServer(itemID)
            end)
        end
        
        local function autoEquip()
            if not character then return end
            local backpack = LocalPlayer:WaitForChild("Backpack")
            local tool = character:FindFirstChild(itemID) or backpack:FindFirstChild(itemID)
            if tool and tool.Parent ~= character then
                tool.Parent = character
            end
        end
        
        local function fakeUse()
            if not character then return end
            if character:FindFirstChild(itemID) then
                pcall(function()
                    useItemRE:FireServer(unpack(args))
                end)
            end
        end
        
        local function ensureGrapple()
            if not character then return end
            if not character:FindFirstChild(itemID) and not LocalPlayer.Backpack:FindFirstChild(itemID) then
                buyItem()
            end
            autoEquip()
        end
        
        local function startSmoothLoop()
            if smoothLoop then smoothLoop:Disconnect() end
            smoothLoop = RunService.RenderStepped:Connect(function()
                -- لا حاجة للتحقق من `enabled` هنا
                fakeUse()
            end)
        end
        
        local function startEquipLoop()
            if equipLoop then equipLoop:Disconnect() end
            equipLoop = RunService.Heartbeat:Connect(function()
                -- لا حاجة للتحقق من `enabled` هنا
                ensureGrapple()
            end)
        end
        
        local function cleanupSpeed()
            stopSpeedHack()
            if smoothLoop then smoothLoop:Disconnect(); smoothLoop = nil end
            if equipLoop then equipLoop:Disconnect(); equipLoop = nil end
            if humanoid then humanoid.WalkSpeed = DEFAULT_SPEED end
        end
        
        --=============== تشغيل النظام بدون GUI ===============--
        
        if active then
            updateCharacter()
            buyItem()
            autoEquip()
            startSpeedHack()
            startSmoothLoop()
            startEquipLoop()
        else
            cleanupSpeed()
        end
        
        -- تفعيل / إيقاف بالزر F (تم إبقاء الكود الأصلي لكنه لن يعمل بشكل صحيح مع زر الـ GUI)
        -- ملاحظة: هذا الجزء من الكود سيتعارض مع منطق زر الـ GUI، يفضل إزالته أو تعديله
        -- لكي يعمل بشكل صحيح مع زر الـ GUI، يجب أن تكون المتغيرات `enabled` و `cleanupSpeed` و `startSpeedHack`... إلخ
        -- معرفة خارج نطاق `OnClick` أو يتم تمريرها. بما أن المستخدم طلب عدم حذف أي شيء، سأبقيها.
        -- لكن سأقوم بتعليقها لأنها ستسبب مشاكل في المنطق عند استخدام زر الـ GUI.
        
        --[[
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.F then
                enabled = not enabled
                if enabled then
                    updateCharacter()
                    buyItem()
                    autoEquip()
                    startSpeedHack()
                    startSmoothLoop()
                    startEquipLoop()
                else
                    cleanupSpeed()
                end
            end
        end)
        --]]
    end
})

-- Row 3: Auto Steal + Floor Up
ui:AddButtonRow(
    {
        Text = "esp timer",
        OnClick = function(active, status)
            local statusText = "Auto timer: " .. (active and "ON" or "OFF")
            local statusColor = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0) 
            
            lockTimerESPEnabled = active -- تم تصحيح: استخدام المتغير الخارجي

            if active then
                -- GUI Creation
                if not screenGui then
                    screenGui = Instance.new("ScreenGui")
                    screenGui.Name = "ESP_LockTimer"
                    screenGui.ResetOnSpawn = false
                    screenGui.Parent = game:GetService("CoreGui")
            
                    label = Instance.new("TextLabel")
                    label.Size = UDim2.new(0, 230, 0, 30)
                    label.Position = UDim2.new(1, -240, 1, -40)
                    label.BackgroundTransparency = 0.3
                    label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 18
                    label.TextStrokeTransparency = 0.5
                    label.BorderSizePixel = 0
                    label.ZIndex = 9999
                    label.Text = ""
                    label.Parent = screenGui
            
                    alarm = Instance.new("Sound")
                    alarm.SoundId = "rbxassetid://2979857617"
                    alarm.Volume = 1.3
                    alarm.Looped = true
                    alarm.Parent = workspace
                    
                    -- Find player's plot
                    local function findMyPlot()
                        local plots = workspace:FindFirstChild("Plots")
                        if not plots then return end
                        for _, plot in ipairs(plots:GetChildren()) do
                            local sign = plot:FindFirstChild("PlotSign")
                            if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then
                                return plot
                            end
                        end
                    end
                    
                    -- Read Timer
                    local function getRemainingSeconds(plot)
                        for _, obj in ipairs(plot:GetDescendants()) do
                            if obj:IsA("TextLabel") and obj.Name == "RemainingTime" and obj.Visible then
                                local seconds = tonumber(obj.Text:match("(%d+)"))
                                return seconds
                            end
                        end
                    end
                    
                    -- MAIN LOOP
                    task.spawn(function()
                        while task.wait(0.2) do
                            if lockTimerESPEnabled and label then
                                local plot = findMyPlot()
                                if plot then
                                    local sec = getRemainingSeconds(plot)
                                    if sec then
                                        label.Text = "🔒 Lock Timer: " .. tostring(sec) .. "s"
                    
                                        -- Alarm below 10 seconds
                                        if sec <= 10 then
                                            if alarm and not alarm.IsPlaying then
                                                alarm:Play()
                                            end
                                        else
                                            if alarm and alarm.IsPlaying then
                                                alarm:Stop()
                                            end
                                        end
                                    else
                                        label.Text = "No Timer Found"
                                    end
                                else
                                    label.Text = "No Base Found"
                                end
                            end
                        end
                    end)
                end
            else
                -- دالة لإزالة GUI
                local function removeGUI()
                    if screenGui then screenGui:Destroy() end
                    if alarm then alarm:Destroy() end
                    screenGui, label, alarm = nil, nil, nil
                end
                removeGUI()
            end
            
            ui:updateStatus(statusText, statusColor)
            
        end
    },
    {
        Text = "Floor Up",
        OnClick = function(active, status)
            -- استخدام دالة updateStatus لتحديث الحالة
            ui:updateStatus("Floor Up! (Toggle: " .. tostring(active) .. ")", active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)) -- لون أخضر/أحمر
            
            --// Services
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer
            
            --// Vars
            local floatBlock
            local floatConn
            
            --// Float Functions
            local function StartFloat()
                if floatBlock then return end
                
                floatBlock = Instance.new("Part")
                floatBlock.Name = "FloatBlock"
                floatBlock.Anchored = true
                floatBlock.CanCollide = true
                floatBlock.Size = Vector3.new(6,1,6)
                floatBlock.Color = Color3.fromRGB(139,0,0) -- اللون الأحمر اللي طلبته
                floatBlock.Material = Enum.Material.Neon
                floatBlock.Transparency = 0.15
                floatBlock.Parent = workspace
                
                floatConn = RunService.Heartbeat:Connect(function()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- يجب أن يكون floatBlock.CFrame هو CFrame وليس Vector3
                        floatBlock.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
                    end
                end)
            end
            
            local function StopFloat()
                if floatConn then
                    floatConn:Disconnect()
                    floatConn = nil
                end
                if floatBlock then
                    floatBlock:Destroy()
                    floatBlock = nil
                end
            end
            
            if active then
                StartFloat()
            else
                StopFloat()
            end
        end
    }
)

-- Row 4: Esp Best + Go To Best
ui:AddButtonRow(
    {
        Text = "ESP Best",
        OnClick = function(active, status)
            -- استخدام دالة updateStatus لتحديث الحالة
            ui:updateStatus("ESP Best Enabled! (Toggle: " .. tostring(active) .. ")", active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)) -- لون أخضر/أحمر
            -- كود احسن pet او افضل هدف هنا
        end
    },
    {
        Text = "Go To Best",
        OnClick = function(active, status)
            -- استخدام دالة updateStatus لتحديث الحالة
            ui:updateStatus("Teleporting To Best...", Color3.fromRGB(0, 191, 255)) -- لون أزرق فاتح
            -- كود الذهاب لأفضل pet هنا
        end
    }
)

-- زر كبير: Auto Fishing
ui:AddFullWidthButton({
    Text = "Auto Fishing",
    TextSize = 14,
    OnClick = function(active, status)
        local statusText = "Auto Fishing: " .. (active and "ON" or "OFF")
        local statusColor = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0) -- أخضر للتشغيل، أصفر للإيقاف
        -- استخدام دالة updateStatus لتحديث الحالة
        ui:updateStatus(statusText, statusColor)
        -- كود الصيد التلقائي هنا
    end
})

-- زر كبير: Copy Discord
ui:AddFullWidthButton({
    Text = "Copy Discord",
    TextSize = 14,
    OnClick = function(active, status)
        setclipboard("https://discord.gg/xxx")
        -- استخدام دالة updateStatus لتحديث الحالة
        ui:updateStatus("Discord Copied!", Color3.fromRGB(255, 255, 255)) -- لون أبيض
    end
})

-- زر كبير: Copy TikTok
ui:AddFullWidthButton({
    Text = "Copy TikTok",
    TextSize = 14,
    OnClick = function(active, status)
        setclipboard("https://tiktok.com/@xxxx")
        -- استخدام دالة updateStatus لتحديث الحالة
        ui:updateStatus("TikTok Copied!", Color3.fromRGB(255, 255, 255)) -- لون أبيض
    end
})

--=================== End Template (تم تعديل استخدام Status) ===================--
