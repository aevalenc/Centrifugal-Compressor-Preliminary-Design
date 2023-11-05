"""
Author: Alejandro Valencia
Update: October 29, 2023
"""

from django.urls import path
from neptune.ccpd_ui import views

# Here we connect views to urls
urlpatterns = [
    path("", views.index, name="ccpd-index"),
    path("about/", views.about, name="ccpd-about"),
    path("test/", views.test, name="ccpd-test"),
    path("Run/", views.run_main, name="ccpd-run-main"),
]
