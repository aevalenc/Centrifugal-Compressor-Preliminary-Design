"""
Create your views here.
"""
from django.shortcuts import render
from django.http import HttpResponse, HttpRequest
from ccpd_dev import main

fluids = [
    {
        "name": "air",
        "specific_heat": 1006.0,
        "specific_ratio": 1.4,
        "specific_gas_constant": 287.0,
        "kinematic_viscosity": 18.13e-6,
    },
    {
        "name": "hydrogen",
        "specific_heat": 14310.0,
        "specific_ratio": 1.41,
        "specific_gas_constant": 4120.0,
        "kinematic_viscosity": 0.88e-5,
    },
]

context = {"fluids": fluids}


def index(request: HttpRequest) -> HttpResponse:
    """
    pass a request to the index(home page)
    """
    return render(request, "ccpd/home.html", context)


def about(request: HttpRequest) -> HttpResponse:
    return render(request, template_name="ccpd/about.html", context={"title": "About"})


def run_hello_world(request: HttpRequest) -> HttpResponse:
    print("hello world")
    return render(request, "ccpd/home.html", context)


def run_main(request: HttpRequest) -> HttpResponse:
    main.main("Preliminary", [])
    return render(request, "ccpd/home.html", context)
