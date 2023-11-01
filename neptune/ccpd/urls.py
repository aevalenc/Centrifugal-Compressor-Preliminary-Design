"""
Author: Alejandro Valencia
Update: October 29, 2023
"""

from django.urls import path
from neptune.ccpd import views

# Here we connect views to urls
urlpatterns = [
    path("", views.index, name="ccpd-index"),
    path("about/", views.about, name="ccpd-about"),
    path("run_hello/", views.run_hello_world, name="ccpd-run_hello_world"),
    path("run_main/", views.run_main, name="ccpd-run-main"),
]
