#ifndef SYSINFO_H
#define SYSINFO_H

#ifdef KERNEL
// Kernel-specific includes and definitions
#include "types.h"
#else
// User-space definitions
typedef unsigned long long uint64;
#endif

struct sysinfo {
    uint64 freemem;  // Free memory in bytes
    uint64 nproc;    // Number of active processes
    uint64 loadavg;  // Load average (optional)
};

#endif // SYSINFO_H
