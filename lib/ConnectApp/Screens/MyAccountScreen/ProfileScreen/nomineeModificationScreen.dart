import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Nomineemodificationscreen extends StatefulWidget {
  const Nomineemodificationscreen({super.key});

  @override
  State<Nomineemodificationscreen> createState() =>
      _NomineemodificationscreenState();
}

class _NomineemodificationscreenState extends State<Nomineemodificationscreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormState>> _formKeys = [];
  final List<Widget> _forms = [];
  int _nomineeCount = 1;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _addNomineeForm();
  }

  void _addNomineeForm() {
    if (_nomineeCount < 4) {
      _formKeys.add(GlobalKey<FormState>());
      _forms.add(_buildNomineeForm(_nomineeCount));
      _nomineeCount++;
      setState(() {});
    }
  }

  void _removeNomineeForm(int index) {
    if (_nomineeCount > 1) {
      _formKeys.removeAt(index);
      _forms.removeAt(index);
      _nomineeCount--;
      setState(() {});
    }
  }

  Future<void> _showDateTimePicker(TextEditingController controller) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00A9FF),
              onPrimary: Colors.black,
              onSurface: Color(0xFF313131),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF313131),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (datePicked != null) {
      controller.text =
          "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  Widget _buildNomineeForm(int index) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController panNumberController = TextEditingController();
    final TextEditingController birthDateController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController sharePercentageController =
        TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final SingleValueDropDownController dropDownController =
        SingleValueDropDownController();

    return Form(
      key: _formKeys[index - 1],
      child: Column(
        children: [
          TextFormField(
            controller: panNumberController,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              labelText: 'Pan Card Number',
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF777777)),
              contentPadding: const EdgeInsets.all(0),
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
            ),
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your pan card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              labelText: 'Full Name As Per Pan',
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF777777)),
              contentPadding: const EdgeInsets.all(0),
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
            ),
            cursorColor: const Color(0xFF777777),
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: birthDateController,
            readOnly: true,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              labelText: 'Date of Birth',
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF777777)),
              contentPadding: const EdgeInsets.all(0),
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
            ),
            onTap: () {
              _showDateTimePicker(birthDateController);
            },
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your birth date';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropDownTextField(
            controller: dropDownController,
            clearOption: false,
            enableSearch: false,
            dropdownRadius: 10,
            padding: const EdgeInsets.all(0),
            textFieldDecoration: InputDecoration(
              fillColor: Colors.transparent,
              labelText: 'Relation',
              labelStyle: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF777777),
              ),
              contentPadding: const EdgeInsets.all(0),
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
            ),
            clearIconProperty: IconProperty(color: Colors.black),
            validator: (value) {
              if (value == null) {
                return "Required field";
              } else {
                return null;
              }
            },
            dropDownItemCount: 3,
            dropDownList: const [
              DropDownValueModel(name: 'Mother', value: "Mother"),
              DropDownValueModel(name: 'Father', value: "Father"),
              DropDownValueModel(name: 'Other', value: "Other"),
            ],
            onChanged: (val) {},
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: sharePercentageController,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              labelText: 'Share Percentage',
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF777777)),
              contentPadding: const EdgeInsets.all(0),
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            cursorColor: const Color(0xFF777777),
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your nominee share percentage';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              labelText: 'Address',
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF777777)),
              contentPadding: const EdgeInsets.all(0),
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
            ),
            cursorColor: const Color(0xFF777777),
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: cityController,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              labelText: 'City',
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF777777)),
              contentPadding: const EdgeInsets.all(0),
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF3F3F3),
                  width: 1.0,
                ),
              ),
            ),
            cursorColor: const Color(0xFF777777),
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 50,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF292D32)),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFF292D32),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
          text: "Nominee Details",
          color: const Color(0xFF00A9FF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _forms.isEmpty
                  ? Center(
                      child: Utils.text(
                        text: "No forms available",
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _forms.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: 'Form ${index + 1}',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00A9FF),
                                ),
                                Visibility(
                                  visible: index != 0,
                                  child: InkWell(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.redAccent.shade700
                                          .withOpacity(0.1),
                                      radius: 15,
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTap: () {
                                      _removeNomineeForm(index - 1);
                                    },
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border:
                                    Border.all(color: const Color(0xFFF3F3F3)),
                              ),
                              child: _forms[index],
                            ),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: _nomineeCount < 4,
              child: Row(
                children: [
                  const Icon(Icons.add, color: Color(0xFF777777), size: 25),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _addNomineeForm,
                    child: Utils.text(
                      text: "Add More Nominee",
                      color: const Color(0xFF777777),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                // Add your submit logic here
              },
              child: Utils.gradientButton(message: "SUBMIT"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
