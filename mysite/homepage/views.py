from django.shortcuts import render

from homepage.models import ThoughtForTheDay
from homepage.models import ThoughtOpinion


def index(request):
    thought_list = list(ThoughtForTheDay.objects.all())
    thought_opinion = ThoughtOpinion.objects.all()
    context = {'thought_list': thought_list,
               'thought_opinion': thought_opinion
    }
    return render(request, 'homepage/index.html', context)
