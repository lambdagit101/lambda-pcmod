PCMOD_COMMANDS_LINUX["help"] = {
    ["description"] = "Shows all available commands",
    ["execute"] = function(args, Shellbox, Terminal, TerminalBG)
        Terminal:AppendText("Available commands:\n")
        for k, v in SortedPairs(PCMOD_COMMANDS_LINUX) do
            Terminal:AppendText(k .. " - " .. v["description"] .. "\n")
        end
        Terminal:AppendText("$ ")
        Shellbox:SetText("")
    end
} 
