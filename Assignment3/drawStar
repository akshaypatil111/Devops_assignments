#!/bin/bash

size=$1
type=$2

draw_t1() {
    for ((i = 1; i <= size; i++)); do
        printf "%*s" $((size - i)) ""
        for ((j = 1; j <= i; j++)); do
            printf "*"
        done
        echo ""
    done
}

draw_t2() {
    for ((i = 1; i <= size; i++)); do
        for ((j = 1; j <= i; j++)); do
            printf "*"
        done
        echo ""
    done
}

draw_t3() {
    for ((i = 1; i <= size; i++)); do
        printf "%*s" $((size - i)) ""
        for ((j = 1; j <= (2 * i - 1); j++)); do
            printf "*"
        done
        echo ""
    done
}

draw_t4() {
    for ((i = size; i >= 1; i--)); do
        for ((j = 1; j <= i; j++)); do
            printf "*"
        done
        echo ""
    done
}

draw_t5() {
    for ((i = size; i >= 1; i--)); do
        printf "%*s" $((size - i)) ""
        for ((j = 1; j <= i; j++)); do
            printf "*"
        done
        echo ""
    done
}

draw_t6() {
    for ((i = size; i >= 1; i--)); do
        printf "%*s" $((size - i)) ""
        for ((j = 1; j <= (2 * i - 1); j++)); do
            printf "*"
        done
        echo ""
    done
}

draw_t7() {
    for ((i = 1; i <= size; i++)); do
        printf "%*s" $((size - i)) ""
        for ((j = 1; j <= (2 * i - 1); j++)); do
            printf "*"
        done
        echo ""
    done
    for ((i = size - 1; i >= 1; i--)); do
        printf "%*s" $((size - i)) ""
        for ((j = 1; j <= (2 * i - 1); j++)); do
            printf "*"
        done
        echo ""
    done
}

case "$type" in
    t1) draw_t1 ;;
    t2) draw_t2 ;;
    t3) draw_t3 ;;
    t4) draw_t4 ;;
    t5) draw_t5 ;;
    t6) draw_t6 ;;
    t7) draw_t7 ;;
    *) echo "Invalid type. Please use t1, t2, t3, t4, t5, t6, or t7." ;;
esac

