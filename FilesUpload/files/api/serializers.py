import os
from rest_framework import serializers
from files.models import File


class FileSerializer(serializers.ModelSerializer):
    owner = serializers.StringRelatedField(read_only=True)
    file_size = serializers.SerializerMethodField()

    class Meta:
        model = File
        fields = [
            "id",
            "file",
            "filename",
            "owner",
            "file_type",
            "file_size",
            "file_size",
            "uploaded_at",
        ]
        read_only_fields = ["file_size", "file_type", "uploaded_at"]

    def validate_file(self, value):
        # Validate file size (10MB limit)
        max_size = 10 # MB
        if value.size > max_size * 1024 * 1024:
            raise serializers.ValidationError("File size must not exceed 10MB")
        return value

    def create(self, validated_data):
        file_obj = validated_data["file"]

        # Extract file information
        validated_data["filename"] = os.path.splitext(file_obj.name)[0]
        validated_data["file_size"] = file_obj.size
        validated_data["file_type"] = os.path.splitext(file_obj.name)[1][1:]

        return super().create(validated_data)
    
    def get_file_size(self, obj):
        return f"{obj.file_size / (1024):.2f} KB"
