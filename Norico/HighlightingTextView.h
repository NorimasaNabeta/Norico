
/*
     File: HighlightingTextView.h
 Abstract: A text view that provides support for highlighting by changing the text color.
 
  Version: 2.0
 
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

@interface HighlightingTextView : UITextView {
}

@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;

@end


