
#import <Foundation/Foundation.h>

/**
 *  用户名
 */
extern NSString* const kcMFVDemoAuthID;

/**
 *  图片
 */
extern NSString* const kcMFVDemoImage;

/**
 *  MFV用户存储封装
 */
@interface IFlyUserDefault : NSObject  

/**
 *  获取存储项
 *
 *  @param key 存储项key
 *
 *  @return 存储项值
 */
+(id)objectForKey:(NSString*)key;
+(id)notNullobjectForKey:(NSString*)key;


/**
 *  设置存储项
 *
 *  @param object 存储项值
 *  @param key    存储项key
 */
+(void)setObject:(id)object forKey:(NSString*)key;

@end
