#!/bin/bash
FILE=$1
PUBLIC_KEY="/home/pongkula/.config/sops/age/keys.txt"
age -r $PUBLIC_KEY -o "$FILE.age" "$FILE"
rm "$FILE"

