# Manifest for tracking patches for PothosSDR

| Project       | Patch                                | Tracker/Comments                                      |
| ------------- | ------------------------------------ | ----------------------------------------------------- |
| Pthreads      | pthreads_win32_vc14.diff             | VC14 struct timespec patches for pthreads-win32       |
| FAAC          | faac_dll_project_files.diff          | updated the project files for faac                    |
| FAAD2         | faad2_dll_project_files.diff         | updated the project files for faad2                   |
| CppUnit       | cppunit_dll_project_files.diff       | updated the project files for cppunit                 |
| BladeRF       | bladerf_fix_empty_array.diff         | fix empty array for MSVC array inconsistencies        |
| GNURadio      | gnuradio_posix_time.diff             | cast input to posix time to long (boost 1.67)         |
| GNURadio      | gnuradio_python_path.diff            | added python env search path to module check          |
| GrLimeSDR     | grlimesdr_pmt_link_fix.diff          | missing PMT executable for swig linking               |
