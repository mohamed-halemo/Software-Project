# from .test_setup import TestSetUp
# from ..models import Account
from django.test import TestCase
from accounts.models import Account
from accounts.serializers import *


class TestModels(TestCase):
#testing sign_up 
    # def test_user_model_full_assignment(self):
    #     test_first = 'test1'
    #     test_last = 'last'
    #     test_age = '50'
    #     test_email = 'test@gmail.com'
    #     testuser = Account.objects.create_user(test_email,test_first,test_last,test_age)
    #     # testuser.email = 'test_user@test.com'
    #     # testuser.save()
    #     query1 = Account.objects.get(email =test_email)
    #     query2 = Account.objects.get(username =test_email.split('@')[0])
    #     query3 = Account.objects.get(age =test_age)
    #     query4 = Account.objects.get(first_name =test_first)
    #     query5 = Account.objects.get(last_name =test_last)
        
        
    #     self.assertEqual(query1,testuser)
    #     self.assertEqual(query2,testuser)
    #     self.assertEqual(query3,testuser)
    #     self.assertEqual(query4,testuser)
    #     self.assertEqual(query5,testuser)
    
    # def test_user_model_email_assignment(self):
    #     testuser = Account.objects.create()
    #     testuser.email = 'test@gmail.com'
    #     testuser.save()
    #     test_email = testuser.email
    #     query1 = Account.objects.get(email =test_email)
    #     self.assertEqual(query1,testuser)
        
    def test_user_model_full_assignment(self):
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        for variable in ["email", "first_name", "last_name","age",'password']:
            test_data[variable] = eval(variable)
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        self.assertEqual(serializer.errors,{})
    
    def test_user_model_missing_email_field(self):
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        
        for variable in ["first_name", "last_name","age",'password']:
            test_data[variable] = eval(variable)
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        self.assertEqual(serializer.errors['email'][0], 'This field is required.')
    
    def test_user_model_missing_first_name_field(self):
        test_data={}
        last_name = 'last'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        for variable in ["email", "last_name","age",'password']:
            test_data[variable] = eval(variable)
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        self.assertEqual(serializer.errors['first_name'][0], 'This field is required.')
        
    def test_user_model_missing_last_name_field(self):
        test_data={}
        first_name = 'test1'
        age = '50'
        password = 'Kamel1234567'
        email = 'test@gmail.com'
        for variable in ["email", "first_name","age",'password']:
            test_data[variable] = eval(variable)
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        self.assertEqual(serializer.errors['last_name'][0], 'This field is required.')
    
    def test_user_model_missing_password_field(self):
        test_data={}
        first_name = 'test1'
        last_name = 'last'
        age = '50'
        email = 'test@gmail.com'
        for variable in ["email", "first_name", "last_name","age"]:
            test_data[variable] = eval(variable)
        serializer = SignUpSerializer(data = test_data)
        serializer.is_valid()
        self.assertEqual(serializer.errors['password'][0], 'This field is required.')
    
    # def test_user_model_mail_assignment(self):
    #     testuser = Account.objects.create_user()
    #     testuser.email = 'test_user@test.com'
    #     print(testuser.email,'DDDDDDD')
    #     testuser.save()
    #     query = Account.objects.get(username ='test_user')
    #     self.assertEqual(query,testuser)














# class TestViews(TestSetUp):

#     def test_user_cannot_register_with_no_data(self):
#         res = self.client.post(self.register_url)
#         self.assertEqual(res.status_code, 400)

#     def test_user_can_register(self):
#         res = self.client.post(self.register_url, self.user_data,
#                                format='json')
#         self.assertEqual(res.status_code, 201)

#     def test_logged_verified(self):
#         """Test to see if the user can log if not verified"""
#         self.client.post(self.register_url, self.user_data,
#                          format='json')
#         res = self.client.post(self.login_url, self.user_data, format="json")
#         self.assertEqual(res.status_code, 401)

#     def test_logged_after_verified(self):
#         """Test to see if the user can log if  verified"""
#         response = self.client.post(self.register_url, self.user_data,
#                                     format='json')

#         email = response.data['email']
#         user = Account.objects.get(email=email)
#         user.is_verified = True
#         user.save()
#         res = self.client.post(self.login_url, self.user_data, format="json")
#         self.assertEqual(res.status_code, 200)

#     def test_get_user_profile(self):
#         """Test email verification"""
#         response = self.client.post(self.register_url, self.user_data,
#                                     format='json')
#         email = response.data['email']
#         user = Account.objects.get(email=email)
#         user.is_verified = True
#         user.save()
#         response1 = self.client.post(self.login_url, self.user_data, format="json")
#         tokens = response1.data['tokens']['access'][0]
#         acces_token = tokens[1]
#         import pdb
#         pdb.set_trace()
