# CMDLib

A command library that helps other mods make commands easier.
The documentation is very WIP and will definitely change in the future.

## Getting Started

Download the `cmd-lib.lua` and then put it in your mods folder.
Now any other mod can access it with _G.CMDLib.

## Constants

ARG_TYPE_NUMBER - Represents an argument that takes in a number.<br>
ARG_TYPE_STRING - Represents an argument that takes in a string.<br>
ARG_TYPE_PLAYER_SINGLE - Represents an argument that takes in one player.<br>
ARG_TYPE_PLAYER_MULTIPLE - Represents an argument that takes in any amount of players.<br>

ARG_PARAM_REQUIRED - Represents an argument that is required.<br>
ARG_PARAM_OPTIONAL - Represents an argument that is optional.<br>

RES_TYPE_ERROR - Represents an error while processing the command.<br>
RES_TYPE_WARNING - Represents a warning while processing the command.<br>
RES_TYPE_SUCCESS - Represents a success while processing the command.<br>

MSG_ERROR_COLOR - Represents the color of error messages.<br>
MSG_ERROR_COLOR - Represents the color of warning messages.<br>
MSG_SUCCESS_COLOR - Represents the color of success messages.

## Functions

argumentFrom - Returns an argument from a name, type, and parameter.<br>
resultFrom - Returns a command result from a type and message.<br>
makeCommand - Makes a command with a name, description, arguments and callback.<br>
editCommand - Edits a command's name, description, arguments or callback.<br>
removeCommand - Removes a command.<br>
getCommandInfo - Returns info about a command.
