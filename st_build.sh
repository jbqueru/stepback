#!/bin/sh
mkdir -p tmp
cc mb24.sines.c -o tmp/mb24.sines -lm
tmp/mb24.sines > tmp/mb24.sines.rmac

mkdir -p out
~/code/rmac/rmac -s -v -p -4 mb24.st.rmac -o out/MB24.PRG
