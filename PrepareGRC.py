########################################################################
## Do checks and prepare dependencies for GRC
########################################################################

import os
import sys
import inspect
from ctypes.util import find_library

PIP_EXE = "%s"%os.path.join(os.path.dirname(sys.executable), 'Scripts', 'pip.exe')

########################################################################
## Python checks
########################################################################
def check_python_version():
    is_64bits = sys.maxsize > 2**32
    if not is_64bits:
        raise Exception("requires 64-bit Python")

    if sys.version_info.major != 2 or sys.version_info.minor != 7:
        raise Exception("requires Python version 2.7")

    if not os.path.exists(PIP_EXE):
        raise Exception("can't find pip executable %s"%PIP_EXE)

    return sys.version

def handle_python_version():
    print("Error: Invoke/Reinstall Python2.7 for amd64")
    exit(-1)

########################################################################
## GTK checks
########################################################################
def check_gtk_runtime():
    libgtk = find_library("libgtk-win32-2.0-0.dll")

    if libgtk is None:
        raise Exception("failed to locate the GTK+ runtime DLL")

    return libgtk

def handle_gtk_runtime():
    pass

def check_import_gtk():
    import gtk
    return inspect.getfile(gtk)

def handle_import_gtk():
    pass

########################################################################
## GNU Radio checks
########################################################################
def check_gr_runtime():
    gnuradio_runtime = find_library("gnuradio-runtime.dll")

    if gnuradio_runtime is None:
        raise Exception("failed to locate the GNURadio runtime DLL")

    return gnuradio_runtime

def handle_gr_runtime():
    print("Error: PothosSDR missing from system path")
    print("  see https://github.com/pothosware/PothosSDR/wiki/Tutorial")
    exit(-1)

def check_import_gr():
    import gnuradio
    from gnuradio import gr
    return inspect.getfile(gnuradio)

def handle_import_gr():
    pass

########################################################################
## Other module checks
########################################################################
def check_import_numpy():
    import numpy
    return inspect.getfile(numpy)

def handle_import_numpy():
    pass

def check_import_lxml():
    import lxml
    return inspect.getfile(lxml)

def handle_import_lxml():
    pass

def check_import_cheetah():
    import Cheetah
    return inspect.getfile(Cheetah)

def handle_import_cheetah():
    print("Installing cheetah templates with pip:")
    os.system("%s install cheetah"%PIP_EXE)
    print("  Done!")

def check_import_wxpython():
    import wx
    import wx.glcanvas
    return inspect.getfile(wx)

def handle_import_wxpython():
    pass

def check_import_opengl():
    import OpenGL
    import OpenGL.GL
    return inspect.getfile(OpenGL)

def handle_import_opengl():
    pass

CHECKS = [
    ("PYVERSION",      'Python version is 2.7',   check_python_version, handle_python_version),
    ("GTK_RUNTIME",    'locate GTK+ runtime',     check_gtk_runtime, handle_gtk_runtime),
    ("IMPORT_GTK",     'import gtk module',       check_import_gtk, handle_import_gtk),
    ("GR_RUNTIME",     'locate GNURadio runtime', check_gr_runtime, handle_gr_runtime),
    ("IMPORT_GR",      'import GNURadio module',  check_import_gr, handle_import_gr),
    ("IMPORT_NUMPY",   'import numpy module',     check_import_numpy, handle_import_numpy),
    ("IMPORT_LXML",    'import lxml module',      check_import_lxml, handle_import_lxml),
    ("IMPORT_CHEETAH", 'import Cheetah module',   check_import_cheetah, handle_import_cheetah),
    ("IMPORT_WX",      'import wx module',        check_import_wxpython, handle_import_wxpython),
    ("IMPORT_OPENGL",  'import OpenGL module',    check_import_opengl, handle_import_opengl),
]

if __name__ == '__main__':
    print("")
    print("="*40)
    print("== Runtime and import checks")
    print("="*40)

    maxLen = max([len(c[1]) for c in CHECKS])
    msgs = dict()
    statuses = dict()
    numFails = 0
    numPasses = 0
    for key, what, check, handle in CHECKS:
        whatStr = "%s...%s"%(what, ' '*(maxLen-len(what)))
        try:
            msg = check()
            statStr = "PASS"
            checkPassed = True
            numPasses += 1
        except Exception as ex:
            statStr = "FAIL"
            checkPassed = False
            msg = str(ex)
            numFails += 1

        print(" * Check %s  %s"%(whatStr, statStr))
        msgs[key] = msg
        statuses[key] = checkPassed

    if numPasses:
        print("")
        print("="*40)
        print("== Checks passed summary")
        print("="*40)
        for key, what, check, handle in CHECKS:
            if statuses[key]: print("%s:\t%s"%(key, msgs[key]))

    if numFails == 0:
        print("All checked passed! GRC is ready to use.")
        exit(0)

    if numFails:
        print("")
        print("="*40)
        print("== Checks failed summary")
        print("="*40)
        for key, what, check, handle in CHECKS:
            if not statuses[key]: print("%s:\t%s"%(key, msgs[key]))

    if numFails:
        print("")
        print("="*40)
        print("== Fixing problems")
        print("="*40)
        for key, what, check, handle in CHECKS:
            if not statuses[key]: handle()

    print("Changes made! Please re-run this script.")
