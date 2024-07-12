-- Main module for the point-and-click adventure game

local currentState = "intro"
local switchToGame, intro, game

-- Load resources and set up the game
function love.load()
    -- Font loading
    local titleFont = love.graphics.newFont("cyberpunk_font.ttf", 40)
    local introFont = love.graphics.newFont(20)
    
    -- Video loading
    local video = love.graphics.newVideo("background.ogv")
    
    -- Background music loading and setup
    local backgroundMusic = love.audio.newSource("CUTEDEPRESSED.mp3", "stream")
    backgroundMusic:setLooping(false)
    backgroundMusic:play()

    -- Intro module
    intro = {
        titleText = "Heartecho",
        introText = "bxymf studios presents...",
        titleFont = titleFont,
        introFont = introFont,
        initialImageDisplayed = true,
        initialImageDisplayTime = 6.33,
        startGameDelay = 19.00,
        startButtonPressed = false,
        video = video,
        videoPlaying = false,
        backgroundMusic = backgroundMusic,
        buttons = {
            {label = "Start", x = 220, y = 200, w = 200, h = 50, scale = 1.0, hovered = false, action = function() intro.startButtonPressed = true end},
            {label = "Saves", x = 220, y = 250, w = 200, h = 50, scale = 1.0, hovered = false},
            {label = "Settings", x = 195, y = 300, w = 250, h = 50, scale = 1.0, hovered = false}
        },
        elapsedTime = 0,
        audioSegmentStart = 6.33,
        audioSegmentEnd = 19.00
    }

    function intro.update(dt)
        intro.elapsedTime = intro.elapsedTime + dt

        if intro.initialImageDisplayed and intro.elapsedTime >= intro.initialImageDisplayTime then
            intro.initialImageDisplayed = false
            intro.video:play()
            intro.videoPlaying = true
            intro.backgroundMusic:seek(intro.audioSegmentStart)
        end

        if intro.videoPlaying then
            if intro.backgroundMusic:tell() >= intro.audioSegmentEnd then
                intro.backgroundMusic:seek(intro.audioSegmentStart)
                intro.backgroundMusic:play()
            end
        end

        if intro.startButtonPressed and intro.backgroundMusic:tell() >= intro.audioSegmentEnd then
            switchToGame()
        end

        local mx, my = love.mouse.getPosition()
        for _, btn in ipairs(intro.buttons) do
            btn.hovered = mx > btn.x and mx < btn.x + btn.w and my > btn.y and my < btn.y + btn.h
            if btn.hovered then
                btn.scale = math.min(btn.scale + 0.1 * dt, 1.1)
            else
                btn.scale = math.max(btn.scale - 0.1 * dt, 1.0)
            end
        end
    end

    function intro.draw()
        love.graphics.setColor(255, 255, 255)
        
        if intro.initialImageDisplayed then
            love.graphics.setFont(intro.introFont)
            love.graphics.printf(intro.introText, 0, love.graphics.getHeight() / 4 - intro.introFont:getHeight() / 2, love.graphics.getWidth(), "center")
        else
            if intro.videoPlaying then
                love.graphics.draw(intro.video, 0, 0)
            end

            love.graphics.setFont(intro.titleFont)
            love.graphics.printf(intro.titleText, 0, love.graphics.getHeight() * 0.1, love.graphics.getWidth(), "center")

            love.graphics.setFont(intro.introFont)
            for _, button in ipairs(intro.buttons) do
                intro.drawButton(button)
            end
        end
    end

    function intro.drawButton(button)
        love.graphics.push()
        love.graphics.translate(button.x + button.w / 2, button.y + button.h / 2)
        love.graphics.scale(button.scale, button.scale)
        love.graphics.translate(-button.w / 2, -button.h / 2)
        love.graphics.setColor(button.hovered and {255, 0, 0, 255} or {255, 255, 255, 255})
        love.graphics.printf(button.label, 0, button.h / 4, button.w, "center")
        love.graphics.pop()
    end

    function intro.mousepressed(x, y, button)
        if button == 1 and not intro.initialImageDisplayed then
            for _, btn in ipairs(intro.buttons) do
                if x > btn.x and x < btn.x + btn.w and y > btn.y and y < btn.y + btn.h then
                    print(btn.label .. " button clicked!") -- Log button click to console
                    if btn.action then
                        btn.action()
                    end
                end
            end
        end
    end

    -- Game module
    game = {
        currentScene = "scene1",
        scenes = {
            scene1 = {
                background = love.graphics.newImage("art.jpg"),
                objects = {
                    {label = "Object1", x = 100, y = 150, w = 50, h = 50, action = function() print("Object1 clicked!") end},
                    {label = "Object2", x = 200, y = 250, w = 50, h = 50, action = function() print("Object2 clicked!") end}
                }
            },
            scene2 = {
                background = love.graphics.newImage("art.jpg"),
                objects = {
                    {label = "Object3", x = 150, y = 200, w = 50, h = 50, action = function() print("Object3 clicked!") end}
                }
            }
        }
    }

    function game.update(dt)
        -- Update game logic here
    end

    function game.draw()
        love.graphics.draw(game.scenes[game.currentScene].background, 0, 0)
        -- Draw objects (no rectangles)
        for _, obj in ipairs(game.scenes[game.currentScene].objects) do
            -- Optionally, you can draw an image representing the object
            -- love.graphics.draw(obj.image, obj.x, obj.y)
        end
    end

    function game.mousepressed(x, y, button)
        if button == 1 then
            for _, obj in ipairs(game.scenes[game.currentScene].objects) do
                if x > obj.x and x < obj.x + obj.w and y > obj.y and y < obj.y + obj.h then
                    print(obj.label .. " object clicked!") -- Log object click to console
                    if obj.action then
                        obj.action()
                    end
                end
            end
        end
    end
end

-- Update function
function love.update(dt)
    if currentState == "intro" then
        intro.update(dt)
    elseif currentState == "game" then
        game.update(dt)
    end
end

-- Draw function
function love.draw()
    if currentState == "intro" then
        intro.draw()
    elseif currentState == "game" then
        game.draw()
    end
end

-- Mouse pressed function
function love.mousepressed(x, y, button, istouch, presses)
    if currentState == "intro" then
        intro.mousepressed(x, y, button)
    elseif currentState == "game" then
        game.mousepressed(x, y, button)
    end
end

-- Switch to game state function
function switchToGame()
    currentState = "game"
end

