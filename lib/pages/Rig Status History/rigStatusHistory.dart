import 'package:flutter/material.dart';
// import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:timeline_tile/timeline_tile.dart';

class rigStatusHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Rig Status History"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              _buildTimelineTile(
                context,
                title: 'Office Inauguration Function',
                subtitle: 'Started journey with new office',
                date: 'Oct 01, 2020',
                images: [
                  'https://via.placeholder.com/150',
                  'https://via.placeholder.com/150',
                  'https://via.placeholder.com/150',
                ],
              ),
              _buildTimelineTile(
                context,
                title: 'Maintanance',
                subtitle: 'Perubahan Status Menjadi Maintanace',
                date: 'Sept 12, 2020',
              ),
              _buildTimelineTile(
                context,
                title: 'Reached New Record',
                subtitle:
                    'Lifetime accreditation from IAO (First Business Advisory Firm in India)',
                date: 'Sept 16, 2020',
              ),
              _buildTimelineTile(
                context,
                title: 'New People Joined with our Journey',
                subtitle: 'John Smith, Designer',
                date: 'Aug 20, 2020',
                imageUrl: 'https://via.placeholder.com/150',
              ),
              _buildTimelineTile(
                context,
                title: 'Office Inauguration Function',
                subtitle: 'Started journey with new office',
                date: 'Oct 01, 2020',
                images: [
                  'https://via.placeholder.com/150',
                  'https://via.placeholder.com/150',
                  'https://via.placeholder.com/150',
                ],
              ),
              _buildTimelineTile(
                context,
                title: 'Design Meetup',
                subtitle:
                    'This is where it all goes down. You will compete head to head with your friends and rivals. Get ready!',
                date: 'Sept 12, 2020',
              ),
              _buildTimelineTile(
                context,
                title: 'Reached New Record',
                subtitle:
                    'Lifetime accreditation from IAO (First Business Advisory Firm in India)',
                date: 'Sept 16, 2020',
              ),
              _buildTimelineTile(
                context,
                title: 'New People Joined with our Journey',
                subtitle: 'John Smith, Designer',
                date: 'Aug 20, 2020',
                imageUrl: 'https://via.placeholder.com/150',
              ),
            ],
          ),
        ));
  }
}

Widget _buildTimelineTile(BuildContext context,
    {required String title,
    required String subtitle,
    required String date,
    List<String>? images,
    String? imageUrl}) {
  return TimelineTile(
    alignment: TimelineAlign.manual,
    lineXY: 0.3,
    isFirst: false,
    isLast: false,
    indicatorStyle: IndicatorStyle(
      width: 20,
      color: Colors.blue,
      indicatorXY: 0.5,
    ),
    beforeLineStyle: LineStyle(
      color: Colors.blue,
      thickness: 3,
    ),
    afterLineStyle: LineStyle(
      color: Colors.blue,
      thickness: 3,
    ),
    startChild: Container(
      constraints: BoxConstraints(
        minHeight: 120,
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
    endChild: Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          minHeight: 120,
        ),
        child: Card(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Text(subtitle),
                if (images != null)
                  Row(
                    children: images
                        .map((url) => Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Image.network(
                                url,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ))
                        .toList(),
                  ),
                if (imageUrl != null)
                  Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(onPressed: () {}, child: Text("Edit")),
                )
              ],
            ),
          ),
        )),
  );
}
