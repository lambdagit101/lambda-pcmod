table.insert(PCMOD_APPS, table.Count(PCMOD_APPS), {
    ['meta'] = {
        ['name'] = "Undertale Sans Fight",
        ['icon'] = "icon16/status_offline.png"
    },
    ['run'] = function(AppLauncher, Desktop)
        AppLauncher:Remove()
                        
        local Browser = vgui.Create("DFrame", Desktop)
        Browser:SetSize(840, 680)
        Browser:Center()
        Browser:SetTitle("Undertale Sans Fight")
        Browser:SetIcon("icon16/status_offline.png")
        Browser:SetSizable(false)
                        
        local html = vgui.Create("DHTML", Browser)
        html:Dock(FILL)
        html:OpenURL("http://jcw87.github.io/c2-sans-fight/")
    end
})

 
