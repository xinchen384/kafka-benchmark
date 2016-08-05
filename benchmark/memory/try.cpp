


#include <iostream>
#include <fstream>
#include <unistd.h>

using namespace std;


void allocate(){
    size_t tSize = 1*1024*1024*1024;
    cout << "1G" << endl;
    char * array1 = new char[tSize];    
    std::fill(array1, array1+tSize, 0);
}
int main(){

    //size_t tSize = SIZE_MAX;
    allocate();    
    allocate();    
    allocate();    
    allocate();    
    cout << "entering lopp ... " << endl;
    while(true) sleep(1);
    return 0;
}
