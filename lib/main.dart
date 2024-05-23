import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Review> reviews = [];

  List<String> reviewers = [];
  List<String> restaurants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
        backgroundColor: Color(0xFFB26069),
      ),
      backgroundColor: Color(0xFFDDBBBE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://marketplace.canva.com/EAFzZd9frfk/1/0/1600w/canva-colorful-illustrative-restaurant-master-chef-logo-4rQv_oY-CF8.jpg',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ReviewCard(
                  review: reviews[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewDetailScreen(review: reviews[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRestaurantPage()),
              );
              if (result != null) {
                setState(() {
                  restaurants.add(result);
                });
              }
            },
            label: Text('Add Restaurant'),
            icon: Icon(Icons.restaurant),
            backgroundColor: Color(0xFFB26069),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReviewerPage()),
              );
              if (result != null) {
                setState(() {
                  reviewers.add(result);
                });
              }
            },
            label: Text('Add Reviewer'),
            icon: Icon(Icons.person_add),
            backgroundColor: Color(0xFFB26069),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReviewPage(
                  reviewers: reviewers,
                  restaurants: restaurants,
                )),
              );
              if (result != null) {
                setState(() {
                  reviews.add(result);
                });
              }
            },
            label: Text('Add Review'),
            icon: Icon(Icons.rate_review),
            backgroundColor: Color(0xFFB26069),
          ),
        ],
      ),
    );
  }
}

class Review {
  final String reviewer;
  final String restaurant;
  final String review;
  final int rating;

  Review({
    required this.reviewer,
    required this.restaurant,
    required this.review,
    required this.rating,
  });
}

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onTap;

  ReviewCard({required this.review, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${review.restaurant} - ${review.reviewer}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  StarRating(rating: review.rating),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                review.review,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;

  StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
            (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 20.0,
        ),
      ),
    );
  }
}

class AddReviewPage extends StatefulWidget {
  final List<String> reviewers;
  final List<String> restaurants;

  AddReviewPage({required this.reviewers, required this.restaurants});

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  String? selectedRestaurant;
  String? selectedReviewer;
  int selectedRating = 1;
  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
        backgroundColor: Color(0xFFB26069),
      ),
      backgroundColor: Color(0xFFDDBBBE),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedRestaurant,
              onChanged: (value) {
                setState(() {
                  selectedRestaurant = value;
                });
              },
              items: widget.restaurants
                  .map((restaurant) => DropdownMenuItem<String>(
                value: restaurant,
                child: Text(restaurant),
              ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Select Restaurant'),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedReviewer,
              onChanged: (value) {
                setState(() {
                  selectedReviewer = value;
                });
              },
              items: widget.reviewers
                  .map((reviewer) => DropdownMenuItem<String>(
                value: reviewer,
                child: Text(reviewer),
              ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Select Reviewer'),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedRating,
              onChanged: (value) {
                setState(() {
                  selectedRating = value!;
                });
              },
              items: List.generate(5, (index) => index + 1)
                  .map((rating) => DropdownMenuItem<int>(
                value: rating,
                child: Text(rating.toString()),
              ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Select Rating'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(labelText: 'Write your review'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB26069),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Review newReview = Review(
                      reviewer: selectedReviewer!,
                      restaurant: selectedRestaurant!,
                      review: reviewController.text,
                      rating: selectedRating,
                    );
                    Navigator.pop(context, newReview);
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB26069),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddReviewerPage extends StatefulWidget {
  @override
  _AddReviewerPageState createState() => _AddReviewerPageState();
}

class _AddReviewerPageState extends State<AddReviewerPage> {
  final TextEditingController reviewerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reviewer'),
        backgroundColor: Color(0xFFB26069),
      ),
      backgroundColor: Color(0xFFDDBBBE),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: reviewerController,
              decoration: InputDecoration(hintText: 'Enter Reviewer Name'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB26069),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String reviewerName = reviewerController.text;
                    Navigator.pop(context, reviewerName);
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB26069),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddRestaurantPage extends StatefulWidget {
  @override
  _AddRestaurantPageState createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final TextEditingController restaurantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Restaurant'),
        backgroundColor: Color(0xFFB26069),
      ),
      backgroundColor: Color(0xFFDDBBBE),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: restaurantController,
              decoration: InputDecoration(hintText: 'Enter Restaurant Name'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB26069),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String restaurantName = restaurantController.text;
                    Navigator.pop(context, restaurantName);
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB26069),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewDetailScreen extends StatelessWidget {
  final Review review;

  ReviewDetailScreen({required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Details'),
        backgroundColor: Color(0xFFB26069),
      ),
      backgroundColor: Color(0xFFDDBBBE),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rating: ${review.rating}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  review.rating,
                      (index) => Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 40.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Review Details:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                review.review,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB26069),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
