//
//  ViewController.m
//  ImageLoadDemo
//
//  Created by zyun2 on 12-12-12.
//  Copyright (c) 2012年 zyun2. All rights reserved.
//

// ---------------WSAssetPickerState

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageDealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize assetGroups;
@synthesize imageScrollView;
@synthesize assetArray;
@synthesize imageArray;
@synthesize assetsLibrary = _assetsLibrary;

-(id)init
{
    if(self == [super init])
    {
        [self loadImages];
    }
    return self;
}

-(ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

-(NSMutableArray *)imageArray
{
    if(!imageArray)
    {
        imageArray = [[NSMutableArray alloc] init];
    }
    return imageArray;
}

-(NSMutableArray *)assetArray
{
    if(!assetArray)
    {
        assetArray = [[NSMutableArray alloc] init];
    }
    return assetArray;
}


-(BOOL)isSupportAutoLayOut
{
  //  int version = [[[UIDevice currentDevice].systemVersion substringToIndex:1] intValue];
    int version = [[UIDevice currentDevice].systemVersion intValue];
    if(version == 6)
    {
        return YES;
    }
    return NO;
}

-(void)loadImages
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                       
                       ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                           if (result!=NULL) {
                               
                               if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                               {
                                   //                                    NSLog(@"bigImage:%@",[UIImage imageWithCGImage:result.thumbnail]);
                                   //             [imageArray addObject:[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage]];
                                   [result retain];
                                   [self.assetArray addObject:result];
                                   //[assetArray addObject: [result copy]];
                                   [self.imageArray addObject:[UIImage imageWithCGImage:result.thumbnail]];
                                   
                               }
                           }
                           
                       };
                       
                       
                       void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                       {
                           if (group == nil)
                           {
                               return;
                           }
                           
                           //                           NSLog(@"count: %d", [group numberOfAssets]);
                           //                           NSLog(@"count: %@", group);
                           //                           NSLog(@"count: %@", [group class]);
                           
                           NSString *str = [NSString stringWithFormat:@"%@", [group valueForProperty:ALAssetsGroupPropertyName]];
                           
                           NSLog(@"name:%@",str);
                           
                           [self.assetGroups addObject:group];
                           
                           NSLog(@"count: %d", [group numberOfAssets]);
                           //                           if ([str isEqualToString:@"Saved Photos"])
                           {
                               [group enumerateAssetsUsingBlock:groupEnumerAtion];
                               
                               // [albumArray addObject:group];
                               //     NSString *str = [NSString stringWithFormat:@"%d", [group numberOfAssets]];
                               
                               //   [picsInAlbumArray addObject:str];
                               
                               //   [albumListTable reloadData];
                              // [self showImageView:imageArray];
                           }
                           
                           // Reload albums
                           [self performSelectorOnMainThread:@selector(showImageView:) withObject:self.assetGroups  waitUntilDone:YES];
                       };
                       
                       // Group Enumerator Failure Block
                       void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                           
                           
                           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@", [error description]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           [alert release];
                           
                           NSLog(@"A problem occured %@", [error description]);
                       };
                       
                       // Enumerate Albums
                       ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                       [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                              usingBlock:assetGroupEnumerator
                                            failureBlock:assetGroupEnumberatorFailure];
                      // [self performSelectorOnMainThread:@selector(showImageView:) withObject:self.assetGroups  waitUntilDone:YES];
                       
                       //  vtypedef void (^ALAssetsLibraryGroupsEnumerationResultsBlock)(ALAssetsGroup *group, BOOL *stop);
                       
                       
                       //  [library release];
                       
                       [pool release];
                   });

}

-(void)loadView
{
    UIView *tempView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.view = tempView;

    [tempView release];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Default"  ofType:@"png"];
    
    NSLog(@"path:%@",path);
    
	// Do any additional setup after loading the view, typically from a nib.
    
      
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *)imageScrollView
{
    if(nil == imageScrollView)
    {
        if([self isSupportAutoLayOut])
        {
            NSLog(@"AutoLayOut");
            
            imageScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [imageScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
            int h = imageScrollView.frame.size.height;
            int w = imageScrollView.frame.size.width;
            NSLog(@"H:%d,W:%d",h,w);

            h = imageScrollView.contentSize.height;
             w = imageScrollView.contentSize.width;
            NSLog(@"H:%d,W:%d",h,w);
            imageScrollView.delegate = self;
            [self.view addSubview:imageScrollView];
            
            NSMutableArray *conArray = [NSMutableArray array];
            NSArray *vecArr = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageScrollView)];
            NSArray *horArr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageScrollView)];
            [conArray addObjectsFromArray:vecArr];
            [conArray addObjectsFromArray:horArr];
            [self.view addConstraints:conArray];
        }
        else
        {
             NSLog(@"manualLayOut");
             imageScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
           //  imageScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
             imageScrollView.delegate = self;
             [self.view addSubview:imageScrollView];
            
        
        }
    }
    
    return imageScrollView;
    
    
}


//展示图片
-(void)showImageView:(NSArray *)imageList
{
    self.imageScrollView.backgroundColor = [UIColor redColor];

    int padding = 10;
    int lineNum = 3;

    float imageWidth = self.view.frame.size.width/lineNum -padding*(lineNum +1)/lineNum;
    
    float imageHeight = imageWidth;
    float temp = (self.imageScrollView.frame.size.height-padding)/(imageHeight+ padding);
    float tempInt = (int)temp;
    float rowNum;
    if(temp == tempInt)
    {
         rowNum = (self.imageScrollView.frame.size.height-padding)/(imageHeight+ padding);
    }
    else
    {
         rowNum = (self.imageScrollView.frame.size.height-padding)/(imageHeight+ padding)+1;    
    }
    
    for(int i = 0;i<self.imageArray.count;i++)
    {
        int imageIndex = i%lineNum;
        
        int imagerow = i/lineNum;
        
        float imageXOffset = padding + (imageWidth + padding)*imageIndex;
        
        float imageYOffset = padding + (imageHeight + padding)*imagerow;
       
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageXOffset, imageYOffset, imageWidth, imageHeight)];
        
        imageView.tag = i;
        
        imageView.image = imageArray[i];
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(selectImage:)];
        tapGuest.numberOfTouchesRequired = 1; //手指数
        tapGuest.numberOfTapsRequired = 1; //tap次数
        tapGuest.delegate = self;
        
        [imageView addGestureRecognizer:tapGuest];
        
        [tapGuest release];
       
        [imageScrollView addSubview:imageView];
        
        [imageScrollView setContentSize:CGSizeMake(self.view.frame.size.width, imageYOffset + imageHeight + padding )];
    }
    
    
}

-(void)selectImage:(UITapGestureRecognizer *)sender
{
    NSLog(@"selectImage:%d",sender.view.tag);
    int tag = sender.view.tag;
    ALAsset *set = (ALAsset *)[assetArray objectAtIndex:tag];
    UIImage *image = [UIImage imageWithCGImage:set.defaultRepresentation.fullScreenImage];
    NSLog(@"W:%f H:%f",image.size.width,image.size.height);
    ImageDealViewController *ctrl = [[ImageDealViewController alloc] initWithImage:image];
    //ctrl.imageView.image = image;
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//  //  transition.type = @"cube";
//    transition.type =@""
////    transition.subtype = kCATransitionFromRight;
//        transition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationTransitionFlipFromRight];
//    [UIView setAnimationDuration:0.5];
//    UIViewAnimationTransition transition = UIViewAnimationOptionTransitionNone;  
//    [UIView setAnimationTransition:transition forView:self.navigationController.view cache:YES];
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:ctrl animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
  //  [nextView release];
    
    
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [self.navigationController pushViewController:ctrl animated:YES];
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    

    for(ALAssetsGroup * group in self.assetGroups)
    {
        NSString *str = [NSString stringWithFormat:@"%@", [group valueForProperty:ALAssetsGroupPropertyName]];
        NSLog(@"album:%@",str);
    }
    
     
}



//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"offsetX:%f,offsetY:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//}

- (NSUInteger)supportedInterfaceOrientations
{
    //return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskPortraitUpsideDown|UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait;

}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//   
//}
//
//-(void)updateViewConstraints
//{
//    
//    [super updateViewConstraints];
//    [self removeImageView];
//     [self showImageView:imageArray];
//}
//
//-(void)removeImageView
//{
//    for(UIImageView *item in self.imageScrollView.subviews)
//    {
//        [item removeFromSuperview];
//    }
//}



@end
