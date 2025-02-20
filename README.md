# CMDLib

A command library that helps other mods make commands easier.
The documentation is very WIP and will definitely change in the future.

## Getting Started

Download the `cmd-lib.lua` and then put it in your mods folder.
Now any other mod can access it with _G.CMDLib.

## Constants

ARG_TYPE_NUMBER - Represents an argument that takes in a number.
ARG_TYPE_STRING - Represents an argument that takes in a string.
ARG_TYPE_PLAYER_SINGLE - Represents an argument that takes in one player.
ARG_TYPE_PLAYER_MULTIPLE - Represents an argument that takes in any amount of players.

ARG_PARAM_REQUIRED - Represents an argument that is required.
ARG_PARAM_OPTIONAL - Represents an argument that is optional.

RES_TYPE_ERROR - Represents an error while processing the command.
RES_TYPE_WARNING - Represents a warning while processing the command.
RES_TYPE_SUCCESS - Represents a success while processing the command.

MSG_ERROR_COLOR - Represents the color of error messages.
MSG_ERROR_COLOR - Represents the color of warning messages.
MSG_SUCCESS_COLOR - Represents the color of success messages.

## Functions

argumentFrom - Returns an argument from a name, type, and parameter.
resultFrom - Returns a command result from a type and message.
makeCommand - Makes a command with a name, description, arguments and callback.
editCommand - Edits a command's name, description, arguments or callback.
removeCommand - Removes a command.
getCommandInfo - Returns info about a command.
