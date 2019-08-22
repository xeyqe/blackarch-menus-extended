#!/bin/sh
#


_CodeAnalysis=( blackarch-reversing blackarch-analysis blackarch-disassembler blackarch-debugger blackarch-binary blackarch-decompiler blackarch-code-audit )
_Cracking=( blackarch-cracker blackarch-crypto)
_Defensive=( blackarch-defensive blackarch-honeypot)
_Exploitation=( blackarch-exploitation blackarch-dos blackarch-automation )
_Forensic=( blackarch-anti-forensic blackarch-forensic blackarch-unpacker blackarch-packer )
_Malware=( blackarch-malware blackarch-backdoor blackarch-keylogger )
_Networking=( blackarch-networking blackarch-tunnel blackarch-proxy blackarch-spoof blackarch-spoofer )
_Wireless=( blackarch-bluetooth blackarch-wireless blackarch-nfc )
_Telephony=( blackarch-voip blackarch-mobile )
_Scanning=( blackarch-scanner blackarch-fingerprint blackarch-fuzzer blackarch-recon )
_Sniffing=( blackarch-sniffer )
_Assorted=( blackarch-database blackarch-drone blackarch-firmware blackarch-misc blackarch-gpu blackarch-hardware blackarch-social blackarch-threat-model blackarch-windows blackarch-webapp )
DIRECTORIES=( _CodeAnalysis _Cracking _Defensive _Exploitation _Forensic _Malware _Networking _Wireless _Telephony _Scanning _Sniffing )


_GROUPS="`pacman -Sg | grep blackarch- | cut -d '-' -f 2- | sort -u | tr -s '\n' ' '`"


make_blackarch_menu_header()
{
    #cat "${WORKDIR}/X-BlackArch-header.tmpl" > X-BlackArch.menu
    echo -n '<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
"http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">

<Menu>
	<Name>Applications</Name>
	
	<!-- BlackArch submenu -->
	<Menu>
		<Name>BlackArch</Name>
		<Directory>BlackArch.directory</Directory>
		<Include>
			<Category>X-BlackArch</Category>
		</Include>
		
' > X-BlackArch.menu

    return 0
}

make_blackarch_menu_footer()
{
    #cat "${WORKDIR}/X-BlackArch-footer.tmpl" >> X-BlackArch.menu
    	echo "    </Menu>
</Menu>" >> X-BlackArch.menu


    return 0
}


blackarch_menu_entry()
{

    group=`echo $1 | sed -re 's/\-(.)/-\U\1\E/g' | sed -re 's/^(.)/\U\1\E/'`
    group2=`echo $group | tr -s '-' ' '`
    
    

    echo -n "		<!-- Begin of $group2 -->
		<Menu>
			<Name>$group2</Name>
			<Directory>BlackArch-$group.directory</Directory>
			<Include>
				<Category>X-BlackArch-$group</Category>
			</Include>

		" >> X-BlackArch.menu

    return 0
}


blackarch_submenu_entry()
{
    group=`echo $1 | sed -re 's/\-(.)/-\U\1\E/g' | sed -re 's/^(.)/\U\1\E/' | sed -re 's/Blackarch-//'`
    group2=`echo $group | sed -re 's/Blackarch-//' | tr -s '-' ' '`

    echo -n "			<!-- Begin of $group2 -->
			<Menu>
				<Name>$group2</Name>
				<Directory>BlackArch-$group.directory</Directory>
				<Include>
					<Category>X-BlackArch-$group</Category>
				</Include>

			" >> X-BlackArch.menu

    return 0
}



make_menus()
{

	blackarch_menu_entry _Asserted
    for gr in ${_GROUPS}

    do
	if ! grep -q "^blackarch-$gr$" .temp
	then
            blackarch_menu_entry $gr
            echo "</Menu>" >> X-BlackArch.menu
	fi
        
    done
    echo "	</Menu>" >> X-BlackArch.menu

    return 0
}

select_group()
{
    for i in "${DIRECTORIES[@]}";
    do
        DIR="$i[@]"
        blackarch_menu_entry $i
        for j in "${!DIR}"
        do
	    echo $j >> .temp
    	    blackarch_submenu_entry $j
    	    
    	    echo "</Menu>" >> X-BlackArch.menu
    	done
	echo "		</Menu>" >> X-BlackArch.menu	
    done 
}

make_blackarch_menu_header
select_group
make_menus
make_blackarch_menu_footer
rm .temp
