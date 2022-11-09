 #! /bin/bash
 

#Color Defines 
RED='\033[0;31m'
NORMAL='\033[0m'
YELLOW='\033[1;33m'
BOLD=`tput bold`




#Welcome Messages
#Installing neccesary pagkages


printf "Welcome ${USER}.\n

Happy to see you! <-_->\n\n"
printf "\n[!] My name is ${BOLD}Jarvis\n"
printf "[!] I'm your personal assistant!!\n"
printf "${RED}[+]Just making sure you have the necessary pagkages\n${NORMAL}"
#echo -ne '#####                     (33%)\r'
#sleep 1
#echo -ne '#############             (66%)\r'
#sleep 1
#echo -ne '#######################   (100%)\r'
#echo -ne '\n'
#sleep 2
#sudo apt install vnstat
#sudo apt install sysstat
#sudo apt install htop


#Date info
printf '======================================\n\n'
printf "[+] Date: $(date +"%Y-%m-%d, %H:%M:%s")\n\n"
printf "Made by ${BOLD}Solas${NORMAL} \n"


printf '======================================\n\n'
printf '[!] What can i do for you today?\n\n'






#this is the function that displays and operates the status menu
function getStatus(){
	#inside menu
	printf '\n======================================\n\n'
	echo "1) Load Average"
	echo "2) Current Cpu & Memory Usage"
	echo "3) Network Bandwidth"
	echo "4) Disk Utilization"
	echo "5) Back to main menu"
	#printf '\n\n======================================\n'

	read command

	case "$command" in
		"1")
		#prints the 3first columns of loadavg 
		printf "${YELLOW}[+]Load AVG: $(awk '{print $1 ", "$2 ", " $3}' /proc/loadavg) \n ${NORMAL} "
		getStatus;;
		"2")
		#Cpu utilization is 100-idle_time so we take it from vmstat
		printf "${YELLOW}[+]CPU Utilization: "
		echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')]'%'
		echo 
		printf "${NORMAL}"
		printf "\n"
		#showing the memory usage
		#printf "${YELLOW}[+]Memory Usage:\n${NORMAL}"
		#Memory usage printing the $3/$2 columns * 100
		printf "${YELLOW}[+]Memory Usage:"
		#echo $(free | grep Mem | awk '{print $3/$2 * 100}')'%'
		res=$(free | grep Mem | awk '{print $3/$2 * 100}')
		printf "%0.5s%%"  "$res"
		printf "${NORMAL}"
		
		getStatus;;
		#free ;;
		"3") 
		#showing top 5 days
		printf "${YELLOW}[+]Network Bandwidth: \n $(vnstat -t) ${NORMAL}"
		getStatus;;
		"4")printf "${YELLOW}\n[+]Disk percentage usage:\n"
		df -hl |grep '/sda' |awk '{print $1":"$5}'
		printf "${NORMAL}"
		getStatus
		;;
		"5") startMenu;;
		*) printf "${RED}Please enter a valid option of the menu ${NORMAL} \n"
		getStatus;;

	esac


}

#this is the function i use for updating packages if the user wants to
function updateAll(){

		printf "${RED}[!]Do you want me to install all the updates? (Y/N):${NORMAL}"


		read updateCommand
		case "$updateCommand" in
			"y"|"Y")
			#Asking if you want to install all the available packages pending for update
			printf "${YELLOW}[!]This probably take some time!! \n"
			#Installing the new versions
			sudo apt upgrade
			printf "\n[!]Let's see how many didn't managed to update!\n"
			#Displaying the rest that didn't manage to update
			apt list --upgradable
			printf "${NORMAL}\n"
			doINeedUpdate;;
			"n"|"N")
			echo "Do you need something else from here Sir?"
			doINeedUpdate;;
			*)echo "${RED}[-]Yes or No Please! ${NORMAL}"
			updateAll;;
		esac
}


#this function is used for os-update check
function checkOsVersion(){
printf "${RED}[+]Are you sure you want to update the OS Version? (Y/N):${NORMAL}"
		read answer
		case "$answer" in
			"y"|"Y")
			#open os-updater
			sudo update-manager –devel-release;;
			"n"|"N")printf "${YELLOW}[-]Your choise ${USER} ${NORMAL}\n";;
			*)printf "${RED}[-]Wrong input"$?
			checkOsVersion;;
			esac
}


#systemctl --all list-units --type=service -n 100

 #systemctl show vgauth.service |grep 'SubState'
#this is the function that displays and operates the update menu
function doINeedUpdate(){
	#inside menu
	printf '======================================\n\n'
	echo "1) Which package require update"
	echo "2) Update to newer OS version"
	echo "3) Check for new Kernel Version"
	echo "4) Back to main menu"

	read command
	case "$command" in
		"1")apt list --upgradable
		updateAll
		;;
		"2")		
		checkOsVersion
		doINeedUpdate;;
		"3")printf "${YELLOW}Current Kernel Version:"
		#showing current kernel infos
		uname -srv
		
		#sleep 2
		#check for new kernel version
		s=$(uname -v)
		#if [["$s" != "6.0.7" ]]
		#then
		#xdg-open 'https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.0.7.tar.xz'
		#else printf "You have the latest Kernel Version!"
		#fi
		printf "${NORMAL}\n"
		doINeedUpdate
		;;
		"4")printf "\nAs you wished ${USER} \n"
		startMenu;;
	esac
}



#this is the function that displays and operates the who menu
function whoIsWho(){
	#inside menu
	printf '======================================\n\n'
	echo "1) Current loged-in users"
	echo "2) How many are loged in the same User Account"
	echo "3) top -u solas -b | awk '{print $1 "     "$2"       "$9"       "$10}' "

	echo "3) Back to main menu"
	#printf '\n\n======================================\n'

	read command

	case "$command" in
		"1")
		printf "${YELLOW}Current loged-in User:\n"
		#showing only the name of the user
		who | awk '{print $1}'
		printf "${NORMAL}\n "
		whoIsWho;;
		"2") 
		#showing only 2 columns of the w command to be more readable
		printf "${YELLOW}Loged-in Users in the same UA:\n"
		w -h | awk '{print "User:"$1 ",   Loged-Time:"  $4}'
		printf "${NORMAL}\n "
		whoIsWho;;
		"3") startMenu;;
		*) "Please enter a valid option of the menu"
		whoIsWho;;

	esac
}


#this function operates the storage case
function getStorage(){
	#inside menu
	printf '======================================\n\n'
	echo "1) List all disks partitions and mount points"
	echo "2) Check unmounted entries from the fstab"
	echo "3) Show UUID of the partitions"
	echo "4) Space you are using"
	echo "5) Back to main menu"
	#printf '\n\n======================================\n'

	read command

	case "$command" in
		"1")
		#list with all disk part and mount points , showing with specific order the columns
		printf "${YELLOW} Result:\n"
		lsblk -fs -o NAME,MOUNTPOINTS
		printf "\n ${NORMAL}\n "
		getStorage;;
		"2")
		printf "${YELLOW} Result:\n"
		 cat /etc/fstab | grep "remount"
		 printf "\n ${NORMAL}\n "
		 getStorage
		;;
		"3") 
		printf "${YELLOW} Result:\n"
		lsblk -fs -o NAME,UUID
		printf "\n ${NORMAL}\n "
		getStorage;;
		"4") 
		printf "${YELLOW} Result:\n"
		lsblk -fs -o NAME,FSUSE%
		# | grep "sda"
		printf "\n ${NORMAL}\n "
		getStorage;;
		"5") startMenu;;
		*) "Please enter a valid option of the menu"
		whoIsWho;;

	esac
}

#function operation Services menu
function getServiceStatus(){
	#checking if the user wants to display all the services
	printf "${RED}Display Service names for input??: (Y/N)"
	read displayService
	case "$displayService" in
		"y"|"Y")
		#showing all services in the system
		printf "${YELLOW} $(systemctl list-units --type=service --all)"
		printf "\n ${NORMAL}\n ";;
		"n"|"N") 
		# ":" is working like break
		: ;;
		*);;
	esac
	
	#Input the services you want to see the status
	printf "${RED}\nInput service name you want to check status: ${NORMAL}"
	read serviceName
	#checking if the service exists.
	if systemctl list-units --type=service --all | grep -q "$serviceName"
	then
   		 printf "${YELLOW} $serviceName exists.\n"
   		 #checking the status of the service
   		 service $serviceName status | grep "Active"
   		 printf "\n ${NORMAL}\n "
   		 
   		 #Picking the operation you want to input in the service.
	printf "[+]Input an operation for the service:\n"
	printf "${YELLOW}[Start(1) / Stop(2) / Restart(3) / Nothing(4)]\n${NORMAL}"
	read operation
		
	case "$operation" in
		"start"|"Start"|"START"|"1")printf "${YELLOW}[+]Trying to start $serviceName ...${NORMAL}"
		service $serviceName start
		$?;;
		"stop"|"Stop"|"STOP"|"2")printf "${YELLOW}[+]Trying to stop $serviceName ...${NORMAL}"
		service $serviceName stop
		$?;;
		"restart"|"Restart"|"RESTART"|"3")printf "${YELLOW}[+]Trying to restart $serviceName ...${NORMAL}"
		service $serviceName restart
		$?;;
		"nothing"|"Nothing"|"NOTHING"|"4")printf "${YELLOW}[-]We do nothing with $serviceName ...${NORMAL}"
		$?;;
		*) printf "${RED}[!]I can not operate in the service.";;
	esac
	else
    		echo "$serviceName service does NOT exist."
	fi
	
	
	
}

#this is the function that displays the starting menu for the user
function startMenu(){
printf "${YELLOW}=====================================${NORMAL}\n"
echo "1) status"
echo "2) who"
echo "3) update"
echo "4) service"
echo "5) storage"
echo "6) exit"

read command


case "$command" in
	"1") getStatus;;
	"2") whoIsWho;;
	"3") doINeedUpdate;;
	"4") getServiceStatus;;
	"5") getStorage;;
	"6") echo "[-]Have a good day ${USER} !";;
	*)
	#if you choose any other than the above, restarting  the start menu
	printf "\n\n${RED}You must whoose one of the above, Try again ${NORMAL}"
	printf '\n=====================================\n\n'
	startMenu;;
esac
}

#start the program
startMenu





