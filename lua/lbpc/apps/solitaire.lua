table.insert(PCMOD_APPS_WINDOWS, table.Count(PCMOD_APPS_WINDOWS), {
    ['meta'] = {
        ['name'] = "Solitaire",
        ['icon'] = "icon16/layout.png"
    },
    ['run'] = function(StartMenu, Desktop)
        StartMenu:Remove()
                        
        local Browser = vgui.Create("DFrame", Desktop)
        Browser:SetSize(640, 480)
        Browser:Center()
        Browser:SetTitle("Solitaire")
        Browser:SetIcon("icon16/layout.png")
        Browser:SetSizable(true)
                        
        local html = vgui.Create("DHTML", Browser)
        html:Dock(FILL)
        html:OpenURL("https://www.google.com/logos/fnbx/solitaire/standalone.html")
    end
})

 
