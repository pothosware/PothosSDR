########################################################################
## GitPatchHelper:
##
## Apply several patches conditionally to avoid source changes
## by re-applying a patch that may have already been applied.
## Detect that a patch should be applied by checking
## if the files in the patch are already changed (git st).
## This is error prone, so reset source changes after
## making modifications to the patch.
########################################################################

import os
import subprocess
from optparse import OptionParser

GIT_EXECUTABLE = 'git'

def getListOfChangedFiles():
    p = subprocess.Popen(args=[GIT_EXECUTABLE, "status", "--short"], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdoutdata, stderrdata = p.communicate()
    for line in stdoutdata.splitlines():
        statusCode, filePath = line.decode("utf-8").split()
        if statusCode == "M":
            assert os.path.exists(filePath)
            yield filePath

def getListOfPatchesFiles(patch):
    for line in open(patch).readlines():
        if line.startswith('diff --git'):
            args = line.split()
            filePath = args[2][2:]
            assert os.path.exists(filePath)
            yield filePath

def applyPatch(patch, changedFiles):
    p = subprocess.Popen(args=[GIT_EXECUTABLE, "checkout"] + list(changedFiles), shell=True)
    if p.wait() != 0:
        raise Exception('Failed to revert state: %s'%patch)
    
    p = subprocess.Popen(args=[GIT_EXECUTABLE, "apply", "--ignore-whitespace", patch], shell=True)
    if p.wait() != 0:
        raise Exception('Failed to apply patch: %s'%patch)

def main():
    parser = OptionParser()
    parser.add_option("--git", dest="git", help="path to git executable")
    (options, args) = parser.parse_args()

    global GIT_EXECUTABLE
    if options.git: GIT_EXECUTABLE = options.git

    print("")
    print("Parsing git status for change files:")
    changedFiles = set(getListOfChangedFiles())
    for filePath in changedFiles: print("   * %s"%filePath)

    for patch in args:
        print("")
        print("Parsing patch (%s):"%patch)
        patchedFiles = set(getListOfPatchesFiles(patch))
        for patchedFile in patchedFiles: print("   * %s"%patchedFile)
        if changedFiles.issuperset(patchedFiles):
            print("    ---- All patches previously applied.")
            continue
        else:
            print("    ---- Applying patch now...")
            applyPatch(patch, changedFiles)
            print("    ---- Done!")

if __name__ == '__main__': main()
