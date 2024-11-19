from django.contrib import admin
from .models import Course, Lesson, StudentProgress


@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ("title", "teacher", "created_at", "updated_at", "is_active")
    list_filter = ("is_active", "created_at")
    search_fields = ("title", "description")
    date_hierarchy = "created_at"


@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    list_display = ("title", "course", "order", "created_at", "is_active")
    list_filter = ("course", "is_active", "created_at")
    search_fields = ("title", "content", "course__title")
    date_hierarchy = "created_at"
    ordering = ("course", "order")


@admin.register(StudentProgress)
class StudentProgressAdmin(admin.ModelAdmin):
    list_display = ("student", "lesson", "completed", "completed_at")
    list_filter = ("completed", "completed_at")
    search_fields = ("student__username", "lesson__title")
    date_hierarchy = "completed_at"
