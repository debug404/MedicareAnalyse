//
//  MFVUserDefaults.m
//  IFlyMFVDemo
//
//  Created by 张剑 on 15/5/12.
//
//

#import "IFlyUserDefaults.h"



@implementation IFlyUserDefault

+(id)objectForKey:(NSString*)key{
    if(key && [key length]>0){
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else{
        return nil;
    }
}
+(id)notNullobjectForKey:(NSString*)key{
    if(key && [key length]>0){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
            return [[NSUserDefaults standardUserDefaults] objectForKey:key];
        } else {
            return @"";
        }
    }
    else{
        return nil;
    }
}
+(void)setObject:(id)object forKey:(NSString*)key{
    if(key && [key length]>0 && object){
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    }
    else{
        return ;
    }
}

@end
