//
//  AESUtil.h
//  RSADemo
//
//  Created by feiwu on 15/8/3.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Encryption.h"

@interface AESUtil : NSObject

- (NSString *)encryptWithKey:(NSString *)key andData:(NSData *)data;   //加密
- (NSString *)decryptWithKey:(NSString *)key andData:(NSData *)data;   //解密
- (NSData *)stringToHexData:(NSString *)str;                          //字符串转为二进制NSData

- (NSString *)getRadomString;

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString;

@end
