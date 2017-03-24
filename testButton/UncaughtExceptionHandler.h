//
//  UncaughtExceptionHandler.h
//  testButton
//
//  Created by hyh on 2017/3/17.
//  Copyright © 2017年 hyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject {
     BOOL dismissed;
}

+(void) InstallUncaughtExceptionHandler;

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);
