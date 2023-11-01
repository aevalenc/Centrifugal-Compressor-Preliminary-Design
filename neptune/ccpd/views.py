"""
Create your views here.
"""
from django.shortcuts import render
from django.http import HttpResponse


def index(request) -> HttpResponse:
    """
    pass a request to the index
    """
    return render(request, "ccpd/home.html")


def about(request) -> HttpResponse:
    return render(request, "ccpd/about.html")
