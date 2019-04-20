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
#import "SearchPresenter.h"
#import "SearchRouter.h"

@interface SearchViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) NSMutableArray<PhotoModel *> *collectionViewArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SearchPresenter *presenter;
@property (nonatomic, strong) NSMutableString *searchText;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL openFromPush;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.presenter = [SearchPresenter new];
    self.presenter.netwotkDelegate = [NetworkService new];
    self.presenter.routerDelegate = [SearchRouter new];
    
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
}


- (void)viewWillAppear:(BOOL)animated
{
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
    
    if (self.openFromPush)
    {
        [searchBar resignFirstResponder];
        [searchBar setText:self.searchText];
        self.collectionViewArray = [NSMutableArray new];
        self.currentPage = 0;
        [self searchNextPageWithText:self.searchText];
    }
    self.openFromPush = NO;
    self.searchText = [NSMutableString new];
    self.collectionViewArray = [NSMutableArray new];
    self.currentPage = 0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchText setString:@""];
}

- (void)setSearchingText:(NSString *)text
{
    self.openFromPush = YES;
    self.searchText = [NSMutableString new];
    [self.searchText setString:text];
}


#pragma mark - Support functions

- (void)searchNextPageWithText:(NSString *)text
{
    self.currentPage++;
    [self.presenter.netwotkDelegate findPhotosBySearchString:text onPage:self.currentPage completion:^(PhotoJSONModel * _Nonnull photoJSON) {
        if (!(photoJSON == nil))
        {
            [self.collectionViewArray addObjectsFromArray:photoJSON.photos];
            [self reloadCollectionView];
        }
    }];
}

#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = searchBar.text;
    if (![self.searchText isEqualToString:text])
    {
        [NSUserDefaults.standardUserDefaults setObject:text forKey:@"searchRequest"];
        [self.collectionViewArray removeAllObjects];
        [self reloadCollectionView];
        [self.searchText setString:text];
        [self searchNextPageWithText:text];
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    [self.searchText setString:@""];
    [self.collectionViewArray removeAllObjects];
    [self reloadCollectionView];
}


#pragma mark - CollectionView Delegate&DataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCell.reuseID forIndexPath:indexPath];
    PhotoModel *photoForCell = self.collectionViewArray[indexPath.item];
    if (photoForCell.thumbnailPicture != nil)
    {
        cell.picView.image = photoForCell.thumbnailPicture;
    }
    else
    {
        [self.presenter.netwotkDelegate getImageFromURL:self.collectionViewArray[indexPath.item].thumbnailPictureURL completion:^(UIImage * _Nonnull picture) {
            dispatch_async(dispatch_get_main_queue(), ^{
                PhotoCollectionViewCell *showingCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCell.reuseID forIndexPath:indexPath];
                if (showingCell)
                {
                    cell.picView.image = picture;
                    cell.picView.contentMode = UIViewContentModeScaleAspectFill;
                }
                else
                {
                    self.collectionViewArray[indexPath.item].thumbnailPicture = picture;
                }
                
            });
        }];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.collectionViewArray.count - 25)
    {
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
    [self.presenter.routerDelegate setNavVC:self.navigationController];
    [self.presenter.routerDelegate showPushNotificationsWindow];
}


@end
