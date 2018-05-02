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
#import <objc/message.h>

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
    //[self testMethod];
    //[self testTypeEncode];
    //[self testStrongCopy];
    [self testCopyAndMutableCopy:[MAPersion class] method:YES]; 
}

/**
 动态创建一个新类,从而测试元类
 */
- (void)ex_registerClassPair
{
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
}

/**
 测试类有多少方法
 */
- (void)testMethod
{
    uint count = 1;
    class_copyMethodList(object_getClass([MAPersion class]), &count);
    NSLog(@"%s---%d---%d",__func__,__LINE__,count);
}

/**
 测试类型编码
 */
- (void)testTypeEncode
{
    //MAPersion *p = [MAPersion new];
    //char *abcd = "maker";
    char abc = 'm';
    NSLog(@"%s---%d---%s",__func__,__LINE__,@encode(typeof(abc)));
}

/**
 测试关联对象
 */
static char mykey;
- (void)testAssociatedObject
{
    MAPersion *p = [MAPersion new];
    NSArray *dataSource = [NSArray new];
    
    objc_setAssociatedObject(p, &mykey, dataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dataSource = objc_getAssociatedObject(p, &mykey);
    //objc_removeAssociatedObjects(p)
}

/**
 测试 strong和 copy 的区别
 */
- (void)testStrongCopy
{
    NSMutableString *name = [NSMutableString new];
    [name appendString:@"maker"];
    MAPersion *p = [MAPersion new];
    p.name = name;
    [name appendString:@"123"];
    NSLog(@"%s---%d---%@",__func__,__LINE__,p.name);
}

/**
 测试 copy 和 mutableCopy在不同的类上的表现
 前两中对象Mutable类型的都是深拷贝
 NS 不可变类型的只有执行 copy 方法时是指针 copy,其他的都是对象 copy.
 对象类型的要执行 copy 或者 mutableCopy 方法必须实现 NSCopying和 NSMutableCopying 协议
 
 @param class 1.NSString NSMutableString 2.NSArray NSMutableArray ... 3.对象类型
 @param isCopy copy或者 mutableCopy.
 */
- (void)testCopyAndMutableCopy:(Class)class method:(BOOL)isCopy
{
    id ids = [[class alloc] init];
    id idsCopy = isCopy == 1 ? [ids copy] : [ids mutableCopy];
    NSLog(@"%s---%d---origin:%p copy:%p",__func__,__LINE__,ids,idsCopy);
}

- (void)testMsgSend
{
    void (*setter)(id,SEL,BOOL);
    
    MAPersion *p = [MAPersion new];
    setter = (void (*)(id,SEL,BOOL)) [p methodForSelector:@selector(doWork)];
    
}





@end
