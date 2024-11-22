from math import *

def newton_raphson(f, df, x0, tol=1e-6, max_iter=100):
    x = x0
    for i in range(max_iter):
        x_new = x - f(x) / df(x)
        if abs(x_new - x) < tol:
            return x_new
        x = x_new
    raise ValueError('no convergence')

def f(x):
    return x**3 - 2*x - 5

def df(x):
    return 3*x**2 - 2

if __name__ == "__main__":
    x0 = 2
    x = newton_raphson(f, df, x0)
    print(x)
    print(f(x))