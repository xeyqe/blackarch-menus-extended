#!/bin/sh
#

_GROUPS="`pacman -Sg | grep blackarch- | cut -d '-' -f 2- | sort -u | tr -s '\n' ' '`"
DIRECTORIES=( _CodeAnalysis _Cracking _Defensive _Exploitation _Forensic _Malware _Networking _Wireless _Telephony _Scanning _Sniffing _Asserted )


blackarch_menu_entry()
{
    echo "[Desktop Entry]
Name=$group2
Type=Directory" > BlackArch-$name.directory

    return 0
}

make_directory_file()
{
    for group in ${_GROUPS}
    do
        name=`echo $group | sed -re 's/\-(.)/-\U\1\E/g' | sed -re 's/^(.)/\U\1\E/'`
        group2=`echo $name | tr -s '-' ' '`
        blackarch_menu_entry
    done

    return 0
}

make_blackarch()
{
    echo "[Desktop Entry]
Name=BlackArch
Icon=blackarch-logo
Type=Directory" > BlackArch.directory
}

make_upperdirectory_file()
{
    for dir in "${DIRECTORIES[@]}"
    do
        group2=`echo "$dir" | sed -re 's/_//'`
        name="$dir"
	
	if [ "$group2" == "Asserted" ]
	then 
		echo "[Desktop Entry]
Name=$group2
Type=Directory" > BlackArch-$name.directory
	else
	echo "[Desktop Entry]
Name=$group2
Icon=BlackArch-$group2
Type=Directory" > BlackArch-$name.directory
	fi

    done

    return 0
}

make_upperdirectory_file
make_directory_file
make_blackarch
