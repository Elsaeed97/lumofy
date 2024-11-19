from django.http import JsonResponse
from django.contrib.auth import get_user_model
from django.views.decorators.csrf import csrf_protect
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from django.views.decorators.http import require_http_methods
import re

User = get_user_model()


@csrf_protect
@require_http_methods(["POST"])
def register_user(request):
    try:
        # Get and validate input
        username = request.POST.get("username")
        email = request.POST.get("email")
        password = request.POST.get("password")

        if not all([username, email, password]):
            return JsonResponse({"error": "All fields are required"}, status=400)

        # Username validation
        if not re.match(r"^[\w.@+-]+$", username):
            return JsonResponse({"error": "Invalid username format"}, status=400)

        # Email validation
        try:
            validate_email(email)
        except ValidationError:
            return JsonResponse({"error": "Invalid email format"}, status=400)

        # Password length validation
        if len(password) < 8:
            return JsonResponse(
                {"error": "Password must be at least 8 characters long"}, status=400
            )

        if not re.match(r"^(?=.*[A-Za-z])(?=.*\d)", password):
            return JsonResponse(
                {"error": "Password must contain both letters and numbers"}, status=400
            )

        # Check if user already exists
        if User.objects.filter(username=username).exists():
            return JsonResponse({"error": "Username already taken"}, status=400)

        if User.objects.filter(email=email).exists():
            return JsonResponse({"error": "Email already registered"}, status=400)

        # Create user
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            is_active=False,  # We Can Add Email Verification and make is active True after verification
        )

        return JsonResponse(
            {
                "message": "Registration successful. Please check your email to verify your account."
            },
            status=201,
        )

    except Exception as e:
        return JsonResponse(
            {"error": "An error occurred during registration"}, status=500
        )
