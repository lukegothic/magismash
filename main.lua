local fn = require("functions")
local spells = require("spells")
gamestates = { MENU = "menu", PLAY = "game", PAUSE ="gamepaused", END ="gameover" } -- Game states, en teoria esto es generico
menucaptions = { "Play", "Options", "Exit" }  -- Labels de los items del menu
menuoptions = {  -- Funcionalidad de los items del menu
  Play = function() play() end,
  Options = function() options() end,
  Exit = function() love.event.quit() end
}
runes = {
  a = "An",
  b = "Bet",
  c = "Corp",
  d = "Des",
  e = "Ex",
  f = "Flam",
  g = "Grav",
  h = "Hur",
  i = "In",
  j = "Jux",
  k = "Kal",
  l = "Lor",
  m = "Mani",
  n = "Nox",
  o = "Ort",
  p = "Por",
  q = "Quas",
  r = "Rel",
  s = "Sanct",
  t = "Tym",
  u = "Uus",
  v = "Vas",
  w = "Wis",
  x = "Xen",
  y = "Ylem",
  z = "Zu"
}
runestack = {}
function emptyRunestack()
  for k in pairs (runestack) do
      runestack[k] = nil
  end
end
function play()
  gamestate = gamestates.PLAY
  emptyRunestack()
end
function options()
end
function menu()
  gamestate = gamestates.MENU
  menuoption = next(menucaptions)
end
function love.load()
  window = {}
  window.width, window.height = love.graphics.getDimensions()
  menu()
end
function love.update(dt)

end
function love.keypressed(key, scancode, isrepeat)
  fn.switch(gamestate): caseof {
    [gamestates.MENU] = function()
      fn.switch(key): caseof {
        up = function()
          menuoption = menuoption - 1
          if menuoption == 0 then
            menuoption = #menucaptions
          end
        end,
        down = function()
          menuoption = menuoption + 1
          if menuoption > #menucaptions then
            menuoption = 1
          end
        end,
        ["return"] = function()
          menuoptions[menucaptions[menuoption]]()
        end,
        escape = function()
          love.event.quit()
        end
      }
    end,
    [gamestates.PLAY] = function()
      if (runes[scancode] ~= nil) then
        table.insert(runestack, scancode)
      elseif scancode == "space" then
        emptyRunestack()
      end
    end,
    [gamestates.END] = function()
      fn.switch(key): caseof {
        ["return"] = function()
          play()
        end,
        escape = function()
          menu()
        end
      }
    end
  }
end
function love.mousepressed( x, y, button, istouch )
  local spell = spells[table.concat(runestack)]
  if spell ~= nil then
    emptyRunestack()
  end
end
function love.draw()
  fn.switch(gamestate): caseof {
    [gamestates.MENU] = function()
      local opt = 0
      for key, val in pairs(menucaptions) do
        if menuoption == key then
          love.graphics.setNewFont(20)
          love.graphics.setColor(255,255,255)
        else
          love.graphics.setNewFont(12)
          love.graphics.setColor(200,200,200)
        end
        love.graphics.print( val, 100, 30 * opt )
        opt = opt + 1
      end
    end,
    [gamestates.PLAY] = function()
      local runeword = {}
      for key, val in pairs(runestack) do
        table.insert(runeword, runes[val])
      end
      if (#runestack > 0) then
        love.graphics.setNewFont(20)
        love.graphics.setColor(255,255,255)
        love.graphics.printf( table.concat(runeword, " "), window.width / 2, window.height / 2, 150, "center" )
      end
      local spell = spells[table.concat(runestack)]
      if spell ~= nil then
        local x, y = love.mouse.getPosition()
        love.graphics.setColor(0, 255, 0, 125)
        love.graphics.circle("fill", x, y, spell.targeting.radius)
      end
    end,
    [gamestates.PAUSE] = function()
      love.graphics.setNewFont(30)
      love.graphics.setColor(255,255,255)
      love.graphics.printf( "PAUSE", window.width / 2, window.height / 2, 150, "center" )
    end,
    [gamestates.END] = function()
      love.graphics.setNewFont(30)
      love.graphics.setColor(255,255,255)
      love.graphics.printf( "END", window.width / 2, window.height / 2, 150, "center" )
    end
  }
end
function love.focus(f)
  if (f == true and gamestate == gamestates.PAUSE) then
    gamestate = gamestates.PLAY
  elseif (f == false and gamestate == gamestates.PLAY) then
    gamestate = gamestates.PAUSE
  end
end
