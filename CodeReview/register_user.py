from django.http import JsonResponse
from django.contrib.auth import get_user_model

User = get_user_model()


def register_user(request):
    if request.method == "POST":
        username = request.POST.get("username")
        email = request.POST.get("email")
        password = request.POST.get("password")
        user = User.objects.create_user(
            username=username, email=email, password=password
        )
        return JsonResponse({"message": "User created"})
