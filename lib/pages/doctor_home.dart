import 'package:flutter/services.dart';
import 'package:notchai_frontend/section/category_section.dart';
import 'package:notchai_frontend/section/hd_section.dart';
import 'package:notchai_frontend/section/trd_section.dart';
import 'package:notchai_frontend/models/category.dart';
import 'package:notchai_frontend/models/doctor.dart';
import 'package:notchai_frontend/pages/detail_page.dart';
import 'package:notchai_frontend/utils/custom_icons.dart';
import 'package:notchai_frontend/utils/he_color.dart';
import 'package:flutter/material.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  List<Doctor> _hDoctors = [];
  List<Category> _categories = [];
  List<Doctor> _trDoctors = [];

  _onCellTap(Doctor doctor) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(doctor: doctor),
        ));
  }

  @override
  void initState() {
    super.initState();
    _hDoctors = _getHDoctors();
    _categories = _getCategories();
    _trDoctors = _getTRDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hDoctorsSection(),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _categorySection(),
                  const SizedBox(
                    height: 32,
                  ),
                  _trDoctorsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: HexColor('#150047')),
      leading: IconButton(
        icon: const Icon(
          CustomIcons.menu,
          size: 14,
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(
            CustomIcons.search,
            size: 20,
          ),
          onPressed: () {},
        ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  SizedBox _hDoctorsSection() {
    return SizedBox(
      height: 199,
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _hDoctors.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(indent: 16),
        itemBuilder: (BuildContext context, int index) => HDCell(
          doctor: _hDoctors[index],
          onTap: () => _onCellTap(_hDoctors[index]),
        ),
      ),
    );
  }

  Column _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(indent: 16),
            itemBuilder: (BuildContext context, int index) =>
                CategoryCell(category: _categories[index]),
          ),
        ),
      ],
    );
  }

  /// Top Rated Doctors Section
  Column _trDoctorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Rated Doctor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: _trDoctors.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            thickness: 16,
            color: Colors.transparent,
          ),
          itemBuilder: (BuildContext context, int index) =>
              TrdCell(doctor: _trDoctors[index]),
        ),
      ],
    );
  }

  /// **********************************************
  /// DUMMY DATA
  /// **********************************************

  List<Doctor> _getHDoctors() {
    List<Doctor> hDoctors = [];

    hDoctors.add(Doctor(
      firstName: 'Albert',
      lastName: 'Alexander',
      image: 'albert.png',
      type: 'Skin',
      rating: 4.5,
    ));
    hDoctors.add(Doctor(
      firstName: 'Elisa',
      lastName: 'Rose',
      image: 'dr-elisa.jpg',
      type: 'Heart',
      rating: 4.5,
    ));

    return hDoctors;
  }

  /// Get Categories
  List<Category> _getCategories() {
    List<Category> categories = [];
    categories.add(Category(
      icon: CustomIcons.cardiologist,
      title: 'Dermatologist',
    ));
    categories.add(Category(
      icon: CustomIcons.eyes,
      title: 'Cardiologist',
    ));
    categories.add(Category(
      icon: CustomIcons.pediatrician,
      title: 'Pediatrician',
    ));
    return categories;
  }

  /// Get Top Rated Doctors List
  List<Doctor> _getTRDoctors() {
    List<Doctor> trDoctors = [];

    trDoctors.add(Doctor(
      firstName: 'Mathew',
      lastName: 'Chambers',
      image: 'mathew.png',
      type: 'Bone',
      rating: 4.3,
    ));
    trDoctors.add(Doctor(
        firstName: 'Cherly',
        lastName: 'Bishop',
        image: 'cherly.png',
        type: 'Eye',
        rating: 4.7));
    trDoctors.add(Doctor(
        firstName: 'Albert',
        lastName: 'Alexander',
        image: 'albert.png',
        type: 'Skin',
        rating: 4.3));
    trDoctors.add(Doctor(
      firstName: 'Elisa',
      lastName: 'Rose',
      image: 'dr-elisa.jpg',
      type: 'Heart',
      rating: 4.5,
    ));
    return trDoctors;
  }
}
