//
//  FRLanguage.h
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/25/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#ifndef FRLanguage_h
#define FRLanguage_h

//Navigation titles
#define LANG_TITLE_CALENDAR_BOOKING @"Bookings"
#define LANG_TITLE_LIST_BOOKING @"History(Free)"
#define LANG_TITLE_NOTIFICATIONS @"Notifications(Free)"
#define LANG_TITLE_MY_HOSTINGS @"Hostings"
#define LANG_TITLE_REPORTS @"Accounting"
#define LANG_TITLE_ACCOUNT @"My Profile"
#define LANG_TITLE_ABOUT_US @"Info FastRent"

//Booking
#define LANG_BOOKING_ADD_TEXT @"New"
#define LANG_BOOKING_LIST_SEARCH_TEXT @"Search  "
#define LANG_BOOKING_LIST_EMPTY_CONTENT @"No bookings."
#define LANG_BOOKING_DETAIL_TITLE @"Booking"
#define LANG_BOOKING_SECTION_BASIC_TEXT @"BASIC INFO"
#define LANG_BOOKING_CHECKIN_DATE_TEXT @"Checkin date"
#define LANG_BOOKING_CHECKOUT_DATE_TEXT @"Checkout date"
#define LANG_BOOKING_SECTION_PRICE_TEXT @"PRICES"
#define LANG_BOOKING_NIGHTS_COUNT_TEXT @"Nights count"
#define LANG_BOOKING_NIGHT_TEXT @"night"
#define LANG_BOOKING_NIGHTS_TEXT @"nights"
#define LANG_BOOKING_PRICE_PER_NIGHT_TEXT @"Price per night"
#define LANG_BOOKING_AMOUNT_TEXT @"amount"
#define LANG_BOOKING_DESCRIPTION_HOSTING_PLACEHOLDER_TEXT @"Type"
#define LANG_BOOKING_DESCRIPTION_GUESTS_PLACEHOLDER_TEXT @"Type"
#define LANG_BOOKING_DESCRIPTION_HOSTING_SUBTITLE_TEXT @"Hosting description"
#define LANG_BOOKING_DESCRIPTION_GUESTS_SUBTITLE_TEXT @"Guests description"
#define LANG_BOOKING_SECTION_SERVICES_TEXT @"OTHER SERVICES"
#define LANG_BOOKING_DESCRIPTION_SERVICES_PLACEHOLDER_TEXT @"Type services information..."
#define LANG_BOOKING_DESCRIPTION_SERVICES_SUBTITLE_TEXT @"Services"
#define LANG_BOOKING_INCOME_PER_SERVICES_TEXT @"Incomes"
#define LANG_BOOKING_AMOUNT_PER_SERVICES_TEXT @"total"
#define LANG_DELETE_BOOKING_TEXT @"Delete booking"
#define LANG_ALERT_DELETE_BOOKING_TEXT @"Do you really want to delete this booking?"

//Hosting
#define LANG_WITHOUT_HOSTING_TEXT @"No Hosting"
#define LANG_HOSTING_DETAIL_TITLE @"Habitación 1"

//Profile
#define LANG_TITLE_PROFILE @"Owner"
#define LANG_PROFILE_SECTION_BASIC_TEXT @"BASIC INFO"
#define LANG_PROFILE_NAME_PLACEHOLDER_TEXT @"Type"
#define LANG_PROFILE_NAME_SUBTITLE_TEXT @"Owner name"
#define LANG_PROFILE_EMAIL_PLACEHOLDER_TEXT @"Type"
#define LANG_PROFILE_EMAIL_SUBTITLE_TEXT @"Owner email"
#define LANG_PROFILE_PHONE_PLACEHOLDER_TEXT @"Type"
#define LANG_PROFILE_PHONE_SUBTITLE_TEXT @"Phone"
#define LANG_PROFILE_CELL_PLACEHOLDER_TEXT @"Type"
#define LANG_PROFILE_CELL_SUBTITLE_TEXT @"Cell phone"
#define LANG_DELETE_PROFILE_TEXT @"Delete owner"
#define LANG_ALERT_DELETE_PROFILE_TEXT @"Do you really want to delete this booking owner?"
#define LANG_MAKE_PHOTO @"Make a Picture"
#define LANG_CHOOSE_PHOTO @"Pick a Picture"

//Filter
#define LANG_FILTER_TITLE_TEXT @"Filters"
#define LANG_FILTER_FROM_TEXT @"Since"
#define LANG_FILTER_TO_TEXT @"To"

//Notifications
#define LANG_NOTIFICATION_GUESTS_CHECKIN @"Guests entry" //DUDA
#define LANG_NOTIFICATION_GUESTS_CHECKOUT @"Guests departure" //DUDA
#define LANG_NOTIFICATION_EMPTY_CONTENT @"No notifications."

//Overlay
#define LANG_CALENDAR_OVERLAY_TEXT @"Sample screen.\n\nOn FastRent Agenda Professional you have:\n\nA Calendar for each hosting.\n\nAlso:\n\n* Add bookings.\n\n* Choose Hosting.\n\n* Guests description.\n\n* View bookings details:\n  Calculate nights count.\n  Payments. Fees.\n\n* Services description and\n  incomes and more..."
#define LANG_HOSTING_OVERLAY_TEXT @"Sample screen.\n\nGet FastRent Agenda Professional:\n\n* Houses or rooms listings.\n\n* Photos. Prices. Addresses.\n\n* Contact owners by phone call\n  or SMS."
#define LANG_NOTIFICATIONS_OVERLAY_TEXT @"1 month trial screen.\n\nAn agenda with life.\n\nEvery day.\n\n* Notifications for:\n\n> Guests entry and departutes.\n\n> Fee payments.\n\n* Bookings details.";
#define LANG_STATISTICS_OVERLAY_TEXT @"Sample screen.\n\nCalculate your incomes:\n\n*  By month and year.\n\n*  Each booking.\n\n*  By rent, services, fees.\n\nFastRent Agenda Profesional price: 35 CUC.\n\nPay once and use it forever.\n\nContact us !!!  +53 5 551 6544"
#define LANG_TASKS_REMAINING_OVERLAY_TEXT @"1 month trial screen.\n\nTry our Professional application.\n\nA history with:\n\n* Your bookings listings.\n\n* Go to each booking\n  detail.\n\nSearch:\n\n* By dates.\n\n* By booking status and\n  hostings (Professional\n  application).";

//General
#define GENERAL_ALERT_OK_BUTTON_TEXT @"OK"
#define GENERAL_ALERT_CANCEL_BUTTON_TEXT @"Cancel"
#define GENERAL_ALERT_ERROR_TITLE_TEXT @"Error"
#define GENERAL_ALERT_INFORMATION_TITLE_TEXT @"Warning"

//General errors
#define LANG_ERROR_DATE_TEXT @"Checkout date must be greather than checkin date."
#define LANG_ERROR_MATCH_OTHER_BOOKING_ERROR @"Dates match with other bookings."
#define LANG_ERROR_EMPTY_CLIENT_DESCRIPTION @"Please type guests information."
#define LANG_ERROR_EMPTY_OWNER_NAME @"Empty owner name"
#define LANG_ERROR_TRIAL_EXPIRED @"Trial finished. You must activate the application."
#define LANG_ERROR_DEVICE_CHECK @"Device error."
#define LANG_ERROR_WRONG_PASSWORD @"Wrong password."
#define LANG_ERROR_NOT_SAVED_PASSWORD @"There is no saved password."

#define LANG_TRIAL_TEXT(DAYS) [NSString stringWithFormat:@"%@ days application trial left", DAYS]

#endif /* FRLanguage_h */
