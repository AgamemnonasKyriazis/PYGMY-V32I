#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <stddef.h>
#include <string.h>

#include <system.h>

int _open(int fd) {
  return -1;
}

int _close(int fd) {
  return -1;
}

int _fstat(int fd, struct stat *st) {
  st->st_mode = S_IFCHR;
  return 0;
}

int _isatty(int fd) {
  return 1;
}

int _lseek(int fd, int ptr, int dir) {
  return 0;
}

void _exit(int status) {
  while (1);
}

void _kill(int pid, int sig) {
  return;
}

int _getpid(void) {
  return -1;
}

void *_sbrk(ptrdiff_t incr) {
  extern char __end$;
  extern char __heap_start$;
  extern char __heap_end$;
  static char * curbrk = &__end$;
  char * ret = NULL;

  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
    return (void *)-1;
  }

  ret = curbrk;
  curbrk += incr;
  return ret;
}

int _read (int fd, char *buf, int count) {
  int read = 0;
  return read;
}

int _write(int fd, const void* ptr, ssize_t len) {
  
  for (int i = 0; i < len; i++)
    ((uart_instance_t *)(UART_BASE))->DATA = *((char*)ptr + i);
  
  return len;
}