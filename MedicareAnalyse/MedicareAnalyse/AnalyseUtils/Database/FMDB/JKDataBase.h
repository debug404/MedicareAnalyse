//
//  JKDataBase.h
//  ismarter2.0_sz
//
//  Created by zx_04 on 15/6/24.
//
//

#import "FMDB.h"
@interface JKDataBase : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (JKDataBase *)shareInstance;

@end
