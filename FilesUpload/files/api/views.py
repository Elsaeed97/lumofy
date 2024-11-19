from rest_framework import generics, status, serializers
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from files.models import File

from .serializers import FileSerializer
from .paginations import FilesPagination


class FileUploadView(generics.CreateAPIView):
    serializer_class = FileSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        if not self.request.FILES.get("file"):
            raise serializers.ValidationError({"file": "No file provided."})
        serializer.save(owner=self.request.user)

    def create(self, request, *args, **kwargs):
        try:
            response = super().create(request, *args, **kwargs)
            return Response(response.data, status=status.HTTP_201_CREATED)
        except serializers.ValidationError as e:
            return Response(e.detail, status=status.HTTP_400_BAD_REQUEST)


class FileListView(generics.ListAPIView):
    serializer_class = FileSerializer
    permission_classes = [IsAuthenticated]
    pagination_class = FilesPagination

    def get_queryset(self):
        queryset = File.objects.all()
        # Filter by file type
        file_type = self.request.query_params.get("type", None)
        if file_type:
            queryset = queryset.filter(file_type__iexact=file_type)

        return queryset

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response(
                {"detail": "No files found."}, status=status.HTTP_404_NOT_FOUND
            )
        response = super().list(request, *args, **kwargs)
        return Response(response.data, status=status.HTTP_200_OK)


class FileDetailView(generics.RetrieveAPIView):
    serializer_class = FileSerializer
    permission_classes = [IsAuthenticated]
    queryset = File.objects.all()

    def retrieve(self, request, *args, **kwargs):
        try:
            response = super().retrieve(request, *args, **kwargs)
            return Response(response.data, status=status.HTTP_200_OK)
        except File.DoesNotExist:
            return Response(
                {"detail": "File not found."}, status=status.HTTP_404_NOT_FOUND
            )
