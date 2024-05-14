import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';

const kTileHeight = 50.0;

class rigStatusHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Rig Status History"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add padding around the OrderTrackerZen widget for better presentation.
            Card(
                elevation: 2,
                margin: EdgeInsets.all(20),
                // OrderTrackerZen is the main widget of the package which displays the order tracking information.
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: OrderTrackerZen(
                    animation_duration: 5,
                    isShrinked: false,
                    // Provide an array of TrackerData objects to display the order tracking information.
                    tracker_data: [
                      // TrackerData represents a single step in the order tracking process.
                      TrackerData(
                        title: "MAINTANACE",
                        date: "",
                        // Provide an array of TrackerDetails objects to display more details about this step.
                        tracker_details: [
                          // TrackerDetails contains detailed information about a specific event in the order tracking process.
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Maintanace",
                            datetime: "Sat, 8 Apr '22 - 17:17",
                          ),
                        ],
                      ),
                      // yet another TrackerData object
                      TrackerData(
                        title: "OPERATION",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Operation",
                            datetime: "Sat, 8 Apr '22 - 17:50",
                          ),
                        ],
                      ),
                      // And yet another TrackerData object
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "",
                        // Provide an array of TrackerDetails objects to display more details about this step.
                        tracker_details: [
                          // TrackerDetails contains detailed information about a specific event in the order tracking process.
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Maintanace",
                            datetime: "Sat, 8 Apr '22 - 17:17",
                          ),
                        ],
                      ),
                      // yet another TrackerData object
                      TrackerData(
                        title: "OPERATION",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Operation",
                            datetime: "Sat, 8 Apr '22 - 17:50",
                          ),
                        ],
                      ),
                      // And yet another TrackerData object
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "",
                        // Provide an array of TrackerDetails objects to display more details about this step.
                        tracker_details: [
                          // TrackerDetails contains detailed information about a specific event in the order tracking process.
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Maintanace",
                            datetime: "Sat, 8 Apr '22 - 17:17",
                          ),
                        ],
                      ),
                      // yet another TrackerData object
                      TrackerData(
                        title: "OPERATION",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Operation",
                            datetime: "Sat, 8 Apr '22 - 17:50",
                          ),
                        ],
                      ),
                      // And yet another TrackerData object
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
