########################################################################
## Do checks and prepare dependencies for GRC
########################################################################

import os
import sys
import inspect
from ctypes.util import find_library

def check_python_version():
    is_64bits = sys.maxsize > 2**32
    if not is_64bits:
        raise Exception("requires 64-bit Python")

    if sys.version_info.major != 2 or sys.version_info.minor != 7:
        raise Exception("requires Python version 2.7")

    return sys.version

def check_gtk_runtime():
    libgtk = find_library("libgtk-win32-2.0-0.dll")

    if libgtk is None:
        raise Exception("failed to locate the GTK+ runtime DLL")

    return libgtk

def check_import_numpy():
    import numpy
    return inspect.getfile(numpy)

def check_import_lxml():
    import lxml
    return inspect.getfile(lxml)

def check_import_cheetah():
    import Cheetah
    return inspect.getfile(Cheetah)

def check_import_gtk():
    import gtk
    return inspect.getfile(gtk)

def check_import_wxpython():
    import wx
    import wx.glcanvas
    return inspect.getfile(wx)

def check_import_opengl():
    import OpenGL
    import OpenGL.GL
    return inspect.getfile(OpenGL)

def check_gr_runtime():
    gnuradio_runtime = find_library("gnuradio-runtime.dll")

    if gnuradio_runtime is None:
        raise Exception("failed to locate the GNURadio runtime DLL")

    return gnuradio_runtime

def check_import_gnuradio():
    import gnuradio
    from gnuradio import gr
    return inspect.getfile(gnuradio)

CHECKS = [
    ("PYTHON_VERSION", 'Python version is 2.7',  check_python_version),
    ("GTK_RUNTIME",    'locate GTK+ runtime',    check_gtk_runtime),
    ("IMPORT_NUMPY",   'import numpy module',    check_import_numpy),
    ("IMPORT_LXML",    'import lxml module',     check_import_lxml),
    ("IMPORT_CHEETAH", 'import Cheetah module',  check_import_cheetah),
    ("IMPORT_GTK",     'import gtk module',      check_import_gtk),
    ("IMPORT_WX",      'import wx module',       check_import_wxpython),
    ("IMPORT_OPENGL",  'import OpenGL module',   check_import_opengl),
    ("GR_RUNTIME",     'locate GNURadio runtime', check_gr_runtime),
    ("IMPORT_GR",      'import GNURadio module',  check_import_gnuradio),
]

if __name__ == '__main__':
    print("="*40)
    print("== GRC depedency helper for PothosSDR")
    print("="*40)

    maxLen = max([len(c[1]) for c in CHECKS])

    for key, what, check in CHECKS:
        whatStr = "%s...%s"%(what, ' '*(maxLen-len(what)))
        try:
            msg = check()
            statStr = "PASS"
            checkPassed = True
        except Exception as ex:
            statStr = "FAIL"
            checkPassed = False
            msg = str(ex)

        if not checkPassed: os.system('color 4')

        print("")
        print(" * Check %s  %s"%(whatStr, statStr))
        print("")
        if msg:
            print("   %s"%msg)
