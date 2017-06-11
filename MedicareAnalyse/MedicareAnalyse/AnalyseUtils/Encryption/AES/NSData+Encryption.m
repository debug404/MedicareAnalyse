//
//  NSData+Encryption.m
//  AESDemo
//
//  Created by frog78 on 15/7/30.
//  Copyright (c) 2015年 frog78. All rights reserved.
//

#import "NSData+Encryption.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (Encryption)

- (NSData *)AES256ParmEncryptWithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256 + 2];
    //initial vector
    const char iv[18] = {'b','3','a','b','c','8','9','7','b','5','4','e','4','f','f','1'};
    BOOL patchNeeded;
    bzero(keyPtr, sizeof(keyPtr));
    patchNeeded= ([key length] > kCCKeySizeAES256+1);
    if(patchNeeded)
    {
        key = [key substringToIndex:kCCKeySizeAES256]; // Ensure that the key isn't longer than what's needed (kCCKeySizeAES256)
    }

    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    if (patchNeeded) {
        keyPtr[0] = '\0';  // Previous iOS version than iOS7 set the first char to '\0' if the key was longer than kCCKeySizeAES256
    }
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          iv,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256ParmDecryptWithKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES256  + 2];
    //initial vector
    const char iv[18] = {'b','3','a','b','c','8','9','7','b','5','4','e','4','f','f','1'};
    bzero(keyPtr, sizeof(keyPtr));
    BOOL patchNeeded;
    
    patchNeeded = ([key length] > kCCKeySizeAES256+1);
    if(patchNeeded)
    {
        key = [key substringToIndex:kCCKeySizeAES256]; // Ensure that the key isn't longer than what's needed (kCCKeySizeAES256)
    }
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    if (patchNeeded) {
        keyPtr[0] = '\0';  // Previous iOS version than iOS7 set the first char to '\0' if the key was longer than kCCKeySizeAES256
    }
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          iv,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end
