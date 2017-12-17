CC = gcc
CFLAGS += -Wall

OBJECT = string.o number.o
TARGET = string number

TARGET: $(OBJECT)
	$(CC) $(CFLAGS) -o string string.o
	$(CC) $(CFLAGS) -o number number.o

string.o : string.cpp
	$(CC) -c -fPIC $(CFLAGS) string.cpp
number.o : number.cpp
	$(CC) -c -fPIC $(CFLAGS) number.cpp

PHONY: clean
clean: 
	rm *.o $(TARGET)
