//
//  ViewController.m
//  ImageLoadDemo
//
//  Created by zyun2 on 12-12-12.
//  Copyright (c) 2012年 zyun2. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize assetGroups;
@synthesize imageScrollView;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  //  NSString
    
    
    

    
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];
    
    imageArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                       
                       ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                           if (result!=NULL) {
                               
                               if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                               {  
//                                    NSLog(@"bigImage:%@",[UIImage imageWithCGImage:result.thumbnail]);
                      //             [imageArray addObject:[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage]];
                                     [imageArray addObject:[UIImage imageWithCGImage:result.thumbnail]];
                                   
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
                               [self showImageView:imageArray];
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
                       
                       //  vtypedef void (^ALAssetsLibraryGroupsEnumerationResultsBlock)(ALAssetsGroup *group, BOOL *stop);
                       
                       
                       [library release];
                       [pool release];
                   });
    
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
            int h = imageScrollView.contentSize.height;
            int w = imageScrollView.contentSize.width;
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
    
    for(int i = 0;i<imageArray.count;i++)
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
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"offsetX:%f,offsetY:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}

@end
