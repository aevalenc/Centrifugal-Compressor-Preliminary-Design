"""
Create your views here.
"""
from django.shortcuts import render
from django.http import HttpResponse


def index(request):
    """
    pass a request to the index
    """
    return HttpResponse("Hello, world. Welcome to project neptune: the hub of ccpd.")
