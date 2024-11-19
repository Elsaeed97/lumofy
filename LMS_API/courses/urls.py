from courses.api.views import CourseViewset, StudentProgressViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r"courses", CourseViewset, basename="course")
router.register(r"student-progress", StudentProgressViewSet, basename="student-progress")

urlpatterns = [
    
]
urlpatterns += router.urls