import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/profile/company/edit_comp_form.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/signup/company/company_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCompanyScreen extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // key: _controller.scaffoldkey,
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
         child: Container(
           width: double.infinity,
          // height: 600,
          decoration: BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
                SectionTitle(
                  title: "Edit profile",
                  color: Color(0xFFFF78a2cc),
                ),
                 SizedBox(
                height: 30,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: 
                  EditCompanyForm()
                  ),
              SizedBox(
                height: 30,
              )
        ],
          ),
        ),
      ),
    );
  }


}