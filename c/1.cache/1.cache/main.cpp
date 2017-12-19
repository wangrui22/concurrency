//--------------------------------------------------//
//Write combining buffer
//我的工作机 win10 x64 企业版; i7-6700k ; 64GB;
//结果差别没有不大 x64 release 结果如下，没有blog里写的两倍的性能提升，不过也提升巨大：
/*
case 1 cost: 7.723
case 2 cost: 5.271
case 1 cost: 7.984
case 2 cost: 5.307
case 1 cost: 7.467
case 2 cost: 5.401
*/
//x64 debug 差别很大
/*
case 1 cost: 38.259
case 2 cost: 14.748
case 1 cost: 35.876
case 2 cost: 14.775
case 1 cost: 36.208
case 2 cost: 14.835
*/
//所以循环遇到多个赋值操作，最好拆开写，拆成多少个得具体试（和cpu的write combining buffer有关）

//http://peg.hengtiansoft.com/article/write-combining-bufferdui-dai-ma-xing-neng-de-ying-xiang/
//--------------------------------------------------//

#include <stdio.h>
#include <limits>
#include <time.h>
#include <iostream>

int ITERATIONS = std::numeric_limits<int>::max();
int ITEMS = 1 << 24;
int MASK = ITEMS - 1;

unsigned char* array1 = new unsigned char[ITEMS];
unsigned char* array2 = new unsigned char[ITEMS];
unsigned char* array3 = new unsigned char[ITEMS];
unsigned char* array4 = new unsigned char[ITEMS];
unsigned char* array5 = new unsigned char[ITEMS];
unsigned char* array6 = new unsigned char[ITEMS];
unsigned char* array7 = new unsigned char[ITEMS];
unsigned char* array8 = new unsigned char[ITEMS];

void run_cast_1() {
    clock_t _start = clock();
    int i = ITERATIONS;
    while (--i != 0) {
        int slot = i & MASK;
        unsigned char b = (unsigned char)i;
        array1[slot] = b;
        array2[slot] = b;
        array3[slot] = b;
        array4[slot] = b;
        array5[slot] = b;
        array6[slot] = b;
        array7[slot] = b;
        array8[slot] = b;
    }

    clock_t _end = clock();
    std::cout<< "case 1 cost: " << double(_end-_start)/CLOCKS_PER_SEC << std::endl;
}

void run_cast_2() {
    clock_t _start = clock();
    int i = ITERATIONS;
    while (--i != 0) {
        int slot = i & MASK;
        unsigned char b = (unsigned char)i;
        array1[slot] = b;
        array2[slot] = b;
        array3[slot] = b;
        array4[slot] = b;
    }

    i = ITERATIONS;
    while (--i != 0) {
        int slot = i & MASK;
        unsigned char b = (unsigned char)i;
        array5[slot] = b;
        array6[slot] = b;
        array7[slot] = b;
        array8[slot] = b;
    }

    clock_t _end = clock();
    std::cout << "case 2 cost: " << double(_end - _start) / CLOCKS_PER_SEC << std::endl;
}

int main(int argc, char* argv[]) {
    for (int i = 0; i < 3; ++i) {
        run_cast_1();
        run_cast_2();
    }
    
    int result = array1[1] + array2[2] + array3[3] +
        array4[4] + array5[5] + array6[6] + array7[7] + array8[8];
    std::cout<< "result: " << result << std::endl;
    return 0;
}
