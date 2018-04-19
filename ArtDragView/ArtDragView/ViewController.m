//
//  ViewController.m
//  ArtDragView
//
//  Created by LeeWong on 2018/4/19.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "ArtView.h"
#import "ArtDragView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ArtDragView *view = [[ArtDragView alloc] initWithFrame:NSMakeRect(100, 100, 100, 100)];
    view.wantsLayer = YES;
    view.layer.backgroundColor = [NSColor redColor].CGColor;
    [self.view addSubview:view];
    // Do any additional setup after loading the view.
    
    
    view.beginDragBlock = ^(ArtDragView *dragView) {
        NSLog(@"begin-----");
    };
    
    view.duringDragBlock = ^(ArtDragView *dragView) {
        NSLog(@"duration");
    };
    
    view.endDragBlock = ^(ArtDragView *dragView) {
        NSLog(@"end");
    };
    
    view.clickDragViewBlock = ^(ArtDragView *dragView) {
        NSLog(@"click");
    };
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}


@end
