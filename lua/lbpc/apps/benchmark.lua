table.insert(PCMOD_APPS, table.Count(PCMOD_APPS), {
    ['meta'] = {
        ['name'] = "LambdaBenchmark",
        ['icon'] = "icon16/cog_go.png"
    },
    ['run'] = function(AppLauncher, Desktop)
        local Window = vgui.Create("DFrame", Desktop)
        Window:SetSize(300, 90)
        Window:Center()
        Window:SetTitle("LambdaBenchmark")
        Window:SetIcon("icon16/cog_go.png")
        Window:SetSizable(true)
        Window.OnClose = function()
            hook.Remove("Think", "benchmark_Update")
        end
        Desktop.OnRemove = function()
            hook.Remove("Think", "benchmark_Update")
        end
               
        local Tickrate = vgui.Create("DLabel", Window)
        Tickrate:Dock(TOP)
        local Framerate = vgui.Create("DLabel", Window)
        Framerate:Dock(TOP)
        Framerate:DockMargin(0, 4, 0, 0)
        
        hook.Add("Think", "benchmark_Update", function()
            Tickrate:SetText("Server Tickrate: " .. 1 / engine.TickInterval())
            Framerate:SetText("FPS: " .. 1 / RealFrameTime())
        end)
    end
})

 
