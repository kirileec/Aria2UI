//
//  ViewController.m
//  Aria2UI
//
//  Created by Kirile on 15/6/25.
//  Copyright (c) 2015年 Kirile. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController

-(void)viewDidAppear
{
	[super viewDidAppear];

	[self startAria2];

	self.webview = [[WebView alloc] initWithFrame:self.view.bounds];

	NSString *str1 = [[NSBundle mainBundle] pathForResource:@"index0" ofType:@"html"];

	NSURL *url = [NSURL fileURLWithPath:str1];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	[[self.webview mainFrame] loadRequest:request];

	[self.view addSubview:self.webview];
	//[_webview setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
	//[self.view setAutoresizingMask:NSViewMaxXMargin|NSViewMaxYMargin];

	[self regNotification];


}


-(void)regNotification
{

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(windowDidResized:)
												 name:NSWindowDidResizeNotification
											   object:self.view.window];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(windowWillClose:)
												 name:NSWindowWillCloseNotification
											   object:self.view.window];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:nil];

}



-(void)appWillTerminate:(NSNotification *)notification
{
	NSLog(@"Applicattion Terminate");
	[self closeAria2];
}

-(void)windowDidResized:(NSNotification *)notification
{
	NSLog(@"Window Did Resized!");
	[_webview setFrameSize:CGSizeMake([self.view.window frame].size.width , [self.view.window frame].size.height-22)];

}


-(void)windowWillClose:(NSNotification *)notification
{
	NSLog(@"Window Close");

	[self closeAria2];
	exit(0);

}

-(void)startAria2
{
	NSArray *arg =[NSArray arrayWithObjects:@"-D",nil];

	NSTask *task=[[NSTask alloc] init];
	[task setLaunchPath:@"/usr/local/bin/aria2c"];
	[task setArguments:arg];
	[task launch];

}

-(void)closeAria2
{
	NSArray *arg =[NSArray arrayWithObjects:@"aria2c",nil];

	NSTask *task=[[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/killall"];
	[task setArguments:arg];
	[task launch];
}

@end
