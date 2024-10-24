from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.signup, name='signup'),
    path('login/', views.custom_login, name='custom_login'),
    path('verify-2fa/', views.verify_2fa, name='verify_2fa'),
    path('customers/', views.list_customers, name='list_customers'),
    path('customers/<int:id>/', views.get_customer, name='get_customer'),
    path('appointments/', views.list_appointments, name='list_appointments'),
    path('appointments/create/', views.create_appointment, name='create_appointment'),
    path('payments/', views.list_payments, name='list_payments'),
    path('payments/create/', views.create_payment, name='create_payment'),
    path('salons/', views.list_salon, name='list_salon'),
    path('salon-profile/<str:username>/',  views.salon_profile, name='salon-profile'),
    path('haircut/<str:username>/', views.get_haircut, name='get_haircut'),  
    path('haircut/add/<str:username>/', views.add_haircut, name='add_haircut'),
    # path('salon/details/', views.salon_details, name='salon_details'),
    
]
