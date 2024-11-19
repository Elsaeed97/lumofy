from django.urls import path
from files.api.views import FileUploadView, FileListView, FileDetailView

urlpatterns = [
    path('', FileListView.as_view(), name='file-list'),
    path('<int:pk>/', FileDetailView.as_view(), name='file-detail'),
    path('upload/', FileUploadView.as_view(), name='file-upload'),
]
