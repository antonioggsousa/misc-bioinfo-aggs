#!/usr/bin/python3

#-------------------------------------------------------------------------------------------------------
# Description: python script for lazying load upon my startup session on my local pc
# 
# Author: António Sousa
# Date: 06/02/2021
# Last update: 06/02/2021
#
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# modules to import 
import webbrowser
import os 
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
## Open browser with most common used websites
# select browser 
browser_path = '/usr/bin/firefox'
select_browser = 'firefox'
webbrowser.register(select_browser, None, webbrowser.BackgroundBrowser(browser_path))

# websites to open:
sites = ['https://www.youtube.com', 
         'https://track.toggl.com', 
         'https://calendar.google.com', 
         'https://gmail.com/', 
         'https://webmail.igc.gulbenkian.pt/horde3/login.php', 
         'https://discord.com/app']

# open sites upon start
for site in sites:
    os.system('sleep 3')
    webbrowser.get(select_browser).open_new_tab(site)  
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
## Open terminal and tmux panes most used
# open terminal & tmux session & windows
#os.system('/usr/bin/gnome-terminal -- bash')
os.system('/usr/bin/gnome-terminal -- tmux new -s aggs -n manage-vms')
os.system('/usr/bin/gnome-terminal -- tmux new-window -t aggs:1 -n working-station')
os.system('/usr/bin/gnome-terminal -- tmux new-window -t aggs:2 -n remote-station')

# run commands
os.system('/usr/bin/gnome-terminal -- tmux send-keys -t aggs:0 C-z "exec bash" C-m')
os.system('/usr/bin/gnome-terminal -- tmux send-keys -t aggs:0 C-z "cd ~/manage_vms/ansible/" C-m')
#os.system('/usr/bin/gnome-terminal -- tmux send-keys -t aggs:0 C-z "ansible -m shell all -a ping -c 1 www.google.com" C-m')
os.system('/usr/bin/gnome-terminal -- tmux send-keys -t aggs:1 C-z "exec bash" C-m')
os.system('/usr/bin/gnome-terminal -- tmux send-keys -t aggs:1 C-z "tb --list" C-m')
os.system('/usr/bin/gnome-terminal -- tmux send-keys -t aggs:2 C-z "exec bash" C-m')
#-------------------------------------------------------------------------------------------------------
