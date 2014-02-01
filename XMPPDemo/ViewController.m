//
//  ViewController.m
//  XMPPDemo
//
//  Created by casa on 14-2-1.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import "ViewController.h"
#import "UIView+HandyConstraints.h"
#import "CallCenter.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, CallCenterDelegate>

@property (nonatomic, strong) UITextView *userName;
@property (nonatomic, strong) UITextView *password;
@property (nonatomic, strong) UIButton *logButton;
@property (nonatomic, strong) UITextView *input;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *content;
@property (nonatomic, strong) CallCenter *callCenter;

@end

@implementation ViewController

#pragma mark - getters and setters
- (UITextView *)userName
{
    if (_userName == nil) {
        _userName = [[UITextView alloc] init];
        _userName.translatesAutoresizingMaskIntoConstraints = NO;
        _userName.text = @"username";
        _userName.backgroundColor = [UIColor lightGrayColor];
    }
    return _userName;
}

- (UITextView *)password
{
    if (_password == nil) {
        _password = [[UITextView alloc] init];
        _password.translatesAutoresizingMaskIntoConstraints = NO;
        _password.text = @"password";
        _password.backgroundColor = [UIColor lightGrayColor];
    }
    return _password;
}

- (UIButton *)logButton
{
    if (_logButton == nil) {
        _logButton = [[UIButton alloc] init];
        _logButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_logButton setTitle:@"login" forState:UIControlStateNormal];
        [_logButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_logButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_logButton addTarget:self action:@selector(logButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logButton;
}

- (UITextView *)input
{
    if (_input == nil) {
        _input = [[UITextView alloc] init];
        _input.translatesAutoresizingMaskIntoConstraints = NO;
        _input.text = @"input your message";
        _input.backgroundColor = [UIColor lightGrayColor];
    }
    return _input;
}

- (UIButton *)sendButton
{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton setTitle:@"send" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    return _sendButton;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)content
{
    if (_content == nil) {
        _content = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _content;
}

- (CallCenter *)callCenter
{
    if (_callCenter == nil) {
        _callCenter = [[CallCenter alloc] init];
        _callCenter.delegate = self;
    }
    return _callCenter;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.userName];
    [self.view addSubview:self.password];
    [self.view addSubview:self.logButton];
    [self.view addSubview:self.input];
    [self.view addSubview:self.sendButton];
    [self.view addSubview:self.tableView];
    
    [self configLayouts];
}

- (void)configLayouts
{
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_userName(44)]-3-[_input(44)]-3-[_tableView]-3-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_userName, _input, _tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_userName(125)]-5-[_password(125)]-5-[_logButton(50)]-5-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_userName, _password, _logButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_input(255)]-5-[_sendButton(50)]-5-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_input, _sendButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_tableView]-5-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraint:[self.password constraintBottomEqualToView:self.userName]];
    [self.view addConstraint:[self.logButton constraintBottomEqualToView:self.userName]];
    [self.view addConstraint:[self.sendButton constraintBottomEqualToView:self.input]];
    
    [self.view addConstraint:[self.password constraintHeightEqualToView:self.userName]];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
    
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"content"];
    }
    tableViewCell.textLabel.text = self.content[indexPath.row];
    
    return tableViewCell;
}

#pragma mark - CallCenterDelegate
- (void)receivedMessage:(NSString *)message
{
    [self.content addObject:message];
    [self.tableView reloadData];
}

#pragma mark - event response
- (void)logButtonClicked:(UIButton *)button
{
    NSLog(@"username is %@", self.userName.text);
    NSLog(@"password is %@", self.password.text);
    [self.callCenter login];
}

- (void)sendButtonClicked:(UIButton *)button
{
    [self.callCenter sendMessage:self.input.text];
}
@end
