
/*
     File: QuoteCell.m
 Abstract: Table view cell to display information about a news item.
 The cell is configured in QuoteCell.xib.
 
  Version: 2.0
 
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "QuoteCell.h"
#import "Verse.h"
#import "Verse+BookTitle.h"
#import "HighlightingTextView.h"

@implementation QuoteCell

@synthesize characterLabel;
@synthesize quotationTextView;
@synthesize actAndSceneLabel;
@synthesize verse;


- (void)setVerse:(Verse *)newVerse {
    if (verse != newVerse) {
        verse = newVerse;
        // actAndSceneLabel.text = verse.book;
        // (新古今集 683 冬歌)
        actAndSceneLabel.text = [NSString stringWithFormat:@"(%@番 %@)",verse.vid, verse.titleVerseBookTitle];
        characterLabel.text = verse.author;
        quotationTextView.text = verse.text;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end

