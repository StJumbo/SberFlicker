//
//  NetworkService.h
//  SberFlicker
//
//  Created by Сергей Грызин on 19/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PhotoJSONModel;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject

+ (void)findPhotosBySearchString:(NSString *)searchString onPage:(NSInteger)page completion:(void (^)(PhotoJSONModel *))completion;
+ (void)getImageFromURL:(NSString *)picURL completion:(void (^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
