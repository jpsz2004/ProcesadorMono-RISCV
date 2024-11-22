#include <iostream>
#include <cmath>
#include <stdexcept>

double f(double x) {
    return x * x * x - 4 * x - 5;
}

double df(double x) {
    return 3 * x * x - 2;
}

double newtonRaphson(double (*f)(double), double (*df)(double), double x0, double tol = 1e-6, int max_iter = 100) {
    double x = x0;
    for (int i = 0; i < max_iter; ++i) {
        double x_new = x - f(x) / df(x);
        if (std::abs(x_new - x) < tol) {
            return x_new;
        }
        x = x_new;
    }
    throw std::runtime_error("no convergence");
}

int main() {
    try {
        double root = newtonRaphson(f, df, 2.0);
        std::cout << "Root: " << root << std::endl;
    } catch (const std::runtime_error& e) {
        std::cerr << e.what() << std::endl;
    }
    return 0;
}
