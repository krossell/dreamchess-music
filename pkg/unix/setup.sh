#!/bin/sh

VERSION="1.0"

failed()
{
    echo "Installation failed"
    exit 1
}

find_dreamchess()
{
    if [ -f "$1/menu_title.png" ];
    then
        install_dir="$1"
        return 1
    fi
    return 0
}

install_music_pack()
{
    for dir in '' $copy_dirs;
    do
        eval install -d '"$install_dir$dir"' || failed
        for file in data$dir/*;
        do
            if test -f $file;
            then
                eval install -m 644 '"$file"' '"$install_dir$dir/`basename $file`"' || failed
            fi
        done
    done
}

echo -e "DreamChess Music Pack $VERSION Installer\n"
echo -e "Featuring music by Matthew P. Smith (http://www.captivatinguitar.com)\n"
cat LICENSE
echo
echo "The music pack can either be installed in the DreamChess data directory, or in"
echo -e "~/.dreamchess\n"

find_dreamchess "/usr/share/dreamchess"

if [ $? -eq 0 ]
then

    find_dreamchess "/usr/local/share/dreamchess"
    if [ $? -eq 0 ]
    then
        install_dir=~/.dreamchess
    fi
fi

copy_dirs=`find data -name 'data' -o -type d -printf '/%P\n'`

echo -n "Where should the music pack be installed? [$install_dir] "
read install_dir_cl
echo

if [ -n "$install_dir_cl" ];
then
    eval "install_dir=$install_dir_cl"
fi

install_music_pack

echo "Installation completed succesfully"
