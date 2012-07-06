//
//  BookViewController.m
//  Norico
//
//  Created by 式正 鍋田 on 12/07/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "BookViewController.h"
#import "Verse.h"

@interface BookViewController ()

@end

@implementation BookViewController

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
        NSSortDescriptor *authorD = [[NSSortDescriptor alloc] initWithKey:@"book" ascending:NO];
        NSSortDescriptor *vidD=[[NSSortDescriptor alloc] initWithKey:@"vid" ascending:YES];
        NSArray *sort = [[NSArray alloc] initWithObjects:authorD, vidD, nil];
        [fetchRequest setSortDescriptors:sort];
        
        [fetchRequest setFetchBatchSize:20];
        _fetchedResultsController=[[NSFetchedResultsController alloc]
                                   initWithFetchRequest:fetchRequest 
                                   managedObjectContext:managedObjectContext
                                   sectionNameKeyPath:@"book"
                                   //sectionNameKeyPath:@"authorInitial"
                                   cacheName:@"Book"];
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
{     [super viewDidLoad];
 	// Do any additional setup after loading the view, typically from a nib.
    
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


- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    // Display the authors' names as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}
- (NSInteger) tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
                atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}



#ifdef __TEMP__
[book objectForKey:verse.book],
NSDictionary *book=[NSDictionary dictionaryWithObjectsAndKeys: 
                    @"00010001",@"古今和歌集　春歌 上", @"00010002",@"古今和歌集　春歌 下",
                    @"00010003",@"古今和歌集　夏歌",
                    @"00010004",@"古今和歌集　秋歌 上", @"00010005",@"古今和歌集　秋歌 下",
                    @"00010006",@"古今和歌集　冬歌",
                    @"00010007",@"古今和歌集　賀歌",
                    @"00010008",@"古今和歌集　離別歌",
                    @"00010009",@"古今和歌集　羈旅歌",
                    @"00010010",@"古今和歌集　物名",
                    @"00010011",@"古今和歌集　恋歌 一", @"00010012",@"古今和歌集　恋歌 二",
                    @"00010013",@"古今和歌集　恋歌 三", @"00010014",@"古今和歌集　恋歌 四",
                    @"00010015",@"古今和歌集　恋歌 五",
                    @"00010016",@"古今和歌集　哀傷歌",
                    @"00010017",@"古今和歌集　雑歌 上", @"00010018",@"古今和歌集　雑歌 下",
                    @"00010019",@"古今和歌集　雑体",
                    @"00010020",@"古今和歌集　大歌所御歌", 
                    @"00080001",@"新古今和歌集　春歌 上", @"00080002",@"新古今和歌集　春歌 下",
                    @"00080003",@"新古今和歌集　夏歌",
                    @"00080004",@"新古今和歌集　秋歌 上", @"00080005",@"新古今和歌集　秋歌 下",
                    @"00080006",@"新古今和歌集　冬歌",    @"00080007",@"新古今和歌集　賀歌",
                    @"00080008",@"新古今和歌集　哀傷歌",  @"00080009",@"新古今和歌集　離別歌",
                    @"00080010",@"新古今和歌集　羇旅歌",
                    @"00080011",@"新古今和歌集　恋歌　一", @"00080012",@"新古今和歌集　恋歌　二",
                    @"00080013",@"新古今和歌集　恋歌　三", @"00080014",@"新古今和歌集　恋歌　四",
                    @"00080015",@"新古今和歌集　恋歌　五",
                    @"00080016",@"新古今和歌集　雑歌 上", @"00080017",@"新古今和歌集　雑歌 中",
                    @"00080018",@"新古今和歌集　雑歌 下", @"00080019",@"新古今和歌集　神祇歌",
                    @"00080020",@"新古今和歌集　釈教歌", nil];

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#endif //#ifdef __TEMP__

@end
