//
//  SentenceGridVC.h
//  SentenceForaging
//
//  Created by Andrew Battles on 5/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayAndRecordVC.h"
#import "MemoryVC.h"

@protocol ProcessDataDelegate2 <NSObject>	//---comm
- (void)logIt:(NSString *)stringToLog;		//---comm
- (NSString *)getTag;						//---comm
- (int)getDelayLow;							//---comm
- (int)getDelayHigh;						//---comm
- (int)getFontSize;							//---comm
- (int)getSetNum;							//---comm
- (int)getOrder;							//---comm
- (int)getInputMode;						//---comm
- (int)getTlogInputMode;					//---comm
- (int)getTotalWait;						//---comm

- (void)puzzleEnded;						//---comm
- (void)setSetNumber:(int)setNum:(int)CTfirst;	//---comm
@end										//---comm

@class DisplayAndRecordVC;

@interface SentenceGridVC : UIViewController {
	
	
    IBOutlet UIButton *button1;
	IBOutlet UIButton *button2;
	IBOutlet UIButton *button3;
	IBOutlet UIButton *button4;
	IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
    IBOutlet UIButton *button7;
    IBOutlet UIButton *button8;
    IBOutlet UIButton *button9;
	
    IBOutlet UIButton *button10;
    IBOutlet UIButton *button11;
    IBOutlet UIButton *button12;
    IBOutlet UIButton *button13;
    IBOutlet UIButton *button14;
    IBOutlet UIButton *button15;
    IBOutlet UIButton *button16;
    IBOutlet UIButton *button17;
    IBOutlet UIButton *button18;
    IBOutlet UIButton *button19;
    
    IBOutlet UIButton *button20;
    IBOutlet UIButton *button21;
    IBOutlet UIButton *button22;
    IBOutlet UIButton *button23;
    IBOutlet UIButton *button24;

    IBOutlet UIButton *createTlogButton;

    
	NSArray *sentencesArray;
	NSArray *sentencesDone;
	NSArray *buttonArray;
	int buttonsPressed;
	int sentenceSet;
	int CTfirstOrder;
	int cumulativeDelay;
	
	DisplayAndRecordVC *drvc;
	DisplayAndRecordVC *drvcTlog;
	MemoryVC *mvc;
	
	
	id <ProcessDataDelegate2> delegate;		//---comm
}

- (void)buttonPressed:(NSInteger)number;

- (void)loadSentencesIntoButtons:(int)setNum;

- (void)randomizeButtonLocation:(int)setNum;

- (int)getSentenceLength:(int)index;

- (void)setupSentences:(int)setNum;
- (void)setupButtons:(int)setNum;
- (void)hide21Buttons;
- (int)getMemoryPuzzleTime;

//delegate functions
- (void)logIt:(NSString *)stringToLog;
- (NSString *)getTag;
- (int)getDelayLow;
- (int)getDelayHigh;
- (int)getFontSize;
- (int)getInputMode;
- (int)getTlogInputMode;
- (int)getSetNum;
- (int)getOrder;
- (void)addWaitToCounter:(int)waitTime;

//memory puzzle functions
- (void)startMemoryPuzzle:(int)startTime;
- (void)endMemoryPuzzle;


- (void)showBackButton;
- (void)puzzleInterrupted;
- (void)puzzleQuit;
- (void)closePuzzle;
- (void)recordingEnded;
- (void)createTlogSpare;

//////////////////////////////////////
- (IBAction)button1Pressed:(id)sender;
- (IBAction)button2Pressed:(id)sender;
- (IBAction)button3Pressed:(id)sender;
- (IBAction)button4Pressed:(id)sender;
- (IBAction)button5Pressed:(id)sender;
- (IBAction)button6Pressed:(id)sender;
- (IBAction)button7Pressed:(id)sender;
- (IBAction)button8Pressed:(id)sender;
- (IBAction)button9Pressed:(id)sender;
- (IBAction)button10Pressed:(id)sender;
- (IBAction)button11Pressed:(id)sender;
- (IBAction)button12Pressed:(id)sender;
- (IBAction)button13Pressed:(id)sender;
- (IBAction)button14Pressed:(id)sender;
- (IBAction)button15Pressed:(id)sender;
- (IBAction)button16Pressed:(id)sender;
- (IBAction)button17Pressed:(id)sender;
- (IBAction)button18Pressed:(id)sender;
- (IBAction)button19Pressed:(id)sender;
- (IBAction)button20Pressed:(id)sender;
- (IBAction)button21Pressed:(id)sender;
- (IBAction)button22Pressed:(id)sender;
- (IBAction)button23Pressed:(id)sender;
- (IBAction)button24Pressed:(id)sender;


- (IBAction)createTlogPressed:(id)sender;

@property (retain) id delegate;				//---comm


@end
