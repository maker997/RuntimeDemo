//
//  ViewController.h
//  MA-KVO
//
//  Created by maker  on 2018/5/4.
//  Copyright © 2018年 maker . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MATestProtocol

- (void)test;

@end

@interface ViewController : UIViewController
/**
 * <#Description#>
 */
@property(nonatomic, strong) id<MATestProtocol> delegate;

@end

