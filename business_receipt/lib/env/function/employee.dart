import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';

List<String> getEmployeeNameListOnly() {
  List<String> employeeNameList = [];
  for (int employeeIndex = 0; employeeIndex < profileEmployeeModelListAdminGlobal.length; employeeIndex++) {
    final String? currentEmployeeIdOrNull = (profileModelEmployeeGlobal == null) ? null : profileModelEmployeeGlobal!.id;
    final bool isNotCurrentEmployeeMatch = (profileEmployeeModelListAdminGlobal[employeeIndex].id != currentEmployeeIdOrNull);
    if (isNotCurrentEmployeeMatch) {
      employeeNameList.add(profileEmployeeModelListAdminGlobal[employeeIndex].name.text);
    }
  }
  return employeeNameList;
}
