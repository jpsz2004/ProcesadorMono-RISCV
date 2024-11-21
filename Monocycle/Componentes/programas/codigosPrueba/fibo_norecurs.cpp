#include <iostream>

int fibonacci() {
    int n = 10;

    int a = 0;
    int b = 1;
    int result = 0;

    for (int i = 2; i <= n; ++i) {
        result = a + b;
        a = b;
        b = result;
    }
    
    return result;
}

int main() {
    std::cout << "Fibonacci(10) = " << fibonacci() << std::endl;
    return 0;
}