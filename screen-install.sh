#!/bin/bash

home="${HOME}";
num_start=$(grep -n '# add these lines to .bashrc' ${home}/.bashrc | cut -d: -f1);
num_end=$(grep -n '# end screen on SSH login' ${home}/.bashrc | cut -d: -f1);
columns=$(stty -a  | awk -F'[ ;]' '/columns/ { print $9 }')

function printLine {

	line='';
	for (( i = 0 ; i < $columns ; i++ ));do
		line="${line}#";
	done;
	echo $line;
}


function createFileScreenrc {
	if [[ -e "${home}/.screenrc" ]];then
		echo "File .screenrc is been";
	else	
		echo "File .screenrc is not been";
		wget https://raw.githubusercontent.com/doroshenkoSaac/screen-installer/main/src/.screenrc -P ${home};
		chmod u+x ${home}/.screenrc;
		#нужно отредактировать путь до юзера
		sed -i "s=full_home_path=${home}=g" ${home}/.screenrc
		echo "File .screenrc is created";
	fi
}


function createFileScreenrcGetuptime {

	if [[ -e "${home}/.screenrc-getuptime" ]];then
		echo "File .screenrc-getuptime is been";
	else
		echo "File .screenrc-getuptime is not been";
		wget https://raw.githubusercontent.com/doroshenkoSaac/screen-installer/main/src/.screenrc-getuptime -P ${home};
		chmod u+x ${home}/.screenrc-getuptime;
		echo "File .screenrc-getuptime is created";
	fi
}


function insertScreenConfigIntoBashrs {
	 
	if [[ $(grep -n "# add these lines to .bashrc" ${home}/.bashrc) ]]; then
		echo "Config for screen is been in file .bashrc";
	else
		echo "Config for screen is not been in file .bashrc";
		echo " не найденно записи в файле .bashrc. Нужно добавить";
		wget https://raw.githubusercontent.com/doroshenkoSaac/screen-installer/main/src/.bashrc  -O ->> ${home}/.bashrc 
		echo "" >> ${home}/.bashrc;
		echo "File .bashrc is edited";

	fi
}


function isInstalledScreen {

	if [[ $(rpm -qa| grep "screen") ]];then
		echo "screen is installed";
	else
		echo "screen is not installed";
		sudo yum -y install epel-release wget || exit;
		sudo yum -y install screen || exit;
	fi
}


function removeScreenConfigFromBashrs {

       echo "   Start to remove..."
        if [[ $(grep -n "# add these lines to .bashrc" ${home}/.bashrc) ]]; then
		sed -i "${num_start},${num_end}d" ${home}/.bashrc;
	fi

	if [[ -e "${home}/.screenrc-getuptime" ]];then
		$(rm ${home}/.screenrc-getuptime)|| echo "Can not remove .screenrc-getuptime";
        fi

	if [[ -e "${home}/.screenrc" ]];then
        	$(rm ${home}/.screenrc)|| echo "Can not remove .screenrc";
	fi
        echo "   Files is removed"
}


printLine;
echo "1) Install and configure screen in one click. You need have sudo yum install"
echo "2) Configure screen. create files .screenrc, .screen-getuptime in you home direcroy. Configure script will addden in your .bashrc"
echo "3) Remove all configure scripst"
read -p "Change your choice: " dosmth;
printLine;

case "${dosmth}" in
	1)
		isInstalledScreen;
		insertScreenConfigIntoBashrs;
		createFileScreenrcGetuptime;
		createFileScreenrc;
		;;	
	
	2)
		insertScreenConfigIntoBashrs;
		createFileScreenrcGetuptime;
		createFileScreenrc;
		;;
	
	3)
		removeScreenConfigFromBashrs
		;;

	*) echo "Restart script and make the right choice";
		;;
esac

echo "";
printLine;
echo "#   COMPLETE !!!";
printLine;

#printLine;
#isInstalledScreen;
#insertScreenConfigIntoBashrs
#createFileScreenrcGetuptime;
#createFileScreenrc;
#removeScreenConfigFromBashrs
