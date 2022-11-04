 #! /bin/bash
#Installing neccesary pagkages
printf "Welcome ${USER}.\n
Happy to see you! <-_->\n
[^]Just making sure you have the necessary pagkages\n"
#sleep 2
#sudo apt install vnstat
#sudo apt install sysstat
#Welcome Messages
printf ' \n [!] Hello Sir, my name is Jarvis\n'
printf " [!] I'm your personal assistant!!\n"
printf '======================================\n\n'
printf "[+] Date: $(date)\n\n"

printf '======================================\n\n'
printf '[!] What can i do for you today?\n\n'

RED='\033[0;31m'
NORMAL='\033[0m'


#this is the function that displays and operates the status menu
function getStatus(){
	#inside menu
	printf '======================================\n\n'
	echo "1) Load Average"
	echo "2) Current Cpu & Memory Usage"
	echo "3) Network Bandwith"
	echo "4) Back to main menu"
	#printf '\n\n======================================\n'
	
	read command
	
	case "$command" in
		"1") printf "Load AVG: $(cat /proc/loadavg) \n "
		#printf '======================================\n\n'
		getStatus;;
		"2")
		#Showing the cpu state
		printf "\n${RED}Current Cpu State:\n${NORMAL}"
		#Cpu utilization is 100-idle_time so we take it from vmstat
		echo "[+]CPU Utilization: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
		printf "\n\n"
		#showing the memory usage
		printf "${RED}Memory Usage:\n${NORMAL}"
		#Memory usage printing the $3/$2 columns * 100
		echo "[+]Memory Usage: "$(free | grep Mem | awk '{print $3/$2 * 100}') "%"
		getStatus;;
		#free ;;
		"3") vnstat
		getStatus;;
		"4") startMenu;;
		*) printf "Please enter a valid option of the menu \n" 
		getStatus;;
		
	esac
	
	
}





#this is the function that displays and operates the update menu
function doINeedUpdate(){
	echo "This is your result Sir:"
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
	"3") echo "You choose update";;
	"4") echo "You choose service";;
	"5") echo "You choose storage";;
	"6") echo "[-]Have a good day Sir!";;
	*) printf "\n\n${RED}You must whoose one of the above, Try again ${NORMAL}"
	printf '\n=====================================\n\n'
	startMenu;;
esac
}


startMenu





