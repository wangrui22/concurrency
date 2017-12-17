#include <boost/thread/thread.hpp>
#include <iostream>

void do_work() {
    std::cout <<"hello world." << std::endl;
}

int main(int argc, char* argv[]) {
    boost::thread th(do_work);
    boost::thread th2(boost::move(th));
    //sleep(5);

    std::cout << th2.get_id() << std::endl;
    
    //if(th.joinable()) {
        th2.join();
    //}

    
    
    return 0;
}