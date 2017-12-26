//
//  SearchBookVC.h
//  Read
//
//  Created by wuyoujian on 2017/12/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BaseVC.h"
#import "BookItem.h"

@protocol SearchBookDelegate <NSObject>

- (void)didSelectBook:(BookItem *)book;
- (void)disNewBook:(BookItem *)newBook;

@end

@interface SearchBookVC : BaseVC
@property (nonatomic, weak) id <SearchBookDelegate> delegate;
@end
