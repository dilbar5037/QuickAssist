class Validate
{
  static String? Textvalidator(String value)
  {
    if(value.length<2)
      return 'REQUIRED FIELD';
    else
      return null;
  }
  static String? check(String value)
  {
    if(value.isEmpty==true)
      return 'REQUIRED FIELD';
    else
      return null;
  }
  static String? GenderValidator(String value)
  {
    if(num.parse(value)==null)
      return 'REQUIRED FIELD';
    else
      return null;
  }
  static String? pwdvalidator(String value)
  {
    if(value.length<8) {
      return('PASSWORD SHOULD CONTAIN ATLEAST 8 CHARACTERS');
    } else
      return null;
  }
  static String? confirmvalidator(String value,String password)
  {
    if(value!=password )
      return 'PASSWORD MISSMATCH ';
    else
      return null;
  }
  static String? phnvalidator(String value)
  {
    if(value.length!=10 || num.parse(value)==null)
      return'INVALID PHONE NUMBER';
    else
      return null;
  }
  static String? pinvalidator(String value)
  {
    if(value.length!=6 || num.parse(value)==null)
      return'NUMBER MUST BE 6 DIGIT';
    else
      return null;
  }
  static String? emailValidator(String value) //Email Validation
  {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
    {
      return 'Email format is invalid';
    }
    else
    {
      return null;
    }
   }

}