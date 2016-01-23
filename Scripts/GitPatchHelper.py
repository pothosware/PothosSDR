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
import hashlib
import json

GIT_EXECUTABLE = 'git'

STAMP_FILE = os.path.join('.git', 'GitPatchHelper.json')

def hashFile(filePath):
    """
    Make a unique hash of the patch set
    so we can check if it has been applied before.
    """
    hasher = hashlib.md5()
    with open(filePath, 'rb') as afile:
        buf = afile.read()
        hasher.update(buf)
    return hasher.hexdigest()

def dumpPatchState(patches):
    """
    Dump a summary of the patch files in use.
    """
    st = dict([(os.path.basename(p), hashFile(p)) for p in patches])
    dump = json.dumps(st, sort_keys=True, indent=4, separators=(',', ': '))
    open(STAMP_FILE, 'w').write(dump)

def didPatchChange(patch):
    """
    Did this patch change since it was last applied?
    """
    try:
        dump = open(STAMP_FILE, 'r').read()
        st = json.loads(dump)
        return st[os.path.basename(patch)] != hashFile(patch)
    except: return True

def getListOfChangedFiles():
    """
    Determine the source files that have modifications (git status)
    """
    p = subprocess.Popen(args=[GIT_EXECUTABLE, "status", "--short"], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdoutdata, stderrdata = p.communicate()
    for line in stdoutdata.splitlines():
        statusCode, filePath = line.decode("utf-8").split()
        if statusCode == "M":
            assert os.path.exists(filePath)
            yield filePath

def getListOfPatchesFiles(patch):
    """
    Get a list of files affected by this patch
    """
    for line in open(patch).readlines():
        if line.startswith('diff --git'):
            args = line.split()
            filePath = args[2][2:]
            if not os.path.exists(filePath):
                raise Exception('%s referenced by %s does not exist'%(filePath, patch))
            yield filePath

def revertFiles(changedFiles):
    """
    Revert changes to a list of files
    """
    p = subprocess.Popen(args=[GIT_EXECUTABLE, "checkout"] + list(changedFiles), shell=True)
    if p.wait() != 0:
        raise Exception('Failed to revert state: %s'%patch)

def applyPatch(patch):
    """
    Apply the specified patch
    """
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
    if not changedFiles: print("   None found")

    if changedFiles:
        filesToRevert = list()
        for patch in args:
            patchedFiles = set(getListOfPatchesFiles(patch))
            probablyApplied = changedFiles.issuperset(patchedFiles)
            if not probablyApplied or didPatchChange(patch):
                filesToRevert += patchedFiles

        filesToRevert = set(filesToRevert)
        if filesToRevert:
            print("")
            print("Reverting files:")
            for fileToRevert in filesToRevert: print("   * %s"%fileToRevert)
        revertFiles(filesToRevert)
        changedFiles -= filesToRevert

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
            applyPatch(patch)
            print("    ---- Done!")

    dumpPatchState(args)

if __name__ == '__main__': main()
