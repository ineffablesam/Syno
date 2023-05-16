// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

String MAIN_BACKEND_URL_PROD = dotenv.get('API_URL');
String MAIN_BACKEND_URL_DEBUG = dotenv.get('API_URL_DEBUG');

String YT_API_KEY = dotenv.get('YT_API_KEY');
