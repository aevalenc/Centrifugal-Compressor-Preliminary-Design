"""
Create your views here.
"""
from django.shortcuts import render
from django.http import HttpResponse

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


def index(request) -> HttpResponse:
    """
    pass a request to the index(home page)
    """
    context = {"fluids": fluids}
    return render(request, "ccpd/home.html", context)


def about(request) -> HttpResponse:
    return render(request, "ccpd/about.html", {"title": "About"})
