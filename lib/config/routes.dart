import 'package:assignment/app.dart';
import 'package:assignment/screens/edit_event_screen.dart';
import 'package:assignment/screens/forgot_password_screen.dart';
import 'package:assignment/screens/home_screen.dart';
import 'package:assignment/screens/login_screen.dart';
import 'package:assignment/screens/organize_event_screen.dart';
import 'package:assignment/screens/signup_screen.dart';
import 'package:assignment/screens/splash_screen.dart';
import 'package:assignment/screens/profile_edit_screen.dart';
import 'package:assignment/screens/profile_view_screen.dart';
import 'package:assignment/screens/ban_user_screen.dart';
import 'package:assignment/screens/report_user_screen.dart';
import 'package:assignment/screens/event_calendar.dart';
import 'package:assignment/screens/faq.dart';
import 'package:assignment/screens/request_feedback.dart';
import 'package:assignment/screens/view_request.dart';
import 'package:assignment/screens/past_request.dart';
import 'package:assignment/screens/event_details.dart';
import 'package:flutter/material.dart';


final Map<String, WidgetBuilder> routesConfig = {
  '/': (_) => const SplashArt(),
  '/auth': (_) => const AuthStateWidget(),
  '/authSignUp': (_) => const AuthStateSignUpWidget(),
  '/login': (_) => const LoginScreen(),
  '/signup': (_) => const SignupScreen(),
  '/forgotPassword': (_) => const ForgotPasswordScreen(),
  '/home': (_) => const HomeScreen(),
  '/event_calendar' : (_) => const EventCalendarScreen(),
  '/edit_profile' : (_) => const ProfileEditScreen(),
  '/others_profile' : (_) => const ProfileViewScreen(),
  '/report_user' : (_) => const ReportUserScreen(),
  '/event_details' : (_) => const EventDetailsScreen(),
  '/faq':  (_) => const FAQScreen(),
  '/make_request_feedback':  (_) => const RequestFeedbackScreen(),
  '/view_past_request':  (_) => const PastRequestScreen(),
  '/organize_event': (_) => const OrganizeEventScreen(),
  '/edit_event':  (_) => const EditEventScreen(),
  '/view_request':  (_) => const ViewRequestScreen(),
  '/ban_user' : (_) => const BanUserScreen(),
};