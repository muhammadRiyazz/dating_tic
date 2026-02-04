 int calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return 0;
    try {
      DateTime birthDate = DateTime.parse(dobString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }