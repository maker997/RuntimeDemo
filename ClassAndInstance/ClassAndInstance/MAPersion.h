//
//  MAPersion.h
//  ClassAndInstance
//
//  Created by maker  on 2018/4/26.
//  Copyright © 2018年 maker . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAPersion : NSObject<NSCopying>
/**
 name
 */
@property(nonatomic, copy) NSString *name;
/**
 age
 */
@property (nonatomic, assign) NSInteger age;

//- (void)doWork;

+ (void)doWork;

@end
