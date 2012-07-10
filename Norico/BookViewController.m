//
//  BookViewController.m
//  Norico
//
//  Created by 式正 鍋田 on 12/07/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "BookViewController.h"
#import "Verse.h"
#import "Verse+BookTitle.h"

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
        NSSortDescriptor *authorD = [[NSSortDescriptor alloc] initWithKey:@"book" ascending:YES];
        NSSortDescriptor *vidD=[[NSSortDescriptor alloc] initWithKey:@"vid" ascending:YES];
        NSArray *sort = [[NSArray alloc] initWithObjects:authorD, vidD, nil];
        [fetchRequest setSortDescriptors:sort];
        
        [fetchRequest setFetchBatchSize:20];
        _fetchedResultsController=[[NSFetchedResultsController alloc]
                                   initWithFetchRequest:fetchRequest 
                                   managedObjectContext:managedObjectContext
                                   sectionNameKeyPath:@"book"
                                   cacheName:@"Book"]; // cacheName:nil];
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
 	// Do any additional setup after loading the view, typically from a nib.
    
    [NSFetchedResultsController deleteCacheWithName:@"Book"];
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
    // CategorySample
    // Verse* chk=[self.fetchedResultsController objectAtIndexPath:indexPath];
    // NSLog(@"%@", chk.titleVerseBookTitle);
    
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}
-(BookViewStyle) bookviewStyle
{
    return BOOKVIEW_STYLE_BOOK1;
}


- (NSString *)titleCookedForHeaderInSection:(NSInteger)section
{
    static NSDictionary *book=nil;
    book=[NSDictionary dictionaryWithObjectsAndKeys: 
          @"古今和歌集　春歌 上", @"00010001",@"古今和歌集　春歌 下",@"00010002",@"古今和歌集　夏歌",@"00010003",
          @"古今和歌集　秋歌 上", @"00010004",@"古今和歌集　秋歌 下",@"00010005",@"古今和歌集　冬歌",@"00010006",
          @"古今和歌集　賀歌",@"00010007",@"古今和歌集　離別歌",@"00010008",@"古今和歌集　羈旅歌", @"00010009",
          @"古今和歌集　物名",@"00010010",@"古今和歌集　恋歌 一",@"00010011", @"古今和歌集　恋歌 二",@"00010012",
          @"古今和歌集　恋歌 三",@"00010013", @"古今和歌集　恋歌 四",@"00010014",@"古今和歌集　恋歌 五",@"00010015",
          @"古今和歌集　哀傷歌",@"00010016",@"古今和歌集　雑歌 上",@"00010017", @"古今和歌集　雑歌 下",@"00010018",
          @"古今和歌集　雑体",@"00010019",@"古今和歌集　大歌所御歌", @"00010020",
          @"新古今和歌集　春歌 上",@"00080001", @"新古今和歌集　春歌 下",@"00080002",@"新古今和歌集　夏歌",@"00080003",
          @"新古今和歌集　秋歌 上", @"00080004",@"新古今和歌集　秋歌 下",@"00080005",
          @"新古今和歌集　冬歌", @"00080006", @"新古今和歌集　賀歌",@"00080007",
          @"新古今和歌集　哀傷歌",@"00080008",@"新古今和歌集　離別歌",@"00080009",@"新古今和歌集　羇旅歌",@"00080010",
          @"新古今和歌集　恋歌　一",@"00080011", @"新古今和歌集　恋歌　二",@"00080012",
          @"新古今和歌集　恋歌　三", @"00080013",@"新古今和歌集　恋歌　四",@"00080014",@"新古今和歌集　恋歌　五",@"00080015",
          @"新古今和歌集　雑歌 上", @"00080016",@"新古今和歌集　雑歌 中",@"00080017",
          @"新古今和歌集　雑歌 下",@"00080018", @"新古今和歌集　神祇歌",@"00080019",
          @"新古今和歌集　釈教歌", @"00080020",nil];
    NSString *title=[[[self.fetchedResultsController sections] objectAtIndex:section] name];
    return [book valueForKey:title];
}
- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    // Display the authors' names as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

/*
 sectionIndex の色を変更する
 http://stackoverflow.com/questions/750119/how-do-i-change-the-color-of-the-side-alphabet-in-an-indexed-uitableview
for(UIView *view in [tableView subviews]) {
    if([view respondsToSelector:@selector(setIndexColor:)]) {
        [view performSelector:@selector(setIndexColor:) withObject:[UIColor whiteColor]];
    }
}
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    // ほんとはここで　vid　のリストを返したい 
    return [self.fetchedResultsController sectionIndexTitles];
}
- (NSInteger) tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
                atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}



@end
