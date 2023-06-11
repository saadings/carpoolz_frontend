import 'package:carpoolz_frontend/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RideReview extends StatefulWidget {
  static const routeName = '/ride-review';

  const RideReview({Key? key}) : super(key: key);

  @override
  _RideReviewState createState() => _RideReviewState();
}

class _RideReviewState extends State<RideReview> {
  int selectedRating = 0;

  void setRating(int rating) {
    setState(() {
      selectedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a Rating'),
      content: Container(
        height: 100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setRating(i);
                      // Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: i <= selectedRating ? Colors.amber : Colors.grey,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (r) => false);
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
