//
//  PhoneUtil.m
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "PhoneUtil.h"
#import "AESUtil.h"
#import "RSAUtil.h"
#import "UUIDManager.h"
#import "sys/utsname.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#define kScreenWidth  CGRectGetWidth([[UIScreen mainScreen] bounds])
@interface PhoneUtil()
@property(nonatomic,strong)RSAUtil *rsaUtil;

@end

@implementation PhoneUtil


+(NSString *) getDeviceUUID{
    AESUtil *aesUtil = [[AESUtil alloc] init];
    UIDevice *device = [UIDevice currentDevice];
    NSString *imei = [[[device identifierForVendor] UUIDString]
                      stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *fakeMacAddress = [self getFakeMacAddress];
    NSString *uuid = [aesUtil getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",fakeMacAddress, imei]];
    return uuid;
}

+ (DeviceModel *)getPhoneModel {
    [self getDeviceUUID];
    AESUtil *aesUtil = [[AESUtil alloc] init];
    DeviceModel *deviceModel = [[DeviceModel alloc]init];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString * deviceName =  [self deviceVersion];
    
    NSString *imei = [UUIDManager getUUID];
    
    NSString *fakeMacAddress = [self getFakeMacAddress];
    
    NSString *uuid = [aesUtil getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",fakeMacAddress, imei]];
    
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;

    NSString *width = [NSString stringWithFormat:@"%.f", size_screen.width*scale_screen];
    
    NSString *height = [NSString stringWithFormat:@"%.f",size_screen.height*scale_screen];
    
    deviceModel = [[DeviceModel alloc] initWithDevice:deviceName OS:@"I" osVersion:device.systemVersion ScreenHeight:height ScreenWidth:width Carriers:[self checkChinaMobile] Imei:imei Uuid:uuid CpuInfo:@"" SimSn:@""];
    return deviceModel;
    
}

//由于真实mac地址被禁，生成一个假的地址
+ (NSString *)getFakeMacAddress {
    NSString *macAddress;
    macAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"fakeMacAdress"];
    if (macAddress == nil) {
        macAddress = @"E8:50:8B:08:BD:88";
        [[NSUserDefaults standardUserDefaults] setObject:macAddress forKey:@"fakeMacAdress"];
    }
    return macAddress;
}

+ (NSString *)checkChinaMobile
{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (carrier == nil)
        
    {
        return @"0";
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if (code == nil)
        
    {
        return @"0";
    }
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"])
    {
        return @"1";
    }else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]){
        return @"2";
    }else if ([code isEqualToString:@"20"] ){
        return @"0";
    }else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]){
        return @"3";
    }
    
    return @"0";
}

/**
 *  获取字符串时间戳
 *
 *  @return 时间戳
 */
+(NSString *) getTimeStampToString{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval=[dat timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *pwdKey = [NSString stringWithFormat:@"%0.f", interval]; //转为字符型
    return pwdKey;
}



/**
 *  获取字符串时间戳
 *
 *  @return 字符串时间戳
 */
+(NSString *)getStringTimeStamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    return [NSString stringWithFormat:@"%0.f", a]; //转为字符型
}

+ (NSString*)deviceVersion
{
    // 需要
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    　return deviceString;
}


+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

@end
