module freeksd.ksdboot;

// main process thread, other threads are created by the System process (kernel)

import freeksd.runksd;

void main() {
    kernelprocess();
}