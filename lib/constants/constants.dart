class COSTANT_VAR {
  static bool EMULATOR_MODE = false;

  //DEV ENDPOINT
  // static String BASE_URL_PUBLIC = "https://dev.rentas.co.id/sikap/sikap-api";
  // static String BASE_URL_API = "https://dev.rentas.co.id/sikap/sikap-api/api";

  static double DEFAULT_TRESHOLD = 0.75;
  static int LAMA_JAM_BEKERJA = 9;

  //PRODUCTION EDPOINT
  static String BASE_URL_PUBLIC = "https://pdc-api.smart-check.id";
  static String BASE_URL_API = "https://pdc-api.smart-check.id/api";

  static String SHIFT_RIG_DUMMY = '[{"status_branch_id":"7","branch_id":"ADMIN_DEMO","status_branch":"MAINTANCE","duration":"12","shift_pagi":{"id":"PDC_PAGI","checkin_pagi":"19:00","checkout_pagi":"07:00"},"shift_malam":{"id":"PDC_MALAM","checkin_malam":"07:00","checkout_malam":"19:00"},"shift_oncall":{"id":"PDC_ONCALL","oncall_checkin":"07:00","oncall_checkout":"07:00"}},{"status_branch_id":"8","branch_id":"ADMIN_DEMO","status_branch":"IDLE","duration":"12","shift_pagi":{"id":"PDC_PAGI","checkin_pagi":"19:00","checkout_pagi":"07:00"},"shift_malam":{"id":"PDC_MALAM","checkin_malam":"07:00","checkout_malam":"19:00"},"shift_oncall":{"id":"PDC_ONCALL","oncall_checkin":"07:00","oncall_checkout":"07:00"}},{"status_branch_id":"9","branch_id":"ADMIN_DEMO","status_branch":"OPERATION","duration":"12","shift_pagi":{"id":"PDC_PAGI","checkin_pagi":"19:00","checkout_pagi":"07:00"},"shift_malam":{"id":"PDC_MALAM","checkin_malam":"07:00","checkout_malam":"19:00"},"shift_oncall":{"id":"PDC_ONCALL","oncall_checkin":"07:00","oncall_checkout":"07:00"}},{"status_branch_id":"10","branch_id":"ADMIN_DEMO","status_branch":"MOVING","duration":"12","shift_pagi":{"id":"PDC_PAGI","checkin_pagi":"19:00","checkout_pagi":"07:00"},"shift_malam":{"id":"PDC_MALAM","checkin_malam":"07:00","checkout_malam":"19:00"},"shift_oncall":{"id":"PDC_ONCALL","oncall_checkin":"07:00","oncall_checkout":"07:00"}}]';
}