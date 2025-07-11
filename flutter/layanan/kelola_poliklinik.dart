import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List _listData = [];
  List<dynamic> _listData = [];
  bool _isLoading = false;
  String _searchQuery = '';

  Future<void> _getData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.5/layanan/read.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<dynamic> get _filteredData {
    return _listData.where((data) {
      final nama_poli = data['nama_poli'].toString().toLowerCase();
      return nama_poli.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  String splitPoliName(String poliName) {
  List<String> words = poliName.split(' ');

  if (words.length > 2) {
    // Jika lebih dari 3 kata, gabungkan dua baris pertama
    return words.sublist(0, 2).join(' ') + '\n' + words.sublist(2).join(' ');
  } else {
    // Jika 3 kata atau kurang, kembalikan string asli
    return poliName;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "INFORMASI LAYANAN KESEHATAN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.5,
          ),
        ),
        backgroundColor: Color(0xFF06628A),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {
            // Perform an action when the back arrow is pressed
          },
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari Poliklinik...',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Color(0xFF06628A),
                  ),
                ),
              ),
            ),
          ),
          // Grid view of cards
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredData.isEmpty
                    ? Center(
                        child: Text('Data tidak ditemukan.'),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        ),
                        itemCount: _filteredData.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(20.0),
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                color: Color(0xFF06628A),
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          splitPoliName(_filteredData[index]['nama_poli']),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // ListTile(
                                //   title: Text(
                                //     _filteredData[index]['nama_poli'],
                                //     textAlign: TextAlign.center,
                                //   ),
                                  // subtitle: Text(
                                  //   _filteredData[index]['alamat'],
                                  //   textAlign: TextAlign.center,
                                  // ),
                                // ),
                                SizedBox(
                                    height:
                                        57.0), // Add spacing between ListTile and button
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailDataPage(
                                          ListData: {
                                            "id_poli": _filteredData[index]['id_poli'],
                                            "nama_poli": _filteredData[index]['nama_poli'],
                                            "detail": _filteredData[index]['detail'],
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(
                                        0xFF06628A), // Set the button color to blue
                                  ),
                                  child: Text(
                                    'Detail',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF06628A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahDataPage(),
            ),
          );
        },
      ),
    );
  }
}

class DetailDataPage extends StatefulWidget {
  final Map ListData;
  const DetailDataPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<DetailDataPage> createState() => _DetailDataPageState();
}

class _DetailDataPageState extends State<DetailDataPage> {
  List _listData = [];
  // bool _isLoading = true;
  int Index = 0;

  Future _getData() async {
    try {
      final respone =
          await http.get(Uri.parse('http://192.168.1.5/layanan/read.php'));
      if (respone.statusCode == 200) {
        final data = jsonDecode(respone.body);
        setState(() {
          _listData = data;
          // _isLoading = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

Future<bool> _hapus(String id) async {
  try {
    final response = await http.post(Uri.parse('http://192.168.1.5/layanan/delete.php'), body: {
      "id_poli": id,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Sesuaikan dengan struktur yang sebenarnya
      // Misalnya, jika ada properti 'status' di objek JSON, Anda dapat mengambil nilai tersebut
      final status = data['status'];
      
      if (status == 'sukses') {
        // Jika operasi berhasil
        setState(() {
          // Anda dapat melakukan apa yang diperlukan untuk memperbarui UI atau state lainnya
          // _listData = data['data']; // Gantilah ini sesuai dengan properti yang Anda perlukan
        });
        return true;
      } else {
        return false;
      }
    }
  } catch (e) {
    print(e);
  }
  return false;
}

  @override
  void initState() {
    _getData();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController id_poli = TextEditingController();
  TextEditingController nama_poli = TextEditingController();
  TextEditingController detail = TextEditingController();
  Future _update() async {
    final respone = await http
        .post(Uri.parse('http://192.168.1.5/layanan/edit.php'), body: {
      "id_poli": id_poli.text,
      "nama_poli": nama_poli.text,
      "detail": detail.text,
    });
    if (respone.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    id_poli.text = widget.ListData['id_poli'];
    nama_poli.text = widget.ListData['nama_poli'];
    detail.text = widget.ListData['detail'];

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "${widget.ListData['nama_poli'].toUpperCase()}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0, // Set a default font size
                  ),
                ),
              ),
            );
          },
        ),       
        backgroundColor: Color(0xFF06628A),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "edit") {
                Index = _listData
                    .indexWhere((item) => item['id_poli'] == id_poli.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDataPage(
                      ListData: {
                        "id_poli": _listData[Index]['id_poli'],
                        "nama_poli": _listData[Index]['nama_poli'],
                        "detail": _listData[Index]['detail'],
                      },
                    ),
                  ),
                );
              } else if (value == "hapus") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      elevation: 4.0, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      content: Text(
                        'Apakah Anda yakin ingin menghapus data ini?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text('Yakin', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                _hapus(widget.ListData['id_poli']).then((value) {
                                  if (value) {
                                    final snackBar = SnackBar(
                                      content: const Text('Data Gagal Di Hapus!'),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                      content: const Text('Data Berhasil Di Hapus!'),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePage()),
                                    (route) => false,
                                  );
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF097DAE)),
                              ),
                            ),
                            SizedBox(width: 80),
                            TextButton(
                              child: Text('Batal', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFA281B)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }
            },

            icon: Icon(
              Icons.more_vert,
              color: Colors.white, // Set the color to white
            ),

            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: "edit",
                child: Text("Edit"),
              ),
              PopupMenuItem<String>(
                value: "hapus",
                child: Text("Hapus"),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(30.0),
            //   child: Image.asset(
            //     'assets/foto_rs/poli_akupuntur_1.jpg',
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              nama_poli.text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                detail.text,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


class EditDataPage extends StatefulWidget {
  final Map ListData;

  const EditDataPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController id_poli = TextEditingController();
  TextEditingController nama_poli = TextEditingController();
  TextEditingController detail = TextEditingController();

  Future _update() async {
    final response = await http.post(Uri.parse('http://192.168.1.5/layanan/edit.php'), body: {
      "id_poli": id_poli.text,
      "nama_poli": nama_poli.text,
      "detail": detail.text,
    });
    
    if (response.statusCode == 200) {
      return true;
    }
    
    return false;
  }

  @override
  void initState() {
    super.initState();
    id_poli.text = widget.ListData['id_poli'];
    nama_poli.text = widget.ListData['nama_poli'];
    detail.text = widget.ListData['detail'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "UBAH ${widget.ListData['nama_poli'].toUpperCase()}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0, // Set a default font size
                  ),
                ),
              ),
            );
          },
        ),
        backgroundColor: Color(0xFF06628A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.0),
              Card(
                elevation: 8.0,
                color: const Color(0xFFE4FDFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Color(0XFF097DAE), width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Ubah Poliklinik',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: id_poli,
                          decoration: const InputDecoration(
                            labelText: 'ID Poliklinik :',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          key: const Key('nama_poli'),
                          controller: nama_poli,
                          decoration: const InputDecoration(
                            labelText: 'Nama Poliklinik :',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: detail,
                          decoration: const InputDecoration(
                            labelText: 'Detail:',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Batal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F267A),
                                  )),
                            ),
                            TextButton(
                              onPressed: () {
                                // Kode untuk menyimpan data
                                if (formKey.currentState!.validate()) {
                                _update().then((value) {
                                  if (value) {
                                    final snackBar = SnackBar(
                                      content: const Text('Data Berhasil Di Ubah!'),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                      content: const Text('Data Gagal Di Ubah!'),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                  (route) => false,
                                );
                              }
                              },
                              child: Text('Simpan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F267A),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TambahDataPage extends StatefulWidget {
  const TambahDataPage({Key? key}) : super(key: key);

  @override
  State<TambahDataPage> createState() => _TambahDatPageState();
}

class _TambahDatPageState extends State<TambahDataPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController id_poli = TextEditingController();
  TextEditingController nama_poli = TextEditingController();
  TextEditingController detail = TextEditingController();

  Future _simpan() async {
    final response = await http.post(Uri.parse('http://192.168.1.5/layanan/create.php'), body: {
      "id_poli": id_poli.text,
      "nama_poli": nama_poli.text,
      "detail": detail.text,
    });
    
    if (response.statusCode == 200) {
      return true;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TAMBAH POLIKLINIK",
          style: TextStyle(
            color: Colors.white, // Set title color to white
          ),
        ),
        backgroundColor: Color(0xFF06628A), // Set appbar color to #0xFF06628A
      ),
       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30.0), 
            Card(
              elevation: 8.0,
              color: const Color(0xFFE4FDFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // Bentuk ujung card
                side: BorderSide(color: Color(0XFF097DAE), width: 1.0), // Warna dan lebar border
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    children: <Widget>[
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Tambah Poliklinik',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: id_poli,
                          decoration: const InputDecoration(
                            labelText: 'ID Poliklinik :',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Detail Poliklinik Tidak Boleh Kosong";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          key: const Key('nama_poli'),
                          controller: nama_poli,
                          decoration: const InputDecoration(
                            labelText: 'Nama Poliklinik :',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Detail Poliklinik Tidak Boleh Kosong";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: detail,
                          decoration: const InputDecoration(
                            labelText: 'Detail :',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Detail Poliklinik Tidak Boleh Kosong";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Kode untuk membatalkan operasi
                              Navigator.of(context).pop();
                            },
                            child: Text('Batal',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F267A),
                                )),
                          ),
                          TextButton(
                            onPressed: () {
                              // Kode untuk menyimpan data
                              if (formKey.currentState!.validate()) {
                                _simpan().then((value) {
                                  if (value) {
                                    final snackBar = SnackBar(
                                      content: const Text('Data Berhasil Di Simpan!'),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                      content: const Text('Data Gagal Di Simpan!'),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                  (route) => false,
                                );
                              }
                            },
                            child: Text('Simpan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F267A),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
