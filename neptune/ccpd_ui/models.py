from django.db import models
from ccpd.data_types.centrifugal_compressor import CentrifugalCompressor


# Create your models here.
class NeptuneCentrifugalCompressor(models.Model, CentrifugalCompressor):
    """
    Neptune model class to hold centrifugal compressor designs
    """

    pass
