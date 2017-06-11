//
//  AnalyseManager.m
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "AnalyseManager.h"
#import "DeviceModelController.h"
#import "LogModelController.h"
#import "PhoneUtil.h"
#import "DeviceModel.h"
#import "LogModel.h"
#import "CoreStatus.h"
#import "AESUtil.h"
#import "UUIDManager.h"
#import "AnalyseLocation.h"
#import "FileUtil.h"


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "IFlyUserDefaults.h"
#import "MJExtension.h"
#import "AnalyseHttpsManager.h"
#import "AFNetworking.h"


@interface AnalyseManager()

@end

@implementation AnalyseManager


+(void)initAppStartTime
{
    [IFlyUserDefault setObject:[PhoneUtil getStringTimeStamp] forKey:APP_START_TIME];
}

/**
 进入后台
 */
+(void)applicationWillResignActive{
    
    //记录页面关闭日志
    if([voicePageUnid isEqualToString:@""]){
        [self onPageEnd:showpage];
    }else{
        [self onPageEnd:showpage andUnid:voicePageUnid];
    }
    
    
    
    [self onAppEvent:BACKGROUND_OUT];
     NSLog(@"进入后台");
}


/**
 进入前台
 */
+(void)applicationDidBecomeActive{
    sessionId = [PhoneUtil uuidString];
    [IFlyUserDefault setObject:sessionId forKey:EVENT_SESSIONID];
    
    //进入前台重新算程序使用的开始时间
    [self initAppStartTime];
    
    [self onPageStart:showpage];
    
    NSLog(@"进入前台");
}

/**
 App切换医院时重新生成启动日志
 */
+ (void)onAppChangeHos {
    
    [self onAppEvent:CHANGE_HOS];
    
    sessionId = [PhoneUtil uuidString];
    [IFlyUserDefault setObject:sessionId forKey:EVENT_SESSIONID];
    
    [self initAppStartTime];
    [self onPageStart:showpage];
    NSLog(@"切换医院");
}


/**
 初始化上传策略
 */
static NSString *cityName =@"";
static NSString *sessionId = @"";
+(void) initAnalyse:(AnalyseConfig *)config{
    
    //生成会话 id
    sessionId = [PhoneUtil uuidString];
    [IFlyUserDefault setObject:sessionId forKey:EVENT_SESSIONID];
    
    [self initAppStartTime];
    
    //根据业务开发者设置缓存到本地，如用户使用网络设置 则替换本地缓存即可
    NSData *basedata = [NSKeyedArchiver archivedDataWithRootObject:config];
    [IFlyUserDefault setObject:basedata forKey:LOG_CONFIG];
    if ([config.isOpenAnalyse isEqualToString:CLOSE]) {
        return;
    }
   
    //创建设备信息存储表
    [DeviceModelController createDeviceTable];
    
    //创建日志存储表
    [LogModelController createLogTable];
    
    //上传机器的基本信息
    [self uploadDeviceInfo:config];
    
    //是否获取地理位置
    if ([config.autoLocation isEqualToString:OPEN]) {
        AnalyseLocation *location =  [AnalyseLocation sharedAnalyseLocationManager] ;
        [location startLocation];
        [location returnCity:^(NSString *city) {
            cityName = city;
        }];
    }
    
    //判断业务开发者是否允许收集奔溃日志
    if([config.crashLogEnable isEqualToString:OPEN]){
        [self registerCarseLog];
    }
    
    //开启一个定时器上传
    if([config.uploadStategy isEqualToString:LOG_TIME_UPLOAD]){
        [self initLocationTimer:[config.timeIntervals intValue]];
    }else if([config.uploadStategy isEqualToString:LOG_COUNT_UPLOAD]){
        [self stopTimer];
    }
}


/**
 * 初始化
 */
NSTimer *mTimer;
+(void) initLocationTimer:(int)time{
    [self stopTimer];
    NSLog(@"log timer start==== %d",time);
    mTimer = [ NSTimer scheduledTimerWithTimeInterval:time
                                                       target:self
                                                       selector:@selector(startTimer:)
                                                       userInfo:nil
                                                       repeats:YES];
}

/**
 *  定时上传日志
 */
+(void) startTimer:(NSTimer *)theTimer{
    [self onFlush];
}


/**
 *  销毁定时器
 */
+(void) stopTimer{
    if (mTimer !=nil) {
        [mTimer invalidate];
        mTimer = nil;
    }
}


/**
 *  上传用户手机信息
 */
+(void) uploadDeviceInfo:(AnalyseConfig *)config{
    DeviceModel * device = [PhoneUtil getPhoneModel];
    //本地数据库存储设备信息
    [DeviceModelController insertDevice:device];
    
    NSMutableArray *allparts = [NSMutableArray arrayWithArray:[DeviceModelController queryDeviceData]];
    
    NSString *url = @"";
    
    if (config.serverUrl == nil) {
        url = [@"http://192.168.57.116:8090" stringByAppendingString:DEVICE_URL];
    }else{
        url = [config.serverUrl stringByAppendingString:DEVICE_URL];
    }
    
    [AnalyseHttpsManager postRequest:url andParams:[allparts mj_JSONObject] ProgressBlock:^(double progress) {
        
    } Success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [DeviceModelController clearDeviceTabData];
            NSLog(@"__上传设备信息state==%@ 数据 == %@",[dict objectForKey:@"msg"],allparts);
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}




/**
 检查是否存在没有上传的设备信息
 */
+(void)checkNoUploadDeviceData:(AnalyseConfig *)config
{
    
    NSString *url = @"";
    if (config.serverUrl == nil) {
        url = [@"http://192.168.57.116:8090" stringByAppendingString:DEVICE_URL];
    }else{
        url = [config.serverUrl stringByAppendingString:DEVICE_URL];
    }
    
    
    NSMutableArray *allparts = [NSMutableArray arrayWithArray:[DeviceModelController queryDeviceData]];
    if (allparts.count != 0) {
        
        [AnalyseHttpsManager postRequest:url andParams:[allparts mj_JSONObject] ProgressBlock:^(double progress) {
            
        } Success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                [DeviceModelController clearDeviceTabData];
                NSLog(@"__上传设备信息state==%@ 数据 == %@",[dict objectForKey:@"msg"],allparts);
            }
        } fail:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }else{
        NSLog(@"不存在未上传的设备信息");
    }
}



+(void) onAppOPEN{
//    [self stopTimer];
    [self onAppEvent:APP_OPEN];
    [self onFlush];
}

/**
 *  退出app 检查是否有未上传的日志  如果有全部上传
 */
+(void) onAppExitEvent{
    [self stopTimer];
    [self onAppEvent:LOGIN_OUT];
    [self onFlush];
}

/**
 *  杀进程保存一下日志
 */
+(void) onKillExitEvent{
    [self onAppEvent:KILL_OUT];
}

/**
 *  页面打开
 *  eventtype ＝2
 */
static NSString *fromPage = @"";
static NSString *showpage = @"";
+(void) onPageStart:(NSString *)eventid {
    if(eventid == nil){
        return;
    }
    voicePageUnid = @"";
    showpage = eventid;
    [IFlyUserDefault setObject:[PhoneUtil getStringTimeStamp] forKey:showpage];
    
}

/**
 *  页面关闭
 *  eventtype ＝2
 */
+(void) onPageEnd:(NSString *)eventid {
    
    
    if(eventid == nil){
        return;
    }
    
    AnalyseConfig *config  = [NSKeyedUnarchiver unarchiveObjectWithData:[IFlyUserDefault objectForKey:LOG_CONFIG]];
    if ([config.isOpenAnalyse isEqualToString:@"NO"]) {
        return;
    }
    long  time = [[PhoneUtil getStringTimeStamp] longLongValue];
    long  pagetime = time -  [[IFlyUserDefault objectForKey:eventid] longLongValue];
   
    
    LogModel *model = [[LogModel alloc] init];
    model.eventid = eventid;
    model.desc = fromPage;
    model.duration = pagetime;
    model.date = [[PhoneUtil getTimeStampToString] longLongValue];
    model.eventtype = OPEN_PAGE_STR;
    NSMutableDictionary *extraDic = [[NSMutableDictionary alloc]init];
    [extraDic setObject:config.userPhone forKey:@"tele"];
    [extraDic setObject:cityName forKey:@"city"];
    
    if ([sessionId isEqualToString:@""]) {
        sessionId = [IFlyUserDefault notNullobjectForKey:EVENT_SESSIONID];
    }
    [extraDic setObject:sessionId forKey:@"accessId"];
    
    model.extradata = extraDic;
  
    
    [self logClassifyHandle:model];
    fromPage = eventid;

}


/**
 *  语音页面关闭
 *  eventtype ＝2
 */
static NSString *voicePageUnid = @"";
+(void) onPageEnd:(NSString *)eventid andUnid:(NSString *)unid{
    if(eventid == nil){
        return;
    }
    if (unid == nil) {
        unid = @"";
    }
    
    voicePageUnid = unid;
    AnalyseConfig *config  = [NSKeyedUnarchiver unarchiveObjectWithData:[IFlyUserDefault objectForKey:LOG_CONFIG]];
    long  time = [[PhoneUtil getStringTimeStamp] longLongValue];
    long  pagetime = time -  [[IFlyUserDefault objectForKey:eventid] longLongValue];
    LogModel *model = [[LogModel alloc] init];
    model.eventid = eventid;
    model.desc = fromPage;
    model.duration = pagetime;
    model.date = [[PhoneUtil getTimeStampToString] longLongValue];
    model.eventtype = OPEN_PAGE_STR;
    NSMutableDictionary *extraDic = [[NSMutableDictionary alloc]init];
    [extraDic setObject:config.userPhone forKey:@"tele"];
    [extraDic setObject:cityName forKey:@"city"];
    [extraDic setObject:unid forKey:@"unid"];
    
    if ([sessionId isEqualToString:@""]) {
        sessionId = [IFlyUserDefault notNullobjectForKey:EVENT_SESSIONID];
    }
    [extraDic setObject:sessionId forKey:@"accessId"];

    model.extradata = extraDic;
    [self logClassifyHandle:model];
    fromPage = eventid;
}


/**
 统计按钮点击事件

 @param eventid 按钮名称
 @param desc 描述
 */
+(void) onClickEvent:(NSString *)eventid andDesc:(NSString *)desc {
    LogModel *model = [[LogModel alloc] init];
    model.eventid = eventid;
    model.date = [[PhoneUtil getTimeStampToString] longLongValue];
    model.desc = desc;
    model.eventtype = CLICK_EVENT_ANAL;
    model.extradata = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [self logClassifyHandle:model];
}

/**
 *  如果您还需要记录更详细的信息
 *
 *  @param eventid 当前操作对象
 *  @param dic     字典类型数据集合
 eventtype ＝7
 */
+(void) onEvent:(NSString *)eventid andDic:(NSMutableDictionary *)dic{
    LogModel *model = [[LogModel alloc] init];
    model.eventid = eventid;
    model.extradata = [dic JSONString];
    model.date = [[PhoneUtil getTimeStampToString] longLongValue];
    model.eventtype = OTHER_LOG_STR;
    [self logClassifyHandle:model];
    
}



/**
 如果您还需要记录更详细的信息
 eventtype ＝7
 
 @param eventid 当前操作对象
 */
+(void) onEventVoice:(NSString *)eventid andHandleType:(NSString *)handleType andHandleStatus:(NSString *)status andUnid:(NSString *)unid{
    if (unid == nil) {
        unid = @"";
    }
    LogModel *model = [[LogModel alloc] init];
    model.eventid = eventid;
    
    if ([sessionId isEqualToString:@""]) {
        sessionId = [IFlyUserDefault notNullobjectForKey:EVENT_SESSIONID];
    }
    model.extradata = [[NSMutableDictionary alloc]
                          initWithObjectsAndKeys:handleType,@"handleType",
                       status,@"handleStatus", unid,@"unid",sessionId,@"accessId",nil];
    model.date = [[PhoneUtil getTimeStampToString] longLongValue];
    model.eventtype = VOICE_LOG_EVENT;
    [self logClassifyHandle:model];
    
}


/**
 *  崩溃或错误日志 eventid：可能错误的对象或者时方法，desc:错误描述
 *  eventtype ＝6
 */
+(void) onErrorEvent:(NSString *)eventid andDesc:(NSString *)desc{
    LogModel *model = [[LogModel alloc] init];
    model.eventid = eventid;
    model.date = [[PhoneUtil getTimeStampToString] longLongValue];
    model.desc = desc;
    model.eventtype = ERROR_LOG_STR;
    model.extradata = [NSMutableDictionary dictionaryWithDictionary:@{}];

    [self logClassifyHandle:model];
}




/**
 *  记录语音相关日志(自定义eventtype)
 *  @param _dic （开始时间/持续时间/是否成功）
 */
+(void) onVoiceEvent:(NSString *)eventid andVoiceDic:(NSMutableDictionary *)_dic{
    @try {
        
        NSString *uuid = @"";
        if([[_dic allKeys] containsObject:UNID])
        {
            uuid = [_dic objectForKey:UNID];
        }else{
            uuid =@"";
        }
        
        LogModel *model = [[LogModel alloc] init];
        model.eventid = eventid;
        model.date = [[_dic objectForKey:VOICE_STARTTIME] longLongValue];
        model.duration = [[_dic objectForKey:VOICE_DURATION] longLongValue];
        model.desc = @"";
        model.eventtype = VOICE_LOG_STR;
        NSString *desc = [_dic objectForKey:VOICE_DESC];
        
        if ([sessionId isEqualToString:@""]) {
            sessionId = [IFlyUserDefault notNullobjectForKey:EVENT_SESSIONID];
        }
        NSMutableDictionary *extraDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         [_dic objectForKey:VOICE_ONEVENT_STATUS],@"voiceStatus",
                                         desc == nil?@"":desc,@"voiceDesc",
                                         [_dic objectForKey:VOICE_TYPE],@"voiceType",
                                         uuid,@"unid",
                                         sessionId,@"accessId",
                                         nil];
        
        model.extradata = extraDic;
        [self logClassifyHandle:model];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}




/**
 *  处理各种事件类型的日志并往数据库插入数据
 *
 */
+(void) logClassifyHandle:(LogModel *)model
{
    @try {
        
        AnalyseConfig *config  = [NSKeyedUnarchiver unarchiveObjectWithData:[IFlyUserDefault objectForKey:LOG_CONFIG]];
        if ([config.isOpenAnalyse isEqualToString:@"NO"]) {
            return;
        }
        
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        int networkModel = [[CoreStatus currentNetWorkStatusString] intValue];
        NSString *imei = [UUIDManager getUUID];
        AESUtil *aesUtil = [[AESUtil alloc] init];
        NSString *fakeMacAddress = [PhoneUtil getFakeMacAddress];
        NSString *uuid = [aesUtil getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",fakeMacAddress, imei]];
        model.appVersion = appVersion;
        model.networkModel = networkModel;
        model.deviceId = uuid;
        model.networkModel = networkModel;
        model.appId = config.appId == nil?TEST_APPID:config.appId;
        model.extradata = model.extradata;
        model.locationId = [self readhoscode];
        model.channel = config.channel== nil?@"":config.channel;
        BOOL ret  = [LogModelController insertLog:model];
        if (ret) {
            NSLog(@"事件type  ＝ %@ save succ",model.eventtype);
        }
        
        //按照记录的数量上传
        if ([config.uploadStategy isEqualToString:LOG_COUNT_UPLOAD]) {
            [self stopTimer];
            
            //查询 目前表里面的日志条目数量
            NSMutableArray *array = [LogModelController queryLogDataNoeventtype:APP_START_STR];
            if (array != nil && array.count >= [config.uploadSize intValue]) {
                // 每次存储的日志 等于或超过config.uploadStategy 则上传
                NSLog(@"%@",array);
                
                NSString *url = @"";
                if (config.serverUrl == nil || [config.serverUrl isEqualToString:@""]) {
//                    url = [@"http://192.168.58.32:18080" stringByAppendingString:MOBILEX_LOG_URL];
                    NSLog(@"统计分析地址为空");
                    return;
                }else{
                    url = [config.serverUrl stringByAppendingString:MOBILEX_LOG_URL];
                }
                [AnalyseHttpsManager postRequest:url andParams:[array mj_JSONObject]ProgressBlock:^(double progress) {
                    
                } Success:^(NSDictionary *dict, BOOL success) {
                    if (success) {
                        [LogModelController deleteTab];
                        
                        NSLog(@"__onFlush 上传行为Log state==%@  data== %@",[dict objectForKey:@"msg"],array);
                    }
                } fail:^(NSError *error) {
                    
                }];
            }
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        
    } @finally {
        
    }
}

/**
 *  崩溃日志收集
 */
+(void) registerCarseLog{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

/**
 *  ios 崩溃之前会回调这个奔溃日志收集方法
 *
 */
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *arrString = [arr componentsJoinedByString:@" "];
    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    [AnalyseManager onErrorEvent:name andDesc:[reason stringByAppendingString:arrString] ];
}


/**
 *  立即上传日志
 */
+(void) onFlush{
    @try {
        AnalyseConfig *config  = [NSKeyedUnarchiver unarchiveObjectWithData:[IFlyUserDefault objectForKey:LOG_CONFIG]];
        [self checkNoUploadDeviceData:config];
        
        
        NSMutableArray *array = [LogModelController queryLogData];
        if (array != nil && array.count >0 ) {
            NSString *url = @"";
            if (config.serverUrl == nil) {
                url = [@"http://192.168.58.32:18080" stringByAppendingString:MOBILEX_LOG_URL];
            }else{
                url = [config.serverUrl stringByAppendingString:MOBILEX_LOG_URL];
            }
            
          
            
            [AnalyseHttpsManager postRequest:url andParams:[array mj_JSONObject] ProgressBlock:^(double progress) {
                
            } Success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    [LogModelController deleteTab];
                    NSLog(@"__onFlush 上传行为Log state==%@  data== %@",[dict objectForKey:@"msg"],array);
                }
            } fail:^(NSError *error) {
                NSLog(@"%@",error.description);
            }];
            
            
            // 每次flush 会在本地保存一份txt文件
            if ([config.isSavelog isEqualToString:OPEN]) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *fileName = [[PhoneUtil getTimeStampToString] stringByAppendingString:@".txt"];;
                NSString *docDir = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],fileName];
                
                NSError *error = nil;
                //convert object to data
                NSData* jsonData =[NSJSONSerialization dataWithJSONObject:array
                                                                  options:NSJSONWritingPrettyPrinted error:&error];
                NSString* jsonString =[[NSString alloc] initWithData:jsonData
                                                            encoding:NSUTF8StringEncoding];
                NSString *content = [NSString stringWithFormat:@"%@",jsonString];
                [FileUtil writeToFile:docDir andStr:content];
            }
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);

    } @finally {
        
    }
}



/**
 *  启动app,不过不填写日志内容默认则默认 desc ＝ “app_start”
 eventtype = 1
 */
+(void) onAppEvent:(NSString *)desc {
    
    @try {
        AnalyseConfig *config  = [NSKeyedUnarchiver unarchiveObjectWithData:[IFlyUserDefault objectForKey:LOG_CONFIG]];
        if ([config.isOpenAnalyse isEqualToString:@"NO"]) {
            return;
        }
        
        long time = [[PhoneUtil getTimeStampToString] longLongValue];
        long recordtime = time -  [[IFlyUserDefault objectForKey:APP_START_TIME] longLongValue];
        LogModel *model = [[LogModel alloc] init];
        
        if ([sessionId isEqualToString:@""]) {
            sessionId = [IFlyUserDefault notNullobjectForKey:EVENT_SESSIONID];
        }
        model.eventid  = sessionId;
        
        model.desc = desc;
        
    
        model.duration = recordtime;
    
        if ([desc isEqualToString:@"0"]) {
            model.duration = 0;
        }
        
        model.date = [[IFlyUserDefault objectForKey:APP_START_TIME] longLongValue];
        model.eventtype = APP_START_STR;
        
        NSMutableDictionary *extraDic = [[NSMutableDictionary alloc]init];
        [extraDic setObject:config.userPhone forKey:@"tele"];
        [extraDic setObject:cityName forKey:@"city"];
        
        
        [extraDic setObject:config.userName forKey:@"name"];
        [extraDic setObject:config.deptName forKey:@"deptName"];
        [extraDic setObject:config.deptCode forKey:@"deptCode"];
        
        if (config.userTitle) {
            [extraDic setObject:config.userTitle forKey:@"userTitle"];
        } else {
            [extraDic setObject:@"" forKey:@"userTitle"];
        }
       
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        int networkModel = [[CoreStatus currentNetWorkStatusString] intValue];
        NSString *imei = [UUIDManager getUUID];
        AESUtil *aesUtil = [[AESUtil alloc] init];
        NSString *fakeMacAddress = [PhoneUtil getFakeMacAddress];
        NSString *uuid = [aesUtil getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",fakeMacAddress, imei]];
        model.appVersion = appVersion;
        model.networkModel = networkModel;
        model.deviceId = uuid;
        model.networkModel = networkModel;
        model.appId = config.appId == nil?TEST_APPID:config.appId;
        model.extradata = extraDic;
        model.locationId = [self readhoscode];
        model.channel = config.channel== nil?@"":config.channel;
        BOOL ret  = [LogModelController insertLog:model];
        if (ret) {
            NSLog(@"启动日志 ＝ %@ save succ",model.eventtype);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        
    } @finally {
        
    }
}



+(NSString *) readhoscode
{
    AnalyseConfig *config  = [NSKeyedUnarchiver unarchiveObjectWithData:[IFlyUserDefault objectForKey:LOG_CONFIG]];
    NSString *hoscode = config.userHosCode;
    if (hoscode == nil) {
        hoscode = @"";
    }
    return hoscode;
}


+(void) updateDeptinfo:(AnalyseConfig *)config
{
    NSData *basedata = [NSKeyedArchiver archivedDataWithRootObject:config];
    [IFlyUserDefault setObject:basedata forKey:LOG_CONFIG];
}

@end
