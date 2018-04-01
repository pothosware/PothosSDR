# Manifest for tracking patches for PothosSDR

| Project       | Patch                                | Tracker/Comments                                      |
| ------------- | ------------------------------------ | ----------------------------------------------------- |
| Pthreads      | pthreads_win32_vc14.diff             | VC14 struct timespec patches for pthreads-win32       |
| PortAudio     | portaudio_no_ksguid_lib.diff         | Fix missing link to ksguid.lib when building PA       |
| FAAC          | faac_dll_project_files.diff          | updated the project files for faac                    |
| FAAD2         | faad2_dll_project_files.diff         | updated the project files for faad2                   |
| CppUnit       | cppunit_dll_project_files.diff       | updated the project files for cppunit                 |
| BladeRF       | bladerf_disable_test_config.diff     | disable failing test config file build                |
| GrNRSC5       | gr_nrsc5_msvc.diff                   | missing PMT and external project build changes        |
