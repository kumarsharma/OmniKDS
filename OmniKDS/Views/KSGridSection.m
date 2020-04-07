//
//  KSGridSection.m
//  omniPOS
//
//  Created by Kumar Sharma on 16/02/19.
//  Copyright © 2019 Home. All rights reserved.
//

#import "KSGridSection.h"

@implementation KSGridSection
@synthesize rowHeaders, colHeaders, gridData;
@synthesize sectionTitle;

-(id)initWithRowHeaders:(NSArray *)rowHeaders columnHeaders:(NSArray *)colHeaders gridData:(NSArray *)gridData andTitle:(NSString *)title
{
    self = [super init];
    self.rowHeaders = rowHeaders;
    self.colHeaders = colHeaders;
    self.gridData = gridData;
    self.sectionTitle = title;
    
    return self;
}
@end
