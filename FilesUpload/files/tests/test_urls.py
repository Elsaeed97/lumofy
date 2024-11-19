# tests/test_urls.py
from django.test import SimpleTestCase
from django.urls import reverse, resolve
from files.api.views import FileListView, FileDetailView, FileUploadView


class TestUrls(SimpleTestCase):
    def test_list_url_resolves(self):
        """Test that the file-list URL resolves correctly"""
        url = reverse("file-list")
        self.assertEqual(resolve(url).func.view_class, FileListView)
        self.assertEqual(url, "/files/")

    def test_detail_url_resolves(self):
        """Test that the file-detail URL resolves correctly"""
        url = reverse("file-detail", args=[1])  # Test with ID 1
        self.assertEqual(resolve(url).func.view_class, FileDetailView)
        self.assertEqual(url, "/files/1/")

    def test_upload_url_resolves(self):
        """Test that the file-upload URL resolves correctly"""
        url = reverse("file-upload")
        self.assertEqual(resolve(url).func.view_class, FileUploadView)
        self.assertEqual(url, "/files/upload/")