# Manifest for tracking patches for PothosSDR

| Project       | Patch                                | Tracker/Comments                                      |
| ------------- | ------------------------------------ | ----------------------------------------------------- |
| Pthreads      | pthreads_win32_vc14.diff             | VC14 struct timespec patches for pthreads-win32       |
| PortAudio     | portaudio_no_ksguid_lib.diff         | Fix missing link to ksguid.lib when building PA       |
| VOLK          | volk_disable_warnings.diff           | Disable many warnings to reduce heavy printing        |
| VOLK          | volk_prefetch_compat_macro.diff      | Added __VOLK_PREFETCH() compatibility macro           |
| FAAC          | faac_dll_project_files.diff          | updated the project files for faac                    |
| FAAD2         | faad2_dll_project_files.diff         | updated the project files for faad2                   |
| CppUnit       | cppunit_dll_project_files.diff       | updated the project files for cppunit                 |
| GNURadio      | gnuradio_fix_codec2_public_defs.diff | https://github.com/pothosware/gnuradio/issues/10      |
| GNURadio      | gnuradio_fix_pfb_clock_sync_fff.diff | https://github.com/pothosware/gnuradio/issues/8       |
| GNURadio      | gnuradio_portaudio_add_io_h.diff     | https://github.com/pothosware/gnuradio/issues/21      |
| GNURadio      | gnuradio_fec_dllr_factor.diff        | https://github.com/pothosware/gnuradio/issues/26      |
| GNURadio      | gnuradio_ifdef_unistd_h.diff         | ifdef unistd.h in public unit test header             |
| GNURadio      | gnuradio_paths_return_fix.diff       | fix bug returning a temporary variable                |
| GNURadio      | gnuradio_config_msvc_rand48.diff     | added missing rand48() functions to config.h          |
| UHD           | uhd_fix_gain_group_floor_round.diff  | https://github.com/EttusResearch/uhd/issues/31        |
| gr-drm        | gr_drm_msvc_fixes.diff               | Minor MSVC patches for dynamic arrays and M_PI        |
| zeromq        | zeromq_readme_docs_path.diff         | Do not install readme docs into the top directory     |
