# Manifest for tracking patches for PothosSDR

| Project       | Patch                                | Tracker/Comments                                      |
| ------------- | ------------------------------------ | ----------------------------------------------------- |
| Pthreads      | pthreads_win32_CMakeLists.txt        | CMakeLists.txt copied over to pthreads-win32          |
| Pthreads      | pthreads_win32_vc14.diff             | VC14 struct timespec patches for pthreads-win32       |
| PorthAudio    | portaudio_no_ksguid_lib.diff         | Fix missing link to ksguid.lib when building PA       |
| GNURadio      | gnuradio_dtv_use_alloca.diff         | https://github.com/pothosware/gnuradio/issues/20      |
| GNURadio      | gnuradio_config_msvc_math.diff       | https://github.com/pothosware/gnuradio/issues/19      |
| GNURadio      | gnuradio_fix_codec2_fdmdv_round.diff | https://github.com/pothosware/gnuradio/issues/11      |
| GNURadio      | gnuradio_fix_codec2_public_defs.diff | https://github.com/pothosware/gnuradio/issues/10      |
| GNURadio      | gnuradio_fix_filter_truncation.diff  | https://github.com/pothosware/gnuradio/issues/7       |
| GNURadio      | gnuradio_fix_pfb_clock_sync_fff.diff | https://github.com/pothosware/gnuradio/issues/8       |
| GNURadio      | gnuradio_portaudio_add_io_h.diff     | https://github.com/pothosware/gnuradio/issues/21      |
| GNURadio      | gnuradio_udp_source_linger.diff      | https://github.com/pothosware/gnuradio/issues/23      |
| GNURadio      | gnuradio_fix_msvc14.diff             | Adds MSVC14 version string to CMake build             |
| GNURadio      | gnuradio_config_msvc_math.diff       | https://github.com/pothosware/gnuradio/issues/24      |
| GNURadio      | gnuradio_fec_dllr_factor.diff        | https://github.com/pothosware/gnuradio/issues/26      |
| GNURadio      | gnuradio_dtv_use_gr_aligned.diff     | https://github.com/pothosware/gnuradio/issues/25      |
| GNURadio      | gnuradio_fec_ldpc_config_h.diff      | https://github.com/pothosware/gnuradio/issues/24      |
| GNURadio      | gr_dtv_dvb_bbheader_grc_fix.diff     | https://github.com/pothosware/gnuradio/issues/28      |
| UHD           | uhd_fix_gain_group_floor_round.diff  | https://github.com/EttusResearch/uhd/issues/31        |
| gr-rds        | gr_rds_msvc_fixes.diff               | Minor MSVC patches for encoder_impl.cc                |
| zeromq        | zeromq_readme_docs_path.diff         | Do not install readme docs into the top directory     |
