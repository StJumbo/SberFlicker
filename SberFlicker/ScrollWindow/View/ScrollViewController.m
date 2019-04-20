//
//  ScrollViewController.m
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "ScrollViewController.h"
#import "ScrollPresenter.h"


@interface ScrollViewController ()

@property (nonatomic, strong)PhotoModel *picture;
@property (nonatomic, strong)ScrollPresenter *presenter;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColor.whiteColor];
    self.presenter = [ScrollPresenter new];
    self.presenter.netwotkDelegate = [NetworkService new];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    [activityIndicator setCenter:self.view.center];
    [activityIndicator startAnimating];
    if (self.picture.pictureURL)
    {
        [self.presenter.netwotkDelegate getImageFromURL:self.picture.pictureURL completion:^(UIImage * _Nonnull picture) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithImage:picture];
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
                [scrollView addSubview:imageView];
                [scrollView setScrollEnabled:YES];
                [scrollView setContentSize:imageView.bounds.size];
                
                [self.view addSubview:scrollView];
                [activityIndicator stopAnimating];
            });
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self removeSearchBar];
}

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

- (void)setCurrentPicture:(PhotoModel *)picture
{
    self.picture = picture;
}

@end
