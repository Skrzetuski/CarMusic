#!/bin/bash

isPlaylist(){
    local url=$1
    local reg=".*playlist.*"
    [[ $url =~ $reg ]] && return 0 || return 1
}

getAlbumName(){
    local url=$1
    local content=$(curl -s -L $url)
    local title=$(echo $content |grep -P '<h1 class="pl-header-title" tabindex="0">.*</h1>' -o)
    local reg='>(.*)<'
    [[ $title =~ $reg  ]] && albumTitle=${BASH_REMATCH[1]}
}

#example array of links
array=(
https://www.youtube.com/watch?v=dQw4w9WgXcQ
https://www.youtube.com/watch?v=djV11Xbc914
https://www.youtube.com/playlist?list=PLRI-yTZNo9nSmwwaBIJBpS_IYCA_bcN8d 
)

for item in ${array[*]}
do
    if  isPlaylist $item; then
        getAlbumName $item
        youtube-dl --extract-audio --audio-format aac -o "./$albumTitle/%(title)s.%(ext)s" $item
    else
        youtube-dl --extract-audio --audio-format aac -o "%(title)s.%(ext)s" $item
    fi
done
