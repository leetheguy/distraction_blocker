; Script Function:
;	This script kills time sucking games and other distractions.
;	It is meant to be started and stopped via the Task Scheduler only.
;	It has built in protection to discourage you from disabling it directly.
;	And it stops you from being able to stop it with Task Scheduler.
;	The only way to kill it when it's running (that I know of) is via the Task Manager and that can be disabled as well.
;
;	Full instructions can be found at: https://github.com/leetheguy/distraction_blocker
;
; License:
;	The MIT License (MIT)
;
;	Copyright (c) 2014 Lee Nathan
;
;	Permission is hereby granted, free of charge, to any person obtaining a copy
;	of this software and associated documentation files (the "Software"), to deal
;	in the Software without restriction, including without limitation the rights
;	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;	copies of the Software, and to permit persons to whom the Software is
;	furnished to do so, subject to the following conditions:
;
;	The above copyright notice and this permission notice shall be included in
;	all copies or substantial portions of the Software.
;
;	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;	THE SOFTWARE.

#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance ignore       ; disallows multiple instances of this script - very important since the task scheduler is set to rerun this script every minute
#NoTrayIcon                  ; Makes script invisible. (I'm invisible! No, I can see you, you're just not wearing any pants.)

; restore the hosts file to the state it was in before the script ran
OnExit, reset_hosts

; this is the list of websites you want redirected
sites =
(

127.0.0.1 jayisgames.com
127.0.0.1 www.kongregate.com
127.0.0.1 steampowered.com
)

; find the hosts file and make a backup
EnvGet, hosts, SYSTEMROOT
hosts = %hosts%\system32\drivers\etc
FileCopy,   %hosts%\hosts, %hosts%\hosts.bak, 1

; add the list of sites to the hosts file
FileAppend, %sites%, %hosts%\hosts

Loop
{
; this is to keep you from trying to disable the scheduled events you've set up to run this script
	IfWinExist, Task Scheduler
		WinKill, Task Scheduler

; duplicate and modify the next 2 lines to kill other programs
	IfWinExist, Popcorn Time
		WinKill, Popcorn Time

	IfWinExist, Steam
; this windows command kills steam and any games that were launched through steam
		Run, cmd /c taskkill /IM steam* /F /T

; uncomment the Task Manager killer below to make this script unkillable without reboot
; this way lies madness!
; should only be done when you're positive you have everything set up right
;
; This is very dangerous because if your task scheduler is running it should fire this script up again before you've had a chance to stop things.
; At that point the only way to kill this thing is from the command line. So if you're a Windows sys admin, you may want to kill that as well. :P
; Be warned that your hosts file won't be reset if you kill this script with the Task Manager.
;
; no guarantees that my code is perfect either
; 
;	IfWinExist, Windows Task Manager
;		WinKill, Windows Task Manager

; only run once every 5 seconds to reduce CPU usage and other problems
	sleep 5000
}

; this method replaces the hosts file with the backup
reset_hosts:
	FileCopy, %hosts%\hosts.bak, %hosts%\hosts, 1
	ExitApp
	return

