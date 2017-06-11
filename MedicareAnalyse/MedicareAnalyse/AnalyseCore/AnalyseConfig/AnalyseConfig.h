//
//  AnalyseConfig.h
//  MobileXCoreBusiness
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

//－－－－－－－－－－－－－－－－－－－－统计分析宏定义   start-------------------------

//启动日志类型 //修改为登出 类型 1正常登出 2 切换后台 3 杀进程

#define APP_OPEN @"0"
#define LOGIN_OUT @"1"
#define BACKGROUND_OUT @"2"
#define KILL_OUT @"3"
#define CHANGE_HOS @"4"


//app 首次启动时间
#define APP_START_TIME @"APP_START_TIME"

/**_______存储模式_________
 */
#define LOG_SQLTE_DATABASE @"LOG_SQLTE_DATABASE"

/**_______上传模式_________
 */
#define LOG_TIME_UPLOAD @"LOG_TIME_UPLOAD"
#define LOG_COUNT_UPLOAD @"LOG_COUNT_UPLOAD"

//记录医院code和手机号
//#define LOG_EXTRADATA @"LOG_EXTRADATA"
#define LOG_CONFIG @"LOG_CONFIG"
#define EVENT_SESSIONID @"EVENT_SESSIONID"

//日志种类
#define APP_START_STR @"1"
#define OPEN_PAGE_STR @"2"
#define COUNT_DOT_STR @"3"
#define COMPUTE_STR @"4"
#define SYSTEM_LOG_STR @"5"
#define ERROR_LOG_STR @"6"
#define OTHER_LOG_STR @"7"
#define VOICE_LOG_STR @"8"
#define VOICE_LOG_EVENT @"9"
#define CLICK_EVENT_ANAL @"10"

//用户种类
#define ANONYMITY_USER @"1"
#define REGISTER_USER @"2"
#define AUTH_USER @"3"

//appid 正式
#define PRODUCE_APPID @"f9e0152f4d055fa0001"

//appid 测试
#define TEST_APPID @"f9e0152f4d055fa0002"

//开关
#define OPEN @"YES"
#define CLOSE @"NO"

//－－－－－－－－－－－－－－－－－－－－语音日志统计宏定义   start-------------------------



//语音日志统计
//语音备忘 1
//语音病历 2
//语音待办 3
//语音医嘱 4
//语音命令 5
#define VOICE_NOTE @"1"
#define VOICE_CASE @"2"
#define VOICE_SCHEDULE @"3"
#define VOICE_DRUG @"4"
#define VOICE_NAVIGATION @"5"

//语音日志的描述 KEY
#define VOICE_DESC @"VOICE_DESC"
#define VOICE_TYPE @"VOICE_TYPE"
#define VOICE_ONEVENT_STATUS @"VOICE_ONEVENT_STATUS"

//操作状态 成功或失败
#define SUCCESS @"1"
#define FAIL @"0"

//语音开始时间
#define VOICE_STARTTIME @"VOICE_STARTTIME"

//语音耗时
#define VOICE_DURATION @"VOICE_DURATION"

//语音日志的标识ID
#define UNID @"UNID"

//语音模块用户行为 提交 保存 返回 删除
#define VOICE_SUBMIT @"1"
#define VOICE_SAVE @"2"
#define VOICE_BACK @"3"
#define VOICE_DELETE @"4"

//－－－－－－－－－－－－－－－－－－－－语音日志统计宏定义   End-------------------------


//－－－－－－－－－－－－－－－－－－－--统计分析宏定义   End-------------------------

@interface AnalyseConfig : NSObject

//科室名称
@property (nonatomic, copy) NSString* deptName;

//科室编码
@property (nonatomic, copy) NSString* deptCode;

//用户姓名
@property (nonatomic, copy) NSString* userName;

//渠道
@property (nonatomic, copy) NSString* channel;

//服务地址
@property (nonatomic, copy) NSString* serverUrl;

/**
 *  是否开启收集log
 */
@property (nonatomic, copy) NSString* isOpenAnalyse;

/**
 *  是否收集crash log
 */
@property  (nonatomic, copy) NSString* crashLogEnable;

/**
 *  是否自动获取定位
 */
@property  (nonatomic, copy) NSString* autoLocation;

/**
 *  获取用户手机号
 */
@property  (nonatomic, copy) NSString* userPhone;


/**
 *  用户userHosCode 医院编号
 */
@property  (nonatomic, copy) NSString* userHosCode;


/**
 *  每次上传的最大数量
 */
@property  (nonatomic, copy) NSString * uploadSize;


/**
 *  根据时间的策略上传
 */
@property  (nonatomic, copy) NSString * timeIntervals;


/**
 *  日志的纪录 目前只支持数据库存储
 */
@property (nonatomic, copy) NSString *saveType;

/**
 *  配置上传的模式 时间还是根据数量上传
 */
@property (nonatomic, copy) NSString *uploadStategy;


/**
 appid
 */
@property (nonatomic, copy) NSString *appId;


/**
 是否保存日志  默认保存在沙河DOCUMENTS 中
 */
@property (nonatomic, copy) NSString *isSavelog;

/**
 职称
 */
@property (nonatomic, copy) NSString *userTitle;

@end
