import 'package:cutis_ai/Start%20Dignosis%20Data/Start_Diagnosis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cutis_ai/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            homeScreen(),
            Positioned(
              bottom: 15,
              child: Container(
                height: 60.h,
                width: 210.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Textcolor,
                  ),
                  color: SurfaceColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        selectedIcon: CircleAvatar(
                          backgroundColor: SecondaryColor,
                          child: Icon(
                            Icons.home_filled,
                            color: Textcolor,
                            size: 25.sp,
                          ),
                        ),
                        onPressed: () {},
                        icon: Icon(
                          Icons.home_filled,
                          color: Textcolor,
                          size: 25.sp,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.document_scanner_sharp,
                            color: Textcolor, size: 25.sp)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person, color: Textcolor, size: 25.sp))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class homeScreen extends StatefulWidget {
  const homeScreen({
    super.key,
  });

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: SurfaceColor,
        ),
        padding: EdgeInsets.only(bottom: 90.h),
        child: Column(
          children: [
            Container(
              height: 200.h,
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 25.h, left: 8.w, right: 8.w),
              decoration: BoxDecoration(
                color: PrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Image(
                            image: AssetImage(
                                'lib/Assects/logo_white.png'),
                            height: 52.h,
                            width: 52.w,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            'Cutis-AI',
                            style: GoogleFonts.dmSans(
                              color: OnPrimaryColor,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage:
                            AssetImage('lib/Assects/Ellipse 4.png'),
                      )
                    ],
                  ),
                  Spacer(),
                  Text(
                    'Hello, User !',
                    style: GoogleFonts.poppins(
                      color: OnPrimaryColor,
                      fontSize: 25.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'We have tailored best experience and Personalized Care at Your Fingertips !',
                    style: GoogleFonts.poppins(
                      color: OnPrimaryColor,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Special offer',
                        style: GoogleFonts.dmSans(
                          color: Textcolor,
                          fontSize: 18.sp,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'See all',
                        style: GoogleFonts.dmSans(
                          color: SecondaryColor,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 160.h,
                    width: 350.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Explore more',
                    style: GoogleFonts.dmSans(
                      color: Textcolor,
                      fontSize: 18.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat_UI()));
                    },
                    child: Container(
                        height: 110.h,
                        width: 350.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(
                                  'lib/Assects/diagnostic.png'),
                              height: 60.h,
                              width: 60.w,
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Diagnosis',
                                    style: GoogleFonts.poppins(
                                      color: Textcolor,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    'Assess skin condition by checking for abnormalities or changes in texture.',
                                    style: GoogleFonts.poppins(
                                      color: Textcolor,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Container(
                      height: 110.h,
                      width: 350.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        children: [
                          Image(
                            image:
                                AssetImage('lib/Assects/skincare.png'),
                            height: 60.h,
                            width: 60.w,
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Skin care',
                                  style: GoogleFonts.poppins(
                                    color: Textcolor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Evaluate your skin by ensuring it addresses specific skin concerns consistently.',
                                  style: GoogleFonts.poppins(
                                    color: Textcolor,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                      height: 110.h,
                      width: 350.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage('lib/Assects/doctor.png'),
                            height: 60.h,
                            width: 60.w,
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Consult a Dermatologist',
                                  style: GoogleFonts.poppins(
                                    color: Textcolor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Consult a doctor for professional evaluation and treatment.',
                                  style: GoogleFonts.poppins(
                                    color: Textcolor,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
