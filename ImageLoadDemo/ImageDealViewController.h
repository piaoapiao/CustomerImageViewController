//
//  ImageDealViewController.h
//  ImageLoadDemo
//
//  Created by zyun2 on 12-12-14.
//  Copyright (c) 2012年 zyun2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDealViewController : UIViewController
{
    UIImageView *imageView;
    UIImage *image;
}
@property (nonatomic,retain)     UIImageView *imageView;
@property (nonatomic,retain)     UIImage *image;
@end
