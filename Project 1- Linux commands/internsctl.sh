getHelp () {
	cat /usr/bin/helpPage.txt
}
getVersionInfo () {

	echo "Command name - internsctl"
	echo "Command version - v0.1.0"
	printf "\nWritten by Krishna Mandhane.\n"
}
getCpuInfo () {
	lscpu
}
getMemoryInfo () {
	free
}
createUser () {
	sudo adduser $3
}
getUsers () {
	cut -d: -f1 /etc/passwd
}
getSudoUsers () {
	getent group sudo | cut -d: -f4
}
getFileInfo () {
	if test -f "$3"; then
		echo "File: $3"
		displayPermissions() {
			case "$1" in
				0) echo "no";;
				1) echo "--x";;
				2) echo "-w-";;
				3) echo "-wx";;
				4) echo "r--";;
				5) echo "r-x";;
				6) echo "rw-";;
				7) echo "rwx";;
		  	esac
		}
		permissions=$(stat -c%a "$3")
		user=${permissions:0:1}
		group=${permissions:1:1}
		others=${permissions:2:1}
		echo "Access: -$(displayPermissions $user)$(displayPermissions $group)$(displayPermissions $others)"		
		myFileSize=$(wc -c $3 | awk '{print $1}')
		echo "Size(B): $myFileSize"		
		echo "Owner: $(stat -c '%U' $3)"		
	else
		echo "internsctl: cannot access '$3': No such file in current directory"
	fi	
}
getSpecificFileInfo () {
case "$3" in
	--size | -s)	
		if test -f "$4"; then
			myFileSize=$(wc -c $4 | awk '{print $1}')
			if [ $myFileSize -ge 1000 ]; then
				myFileSize=$(echo "$myFileSize * 0.001"|bc)
				printf "%.2f kilobytes\n" $myFileSize
			else
				echo "$myFileSize bytes"
			fi
		else
			echo "internsctl: cannot access '$4': No such file in current directory"
		fi ;;
	
	"--permissions" | "-p")
		if test -f "$4"; then
			displayPermissions() {
				case "$1" in
					0) echo "no";;
					1) echo "--x";;
					2) echo "-w-";;
					3) echo "-wx";;
					4) echo "r--";;
					5) echo "r-x";;
					6) echo "rw-";;
					7) echo "rwx";;
			  	esac
			}
			permissions=$(stat -c%a "$4")
			user=${permissions:0:1}
			group=${permissions:1:1}
			others=${permissions:2:1}
			echo "-$(displayPermissions $user)$(displayPermissions $group)$(displayPermissions $others)"
		else
			echo "internsctl: cannot access '$4': No such file in current directory"
		fi ;;
	
	"--owner" | "-o")
		if test -f "$4"; then
			echo "$(stat -c '%U' $4)"
		else
			echo "internsctl: cannot access '$4': No such file in current directory"
		fi ;;
	
	"--last-modified" | "-m")
		if test -f "$4"; then
			echo "$(stat -c '%y' $4)"
		else
			echo "internsctl: cannot access '$4': No such file in current directory"
		fi ;;
	
	*)
		if [ "${3:0:1}" = "-" ]; then
			echo "internsctl: invalid option"
			printf "\nUsage:\n internsctl file getinfo [options] <file-name>\n"
			printf "\nTry 'internsctl --help' for more information.\n"
		else
			printf "error: too many arguments\n"
			printf "\nUsage:\n internsctl file getinfo <file-name>\n"
			printf "\n Try 'internsctl --help' for additional help text.\n"
		fi ;;
esac
}

driver_function () {
if [ "$1" == "--help" ] && [ -z "$3" ]
then
        getHelp
        exit 1
fi
if [ "$1" == "--version" ] && [ -z "$3" ]
then
        getVersionInfo
        exit 1
fi
if [ "$1" == "file" ] && [ "$2" == "getinfo" ] && [ ! -z "$3" ] && [ ! -z "$4" ] && [ -z "$5" ]
then
        getSpecificFileInfo $1 $2 $3 $4
        exit 1
elif [ "$1" == "file" ] && [ "$2" == "getinfo" ] && [ ! -z "$3" ] && [ ! -z "$4" ] && [ ! -z "$5" ]
then
	echo "error: too many arguments"
	printf "\nUsage:\n internsctl file getinfo [options] <file-name>\n"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
fi
if [ "$1" == "user" ] && [ "$2" == "list" ] && [ "$3" == "--sudo-only" ] && [ -z "$4" ]
then
        getSudoUsers
        exit 1
elif [ "$1" == "user" ] && [ "$2" == "list" ] && [ "$3" == "--sudo-only" ] && [ ! -z "$4" ]
then
	echo "error: too many arguments"
	printf "\nUsage:\n internsctl user list [options]\n"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
elif [ "$1" == "user" ] && [ "$2" == "list" ] && [ ! -z "$3" ] && [ -z "$4" ]
then
	echo "internsctl: invalid option"
	printf "\nUsage:\n internsctl user list [options]\n"
	printf "\nTry 'internsctl --help' for more information.\n"
	exit 1
fi
if [ "$1" == "user" ] && [ "$2" == "list" ] && [ -z "$3" ]
then
        getUsers
        exit 1
elif [ "$1" == "user" ] && [ "$2" == "list" ] && [ ! -z "$3" ]
then
	echo "error: too many arguments"
	printf "\nUsage:\n internsctl user list\n"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
fi
if [ "$1" == "memory" ] && [ "$2" == "getinfo" ] && [ -z "$3" ]
then
        getMemoryInfo
        exit 1
elif [ "$1" == "memory" ] && [ "$2" == "getinfo" ] && [ ! -z "$3" ]
then
	echo "error: too many arguments"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
fi
if [ "$1" == "cpu" ] && [ "$2" == "getinfo" ] && [ -z "$3" ]
then
        getCpuInfo
        exit 1
elif [ "$1" == "cpu" ] && [ "$2" == "getinfo" ] && [ ! -z "$3" ]
then
	echo "error: too many arguments"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
fi
if [ "$1" == "file" ] && [ "$2" == "getinfo" ] && [ ! -z "$3" ] && [ -z "$4" ]
then
        getFileInfo $1 $2 $3
        exit 1
elif [ "$1" == "file" ] && [ "$2" == "getinfo" ] && [ ! -z "$3" ] && [ ! -z "$4" ]
then
	echo "error: too many arguments"
	printf "\nUsage:\n internsctl file getinfo <file-name>\n"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
fi
if [ "$1" == "user" ] && [ "$2" == "create" ] && [ ! -z "$3" ] && [ -z "$4" ]
then
        createUser $1 $2 $3
        exit 1
elif [ "$1" == "file" ] && [ "$2" == "getinfo" ] && [ ! -z "$3" ] && [ ! -z "$4" ]
then
	echo "error: too many arguments"
	printf "\nUsage:\n internsctl user create <username>\n"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
fi
	printf "\nUsage:\n"
	printf " internsctl cpu getinfo\n"
	printf " internsctl memory getinfo\n"
	printf " internsctl user create <username>\n"
	printf " internsctl user list\n"
	printf " internsctl user list --sudo-only\n"
	printf " internsctl file getinfo <file-name>\n"
	printf " internsctl file getinfo [options] <file-name>\n"
	printf "\n Try 'internsctl --help' for additional help text.\n"
	exit 1
}

driver_function $1 $2 $3 $4 $5