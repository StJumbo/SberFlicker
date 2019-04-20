//
//  SearchViewController.m
//  SberFlicker
//
//  Created by Сергей Грызин on 16/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkService.h"
#import "PhotoJSONModel.h"
#import "PhotoModel.h"
#import "PhotoCollectionViewCell.h"

@interface SearchViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) NSMutableArray<PhotoModel *> *collectionViewArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableString *searchText;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger currentOffset;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    self.currentOffset = 0;
    self.searchText = [NSMutableString new];
    self.collectionViewArray = [NSMutableArray new];
    
    UIBarButtonItem *pushBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(openPushVC)];
    //Не знаю, почему ширина pushBarButtonItem при инициализации задается равной 0,
    //поэтому на глаз задал такую же ширину, как и у кнопки cancel searchbar'a
    [pushBarButtonItem setWidth:70.0f];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = pushBarButtonItem;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.bounds.origin.x + pushBarButtonItem.width, self.navigationController.navigationBar.bounds.origin.y, self.navigationController.navigationBar.bounds.size.width - pushBarButtonItem.width, self.navigationController.navigationBar.bounds.size.height)];
    [searchBar setShowsCancelButton:YES];
    [searchBar setPlaceholder:@"Search pictures..."];
    
    [self.navigationController.navigationBar addSubview:searchBar];
    searchBar.delegate = self;
    [searchBar becomeFirstResponder];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    CGFloat itemWidthOffset = 10.0f;
    CGFloat size = (self.view.bounds.size.width - 3 * itemWidthOffset) / 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(itemWidthOffset, itemWidthOffset, itemWidthOffset, itemWidthOffset);
    CGSize itemSize = CGSizeMake(size, size);
    [flowLayout setItemSize:itemSize];
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + navBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - navBarHeight) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:PhotoCollectionViewCell.class forCellWithReuseIdentifier:PhotoCollectionViewCell.reuseID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:UIColor.whiteColor];
    
    [self.view addSubview:self.collectionView];
    
//    NSString *picURL = @"https://live.staticflickr.com/4907/44426140660_fca2077ab0_h.jpg";
//    [NetworkService getImageFromURL:picURL completion:^(UIImage * _Nonnull picture) {
//        NSLog(@"PICTURE IS: \n%@", picture);
//    }];
}


#pragma mark - Support functions
- (void)searchNextPageWithText:(NSString *)text
{
    NSInteger nextPage = self.currentPage + 1;
    [NetworkService findPhotosBySearchString:text onPage:nextPage completion:^(PhotoJSONModel * _Nonnull photoJSON) {
        if (photoJSON.page < photoJSON.pagesTotal)
        {

        }
        if (!(photoJSON == nil))
        {
            NSLog(@"OVER HERE");
            self.currentPage = photoJSON.page;
            [self.collectionViewArray addObjectsFromArray:photoJSON.photos];
            [self reloadCollectionView];
        }
    }];
}

#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.collectionViewArray removeAllObjects];
    NSString *text = searchBar.text;
    [self.searchText setString:text];
    [self searchNextPageWithText:text];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    [self.searchText setString:@""];
    [self.collectionViewArray removeAllObjects];
    [self reloadCollectionView];
}


#pragma mark - CollectionView Delegate&DataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCell.reuseID forIndexPath:indexPath];
    [NetworkService getImageFromURL:self.collectionViewArray[indexPath.row].thumbnailPictureURL completion:^(UIImage * _Nonnull picture) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.picView.image = picture;
            cell.picView.contentMode = UIViewContentModeScaleAspectFill;
        });
    }];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.currentOffset)
    {
        self.currentOffset += 40;
        [self searchNextPageWithText:self.searchText];
    }
}


#pragma mark - Reload CollectionView

- (void)reloadCollectionView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


#pragma mark - Navigation

- (void)openPushVC
{
    NSLog(@"push pressed");
}


@end
