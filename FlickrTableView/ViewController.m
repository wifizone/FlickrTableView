//
//  ViewController.m
//  FlickrTableView
//
//  Created by Антон Полуянов on 21/01/2018.
//  Copyright © 2018 Антон Полуянов. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "CustomCollectionViewCell.h"

const NSString* flickrKey = @"d";
static const CGFloat searchBarHeight = 40;

@interface ViewController () <NetworkServiceOutputProtocol, UISearchBarDelegate>

@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (nonatomic,strong) UISearchBar *mySearchBar;
@property NSMutableArray <UIImage*> *images;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NetworkService *networkService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self prepareUI];
}

- (void)prepareUI
{
    self.images = [NSMutableArray new];
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self prepareCollectionView];
    [self prepareSearchBar];
}

- (void)prepareCollectionView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.myCollectionView = [[UICollectionView alloc]
                             initWithFrame:CGRectMake(0, 20+searchBarHeight, CGRectGetMaxX(self.view.frame), CGRectGetMaxY(self.view.frame) - 20 - searchBarHeight)
                             collectionViewLayout:layout];
    [self.myCollectionView setDataSource:self];
    [self.myCollectionView setDelegate:self];
    
    
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}

- (void)prepareSearchBar
{
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, CGRectGetMaxX(self.view.frame), searchBarHeight)];
    [self.mySearchBar setBarStyle:UIBarStyleDefault];
    self.mySearchBar.delegate = self;
    [self.view addSubview:self.mySearchBar];
}


- (void)loadModelWithImages: (NSData *)images
{
    NSMutableArray *mutableImageArray = [NSMutableArray new];
    for (NSInteger i = 0; i < mutableImageArray.count; i++)
    {
//        [mutableImageArray addObject:[UIImage imageWithData:NSData]];
    }
    self.images = [NSMutableArray arrayWithArray:mutableImageArray];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    cell.image = self.images[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.images = [NSMutableArray new];
    [self.networkService startImageLoading:searchBar.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
    NSLog(@"Image downloaded");
    [self.images addObject:[UIImage imageWithData:dataRecieved]];
    [self.myCollectionView reloadData];
}


@end
