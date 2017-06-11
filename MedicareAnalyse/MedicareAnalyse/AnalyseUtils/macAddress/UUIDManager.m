//
//  UUIDManager.m
//  Medicare
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 medicare. All rights reserved.
//

#import "UUIDManager.h"
#import "KeyChainManager.h"
#import "IFlyUserDefaults.h"

#define KEY_IN_KEYCHAIN [[NSBundle mainBundle] bundleIdentifier]

#define KEY_IN_KEYCHAIN_USERDEFAULT [NSString stringWithFormat:@"%@_keychain",KEY_IN_KEYCHAIN]
@implementation UUIDManager

//static NSString * const KEY_IN_KEYCHAIN = @"com.iflytek.medicalassistant3";


+ (void)saveUUID:(NSString *)uuid{
    if (uuid && uuid.length > 0) {
        [KeyChainManager save:KEY_IN_KEYCHAIN data:uuid];
    }
}


+ (NSString *)getUUID{
    
    NSString *uuid = [IFlyUserDefault objectForKey:KEY_IN_KEYCHAIN_USERDEFAULT];
    if (uuid) {
        return uuid;
    }
    //先获取keychain里面的UUID字段，看是否存在
    uuid = (NSString *)[KeyChainManager load:KEY_IN_KEYCHAIN];
    
    //如果不存在则为首次获取UUID，所以获取保存。
    if (!uuid || uuid.length == 0) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        
        uuid = [NSString stringWithFormat:@"%@", uuidString];
        
        [self saveUUID:uuid];
        
        CFRelease(puuid);
        
        CFRelease(uuidString);
    }
    [IFlyUserDefault setObject:uuid forKey:KEY_IN_KEYCHAIN_USERDEFAULT];
    return uuid;
}



+ (void)deleteUUID{
    [KeyChainManager delete:KEY_IN_KEYCHAIN];
}

@end
