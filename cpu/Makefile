CC = g++
CFLAGS += -Wall -std=c++11

OBJECT = 0.basic.o
TARGET = 0.basic

INCLUDE_PATH = /usr/local/includ
LIB_PATH = /usr/local/lib

TARGET: $(OBJECT)
	$(CC) $(CFLAGS) -o 0.basic 0.basic.o -I$(LIB_PATH) -lboost_system -lboost_thread

0.basic.o : 0.basic.cpp
	$(CC) -c -fPIC $(CFLAGS) 0.basic.cpp -L$(INCLUDE_PATH)

PHONY: clean
clean: 
	rm *.o $(TARGET)

