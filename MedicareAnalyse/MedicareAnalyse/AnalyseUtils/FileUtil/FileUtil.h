//
//  FileUtil.h
//  MedicareAnalyse
//
//  Created by 洪旺 on 2016/12/1.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject


/**
 读取指定的文件内容

 @param path <#path description#>
 @return <#return value description#>
 */
+(NSString *) readFile:(NSString *)path;



/**
 写入指定的文件内容

 @param path <#path description#>
 @param str <#str description#>
 */
+(void)writeToFile:(NSString *)path andStr:(NSString *)str;


@end
