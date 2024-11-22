#include <iostream>
using namespace std;

int factorial(){
    int n = 5;
    if(n <= 1){
        return 1;
    }

    int result = 1;

    while (n > 1){
        result *= n;
        n--;
    }

    return result;
}

int main(){
    cout << factorial() << endl;
    return 0;
}