//
//  ScrollViewController.m
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "ScrollViewController.h"
#import "ScrollPresenter.h"


@interface ScrollViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)PhotoModel *picture;
@property (nonatomic, strong)ScrollPresenter *presenter;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)CIFilter *filter;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColor.whiteColor];
    self.presenter = [ScrollPresenter new];
    self.presenter.netwotkDelegate = [NetworkService new];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator setCenter:self.view.center];
    [self.activityIndicator startAnimating];
    
    [self downloadPicture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self removeSearchBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self addFilterButton];
}

- (void)downloadPicture
{
    if (self.picture.pictureURL)
    {
        [self.presenter.netwotkDelegate getImageFromURL:self.picture.pictureURL completion:^(UIImage * _Nonnull picture) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView = [[UIImageView alloc] initWithImage:picture];
                CGFloat systemHeight = self.navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication.statusBarFrame.size.height;
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + systemHeight, self.view.bounds.size.width, self.view.bounds.size.height - systemHeight)];
                [scrollView setMinimumZoomScale:0.1f];
                [scrollView setMaximumZoomScale:2.0];
                [scrollView addSubview:self.imageView];
                [scrollView setScrollEnabled:YES];
                [scrollView setClipsToBounds:YES];
                [scrollView setContentSize:self.imageView.bounds.size];
                scrollView.delegate = self;
                
                [self.view addSubview:scrollView];
                self.image = picture;
                [self.activityIndicator stopAnimating];
            });
        }];
    }
}


#pragma mark - Setting picture

- (void)setCurrentPicture:(PhotoModel *)picture
{
    self.picture = picture;
}


#pragma mark - Working with NavBar

- (void)removeSearchBar
{
    NSArray *array = self.navigationController.navigationBar.subviews;
    for (int i = 0; i < array.count; i++)
    {
        UIView *view = array[i];
        if ([view isKindOfClass:UISearchBar.class])
        {
            [view removeFromSuperview];
        }
    }
}

- (void)addFilterButton
{
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Random filter" style:UIBarButtonItemStylePlain target:self action:@selector(setFilter)];
    [filterButton setWidth:100.0f];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:filterButton];
}


#pragma mark - ScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Filter functions

- (void)setFilter
{
    if (self.image)
    {
        CIImage *image = [[CIImage alloc] initWithImage:self.image];
        NSInteger index = arc4random() % 5;
        self.filter = [self filterWithType:index];
        [self.filter setValue:image forKey:kCIInputImageKey];
        CIImage *result = [self.filter valueForKey: @"outputImage"];
        CGImageRef cgImageRef = [[CIContext contextWithOptions:nil] createCGImage:result fromRect:[result extent]];
        UIImage *targetImage = [UIImage imageWithCGImage:cgImageRef];
        self.imageView.image = targetImage;
    }
    
    
}

- (CIFilter *)filterWithType:(NSInteger)type
{
    switch (type) {
        case 0:
            return [CIFilter filterWithName:@"CIPhotoEffectTonal"];
            break;
        case 1:
            return [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
            break;
        case 2:
            return [CIFilter filterWithName:@"CIPhotoEffectProcess"];
            break;
        case 3:
            return [CIFilter filterWithName:@"CIPhotoEffectNoir"];
            break;
        case 4:
            return [CIFilter filterWithName:@"CIColorMonochrome"];
            break;
            
        default:
            return nil;
            break;
    }
}

@end
