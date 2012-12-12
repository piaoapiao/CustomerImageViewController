//
//  ViewController.h
//  ImageLoadDemo
//
//  Created by zyun2 on 12-12-12.
//  Copyright (c) 2012年 zyun2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>
{
	NSMutableArray *assetGroups;
    UIScrollView *imageScrollView;
    NSMutableArray *imageArray;
}

@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic, retain) UIScrollView *imageScrollView;

-(void) showImageView:(NSArray *)imageList;
@end
