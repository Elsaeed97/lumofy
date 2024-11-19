# tests.py
from django.test import TestCase
from django.core.exceptions import ValidationError
from django.contrib.auth import get_user_model
from django.utils import timezone
from ..models import Course, Lesson, StudentProgress

User = get_user_model()


class CourseModelTest(TestCase):
    def setUp(self):
        self.course = Course.objects.create(
            title="Python Programming",
            description="Learn Python from scratch",
            teacher="Elsaeed Ahmed",
        )

    def test_course_creation(self):
        """Test if course is created correctly"""
        self.assertEqual(self.course.title, "Python Programming")
        self.assertEqual(self.course.teacher, "Elsaeed Ahmed")
        self.assertTrue(self.course.is_active)

    def test_course_str_representation(self):
        """Test the string representation of the course"""
        self.assertEqual(str(self.course), "Python Programming")

    def test_course_empty_title(self):
        """Test that course cannot be created with empty title"""
        with self.assertRaises(ValidationError):
            course = Course(
                title="", description="Test description", teacher="Jane Doe"
            )
            course.full_clean()


class LessonModelTest(TestCase):
    def setUp(self):
        self.course = Course.objects.create(
            title="Python Programming",
            description="Learn Python from scratch",
            teacher="Elsaeed Ahmed",
        )
        self.lesson = Lesson.objects.create(
            course=self.course,
            title="Introduction to Python",
            content="Basic Python concepts",
            order=1,
        )

    def test_lesson_creation(self):
        """Test if lesson is created correctly"""
        self.assertEqual(self.lesson.title, "Introduction to Python")
        self.assertEqual(self.lesson.course, self.course)
        self.assertEqual(self.lesson.order, 1)

    def test_lesson_str_representation(self):
        """Test the string representation of the lesson"""
        expected_str = "Python Programming - Introduction to Python"
        self.assertEqual(str(self.lesson), expected_str)

    def test_unique_order_per_course(self):
        """Test that lessons in the same course cannot have the same order"""
        with self.assertRaises(ValidationError):
            lesson = Lesson(
                course=self.course,
                title="Another Lesson",
                content="More content",
                order=1,
            )
            lesson.full_clean()


class StudentProgressModelTest(TestCase):
    def setUp(self):
        # Create a user
        self.user = User.objects.create_user(
            username="testuser", email="test@example.com", password="testpass123"
        )

        # Create a course
        self.course = Course.objects.create(
            title="Python Programming",
            description="Learn Python from scratch",
            teacher="John Doe",
        )

        # Create a lesson
        self.lesson = Lesson.objects.create(
            course=self.course,
            title="Introduction to Python",
            content="Basic Python concepts",
            order=1,
        )

        # Create student progress
        self.progress = StudentProgress.objects.create(
            student=self.user, lesson=self.lesson, completed=False
        )

    def test_progress_creation(self):
        """Test if student progress is created correctly"""
        self.assertEqual(self.progress.student, self.user)
        self.assertEqual(self.progress.lesson, self.lesson)
        self.assertFalse(self.progress.completed)
        self.assertIsNone(self.progress.completed_at)

    def test_unique_student_lesson_combination(self):
        """Test that a student cannot have multiple progress records for the same lesson"""
        with self.assertRaises(ValidationError):
            duplicate_progress = StudentProgress(
                student=self.user, lesson=self.lesson, completed=True
            )
            duplicate_progress.full_clean()

    def test_progress_str_representation(self):
        """Test the string representation of the progress"""
        expected_str = "testuser - Introduction to Python"
        self.assertEqual(str(self.progress), expected_str)

    def test_completion_tracking(self):
        """Test updating progress completion status"""
        self.progress.completed = True
        self.progress.completed_at = timezone.now()
        self.progress.save()

        updated_progress = StudentProgress.objects.get(id=self.progress.id)
        self.assertTrue(updated_progress.completed)
        self.assertIsNotNone(updated_progress.completed_at)
