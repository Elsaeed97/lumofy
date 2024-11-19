from django.db.models import Count, F, Q
from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import action
from .serializers import CourseSerializer, LessonSerializer, StudentProgressSerializer
from ..models import Course, Lesson, StudentProgress


class CourseViewset(viewsets.ModelViewSet):
    """Viewset for Course model that will return all active courses"""

    serializer_class = CourseSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Course.objects.filter(is_active=True).order_by("-created_at")

    @action(detail=True, methods=["post"])
    def add_lesson(self, request, pk=None):
        """
        Add a lesson to a course
        Expected request data format:
        {
            "title": "Lesson Title",
            "content": "Lesson Content",
            "order": 1,
            "is_active": true
        }
        """
        course = self.get_object()
        lesson_data = request.data.copy()
        lesson_data["course"] = course.id

        serializer = LessonSerializer(data=lesson_data)
        if serializer.is_valid():
            lesson = serializer.save()
            return Response(
                {"message": "Lesson added successfully", "lesson": serializer.data},
                status=status.HTTP_201_CREATED,
            )
        return Response(
            {"error": serializer.errors}, status=status.HTTP_400_BAD_REQUEST
        )

    @action(detail=True, methods=["delete"])
    def remove_lesson(self, request, pk=None):
        """
        Remove a lesson from a course
        Expected URL parameter: ?lesson_id=<id>
        """
        course = self.get_object()
        lesson_id = request.query_params.get("lesson_id")

        if not lesson_id:
            return Response(
                {"error": "lesson_id is required"}, status=status.HTTP_400_BAD_REQUEST
            )

        try:
            lesson = course.lessons.get(id=lesson_id)
            lesson.delete()
            return Response(
                {"message": "Lesson removed successfully", "lesson_id": lesson_id},
                status=status.HTTP_200_OK,
            )
        except Lesson.DoesNotExist:
            return Response(
                {"error": "Lesson not found"}, status=status.HTTP_404_NOT_FOUND
            )


class StudentProgressViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for tracking student progress"""
    serializer_class = StudentProgressSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return StudentProgress.objects.filter(student=self.request.user)

    def list(self, request):
        """Get overall progress for all courses"""
        progress = (
            StudentProgress.objects.filter(student=request.user)
            .values('lesson__course')
            .annotate(
                course_title=F('lesson__course__title'),
                total_lessons=Count('lesson__course__lessons'),
                completed_lessons=Count('lesson', filter=Q(completed=True))
            )
        )

        return Response({
            'courses_progress': [
                {
                    'course_id': item['lesson__course'],
                    'course_title': item['course_title'],
                    'total_lessons': item['total_lessons'],
                    'completed_lessons': item['completed_lessons'],
                    'progress_percentage': round(
                        (item['completed_lessons'] / item['total_lessons']) * 100 
                        if item['total_lessons'] > 0 else 0,
                        2
                    )
                }
                for item in progress
            ]
        })

    @action(detail=False, methods=['get'])
    def course_progress(self, request):
        """Get detailed progress for a specific course"""
        course_id = request.query_params.get('course_id')
        if not course_id:
            return Response(
                {'error': 'course_id is required'}, 
                status=status.HTTP_400_BAD_REQUEST
            )

        progress = (
            StudentProgress.objects.filter(
                student=request.user,
                lesson__course_id=course_id
            )
            .select_related('lesson')
            .order_by('lesson__order')
        )

        return Response({
            'course_id': course_id,
            'lessons_progress': [
                {
                    'lesson_id': prog.lesson.id,
                    'lesson_title': prog.lesson.title,
                    'completed': prog.completed,
                    'completed_at': prog.completed_at
                }
                for prog in progress
            ]
        })