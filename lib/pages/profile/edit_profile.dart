import 'package:delivery_man/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController businessname = TextEditingController();
  TextEditingController businessemail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        backgroundColor: const Color(0xFF212425),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Align(
          alignment: AlignmentDirectional(-1, 0),
          child: Text(
            'Your Profiles',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment(0, 0),
                      child: TabBar(
                        indicatorColor: white,
                        labelStyle: TextStyle(
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 16,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Color(0xFF545858),
                        padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                        tabs: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                child: Icon(
                                  Icons.person_outlined,
                                ),
                              ),
                              Tab(
                                text: 'Personal',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                child: Icon(
                                  Icons.business_center_rounded,
                                ),
                              ),
                              Tab(
                                text: 'Business',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Builder(
                            builder: (context) => Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 2, 10, 2),
                                        child: TextFormField(
                                          controller: name,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            labelStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            hintText: 'Name',
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFCFCFD),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF060000),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            suffixIcon: name.text.isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      name.clear();
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.clear,
                                                      color: Color(0xFF060000),
                                                      size: 14,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: const TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 2, 10, 2),
                                        child: TextFormField(
                                          controller: email,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            hintText: 'Email',
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFCFCFD),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF060000),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            suffixIcon: email.text.isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      email.clear();
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.clear,
                                                      color: Color(0xFF060000),
                                                      size: 14,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: const TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 2, 10, 2),
                                        child: TextFormField(
                                          controller: phone,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Phone',
                                            labelStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            hintText: 'Phone',
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFCFCFD),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF060000),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            suffixIcon: phone.text.isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      phone.clear();
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.clear,
                                                      color: Color(0xFF060000),
                                                      size: 14,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: const TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) => Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 2, 10, 2),
                                        child: TextFormField(
                                          controller: businessname,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Business Name',
                                            labelStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            hintText: 'Business Name',
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFCFCFD),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF060000),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            suffixIcon: businessname
                                                    .text.isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      businessname.clear();
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.clear,
                                                      color: Color(0xFF060000),
                                                      size: 14,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: const TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 2, 10, 2),
                                        child: TextFormField(
                                          controller: businessemail,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Business Email',
                                            labelStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            hintText: 'Business Email',
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF060000),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFCFCFD),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF060000),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFEBFA14),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            suffixIcon: businessemail
                                                    .text.isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      businessemail.clear();
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.clear,
                                                      color: Color(0xFF060000),
                                                      size: 14,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: const TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
