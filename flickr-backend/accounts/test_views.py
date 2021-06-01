# from .test_setup import TestSetUp
# from ..models import Account
from accounts.views import *
from django.test import TestCase
from accounts.models import Account
from accounts.serializers import *
from project.utils import validate_password

class TestModels(TestCase):

#testing sign_up         
    def test_signup_full_assignment(self):
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'mohammed99kamel@gmail.com'
        
        #Turning to dictionary
        for variable in ["email", "first_name", "last_name","age",'password']:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors,{})
    
    def test_signup_missing_email_field(self):
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        
        #Turning to dictionary
        for variable in ["first_name", "last_name","age",'password']:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors['email'][0], 'This field is required.')
    
    def test_signup_missing_first_name_field(self):
        #preparing test data
        test_data={}
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        
        #Turning to dictionary
        for variable in ["email", "last_name","age",'password']:
            test_data[variable] = eval(variable)
            
        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors['first_name'][0], 'This field is required.')
        
    def test_signup_missing_last_name_field(self):
        #preparing test data
        test_data={}
        first_name = 'test1'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        
        #Turning to dictionary
        for variable in ["email", "first_name","age",'password']:
            test_data[variable] = eval(variable)
            
        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors['last_name'][0], 'This field is required.')
    
    def test_signup_missing_password_field(self):
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        email = 'test@gmail.com'
        
        #Turning to dictionary
        for variable in ["email", "first_name", "last_name","age"]:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors['password'][0], 'This field is required.')

    def test_signup_email_already_exist(self):
        #prepare already exist user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        
        #Turning to dictionary
        for variable in ["email", "first_name", "last_name","age",'password']:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors['email'][0], 'account with this email already exists.')
    def test_signup_entering_short_password(self):
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel'
        email = 'test@gmail.com'
        
        #Turning to dictionary
        for variable in ["email", "first_name", "last_name","age",'password']:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors['password'][0], 'Ensure this field has at least 12 characters.')
        
    def test_signup_entering_long_password(self):
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamelllllllllllllllllllllllllllllllllllll'
        email = 'test@gmail.com'
        
        #Turning to dictionary
        for variable in ["email", "first_name", "last_name","age",'password']:
            test_data[variable] = eval(variable)
            
        #Sending data to serializer to test serializer
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        
        self.assertEqual(serializer.errors['password'][0], 'Ensure this field has no more than 16 characters.')
        
    def test_signup_validating_password_correct(self):
        #test password
        password = 'Kamel1234567'
        
        #testing validate password function
        result,error = validate_password(password)
        
        self.assertEqual(error, '')
    
    def test_signup_validating_password_uppercase(self):
        #test password
        password = 'kamel1234567'
        
        #testing validate password function
        result,error = validate_password(password)
        self.assertEqual(error, 'password must contain at least one uppercase character')
        
    def test_signup_validating_password_lowercase(self):
        #test password
        password = 'KAMEL1234567'
        
        #testing validate password function
        result,error = validate_password(password)
        self.assertEqual(error, 'password must contain at least one lowercase character')
    
    def test_signup_validating_password_lowercase(self):
        #test password
        password = 'Kamelalimohammed'
        
        #testing validate password function
        result,error = validate_password(password)
        self.assertEqual(error, 'password must contain at least one number')
    
    def test_signup_validating_password_in_username(self):
        #test password
        password = 'Kamel12345678'
        username = 'Kamel123'
        #testing validate password function
        result,error = validate_password(password,username)
        self.assertEqual(error, 'username cannot be used as part of your password')

# verifying &  reset mail
    def test_verify_user(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)
        
        #verify user
        verifying_user(user)
        
        
        self.assertEqual(user.is_verified, True)
    
    def test_verify_user_mail(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        test_host = 'www.test.com'
        test_token = 'eyJhbGciOiJIUzI1NiIsBzOi8vYXNxeIJoFK9krqaeZrPLwmMmgI_XiQiIkQ'
        expected_body = 'Hi test Use link to verify \nhttp://'+test_host+'/api/accounts/email-verify/?token='+test_token
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #prepare verify mail
        mail =prepare_verify_email(test_host, user,test_token)
        
        self.assertEqual(mail['to_email'], user.email)
        self.assertEqual(mail['email_subject'], 'Verify Your Email')
        self.assertEqual(mail['email_body'], expected_body)
    
    def test_reset_password_mail(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        test_host = 'www.test.com'
        test_token = 'eyJhbGciOiJIUzI1NiIsBzOi8vYXNxeIJoFK9krqaeZrPLwmMmgI_XiQiIkQ'
        test_uidb64= 'Mq'
        expected_body = 'Hello,\n Use link below to reset your password  \nhttp://'+test_host+'/api/accounts/password-reset/'+test_uidb64+'/'+test_token+'/'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)
        
        #prepare verify mail
        mail =prepare_reset_password_email(test_host, user,test_token,test_uidb64)
        
        self.assertEqual(mail['to_email'], user.email)
        self.assertEqual(mail['email_subject'], 'Reset you password')
        self.assertEqual(mail['email_body'], expected_body)

    def test_email_reset_exist(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)

        #check if mail really exist
        test_mail = 'test@gmail.com'
        bool,error = check_account_exist_email(test_mail)
        
        self.assertEqual(bool, True)
        self.assertEqual(error, '')
    
    def test_email_reset_not_exist(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)

        #check if mail really exist
        test_mail = 'test2@gmail.com'
        bool,error = check_account_exist_email(test_mail)
        
        self.assertEqual(bool, False)
        self.assertEqual(error, 'Email doesnt exist. Kindly recheck entered email')

#testing login
    def test_login_correct(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #login
        test_data={}
        email = 'test@gmail.com'
        password = 'Kamel1234567'
        
        #Turning to dictionary
        for variable in ["email",'password']:
            test_data[variable] = eval(variable)

        #verify user
        verifying_user(user)

        #Sending data to serializer to test serializer
        serializer = LogInSerializer(data = test_data)
        serializer.is_valid()
        self.assertEqual(serializer.errors, {})
    
    def test_login_incorrect(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #login
        test_data={}
        email = 'test@gmail.com'
        password = 'Kamel12346578'
        
        #Turning to dictionary
        for variable in ["email",'password']:
            test_data[variable] = eval(variable)

        #verify user
        verifying_user(user)

        #Sending data to serializer to test serializer
        try:
            serializer = LogInSerializer(data = test_data)
            serializer.is_valid()
        except Exception as e:
            error = str(e)
        
        self.assertEqual(error , 'Invalid email or password.')
        
    def test_login_not_verified(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #login
        test_data={}
        email = 'test@gmail.com'
        password = 'Kamel1234567'
        
        #Turning to dictionary
        for variable in ["email",'password']:
            test_data[variable] = eval(variable)


        #Sending data to serializer to test serializer
        try:
            serializer = LogInSerializer(data = test_data)
            serializer.is_valid()
        except Exception as e:
            error = str(e)
        self.assertEqual(error , 'Email is not verified')

#deleting user
    def test_user_deletion(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.filter(email = email)

        #deleting user
        delete_user(user)
        
        #checking deleted user
        user=Account.objects.filter(email = email)

        self.assertEqual(user.exists(), False)

#changind & getting user type
    def test_user_check_pro(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #get type
        bool = check_pro(user)
        
        self.assertEqual(bool , False)
        
    def test_user_change_to_pro(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #change to pro
        change_to_pro(user)
        
        #get type
        bool = check_pro(user)
        
        self.assertEqual(bool , True)
        
    def test_user_change_to_normal(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #change to pro
        change_to_pro(user)
        
        #change to normal
        change_to_normal(user)
        
        #get type
        bool = check_pro(user)
        
        self.assertEqual(bool , False)

#changing user password
    def test_user_change_password_correct(self):
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)
        
        old_password = 'Kamel1234567'
        new_password = 'Kamel1234568'
        
        #Turning to dictionary
        for variable in ['old_password', "new_password"]:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = ChangePasswordSerializer(data = test_data)
        serializer.is_valid()

        _, _ = change_user_password(serializer, user)
        user = auth.authenticate(email=email, password=new_password)
        bool = user == None
        self.assertEqual(bool, False)
        
    def test_user_change_password_fail_1(self):
        #old password is wrong
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)
        
        old_password = 'Kamel1234568'
        new_password = 'Kamel1234568'
        
        #Turning to dictionary
        for variable in ['old_password', "new_password"]:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = ChangePasswordSerializer(data = test_data)
        serializer.is_valid()

        response, status = change_user_password(serializer, user)

        # bool = user == None
        self.assertEqual(response['old_password'][0], 'Wrong password.')
        
    def test_user_change_password_fail_2(self):
        #old password can not be equal to new password
        #preparing test data
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)
        
        old_password = 'Kamel1234567'
        new_password = 'Kamel1234567'
        
        #Turning to dictionary
        for variable in ['old_password', "new_password"]:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = ChangePasswordSerializer(data = test_data)
        serializer.is_valid()
        try:
            response, status = change_user_password(serializer, user)
        except Exception as e:
            error = e
        err_message = error.args[0]

        self.assertEqual(err_message, 'New password cannot be same as old one!')

#change username
    def test_validating_username_correct(self):
        #test username
        username = 'Kamel123'
        
        #testing validate password function
        result,error = validate_username(username)
        self.assertEqual(error, '')
    
    def test_validating_username_no_number(self):
        #test username
        username = 'Kamelkamel'
        
        #testing validate password function
        result,error = validate_username(username)
        self.assertEqual(error, 'username must contain at least one number')
       
    
    def test_validating_username_short(self):
        #test username
        username = 'Kl123'
        
        #testing validate password function
        result,error = validate_username(username)
        self.assertEqual(error, 'username must be greater than or equal to 6 characters')
        
    def test_validating_username_long(self):
        #test username
        username = 'Kamell123456789012'
        
        #testing validate password function
        result,error = validate_username(username)
        self.assertEqual(error, 'username must be less than or equal to 16 characters')
    
    def test_username_change(self):
        #prepare user
        first_name = 'test2'
        last_name = 'name'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        Account.objects.create_user(email,first_name,last_name,age,password)
        user=Account.objects.get(email = email)

        #inpus
        test_data={}
        
        username = 'Kamel123'
        
        #Turning to dictionary
        for variable in ["username",'password']:
            test_data[variable] = eval(variable)

        #Sending data to serializer to test serializer
        serializer = ChangeUsernameSerializer(data = test_data)
        serializer.is_valid()
        response = change_user_name(serializer,user)
        self.assertEqual(response['Success'], 'Username changed')
        
    






