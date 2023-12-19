"""
Create your views here.
"""
from django.shortcuts import render
from django.http import HttpResponse, HttpRequest
from ccpd.main import main as ccpd_main
import json
import logging

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

logger = logging.getLogger(__name__)


def index(request: HttpRequest) -> HttpResponse:
    """
    pass a request to the index(home page)
    """
    return render(request, "ccpd/home.html", context)


def about(request: HttpRequest) -> HttpResponse:
    return render(request, template_name="ccpd/about.html", context={"title": "About"})


def test(request: HttpRequest) -> HttpResponse:
    print(f"Request method: {request.method}")
    return render(request, "ccpd/test.html", context)


def run_main(request: HttpRequest) -> HttpResponse:
    if request.method == "POST":
        data = request.POST.dict()
        del data["csrfmiddlewaretoken"]
        with open("ccpd/neptune_inputs.json", "w") as input_file:
            logger.info("Dumping inputs")
            json.dump(data, input_file, indent=4)

        compressor = ccpd_main("Preliminary", [])
        logger.debug(f"Generated compressor: {compressor.__dict__}")
        return render(request, "ccpd/ccpd.html", {"compressor": compressor.__dict__})
    else:
        return render(request, "ccpd/ccpd.html", context)
