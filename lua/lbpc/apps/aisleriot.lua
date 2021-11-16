table.insert(PCMOD_APPS_LINUX, table.Count(PCMOD_APPS_LINUX), {
    ['meta'] = {
        ['name'] = "Solitaire For Linux",
        ['icon'] = "icon16/layout.png"
    },
    ['run'] = function(ApplicationLauncher, Desktop)
        ApplicationLauncher:Remove()
                        
        local Browser = vgui.Create("DFrame", Desktop)
        Browser:SetSize(640, 480)
        Browser:Center()
        Browser:SetTitle("Solitaire For Linux")
        Browser:SetIcon("icon16/layout.png")
        Browser:SetSizable(true)
                        
        local html = vgui.Create("DHTML", Browser)
        html:Dock(FILL)
        html:OpenURL("https://www.google.com/logos/fnbx/solitaire/standalone.html")
    end
})

 
