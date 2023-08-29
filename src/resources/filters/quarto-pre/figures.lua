-- figures.lua
-- Copyright (C) 2020-2022 Posit Software, PBC


function quarto_pre_figures() 
  
  return {    
    FloatRefTarget = function(float)
      local kind = refType(float.identifier)
      if kind ~= "fig" then
        return
      end

      -- propagate fig-alt
      if _quarto.format.isHtmlOutput() then
        -- read the fig-alt text and set the image alt
        local altText = attribute(float, kFigAlt, nil)
        if altText ~= nil then
          float.attributes["alt"] = altText
          float.attributes[kFigAlt] = nil
          return float
        end
      -- provide default fig-pos or fig-env if specified
      elseif _quarto.format.isLatexOutput() then
        local figPos = param(kFigPos)
        if figPos and not float.attributes[kFigPos] then
          float.attributes[kFigPos] = figPos
        end
        -- remove fig-pos if it is false, since it
        -- signals "don't use any value"
        if float.attributes[kFigPos] == "FALSE" then
          float.attributes[kFigPos] = nil
        end
        local figEnv = param(kFigEnv)
        
        if figEnv and not float.attributes[kFigEnv] then
          float.attributes[kFigEnv] = figEnv
        end
        return float
      end
    end
  }
end



