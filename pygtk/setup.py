
import os
import sys
import shutil
import glob
from setuptools import setup

from datetime import datetime
VERSION = datetime.today().strftime('%Y.%m.%d')

THIS_DIR = os.getcwd()
THIS_SITE_PACKAGES = os.path.join(THIS_DIR, 'Lib', 'site-packages')

#gvsbuild resource location
GTK_INSTALL_ROOT = os.path.abspath("c:/gtk-build/gtk/x64/release")
PYTHON_INSTALL_ROOT = os.path.dirname(sys.executable)
PYTHON_SITE_PACKAGES = os.path.join(PYTHON_INSTALL_ROOT, 'Lib', 'site-packages')

#copy python modules into local directory
for globname in ('pycairo-*.egg/cairo', 'PyGObject-*.egg/gi'):
    src = glob.glob(os.path.join(PYTHON_SITE_PACKAGES, globname))[0]
    dst = os.path.join(THIS_SITE_PACKAGES, os.path.basename(src))
    print('Copying %s to %s'%(src, dst))
    shutil.copytree(src, dst, dirs_exist_ok=True, ignore=shutil.ignore_patterns('__pycache__'))

#copy gvsbuild install into local directory
for dirname in os.listdir(GTK_INSTALL_ROOT):
    src = os.path.join(GTK_INSTALL_ROOT, dirname)
    dst = os.path.join(THIS_DIR, 'Lib', 'gtk', dirname)
    print('Copying %s to %s'%(src, dst))
    shutil.copytree(src, dst, dirs_exist_ok=True)

#patch dll dir into gi __init__.py
print("Patching gi module...")
gi = glob.glob(os.path.join(THIS_SITE_PACKAGES, 'gi', '__init__.py'))[0]
original = open(gi).read()
PATCH = """
########################################################################
THIS_DIR = os.path.dirname(__file__)
BIN_DIR = os.path.join(THIS_DIR, '..', '..', 'gtk', 'bin')
os.environ['PATH'] = os.environ['PATH'] + ';' + os.path.abspath(BIN_DIR)
os.add_dll_directory(BIN_DIR) #do add_dll_directory without added_dirs
#code below will close added_dirs after imports and break future imports
########################################################################
"""
if 'BIN_DIR' not in original:
    SEARCH_TEXT = 'added_dirs = []'
    output = original.replace(SEARCH_TEXT, PATCH+SEARCH_TEXT)
    open(gi, 'w').write(output)

def form_data_file_list(*dir_list):
    for dirname in dir_list:
        print("Generate data file list for %s..."%dirname)
        for root, dirs, files in os.walk(dirname):
            root_files = [os.path.join(root, i) for i in files]
            yield (root, root_files)

def form_package_file_list(*dir_list):
    for dirname in dir_list:
        print("Generate data file list for %s..."%dirname)
        for root, dirs, files in os.walk(dirname):
            for i in files: yield os.path.join(root, i)

#form list of all data files
data_files = list(form_data_file_list('Lib'))

print("Start setup...")

#https://stackoverflow.com/questions/45150304/how-to-force-a-python-wheel-to-be-platform-specific-when-building-it
from setuptools.dist import Distribution
class BinaryDistribution(Distribution):
    """Distribution which always forces a binary package with platform name"""
    def has_ext_modules(foo): return True

setup(
    name='PothosSDRPyGTK',
    data_files=data_files,
    version=VERSION,
    python_requires='==%d.%d.*'%(sys.version_info.major, sys.version_info.minor),
    distclass=BinaryDistribution,
)

print("Done!")
