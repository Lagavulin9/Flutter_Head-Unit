#ifndef EXTERNC
# define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

#include <thread>
#include <mutex>
#include <iostream>
#include <CommonAPI/CommonAPI.hpp>
#include <CommonAPI/AttributeCacheExtension.hpp>
#include <v0/commonapi/ParkDistanceControlProxy.hpp>

using namespace v0::commonapi;

std::shared_ptr<typename CommonAPI::DefaultAttributeProxyHelper<ParkDistanceControlProxy, CommonAPI::Extensions::AttributeCacheExtension>::class_t> pdcProxy;
std::mutex	_mutex;
ParkDistanceControl::SonarArrayStruct _sonar;

struct sonar {
	unsigned int left;
	unsigned int middle;
	unsigned int right;
};

void buildPDCProxy()
{
	std::shared_ptr<CommonAPI::Runtime> runtime = CommonAPI::Runtime::get();

	std::string domain = "local";
	std::string instance = "commonapi.ParkDistanceControl";
	std::string connection = "client-headunit";

	pdcProxy = runtime->buildProxyWithDefaultAttributeExtension<ParkDistanceControlProxy, CommonAPI::Extensions::AttributeCacheExtension>(domain, instance, connection);
	std::cout << "Waiting for ParkDistanceControl service to become available." << std::endl;
	while (!pdcProxy->isAvailable()) {
		std::this_thread::sleep_for(std::chrono::microseconds(10));
	}
	std::cout << "ParkDistanceControl service is available" << std::endl;

	// initialize values
	CommonAPI::CallStatus callStatus;
	CommonAPI::CallInfo info(1000);
	info.sender_ = 5678;
}

EXPORT
void subscribe_pdc()
{
	// subscribe and attatch callback function
	pdcProxy->getDistancesAttribute().getChangedEvent().subscribe([&](const ParkDistanceControl::SonarArrayStruct& val){
		std::cout << "Received sonar" << std::endl;
		{
			std::lock_guard<std::mutex> lock(_mutex);
			_sonar = val;
		}
	});

	std::cout << "Sonar subscribed" << std::endl;
}

EXPORT
sonar getSonar()
{
	std::lock_guard<std::mutex> lock(_mutex);
	sonar ret = {
		(unsigned int)_sonar.getSensorfrontleft(),
		(unsigned int)_sonar.getSensorfrontmiddle(),
		(unsigned int)_sonar.getSensorfrontright()
	};
	return ret;
}
