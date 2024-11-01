#include <stdint.h>
#include <stddef.h>
#include <sys/stat.h>

#include <sys.h>

#include <system.h>

typedef struct uart_instance_t {
  uint8_t DATA;
} uart_instance_t;

static volatile uart_instance_t* const UART = (uart_instance_t*)(UART_BASE);

int _close(int fd) {
    return -1;
}

int _open(int fd) {
    return -1;
}

int _fstat(int fd, struct stat *st) {
    return 0;
}

int _isatty(int fd) {
    return 1;
}

int _lseek(int fd, int ptr, int dir) {
    return -1;
}

int _read(int fd, char *ptr, size_t len) {
    return -1;
}


void *_sbrk(ptrdiff_t incr) {
    extern char _end;
    extern char __heap_start$;  // Start of the heap, defined in your linker script
    extern char __heap_end$;    // End of the heap, defined in your linker script
    extern char __stack_top$;   // Top of the stack, defined in your linker script
    static char * curbrk = &_end;
    void * ret = NULL;

    curbrk += incr;
    ret = curbrk - incr;

    return ret;
}

int _write(int fd, const void* ptr, size_t len) {
    char * str_ptr = (char *)ptr;
    
    int i = 0;

    while (str_ptr[i])
        UART->DATA = str_ptr[i++];

    return 1;
}