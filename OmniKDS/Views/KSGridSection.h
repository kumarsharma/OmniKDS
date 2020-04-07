//
//  KSGridSection.h
//  omniPOS
//
//  Created by Kumar Sharma on 16/02/19.
//  Copyright © 2019 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KSGridSection : NSObject

@property (nonatomic, strong) NSArray *rowHeaders, *colHeaders, *gridData;
@property (nonatomic, strong) NSString *sectionTitle;

-(id)initWithRowHeaders:(NSArray *)rowHeaders columnHeaders:(NSArray *)colHeaders gridData:(NSArray *)gridData andTitle:(NSString *)title;
@end
