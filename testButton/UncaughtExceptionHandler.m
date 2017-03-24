//
//  UncaughtExceptionHandler.m
//  testButton
//
//  Created by hyh on 2017/3/17.
//  Copyright © 2017年 hyh. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const ExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const ExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const ExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger ExceptionHandlerSkipAddressCount = 4;
const NSInteger ExceptionHandlerReportAddressCount = 5;

@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace
{
    void  * callstack[128];
    
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = ExceptionHandlerSkipAddressCount;
         i < ExceptionHandlerSkipAddressCount +
         ExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)validateAndSaveCriticalApplicationData
{
}

- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationData];

     
     
     
     NSArray *array = [exception callStackSymbols];//得到当前调用栈信息
     NSString *reason = [exception reason];//非常重要，就是崩溃的原因
     NSString *name = [exception name];//异常类型
     
     NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, array);
     
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:ExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:ExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

@end

void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo
     setObject:callStack
     forKey:ExceptionHandlerAddressesKey];
    [[[UncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSMutableDictionary *userInfo =
    [NSMutableDictionary
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     forKey:ExceptionHandlerSignalKey];
    
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    [userInfo
     setObject:callStack
     forKey:ExceptionHandlerAddressesKey];
    [[[UncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:ExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.", nil),
       signal]
      userInfo:
      [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:ExceptionHandlerSignalKey]]
     waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
