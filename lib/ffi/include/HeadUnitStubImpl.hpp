#ifndef HeadUnitStubImpl_H_
#define HeadUnitStubImpl_H_

#include <thread>
#include <mutex>
#include <CommonAPI/CommonAPI.hpp>
#include <v0/commonapi/HeadUnitStubDefault.hpp>

using namespace v0::commonapi;

class HeadUnitStubImpl: public HeadUnitStubDefault
{
private:
	static std::shared_ptr<HeadUnitStubImpl> instance;
	HeadUnitStubImpl();

public:
	static std::shared_ptr<HeadUnitStubImpl> getInstance();
	virtual ~HeadUnitStubImpl();
};

#endif //HeadUnitStubImpl_H