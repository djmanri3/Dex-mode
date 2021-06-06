#! /bin/bash
function ProgressBar {
        # Process data
        let _progress=(${1}*100/${2}*100)/100
        let _done=(${_progress}*4)/10
        let _left=40-$_done
        # Build progressbar string lengths
        _done=$(printf "%${_done}s")
        _left=$(printf "%${_left}s")

        printf "\rProgress : [${_done// /#}${_left// /-}] ${_progress}%%"
}

if [ -f "/bin/scrcpy" ]
then
	echo "- SCRCPY is installed"
else
	sudo apt update && sudo apt install scrcpy
fi

if [ -f "/bin/adb"  ]
then
	echo "- ADB is installed"
else
	sudo apt update && sudo apt install android-tools-adb
fi

if [ -f "/bin/vlc"  ]
then
        echo "- VLC is installed"
else
        sudo apt update && sudo apt install vlc
fi



sleep 0.5
clear

echo "  Desktop to android  "
echo "- Credits to DJMANRI3  "
echo ""
echo " ======================= "
echo "=                       ="
echo "= - c - Connect manualy ="
echo "= - s - Setup           ="
echo "= - u - usb connection  ="
echo "= - q - Quit            ="
echo "=                       ="
echo " =======================  "
read -p ": " o

case $o in
	c)
		read -p "IP address: " device
		read -p "Introduzca una dpi (vacia por defecto): " densitymod
	;;
	s)
		echo "Is necesary: "
		echo ""
		echo "- Andorid > 6"
		echo "- Install Taskbar"
		echo "- Android in the same network"
		echo "- Activate adb debug and debug wireless (not cable)"
		echo "- Needed root for SecondScreen for force desktop mode (change default launcher for Taskbar launcher)"
		echo
		echo "THIS PROCESS INSTALL: "
		echo "- Taskbar"
		echo "- SecondScreen"
		echo
		read -p "- Do you initial process (y=yes): " apk
		if [ $apk == y ]
		then
			echo
			echo "- Activate adb debug in your device and connect usb"
			read -p "Press enter to continue..."
			echo

			end=10
			for i in {0..10} 
			do
				sleep 0.1
				ProgressBar ${i} ${end}

			if [ $i = 3 ]
			then
				# adb commands
				echo
				adb install "./SecondScreen-2.9.2.apk"
				adb install "./Taskbar-6.1.1.apk"
				adb shell settings put global enablefreeformsupport 1
				adb shell pm grant com.farmerbb.secondscreen.free android.permission.WRITE_SECURE_SETTINGS
			fi

			if [ $i = 4 ]
			then
				cd audio/
				bash sndcpy
				cd .. & cd ..
				echo
			fi
	
			if [ $i = 5 ]
			then
				echo
				echo
				echo "======================================================================================== "
				echo "Please open Taskbar and activate MODE WINDOWS FREE and AVANCED OPTIONS REMPLACE LAUNCHER "
				echo "======================================================================================== "
				sleep 2
				echo
				read -p "- Necesary reboot the device please press enter to reboot.. " 			
				adb reboot now
				echo
			fi
			done
			echo ""
			echo ""
			echo "========================================================="
			echo "When devide is restarted create a profile in SecondScreen"
			echo "========================================================="
			echo
			read -p "- Press enter when device is restarted to try connect..."
			clear
		fi	
	;;
	u)
		read -p "- Press enter after Connect cable USB..." 

	;;

	q)
		exit
	;;
esac

if [ -z $device ];
then
	densitymod="240"
	echo
	echo " ============== "
	echo " = USB CONECT = "
	echo " ============== "
	echo	
else
	adb connect $device":5555"
fi
	echo " ================= "
	echo " = Conecting...  ="
	echo " ================= "
	echo ""
	clear
		
	end=10
	for i in {0..10} 
	do
		sleep 0.1
		ProgressBar ${i} ${end}


	if [ $i == 5 ]
	then
		echo
		#adb shell wm density $densitymod > /dev/null
	
		# audio	
		adb forward tcp:2280 localabstract:sndcpy
		adb shell am start com.rom1v.sndcpy/.MainActivity
		clear
	fi
	if [ $i == 6 ]
	then
		echo ""
		echo ""
		echo " ========================================================== "
		read -p "= Please press start cast  in your phone and press enter... ="
		nohup cvlc -Idummy --demux rawaud --network-caching=50 --play-and-exit tcp://localhost:2280 &
	fi
	if [ $i == 7 ]
	then
		clear
		#sleep 1
		adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0 > /dev/null
		adb shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:1 > /dev/null
		adb shell am kill-all
		adb shell input keyevent 164
	fi

	if [ $i == 9 ]
	then
		nohup scrcpy -S &
		echo ""
		clear
	fi


	if [ $i == 10 ]
	then
		echo ""
		echo ""
		echo "====================================================================="
		echo "if you use taskbar, necesary close all apps, for open apps in windows"
		echo "====================================================================="
		echo ""
		echo ""
	fi
	
	done


	echo
	echo " ============================== "
	read -p "= Press enter to disconnect... ="
	#scrcpy > /dev/null

	#adb shell am start com.rom1v.sndcpy/.MainActivity

	adb shell wm density reset
	adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:1
	sleep 1
	adb shell input keyevent 164


	adb kill-server
	rm -rf nohup.out
