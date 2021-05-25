#! /bin/bash

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

sleep 1
clear

echo "  Desktop to android  "
echo "- Credits to DJMANRI3  "
echo ""
echo "========================="
echo "=    YouTube CHANEL     ="
echo "=      ROMS MANRI       ="
echo "========================="
echo ""
echo " ======================= "
echo "=                       ="
echo "= - 0 - Prepare device  ="
echo "= - 1 - Device 1        ="
echo "= - 2 - Device 2        ="
echo "=                       ="
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
	0)
		echo "- Connect your device... 5 sec"
		read -p "Press enter... "
		adb tcpip 5555
		echo "- Disconect your device..."

	;;

	1)
		device="ip address"
		densitymod="200"
	;;

	2)
		device="ip address"
		densitymod="120"
	;;

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

			# adb commands
			adb install "./SecondScreen-2.9.2.apk"
			adb install "./Taskbar-6.1.1.apk"
			adb shell settings put global enablefreeformsupport 1
			adb shell pm grant com.farmerbb.secondscreen.free android.permission.WRITE_SECURE_SETTINGS

			echo
			echo "======================================================================================== "
			echo "Please open Taskbar and activate MODE WINDOWS FREE and AVANCED OPTIONS REMPLACE LAUNCHER "
			echo "======================================================================================== "
			sleep 2
			echo
			read -p "- Necesary reboot the device please press enter to reboot.. "
			adb reboot now
			echo
			echo "========================================================="
			echo "When devide is restarted create a profile in SecondScreen"
			echo "========================================================="
			echo
			read -p "- Press enter when device is restarted to try connect..."
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

	echo "====================================================================="
	echo "if you use taskbar, necesary close all apps, for open apps in windows"
	echo "====================================================================="
	echo

	sleep 1
	adb shell wm density $densitymod
	adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0
	adb shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:1

	scrcpy -S &> /dev/tty2

	adb shell wm density reset
	adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:1


	adb kill-server
