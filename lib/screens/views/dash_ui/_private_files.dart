import 'dart:async';
import 'dart:html';
import 'package:blur/blur.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmbrew/data/_delete_private_file_database.dart';
import 'package:pharmbrew/domain/_web_file_picker.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/_delete_private_file.dart';
import '../../../data/_fetch_private_files_database_info.dart';
import '../../../data/_get_private_file.dart';
import '../../../data/_upload_private_files_info_database.dart';
import '../../../widgets/_custom_success2.dart';

class PrivateFiles extends StatefulWidget {
  const PrivateFiles({super.key});

  @override
  State<PrivateFiles> createState() => _PrivateFilesState();
}

class _PrivateFilesState extends State<PrivateFiles> {
  int selectedIndex = 0;
  int length = 5;
  bool isUploading = false;
  late String userId = '';

  late double size;

  dynamic databaseInfo = [];

  void fetchDatabaseInfo() async {
    Future.delayed(const Duration(milliseconds: 300), () async {
      var data = await FetchPrivateFilesDatabase.fetch(userId);
      setState(() {
        databaseInfo = data;
      });
    });
  }

  int hoveringIndex = -1;

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('loggedInUserId') ??
          ''; // Assign x to pp, if x is null assign an empty string
    });
  }

  bool isNull = true;

  dynamic privateFiles;

  void fetchPrivateFiles() async {
    var data = await FetchPrivateFiles.getPrivateFile(userId);
    setState(() {
      privateFiles = data['files'];
      isNull = data['files'] == null;
    });
  }

  late Timer timer, timer2, timer3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();

    timer2 = Timer.periodic(const Duration(seconds: 400), (timer) {
      isNull = false;
    });

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchPrivateFiles();
    });

    timer3 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchDatabaseInfo();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isEmpty = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timer2.cancel();
    timer3.cancel();
  }

  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Private Files',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: double.parse(calculateTotalLimit()) > 40
                                ? Colors.red.shade300
                                : Colors.green.shade300,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Limit: ${calculateTotalLimit()}/50MB',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 400,
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectedIndex == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Existing Files',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedIndex == 0
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectedIndex == 1
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Upload Files',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedIndex == 1
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  selectedIndex == 0
                      ? Expanded(
                          child: Column(
                          children: [
                            Container(
                              color: Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  Container(width: 50),
                                  const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'File Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                  const Expanded(
                                      child: Center(
                                    child: Text(
                                      'Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                                  const Expanded(
                                      child: Center(
                                    child: Text(
                                      'Size',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                                  const Expanded(
                                      child: Center(
                                    child: Text(
                                      'Type',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                                  const Expanded(
                                      child: Center(
                                    child: Text(
                                      'Action',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            isNull
                                ? const Expanded(
                                    child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          CupertinoColors.activeGreen),
                                    ),
                                  ))
                                : privateFiles.length == 0
                                    ? Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey.shade500),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Center(
                                            child: Text(
                                              'No files found',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                            itemCount: privateFiles.length,
                                            itemBuilder: (context, index) {
                                              return MouseRegion(
                                                onEnter: (event) {
                                                  setState(() {
                                                    hoveringIndex = index;
                                                  });

                                                  // showCustomSuccessDialog2("Hovered~!", context);
                                                },
                                                onExit: (event) {
                                                  setState(() {
                                                    hoveringIndex = -1;
                                                  });
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        _downloadFile(
                                                            privateFiles[index][
                                                                'download_link']);
                                                      },
                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        curve: Curves.easeInOut,
                                                        color: hoveringIndex ==
                                                                index
                                                            ? Colors
                                                                .grey.shade400
                                                            : Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 20,
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 50,
                                                              child: Icon(
                                                                getFileType(privateFiles[index]['file_name'])
                                                                            .toLowerCase() ==
                                                                        'zip'
                                                                    ? Icons
                                                                        .folder_zip
                                                                    : getFileType(privateFiles[index]['file_name']).toLowerCase() ==
                                                                            'mp4'
                                                                        ? Icons
                                                                            .video_file
                                                                        : getFileType(privateFiles[index]['file_name']).toLowerCase() == 'png' ||
                                                                                getFileType(privateFiles[index]['file_name']).toLowerCase() == 'jpg' ||
                                                                                getFileType(privateFiles[index]['file_name']).toLowerCase() == 'jpeg'
                                                                            ? Icons.image
                                                                            : getFileType(privateFiles[index]['file_name']) == 'pdf'
                                                                                ? Icons.picture_as_pdf
                                                                                : Icons.file_copy,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  privateFiles[
                                                                          index]
                                                                      [
                                                                      'file_name'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                )),
                                                            Expanded(
                                                                child: Center(
                                                              child: Text(
                                                                getDate(privateFiles[
                                                                        index][
                                                                    'file_name']),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            )),
                                                            Expanded(
                                                                child: Center(
                                                              child: Text(
                                                                "${getSize(privateFiles[index]['file_name'])} MB",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            )),
                                                            Expanded(
                                                                child: Center(
                                                              child: Text(
                                                                getFileType(
                                                                    privateFiles[
                                                                            index]
                                                                        [
                                                                        'file_name']),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            )),
                                                            Expanded(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            title:
                                                                                const Text('Delete Confirmation'),
                                                                            content:
                                                                                const Text('Are you sure you want to delete this file?'),
                                                                            actions: <Widget>[
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  await DeletePrivateFilesDatabase.delete(userId, privateFiles[index]['file_name']);
                                                                                  await DeletePrivateFiles.delete(userId, privateFiles[index]['file_name']);
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.white,
                                                                                  foregroundColor: Colors.red,
                                                                                ),
                                                                                child: const Text('Delete'),
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.white,
                                                                                  foregroundColor: Colors.black,
                                                                                ),
                                                                                child: const Text('Cancel'),
                                                                              ),
                                                                            ],
                                                                          ).frosted(
                                                                              blur: 20,
                                                                              borderRadius: BorderRadius.circular(10));
                                                                        },
                                                                      );
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red,
                                                                    )),
                                                              ],
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      color:
                                                          Colors.grey.shade300,
                                                    )
                                                  ],
                                                ),
                                              );
                                            }))
                          ],
                        ))
                      : Expanded(
                          child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    !isUploading
                                        ? const Icon(
                                            Icons.cloud_upload,
                                            size: 80,
                                            color: Colors.grey,
                                          )
                                        : const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                CupertinoColors.activeGreen),
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _file == null
                                          ? 'Upload your private file here'
                                          : _file!.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _file == null
                                    ? const SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Size: ${size.toStringAsFixed(2)} MB',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                _file == null
                                    ? const SizedBox.shrink()
                                    : const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _file == null
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              // _pickFiles();
                                              // print("file name: $_fileName");
                                              // print("file path: $_filePath");

                                              WebFilePicker().pickFile(
                                                onFilePicked: (file) {
                                                  setState(() {
                                                    _file = file;
                                                    size = _file!.size /
                                                        1024 /
                                                        1024;
                                                  });
                                                },
                                              );

                                              // showCustomSuccessDialog2(
                                              //     'Selected ${_file!.name}',
                                              //     context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.shade500,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: Text('Browse Files'),
                                          )
                                        : Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isUploading = true;
                                                  });

                                                  double currentSize =
                                                      double.parse(size
                                                          .toStringAsFixed(2));
                                                  double existing = double.parse(
                                                      calculateTotalLimit());

                                                  if (currentSize + existing >
                                                      50) {
                                                    showCustomErrorDialog(
                                                        "File size exceeds limit!",
                                                        context);
                                                    setState(() {
                                                      isUploading = false;
                                                    });
                                                    return;
                                                  } else {
                                                    await _uploadFile(userId,
                                                        _file!, context);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      CupertinoColors
                                                          .activeGreen,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: Text('Upload'),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    _file = null;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: Text('Cancel'),
                                              ),
                                            ],
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),
    );
  }

  // String? _fileName;
  // String? _filePath;
  // List<PlatformFile>? _files;
  // String formattedSize = "";
  // void _pickFiles() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //   );

  //   if (result != null) {
  //     setState(() {
  //       _files = result.files;
  //       _fileName = _files!
  //           .map((e) => e.name)
  //           .join(', '); // Join file names into a single string

  //       // Calculating total size of selected files
  //       int totalSize = 0;
  //       for (PlatformFile file in _files!) {
  //         totalSize += file.bytes!.length;
  //       }
  //       print("Total file size: $totalSize bytes");

  //       // You can also convert bytes to KB or MB if needed
  //       formattedSize = (totalSize / 1024 / 1024).toStringAsFixed(2);
  //     });
  //     print("Selected file name(s): $_fileName");
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  Future<void> insert(
      String id, String fileName, String date, String fileSize) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://bcrypt.site/scripts/php/upload_private_file_database.php'),
          body: {
            'fileName': fileName,
            'uploadDate': date,
            'fileType': fileName.split('.').last,
            'fileSize': fileSize,
            'user': id,
          });

      if (response.statusCode == 200) {
        setState(() {
          isUploading = false;
        });
        showCustomSuccessDialog2("File Uploaded!", context);

        setState(() {
          _file = null;
        });
      } else {
        throw Exception('Failed to insert : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to insert: $e');
    }
  }

  Future<void> _uploadFile(String id, File file, BuildContext context) async {
    var uri = Uri.parse(
        'https://bcrypt.site/scripts/php/upload_private_file.php'); // Replace with your API URL

    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id;

    // Read the file using FileReader
    var completer = Completer<List<int>>();
    var reader = FileReader();

    reader.onLoad.listen((event) {
      completer.complete(reader.result as List<int>);
    });

    reader.onError.listen((event) {
      completer.completeError('Failed to read file');
    });

    reader.readAsArrayBuffer(file);

    var fileBytes = await completer.future;

    // Add the file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: file.name,
      contentType: MediaType(
          'application', 'octet-stream'), // Adjust content type if needed
    ));

    // Send the request
    var streamedResponse = await request.send();

    // Check the response status
    if (streamedResponse.statusCode == 200) {
      // Assuming insert() is a function you have defined elsewhere
      insert(
          id,
          file.name,
          DateTime.now().toString().split('.')[0],
          size.toStringAsFixed(
              2)); // Ensure 'formattedSize' is defined appropriately
      print('Uploaded successfully');
    } else {
      print('Failed to upload: ${streamedResponse.reasonPhrase}');
    }
  }

  void _downloadFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getFileType(String path) {
    List<String> pathParts = path.split('.');
    return pathParts.last;
  }

  String calculateTotalLimit() {
    double total = 0;

    for (var item in databaseInfo) {
      total += item['fileSize']; // No need to parse again
    }

    return total.toStringAsFixed(2);
  }

  String getSize(String fileName) {
    for (var item in databaseInfo) {
      if (item['fileName'] == fileName) {
        return item['fileSize'].toString();
      }
    }
    return '';
  }

  String getDate(String fileName) {
    for (var item in databaseInfo) {
      if (item['fileName'] == fileName) {
        return item['uploadDate'].toString();
      }
    }
    return '';
  }

  // XFile? _file;
  File? _file;
}
