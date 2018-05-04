//
//  NSObject+KVO.h
//  MA-KVO
//
//  Created by maker  on 2018/5/4.
//  Copyright © 2018年 maker . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MAObservingBlock)(id observedObject,NSString *observedKey,id oldValue,id newValue);

@interface NSObject (KVO)

- (void)MA_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(MAObservingBlock)block;

- (void)MA_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end
