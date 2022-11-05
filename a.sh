 #! /bin/bash
#Installing neccesary pagkages
printf "Welcome ${USER}.\n

Happy to see you! <-_->\n\n"
printf ' \n [!] My name is Jarvis\n'
printf " [!] I'm your personal assistant!!\n"
printf '[+]Just making sure you have the necessary pagkages\n'
#sleep 2
#sudo apt install vnstat
#sudo apt install sysstat
#Welcome Messages


printf '======================================\n\n'
printf "[+] Date: $(date +"%Y-%m-%d, %H:%M:%s")\n\n"

printf '======================================\n\n'
printf '[!] What can i do for you today?\n\n'

RED='\033[0;31m'
NORMAL='\033[0m'
YELLOW='\033[1;33m'


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
		#Showing the cpu state
		printf "\n${YELLOW}[+]Current Cpu State:\n${NORMAL}"
		#Cpu utilization is 100-idle_time so we take it from vmstat
		echo "[+]CPU Utilization: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
		printf "\n\n"
		#showing the memory usage
		#printf "${YELLOW}[+]Memory Usage:\n${NORMAL}"
		#Memory usage printing the $3/$2 columns * 100
		printf "${YELLOW}[+]Memory Usage: $(free | grep Mem | awk '{print $3/$2 * 100}')% ${NORMAL} \n"
		
		getStatus;;
		#free ;;
		"3") 
		printf "${YELLOW}[+]Network Bandwidth: \n $(vnstat) ${NORMAL}"
		getStatus;;
		"4")printf '\n[+]Disk percentage usage:\n'
		df -hl |grep '/sda' |awk '{print $1":"$5}'
		getStatus
		;;
		"5") startMenu;;
		*) printf "Please enter a valid option of the menu \n"
		getStatus;;

	esac


}

#this is the function i use for updating packages if the user wants to
function updateAll(){

		echo "Do you want me to install all the updates? (Y/N):"


		read updateCommand
		case "$updateCommand" in
			"y"|"Y")
			#Asking if you want to install all the available packages pending for update
			echo "[!]This probably take some time!!"
			#Installing the new versions
			sudo apt upgrade
			echo "[!]Let's see how many managed to updated!"
			#Displaying the rest that didn't manage to update
			apt list --upgradable;;
			"n"|"N")
			echo "Do you need something else from here Sir?"
			doINeedUpdate;;
			*)echo "${RED}[-]Yes or No Please! ${NORMAL}"
			updateAll;;
		esac
}


#this is the function that displays and operates the update menu
function doINeedUpdate(){
	#inside menu
	printf '======================================\n\n'
	echo "1) Which package require update"
	echo "2) Update to newer OS version"
	echo "3) Back to main menu"

	read command
	case "$command" in
		"1")apt list --upgradable
		updateAll
		;;
		"2");;
		"3")printf "\nAs you wished ${USER} \n"
		startMenu;;
	esac
}



#this is the function that displays and operates the who menu
function whoIsWho(){
	#inside menu
	printf '======================================\n\n'
	echo "1) Current loged-in users"
	echo "2) How many are loged in the same User Account"
	echo "3) Back to main menu"
	#printf '\n\n======================================\n'

	read command

	case "$command" in
		"1")who
		printf "\n "
		whoIsWho;;
		"2") w -h
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
		lsblk -fs -o NAME,MOUNTPOINTS
		printf "\n "
		getStorage;;
		"2") cat /etc/fstab
		;;
		"3") lsblk -fs -o NAME,UUID
		getStorage;;
		"4") lsblk -fs -o NAME,FSUSE%;;
		"5") startMenu;;
		*) "Please enter a valid option of the menu"
		whoIsWho;;

	esac
}

#this is the function that displays the starting menu for the user
function startMenu(){
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
	"4") echo "You choose service";;
	"5") getStorage;;
	"6") echo "[-]Have a good day ${USER} !";;
	*)
	#if you choose any other than the above, restarting  the start menu
	printf "\n\n${RED}You must whoose one of the above, Try again ${NORMAL}"
	printf '\n=====================================\n\n'
	startMenu;;
esac
}


startMenu





