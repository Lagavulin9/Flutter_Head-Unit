#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))

#include <iostream>
#include <thread>
#include <mutex>
#include <CommonAPI/CommonAPI.hpp>
#include <CommonAPI/AttributeCacheExtension.hpp>

#include "HeadUnitStubImpl.hpp"

std::shared_ptr<CommonAPI::Runtime> runtime;
std::shared_ptr<HeadUnitStubImpl> huService;

void buildCarControlProxy();

EXPORT
void init()
{
	std::cout << "init called" << std::endl;

	runtime = CommonAPI::Runtime::get();
	CommonAPI::Runtime::setProperty("LogContext", "HeadUnit");
	CommonAPI::Runtime::setProperty("LogApplication", "HeadUnit");
	buildCarControlProxy();
	huService = HeadUnitStubImpl::getInstance();
}
