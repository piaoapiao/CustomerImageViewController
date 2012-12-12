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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
                                   //                                   [self addImage:[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage]
                                   //                                       SmallImage:[UIImage imageWithCGImage:result.thumbnail]];
                                   NSLog(@"bigImage:%@",[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage]);
                                   
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
                           
                           if ([str isEqualToString:@"Saved Photos"])
                           {
                               [group enumerateAssetsUsingBlock:groupEnumerAtion];
                               
                               // [albumArray addObject:group];
                               NSString *str = [NSString stringWithFormat:@"%d", [group numberOfAssets]];
                               
                               //   [picsInAlbumArray addObject:str];
                               
                               //   [albumListTable reloadData];
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
        imageScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
        [imageScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        imageScrollView.delegate = self;
        [self.view addSubview:imageScrollView];
        
        NSMutableArray *conArray = [NSMutableArray array];
        NSArray *vecArr = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageScrollView]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageScrollView)];
        NSArray *horArr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageScrollView)];
        [conArray addObjectsFromArray:vecArr];
        [conArray addObjectsFromArray:horArr];
        [self.view addConstraints:conArray];
    }
    
    return imageScrollView;
    
}

-(void)showImageView:(NSArray *)imageList
{
    //   self.imageScrollView = nil;
    self.imageScrollView.backgroundColor = [UIColor redColor];
    id  res = imageList[0];
    
    
    
}


@end
