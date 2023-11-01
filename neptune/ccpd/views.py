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


def about(request):
    return HttpResponse(
        """
        ccpd is a application to generate a preliminary design of a centrifugal compressor.\n
        The user can input certain design parameters to obtain a desired design
        """
    )
