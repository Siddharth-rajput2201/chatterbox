class Utils
{
  static String getUsername(String email)
  {
    return "${email.split('@')[0]}";
  }

  static String getInitials(String name , String email) {
    if(name!=null)
      {
        List<String> nameSplit = name.split(" ");
        String firstNameInitial = nameSplit[0][0];
        String lastNameInitial = nameSplit[1][0];
        return firstNameInitial + lastNameInitial;
      }
    else{
      String emailIntials = email[0];
      return emailIntials;
    }
  }
}