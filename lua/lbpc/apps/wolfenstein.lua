table.insert(PCMOD_APPS, table.Count(PCMOD_APPS), {
    ['meta'] = {
        ['name'] = "Wolfenstein 3D",
        ['icon'] = "lambda/wolfenstein.png"
    },
    ['run'] = function(AppLauncher, Desktop)
        AppLauncher:Remove()
                        
        local Browser = vgui.Create("DFrame", Desktop)
        Browser:SetSize(650, 434)
        Browser:Center()
        Browser:SetTitle("Wolfenstein 3D")
        Browser:SetIcon("lambda/wolfenstein.png")
        Browser:SetSizable(false)
                        
        local html = vgui.Create("DHTML", Browser)
        html:Dock(FILL)
        html:OpenURL("http://loadx.github.io/html5-wolfenstein3D")
    end
})

 
