# Generated by Django 5.0.7 on 2024-10-23 12:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0011_salon_city_salon_country_salon_haircut_duration_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='salon',
            name='name',
        ),
        migrations.AddField(
            model_name='salon',
            name='full_name',
            field=models.CharField(default=1, max_length=255),
        ),
        migrations.AddField(
            model_name='salon',
            name='salon_name',
            field=models.CharField(default=1, max_length=255),
        ),
    ]