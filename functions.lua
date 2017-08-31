rng = love.math.newRandomGenerator( os.time() );
local M = {
  randomdouble = function (min, max)
    return rng:random() * (max - min) + min
  end,
  switch = function (c)
    --[[
    fn.switch("val") : caseof {
      [1]   = function (x) print(x,"one") end,
      [2]   = function (x) print(x,"two") end,
      [3]   = 12345,
      default = function (x) print(x,"default") end,
      missing = function (x) print(x,"missing") end
    }
    --]]
    local swtbl = {
      casevar = c,
      caseof = function (self, code)
        local f
        if (self.casevar) then
          f = code[self.casevar] or code.default
        else
          f = code.missing or code.default
        end
        if f then
          if type(f)=="function" then
            return f(self.casevar,self)
          else
            error("case "..tostring(self.casevar).." not a function")
          end
        end
      end
    }
    return swtbl
  end
}
return M
