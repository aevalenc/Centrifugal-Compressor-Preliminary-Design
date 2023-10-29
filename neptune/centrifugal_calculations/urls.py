"""
Author: Alejandro Valencia
Update: October 29, 2023
"""

from django.urls import path
from . import views

# Here we connect views to urls
urlpatterns = [
    path("", views.index, name="index"),
]
