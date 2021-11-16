PCMOD_COMMANDS_LINUX["test"] = {
    ["description"] = "Does this work?",
    ["execute"] = function(args, Shellbox, Terminal, TerminalBG)
        Terminal:AppendText("It worked!\n")
        Terminal:AppendText("You added arguments: " .. table.concat(args, ", ") .. "\n$ ")
        Shellbox:SetText("")
        TerminalBG:SetBackgroundColor(Color(50, 50, 50))
    end
} 
