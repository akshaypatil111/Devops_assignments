#!/bin/bash

# Ensure correct number of arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <command> [arguments...]"
    exit 1
fi

COMMAND="$1"
shift

case "$COMMAND" in
    addLineTop)
        if [ "$#" -ne 2 ]; then
            echo "Usage: $0 addLineTop <file> <line>"
            exit 1
        fi
        FILE="$1"
        LINE="$2"
        if [ ! -f "$FILE" ]; then
            echo "File not found!"
            exit 1
        fi
        (echo "$LINE"; cat "$FILE") > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
        ;;
    
    addLineBottom)
        if [ "$#" -ne 2 ]; then
            echo "Usage: $0 addLineBottom <file> <line>"
            exit 1
        fi
        FILE="$1"
        LINE="$2"
        if [ ! -f "$FILE" ]; then
            echo "File not found!"
            exit 1
        fi
        echo "$LINE" >> "$FILE"
        ;;
    
    addLineAt)
        if [ "$#" -ne 3 ]; then
            echo "Usage: $0 addLineAt <file> <linenumber> <line>"
            exit 1
        fi
        FILE="$1"
        LINENUM="$2"
        LINE="$3"
        if [ ! -f "$FILE" ]; then
            echo "File not found!"
            exit 1
        fi
        awk -v linenum="$LINENUM" -v line="$LINE" 'NR==linenum {print line} 1' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
        ;;
    
    updateFirstWord)
        if [ "$#" -ne 3 ]; then
            echo "Usage: $0 updateFirstWord <file> <word> <word2>"
            exit 1
        fi
        FILE="$1"
        OLD_WORD="$2"
        NEW_WORD="$3"
        if [ ! -f "$FILE" ]; then
            echo "File not found!"
            exit 1
        fi
        sed -i "s/\b$OLD_WORD\b/$NEW_WORD/" "$FILE"
        ;;
    
    updateAllWords)
        if [ "$#" -ne 3 ]; then
            echo "Usage: $0 updateAllWords <file> <word> <word2>"
            exit 1
        fi
        FILE="$1"
        OLD_WORD="$2"
        NEW_WORD="$3"
        if [ ! -f "$FILE" ]; then
            echo "File not found!"
            exit 1
        fi
        sed -i "s/$OLD_WORD/$NEW_WORD/g" "$FILE"
        ;;
    
    insertWord)
        if [ "$#" -ne 3 ]; then
            echo "Usage: $0 insertWord <file> <word1> <word2> <word to be inserted>"
            exit 1
        fi
        FILE="$1"
        WORD1="$2"
        WORD2="$3"
        INSERT="$4"
        if [ ! -f "$FILE" ]; then
            echo "File not found!"
            exit 1
        fi
        sed -i "s/$WORD1/$INSERT $WORD2/" "$FILE"
        ;;
    
    deleteLine)
        if [ "$#" -lt 2 ]; then
            echo "Usage: $0 deleteLine <file> <line number> [<word>]"
            exit 1
        fi
        FILE="$1"
        LINENUM="$2"
        WORD="$3"
        if [ ! -f "$FILE" ]; then
            echo "File not found!"
            exit 1
        fi
        if [ -z "$WORD" ]; then
            sed -i "${LINENUM}d" "$FILE"
        else
            awk -v word="$WORD" 'NR==LINENUM && !/word/ {print; next} 1' LINENUM="$LINENUM" "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
        fi
        ;;
    
    *)
        echo "Unknown command: $COMMAND"
        echo "Usage: $0 <command> [arguments...]"
        exit 1
        ;;
esac

