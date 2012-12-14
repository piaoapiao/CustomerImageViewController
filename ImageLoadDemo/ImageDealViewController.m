//
//  ImageDealViewController.m
//  ImageLoadDemo
//
//  Created by zyun2 on 12-12-14.
//  Copyright (c) 2012年 zyun2. All rights reserved.
//

#import "ImageDealViewController.h"

@interface ImageDealViewController ()

@end

@implementation ImageDealViewController

@synthesize imageView;
@synthesize image;

-(id)initWithImage:(UIImage *)image_
{
    self = [super init];
    if(self)
    {
        
        self.image = image_;
    }
    return  self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewDidLoad];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
