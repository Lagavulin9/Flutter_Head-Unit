#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))

#include <iostream>
#include <thread>
#include <mutex>
#include <CommonAPI/CommonAPI.hpp>
#include <CommonAPI/AttributeCacheExtension.hpp>

void buildCarControlProxy();
void registerHeadUnitService();

EXPORT
void init()
{
	std::cout << "init called" << std::endl;
	CommonAPI::Runtime::setProperty("LogContext", "HeadUnit");
	CommonAPI::Runtime::setProperty("LogApplication", "HeadUnit");
	buildCarControlProxy();
	registerHeadUnitService();
}
