//
//  ViewController.m
//  ClassAndInstance
//
//  Created by maker  on 2018/4/25.
//  Copyright © 2018年 maker . All rights reserved.
//

#import "ViewController.h"
#import "MAPersion.h"
#import <objc/runtime.h>
#import <objc/objc.h>

@interface ViewController ()

@end

void TestMetaClass(id self,SEL _cmd)
{
    NSLog(@"this object is %p",self);
    NSLog(@"Class is %@,super class is %@",[self class],[self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p",i,currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    NSLog(@"NSObject's class is %p",[NSObject class]);
    NSLog(@"NSObject's meta class is %p",object_getClass([NSObject class]));
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self ex_registerClassPair];
    [self testMethod];
}

- (void)ex_registerClassPair
{
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
}

- (void)testMethod
{
    int count = 1;
    class_copyMethodList(object_getClass([MAPersion class]), &count);
    NSLog(@"%s---%d---%d",__func__,__LINE__,count);
}



@end
