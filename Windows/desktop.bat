@echo off
cls
title Desktop android -- MANRI

echo   Desktop to android 
echo - Credits to DJMANRI3
echo -----------------------------
echo = Youtube chanel ROMS MANRI =
echo -----------------------------
echo  ======================= 
echo =                       =
echo = - c - Connect manualy =
echo = - s - Setup           =
echo = - u - usb connection  =
echo = - q - Quit            =
echo =                       =
echo  =======================  

set/p o=:

if %o%==c (
	
	set/p device=IP address: 
	set/p densitymod=Write dpi: 
	
)
if %o%==s (
	echo Is necesary: 
	echo --------------------
	echo - Andorid more 6
	echo - Install Taskbar
	echo - Android in the same network
	echo - Activate adb debug and debug wireless not cable
	echo - Needed root for SecondScreen for force desktop mode change default launcher for Taskbar launcher
	echo ------------------------
	echo THIS PROCESS INSTALL: 
	echo - Taskbar
	echo - SecondScreen
	echo ------------------------
	set/p null=Press enter to install
	
		echo ------------------------------------------
		echo - Activate adb debug in your device and connect usb
		set/p null=Press enter to continue...
		adb install "./SecondScreen-2.9.2.apk"
		adb install "./Taskbar-6.1.1.apk"
		adb shell settings put global enablefreeformsupport 1
		adb shell pm grant com.farmerbb.secondscreen.free android.permission.WRITE_SECURE_SETTINGS
		echo -----------------------------------------
		echo ======================================================================================== 
		echo Please open Taskbar and activate MODE WINDOWS FREE and AVANCED OPTIONS REMPLACE LAUNCHER 
		echo ======================================================================================== 
		timeout /t 2
		echo
		set/p null=- Necesary reboot the device please press enter to reboot.. 
		adb reboot now
		echo -----------------------------------------
		echo =========================================================
		echo When devide is restarted create a profile in SecondScreen
		echo =========================================================
		echo -----------------------------------------
		set/p null=- Press enter when device is restarted to try connect...

)

if %o%==u (
	set/p null=- Press enter after connect cable USB...
	set densitymod=240
	echo ------------------
	echo  ============== 
	echo  = USB CONECT = 
	echo  ==============
	echo ------------------
)
if %o%==q (
	echo thanks used
	goto fin
)

    echo  ================= 
	echo  = Conecting...  =
	echo  ================= 

	echo =====================================================================
	echo if you use taskbar, necesary close all apps, for open apps in windows
	echo =====================================================================
	echo -----------------------------------
	
	echo EXIT FULL SCREEN ALT + F

	timeout /t 5
	adb shell wm density %densitymod%
	adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0
	adb shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:1

    echo ---------------------
	scrcpy -Sf
	echo ---------------------
	echo Reset dpi...

	adb shell wm density reset
	adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:1


	adb kill-server

:fin