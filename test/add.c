int main() {
    int a = 1, b = 2;
    int c = 3;
    int d = a + 1000;
    int v = c + a;
    asm("ecall");
}