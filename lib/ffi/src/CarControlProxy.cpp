#ifndef EXTERNC
# define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

#include <thread>
#include <mutex>
#include <iostream>
#include <CommonAPI/CommonAPI.hpp>
#include <CommonAPI/AttributeCacheExtension.hpp>
#include <v0/commonapi/CarControlProxy.hpp>

using namespace v0::commonapi;

std::shared_ptr<typename CommonAPI::DefaultAttributeProxyHelper<v0::commonapi::CarControlProxy, CommonAPI::Extensions::AttributeCacheExtension>::class_t> ccProxy;
std::string	_gear("P");
std::string	_indicator("None");
std::mutex	_gearMutex;
std::mutex	_indicatorMutex;

void buildCarControlProxy()
{
	std::shared_ptr<CommonAPI::Runtime> runtime = CommonAPI::Runtime::get();

	std::string domain = "local";
	std::string instance = "commonapi.CarControl";
	std::string connection = "client-sample";

	ccProxy = runtime->buildProxyWithDefaultAttributeExtension<CarControlProxy, CommonAPI::Extensions::AttributeCacheExtension>(domain, instance, connection);
	std::cout << "Waiting for service to become available." << std::endl;
	while (!ccProxy->isAvailable()) {
		std::this_thread::sleep_for(std::chrono::microseconds(10));
	}
	std::cout << "CarControl service is available" << std::endl;

	// initialize values
	CommonAPI::CallStatus callStatus;
	CommonAPI::CallInfo info(1000);
	info.sender_ = 5678;

	ccProxy->getGearAttribute().getValue(callStatus, _gear, &info);
	if (callStatus != CommonAPI::CallStatus::SUCCESS) {
		std::cerr << "Remote call A failed!\n";
		return;
	}
	std::cout << "Got attribute value: " << _gear << std::endl;

	ccProxy->getIndicatorAttribute().getValue(callStatus, _indicator, &info);
	if (callStatus != CommonAPI::CallStatus::SUCCESS) {
		std::cerr << "Remote call A failed!\n";
		return;
	}
	std::cout << "Got attribute value: " << _indicator << std::endl;
}

EXPORT
void subscribe_control()
{
	// subscribe and attatch callback function
	ccProxy->getGearAttribute().getChangedEvent().subscribe([&](const std::string& val){
		std::cout << "Received gear: " << val << std::endl;
		{
			std::lock_guard<std::mutex> lock(_gearMutex);
			_gear = val;
		}
	});
	
	ccProxy->getIndicatorAttribute().getChangedEvent().subscribe([&](const std::string& val){
		std::cout << "Received indicator: " << val << std::endl;
		{
			std::lock_guard<std::mutex> lock(_indicatorMutex);
			_indicator = val;
		}
	});
	std::cout << "CarControl subscribed" << std::endl;
}

EXPORT
const char* getGear()
{
	std::lock_guard<std::mutex> lock(_gearMutex);
	return _gear.c_str();
}

EXPORT
void setGear(const char* input)
{
	CommonAPI::CallStatus callStatus;
	CommonAPI::CallInfo info(1000);
	info.sender_ = 1234;
	bool res;
	std::string gear(input);
	ccProxy->gearSelectionHeadUnit(gear, callStatus, res, &info);
	if (res == true)
		std::cout << "Gear changed successfully" << std::endl;
	else
		std::cout << "Gear change failed" << std::endl;
}

EXPORT
const char* getIndicator()
{
	std::lock_guard<std::mutex> lock(_indicatorMutex);
	return _indicator.c_str();
}
