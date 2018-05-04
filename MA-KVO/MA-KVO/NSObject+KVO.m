//
//  NSObject+KVO.m
//  MA-KVO
//
//  Created by maker  on 2018/5/4.
//  Copyright © 2018年 maker . All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>

NSString *const kMAKVOClassPrefix = @"MAKVOClassPrefix_";

@implementation NSObject (KVO)

- (void)MA_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(MAObservingBlock)block
{
    // 1.检验key是否有 setter 方法
    Class observedClass = [self class];
    SEL setterSel = NSSelectorFromString(generateSetter(key));
    Method setterMethod = class_getInstanceMethod(observedClass, setterSel);
    if (!setterMethod)
    {
        NSString *reason = [NSString stringWithFormat:@"object %@ does not have a setter for key %@",self,key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    // 2.检验对象的 isa指针是否指向 KVO类,如果不是 KVO 类,那么新建一个子类继承自原来的类(KVO 类),并把对象的 isa指向新建的类(KVO 类)
    NSString *className = NSStringFromClass(observedClass);
    if (![className hasPrefix:kMAKVOClassPrefix]) {
        //不是 KVO 类
        Class kvoClass = [self generateKvoClassWithOriginalClassName:key];
        object_setClass(self, kvoClass);
    }
}

- (void)MA_removeObserver:(NSObject *)observer forKey:(NSString *)key
{
    
}

#pragma mark- Private Mthods

static NSString * generateSetter(NSString *key)
{
    if (key.length == 0)
    {
        return nil;
    }
    NSString *firstLetter = [[key substringToIndex:1] uppercaseString];
    NSString *remainingLetter = [key substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@",firstLetter,remainingLetter];
}

- (Class)generateKvoClassWithOriginalClassName:(NSString *)className
{
    NSString *KVOClassName = [NSString stringWithFormat:@"%@%@",kMAKVOClassPrefix,className] ;
    Class KVOClass = NSClassFromString(KVOClassName);
    if (KVOClass) {
        return KVOClass;
    }
    
    // KVO 类还没有存在,创建新的 kvo 类
    Class observedClass = NSClassFromString(className);
    KVOClass = objc_allocateClassPair(observedClass, KVOClassName.UTF8String, 0);
    
    // 从别观察对象类中获取 class 方法,添加到 KVO 类中,从而隐藏了KVO 类
    Method originalClassMethod = class_getInstanceMethod(observedClass, @selector(class));
    class_addMethod(KVOClass, @selector(class), method_getImplementation(originalClassMethod), method_getTypeEncoding(originalClassMethod));
    
    objc_registerClassPair(KVOClass);
    return KVOClass;
}
@end





















