//
//  ViewController.m
//  Aria2UI
//
//  Created by Kirile on 15/6/25.
//  Copyright (c) 2015年 Kirile. All rights reserved.
//

#import "ViewController.h"
#import "WebPreferencesPrivate.h"


@implementation ViewController

-(void)viewDidAppear
{
	[super viewDidAppear];

	[self startAria2];

	self.webview = [[WebView alloc] initWithFrame:self.view.bounds];

	NSString *str1 = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];

	NSURL *url = [NSURL fileURLWithPath:str1];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	[[_webview mainFrame] loadRequest:request];

	[self.view addSubview:_webview];


	[self regNotification];

	[self enableLocalStorageDatabase:_webview];

}

// 引入 WebPreferencesPrivate.h 以支持Webkit的 LocalStorage 用于保存配置
-(void)enableLocalStorageDatabase:(WebView *)wv
{
	WebPreferences *prefs =[_webview preferences];
	[prefs _setLocalStorageDatabasePath:@"~/Library/Application Support/Aria2UI"];
	[prefs setLocalStorageEnabled:YES];
}
// 注册窗口消息
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
// 反注册窗口消息
-(void)deRegNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowDidResizeNotification
												  object:self.view.window];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillCloseNotification
												  object:self.view.window];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSApplicationWillTerminateNotification
												  object:nil];
}


-(void)appWillTerminate:(NSNotification *)notification
{
	//NSLog(@"Applicattion Terminate");
	[self closeAria2];
	[self deRegNotification];
}

-(void)windowDidResized:(NSNotification *)notification
{
	//NSLog(@"Window Did Resized!");
	[_webview setFrameSize:CGSizeMake([self.view.window frame].size.width , [self.view.window frame].size.height-22)];

}


-(void)windowWillClose:(NSNotification *)notification
{
	//NSLog(@"Window Close");

	[self closeAria2];
	[self deRegNotification];
	exit(0);

}
// TO DO ：
// 处理aria2c位于不同目录时的情况
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
