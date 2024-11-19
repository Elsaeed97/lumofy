from django.core.exceptions import ValidationError
from django.db import models
from django.contrib.auth import get_user_model


User = get_user_model()


class File(models.Model):
    """
    Model representing an uploaded file.

    Attributes:
        owner (ForeignKey): Reference to the user who uploaded the file.
        file (FileField): The uploaded file.
        filename (CharField): The name of the uploaded file.
        file_type (CharField): The type of the uploaded file.
        file_size (IntegerField): The size of the uploaded file in bytes.
        uploaded_at (DateTimeField): The timestamp when the file was uploaded.
    """

    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    file = models.FileField(upload_to="uploads/")
    filename = models.CharField(max_length=255)
    file_type = models.CharField(max_length=100)
    file_size = models.IntegerField()
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        if self.file_size > 10 * 1024 * 1024:  # 10MB in bytes
            raise ValidationError("File size cannot exceed 10MB")
        super().save(*args, **kwargs)

    def __str__(self):
        return self.filename
