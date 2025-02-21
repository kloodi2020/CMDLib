-- name: CMDLib
-- description: A command library that helps other mods make commands easier.\nAccessible with _G.CMDLib.\n\nMade by kloodi

_G.CMDLib = {
    ARG_TYPE_NUMBER = 0,
    ARG_TYPE_STRING = 1,
    ARG_TYPE_PLAYER_SINGLE = 2,
    ARG_TYPE_PLAYER_MULTIPLE = 3,
    ARG_PARAM_REQUIRED = 4,
    ARG_PARAM_OPTIONAL = 5,
    RES_TYPE_ERROR = 6,
    RES_TYPE_WARNING = 7,
    RES_TYPE_SUCCESS = 8,
    MSG_ERROR_COLOR = "\\#ff5555\\",
    MSG_WARNING_COLOR = "\\#ffff55\\",
    MSG_SUCCESS_COLOR = "\\#55ff55\\"
}

--- @param str string
--- @param sep string
local function splitString(str, sep)
    if sep == nil then
        sep = "%s"
    end
    
    local result = {}
    for str in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, str)
    end
    return result
end

-- Returns a command argument from a name, type and parameter
--- @param name string
--- @param type integer
--- @param parameter integer
local function argumentFrom(name, type, parameter)
    return {name = name, type = type, parameter = parameter}
end

-- Returns a command result from a type and message
--- @param type integer
--- @param message string
local function resultFrom(type, message)
    return {type = type, message = message}
end

--- @param table table
--- @param item any
local function findTable(table, item)
    for k, v in pairs(table) do
        if v == item then
            return k
        end
    end
    return nil
end

--- @param text string
local function parseSelector(text)
    local result = nil
    local allPlrs = {}

    --- @type NetworkPlayer
    for _, player in pairs(gNetworkPlayers) do
        if player.connected then
            table.insert(allPlrs, player)
            if player.name == text then
                result = {player}
                break
            end
        end
    end

    if text:sub(1, 3) == "all" then
        text = text:sub(4, -1)
        result = allPlrs
    elseif text:sub(1, 2) == "me" then
        text = text:sub(3, -1)
        result = {gNetworkPlayers[0]}
    elseif text:sub(1, 6) == "others" then
        text = text:sub(7, -1)
        result = {}
        for _, v in ipairs(allPlrs) do
            if v.localIndex > 0 then
                table.insert(result, v)
            end
        end
    elseif result == nil then
        return nil
    end

    if text:sub(1, 1) == "[" then
        if text:sub(-1, -1) == "]" then
            local levelNames = {"bob", "wf", "jrb", "ccm", "bbh", "hmc", "lll", "ssl", "ddd", "sl", "wdw", "ttm", "thi", "ttc", "rr", "bitdw", "bitfs", "bits", "pss", "cotmc", "totwc", "vcutm", "wmotr", "sa", "c", "cg", "ccy", "b1", "b2", "b3"}
            local levelNums = {LEVEL_BOB, LEVEL_WF, LEVEL_JRB, LEVEL_CCM, LEVEL_BBH, LEVEL_HMC, LEVEL_LLL, LEVEL_SSL, LEVEL_DDD, LEVEL_SL, LEVEL_WDW, LEVEL_TTM, LEVEL_THI, LEVEL_TTC, LEVEL_RR, LEVEL_BITDW, LEVEL_BITFS, LEVEL_BITS, LEVEL_PSS, LEVEL_COTMC, LEVEL_TOTWC, LEVEL_VCUTM, LEVEL_WMOTR, LEVEL_SA, LEVEL_CASTLE, LEVEL_CASTLE_GROUNDS, LEVEL_CASTLE_COURTYARD, LEVEL_BOWSER_1, LEVEL_BOWSER_2, LEVEL_BOWSER_3}
            for i = 1, 65535, 1 do
                local level = smlua_level_util_get_info(i)
                if level ~= nil then
                    table.insert(levelNames, level.shortName)
                    table.insert(levelNums, level.levelNum)
                end
            end

            text = text:sub(2, -2)

            local filters = splitString(text, ",")
            for _, filter in ipairs(filters) do
                local name = splitString(filter, "=")[1]
                local value = #splitString(filter, "=") > 1 and splitString(filter, "=")[2] or nil

                local newResult = {}
                for i, v in ipairs(result) do
                    if name == "level" then
                        if value == nil then return nil end
                        if v.currLevelNum == levelNums[findTable(levelNames, value:lower())] then
                            table.insert(newResult, v)
                        end
                    end
                end
                result = newResult
            end
        else
            return nil
        end
    end

    return result
end

--- @param arguments table
--- @param argumentTypes table
local function parseArguments(arguments, argumentTypes)
    local result = {}

    if #arguments > #argumentTypes then
        djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: Too many arguments.")
        return nil
    end

    --- @type table
    for idx, arg in ipairs(argumentTypes) do
        if #arguments < idx then
            if arg.parameter == _G.CMDLib.ARG_PARAM_REQUIRED then
                djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: Did not include required argument \"" .. arg.name .. "\".")
                return nil
            elseif arg.parameter == _G.CMDLib.ARG_PARAM_OPTIONAL then
                goto continue
            end
        end

        local convertedArg = arguments[idx]

        if arg.type == _G.CMDLib.ARG_TYPE_NUMBER then
            convertedArg = tonumber(convertedArg)
            if convertedArg == nil then
                djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: Invalid number for \"" .. arg.name .. "\".")
                return nil
            end
        elseif arg.type == _G.CMDLib.ARG_TYPE_PLAYER_SINGLE then
            convertedArg = parseSelector(convertedArg)
            if convertedArg == nil then
                djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: Invalid player for \"" .. arg.name .. "\".")
                return nil
            end
            if #convertedArg > 1 then
                djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: \"" .. arg.name .. "\" only accepts 1 player.")
                return nil
            end
        elseif arg.type == _G.CMDLib.ARG_TYPE_PLAYER_MULTIPLE then
            convertedArg = parseSelector(convertedArg)
            if convertedArg == nil then
                djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: Invalid player for \"" .. arg.name .. "\".")
                return nil
            end
        end

        result[arg.name] = convertedArg

        ::continue::
    end

    return result
end

local commands = {}

--- @param dict table
local function dictLength(dict)
    local result = 0
    for _, _ in pairs(dict) do
        result = result + 1
    end
    return result
end

-- Makes a command with CMDLib's internal command system
--- @param name string
--- @param data table
local function makeCommand(name, data)
    name = name:lower()

    local commandData = {
        description = "",
        longDescription = nil,
        arguments = {},
        callback = function(_) end
    }

    for k, v in pairs(data) do
        commandData[k] = v
    end

    if commandData.longDescription == nil then
        commandData.longDescription = commandData.description
    end

    local argDescription = ""
    for _, arg in ipairs(commandData.arguments) do
        argDescription = argDescription .. "[" .. arg.name
        if arg.parameter == _G.CMDLib.ARG_PARAM_OPTIONAL then argDescription = argDescription .. "?" end

        argDescription = argDescription .. "] "
    end

    commands[name] = {
        name = name,
        order = dictLength(commands),
        description = commandData.description,
        longDescription = commandData.longDescription,
        argDescription = argDescription,
        arguments = commandData.arguments,
        callback = commandData.callback,
        realCallback = function(msg)
            local args = splitString(msg, " ")
            local convertedArgs = parseArguments(args, commands[name].arguments)
            if convertedArgs == nil then return end
    
            local result = commands[name].callback(convertedArgs)
            if result ~= nil and result.message:len() > 0 then
                if result.type == _G.CMDLib.RES_TYPE_ERROR then
                    djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: " .. result.message)
                end
                if result.type == _G.CMDLib.RES_TYPE_WARNING then
                    djui_chat_message_create(_G.CMDLib.MSG_WARNING_COLOR .. "Warning: " .. result.message)
                end
                if result.type == _G.CMDLib.RES_TYPE_SUCCESS then
                    djui_chat_message_create(_G.CMDLib.MSG_SUCCESS_COLOR .. "Success: " .. result.message)
                end
            end
        end
    }
end

-- Removes a command that is made with CMDLib's internal command system
--- @param name string
local function removeCommand(name)
    if commands[name] ~= nil then
        if findTable({"help", "helpCmd"}, name) ~= nil then return end
        commands[name] = nil
    end
end

-- Gets info about a command that is made with CMDLib's internal command system.<br>
-- Editing this won't update the command, For that see `editCommand`.
--- @param name string
local function getCommandInfo(name)
    if commands[name] ~= nil then
        return {
            name = commands[name].name,
            description = commands[name].description,
            longDescription = commands[name].longDescription,
            arguments = commands[name].arguments,
            callback = commands[name].callback
        }
    else
        return nil
    end
end

-- Edits a command that is made with CMDLib's internal command system
--- @param name string
--- @param newName string
--- @param newData table
local function editCommand(name, newName, newData)
    if commands[name] ~= nil then
        removeCommand(name)
        makeCommand(newName, newData)
    end
end

_G.CMDLib.argumentFrom = argumentFrom
_G.CMDLib.resultFrom = resultFrom
_G.CMDLib.makeCommand = makeCommand
_G.CMDLib.editCommand = editCommand
_G.CMDLib.getCommandInfo = getCommandInfo
_G.CMDLib.removeCommand = removeCommand

makeCommand("help", {
    description = "Show a list of commands",
    longDescription = "Show a list of commands, Use [page?] to check which page.",
    arguments = {argumentFrom("page", _G.CMDLib.ARG_TYPE_NUMBER, _G.CMDLib.ARG_PARAM_OPTIONAL)},
    callback = function(args)
        if args.page == nil then
            args.page = 1
        end
    
        args.page = args.page - 1
    
        local commandTable = {}
        for _, command in pairs(commands) do
            table.insert(commandTable, command)
        end

        table.sort(commandTable, function(a, b) return a.order < b.order end)
    
        local perPage = 5
        local maxPage = math.ceil(#commandTable / perPage)
        
        args.page = math.min(math.max(args.page, 0), maxPage - 1)
    
        local list = "List of commands (Page " .. args.page + 1 .. "/" .. maxPage .. "):"
        for idx = args.page * perPage, args.page * perPage + (perPage - 1), 1  do
            idx = idx + 1
            if idx > #commandTable then break end
    
            local command = commandTable[idx]
    
            local join = ""
            if command.description:len() > 0 then
                join = "- " .. command.description
            end
            list = list .. "\n!" .. command.name .. " " .. command.argDescription .. join
        end

        djui_chat_message_create(list)
    end
})
makeCommand("helpCmd", {
    description = "Help about a specific command",
    longDescription = "Help about a specific command, Also shows an extended description (If there is one).",
    arguments = {argumentFrom("command", _G.CMDLib.ARG_TYPE_STRING, _G.CMDLib.ARG_PARAM_OPTIONAL)},
    callback = function(args)
        if args.command == nil then
            commands.help.callback({page = 1})
            return
        end
        args.command = args.command:lower()
        
        if commands[args.command] == nil then
            return resultFrom(_G.CMDLib.RES_TYPE_ERROR, "Invalid command \"" .. args.command .. "\".")
        end
    
        local command = commands[args.command]
    
        djui_chat_message_create("Help (\"" .. command.name .. "\")\n!" .. command.name .. " " .. command.argDescription .. "\n" .. command.longDescription)
    end
})

local function onChat(sender, message)
    if sender.playerIndex > 0 then
        if message:sub(1, 1) == "!" then
            return false
        end
    end

    if message:sub(1, 1) == "!" then
        for name, command in pairs(commands) do
            if splitString(message, " ")[1] == "!" .. name then
                local messageInput = ""
                if message:len() > name:len() + 2 then
                    messageInput = message:sub(name:len() + 2, -1)
                end

                command.realCallback(messageInput)
                return false
            end
        end
        
        djui_chat_message_create(_G.CMDLib.MSG_ERROR_COLOR .. "Error: Invalid command. (Use !help for a list of commands.)")
        return false
    end
end

hook_event(HOOK_ON_CHAT_MESSAGE, onChat)
