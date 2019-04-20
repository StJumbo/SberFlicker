//
//  NetworkHelper.m
//  SberFlicker
//
//  Created by Сергей Грызин on 19/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (NSString *)URLFromSearchString:(NSString *)searchString
{
    NSString *APIKey = @"5553e0626e5d3a905df9a76df1383d98";
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=40&extras=url_s,url_h&format=json&nojsoncallback=1", APIKey, searchString];
}

@end
