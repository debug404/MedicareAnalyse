//
//  AnalyseManager.h
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyseConfig.h"


@interface AnalyseManager : NSObject

+(void) initAnalyse:(AnalyseConfig *)model;

/**
 *  启动app,不过不填写日志内容默认则默认 desc ＝ “app_start”
    eventtype = 1
 *
 */
+(void) onAppEvent:(NSString *)desc;


/**
 App启动日志
 */
+(void) onAppOPEN;

/**
 *  退出app,不过不填写日志内容默认则默认 
 */
+(void) onAppExitEvent;

/**
 *  页面打开
 *  eventtype ＝2
 */
+(void) onPageStart:(NSString *)pageName ;

/**
 *  页面关闭
 *  eventtype ＝2
 */
+(void) onPageEnd:(NSString *)eventid;

/**
 *  语音页面关闭
 *  eventtype ＝2
 */
+(void) onPageEnd:(NSString *)eventid andUnid:(NSString *)unid;


/**
 *  崩溃或错误日志 eventid：可能错误的对象或者时方法，desc:错误描述
 *  eventtype ＝6
 */
+(void) onErrorEvent:(NSString *)eventid andDesc:(NSString *)desc;

/**
 *  统计按钮点击事件
 *  eventtype ＝10
 */
+(void) onClickEvent:(NSString *)eventid andDesc:(NSString *)desc;

/**
 *  如果您还需要记录更详细的信息
 *
 *  @param eventid 当前操作对象
 *  @param dic     字典类型数据集合
 eventtype ＝7
 */
+(void) onEvent:(NSString *)eventid andDic:(NSDictionary *)dic;

/**
 *  记录语音相关日志(自定义eventtype)
 *
 *  @param eventid 操作的对象
 *  @param time    时长
 */
+(void) onVoiceEvent:(NSString *)eventid andVoiceDic:(NSDictionary *)_dic;

/**
 App切换医院时重新生成启动日志
 */
+ (void)onAppChangeHos;

/**
 *  进入后台
 *
 */
+(void)applicationWillResignActive;

/**
 *  进入前台
 *
 */
+(void)applicationDidBecomeActive;

/**
 记录用户在语音模块的操作日志
 @param eventidn
 @param handleType
 */
+(void) onEventVoice:(NSString *)eventid andHandleType:(NSString *)handleType andHandleStatus:(NSString *)status andUnid:(NSString *)unid;

/**
 *  初始化App启动时间
 *
 *  @param config
 */

+(void)initAppStartTime;

/**
 *  立即上传日志
 */
+(void) onFlush;


/**
 杀进程的日志
 */
+(void) onKillExitEvent;



//更新配置信息
+(void) updateDeptinfo:(AnalyseConfig *)config;


@end
