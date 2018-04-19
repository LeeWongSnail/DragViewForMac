//
//  ArtDragViewDelegate.h
//  ArtDragView
//
//  Created by LeeWong on 2018/4/19.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@class ArtDragView;

@interface ArtDragViewDelegate : NSObject <NSGestureRecognizerDelegate>
@property (nonatomic, weak) ArtDragView *dragView;

@end
