from django.test import TestCase
from django.urls import reverse
from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from rest_framework.test import APIClient
from rest_framework import status
from ..models import File

class FileUploadViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = get_user_model().objects.create_user(
            username='testuser',
            password='testpass123'
        )
        self.upload_url = reverse('file-upload')
        self.client.force_authenticate(user=self.user)

    def test_successful_upload(self):
        test_file = SimpleUploadedFile(
            'test.txt',
            b'test content',
            content_type='text/plain'
        )
        data = {'file': test_file}
        response = self.client.post(
            self.upload_url,
            data,
            format='multipart'
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(File.objects.filter(filename='test.txt').exists())

    def test_upload_without_file(self):
        response = self.client.post(self.upload_url, {}, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data['file'][0], 'No file was submitted.')

    def test_upload_unauthorized(self):
        self.client.force_authenticate(user=None)
        test_file = SimpleUploadedFile(
            'test.txt',
            b'test content',
            content_type='text/plain'
        )
        response = self.client.post(
            self.upload_url,
            {'file': test_file},
            format='multipart'
        )
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class FileListViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = get_user_model().objects.create_user(
            username='testuser',
            password='testpass123'
        )
        self.list_url = reverse('file-list')
        self.client.force_authenticate(user=self.user)
        
        # Create test file
        test_file = SimpleUploadedFile('test.txt', b'content')
        self.test_file = File.objects.create(
            owner=self.user,
            file=test_file,
            filename='test.txt',
            file_type='txt',
            file_size=7
        )

    def test_list_files(self):
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 1)

    def test_filter_by_type(self):
        response = self.client.get(f"{self.list_url}?type=txt")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 1)

    def test_empty_list(self):
        File.objects.all().delete()
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertEqual(response.data['detail'], 'No files found.')


class FileDetailViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = get_user_model().objects.create_user(
            username='testuser',
            password='testpass123'
        )
        self.client.force_authenticate(user=self.user)
        
        # Create test file
        test_file = SimpleUploadedFile('test.txt', b'content')
        self.test_file = File.objects.create(
            owner=self.user,
            file=test_file,
            filename='test.txt',
            file_type='txt',
            file_size=7
        )
        self.detail_url = reverse('file-detail', args=[self.test_file.id])

    def test_get_file_detail(self):
        response = self.client.get(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['filename'], 'test.txt')

    def test_file_not_found(self):
        url = reverse('file-detail', args=[99999])
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_detail_unauthorized(self):
        self.client.force_authenticate(user=None)
        response = self.client.get(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)