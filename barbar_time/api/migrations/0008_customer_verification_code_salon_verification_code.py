# Generated by Django 5.0.7 on 2024-10-22 10:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0007_delete_emailverification'),
    ]

    operations = [
        migrations.AddField(
            model_name='customer',
            name='verification_code',
            field=models.CharField(blank=True, max_length=4, null=True),
        ),
        migrations.AddField(
            model_name='salon',
            name='verification_code',
            field=models.CharField(blank=True, max_length=4, null=True),
        ),
    ]
