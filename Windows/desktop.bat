@echo off
cls
title Desktop android -- MANRI

if not defined ADB set ADB=adb
if not defined VLC set VLC="C:\Program Files\VideoLAN\VLC\vlc.exe"
if not defined SNDCPY_APK set SNDCPY_APK=sndcpy.apk
if not defined SNDCPY_PORT set SNDCPY_PORT=28200


echo   Desktop to android 
echo - Credits to DJMANRI3
echo ----------------------------
echo  ======================= 
echo =                       =
echo = - 0 - Prepare device  =
echo = - 1 - Device 1        =
echo = - 2 - Device 2        =
echo =                       =
echo  ======================= 
echo =                       =
echo = - c - Connect manualy =
echo = - s - Setup           =
echo = - u - usb connection  =
echo = - q - Quit            =
echo =                       =
echo  =======================  

set/p o=:

if %o%==0 (
	echo - Connect your device... 5 sec
	set/p null=Press enter... 
	adb tcpip 5555
	echo - Disconect your device...
)

if %o%==1 (
	
	set device="192.168.100.17"
	set densitymod="200"

)
if %o%==2 (
	
	set device="192.168.100.36"
	set densitymod="120"

	
)
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
	::set densitymod=240
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
	cls
    echo  ================= 
	echo  = Conecting...  =
	echo  ================= 

	echo "prepare terminal - progress : [#---------------------------------] 5%"
	timeout /t 1 /nobreak >nul
	
	:: settings: landscape, dpi, volumen mute in the phone
	cls
    echo  ================= 
	echo  = Conecting...  =
	echo  ================= 
	echo "prepare terminal - progress : [#############---------------------] 50%"
	timeout /t 1 /nobreak >nul
	
	adb shell wm density %densitymod%
	adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0
	adb shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:1
	adb shell input keyevent 164
	
	::Enable audio
	cls
    echo  ================= 
	echo  = Conecting...  =
	echo  ================= 
	echo "prepare terminal - progress : [#########################---------] 70%"
	timeout /t 1 /nobreak >nul
	
	%ADB% %serial% forward tcp:%SNDCPY_PORT% localabstract:sndcpy || goto :error
	%ADB% %serial% shell am start com.rom1v.sndcpy/.MainActivity || goto :error
	
	::start CMD /c %VLC% -Idummy --demux rawaud --network-caching=50 --play-and-exit tcp://localhost:%SNDCPY_PORT%
	cls
    echo  ================= 
	echo  = Conecting...  =
	echo  ================= 
	echo "prepare terminal - progress : [#################################--] 90%"
	timeout /t 1 /nobreak >nul
	
	START /B CMD /c %VLC% -Idummy --demux rawaud --network-caching=50 --play-and-exit tcp://localhost:%SNDCPY_PORT% 2>&1

	:: start screen mirroring
	cls
    echo  ================= 
	echo  = Conecting...  =
	echo  ================= 
	echo "progress : [###################################] 100%"
	timeout /t 1 /nobreak >nul
	
	
	echo =====================================================================
	echo if you use taskbar, necesary close all apps, for open apps in windows
	echo =====================================================================
	echo EXIT FULL SCREEN ALT + F
	echo -------------------------
	
    echo ---------------------
	echo ---------------------
	
	scrcpy -Sf
	echo ---------------------
	
	:: Restore config
	cls
	echo Restore config of device...
	echo ----------------------------
	cls
	echo "reset config - progress : [###########################--------] 75%"
	timeout /t 1 /nobreak >nul

	REM adb shell wm density reset
	adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:1
	
	adb shell input keyevent 164

	cls
	echo "reset config - progress : [###############################----] 90%"
	timeout /t 1 /nobreak >nul
	
	adb kill-server
	taskkill /IM vlc.exe /f
	
	cls
	echo "reset config - progress : [###################################] 100%"
	timeout /t 1 /nobreak >nul
	exit

:fin