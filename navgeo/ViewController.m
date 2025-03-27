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
  self.url = @"";

  UILabel *label = [[UILabel alloc] init];
  label.text = @"Geonavigation Test 🥳";
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:label];

  // Parameter Type Selection (directions or place)
  self.directionsPlaceControl =
      [[UISegmentedControl alloc] initWithItems:@[ @"directions", @"place" ]];
  self.directionsPlaceControl.selectedSegmentIndex = 0;
  [self.directionsPlaceControl addTarget:self
                                  action:@selector(directionsPlaceSegmentHandler:)
                        forControlEvents:UIControlEventValueChanged];
  self.directionsPlaceControl.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.directionsPlaceControl];

  // Create Directions View
  self.directionsView = [[UIView alloc] init];
  self.directionsView.translatesAutoresizingMaskIntoConstraints = NO;

  // Create Place View
  self.placeView = [[UIView alloc] init];
  //  self.placeView.backgroundColor = [UIColor blueColor];
  self.placeView.translatesAutoresizingMaskIntoConstraints = NO;

  // Add Both to Main View
  [self.view addSubview:self.directionsView];
  [self.view addSubview:self.placeView];

  // Initially Show Only Directions View
  self.directionsView.hidden = NO;
  self.placeView.hidden = YES;

  self.addressCoordinateControl =
      [[UISegmentedControl alloc] initWithItems:@[ @"address", @"coordinate" ]];
  self.addressCoordinateControl.selectedSegmentIndex = 0;
  [self.addressCoordinateControl addTarget:self
                                    action:@selector(addressCoordinateSegmentHandler:)
                          forControlEvents:UIControlEventValueChanged];
  self.addressCoordinateControl.translatesAutoresizingMaskIntoConstraints = NO;
  [self.placeView addSubview:self.addressCoordinateControl];

  // Create Addressions View
  self.addressionsView = [[UIView alloc] init];
  self.addressionsView.translatesAutoresizingMaskIntoConstraints = NO;

  // Create Coordinate View
  self.coordinateView = [[UIView alloc] init];
  self.coordinateView.translatesAutoresizingMaskIntoConstraints = NO;

  // Add Both to Main View
  [self.placeView addSubview:self.addressionsView];
  [self.placeView addSubview:self.coordinateView];

  self.addressionsView.hidden = NO;
  self.coordinateView.hidden = YES;

  // Address Field
  self.addressField = [[UITextField alloc] init];
  self.addressField.placeholder = @"Enter Address";
  self.addressField.borderStyle = UITextBorderStyleRoundedRect;
  self.addressField.translatesAutoresizingMaskIntoConstraints = NO;
  self.addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.addressField addTarget:self
                        action:@selector(addressTextFieldEditingHandler)
              forControlEvents:UIControlEventEditingChanged];
  [self.addressionsView addSubview:self.addressField];

  self.goAddressButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.goAddressButton setTitle:@"GO" forState:UIControlStateNormal];
  [self.goAddressButton addTarget:self
                           action:@selector(redirectionHandler)
                 forControlEvents:UIControlEventTouchUpInside];
  self.goAddressButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.addressionsView addSubview:self.goAddressButton];

  // X Coordinate Field
  self.xcoordinateField = [[UITextField alloc] init];
  self.xcoordinateField.placeholder = @"Enter X Coordinate";
  self.xcoordinateField.borderStyle = UITextBorderStyleRoundedRect;
  self.xcoordinateField.translatesAutoresizingMaskIntoConstraints = NO;
  self.xcoordinateField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.xcoordinateField addTarget:self
                            action:@selector(coordinateTextFieldEditingHandler)
                  forControlEvents:UIControlEventEditingChanged];
  [self.coordinateView addSubview:self.xcoordinateField];

  // Y Coordinate Field
  self.ycoordinateField = [[UITextField alloc] init];
  self.ycoordinateField.placeholder = @"Enter Y Coordinate";
  self.ycoordinateField.borderStyle = UITextBorderStyleRoundedRect;
  self.ycoordinateField.translatesAutoresizingMaskIntoConstraints = NO;
  self.ycoordinateField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.ycoordinateField addTarget:self
                            action:@selector(coordinateTextFieldEditingHandler)
                  forControlEvents:UIControlEventEditingChanged];
  [self.coordinateView addSubview:self.ycoordinateField];

  self.goCoordinateButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.goCoordinateButton setTitle:@"GO" forState:UIControlStateNormal];
  [self.goCoordinateButton addTarget:self
                              action:@selector(redirectionHandler)
                    forControlEvents:UIControlEventTouchUpInside];
  self.goCoordinateButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.coordinateView addSubview:self.goCoordinateButton];

  // Source Field
  self.sourceField = [[UITextField alloc] init];
  self.sourceField.placeholder = @"Enter Source Address";
  self.sourceField.borderStyle = UITextBorderStyleRoundedRect;
  self.sourceField.translatesAutoresizingMaskIntoConstraints = NO;
  self.sourceField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.sourceField addTarget:self
                       action:@selector(directionsTextFieldEditingHandler)
             forControlEvents:UIControlEventEditingChanged];
  [self.directionsView addSubview:self.sourceField];

  // Destination Field
  self.destinationField = [[UITextField alloc] init];
  self.destinationField.placeholder = @"Enter Destination Address";
  self.destinationField.borderStyle = UITextBorderStyleRoundedRect;
  self.destinationField.translatesAutoresizingMaskIntoConstraints = NO;
  self.destinationField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.destinationField addTarget:self
                            action:@selector(directionsTextFieldEditingHandler)
                  forControlEvents:UIControlEventEditingChanged];
  [self.directionsView addSubview:self.destinationField];

  // Initialize the array
  self.waypointTextFields = [NSMutableArray array];

  self.buttonView = [[UIStackView alloc] init];
  self.buttonView.axis = UILayoutConstraintAxisHorizontal;
  self.buttonView.alignment = UIStackViewAlignmentCenter;
  self.buttonView.distribution = UIStackViewDistributionFillEqually;
  self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.directionsView addSubview:self.buttonView];

  self.addWaypointButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.addWaypointButton setTitle:@"+ Waypoint" forState:UIControlStateNormal];
  [self.addWaypointButton addTarget:self
                             action:@selector(addWaypointTextFieldHandler)
                   forControlEvents:UIControlEventTouchUpInside];
  self.addWaypointButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.buttonView addArrangedSubview:self.addWaypointButton];

  self.removeWaypointButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.removeWaypointButton setTitle:@"- Waypoint" forState:UIControlStateNormal];
  [self.removeWaypointButton addTarget:self
                                action:@selector(removeWaypointTextFieldHandler)
                      forControlEvents:UIControlEventTouchUpInside];
  self.removeWaypointButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.buttonView addArrangedSubview:self.removeWaypointButton];

  self.goDirectionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.goDirectionsButton setTitle:@"GO" forState:UIControlStateNormal];
  [self.goDirectionsButton addTarget:self
                              action:@selector(redirectionHandler)
                    forControlEvents:UIControlEventTouchUpInside];
  self.goDirectionsButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.buttonView addArrangedSubview:self.goDirectionsButton];

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

    [self.directionsPlaceControl.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:20],
    [self.directionsPlaceControl.centerXAnchor constraintEqualToAnchor:label.centerXAnchor],
    [self.directionsPlaceControl.widthAnchor constraintEqualToConstant:250],

    [self.directionsView.topAnchor constraintEqualToAnchor:self.directionsPlaceControl.bottomAnchor
                                                  constant:20],
    [self.directionsView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
    [self.directionsView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor
                                                       constant:-20],
    [self.directionsView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-20],

    [self.addressCoordinateControl.topAnchor
        constraintEqualToAnchor:self.directionsPlaceControl.bottomAnchor
                       constant:20],
    [self.addressCoordinateControl.centerXAnchor
        constraintEqualToAnchor:self.directionsPlaceControl.centerXAnchor],
    [self.addressCoordinateControl.widthAnchor constraintEqualToConstant:250],

    [self.addressField.topAnchor constraintEqualToAnchor:self.addressCoordinateControl.bottomAnchor
                                                constant:20],
    [self.addressField.heightAnchor constraintEqualToConstant:40],
    [self.addressField.leadingAnchor constraintEqualToAnchor:self.placeView.leadingAnchor
                                                    constant:20],
    [self.addressField.trailingAnchor constraintEqualToAnchor:self.placeView.trailingAnchor
                                                     constant:-20],
    [self.addressField.centerXAnchor constraintEqualToAnchor:self.placeView.centerXAnchor],

    [self.goAddressButton.topAnchor constraintEqualToAnchor:self.addressField.bottomAnchor
                                                   constant:20],
    [self.goAddressButton.centerXAnchor
        constraintEqualToAnchor:self.addressCoordinateControl.centerXAnchor],

    [self.xcoordinateField.topAnchor
        constraintEqualToAnchor:self.addressCoordinateControl.bottomAnchor
                       constant:20],
    [self.xcoordinateField.heightAnchor constraintEqualToConstant:40],
    [self.xcoordinateField.leadingAnchor constraintEqualToAnchor:self.placeView.leadingAnchor
                                                        constant:20],
    [self.xcoordinateField.trailingAnchor constraintEqualToAnchor:self.placeView.trailingAnchor
                                                         constant:-20],
    [self.xcoordinateField.centerXAnchor constraintEqualToAnchor:self.placeView.centerXAnchor],

    [self.ycoordinateField.topAnchor constraintEqualToAnchor:self.xcoordinateField.bottomAnchor
                                                    constant:20],
    [self.ycoordinateField.heightAnchor constraintEqualToConstant:40],
    [self.ycoordinateField.leadingAnchor constraintEqualToAnchor:self.placeView.leadingAnchor
                                                        constant:20],
    [self.ycoordinateField.trailingAnchor constraintEqualToAnchor:self.placeView.trailingAnchor
                                                         constant:-20],
    [self.ycoordinateField.centerXAnchor constraintEqualToAnchor:self.placeView.centerXAnchor],

    [self.goCoordinateButton.topAnchor constraintEqualToAnchor:self.ycoordinateField.bottomAnchor
                                                   constant:20],
    [self.goCoordinateButton.centerXAnchor
        constraintEqualToAnchor:self.addressCoordinateControl.centerXAnchor],


    [self.sourceField.topAnchor constraintEqualToAnchor:self.directionsView.topAnchor constant:20],
    [self.sourceField.heightAnchor constraintEqualToConstant:40],
    [self.sourceField.leadingAnchor constraintEqualToAnchor:self.directionsView.leadingAnchor
                                                   constant:20],
    [self.sourceField.trailingAnchor constraintEqualToAnchor:self.directionsView.trailingAnchor
                                                    constant:-20],
    [self.sourceField.centerXAnchor
        constraintEqualToAnchor:self.directionsPlaceControl.centerXAnchor],

    [self.destinationField.topAnchor constraintEqualToAnchor:self.sourceField.bottomAnchor
                                                    constant:15],
    [self.destinationField.heightAnchor constraintEqualToConstant:40],
    [self.destinationField.leadingAnchor constraintEqualToAnchor:self.sourceField.leadingAnchor],
    [self.destinationField.trailingAnchor constraintEqualToAnchor:self.sourceField.trailingAnchor],
    [self.destinationField.centerXAnchor
        constraintEqualToAnchor:self.directionsPlaceControl.centerXAnchor],

    [self.buttonView.topAnchor constraintEqualToAnchor:self.destinationField.bottomAnchor
                                              constant:20],
    [self.buttonView.leadingAnchor constraintEqualToAnchor:self.destinationField.leadingAnchor],
    [self.buttonView.trailingAnchor constraintEqualToAnchor:self.destinationField.trailingAnchor],
    [self.buttonView.heightAnchor constraintEqualToConstant:40],

    [self.stackWaypointView.topAnchor constraintEqualToAnchor:self.buttonView.bottomAnchor
                                                     constant:20],
    [self.stackWaypointView.leadingAnchor
        constraintEqualToAnchor:self.directionsView.leadingAnchor],
    [self.stackWaypointView.trailingAnchor
        constraintEqualToAnchor:self.directionsView.trailingAnchor],

    [self.placeView.topAnchor constraintEqualToAnchor:self.directionsView.topAnchor],
    [self.placeView.leadingAnchor constraintEqualToAnchor:self.directionsView.leadingAnchor],
    [self.placeView.trailingAnchor constraintEqualToAnchor:self.directionsView.trailingAnchor],
    [self.placeView.bottomAnchor constraintEqualToAnchor:self.directionsView.bottomAnchor],

    [self.addressionsView.topAnchor
        constraintEqualToAnchor:self.addressCoordinateControl.bottomAnchor],
    [self.addressionsView.leadingAnchor constraintEqualToAnchor:self.directionsView.leadingAnchor],
    [self.addressionsView.trailingAnchor
        constraintEqualToAnchor:self.directionsView.trailingAnchor],
    [self.addressionsView.bottomAnchor constraintEqualToAnchor:self.placeView.bottomAnchor],

    [self.coordinateView.topAnchor
        constraintEqualToAnchor:self.addressCoordinateControl.bottomAnchor],
    [self.coordinateView.leadingAnchor constraintEqualToAnchor:self.directionsView.leadingAnchor],
    [self.coordinateView.trailingAnchor constraintEqualToAnchor:self.directionsView.trailingAnchor],
    [self.coordinateView.bottomAnchor constraintEqualToAnchor:self.placeView.bottomAnchor],

  ]];
}

- (void)directionsPlaceSegmentHandler:(UISegmentedControl *)sender {
  if (sender.selectedSegmentIndex == 0) {
    self.directionsView.hidden = NO;
    self.placeView.hidden = YES;
  } else {
    self.directionsView.hidden = YES;
    self.placeView.hidden = NO;
  }
}

- (void)addressCoordinateSegmentHandler:(UISegmentedControl *)sender {
  if (sender.selectedSegmentIndex == 0) {
    self.addressionsView.hidden = NO;
    self.coordinateView.hidden = YES;
  } else {
    self.addressionsView.hidden = YES;
    self.coordinateView.hidden = NO;
  }
}

- (void)addressTextFieldEditingHandler {
  NSString *addrEncoded = [self.addressField.text stringByReplacingOccurrencesOfString:@" "
                                                                            withString:@"+"];
  self.url = [NSString stringWithFormat:@"geo-navigation:///place?address=%@", addrEncoded];
  NSLog(@"URL is: %@", self.url);
}

- (void)coordinateTextFieldEditingHandler {
  NSString *xcoordinate = self.xcoordinateField.text;
  NSString *ycoordinate = self.ycoordinateField.text;
  self.url = [NSString
      stringWithFormat:@"geo-navigation:///place?coordinate=%@,%@", xcoordinate, ycoordinate];
  NSLog(@"URL is: %@", self.url);
}

- (void)directionsTextFieldEditingHandler {
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

  NSMutableArray<NSString *> *waypoints = [NSMutableArray array];
  for (NSString *waypoint in waypointsEncoded) {
    NSString *query = [NSString stringWithFormat:@"waypoint=%@", waypoint];
    [waypoints addObject:query];
  }

  NSString *wps = [waypoints componentsJoinedByString:@"&"];

  NSString *src = @"";
  NSString *dst = @"";
  self.url = @"";
  if ([srcEncoded length] > 0) {
    src = [NSString stringWithFormat:@"source=%@", srcEncoded];
  }
  if ([dstEncoded length] > 0) {
    dst = [NSString stringWithFormat:@"destination=%@", dstEncoded];
  }

  NSString *query = [@[ src, dst, wps ] componentsJoinedByString:@"&"];
  self.url = [NSString stringWithFormat:@"geo-navigation:///directions?%@", query];

  NSLog(@"URL is: %@", self.url);
}

- (void)addWaypointTextFieldHandler {

  UITextField *newTextField = [[UITextField alloc] init];
  newTextField.placeholder = [NSString
      stringWithFormat:@"Enter Waypoint %lu", (unsigned long)self.waypointTextFields.count + 1];
  newTextField.borderStyle = UITextBorderStyleRoundedRect;
  newTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [newTextField addTarget:self
                   action:@selector(directionsTextFieldEditingHandler)
         forControlEvents:UIControlEventEditingChanged];
  [self.stackWaypointView addArrangedSubview:newTextField];

  [self.waypointTextFields addObject:newTextField];
}

- (void)removeWaypointTextFieldHandler {
  if (self.waypointTextFields.count > 0) {
    [self.waypointTextFields removeLastObject];

    UITextField *lastWaypointTextField = [self.stackWaypointView.arrangedSubviews lastObject];
    [self.stackWaypointView removeArrangedSubview:lastWaypointTextField];
    [lastWaypointTextField removeFromSuperview];

    NSLog(@"Removed the last waypoint field from the array. Array count is now: %lu",
          (unsigned long)self.waypointTextFields.count);

  } else {
    NSLog(@"Waypoint array is already empty. Cannot remove last object.");
  }
}

- (void)redirectionHandler {
  NSURL *deepLinkURL = [NSURL URLWithString:self.url];
  if (deepLinkURL) {
    [[UIApplication sharedApplication] openURL:deepLinkURL options:@{} completionHandler:nil];
  }
}
@end
