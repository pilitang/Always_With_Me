class_name TimeUtil
extends RefCounted

@warning_ignore("integer_division")
static func differ_time_day(time1:int,time2:int)->int:
	return int( (time2-time1) /60/60/24 )

#yyyy年MM月dd日HH时mm分 转 时间戳
static func string_to_time(timeStr : String)->int:
	timeStr = timeStr.replacen("年","-")
	timeStr = timeStr.replacen("月","-")
	timeStr = timeStr.replacen("日","-")
	timeStr = timeStr.replacen("时","-")
	timeStr = timeStr.replacen("分","-")
	timeStr = timeStr.replacen("秒","-")
	
	var timeArray = timeStr.split("-")
	timeArray.remove_at(timeArray.size()-1)
	while timeArray.size() < 6 :
		timeArray.append("0")
	var time = Time.get_unix_time_from_datetime_dict({
			"year":timeArray[0],
			"month":timeArray[1],
			"day":timeArray[2],
			"hour":timeArray[3],
			"minute":timeArray[4],
			"second":timeArray[5]
	})
	return time

static func time_to_ymd(time : int) -> String:
	var date = Time.get_datetime_dict_from_unix_time(time)
	return str(date.year)+"年"+str(date.month)+"月"+str(date.day)+"日"

static func time_to_ymdhm(time : int) -> String:
	var date = Time.get_datetime_dict_from_unix_time(time)
	return str(date.year)+"年"+str(date.month)+"月"+str(date.day)+"日"+str(date.hour+8)+"时"+str(date.minute)+"分"+str(date.second)+"秒"

static func time_to_HM(time : int) -> String:
	var date = Time.get_datetime_dict_from_unix_time(time)
	return str(date.hour+8)+"时"+str(date.minute)+"分"

@warning_ignore("integer_division")
static func differentMinutes(time1: int, time2: int) -> int :
	return (time2- time1)/ 60


@warning_ignore("integer_division")
static func differentDays(time1: int, time2: int) -> int :
		return (time2- time1)/( 3600*24 )

@warning_ignore("integer_division")
static func differentHours(time1: int, time2: int) -> int :
	return (time2- time1) / 3600 % 24



#网络校时 先进行set，然后再取；
@warning_ignore("integer_division")
static func serverTimeSeconds() -> int :
	return get_system_time_secs() + Global.timeOffset/1000

static func serverTimeMillsecond() -> int :
	return get_system_time_msecs() + Global.timeOffset



static func setTimeOffset(serverTime: int):
	var timeOffset = serverTime - get_system_time_msecs()
	if abs(timeOffset - Global.timeOffset) < 1000:# 1s之内的改变不考虑，防止时间跳来跳去
		return
	Global.timeOffset = timeOffset

static func get_system_time_msecs():
	return int(Time.get_unix_time_from_system()*1000) 

static func get_system_time_secs():
	return int(Time.get_unix_time_from_system()) 
