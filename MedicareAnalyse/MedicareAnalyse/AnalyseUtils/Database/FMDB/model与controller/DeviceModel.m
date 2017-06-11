//
//  DeviceModel.m
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel



-(instancetype)initWithDevice:(NSString *)dm OS:(NSString *)os osVersion:(NSString *)ov ScreenHeight:(NSString *)screenHeight ScreenWidth:(NSString *)screenWidth Carriers:(NSString *)carriers Imei:(NSString *)imei Uuid:(NSString *)uuid CpuInfo:(NSString *)cpuInfo SimSn:(NSString *)simSn  {
    self = [super init];
    if (self) {
        self.dm = dm;
        self.os = os;
        self.ov = ov;
        self.sh = screenHeight;
        self.sw = screenWidth;
        self.c = carriers;
        self.imei = imei;
        self.uuid = uuid;
        self.cpu = cpuInfo;
        self.sim = simSn;
    }
    return self;
}


@end
