from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Customer, Appointment, Salon, Payment
import json



from django.views.decorators.csrf import csrf_exempt


import pyotp
from django.core.mail import send_mail

from django.contrib.auth import login, authenticate

from django.http import JsonResponse
from two_factor.views import LoginView
import base64
from django_otp.plugins.otp_totp.models import TOTPDevice
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse
from django.contrib.auth import authenticate, login
from django.views.decorators.csrf import csrf_exempt
import json
import base64
import pyotp
from django.core.mail import send_mail
from django.conf import settings


otp_storage = {}

@csrf_exempt
def signup(request):
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))
        username = data.get('username')
        password = data.get('password')
        email = data.get('email', '')  # Email is optional
        account_type = data.get('account_type')

        if not username or not password:
            return JsonResponse({'error': 'Username and password are required'}, status=400)

        if User.objects.filter(username=username).exists():
            return JsonResponse({'error': 'Username already taken'}, status=400)

        # # Create new user
        user = User.objects.create_user(username=username, password=password, email=email)
        user.save()

        # Create TOTP device for 2FA
        totp_device = TOTPDevice.objects.create(user=user)

        # Encode the binary secret to base32
        otp_secret = base64.b32encode(totp_device.bin_key).decode('utf-8')  # Base32 encode

        # Create TOTP object using pyotp
        totp = pyotp.TOTP(otp_secret)
        otp = totp.now()  # Generate the current OTP

        # Store the generated OTP in the temporary storage
        otp_storage[username] = otp

        # Print OTP to output (for testing purposes)
        print(f"Generated OTP for {user.username}: {otp}")

        # Send OTP via email
        if email:
            subject = 'Your OTP for Account Verification'
            message = f'Hello {username},\n\nYour OTP for account verification is: {otp}\n\nPlease use this OTP to verify your account.'
            from_email = 'barbartimeapp@gmail.com'  # Replace with your "from" email
            recipient_list = [email]
            send_mail(subject, message, from_email, recipient_list)


        # Return response
        response_data = {
            'message': 'User created successfully. OTP sent to your email.',
            'otp': otp  # For testing only; in production, don't return the OTP in response
        }

        # Handle account type
        if account_type == 'customer':
            customer = Customer.objects.create(
                user=user,
                name=username,
                email=email
            )
            customer.save()
        elif account_type == 'salon':
            # Collect salon-related data
            full_name = data.get('full_name')
            salon_name = data.get('salon_name')
            city = data.get('city')
            country = data.get('country')
            location = data.get('location')
            phone_number = data.get('phone_number')

            # Create the Salon instance
            salon = Salon.objects.create(
                user=user,  # Link salon with the user
                full_name=full_name,
                salon_name=salon_name,
                city=city,
                country=country,
                location=location,
                phone_number=phone_number
            )
            salon.save()
        else:
            return JsonResponse({'error': 'Invalid account type'}, status=400)

        return JsonResponse(response_data, status=201)

    return JsonResponse({'error': 'Only POST method is allowed'}, status=405)

@csrf_exempt
def custom_login(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data.get('username')
        password = data.get('password')

        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)

           

            return JsonResponse({'message': 'Logged in successfully'}, status=200)

        return JsonResponse({'error': 'Invalid credentials'}, status=400)

    return JsonResponse({'error': 'Method not allowed'}, status=405)

@csrf_exempt
def verify_2fa(request):
    if request.method == 'POST':
        data = json.loads(request.body)  # Get data from the request body
        otp_token = data.get('otp_token')  # Get the OTP token from the request
        username = data.get('username')  # Include the username to identify the user

        try:
            # Check if OTP was generated for the username
            if username in otp_storage:
                expected_otp = otp_storage[username]  # Retrieve the OTP from storage
                # Validate the received OTP
                print(f"Received otp_token: {otp_token}, username: {username}, creat {expected_otp}")
                if otp_token == expected_otp:
                    del otp_storage[username]  # Clear the stored OTP after verification
                    return JsonResponse({'success': True}, status=200)
                else:
                    return JsonResponse({'error': 'Invalid OTP'}, status=400)
            else:
                return JsonResponse({'error': 'No OTP found for this username'}, status=404)

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)




@csrf_exempt
def list_customers(request):
    if request.method == 'GET':
        customers = Customer.objects.all()
        data = [{'id': customer.id, 'name': customer.name, 'email': customer.email} for customer in customers]
        return JsonResponse(data, safe=False)
    return JsonResponse({'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_customer(request, id):
    if request.method == 'GET':
        try:
            customer = Customer.objects.get(id=id)
            data = {
                'id': customer.id,
                'name': customer.name,
                'email': customer.email
            }
            return JsonResponse(data)
        except Customer.DoesNotExist:
            return JsonResponse({'error': 'Customer not found'}, status=404)
    return JsonResponse({'error': 'Method not allowed'}, status=405)


def list_appointments(request):
    if request.method == 'GET':
        appointments = Appointment.objects.all()  # Get all appointments
        data = [
            {
                'id': appointment.id,
                'customer': appointment.customer.name,
                'appointment_time': appointment.appointment_time
            }
            for appointment in appointments
        ]
        return JsonResponse(data, safe=False)  # Return the list of appointments
    return JsonResponse({'error': 'Method not allowed'}, status=405)


@csrf_exempt
def create_appointment(request):
    if request.method == 'POST':
        try:
            body = json.loads(request.body)
            customer = Customer.objects.get(id=body['customer_id'])
            appointment = Appointment.objects.create(
                customer=customer,
                appointment_time=body['appointment_time']
            )
            return JsonResponse({'id': appointment.id, 'customer': customer.id}, status=201)
        except Customer.DoesNotExist:
            return JsonResponse({'error': 'Customer not found'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON data'}, status=400)
    return JsonResponse({'error': 'Method not allowed'}, status=405)

@csrf_exempt
def get_appointments(request):
    if request.method == 'GET':
        appointments = Appointment.objects.all()
        data = [
            {
                'id': appointment.id,
                'customer': appointment.customer.name,
                'appointment_time': appointment.appointment_time
            }
            for appointment in appointments
        ]
        return JsonResponse(data, safe=False)
    return JsonResponse({'error': 'Method not allowed'}, status=405)

@csrf_exempt
def list_payments(request):
    if request.method == 'GET':
        payments = Payment.objects.all()
        data = [
            {
                'id': payment.id,
                'customer': payment.customer.name,
                'amount': payment.amount,
                'date': payment.date.isoformat()  # Formatting date to ISO 8601 string
            }
            for payment in payments
        ]
        return JsonResponse(data, safe=False)
    return JsonResponse({'error': 'Method not allowed'}, status=405)

@csrf_exempt
def create_payment(request):
    if request.method == 'POST':
        try:
            body = json.loads(request.body)
            customer = Customer.objects.get(id=body['customer_id'])
            payment = Payment.objects.create(
                customer=customer,
                amount=body['amount']
            )
            return JsonResponse({'id': payment.id, 'amount': payment.amount}, status=201)
        except Customer.DoesNotExist:
            return JsonResponse({'error': 'Customer not found'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON data'}, status=400)
    return JsonResponse({'error': 'Method not allowed'}, status=405)


@csrf_exempt
def list_salon(request):
    if request.method == 'GET':
        salons = Salon.objects.all()
        data = []
        for salon in salons:
            # Assuming that the Salon model has a foreign key to User or similar
            salon_data = {
                'id': salon.id,
                'full_name': salon.full_name,  # Change this line
                'city': salon.city,  # Assuming you have added a city field to the Salon model
                'country': salon.country,  # Assuming you have added a country field to the Salon model
                'location': salon.location,  # Assuming you have added a location field to the Salon model
                'phone_number': salon.phone_number  # Assuming you have added a phone_number field to the Salon model
            }
            data.append(salon_data)
        return JsonResponse(data, safe=False)
    return JsonResponse({'error': 'Method not allowed'}, status=405)


from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from .models import Salon, Haircut

def salon_profile(request, username):
    salon = get_object_or_404(Salon, user__username=username)  # Fetch salon by username
    haircuts = Haircut.objects.filter(salon=salon)  # Fetch haircuts for the salon
    haircut_list = []
    
    for haircut in haircuts:
        haircut_list.append({
            'name': haircut.name,
            'image': haircut.image,
            'price': str(haircut.price),  # Convert to string for JSON serialization
            'duration': haircut.duration,
        })

    salon_data = {
        'full_name': salon.full_name,
        'salon_name': salon.salon_name,
        'city': salon.city,
        'country': salon.country,
        'location': salon.location,
        'phone_number': salon.phone_number,
        'haircuts': haircut_list,  # Add haircuts to the response
    }
    return JsonResponse(salon_data)





from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
import json
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from .models import Salon, Haircut

@csrf_exempt
def get_haircut(request, username):
    if request.method == 'GET':
        # Find the salon by username
        salon = get_object_or_404(Salon, user__username=username)

        # Get haircuts associated with the salon
        haircuts = Haircut.objects.filter(salon=salon)
        
        # Prepare response data
        haircut_data = [
            {
                'name': haircut.name,
                'image': haircut.image,
                'price': haircut.price,
                'duration': haircut.duration,
            } for haircut in haircuts
        ]

        return JsonResponse({'haircuts': haircut_data}, status=200)

    return JsonResponse({'error': 'Invalid request method'}, status=400)

@csrf_exempt
def add_haircut(request, username):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            price = data.get('price')
            duration = data.get('duration')
            image = data.get('image')  # Assuming the image name is sent in the request body
            name = data.get('name')  # Haircut name

            # Debugging output
            print(f"Data received: {data}")

            # Find the salon by username
            salon = get_object_or_404(Salon, user__username=username)  # Fetch salon by username

            # Create a new haircut for the salon
            haircut = Haircut.objects.create(
                salon=salon,
                name=name,
                image=image,
                price=price,
                duration=duration
            )

            return JsonResponse({'message': 'Haircut added successfully'}, status=200)
        except Exception as e:
            print(f"Error: {e}")
            return JsonResponse({'error': 'Failed to add haircut'}, status=400)
    
    return JsonResponse({'error': 'Invalid request method'}, status=400)


