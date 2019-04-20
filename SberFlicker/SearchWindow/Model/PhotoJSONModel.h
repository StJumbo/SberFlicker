//
//  PhotoJSONModel.h
//  SberFlicker
//
//  Created by Сергей Грызин on 19/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoJSONModel : NSObject

@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger pagesTotal;
@property (nonatomic) NSArray<PhotoModel *> *photos;

@end

NS_ASSUME_NONNULL_END
