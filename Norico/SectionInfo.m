
/*
     File: SectionInfo.m
 Abstract: A section info object maintains information about a section:
 * Whether the section is open
 * The header view for the section
 * The model objects for the section -- in this case, the dictionary containing the quotations for a single play
 * The height of each row in the section
 
  Version: 2.0
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "SectionInfo.h"
#import "SectionHeaderView.h"
//#import "Play.h"
#import "Verse.h"

@implementation SectionInfo

@synthesize open;
@synthesize rowHeights;
@synthesize title;
@synthesize headerView;

- init {
	
	self = [super init];
	if (self) {
		rowHeights = [[NSMutableArray alloc] init];
	}
	return self;
}


- (NSUInteger)countOfRowHeights {
	return [rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
	return [rowHeights objectAtIndex:idx];
}

- (void)insertObject:(id)anObject
 inRowHeightsAtIndex:(NSUInteger)idx
{
	[rowHeights insertObject:anObject atIndex:idx];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray
               atIndexes:(NSIndexSet *)indexes
{
	[rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx
{
	[rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes
{
	[rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx
                              withObject:(id)anObject
{
	[rowHeights replaceObjectAtIndex:idx withObject:anObject];
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes
                    withRowHeights:(NSArray *)rowHeightArray 
{
	[rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

@end
