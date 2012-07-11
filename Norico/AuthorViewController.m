//
//  AuthorViewController.m
//  Norico
//
//  Created by 式正 鍋田 on 12/07/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "AuthorViewController.h"
#import "Verse.h"

@interface AuthorViewController ()

@end

@implementation AuthorViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;

-(NSFetchedResultsController*) fetchedResultsController
{
    if(_fetchedResultsController == nil){
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Verse" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // ソートのクリティリアとセクション分割の項目は合致していないといけないらしい。
        NSSortDescriptor *authorD = [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
        NSSortDescriptor *vidD=[[NSSortDescriptor alloc] initWithKey:@"vid" ascending:YES];
        NSArray *sort = [[NSArray alloc] initWithObjects:authorD, vidD, nil];
        [fetchRequest setSortDescriptors:sort];
        
        [fetchRequest setFetchBatchSize:20];
        _fetchedResultsController=[[NSFetchedResultsController alloc]
                                   initWithFetchRequest:fetchRequest 
                                   managedObjectContext:managedObjectContext
                                   sectionNameKeyPath:@"author"
                                   cacheName:@"Author"]; // cacheName:nil];
        _fetchedResultsController.delegate=self;
    }    
    return _fetchedResultsController;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{   
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [NSFetchedResultsController deleteCacheWithName:@"Author"];    
    NSError *error;    
    if(! [[self fetchedResultsController] performFetch:&error ] ){
        NSLog(@"Unresulved error %@, %@", error, [error userInfo] );
        exit(-1);
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}
- (NSInteger)numberInSection:(NSInteger)aSection
{
    return [[[self.fetchedResultsController sections] objectAtIndex:aSection] numberOfObjects];
}
-(Verse *) verseInIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}
-(BookViewStyle) bookviewStyle
{
    return BOOKVIEW_STYLE_AUTHOR;
}

- (NSString *)titleCookedForHeaderInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}
- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    return [self titleCookedForHeaderInSection:section];
//    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSArray *tmp = [self.fetchedResultsController sectionIndexTitles];
//    for (NSString* chk in tmp) {
//        NSLog(@"%@", chk);
//    }
//    return tmp;
    return [self.fetchedResultsController sectionIndexTitles];
}
- (NSInteger) tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
                atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}


@end
