# Manifest for tracking patches for PothosSDR

| Project       | Patch                                | Tracker/Comments                                      |
| ------------- | ------------------------------------ | ----------------------------------------------------- |
| Pthreads      | pthreads_win32_vc14.diff             | VC14 struct timespec patches for pthreads-win32       |
| PortAudio     | portaudio_no_ksguid_lib.diff         | Fix missing link to ksguid.lib when building PA       |
| VOLK          | volk_config_h.diff                   | Disable many warnings, ifdefs to simplify config.h    |
| VOLK          | volk_prefetch_compat_macro.diff      | Added __VOLK_PREFETCH() compatibility macro           |
| FAAC          | faac_dll_project_files.diff          | updated the project files for faac                    |
| FAAD2         | faad2_dll_project_files.diff         | updated the project files for faad2                   |
| CppUnit       | cppunit_dll_project_files.diff       | updated the project files for cppunit                 |
| GNURadio      | gnuradio_fix_codec2_public_defs.diff | https://github.com/pothosware/gnuradio/issues/10      |
| GNURadio      | gnuradio_ifdef_unistd_h.diff         | ifdef unistd.h in public unit test header             |
| GNURadio      | gnuradio_catv_bin_hex.diff           | switch from 0b binary to 0x hex format                |
| GNURadio      | gnuradio_config_h.diff               | ifdefs to simplify config.h and related               |
| zeromq        | zeromq_readme_docs_path.diff         | Do not install readme docs into the top directory     |
