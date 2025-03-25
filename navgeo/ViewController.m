//
//  ViewController.m
//  navgeo
//
//  Created by Zifeng(Allen) An on 3/24/25.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  self.view.backgroundColor = [UIColor whiteColor];

  UILabel *label = [[UILabel alloc] init];
  label.text = @"Geonavigation Test 🥳";
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:label];

  // Parameter Type Selection (directions or place)
  self.parameterTypeControl =
      [[UISegmentedControl alloc] initWithItems:@[ @"directions", @"place" ]];
  self.parameterTypeControl.selectedSegmentIndex = 0;
  [self.parameterTypeControl addTarget:self
                                action:@selector(segmentChanged:)
                      forControlEvents:UIControlEventValueChanged];
  self.parameterTypeControl.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.parameterTypeControl];

  // Create Directions View
  self.directionsView = [[UIView alloc] init];
  //  self.directionsView.backgroundColor = [UIColor redColor];
  self.directionsView.translatesAutoresizingMaskIntoConstraints = NO;

  // Create Place View
  self.placeView = [[UIView alloc] init];
  self.placeView.backgroundColor = [UIColor blueColor];
  self.placeView.translatesAutoresizingMaskIntoConstraints = NO;

  // Add Both to Main View
  [self.view addSubview:self.directionsView];
  [self.view addSubview:self.placeView];

  // Initially Show Only Directions View
  self.placeView.hidden = YES;
  self.directionsView.hidden = NO;

  // Source Field
  self.sourceField = [[UITextField alloc] init];
  self.sourceField.placeholder = @"Enter Source Address";
  self.sourceField.borderStyle = UITextBorderStyleRoundedRect;
  self.sourceField.translatesAutoresizingMaskIntoConstraints = NO;
  self.sourceField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.sourceField addTarget:self
                       action:@selector(textFieldEditingChanged)
             forControlEvents:UIControlEventEditingChanged];
  [self.directionsView addSubview:self.sourceField];

  // Destination Field
  self.destinationField = [[UITextField alloc] init];
  self.destinationField.placeholder = @"Enter Destination Address";
  self.destinationField.borderStyle = UITextBorderStyleRoundedRect;
  self.destinationField.translatesAutoresizingMaskIntoConstraints = NO;
  self.destinationField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.destinationField addTarget:self
                            action:@selector(textFieldEditingChanged)
                  forControlEvents:UIControlEventEditingChanged];
  [self.directionsView addSubview:self.destinationField];

  // Initialize the array
  self.waypointTextFields = [NSMutableArray array];

  // Create and set up the "+" button
  self.addWaypointButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.addWaypointButton setTitle:@"+ Waypoint" forState:UIControlStateNormal];
  [self.addWaypointButton addTarget:self
                             action:@selector(addWaypointTextFieldHandler)
                   forControlEvents:UIControlEventTouchUpInside];
  self.addWaypointButton.translatesAutoresizingMaskIntoConstraints = NO;

  // Add the button to the view
  [self.directionsView addSubview:self.addWaypointButton];

  self.stackWaypointView = [[UIStackView alloc] init];
  self.stackWaypointView.axis = UILayoutConstraintAxisVertical;
  self.stackWaypointView.alignment = UIStackViewAlignmentFill;
  self.stackWaypointView.distribution = UIStackViewDistributionFill;
  self.stackWaypointView.spacing = 8.0;
  self.stackWaypointView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.directionsView addSubview:self.stackWaypointView];

  UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [label.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:20],
    [label.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor],

    [self.parameterTypeControl.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:20],
    [self.parameterTypeControl.centerXAnchor constraintEqualToAnchor:label.centerXAnchor],
    [self.parameterTypeControl.widthAnchor constraintEqualToConstant:250],

    [self.directionsView.topAnchor constraintEqualToAnchor:self.parameterTypeControl.bottomAnchor
                                                  constant:20],
    [self.directionsView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
    [self.directionsView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor
                                                       constant:-20],
    [self.directionsView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-20],

    [self.sourceField.topAnchor constraintEqualToAnchor:self.directionsView.topAnchor constant:20],
    [self.sourceField.heightAnchor constraintEqualToConstant:40],
    [self.sourceField.leadingAnchor constraintEqualToAnchor:self.directionsView.leadingAnchor
                                                   constant:20],
    [self.sourceField.trailingAnchor constraintEqualToAnchor:self.directionsView.trailingAnchor
                                                    constant:-20],
    [self.sourceField.centerXAnchor
        constraintEqualToAnchor:self.parameterTypeControl.centerXAnchor],

    [self.destinationField.topAnchor constraintEqualToAnchor:self.sourceField.bottomAnchor
                                                    constant:15],
    [self.destinationField.heightAnchor constraintEqualToConstant:40],
    [self.destinationField.leadingAnchor constraintEqualToAnchor:self.sourceField.leadingAnchor],
    [self.destinationField.trailingAnchor constraintEqualToAnchor:self.sourceField.trailingAnchor],
    [self.destinationField.centerXAnchor
        constraintEqualToAnchor:self.parameterTypeControl.centerXAnchor],

    [self.addWaypointButton.topAnchor constraintEqualToAnchor:self.destinationField.bottomAnchor
                                                     constant:20],
    [self.addWaypointButton.heightAnchor constraintEqualToConstant:40],
    [self.addWaypointButton.widthAnchor constraintEqualToConstant:100],
    [self.addWaypointButton.leadingAnchor
        constraintEqualToAnchor:self.destinationField.leadingAnchor],

    [self.stackWaypointView.topAnchor constraintEqualToAnchor:self.addWaypointButton.bottomAnchor
                                                     constant:20],
    [self.stackWaypointView.leadingAnchor
        constraintEqualToAnchor:self.directionsView.leadingAnchor],
    [self.stackWaypointView.trailingAnchor
        constraintEqualToAnchor:self.directionsView.trailingAnchor],

    [self.placeView.topAnchor constraintEqualToAnchor:self.directionsView.topAnchor],
    [self.placeView.leadingAnchor constraintEqualToAnchor:self.directionsView.leadingAnchor],
    [self.placeView.trailingAnchor constraintEqualToAnchor:self.directionsView.trailingAnchor],
    [self.placeView.bottomAnchor constraintEqualToAnchor:self.directionsView.bottomAnchor],

  ]];
}

- (void)segmentChanged:(UISegmentedControl *)sender {
  if (sender.selectedSegmentIndex == 0) {
    self.directionsView.hidden = NO;
    self.placeView.hidden = YES;
  } else {
    self.directionsView.hidden = YES;
    self.placeView.hidden = NO;
  }
}

- (void)textFieldEditingChanged {
  NSString *srcEncoded = [self.sourceField.text stringByReplacingOccurrencesOfString:@" "
                                                                          withString:@"+"];
  NSString *dstEncoded = [self.destinationField.text stringByReplacingOccurrencesOfString:@" "
                                                                               withString:@"+"];
  NSMutableArray<NSString *> *waypointsEncoded = [NSMutableArray array];

  for (UITextField *textField in self.waypointTextFields) {
    if (textField.text.length > 0) {
      [waypointsEncoded addObject:[textField.text stringByReplacingOccurrencesOfString:@" "
                                                                     withString:@"+"]];
    }
  }

  NSString *src = @"";
  NSString *dst = @"";
  NSString *url = @"";
  if ([srcEncoded length] > 0) {
    src = [NSString stringWithFormat:@"source=%@", srcEncoded];
  }
  if ([dstEncoded length] > 0) {
    dst = [NSString stringWithFormat:@"destination=%@", dstEncoded];
  }

  if ([srcEncoded length] > 0 && [dstEncoded length] > 0) {
    url = [NSString stringWithFormat:@"geo-navigation:///directions?%@&%@", src, dst];
  } else {
    url = [NSString stringWithFormat:@"geo-navigation:///directions?%@%@", src, dst];
  }
  NSLog(@"URL is: %@", url);
}

- (void)addWaypointTextFieldHandler {

  UITextField *newTextField = [[UITextField alloc] init];
  newTextField.placeholder = [NSString
      stringWithFormat:@"Enter Waypoint %lu", (unsigned long)self.waypointTextFields.count + 1];
  newTextField.borderStyle = UITextBorderStyleRoundedRect;
  newTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [newTextField addTarget:self
                   action:@selector(textFieldEditingChanged)
         forControlEvents:UIControlEventEditingChanged];
  [self.stackWaypointView addArrangedSubview:newTextField];

  [self.waypointTextFields addObject:newTextField];
}

@end
