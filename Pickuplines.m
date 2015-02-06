//
//  Pickuplines.m
//  EZpickup
//
//  Created by Leonard Yeo on 13/5/14.
//  Copyright (c) 2014 leonard. All rights reserved.
//

#import "Pickuplines.h"

@implementation Pickuplines
@synthesize pickuplinesText, pickuplinesCountry, pickuplinesGender, pickuplinesPostalCode;

-(id) initWithPickuplinesText: (NSString *) PULtext
{
    self = [super init];
    if(self){
        pickuplinesText = PULtext;
        
    }
    
    return self;
    
}

@end
