clamav.bat
A Windows batch file used to manage clamav anti-virus software.
ClamAV is a free anti-virus software, but it offical not provide GUI for manage it. so I write one tool base windows console help me use it for better.

1.  OS version
   I test on Windows 7 and Windows 10 success, if you want use in Windows XP or older, you may need change "sleep N" to "ping -n N 127.0.0.1>NUL" to sleep N second
3. installation
   I suppose clamav path is: c:\clamav\clamav-1.0.1.win.x64\
   copy it to your clamav install path c:\clamav\, then add path to environment variable, set PATH=%PATH%;c:\clamav\
   now you can execute clamav.bat in a cmd.exe console.
   if you can't put it to c:\clamav\ , you need indicate path in clamav.bat:
   "
   set clamhome=%~dp0
   set clampath=%clamhome%\clamav-1.0.1.win.x64   <--------- change to your clamav install path
   "
4. first running
   install / uninstall , start/stop service need administrator permission, so I use "administrator" user for it, if you first run, it will prompt you input administrator password for cmd.exe's "runas" command call.
5. get help
    use "clamav.bat help" get all support command, and yes you can read .bat file directly if you learned cmd.exe batch file.
6. integrate to GUI explorer.
   make clamav.bat shortcut to %appdata%\Microsoft\Windows\SendTo, now select you want to scan file(s) or directory(s) and right click,pop up context menu, send to sub-menu, clamav.bat shortcut, now it's will call clamav to scan virus now.
   
