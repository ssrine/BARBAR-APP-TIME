from django.db import models
from django.contrib.auth.models import User

class Customer(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=1)  # Assuming user with ID 1 exists
    name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100, blank=True)

    def __str__(self):
        return self.name
from django.db import models
from django.contrib.auth.models import User

class Salon(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=1)  # Assuming user with ID 1 exists
    full_name = models.CharField(max_length=255, default=1)
    salon_name = models.CharField(max_length=255, default=1)    
    city = models.CharField(max_length=100, blank=True)
    country = models.CharField(max_length=100, blank=True)
    location = models.CharField(max_length=200, blank=True)
    phone_number = models.CharField(max_length=15, blank=True)

    def __str__(self):
        return self.salon_name

class Haircut(models.Model):
    salon = models.ForeignKey(Salon, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    image = models.CharField(max_length=255,default=1)  # Assuming this is the image URL or name
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    duration = models.IntegerField(null=True, blank=True)  # Ensure this field exists

    def __str__(self):
        return self.name

class Appointment(models.Model):
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    appointment_time = models.DateTimeField()

    def __str__(self):
        return f"{self.customer.name} - {self.appointment_time}"





class Payment(models.Model):
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    date = models.DateTimeField(auto_now_add=True)
