//
//  FileUtil.m
//  MedicareAnalyse
//
//  Created by 洪旺 on 2016/12/1.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil


//读取文件
+(NSString *) readFile:(NSString *)path{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"文件存在");
    }
    else {
        NSLog(@"文件不存在");
        NSData *fileData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        [fileManager createFileAtPath:path contents:fileData attributes:nil];
    }
    
    NSData* data = [[NSData alloc] init];
    data = [fileManager contentsAtPath:path];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(str ==nil)
    {
        str = @"";
    }
    return str;
}



//写入文件
+(void)writeToFile:(NSString *)path andStr:(NSString *)str{
    
    NSError *error = nil;
    //atomically : YES时，没有写完，则会全部撤销；NO时候，没有写完，不会撤销
    //注意：这种写入方式，如果文件补存在，则创建；如果文件存在，则覆盖原文件的内容
    BOOL flag = [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];//一般error都设置为nil，保证写入成功
    
    if (flag) {
        NSLog(@"写入成功");
    }
    else{
        NSLog(@"写入失败");
    }
}
@end
