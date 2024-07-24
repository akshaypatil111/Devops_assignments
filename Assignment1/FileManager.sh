#!/bin/bash

function create_directory {
    mkdir -p "$1/$2"
}

function delete_directory {
    rm -rf "$1/$2"
}

function list_content {
    ls -la "$1"
}

function list_files {
    find "$1" -maxdepth 1 -type f
}

function list_directories {
    find "$1" -maxdepth 1 -type d
}

function list_all {
    ls -A "$1"
}

function create_file {
    touch "$1/$2"
    [ -n "$3" ] && echo "$3" > "$1/$2"
}

function add_content_to_file {
    echo "$3" >> "$1/$2"
}

function add_content_to_file_beginning {
    echo "$3" | cat - "$1/$2" > temp && mv temp "$1/$2"
}

function show_file_beginning_content {
    head -n "$3" "$1/$2"
}

function show_file_end_content {
    tail -n "$3" "$1/$2"
}

function show_file_content_at_line {
    sed -n "${3}p" "$1/$2"
}

function show_file_content_for_line_range {
    sed -n "${3},${4}p" "$1/$2"
}

function move_file {
    mv "$1" "$2"
}

function copy_file {
    cp "$1" "$2"
}

function clear_file_content {
    > "$1/$2"
}

function delete_file {
    rm -f "$1/$2"
}

case "$1" in
    addDir)
        create_directory "$2" "$3"
        ;;
    deleteDir)
        delete_directory "$2" "$3"
        ;;
    listContent)
        list_content "$2"
        ;;
    listFiles)
        list_files "$2"
        ;;
    listDirs)
        list_directories "$2"
        ;;
    listAll)
        list_all "$2"
        ;;
    addFile)
        create_file "$2" "$3" "$4"
        ;;
    addContentToFile)
        add_content_to_file "$2" "$3" "$4"
        ;;
    addContentToFileBegining)
        add_content_to_file_beginning "$2" "$3" "$4"
        ;;
    showFileBeginingContent)
        show_file_beginning_content "$2" "$3" "$4"
        ;;
    showFileEndContent)
        show_file_end_content "$2" "$3" "$4"
        ;;
    showFileContentAtLine)
        show_file_content_at_line "$2" "$3" "$4"
        ;;
    showFileContentForLineRange)
        show_file_content_for_line_range "$2" "$3" "$4" "$5"
        ;;
    moveFile)
        move_file "$2" "$3"
        ;;
    copyFile)
        copy_file "$2" "$3"
        ;;
    clearFileContent)
        clear_file_content "$2" "$3"
        ;;
    deleteFile)
        delete_file "$2" "$3"
        ;;
    *)
        echo "Invalid command"
        ;;
esac

