//
//  SGTool.m
//  Codedlock
//
//  Created by hyh on 2017/9/14.
//  Copyright © 2017年 soulghost. All rights reserved.
//

#import "SGTool.h"

@implementation SGTool


+ (UIImage*) getVideoPreViewImageWithVideoPath:(NSURL *)videoPath {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(0, 1); //当前第0秒第一帧，一秒60帧，当前时间  1/60
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

@end
