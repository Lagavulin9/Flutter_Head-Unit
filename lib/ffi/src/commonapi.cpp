#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))

#include <iostream>
#include <thread>
#include <mutex>
#include <CommonAPI/CommonAPI.hpp>
#include <CommonAPI/AttributeCacheExtension.hpp>

#include "HeadUnitStubImpl.hpp"

using namespace v0::commonapi;

std::shared_ptr<CommonAPI::Runtime> runtime;

EXPORT
void init()
{
	std::cout << "init called" << std::endl;

	runtime = CommonAPI::Runtime::get();
	CommonAPI::Runtime::setProperty("LogContext", "HeadUnit");
	CommonAPI::Runtime::setProperty("LogApplication", "HeadUnit");
	//CommonAPI::Runtime::setProperty("LibraryBase", "speedsensor");
}
