table.insert(PCMOD_APPS, table.Count(PCMOD_APPS), {
    ['meta'] = {
        ['name'] = "Worldfox Browser",
        ['icon'] = "icon16/world.png"
    },
    ['run'] = function(AppLauncher, Desktop)
        AppLauncher:Remove()
                        
        local Browser = vgui.Create("DFrame", Desktop)
        Browser:SetSize(650, 470)
        Browser:Center()
        Browser:SetTitle("Worldfox Browser")
        Browser:SetIcon("icon16/world.png")
        Browser:SetSizable(true)
                        
        local HTMLbg = vgui.Create("DPanel", Browser)
        HTMLbg:Dock(FILL)
        
        local html = vgui.Create("DHTML", HTMLbg)
        html:Dock(FILL)
        html:OpenURL("http://frogfind.com")
                        
        local htmlcontrols = vgui.Create("DHTMLControls", Browser)
        htmlcontrols:SetHTML(html)
        htmlcontrols:Dock(TOP) 
    end
})

