# serializers.py
from rest_framework import serializers
from ..models import Course, Lesson, StudentProgress


class CourseLessonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Lesson
        fields = (
            "id",
            "title",
            "content",
            "order",
            "created_at",
            "updated_at",
            "is_active",
        )


class CourseSerializer(serializers.ModelSerializer):
    lessons = CourseLessonSerializer(many=True, read_only=True)
    number_of_lessons = serializers.SerializerMethodField()
    
    class Meta:
        model = Course
        fields = (
            "id",
            "title",
            "description",
            "teacher",
            "created_at",
            "updated_at",
            "is_active",
            "lessons",
            "number_of_lessons"
        )
        
    def get_number_of_lessons(self, obj):
        return obj.lessons.count()


class LessonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Lesson
        fields = (
            "id",
            "course",
            "title",
            "content",
            "order",
            "created_at",
            "updated_at",
            "is_active",
        )

    def validate_order(self, value):
        """Validate that the order is unique within the course"""
        course_id = self.initial_data.get("course")
        lesson_id = self.instance.id if self.instance else None

        if (
            Lesson.objects.filter(course_id=course_id, order=value)
            .exclude(id=lesson_id)
            .exists()
        ):
            raise serializers.ValidationError(
                "A lesson with this order already exists in the course"
            )
        return value


class StudentProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudentProgress
        fields = (
            "id",
            "student",
            "lesson",
            "completed",
            "completed_at",
        )
