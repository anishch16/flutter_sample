import 'package:flutter/material.dart';
import 'person.dart';
import 'database_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Person> persons = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedBloodGroup;
  String? selectedNationality;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() async {
    List<Person> personsList = await databaseHelper.getAllPersons();
    setState(() {
      persons = personsList;
    });
  }

  void _addPerson() {
    nameController.clear();
    ageController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Person'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the age';
                      }
                      if (!_isAgeValid(value)) {
                        return 'Invalid age. Please enter a valid number.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Age'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedBloodGroup,
                    items: bloodGroups
                        .map((group) => DropdownMenuItem<String>(
                              value: group,
                              child: Text(group),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBloodGroup = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the blood group';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Blood Group'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedNationality,
                    items: nationalities
                        .map((nation) => DropdownMenuItem<String>(
                              value: nation,
                              child: Text(nation),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedNationality = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the nationality';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Nationality'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final person = Person(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    bloodGroup: selectedBloodGroup!,
                    nationality: selectedNationality!,
                  );

                  persons.add(person);
                  await databaseHelper.saveAllPersons(persons);
                  _refreshList();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  bool _isAgeValid(String ageText) {
    try {
      int.parse(ageText);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _editPerson(Person person) {
    nameController.text = person.name;
    ageController.text = person.age.toString();
    selectedBloodGroup = person.bloodGroup;
    selectedNationality = person.nationality;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Person'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the age';
                      }
                      if (!_isAgeValid(value)) {
                        return 'Invalid age. Please enter a valid number.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Age'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedBloodGroup,
                    items: bloodGroups
                        .map((group) => DropdownMenuItem<String>(
                              value: group,
                              child: Text(group),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBloodGroup = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the blood group';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Blood Group'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedNationality,
                    items: nationalities
                        .map((nation) => DropdownMenuItem<String>(
                              value: nation,
                              child: Text(nation),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedNationality = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the nationality';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Nationality'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final updatedPerson = Person(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    bloodGroup: selectedBloodGroup!,
                    nationality: selectedNationality!,
                  );
                  final personIndex = persons.indexWhere((p) => p == person);
                  if (personIndex >= 0) {
                    persons[personIndex] = updatedPerson;
                    await databaseHelper.saveAllPersons(persons);
                    nameController.clear();
                    ageController.clear();
                    selectedBloodGroup = null;
                    selectedNationality = null;
                    _refreshList();
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deletePerson(Person person) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Person'),
          content: Text('Are you sure you want to delete ${person.name}?'),
          actions: [
            TextButton(
              onPressed: () async {
                persons.remove(person);
                await databaseHelper.saveAllPersons(persons);
                _refreshList();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  static const List<String> nationalities = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Japan',
    'China',
    'Australia',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 134, 175, 173),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Persons Table',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('SN')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Age')),
                      DataColumn(label: Text('Blood Group')),
                      DataColumn(label: Text('Nationality')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: persons.asMap().entries.map((entry) {
                      int sn = entry.key + 1; // Serial number starting from 1
                      Person person = entry.value;

                      return DataRow(cells: [
                        DataCell(Text(sn.toString())),
                        DataCell(Text(person.name)),
                        DataCell(Text(person.age.toString())),
                        DataCell(Text(person.bloodGroup)),
                        DataCell(Text(person.nationality)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editPerson(person),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deletePerson(person),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addPerson,
            child: const Text('Add Person'),
          ),
        ],
      ),
    );
  }
}
