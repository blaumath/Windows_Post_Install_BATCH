# Windows_Post_Install_BATCH
Post Install Script With Collections Of Online And Personal Scripts.

## Disclaimer!
An **INTERNET Connection** is required for this script to run properly.

W̶i̶l̶l̶ ̶h̶a̶v̶e̶ ̶a̶ ̶f̶u̶l̶l̶y̶ ̶o̶f̶f̶l̶i̶n̶e̶ ̶v̶e̶r̶s̶i̶o̶n̶ ̶d̶o̶w̶n̶ ̶t̶h̶e̶ ̶r̶o̶a̶d̶.̶ (Hell no)

TASKLIST:

- [x] Script Creation
- [x] IRM Version for using in terminal 
- [ ] Offline Install Version
 
## HOW TOs

Option 1: Either download the zip file and launch the "Install.bat" file 
 
Option 2: Using the Powershell/Terminal commands below ☟

<details><summary>Command (Click Me)</summary>
<p>

```
irm post.8mpty.xyz | iex
```
or (A bit more Secure)
```
irm https://post.8mpty.xyz | iex
```
or (use if DNS issues)
```
irm https://raw.githubusercontent.com/8mpty/Windows_Post_Install_BATCH/main/psfile/empty.ps1 | iex
```
</p>
</details>

**E̶X̶E̶ ̶a̶n̶d̶ ̶M̶S̶I̶ ̶f̶o̶r̶m̶a̶t̶s̶ ̶w̶i̶l̶l̶ ̶b̶e̶ ̶p̶r̶o̶v̶i̶d̶e̶d̶ ̶a̶t̶ ̶a̶ ̶l̶a̶t̶e̶r̶ ̶d̶a̶t̶e̶.̶** (Nevermind)


## Additional Options
You may also pass in a max of **[2]** arguments into the script downloaded locally or over the internet with "irm"

**ARGUMENTS MUST BE SEPERATE WITH A SPACING TO WORK** EX. ```5 6``` and not ```56```

Credits: https://massgrave.dev/command_line_switches.html

Example Arguments are:

<details><summary>If Downloaded Locally Examples (Click Me)</summary>
<p> 
 
```
.\Install.bat 5
```
Which will go to the [Extras] page.

If running:
```
.\Install.bat 5 6
```
Will go the [Extras] page and execute option [6] which is creating the script shortcut.
</p>
</details>


<details><summary>If Running with IRM Examples (Click Me)</summary>
<p>

Default is ```irm post.8mpty.xyz | iex```,

But if you want to pass in arguments:
```
iex "&{$(irm post.8mpty.xyz)} 5"
```
Which will go to the [Extras] page.

If running:
```
iex "&{$(irm post.8mpty.xyz)} 5 6"
```
Will go the [Extras] page and execute option [6] which is creating the script shortcut.
</p>
</details>

## Additional Options (Disclaimers)

Ofcourse these options are not only limited to Options 5 & 6, other options are availble to try but do **NOTE** that only a max of "2" options are availble.

As of right now, this script is not able to run further than "2" arguments like ```iex "&{$(irm post.8mpty.xyz)} 5 3 1"```.

Above is meant to go to the [Extras] Page and execute option [3] which is "Removal of Folders" and will execute [1] to confirm the removal but as of this current iteration of the script, it is **NOT POSSIBLE** yet.

## References (Scripts)
 
Windows Activator (https://github.com/massgravel/Microsoft-Activation-Scripts)
 
Program's Installer (https://github.com/ChrisTitusTech/winutil)
 
Winget Standalone Installer (https://christitus.com/installing-appx-without-msstore/)
 
Windows AutoLogon (https://github.com/mbd-shift/Windows10-Autologon)
