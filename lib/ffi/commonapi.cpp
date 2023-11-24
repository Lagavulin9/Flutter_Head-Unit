#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))

#include <iostream>
#include <thread>
#include <mutex>
#include <CommonAPI/CommonAPI.hpp>
#include <CommonAPI/AttributeCacheExtension.hpp>
#include <v1/commonapi/speedsensor/SpeedSensorProxy.hpp>
#include <v1/commonapi/carcontrol/CarControlProxy.hpp>
#include <v1/commonapi/carinfo/CarInfoProxy.hpp>

using namespace v1::commonapi::speedsensor;
using namespace v1::commonapi::carcontrol;
using namespace v1::commonapi::carinfo;

std::shared_ptr<CommonAPI::Runtime> runtime;
std::shared_ptr<typename CommonAPI::DefaultAttributeProxyHelper<SpeedSensorProxy, CommonAPI::Extensions::AttributeCacheExtension>::class_t> ssProxy;
std::shared_ptr<typename CommonAPI::DefaultAttributeProxyHelper<CarControlProxy, CommonAPI::Extensions::AttributeCacheExtension>::class_t> ccProxy;
std::shared_ptr<typename CommonAPI::DefaultAttributeProxyHelper<CarInfoProxy, CommonAPI::Extensions::AttributeCacheExtension>::class_t> ciProxy;

static int _speed;
static std::string _gear;
static v1::commonapi::carinfo::CommonTypes::InfoStruct _carinfo;
static std::string _indicator;
static std::mutex _mutex;

struct carinfo {
	double vol;
	double cur;
	double pwr;
	double bat;
};

EXPORT
void init()
{
	std::cout << "init called" << std::endl;

	CommonAPI::Runtime::setProperty("LogContext", "HeadUnit");
	CommonAPI::Runtime::setProperty("LogApplication", "HeadUnit");
	//CommonAPI::Runtime::setProperty("LibraryBase", "speedsensor");
	runtime = CommonAPI::Runtime::get();

	std::string domain = "local";
	std::string instance = "commonapi.speedsensor.SpeedSensor";
	std::string connection = "client-sample";

	// ssProxy = runtime->buildProxyWithDefaultAttributeExtension<SpeedSensorProxy, CommonAPI::Extensions::AttributeCacheExtension>(domain, instance, connection);
	// std::cout << "Waiting for service to become available." << std::endl;
	// while (!ssProxy->isAvailable()) {
	// 	std::this_thread::sleep_for(std::chrono::microseconds(10));
	// }
	// std::cout << "SpeedSensor service is available" << std::endl;


	instance = "commonapi.carcontrol.CarControl";
	ccProxy = runtime->buildProxyWithDefaultAttributeExtension<CarControlProxy, CommonAPI::Extensions::AttributeCacheExtension>(domain, instance, connection);
	std::cout << "Waiting for service to become available." << std::endl;
	while (!ccProxy->isAvailable()) {
		std::this_thread::sleep_for(std::chrono::microseconds(10));
	}
	std::cout << "CarControl service is available" << std::endl;


	// instance = "commonapi.carinfo.CarInfo";
	// ciProxy = runtime->buildProxyWithDefaultAttributeExtension<CarInfoProxy, CommonAPI::Extensions::AttributeCacheExtension>(domain, instance, connection);
	// std::cout << "Waiting for service to become available." << std::endl;
	// while (!ciProxy->isAvailable()) {
	// 	std::this_thread::sleep_for(std::chrono::microseconds(10));
	// }
	// std::cout << "CarInfo service is available" << std::endl;

}

// EXPORT
// void subscribe_speed()
// {
// 	CommonAPI::CallStatus callStatus;
// 	CommonAPI::CallInfo info(1000);
// 	info.sender_ = 5678;
// 	ssProxy->getSpeedAttribute().getValue(callStatus, _speed, &info);
// 	if (callStatus != CommonAPI::CallStatus::SUCCESS) {
// 		std::cerr << "Remote call A failed!\n";
// 		return;
// 	}
// 	std::cout << "Got attribute value: " << _speed << std::endl;
// 	ssProxy->getSpeedAttribute().getChangedEvent().subscribe([&](const int& val){
// 		//std::cout << "Received speed: " << val << std::endl;
// 		{
// 			std::lock_guard<std::mutex> lock(_mutex);
// 			_speed = val;
// 		}
// 	});
// 	std::cout << "subscribed" << std::endl;
// }

EXPORT
void subscribe_control()
{
	CommonAPI::CallStatus callStatus;
	CommonAPI::CallInfo info(1000);
	info.sender_ = 5678;
	ccProxy->getGearAttribute().getValue(callStatus, _gear, &info);
	if (callStatus != CommonAPI::CallStatus::SUCCESS) {
		std::cerr << "Remote call A failed!\n";
		return;
	}
	std::cout << "Got attribute value: " << _gear << std::endl;
	ccProxy->getGearAttribute().getChangedEvent().subscribe([&](const std::string& val){
		std::cout << "Received gear: " << val << std::endl;
		{
			std::lock_guard<std::mutex> lock(_mutex);
			_gear = val;
		}
	});
	
	ccProxy->getIndicatorAttribute().getValue(callStatus, _indicator, &info);
	if (callStatus != CommonAPI::CallStatus::SUCCESS) {
		std::cerr << "Remote call A failed!\n";
		return;
	}
	std::cout << "Got attribute value: " << _indicator << std::endl;
	ccProxy->getIndicatorAttribute().getChangedEvent().subscribe([&](const std::string& val){
		std::cout << "Received indicator: " << val << std::endl;
		{
			std::lock_guard<std::mutex> lock(_mutex);
			_indicator = val;
		}
	});
	std::cout << "subscribed" << std::endl;
}

// EXPORT
// void subscribe_info()
// {
// 	CommonAPI::CallStatus callStatus;
// 	CommonAPI::CallInfo info(1000);
// 	info.sender_ = 5678;
// 	ciProxy->getCar_infoAttribute().getValue(callStatus, _carinfo, &info);
// 	if (callStatus != CommonAPI::CallStatus::SUCCESS) {
// 		std::cerr << "Remote call A failed!\n";
// 		return;
// 	}
// 	// std::cout << "Got attribute value:\n"
// 	// 		<< "vol: " << _carinfo.getVoltage()
// 	// 		<< ", cur: " << _carinfo.getCurrent()
// 	// 		<< ", pwr: " << _carinfo.getPower()
// 	// 		<< ", bat: " << _carinfo.getBattery()
// 	// 		<< std::endl;
// 	ciProxy->getCar_infoAttribute().getChangedEvent().subscribe([&](const v1::commonapi::carinfo::CommonTypes::InfoStruct& val){
// 			std::cout << "Received value->"
// 			<< "vol: " << _carinfo.getVoltage()
// 			<< ", cur: " << _carinfo.getCurrent()
// 			<< ", pwr: " << _carinfo.getPower()
// 			<< ", bat: " << _carinfo.getBattery()
// 			<< std::endl;
// 		{
// 			std::lock_guard<std::mutex> lock(_mutex);
// 			_carinfo = val;
// 		}
// 	});
// }

// EXPORT
// int getSpeed()
// {
// 	std::lock_guard<std::mutex> lock(_mutex);
// 	return _speed;
// }

EXPORT
const char* getGear()
{
	std::lock_guard<std::mutex> lock(_mutex);
	return _gear.c_str();
}

// EXPORT
// const char* getIndicator()
// {
// 	std::lock_guard<std::mutex> lock(_mutex);
// 	return _indicator.c_str();
// }

// EXPORT
// carinfo getInfo()
// {
// 	std::lock_guard<std::mutex> lock(_mutex);
// 	carinfo ret = {_carinfo.getVoltage(),\
// 				_carinfo.getCurrent(),\
// 				_carinfo.getPower(),\
// 				_carinfo.getBattery()\
// 				};
// 	return ret;
// }

EXPORT
void setGear(const char* input)
{
	CommonAPI::CallStatus callStatus;
	CommonAPI::CallInfo info(1000);
	info.sender_ = 1234;
	bool res;
	std::string gear(input);
	ccProxy->ChangeGear(gear, callStatus, res, &info);
	if (res == true)
		std::cout << "Gear changed successfully" << std::endl;
	else
		std::cout << "Gear change failed" << std::endl;
}