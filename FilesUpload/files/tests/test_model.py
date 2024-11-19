from django.test import TestCase
from django.core.exceptions import ValidationError
from django.core.files.uploadedfile import SimpleUploadedFile
from django.contrib.auth import get_user_model
from ..models import File
from datetime import datetime


class FileModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        # Create a test user
        User = get_user_model()
        cls.user = User.objects.create_user(
            username="testuser", email="test@example.com", password="testpass123"
        )

    def setUp(self):
        # Create a test file for each test
        self.test_file_content = b"test content"
        self.test_file = SimpleUploadedFile(
            name="test.txt", content=self.test_file_content, content_type="text/plain"
        )

        self.file = File.objects.create(
            owner=self.user,
            file=self.test_file,
            filename="test.txt",
            file_type=".txt",
            file_size=len(self.test_file_content),
        )

    def test_file_creation(self):
        """Test that a file can be created with valid data"""
        self.assertEqual(self.file.filename, "test.txt")
        self.assertEqual(self.file.file_type, ".txt")
        self.assertEqual(self.file.file_size, len(self.test_file_content))
        self.assertEqual(self.file.owner, self.user)
        self.assertIsInstance(self.file.uploaded_at, datetime)

    def test_file_string_representation(self):
        """Test the string representation of the File model"""
        self.assertEqual(str(self.file), "test.txt")

    def test_file_size_validation(self):
        """Test that files larger than 10MB are rejected"""
        large_file_content = b"x" * (10 * 1024 * 1024 + 1)  # 10MB + 1 byte
        large_file = SimpleUploadedFile(
            name="large.txt", content=large_file_content, content_type="text/plain"
        )

        with self.assertRaises(ValidationError):
            File.objects.create(
                owner=self.user,
                file=large_file,
                filename="large.txt",
                file_type=".txt",
                file_size=len(large_file_content),
            )


    def test_file_size_is_integer(self):
        """Test that file_size must be an integer"""
        with self.assertRaises(Exception):
            File.objects.create(
                owner=self.user,
                file=self.test_file,
                filename="test.txt",
                file_type=".txt",
                file_size="not an integer",
            )

    def tearDown(self):
        # Clean up uploaded files
        try:
            self.file.file.delete(
                save=False
            ) 
        except:
            pass 
