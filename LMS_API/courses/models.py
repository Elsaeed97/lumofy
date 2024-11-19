from django.db import models
from django.utils.translation import gettext_lazy as _
from django.contrib.auth import get_user_model

User = get_user_model()


class Course(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    teacher = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        ordering = ["-created_at"]
        verbose_name = _("Course")
        verbose_name_plural = _("Courses")

    def __str__(self):
        return self.title


class Lesson(models.Model):
    course = models.ForeignKey(Course, related_name="lessons", on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    content = models.TextField()
    order = models.PositiveIntegerField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        ordering = ["order"]
        verbose_name = _("Lesson")
        verbose_name_plural = _("Lessons")
        unique_together = ["course", "order"]

    def __str__(self):
        return f"{self.course.title} - {self.title}"


class StudentProgress(models.Model):
    # we will assume that the user is a student but in other case we can use a ForeignKey to a Student model
    student = models.ForeignKey(User, on_delete=models.CASCADE)
    lesson = models.ForeignKey(Lesson, on_delete=models.CASCADE)
    completed = models.BooleanField(default=False)
    completed_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = ["student", "lesson"]
        verbose_name = _("Student Progress")
        verbose_name_plural = _("Student Progress")

    def __str__(self):
        return f"{self.student.username} - {self.lesson.title}"
