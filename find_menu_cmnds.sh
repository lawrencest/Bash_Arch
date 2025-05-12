#!/bin/bash

# Use find and fzf to select files and open them in vim, cat, or bat

echo "Find and Open Files (Current Directory: $(pwd))"
echo "---------------------------------------------"

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is not installed. Please install fzf to use this script."
    exit 1
fi

# Check if bat is available for preview and viewing
if command -v bat >/dev/null 2>&1; then
    BAT_AVAILABLE=1
    PREVIEW_CMD="bat --color=always {}"
else
    BAT_AVAILABLE=0
    PREVIEW_CMD="cat {}"
    echo "Note: 'bat' is not installed. Using 'cat' for previews and viewing."
fi

# Prompt for file pattern
read -p "Enter file name or pattern (e.g., *.txt, or press Enter for all files): " pattern
if [ -z "$pattern" ]; then
    command="find . -type f"
else
    command="find . -type f -name \"$pattern\""
fi

echo "Running: $command"

# Run find and pipe to fzf with keybindings for vim, cat, bat
if [ $BAT_AVAILABLE -eq 1 ]; then
    eval "$command" | fzf --preview "$PREVIEW_CMD" \
        --bind "enter:execute(vim {})" \
        --bind "ctrl-c:execute(cat {})" \
        --bind "ctrl-b:execute(bat {})" \
        --header "Enter: vim | Ctrl-c: cat | Ctrl-b: bat | Esc: quit"
else
    eval "$command" | fzf --preview "$PREVIEW_CMD" \
        --bind "enter:execute(vim {})" \
        --bind "ctrl-c:execute(cat {})" \
        --header "Enter: vim | Ctrl-c: cat | Esc: quit"
fi
