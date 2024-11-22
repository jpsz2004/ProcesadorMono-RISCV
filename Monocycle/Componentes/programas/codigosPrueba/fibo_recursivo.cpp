#include <iostream>
using namespace std;

// Dada una posicion, calcular  el valor de la serie de Fibonacci en esa posicion
int fibo(int n) {
    if (n <= 1) {
        return n;
    } else {
        return fibo(n - 1) + fibo(n - 2);
    }
}

int main() {
    int n = 7;
    cout << "Fibonacci(" << n << ") = " << fibo(n) << endl;
    return 0;
}