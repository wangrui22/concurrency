#include <stdio.h>

void func() {

}

void swap(int& a, int& b) {
    a = a^b;
    b = a^b;
    a = a^b;
}

int main(void)
{
    // 整数常量的编译器赋 类型
	unsigned long long x = 1234567890LL * 1234567890;
    printf("%lld\n",x);

    // 异或
    // unsigned char data[10]={0x12,0x21,0x1A,0xB1,0xC1,0xEB,0xDF,0xCA,0xF6,0xDD}; 
    // unsigned char  out=0x00; 
    // for (unsigned int i=0;i<sizeof(data);i++) 
    // { 
    //   out^=data[i]; 
    // } 
    // printf("%d\n", out);
    int a = 32;
    int b = 213123;
    printf("a=%d, b=%d.\n",a,b);
    swap(a,b);
    printf("a=%d, b=%d.\n",a,b);

    int c = 0x100000;
    printf("c=%d\n",c);
    int d = (c-1)^c;
    printf("c=%d\n",d);
	return 0;
}