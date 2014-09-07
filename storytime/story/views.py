from django.shortcuts import render_to_response
from .models import Line

def home(request):
    return render_to_response("story/home.html", {'lines' : Line.objects.all()})

