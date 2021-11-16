PCMOD_COMMANDS_WINDOWS["help"] = {
    ["description"] = "Shows all available commands",
    ["execute"] = function(args, Shellbox, Terminal, TerminalBG)
        Terminal:AppendText("Available commands:\n")
        for k, v in SortedPairs(PCMOD_COMMANDS_WINDOWS) do
            Terminal:AppendText(k .. " - " .. v["description"] .. "\n")
        end
        Terminal:AppendText("> ")
        Shellbox:SetText("")
    end
} 
