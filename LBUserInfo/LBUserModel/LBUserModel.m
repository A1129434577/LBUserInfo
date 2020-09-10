//
//  LoginInfo.m
//  MBP_MAPP
//
//  Created by 刘彬 on 16/4/19.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBUserModel.h"
NSString *const LBUserInfo = @"LBUserInfo";//私有

NSString *const LBToken = @"LBToken";
NSString *const LBAccount = @"LBAccount";

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

-(NSDictionary *)userInfo{
    if (_privateUserInfo.count) {
        return _privateUserInfo;
    }else{
        _privateUserInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:LBUserInfo] mutableCopy];
        if (!_privateUserInfo) {
            _privateUserInfo = [[NSMutableDictionary alloc] init];
        }
        return _privateUserInfo;
    }
    return _privateUserInfo;
}
- (NSMutableDictionary *)privateUserInfo{
    if (!_privateUserInfo) {
        [self userInfo];
    }
    return _privateUserInfo;
}
- (void)setLBUserInfoObject:(id)anObject forKey:(id)aKey{
    if ([anObject isEqual:[NSNull null]]) {
        anObject = @"";
    }
    [self.privateUserInfo setValue:anObject forKey:aKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.privateUserInfo forKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)addEntriesForLBUserInfoFromDictionary:(NSDictionary *)otherDictionary{
    for (id key in otherDictionary.allKeys) {
        id anObject = otherDictionary[key];
        if ([anObject isEqual:[NSNull null]]) {
            anObject = @"";
        }
        [self.privateUserInfo setValue:anObject forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.privateUserInfo forKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeUserInfo{
    self.privateUserInfo = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeLBUserInfoAllObjects{
    [self removeLBUserInfoObjectsForKeys:self.privateUserInfo.allKeys];
}
- (void)removeLBUserInfoObjectForKey:(id)aKey{
    [self removeLBUserInfoObjectsForKeys:@[aKey]];
}

- (void)removeLBUserInfoObjectsForKeys:(NSArray*)keyArray{
    [self.privateUserInfo removeObjectsForKeys:keyArray];
    [[NSUserDefaults standardUserDefaults] setObject:self.privateUserInfo forKey:LBUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
