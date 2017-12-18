//
//  BookGridTableViewCell.m
//  Read
//
//  Created by wuyoujian on 2017/12/18.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BookGridTableViewCell.h"
#import "UIView+SizeUtility.h"
#import "BookItem.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation GridMenuItem
@end

static NSString *const kGridMenuCellIdentifier = @"kGridMenuCellIdentifier";

@interface inline_GridMenuCell : UICollectionViewCell
@property(nonatomic,copy) NSIndexPath           *indexPath;
@property(nonatomic,strong) UIImageView         *iconImageView;
@property(nonatomic,strong) UILabel             *titleLabel;

- (void)setGridMenu:(GridMenuItem*)menu;
@end

@implementation inline_GridMenuCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setGridMenu:(GridMenuItem*)menu {
    
    [_titleLabel setText:menu.title];
    [_titleLabel setFont:menu.titleFont];
    [_titleLabel setTextColor:menu.titleColor];
    
    // 远程icon
    NSString *imageKey  = [menu.icon md5EncodeUpper:NO];
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    UIImage * cacheimage = [imageCache imageFromDiskCacheForKey:imageKey];
    
    if (cacheimage == nil) {
        _iconImageView.image = [UIImage imageNamed:@"book_cover"];
        __weak inline_GridMenuCell *wSelf = self;
        [_iconImageView  sd_setImageWithURL:[NSURL URLWithString:menu.icon] placeholderImage:cacheimage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            inline_GridMenuCell *sSelf = wSelf;
            if (image) {
                sSelf.iconImageView.image = image;
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
            }
        }];
    } else {
        _iconImageView.image = cacheimage;
    }
    
    CGSize size = menu.iconSize;
    CGFloat textHeight = menu.titleFont.pointSize;
    CGFloat h = size.height;
    h += 5;
    h += textHeight;
    
    CGFloat top = (self.bounds.size.height - h) / 2.0;
    CGFloat left = (self.bounds.size.width - size.width) / 2.0;
    [_iconImageView setFrame:CGRectMake(left, top, size.width, size.height)];
    
    [_titleLabel setFrame:CGRectMake(0, self.bounds.size.height - top - textHeight, self.bounds.size.width, textHeight)];
}

@end

@interface BookGridTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView          *mainMenuView;
@property (nonatomic, strong) NSMutableArray            *menuDatas;
@property (nonatomic, assign) NSUInteger                menuWidth;
@property (nonatomic, assign) NSUInteger                menuHeight;
@property (nonatomic, assign) NSUInteger                space;
@property (nonatomic, assign) NSUInteger                contentHeight;
@end

@implementation BookGridTableViewCell

- (void)addBooks:(NSArray *)books {
    
    NSInteger bookWidth = 58;
    NSInteger bookHeight = 72;
    if ([DeviceInfo screenWidth] > 320) {
        bookWidth = 66;
        bookHeight = 86;
    }
    
    _menuWidth = bookWidth;
    _menuHeight = bookHeight + 5 + 14;
    _space = ([DeviceInfo screenWidth] - _menuWidth * 5 ) / 6;
    
    NSInteger row = [books count] % 5 == 0 ?[books count] / 5 : [books count] / 5 + 1;
    _contentHeight = row * _menuHeight + (row ) * _space;
    
    
    _mainMenuView.contentSize = CGSizeMake([DeviceInfo screenWidth], _contentHeight);
    _mainMenuView.height = _contentHeight;
    
    [_menuDatas removeAllObjects];
    for (BookItem *item in books) {
        NSString *title = item.name;
        NSString *pic = item.pic_big;
        
        GridMenuItem *menu = [[GridMenuItem alloc] init];
        menu.icon = pic;
        menu.title = title;
        menu.iconSize = CGSizeMake(bookWidth, bookHeight);
        menu.titleColor = [UIColor grayColor];
        
        menu.titleFont = [UIFont systemFontOfSize:11];
        if ([DeviceInfo screenWidth] > 320) {
            menu.titleFont = [UIFont systemFontOfSize:13];
        }
        
        [_menuDatas addObject:menu];
    }
    [_mainMenuView reloadData];
}

- (CGFloat)cellHeight {
    return _contentHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        NSInteger bookWidth = 58;
        NSInteger bookHeight = 72;
        if ([DeviceInfo screenWidth] > 320) {
            bookWidth = 66;
            bookHeight = 86;
        }
        
        _menuWidth = bookWidth;
        _menuHeight = bookHeight + 5 + 14;
        _space = ([DeviceInfo screenWidth] - _menuWidth * 5 ) / 6;
        
        _menuDatas = [[NSMutableArray alloc] initWithCapacity:0];
        //初始化
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = _space ;
        flowLayout.minimumLineSpacing = _space;
        flowLayout.headerReferenceSize = CGSizeZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        
        self.mainMenuView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [DeviceInfo screenWidth], 0) collectionViewLayout:flowLayout];
        // 注册
        [_mainMenuView registerClass:[inline_GridMenuCell class] forCellWithReuseIdentifier:kGridMenuCellIdentifier];
        _mainMenuView.backgroundColor = [UIColor whiteColor];
        _mainMenuView.showsVerticalScrollIndicator = NO;
        _mainMenuView.showsHorizontalScrollIndicator = NO;
        _mainMenuView.delegate = self;
        _mainMenuView.dataSource = self;
        _mainMenuView.bounces = YES;
        _mainMenuView.scrollEnabled = NO;
        [self.contentView addSubview:_mainMenuView];
    }
    
    return self;
}

#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_menuDatas count];
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    inline_GridMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGridMenuCellIdentifier forIndexPath:indexPath];
    
    [cell sizeToFit];
    cell.indexPath = indexPath;
    [cell setGridMenu:[_menuDatas objectAtIndex:indexPath.row]];
    
    return cell;
}

//
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets top = {0,_space,_space,_space};
    return top;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_menuWidth,_menuHeight);
}


//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectGridMenuIndex:)]) {
        [_delegate didSelectGridMenuIndex:indexPath.row];
    }
}

@end
