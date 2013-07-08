//
//  MemoryVC.h
//  CountDownPuzzle
//
//  Created by Andrew Battles on 6/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoggingSingleton.h"
@protocol ProcessDataDelegate6 <NSObject>	//---comm
- (void)logIt:(NSString *)stringToLog;		//---comm
- (void)endMemoryPuzzle;
@end

@interface MemoryVC : UIViewController {

	IBOutlet UIButton *card1Button;
    IBOutlet UIButton *card2Button;
    IBOutlet UIButton *card3Button;
    IBOutlet UIButton *card4Button;
    IBOutlet UIButton *card5Button;
    IBOutlet UIButton *card6Button;
    IBOutlet UIButton *card7Button;
    IBOutlet UIButton *card8Button;
    IBOutlet UIButton *card9Button;	
    IBOutlet UIButton *card10Button;
	
    IBOutlet UIButton *card11Button;
    IBOutlet UIButton *card12Button;
    IBOutlet UIButton *card13Button;
    IBOutlet UIButton *card14Button;
    IBOutlet UIButton *card15Button;
    IBOutlet UIButton *card16Button;
    IBOutlet UIButton *card17Button;
    IBOutlet UIButton *card18Button;
    IBOutlet UIButton *card19Button;
    IBOutlet UIButton *card20Button;
	
	IBOutlet UILabel *timerDisp;
	
	NSTimer *timerNoOne;
	NSInteger timeLeft;
	BOOL timerStarted;
	
	int numFlips;
	int currentCard;
	int lastCard;
	int matchCount;
	
	UIImage *backOfCard;
	UIImage *frog;
	UIImage *tiger;
	UIImage *butterfly;
	UIImage *hamster;
	UIImage *deer;
	UIImage *fly;
	UIImage *cat;
	UIImage *snake;
	UIImage *dog;
	UIImage *bird;
	
	NSMutableArray *buttonArray;
	//UIView *buttonContainerView;
	
	id <ProcessDataDelegate6> delegate;		//---comm

}
- (IBAction)card1Pressed:(id)sender;
- (IBAction)card2Pressed:(id)sender;
- (IBAction)card3Pressed:(id)sender;
- (IBAction)card4Pressed:(id)sender;
- (IBAction)card5Pressed:(id)sender;
- (IBAction)card6Pressed:(id)sender;
- (IBAction)card7Pressed:(id)sender;
- (IBAction)card8Pressed:(id)sender;
- (IBAction)card9Pressed:(id)sender;
- (IBAction)card10Pressed:(id)sender;

- (IBAction)card11Pressed:(id)sender;
- (IBAction)card12Pressed:(id)sender;
- (IBAction)card13Pressed:(id)sender;
- (IBAction)card14Pressed:(id)sender;
- (IBAction)card15Pressed:(id)sender;
- (IBAction)card16Pressed:(id)sender;
- (IBAction)card17Pressed:(id)sender;
- (IBAction)card18Pressed:(id)sender;
- (IBAction)card19Pressed:(id)sender;
- (IBAction)card20Pressed:(id)sender;

-(IBAction)backPressed:(id)sender;
/////////////////////////////////////

- (void)buttonPressed:(NSInteger)number;
- (void)flipCard;
- (void)delayFunction;
- (void)unflipCard:(int)cardNum;
- (void)disableAllCards;
- (void)enableAllCards;

- (void)showAllButtons;
- (void)hideButton:(int)buttonNum;
- (BOOL)compareMatch;

- (void)setupButtons;
- (void)randomizeButtonLocation;
- (void)startGame:(int)startTime;
- (void)restartGame;
- (void)endGame;

- (void)updateTime:(int)time;
- (void)startTimer:(int)time;
- (void)killTimer;



@property (retain) id delegate;				//---comm

@end
