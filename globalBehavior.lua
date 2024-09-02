
gm.post_code_execute(function(self, other, code, result, flags)
    -- Global Draw
    if code.name:match("oInit_Draw_7") then
        RunFunctionsFromTable(GlobalDraw)
    end
    -- Global Step
    if code.name:match("oInit_Step_7") then
        RunFunctionsFromTable(GlobalStep)
    end
end)

gm.pre_code_execute(function(self, other, code, result, flags)
    -- Global Draw
    if code.name:match("oP_Draw") then
        for _, i in ipairs(PrePlayerGlobalDraw) do
            if type(i) == "function" then
                i(self)
            end
        end
    end
end)