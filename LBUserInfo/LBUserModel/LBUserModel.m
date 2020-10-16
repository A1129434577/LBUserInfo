//
//  LoginInfo.m
//  MBP_MAPP
//
//  Created by 刘彬 on 16/4/19.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBUserModel.h"
LBUserModelKey const LBUserInfo = @"LBUserInfo";//私有

LBUserModelKey const LBToken = @"LBToken";
LBUserModelKey const LBAccount = @"LBAccount";

@interface LBUserModel()
@property (nonatomic,strong)NSMutableDictionary *privateUserInfo;
@end

@implementation LBUserModel
+(LBUserModel *)shareInstanse{
    static LBUserModel *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[LBUserModel alloc] init];
    });
    return info;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _privateUserInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSDictionary *)userInfo{
    NSDictionary *userInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:LBUserInfo] mutableCopy];
    if (userInfo) {
        _privateUserInfo = userInfo;
    }else{
        _privateUserInfo = [[NSMutableDictionary alloc] init];
    }
    return userInfo;
}

- (void)setLBUserInfoObject:(id)anObject forKey:(id)aKey{
    if ([anObject isEqual:[NSNull null]]) {
        anObject = @"";
    }
    [_privateUserInfo setValue:anObject forKey:aKey];
    [[NSUserDefaults standardUserDefaults] setObject:_privateUserInfo forKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)addEntriesForLBUserInfoFromDictionary:(NSDictionary *)otherDictionary{
    for (id key in otherDictionary.allKeys) {
        id anObject = otherDictionary[key];
        if ([anObject isEqual:[NSNull null]]) {
            anObject = @"";
        }
        [_privateUserInfo setValue:anObject forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_privateUserInfo forKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeUserInfo{
    [_privateUserInfo removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeLBUserInfoAllObjects{
    [self removeLBUserInfoObjectsForKeys:_privateUserInfo.allKeys];
}
- (void)removeLBUserInfoObjectForKey:(id)aKey{
    [self removeLBUserInfoObjectsForKeys:@[aKey]];
}

- (void)removeLBUserInfoObjectsForKeys:(NSArray*)keyArray{
    [_privateUserInfo removeObjectsForKeys:keyArray];
    [[NSUserDefaults standardUserDefaults] setObject:_privateUserInfo forKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
