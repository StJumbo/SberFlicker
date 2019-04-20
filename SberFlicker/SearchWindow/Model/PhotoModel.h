//
//  PhotoModel.h
//  SberFlicker
//
//  Created by Сергей Грызин on 19/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoModel : NSObject

@property (nonatomic) NSInteger farm;
@property (nonatomic) NSInteger ID;
@property (nonatomic) NSInteger secret;
@property (nonatomic) NSInteger server;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *pictureURL;
@property (nonatomic) NSString *thumbnailPictureURL;

@end

NS_ASSUME_NONNULL_END
