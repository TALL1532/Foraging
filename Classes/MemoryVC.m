    //
//  MemoryVC.m
//  CountDownPuzzle
//
//  Created by Andrew Battles on 6/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MemoryVC.h"


@implementation MemoryVC

@synthesize delegate;												//---comm

-(IBAction)backPressed:(id)sender{
    [self puzzleQuit];
}
- (void)buttonPressed:(NSInteger)number {
	NSLog(@"Button %d Pressed",number);
	
	if(numFlips < 2) {
	//get the proper card button pressed
	lastCard = currentCard;
	currentCard = number;
	}
	
}

- (void)delayFunction {
	
	[self unflipCard:lastCard];
	[self unflipCard:currentCard];
	[self enableAllCards];
	
	BOOL match = [self compareMatch];
	if(match) {
		[self hideButton:currentCard];
		[self hideButton:lastCard];
	}
	
	if(matchCount == 10) {
	
		[self endGame];
	}
}

- (void)startGame:(int)startTime {
	
	//[self killTimer];
	[self startTimer:startTime];
	
	[self randomizeButtonLocation];
	
	[self showAllButtons];
	
	numFlips = 0;
	currentCard = 1;
	lastCard = 1;
	matchCount = 0;
}

- (void)restartGame {
	
	[self randomizeButtonLocation];
	
	[self showAllButtons];
	
	numFlips = 0;
	currentCard = 1;
	lastCard = 1;
	matchCount = 0;
	
}

- (void)endGame {
	
	UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Congratulations!" 
														delegate:self 
											   cancelButtonTitle:@"Play Again!" 
											   otherButtonTitles:nil]; 
	[doneAlert show]; 
	[doneAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	//NSLog(@"alertView called");
    if(alertView.tag == 22){//22 is called from the quit button
        if(buttonIndex == 0){
            [self actualPuzzleQuit];
        }
    }else [self restartGame];
	
}

- (void)setupButtons {
	buttonArray = [[NSMutableArray alloc] initWithObjects:card1Button, card2Button, card3Button, card4Button ,card5Button
				   ,card6Button ,card7Button ,card8Button ,card9Button ,card10Button 
				   ,card11Button ,card12Button ,card13Button ,card14Button ,card15Button
				   ,card16Button ,card17Button ,card18Button ,card19Button ,card20Button,nil];
	
	//[buttonArray retain];

	UIButton *button;
	
	int j;
	for(j=0;j<20;j++) {
		//get current button (for loop will complete these actions for all buttons)
		button = [buttonArray objectAtIndex:j];
		
		//make button look like a card
		[button setBackgroundImage:backOfCard forState:UIControlStateNormal];
		[button setTitle:@"" forState:UIControlStateNormal];
		
		//setup flip action
		[button addTarget:self action:@selector(flipCard) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:button];
	}
	//[button release];
}


- (void)flipCard { //flipCard is set up to be called directly from the button press		
	
	numFlips++;

	//flip the button over, simulates flipping a card over
	if(numFlips < 3) {
		UIButton *button = [buttonArray objectAtIndex:(currentCard-1)];
	
		//setup flip action for the card
		[UIView beginAnimations:nil context:nil]; 
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:button cache:YES];
		[UIView setAnimationDuration:0.20]; 
		[UIView setAnimationDelay:0.0]; 
		[UIView setAnimationDelegate:self];
	
		//show the proper image
		int set = ((currentCard-1)/2)+1;
		switch (set) {
			case 1:
				[button setBackgroundImage:frog forState:UIControlStateNormal];
				break;
			case 2:
				[button setBackgroundImage:tiger forState:UIControlStateNormal];
				break;
			case 3:
				[button setBackgroundImage:butterfly forState:UIControlStateNormal];
				break;
			case 4:
				[button setBackgroundImage:hamster forState:UIControlStateNormal];
				break;
			case 5:
				[button setBackgroundImage:deer forState:UIControlStateNormal];
				break;
			case 6:
				[button setBackgroundImage:fly forState:UIControlStateNormal];
				break;
			case 7:
				[button setBackgroundImage:cat forState:UIControlStateNormal];
				break;
			case 8:
				[button setBackgroundImage:snake forState:UIControlStateNormal];
				break;
			case 9:
				[button setBackgroundImage:dog forState:UIControlStateNormal];
				break;
			case 10:
				[button setBackgroundImage:bird forState:UIControlStateNormal];
				break;
			default:
				break;
		}
	
		//perform the flip animation
		[UIView commitAnimations];

		//disable the card
		[button setEnabled:NO];
	
		if(numFlips == 2) {

			[self disableAllCards];
		
			BOOL match = [self compareMatch];
	
			//put in a time delay before the card flips back over
			if(match) {
				[self performSelector:@selector(delayFunction) withObject:nil afterDelay:0.25];
				matchCount++;
			}
			else {
				[self performSelector:@selector(delayFunction) withObject:nil afterDelay:1.0];
			}
		}
	}
}

- (void)unflipCard:(int)cardNum {
	
	NSLog(@"card %d unflipped",cardNum);
	UIButton *button = [buttonArray objectAtIndex:(cardNum-1)];
	
	//setup flip action for the card
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:button cache:YES];
	[UIView setAnimationDuration:0.20]; 
	[UIView setAnimationDelay:0.0]; 
	[UIView setAnimationDelegate:self];
	
	//tell the card to look like the back again
	[button setBackgroundImage:backOfCard forState:UIControlStateNormal];
	
	//perform the flip animation
	[UIView commitAnimations];	
	numFlips = 0;
}

- (void)disableAllCards {
	int i;
	UIButton *button;
	for (i = 0; i<20; i++) {
		button = [buttonArray objectAtIndex:i];
		[button setEnabled:NO];
		button.alpha = 1.0;
	}
}
	
- (void)enableAllCards {
	int i;
	UIButton *button;
	for (i = 0; i<20; i++) {
		button = [buttonArray objectAtIndex:i];
		[button setEnabled:YES];
	}
}

- (void)showAllButtons {
	int i;
	UIButton *button;
	for (i = 0; i<20; i++) {
		button = [buttonArray objectAtIndex:i];
		[button setHidden:NO];
	}	
}

- (void)hideButton:(int)buttonNum {
	UIButton *button;
	button = [buttonArray objectAtIndex:(buttonNum-1)];
	[button setHidden:YES];
}

- (BOOL)compareMatch {
	
	int card1 = ((currentCard-1)/2);
	int card2 = ((lastCard-1)/2);
	
	if(card1 == card2) {
		NSLog(@"Match!");
		//[self hideButton:currentCard];
		//[self hideButton:lastCard];
		return YES;
	}
	else {
		return NO;
	}
}



- (void)randomizeButtonLocation {
	
	//first, create a randomized array of the button numbers	
	int buttonNums[20];
	
	int j;
	for(j=0;j<20;j++) {
			buttonNums[j] = (j+1);
	}

	int i;
	int arraySize = (sizeof buttonNums)/(sizeof buttonNums[0]); //get length of array by dividing (sizeof array) by size of one element
	//NSLog(@"size: %d",arraySize);
	
	int a;		
	int b;
	int rando;
	
	for (i = 0; i< arraySize; i++) {
		
		rando = (random()%arraySize);		//get a random position to move this number to
		a = buttonNums[i];		//store the current value in that position
		b = buttonNums[rando];
		
		
		buttonNums[i] = b;	//move the random number to the position of the current number
		buttonNums[rando] = a;		//move the old number into the position it was swapped with
		
	}

	
	// now that we have a randomized order, put the buttons in the locations corresponding to their randomized order
	int xPos;
	int yPos;
	int n;
	
	UIButton *button;
	CGRect buttonRect;
	
	for (i = 0; i< arraySize; i++) {
		
		n = buttonNums[i];	//this is the number of the button location we're moving to
		
		xPos = 103+(n-1)%4*187;
		yPos = 103+(n-1)/4*186;
		//xPos = 85+(n-1)%5*150;
		//yPos = 65+(n-1)/5*98;
		
		
		button = [buttonArray objectAtIndex:i];	//get button 'i'
		
		buttonRect = CGRectMake(xPos-83.5, 45 + yPos-83, 167, 166);
		button.frame = buttonRect;
	}
}


//////////  TIMER FUNCTIONS //////////////////////////////////////////////

- (void)startTimer:(int)time {
	// Kill timer, if already active
	
	//if([timerNoOne isValid]) {
	//	[timerNoOne invalidate]; 
	//	NSLog(@"timerNoOne isValid");
	//}
	
	timerNoOne = nil; // ensures we never invalidate an already invalid Timer 
	
	// Create timer
	timerNoOne = [NSTimer scheduledTimerWithTimeInterval:1
												  target:self 
												selector:@selector(updateTimerNoOne:) 
												userInfo:nil 
												 repeats:YES];	
	//set time
	timeLeft = time;	
	timerStarted = YES;
	[self updateTime:time];
	//[timerNoOne retain];
	
}

- (void)killTimer {
	[timerNoOne invalidate]; 
	timerNoOne = nil;
	timerStarted = NO;
	//[timerNoOne release];
}

- (void)updateTimerNoOne:(NSTimer *) timer {
	
	if(timeLeft > 0) {
		
		timeLeft--;
		[self updateTime:timeLeft];
	}
	
	else {

		[self killTimer];
		//[self.navigationController popViewControllerAnimated:YES];
		[[self delegate] endMemoryPuzzle];
		
	}
}

- (void)updateTime:(int)time {
	int minutes = time / 60;
	int seconds = time % 60;
	timerDisp.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
}

- (void)viewDidLoad {
	
	//setup images
	backOfCard = [UIImage imageNamed:@"cardBack.jpg"];
	frog = [UIImage imageNamed:@"frog.jpg"];
	tiger = [UIImage imageNamed:@"tiger.jpg"];
	butterfly = [UIImage imageNamed:@"butterfly.jpg"];
	deer = [UIImage imageNamed:@"deer.jpg"];
	hamster = [UIImage imageNamed:@"hamster.jpg"];
	fly = [UIImage imageNamed:@"fly.jpg"];
	cat = [UIImage imageNamed:@"cat.jpg"];
	snake = [UIImage imageNamed:@"snake.jpg"];
	dog = [UIImage imageNamed:@"dog.jpg"];
	bird = [UIImage imageNamed:@"bird.jpg"];
	
	//setup buttons and flip actions
	[self setupButtons];
	
	self.navigationItem.title = @"Match the cards!";
	
	self.navigationItem.hidesBackButton = YES;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(puzzleQuit)] autorelease];
	
	[LoggingSingleton logIt:@"----- Memory game visible"];
	
    [super viewDidLoad];
	
	//[self.navigationController popViewControllerAnimated:NO]; 
	//this quick push-pop makes sure the window is working on the first try
}

- (void)puzzleQuit {
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit?"
                                                    message:@"Your session will be reset"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"cancel",nil];
    alert.tag = 22;

    [alert show];
    [alert release];
}



-(void)actualPuzzleQuit{
    [self killTimer];
    [self dismissViewControllerAnimated:NO completion:nil];
	//[self.navigationController popViewControllerAnimated:NO];
    [[self delegate] puzzleQuit];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return ((interfaceOrientation != UIDeviceOrientationLandscapeLeft) &&
			(interfaceOrientation != UIDeviceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"MEMORY WARN MEMORYVC");
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	
	//[buttonArray release];
	
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"MemoryVC: Dealloc");
	
	[buttonArray release];
	
    [super dealloc];
}

- (IBAction)card1Pressed:(id)sender {
    [self buttonPressed:1];
}
- (IBAction)card2Pressed:(id)sender {
    [self buttonPressed:2];
}
- (IBAction)card3Pressed:(id)sender {
    [self buttonPressed:3];
}
- (IBAction)card4Pressed:(id)sender {
    [self buttonPressed:4];
}
- (IBAction)card5Pressed:(id)sender {
    [self buttonPressed:5];
}
- (IBAction)card6Pressed:(id)sender {
    [self buttonPressed:6];
}
- (IBAction)card7Pressed:(id)sender {
    [self buttonPressed:7];
}
- (IBAction)card8Pressed:(id)sender {
    [self buttonPressed:8];
}
- (IBAction)card9Pressed:(id)sender {
    [self buttonPressed:9];
}
- (IBAction)card10Pressed:(id)sender {
    [self buttonPressed:10];
}
- (IBAction)card11Pressed:(id)sender {
    [self buttonPressed:11];
}
- (IBAction)card12Pressed:(id)sender {
    [self buttonPressed:12];
}
- (IBAction)card13Pressed:(id)sender {
    [self buttonPressed:13];
}
- (IBAction)card14Pressed:(id)sender {
    [self buttonPressed:14];
}
- (IBAction)card15Pressed:(id)sender {
    [self buttonPressed:15];
}
- (IBAction)card16Pressed:(id)sender {
    [self buttonPressed:16];
}
- (IBAction)card17Pressed:(id)sender {
    [self buttonPressed:17];
}
- (IBAction)card18Pressed:(id)sender {
    [self buttonPressed:18];
}
- (IBAction)card19Pressed:(id)sender {
    [self buttonPressed:19];
}
- (IBAction)card20Pressed:(id)sender {
    [self buttonPressed:20];
}

@end
