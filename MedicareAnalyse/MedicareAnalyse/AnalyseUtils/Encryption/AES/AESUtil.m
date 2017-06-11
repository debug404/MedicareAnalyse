//
//  AESUtil.m
//  RSADemo
//
//  Created by feiwu on 15/8/3.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//
#import "AESUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AESUtil

//转换http请求中特殊字符，如“+”等
-(NSString *)encodeStr:(NSString *)str
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef) str,NULL,CFSTR("!*'();:@&=+$,/?%#[]\" "),kCFStringEncodingUTF8));
    return escapedString;
}

//字符串转换为二进制NSData
- (NSData *)stringToHexData:(NSString *)str
{
    NSUInteger len = [str length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}

//NSData转为16进制字符串
- (NSString *)dataToHexString:(NSData *)data
{
    NSUInteger  len = [data length];
    char *      chars = (char *)[data bytes];
    NSMutableString *   hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    
    return hexString;
}

//16位MD5加密方式
- (NSString *)getMd5_16Bit_String:(NSString *)srcString{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self getMd5_32Bit_String:srcString];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    return result;
}


//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}


//AES加密
- (NSString *)encryptWithKey:(NSString *)key andData:(NSData *)data {
    
    NSString *encryptKey = [self getMd5_16Bit_String:key];
    
    NSData *encryptedData = [data AES256ParmEncryptWithKey:encryptKey];
    
    return [self dataToHexString:encryptedData];
}

//AES解密
- (NSString *)decryptWithKey:(NSString *)key andData:(NSData *)data {
    NSString *decryptKey = [self getMd5_16Bit_String:key];
    
    NSData *decryptedData = [data AES256ParmDecryptWithKey:decryptKey];
    NSString *result = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];

    return result;
}

//获取随机32位字符串
- (NSString *)getRadomString

{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}


@end
