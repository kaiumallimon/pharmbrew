import 'package:pharmbrew/domain/usecases/constants/_departments_dummy.dart';

// List<String> getDesignations() {
//   return departments.map((dept) => dept['designation'].toString()).toList();
// }

// String? getDepartmentIdByName(String departmentName) {
//   for (var department in departments) {
//     if (department['name'] == departmentName) {
//       return department['id'].toString();
//     }
//   }

//   return null;
// }

List<String> getAllDesignations() {
  List<String> allDesignations = [];
  for (var department in departments) {
    var designations = department['designations'];
    if (designations is List<String>) {
      allDesignations.addAll(designations);
    } else if (designations is String) {
      allDesignations.add(designations);
    }
  }
  return allDesignations;
}

String? getDepartmentIdByDesignation(String designation) {
  for (var department in departments) {
    var designations = department['designations'];
    if (designations is List<String> && designations.contains(designation)) {
      return department['id'].toString();
    } else if (designations is String && designations == designation) {
      return department['id'].toString();
    }
  }
  return null; // Return null if the designation is not found in any department
}
