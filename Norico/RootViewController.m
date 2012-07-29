//
//  RootViewController.m
//  NoriCo
//
//  Created by 式正 鍋田 on 12/06/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "RootViewController.h"
#import "QuoteCell.h"
#import "Verse.h"
#import "SectionHeaderView.h"
#import "SectionInfo.h"


#pragma mark -
#pragma mark EmailMenuItem
@interface EmailMenuItem : UIMenuItem 
@property (nonatomic, strong) NSIndexPath* indexPath;
@end
@implementation EmailMenuItem
@synthesize indexPath;
@end

//
//
@interface RootViewController ()
@property (nonatomic, strong) NSMutableArray* sectionInfoArray;
@property (nonatomic, strong) NSIndexPath* pinchedIndexPath;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) CGFloat initialPinchHeight;
// Use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously.
@property (nonatomic, assign) NSInteger uniformRowHeight;

@property (nonatomic, strong) UIActivityIndicatorView *spinner; 

@end

@implementation RootViewController
#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 45

@synthesize sectionInfoArray=_sectionInfoArray;
@synthesize pinchedIndexPath=_pinchedIndexPath;
@synthesize openSectionIndex=_openSectionIndex;
@synthesize initialPinchHeight=_initialPinchHeight;
@synthesize uniformRowHeight=_uniformRowHeight;
//@synthesize spinner=_spinner;
//
//
//

-(void) setSectionInfoArray:(NSMutableArray *)sectionInfoArray
{
    if(_sectionInfoArray != sectionInfoArray){
        _sectionInfoArray = sectionInfoArray;
        [self.tableView reloadData];
    }
}
/*
-(UIActivityIndicatorView *) spinner
{
    if(! _spinner){
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
#ifdef __NOT_YET__
        CGSize viewSize = self.view.bounds.size;
        
        // other size? change it
        _spinner.bounds = CGRectMake(0, 0, 65, 65);
        _spinner.hidesWhenStopped = YES;
        _spinner.alpha = 0.7f;
        _spinner.backgroundColor = [UIColor blackColor];
        //_spinner.layer.cornerRadius = 10.0f;
        
        // display it in the center of your view
        _spinner.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
#endif 
        
        [self.view addSubview:_spinner];
    }
    return _spinner;
}
*/

// Copy/Cut/Select/SelectAll のコンテキストメニュー表示を抑制する
-(BOOL)canBecomeFirstResponder {
    return YES;
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

    // 背景壁紙
    // UIImage *bg = [UIImage imageNamed:@"zen_washi001.png"];
    // self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
  
    
    // Add a pinch gesture recognizer to the table view.
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.tableView addGestureRecognizer:pinchRecognizer];
    
    
    // MenuItem(Mail/SMS) >>
    UILongPressGestureRecognizer* longPressReconizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.tableView addGestureRecognizer:longPressReconizer];
    // MenuItem(Mail/SMS) <<

    
    
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    /*
     The section info array is thrown away in viewWillUnload, 
     so it's OK to set the default values here. 
     If you keep the section information etc. 
     then set the default values in the designated initializer.
     */
    self.uniformRowHeight=DEFAULT_ROW_HEIGHT;
    self.openSectionIndex= NSNotFound;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated]; 
    // [self.spinner startAnimating];
	
    /*
     Check whether the section info array has been created, 
     and if so whether the section count still matches the current section count. 
     In general, you need to keep the section info synchronized with the rows and section. 
     If you support editing in the table view, 
     you need to appropriately update the section info during editing operations.
     */
	if ((self.sectionInfoArray == nil) || 
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:nil])) {

		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
#ifdef __TEST_NOT_BLOCK__
        // ここをBlock 化できないものか？
        for (NSInteger sec = 0; sec <[self numberOfSectionsInTableView:nil]; sec++) {
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.title = [self titleCookedForHeaderInSection:sec];
			sectionInfo.titleRaw = [self tableView:nil titleForHeaderInSection:sec];
			sectionInfo.open = NO;
			// NSLog(@"%d: %@", sec, sectionInfo.title);
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
            NSInteger countOfQuotations = [self numberInSection:sec];
			for (NSInteger i = 0; i < countOfQuotations; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
#else // #ifdef __TEST_NOT_BLOCK__
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

        dispatch_queue_t downloadQueue = dispatch_queue_create("setup sections", NULL);
        dispatch_async(downloadQueue, ^{
            for (NSInteger sec = 0; sec <[self numberOfSectionsInTableView:nil]; sec++) {
                SectionInfo *sectionInfo = [[SectionInfo alloc] init];
                sectionInfo.title = [self titleCookedForHeaderInSection:sec];
                sectionInfo.titleRaw = [self tableView:nil titleForHeaderInSection:sec];
                sectionInfo.open = NO;
                // NSLog(@"%d: %@", sec, sectionInfo.title);
                NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
                NSInteger countOfQuotations = [self numberInSection:sec];
                for (NSInteger i = 0; i < countOfQuotations; i++) {
                    [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                }
                [infoArray addObject:sectionInfo];
            }            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sectionInfoArray = infoArray;
                self.navigationItem.rightBarButtonItem = nil;
            });
        });
        dispatch_release(downloadQueue);
#endif //#ifdef __TEST_NOT_BLOCK__
        
	}
    // [self.spinner stopAnimating];

	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sectionInfoArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberInSection:(NSInteger)aSection
{
    return 0;
}
-(Verse *) verseInIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}
-(BookViewStyle) bookviewStyle
{
    return BOOKVIEW_STYLE_BOOK1;
}
- (NSString *) titleCookedForHeaderInSection:(NSInteger)section
{
    return nil;
}

// 20120702>>
// stackoverflow:2167857 'Non-US-character-in ¥-selection-headers-for-a-uitableView
-(NSString*) controller:(NSFetchedResultsController *)controller 
sectionIndexTitleForSectionName:(NSString *)sectionName
{
    if (sectionName.length>1) {
        return [sectionName substringWithRange:NSMakeRange(0, 2)] ;
    }
    else {
        return sectionName;
    }
}
// 20120702<<

// amount in each section
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
// #warning Incomplete method implementation.
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    NSInteger numStoriesInSection = [sectionInfo.rowHeights count];	
    return sectionInfo.open ? numStoriesInSection : 0;

}


-(void) configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath*)indexPath
{
    //cell.verse = [self.fetchedResultsController objectAtIndexPath:indexPath];
    QuoteCell*vcell=(QuoteCell*)cell;
    vcell.verse = [self verseInIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuoteCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    if (([MFMailComposeViewController canSendMail]) ||
        ([MFMessageComposeViewController canSendText]) ||
        ([TWTweetComposeViewController canSendTweet])) {
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [cell addGestureRecognizer:longPressRecognizer];        
    }
    else {
        NSLog(@"Any Massage functions is not available");
    }
    
    return cell;
}

#pragma mark - Table view delegate


-(UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section
{
    /*
     Create the section header views lazily.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
        //NSLog(@"sec:%d title:%@", section,sectionInfo.title);
		NSString *titleName = sectionInfo.title;
        NSInteger style = 0;
        if (self.bookviewStyle == BOOKVIEW_STYLE_AUTHOR) {
            style=0;
            titleName = sectionInfo.titleRaw;
        }
        else {
            style=1;
            if([[sectionInfo.titleRaw substringToIndex:4] isEqualToString:@"0001"]){
                style=2;
            }
        }
        sectionInfo.headerView = [[SectionHeaderView alloc] 
                                  initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) 
                                  title:titleName 
                                  section:section 
                                  style:style
                                  delegate:self];
    }
    
    return sectionInfo.headerView;
}


-(CGFloat)      tableView:(UITableView*)tableView
  heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

//
// 選択したセルの高さを変更する。
// 別のセルが選択された時点でセルの高さはリセットされる。
//
- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"didSelect: %@", indexPath);
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    for (NSInteger i = 0; i < sectionInfo.rowHeights.count; i++) {
        if(i == indexPath.row){
            [sectionInfo replaceObjectInRowHeightsAtIndex:i withObject:[NSNumber numberWithFloat:DEFAULT_ROW_HEIGHT*2]];
        }
        else {
            [sectionInfo replaceObjectInRowHeightsAtIndex:i withObject:[NSNumber numberWithFloat:DEFAULT_ROW_HEIGHT]];
        }

    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - FetchResultController delegate
-(void) controllerWillChangeContent:(NSFetchedResultsController*) controller
{
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath 
{    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


//
//
//
#pragma mark Section header delegate
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView
           sectionOpened:(NSInteger)sectionOpened
{
    NSLog(@"sectionOpened:%d",sectionOpened);
//    [self.spinner startAnimating];
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	sectionInfo.open = YES;
    
    // dispatch_queue_t testq = dispatch_queue_create("com.norimasanabeta.noriko.main", NULL);
    /*
     Create an array containing the index paths of the rows to insert:
     These correspond to the rows for each quotation in the current section.
     */
#ifdef __TEST_NOT_BLOCK__
    NSInteger countOfRowsToInsert = [self numberInSection:sectionOpened];
    NSLog(@"sectionOpened:%d ToInsert:%d",sectionOpened,countOfRowsToInsert);

    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    /*
     Create an array containing the index paths of the rows to delete:
     These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [self numberInSection:previousOpenSectionIndex];
        NSLog(@"sectionOpened:%d ToDelete:%d",sectionOpened,countOfRowsToDelete);

        // memory leak problem!!!
        // dispatch_async(testq, ^{
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
        // });
    }
    // dispatch_release(testq);
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
//    [self.spinner stopAnimating];
#else //#ifdef __TEST_NOT_BLOCK__
    NSInteger countOfRowsToInsert = [self numberInSection:sectionOpened];
    NSLog(@"sectionOpened:%d ToInsert:%d",sectionOpened,countOfRowsToInsert);
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = self.openSectionIndex;

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
 
    dispatch_queue_t downloadQueue = dispatch_queue_create("open sections", NULL);
    dispatch_async(downloadQueue, ^{
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
        }
        if (previousOpenSectionIndex != NSNotFound) {
            SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
            previousOpenSection.open = NO;
            [previousOpenSection.headerView toggleOpenWithUserAction:NO];
            NSInteger countOfRowsToDelete = [self numberInSection:previousOpenSectionIndex];
            NSLog(@"sectionOpened:%d ToDelete:%d",sectionOpened,countOfRowsToDelete);
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
            }
        }
    
        // Style the animation so that there's a smooth flow in either direction.
        UITableViewRowAnimation insertAnimation;
        UITableViewRowAnimation deleteAnimation;
        if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
            insertAnimation = UITableViewRowAnimationTop;
            deleteAnimation = UITableViewRowAnimationBottom;
        }
        else {
            insertAnimation = UITableViewRowAnimationBottom;
            deleteAnimation = UITableViewRowAnimationTop;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
            [self.tableView endUpdates];
            self.openSectionIndex = sectionOpened;
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
    dispatch_release(downloadQueue);

#endif //#ifdef __TEST_NOT_BLOCK__

// Block code sample:
//    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
//    dispatch_async(downloadQueue, ^{
//        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.photos = photos;
//        });
//    });
//    dispatch_release(downloadQueue);
#ifdef __TEST_NOT_BLOCK__
#else //#ifdef __TEST_NOT_BLOCK__
#endif //#ifdef __TEST_NOT_BLOCK__
}
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView
           sectionClosed:(NSInteger)sectionClosed
{
    NSLog(@"sectionClosed:%d",sectionClosed);
    /*
     Create an array of the index paths of the rows in the section that was closed,
     then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    NSLog(@"sectionClosed:%d ToDelete:%d",sectionClosed,countOfRowsToDelete);
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
#ifdef __TEST_NOT_BLOCK__
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
#else //#ifdef __TEST_NOT_BLOCK__
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];

        dispatch_queue_t downloadQueue = dispatch_queue_create("delete sections", NULL);
        dispatch_async(downloadQueue, ^{
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
                //[self.tableView reloadData];
                self.navigationItem.rightBarButtonItem = nil;
            });
        });
        dispatch_release(downloadQueue);
#endif //#ifdef __TEST_NOT_BLOCK__
    }
    self.openSectionIndex = NSNotFound;
}

//
// コンテキストメニューを表示した時点でセルの幅を広げるようにしたい。
//
//
//
// テキストエリアを広げたり、狭めたりする
#pragma mark Handling pinches
-(void)handlePinch:(UIPinchGestureRecognizer*)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {        
        CGPoint pinchLocation = [pinchRecognizer locationInView:self.tableView];
        NSIndexPath *newPinchedIndexPath = [self.tableView indexPathForRowAtPoint:pinchLocation];
		self.pinchedIndexPath = newPinchedIndexPath;
        
		SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:newPinchedIndexPath.section];
        self.initialPinchHeight = [[sectionInfo objectInRowHeightsAtIndex:newPinchedIndexPath.row] floatValue];
        // Alternatively, set initialPinchHeight = uniformRowHeight.
        
        [self updateForPinchScale:pinchRecognizer.scale atIndexPath:newPinchedIndexPath];
    }
    else {
        if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
            [self updateForPinchScale:pinchRecognizer.scale atIndexPath:self.pinchedIndexPath];
        }
        else if ((pinchRecognizer.state == UIGestureRecognizerStateCancelled) || 
                 (pinchRecognizer.state == UIGestureRecognizerStateEnded)) {
            self.pinchedIndexPath = nil;
        }
    }
}


-(void)updateForPinchScale:(CGFloat)scale
               atIndexPath:(NSIndexPath*)indexPath
{    
    if (indexPath && (indexPath.section != NSNotFound) && (indexPath.row != NSNotFound)) {
        
		CGFloat newHeight = round(MAX(self.initialPinchHeight * scale, DEFAULT_ROW_HEIGHT));
        
        if(newHeight < DEFAULT_ROW_HEIGHT *3){
		SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
        [sectionInfo replaceObjectInRowHeightsAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:newHeight]];
        // Alternatively, set uniformRowHeight = newHeight.
        
        /*
         Switch off animations during the row height resize,
         otherwise there is a lag before the user's action is seen.
         */
        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [UIView setAnimationsEnabled:animationsEnabled];
        }
    }
}

//セルの長押してコンテキスト位置にメニューを表示して個別の動作（メールやショートメッセージ）を起動する
// Menu(Mail|SMS)
//
#pragma mark Handling long presses
-(void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer
{    
    /*
     For the long press, the only state of interest is Began.
     When the long press is detected, find the index path of the row (if there is one) at press location.
     If there is a row at the location, create a suitable menu controller and display it.
     */
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pnt = [longPressRecognizer locationInView:self.tableView];
        NSIndexPath *pressedIndexPath = [self.tableView indexPathForRowAtPoint:pnt];
        
        
        
        // メニューを作成する前に夫々の機能が利用可能かを確認すべきじゃないの？
        if (pressedIndexPath && (pressedIndexPath.row != NSNotFound) && 
            (pressedIndexPath.section != NSNotFound)) {
            [self becomeFirstResponder];
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            //menuController.menuItems = [[NSArray alloc] init];
            //if( [MFMailComposeViewController canSendMail]){
                EmailMenuItem *menuItem1 = [[EmailMenuItem alloc] initWithTitle:@"Email" action:@selector(emailMenuButtonPressed:)];
                menuItem1.indexPath = pressedIndexPath;
            //    [menuController.menuItems indexOfObject:menuItem1];
            //}
            //if( [MFMessageComposeViewController canSendText]){
                EmailMenuItem *menuItem2 = [[EmailMenuItem alloc] initWithTitle:@"SMS" action:@selector(smsMenuButtonPressed:)];
                menuItem2.indexPath = pressedIndexPath;
            //    [menuController.menuItems indexOfObject:menuItem2];
            //}
            //if ([TWTweetComposeViewController canSendTweet]) {
                EmailMenuItem *menuItem3 = [[EmailMenuItem alloc] initWithTitle:@"Twitter" action:@selector(twitterMenuButtonPressed:)];
                menuItem3.indexPath = pressedIndexPath;
            //    [menuController.menuItems indexOfObject:menuItem3];
            //}
            menuController.menuItems = [NSArray arrayWithObjects:menuItem1, menuItem2, menuItem3, nil];
            [menuController setTargetRect:[self.tableView rectForRowAtIndexPath:pressedIndexPath] inView:self.tableView];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}


-(void)emailMenuButtonPressed:(UIMenuController*)menuController
{    
    EmailMenuItem *menuItem = [[[UIMenuController sharedMenuController] menuItems] objectAtIndex:0];
    if (menuItem.indexPath) {
        [self resignFirstResponder];
        [self sendEmailForEntryAtIndexPath:menuItem.indexPath];
    }
}
-(void)smsMenuButtonPressed:(UIMenuController*)menuController
{    
    EmailMenuItem *menuItem = [[[UIMenuController sharedMenuController] menuItems] objectAtIndex:0];
    if (menuItem.indexPath) {
        [self resignFirstResponder];
        [self sendSmsForEntryAtIndexPath:menuItem.indexPath];
    }
}
-(void)twitterMenuButtonPressed:(UIMenuController*)menuController
{    
    EmailMenuItem *menuItem = [[[UIMenuController sharedMenuController] menuItems] objectAtIndex:0];
    if (menuItem.indexPath) {
        [self resignFirstResponder];
        [self sendTwitterForEntryAtIndexPath:menuItem.indexPath];
    }
}

//
// Mail とSMS もdelegate の部分をblock で置き換えられそうだけど、どうなのか？
//
-(void)sendEmailForEntryAtIndexPath:(NSIndexPath*)indexPath
{    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:self.pinchedIndexPath.section];
    
    // In production, send the appropriate message.
    // 20120606 Mail>>
    if( [MFMailComposeViewController canSendMail]){
        MFMailComposeViewController* pickerCtl = [[MFMailComposeViewController alloc] init];
        pickerCtl.mailComposeDelegate = self;
        Verse *verse = [self verseInIndexPath:indexPath];
        NSString *msg=[NSString stringWithFormat:@"「%@」（%@）", verse.text, verse.author];
        [pickerCtl setMessageBody:msg  isHTML:NO];
        // NSData* data = UIImagePNGRepresentation(img);
        // [pickerCtl addAttachmentData:data mimeType:@"image/png" fileName:@"sample.png"];
        [self presentModalViewController:pickerCtl animated:YES];
        NSLog(@"Send email to %@", sectionInfo.title);
    }
    else {
        NSLog(@"Cannot send email to %@", sectionInfo.title);        
    }
    // 20120606 Mail<<
    
    return;
}

//
//
-(void)mailComposeController:(MFMailComposeViewController*)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError*)error
{    
    [self dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultFailed) {
        // In production, display an appropriate message to the user.
        NSLog(@"Mail send failed with error: %@", error);
    }
}

-(void)sendSmsForEntryAtIndexPath:(NSIndexPath*)indexPath
{    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:self.pinchedIndexPath.section];
    
    if( [MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController* pickerCtl = [[MFMessageComposeViewController alloc] init];
        pickerCtl.messageComposeDelegate = self;
        Verse *verse = [self verseInIndexPath:indexPath];
        NSString *msg=[NSString stringWithFormat:@"「%@」（%@）", verse.text, verse.author];
        pickerCtl.body=msg;
        // NSData* data = UIImagePNGRepresentation(img);
        // [pickerCtl addAttachmentData:data mimeType:@"image/png" fileName:@"sample.png"];
        [self presentModalViewController:pickerCtl animated:YES];
        // Verse *verse = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Send SMS to %@", sectionInfo.title);
    }
    else {
        NSLog(@"Cannot send SMS to %@", sectionInfo.title);        
    }
    // 20120606 SMS<<
    
    return;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"SMS canceled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"SMS send failed");
            break;
        case MessageComposeResultSent:
        default:
            NSLog(@"SMS send done");
            break;
    }
}

-(void)sendTwitterForEntryAtIndexPath:(NSIndexPath*)indexPath
{    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:self.pinchedIndexPath.section];
    
    if ([TWTweetComposeViewController canSendTweet]) {
        // Set up the built-in twitter composition view controller.
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        
        // Set the initial tweet text. See the framework for additional properties that can be set.
        //[tweetViewController addImage:[UIImage imageNamed:@"iOSDevTips.png"]];
        //[tweetViewController  addURL:[NSURL URLWithString:[NSString stringWithString:@"http:/MobileDeveloperTips.com/"]]];
        //[tweetViewController setInitialText:@"Tweet from iOS 5 app using the Twitter framework."];
        //[tweetViewController setInitialText:@"Hello. This is a tweet."];
        
        //Verse *verse = [self.fetchedResultsController objectAtIndexPath:indexPath];
        Verse *verse = [self verseInIndexPath:indexPath];
        [tweetViewController setInitialText:[NSString stringWithFormat:@"%@(%@)", verse.text,  verse.author ]];
        
        // Create the completion handler block.
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    // The cancel button was tapped.
                    output = @"Tweet cancelled.";
                    break;
                case TWTweetComposeViewControllerResultDone:
                    // The tweet was sent.
                    output = @"Tweet done.";
                    break;
                default:
                    break;
            }
             
            // Dismiss the tweet composition view controller.
            [self dismissModalViewControllerAnimated:YES];
        }];
        // Present the tweet composition view controller modally.
        [self presentModalViewController:tweetViewController animated:YES];
        NSLog(@"Send Twitter to %@", sectionInfo.title);
    }
    else {
        NSLog(@"Cannot send Twitter to %@", sectionInfo.title);        
    }
    
    return;
}


//
//
//

@end
