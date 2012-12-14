//
//  ViewController.h
//  ImageLoadDemo
//
//  Created by zyun2 on 12-12-12.
//  Copyright (c) 2012年 zyun2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsLibrary;
@interface ViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
	NSMutableArray *assetGroups;
    UIScrollView *imageScrollView;
    NSMutableArray *imageArray;
    NSMutableArray *assetArray;
    ALAssetsLibrary *assetsLibrary;
}

@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic, retain) UIScrollView *imageScrollView;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic,retain)  NSMutableArray *assetArray;
-(void) showImageView:(NSArray *)imageList;
@end
