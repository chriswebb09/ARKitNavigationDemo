# ARKitNavigationDemo
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Platform](http://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![Platform](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](hhttps://swift.org/blog/swift-4-0-released/)



* Work in progress.

**In Progress**

- [ ] **Region** — For one, we could render far fewer nodes. In fact, it’s a bit distracting that the entire trip is rendered. To fix this, we could render one leg of the journey at a time. Then we could use our location service to monitor for when we enter that region, or we could calculate the distance from the point of view to the last node in the leg triggering a mechanism to render a new leg and remove the old when they are in proximity. 

- [ ] **Dynamic Destination** — Another easy way we could improve it is we could allow the user to set their destination while they are navigating, instead having to go back to the map. 

- [ ] **Rese**t — As the project is as of this writing, the reset functionality hasn’t been completed. Sometimes ARKit gets confused, sometimes the GPS gets confused (more on the location problems in a bit.) So we can build a mechanism which resets the screen so we can start over. That way you don’t have to quit to reset the trip.

## ARKit Demo Application

When it loads to the map, tap a place on the map where you want to navigate to and press okay. The tap can be sluggish, so you might have to try once or twice before you get it. When the navigation screen loads, tap the screen, then give it a few seconds. You should see the nodes render. 




![Example gif](https://github.com/chriswebb09/ARKitNavigationDemo/blob/master/ARKitNavigationDemo/test4.gif)

## Demo project for:

[ARKit and CoreLocation: Part One](https://medium.com/journey-of-one-thousand-apps/arkit-and-corelocation-part-one-fc7cb2fa0150)


[ARKit and CoreLocation: Part Two](https://medium.com/journey-of-one-thousand-apps/arkit-and-corelocation-part-two-7b045fb1d7a1)


[ARKit and CoreLocation: Part Three](https://medium.com/journey-of-one-thousand-apps/arkit-and-corelocation-part-three-98b1d51e2eac)


# Related Projects: 

[ARKit Airport - Navigation In Augmented Reality: Part One](https://medium.com/@chris.webb5249/arkit-airport-navigation-in-augmented-reality-part-one-c99d2ad326c0)

[ARKitAirport](https://github.com/chriswebb09/ARKitAirport)

[ARNavigation](https://github.com/chriswebb09/ARNavigation)

[ARKit Drone](https://github.com/chriswebb09/ARKitDrone)

[ARKitSpitfire](https://github.com/chriswebb09/ARKitSpitfire)
