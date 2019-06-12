import 'dart:convert';

class ConfigApi {
  static String username = 'support@skaratechnologies.com';
  static String password = 'secret';

  static String basicAuth = 'Basic ' +
      base64Encode(utf8.encode(ConfigApi.username + ':' + ConfigApi.password));

//   TODO live api
  static String URL = "http://jainsurakshasangh.org/api/api/";
  static String DOWNLOAD_URL = "http://jainsurakshasangh.org/api/api";

//  Todo Local api
//  static String URL = "http://192.168.1.37:8001/api/";
//  static String DOWNLOAD_URL = "http://192.168.1.37:8001/api";


  /* ====== TODO LOGIN Api ====== */
  static String LOGIN_API = URL + "login";

  /* ====== TODO SIGNUP Api ====== */
  static String SIGNUP_API = URL + "signup";

  /* ====== TODO MEMBER-TYPE ====== */
  static String MEMBER_TYPE_API = URL + "member-type";

  /* ====== TODO MEMBER ====== */
  static String MEMBER_API = URL + "member";

  /* ====== TODO CAMPAIGNS ====== */
  static String ALlCAMPAIGNS_API = URL + "getAllCampaigns";

  /* ====== TODO EVENT ====== */
  static String EVENTS_API = URL + "open/event";
  static String EVENTS_USER_API = URL + "event";

  /* ====== TODO BLOGS ====== */
  static String BLOGS_API = URL + "open/blog";

  /* ====== TODO DONATION ====== */
  static String DONATION_API = URL + "donation";
  static String DONATION_CATEGORY_API = URL + "getAllDonationCategories";

  /* ====== TODO EVENT COUNTER ====== */
  static String EVENT_COUNTER_API = URL + "event_counter";

  /* ====== TODO EVENT COUNTER ====== */
  static String SEVA_CATEGORY_API = URL + "seva_category";
  static String SEVA_API = URL + "seva";

  /* ====== TODO COMPLAIN ====== */
  static String COMPLAIN_API = URL + "complaint";

  /* ====== TODO COMPLAIN ====== */
  static String GALLERY_API = URL + "gallery";

  /* ====== TODO MAGZINE SUBSCRIBER ====== */
  static String MAGSUB_API = URL + "magsub";
}
