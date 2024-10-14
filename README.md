# EnhancedLogSystem for Godot

An advanced logging system addon for the Godot Engine that provides various logging features, including:

- Standard console output
- Colored console output using ANSI codes
- BBCode colored output for Godot's RichTextLabel
- Log file output for persistent logging

## Features

1. **Standard Console Output**  
   Outputs log messages directly to the terminal or console. 

2. **ANSI Color Support**  
   Adds colored log messages using ANSI escape codes, which makes it easier to distinguish different log levels (info, warning, error) in the terminal.

3. **BBCode Color Output**  
   Allows logs to be displayed in Godot's UI elements (e.g., `RichTextLabel`) with BBCode-based colors, enhancing readability.

4. **File Output**  
   Saves logs to a file for later inspection. Supports log rotation and custom file naming.

## Installation

1. Copy the `res://addons/enhancedlogger` folder into your project's `res://addons/` directory.
2. Enable the addon in **Project Settings** -> **Plugins**.
3. The logging system will be available as a global singleton for easy access.
