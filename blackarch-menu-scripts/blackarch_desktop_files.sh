#! /bin/bash
# based on https://github.com/BlackArch/blackarch-iso/tree/master/tools/menu-maker
#set -x

_GROUPS="`pacman -Sg | grep blackarch- | sort -u | tr -s '\n' ' '`"
N=0
wget "https://raw.githubusercontent.com/BlackArch/blackarch-iso/master/tools/menu-maker/help-flags.txt"
#IFS=$'\n'

make_desktop_files()
{
    for GROUP in $_GROUPS
    do
        PKGS="`pacman -Sg ${GROUP} | cut -d ' ' -f 2`"

        for P in ${PKGS}
        do
            TOOLS="`pkgfile -lbq ${P} | grep -vE '.keep|.exe|.applet|.txt|.png|.jar'`"
            
            for TOOL in ${TOOLS}
            do
                N=`echo "$N+1" | bc`
                if ! grep "^$TOOL " "done.txt" && ! grep "^$TOOL " "skipped.txt" && ! grep "^$TOOL " "i_dont_want_to_think_about_that_yet.txt"
                then
                    TOOL_NAME=$(echo "$TOOL" | perl -p -e 's/\//\\/g')
                    PACMAN_PACKAGE_INFO=$(echo "`pacman -Si $P`")
                    TOOL_ONLY="${TOOL##*/}"
                    EXIST=$TOOL
                    CATEGORY=""
                    
		    add_description;
                    
                    add_categories;
                    
                    OPTS=`grep "^$TOOL_ONLY " "help-flags.txt" | cut -d ' ' -f 2-`
                    
                    if [ -z "${OPTS}" ]
                    then    
                        OPTS_FINAL=""
                        
                        clear
                        
                        OUTPUT_FILE="ba-$TOOL_NAME.desktop"
                        
                        if [ ! -e "$OUTPUT_FILE" ]
                        then
                            
                            desktop_file_entry;

                            ask_user;
                        fi
                    else
                        IFS=$'\n'
                        
                        for S in $OPTS
                        do
                            IFS=$'  \n'
                            S=${S%;*}
                            S=${S% *}
                            if [ -z $S ]
                            then
                                OPTS_FINAL="$S"
                                SPACE=""
                            else
                                OPTS_FINAL=" $S"
                                SPACE="_"
                            fi
                            
                            clear
                            OUTPUT_FILE="ba-$TOOL_NAME$SPACE$OPTS_FINAL.desktop"

                            if [ ! -e "$OUTPUT_FILE" ]
                            then
                                
                                desktop_file_entry;
                                
                                ask_user;

                            fi
                        done
                    fi
                fi
            done         
        done
    done

    return 0
}

desktop_file_entry()
{
	DESKTOP_FILE_INFO="[Desktop Entry]
Name=${TOOL_ONLY}
Icon=utilities-terminal
Comment=${DESCRIPTION}
TryExec=${EXIST}
Exec=sh -c '/usr/local/bin/appHelper.sh ${TOOL}${OPTS_FINAL}' \$SHELL
StartupNotify=true
Terminal=true
Type=Application
Categories=${CATEGORY}"

        echo -n "$DESKTOP_FILE_INFO" > "$OUTPUT_FILE"

    #kioclient exec "ba-$TOOL_ONLY ${OPTS_FINAL}.desktop"
    return 0
}

add_description()
{
	if [ "$TOOL_ONLY" == "$P" ]
	then
		DESCRIPTION=$(echo "$PACMAN_PACKAGE_INFO" |
		grep Description |
		cut -c19- | sort -n | head -1)
	else
		DESCRIPTION=""
	fi
	
	return 0

}

add_categories()
{
	for S in `echo "$PACMAN_PACKAGE_INFO" | grep Groups | grep blackarch | cut -c29- `;
	do
		CAPITALIZED=`echo $S | sed 's/blackarch/BlackArch/' | sed -r 's/\-(.)/-\U\1/g'`
		CATEGORY=$CATEGORY`echo "X-$CAPITALIZED;"`
	done
		
	return 0
}

ask_user()
{
	echo "$DESKTOP_FILE_INFO"
	echo "

		I will tell you what. Press
			1 for everything is OK
			2 for I want to edit it
			3 I do not want to think about it yet or
			4 for should not be used at all

		$N"

	read ANSWER

	[ $ANSWER = 1 ] && echo "$TOOL " >> done.txt
	[ $ANSWER = 2 ] && echo "$TOOL " >> done.txt && vim "$OUTPUT_FILE"
	[ $ANSWER = 3 ] && echo "$TOOL " >> i_dont_want_to_think_about_that_yet.txt && rm "$OUTPUT_FILE"
	[ $ANSWER = 4 ] && echo "$TOOL " >> skipped.txt && rm "$OUTPUT_FILE"
		
	return 0
}

check_repository()
{
	if pacman -Sg blackarch 1> /dev/null
	then
		return 0
	else
		echo "Add blackarch repository to /etc/pacman.conf to use this script."
		exit
	fi
	
	return 0;
}

check_repository
make_desktop_files
