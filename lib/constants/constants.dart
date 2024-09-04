class CONSTANT_VAR {
  static bool EMULATOR_MODE = false;
  static bool DEV_MODE = true;

  //DEV ENDPOINT
  // static String BASE_URL_PUBLIC = "https://dev.rentas.co.id/sikap/sikap-api";
  // static String BASE_URL_API = "https://dev.rentas.co.id/sikap/sikap-api/api";

  //PRODUCTION EDPOINT
  static String BASE_URL_PUBLIC = "https://pdc-api.smart-check.id";
  static String BASE_URL_API = "https://pdc-api.smart-check.id/api";

  static String PLAYSTORE_URL =
      "https://play.google.com/store/apps/details?id=com.pdc.smartcheck.multiple";

  static double DEFAULT_TRESHOLD = 0.75;
  static int LAMA_JAM_BEKERJA = 9;
  static int CUT_OFF_PERIODE = 16;
  static int headEulerY = 5;
  static int headEulerX = 10;

  // static String SHIFT_RIG_DUMMY =
  //     '[{"status_branch_id":"7","branch_id":"ADMIN_DEMO","status_branch":"MAINTANCE","duration":"12","shift":[{"id":"PDC_PAGI","checkin":"19:00","checkout":"07:00"},{"id":"PDC_MALAM","checkin":"07:00","checkout":"19:00"},{"id":"PDC_ONCALL","checkin":"07:00","checkout":"07:00"}]},{"status_branch_id":"8","branch_id":"ADMIN_DEMO","status_branch":"IDLE","duration":"12","shift":[{"id":"PDC_PAGI","checkin":"19:00","checkout":"07:00"},{"id":"PDC_MALAM","checkin":"07:00","checkout":"19:00"},{"id":"PDC_ONCALL","checkin":"07:00","checkout":"07:00"}]},{"status_branch_id":"9","branch_id":"ADMIN_DEMO","status_branch":"OPERATION","duration":"12","shift":[{"id":"PDC_PAGI","checkin":"19:00","checkout":"07:00"},{"id":"PDC_MALAM","checkin":"07:00","checkout":"19:00"},{"id":"PDC_ONCALL","checkin":"07:00","checkout":"07:00"}]},{"status_branch_id":"10","branch_id":"ADMIN_DEMO","status_branch":"MOVING","duration":"12","shift":[{"id":"PDC_PAGI","checkin":"19:00","checkout":"07:00"},{"id":"PDC_MALAM","checkin":"07:00","checkout":"19:00"},{"id":"PDC_ONCALL","checkin":"07:00","checkout":"07:00"}]}]';
}
