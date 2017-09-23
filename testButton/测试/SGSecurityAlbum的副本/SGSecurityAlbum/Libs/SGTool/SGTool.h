//
//  SGTool.h
//  Codedlock
//
//  Created by hyh on 2017/9/14.
//  Copyright © 2017年 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SGTool : NSObject

/* 获取视频的某一帧 */
+ (UIImage*) getVideoPreViewImageWithVideoPath:(NSURL *)videoPath;

@end
