//
//  Pickuplines.h
//  EZpickup
//
//  Created by Leonard Yeo on 13/5/14.
//  Copyright (c) 2014 leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pickuplines : NSObject

@property (nonatomic, strong) NSString *pickuplinesText;
@property (nonatomic, strong) NSString *pickuplinesPostalCode;
@property (nonatomic, strong) NSString *pickuplinesCountry;
@property (nonatomic, strong) NSString *pickuplinesGender;

//methods
-(id) initWithPickuplinesText: (NSString *) PULtext;

@end
