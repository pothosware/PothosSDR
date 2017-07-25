# Manifest for tracking patches for PothosSDR

| Project       | Patch                                | Tracker/Comments                                      |
| ------------- | ------------------------------------ | ----------------------------------------------------- |
| Pthreads      | pthreads_win32_vc14.diff             | VC14 struct timespec patches for pthreads-win32       |
| PortAudio     | portaudio_no_ksguid_lib.diff         | Fix missing link to ksguid.lib when building PA       |
| FAAC          | faac_dll_project_files.diff          | updated the project files for faac                    |
| FAAD2         | faad2_dll_project_files.diff         | updated the project files for faad2                   |
| CppUnit       | cppunit_dll_project_files.diff       | updated the project files for cppunit                 |
| BladeRF       | bladerf_cyapi_win10.diff             | Allow for win10 build linking with CyAPI              |
| BladeRF       | bladerf_cal_dc_fix.diff              | Patch cast type warning treated as an error           |
