
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class userguide_view extends StatefulWidget {
  const userguide_view({Key? key}) : super(key: key);

  @override
  _userguide_viewState createState() => _userguide_viewState();
}

class _userguide_viewState extends State<userguide_view> {
  String downloaded_path = "";
  var pdfController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(15),
              child: const Text("Preview"),
            ),
            SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child:
                      const PDF(
                        // swipeHorizontal: true,
                      ).cachedFromUrl(
                        "https://pdc-api.smart-check.id/api/master/download-user-guide",
                        // "${CONS_VARIABLE.DOMAIN}/SIGNED/final_stamp_${widget.file_path}",

                        maxAgeCacheObject:
                            const Duration(days: 30), //duration of cache
                        placeholder: (progress) => Center(
                            child: Text(
                          progress.toString(),
                          style : 
                               TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 30),
                        )),
                        errorWidget: (error) =>
                            Center(child: Text(error.toString())),
                        whenDone: (filePath) {
                          downloaded_path = filePath;
                        },
                      )
                  //     PdfView(
                  //   controller: pdfController,
                  // ),
                )),
            
            
          ],
        ),
      ),
    );
  }
}
