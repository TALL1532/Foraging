//
//  StartMenuVC.h
//  SentenceForaging
//
//  Created by Andrew Battles on 5/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SentenceGridVC.h"
#import "SentenceViewController.h"



@class SentenceGridVC;

@interface StartMenuVC : UIViewController < ProcessDataDelegate1> {
    IBOutlet UIButton *startButton;
    IBOutlet UITextView *instructionView;
	
	int setNumber;
	int CTfirstOrder;
	
	SentenceViewController *sgvc;
	
	id <ProcessDataDelegate1> delegate;		//---comm
	
}
- (IBAction)startButtonPressed:(id)sender;



- (void)setSetNumber:(int)setNum; //sets up the set of sentences

- (void)puzzleInterrupted;
- (void)puzzleEnded;

//delegate functions
- (void)logIt:(NSString *)whatToLog;
- (NSString *)getTag;
- (int)getDelayLow;
- (int)getDelayHigh:(int)setNum;
- (int)getFontSize:(int)setNum;
- (int)getSetNum;
- (int)getOrder;
- (int)getInputMode;
- (int)getTlogInputMode;
- (int)getTotalWait;
- (int)getNextSet:(int)setNum;

@property (retain) id <ProcessDataDelegate1> delegate;				//---comm

@end
