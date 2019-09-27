//
//  UserModel+TempOperateInfo.m
//  TransitBox
//
//  Created by 刘彬 on 2019/3/8.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "LBUserModel+TempOperateInfo.h"
#import <objc/runtime.h>
@implementation LBUserModel (TempOperateInfo)

@dynamic tempOperateInfo;
static NSString *tempOperateInfoKey = @"TempOperateInfoKey";

- (NSMutableDictionary *)tempOperateInfo{
    return objc_getAssociatedObject(self, &tempOperateInfoKey);
}
-(void)setTempOperateInfo:(NSMutableDictionary *)tempOperateInfo{
    objc_setAssociatedObject(self, &tempOperateInfoKey, tempOperateInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

