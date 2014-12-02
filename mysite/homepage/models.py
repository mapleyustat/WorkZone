from django.db import models


class ThoughtForTheDay(models.Model):
    thought_text = models.CharField(max_length=255)
    posted_date = models.DateTimeField('date posted')


class ThoughtOpinion(models.Model):
    thought_text = models.ForeignKey(ThoughtForTheDay)
    up_votes = models.IntegerField(default=0)
    down_votes = models.IntegerField(default=0)