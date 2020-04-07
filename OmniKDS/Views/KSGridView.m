//
//  KSGridView.m
//  omniPOS
//
//  Created by Kumar Sharma on 12/02/19.
//  Copyright © 2019 Home. All rights reserved.
//

#import "KSGridView.h"
#import "KSGridTableViewCell.h"
#import "KSGridSection.h"

@implementation KSGridView
@synthesize gridSections;
@synthesize tableView;
@synthesize showInFullView;
@synthesize headerText1, headerText2;

- (id)initWithGridSections:(NSArray *)sections
{
    self = [super init];
    self.gridSections = sections;
    return self;
}

- (void)reloadGrid{
    
    [self.tableView reloadData];
    
    if(gridSections.count<=0){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
        label.font = [UIFont italicSystemFontOfSize:21];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"No Records!";
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableFooterView = label;
    }else{
        self.tableView.tableFooterView = nil;
    }
}

- (void)setupViews
{ 
    self.backgroundColor = [UIColor clearColor];
    
    UITableView *t1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStyleGrouped];
    t1.dataSource = self;
    t1.delegate = self;
    self.tableView = t1;
    UIView *bgView = [[UIView alloc] initWithFrame:t1.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    t1.backgroundView = bgView;
    t1.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.gridSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KSGridSection *gridSection = [self.gridSections objectAtIndex:section];
    return gridSection.colHeaders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 150)];
    UILabel *header1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, hview.bounds.size.width/2, hview.frame.size.height)];
    header1.numberOfLines = 10;
    header1.textAlignment = NSTextAlignmentCenter;
//    header1.text = headerText1;
    hview.layer.cornerRadius=0.5;
    hview.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    hview.layer.borderWidth=1;
    
    UILabel *header2 = [[UILabel alloc] initWithFrame:CGRectMake(hview.bounds.size.width/2, 0, hview.bounds.size.width/2, hview.frame.size.height)];
    header2.numberOfLines = 2;
    header2.textAlignment = NSTextAlignmentRight;
    header2.text = headerText2;
    
    [hview addSubview:header1];
//    [hview addSubview:header2];
    
    return hview;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    KSGridSection *gridSection = [self.gridSections objectAtIndex:section];
    return gridSection.sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d", (int)indexPath.section, (int)indexPath.row];
    
    KSGridSection *gridSection = [self.gridSections objectAtIndex:indexPath.section];
    KSGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BOOL requiredSetup = NO;
    if (cell == nil) {
        cell = [[KSGridTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier numberOfCell:gridSection.rowHeaders.count];
        cell.showInFullView = self.showInFullView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        requiredSetup = YES;
    }
    
    cell.viewWidth = self.frame.size.width;
    cell.showInFullView = self.showInFullView;

    if(requiredSetup)
        [cell setupSubviews];

    NSArray *row = [gridSection.gridData objectAtIndex:indexPath.row];
    for(UILabel *label in cell.cells)
    {
        if(indexPath.row == 0)
        {
            label.font = [UIFont boldSystemFontOfSize:21];
            label.text = [gridSection.rowHeaders objectAtIndex:[cell.cells indexOfObject:label]];
        }
        else
        {
            if([cell.cells indexOfObject:label] == 0)
            {
                label.font = [UIFont boldSystemFontOfSize:21];
                label.text = [gridSection.colHeaders objectAtIndex:indexPath.row];
            }
            else
            {
                label.font = [UIFont systemFontOfSize:19];
                label.text = [row objectAtIndex:[cell.cells indexOfObject:label]];
            }
        }
    }
    
    return cell;
}

@end
