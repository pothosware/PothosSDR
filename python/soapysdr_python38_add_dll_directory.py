#This is a fix for python3.8
#The dll search path has to be manually added
import os
try: os.add_dll_directory(os.path.join(os.path.dirname(__file__), '..', '..', '..', 'bin'))
except: pass
