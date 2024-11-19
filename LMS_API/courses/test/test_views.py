from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from courses.models import Course, Lesson

User = get_user_model()


class CourseViewSetTests(APITestCase):
    def setUp(self):
        # Create test user
        self.user = User.objects.create_user(
            username="testuser", email="test@example.com", password="testpass123"
        )

        # Authenticate the test client
        self.client.force_authenticate(user=self.user)

        # Create test course
        self.course = Course.objects.create(
            title="Test Course", description="Test Description", teacher="Test Teacher"
        )

        # Create test lesson
        self.lesson = Lesson.objects.create(
            course=self.course, title="Test Lesson", content="Test Content", order=1
        )

    def test_unauthorized_access(self):
        """Test that unauthorized users cannot access protected endpoints"""
        # Remove authentication
        self.client.force_authenticate(user=None)

        # Test add lesson
        url = reverse("course-add-lesson", kwargs={"pk": self.course.pk})
        response = self.client.post(url, {}, format="json")
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

        # Test remove lesson
        url = reverse("course-remove-lesson", kwargs={"pk": self.course.pk})
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_add_lesson(self):
        url = reverse("course-add-lesson", kwargs={"pk": self.course.pk})

        data = {"title": "New Lesson", "content": "New Content", "order": 2}

        response = self.client.post(url, data, format="json")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        self.assertTrue(
            Lesson.objects.filter(course=self.course, title="New Lesson").exists()
        )

    def test_add_lesson_invalid_data(self):
        url = reverse("course-add-lesson", kwargs={"pk": self.course.pk})

        # Missing required fields
        data = {"title": "New Lesson"}

        response = self.client.post(url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_remove_lesson(self):
        url = reverse("course-remove-lesson", kwargs={"pk": self.course.pk})
        url = f"{url}?lesson_id={self.lesson.id}"

        response = self.client.delete(url)

        # Check response status
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Check that lesson was deleted
        self.assertFalse(Lesson.objects.filter(id=self.lesson.id).exists())

    def test_remove_lesson_not_found(self):
        url = reverse("course-remove-lesson", kwargs={"pk": self.course.pk})
        url = f"{url}?lesson_id=999"  # Non-existent lesson ID

        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_remove_lesson_missing_id(self):
        url = reverse("course-remove-lesson", kwargs={"pk": self.course.pk})

        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def tearDown(self):
        # Clean up created objects
        User.objects.all().delete()
        Course.objects.all().delete()
        Lesson.objects.all().delete()
