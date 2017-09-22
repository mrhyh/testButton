//
//  SGPhotoViewController.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//  图片浏览模式

#import <UIKit/UIKit.h>

@class SGPhotoModel;
@class SGPhotoBrowser;

@interface SGPhotoViewController : UIViewController

@property (nonatomic, weak) SGPhotoBrowser *browser;
@property (nonatomic, assign) NSInteger index;

@end
