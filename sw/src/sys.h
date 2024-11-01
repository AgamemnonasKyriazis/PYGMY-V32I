#include <stdint.h>
#include <stddef.h>

int _close(int fd);

int _open(int fd);

void * _sbrk(ptrdiff_t incr);

int _write(int fd, const void* ptr, size_t len);