from django.contrib import admin
from .models import File


@admin.register(File)
class FileAdmin(admin.ModelAdmin):
    """
    Admin model for managing File instances in the Django admin interface.
    """
    list_display = ("id", "filename", "file","owner", "uploaded_at", "file_size")
    search_fields = ("filename",)
    list_filter = ("uploaded_at",)
