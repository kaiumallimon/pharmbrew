bool isProductExpired(String expiryDateString) {
  DateTime expiryDate = DateTime.parse(expiryDateString);
  DateTime currentDate = DateTime.now();
  return currentDate.isAfter(expiryDate);
}

void main(){
  print(
      '${isProductExpired('2025-03-24')}'
  );
}