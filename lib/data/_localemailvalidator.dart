bool isEmailValid(String email) {
  // Check if email contains '@' and ends with '.com'
  if (email.contains('@') && email.endsWith('.com')) {
    return true;
  } else {
    return false;
  }
}
