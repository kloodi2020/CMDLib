# CMDLib

A command library for sm64coopd that helps other mods make commands easier.<br>
The documentation is very WIP and will definitely change in the future.

## Getting Started

Download the `cmdlib.lua` and then put it in your mods folder.<br>
Now any other mod can access it with _G.CMDLib.

## Constants

ARG_TYPE_NUMBER - An argument that takes in a number.<br>
ARG_TYPE_STRING - An argument that takes in a string.<br>
ARG_TYPE_PLAYER_SINGLE - An argument that takes in one player.<br>
ARG_TYPE_PLAYER_MULTIPLE - An argument that takes in any amount of players.<br>

ARG_PARAM_REQUIRED - A parameter that makes the argument required.<br>
ARG_PARAM_OPTIONAL - A parameter that makes the argument optional.<br>

RES_TYPE_ERROR - An error result type.<br>
RES_TYPE_WARNING - A warning result type.<br>
RES_TYPE_SUCCESS - A success result type.<br>

MSG_ERROR_COLOR - The color of error messages.<br>
MSG_ERROR_COLOR - The color of warning messages.<br>
MSG_SUCCESS_COLOR - The color of success messages.

## Functions

### argumentFrom(name, type, parameter)
Returns an argument from a name, type, and parameter.<br>

### resultFrom(type, message)
Returns a command result from a type and message.<br>

### makeCommand(name, data)
Makes a command with a name and a data table that can contain:<br>
description<br>
longDescription<br>
arguments<br>
callback<br>

### editCommand(name, newName, newData)
Edits a command's name and data.<br>

### removeCommand(name)
Removes a command.<br>

### getCommandData(name)
Returns a command's data.
