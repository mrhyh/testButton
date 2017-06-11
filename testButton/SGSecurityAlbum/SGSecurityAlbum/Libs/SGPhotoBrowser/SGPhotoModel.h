//
//  SGPhoto.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SGPMediaType) {
    SGPMediaTypeMediaTypeImage = 0,
    SGPMediaTypeMediaTypeVideo
};

@interface SGPhotoModel : NSObject

@property (nonatomic, copy) NSURL *photoURL;
@property (nonatomic, copy) NSURL *thumbURL;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, assign) SGPMediaType mediaType;
@property (nonatomic, assign) BOOL isSelected;

@end
