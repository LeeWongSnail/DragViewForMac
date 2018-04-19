//
//  ArtDragViewDelegate.m
//  ArtDragView
//
//  Created by LeeWong on 2018/4/19.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import "ArtDragViewDelegate.h"
#import "ArtDragView.h"

@implementation ArtDragViewDelegate

- (BOOL)gestureRecognizerShouldBegin:(NSGestureRecognizer *)gestureRecognizer {
    return self.dragView.dragEnable;
}


@end
