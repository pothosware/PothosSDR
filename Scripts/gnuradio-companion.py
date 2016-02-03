########################################################################
## gnuradio-companion.py forwarder script
## Use pyinstaller to create a nice gnuradio-companion.exe with icon.
## Makes the desktop/start menu/and file associations work nicely.
########################################################################
import os
import sys
import subprocess

this_exe = os.path.abspath(sys.argv[0])
this_dir = os.path.dirname(this_exe)
grc_py = os.path.join(this_dir, 'gnuradio-companion.py')

new_args = [grc_py] + sys.argv[1:]
new_cmd = " ".join('"%s"'%a for a in new_args)

print(new_cmd)
subprocess.call(new_cmd, shell=True)
