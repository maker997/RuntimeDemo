//
//  NSObject+IvarList.m
//  ClassAndInstance
//
//  Created by maker  on 2018/5/3.
//  Copyright © 2018年 maker . All rights reserved.
//

#import "NSObject+IvarList.h"
#import <objc/runtime.h>

const void * ivarListKey = "ivarListKey";

@implementation NSObject (IvarList)

+ (NSArray *)ivarList;
{
    NSArray *resultArray = objc_getAssociatedObject(self, ivarListKey);
    if (resultArray != nil)
    {
        return resultArray;
    }
    
    __block uint  ivarCount = 1;
    Ivar *ivarList = class_copyIvarList([self class], &ivarCount);
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [array addObject:ivarName];
    }
    objc_setAssociatedObject(self, ivarListKey, array, OBJC_ASSOCIATION_COPY_NONATOMIC);
    free(ivarList);
    return objc_getAssociatedObject(self, ivarListKey);
}

@end
