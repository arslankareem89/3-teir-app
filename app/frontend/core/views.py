import os

import requests
from django.shortcuts import redirect, render


BACKEND_URL = os.getenv(
    "BACKEND_URL",
    "http://127.0.0.1:8000",
)


def home(request):
    token = request.session.get("access_token")

    if not token:
        return redirect("register")

    try:
        response = requests.get(
            f"{BACKEND_URL}/auth/me",
            headers={
                "Authorization": f"Bearer {token}",
            },
            timeout=5,
        )

        if response.ok:
            return render(
                request,
                "core/home.html",
                {
                    "user": response.json(),
                },
            )

        request.session.flush()
        return redirect("login")

    except requests.RequestException:
        return render(
            request,
            "core/home.html",
            {
                "user": None,
                "error": "Backend unavailable.",
            },
        )


def register(request):
    if request.method == "GET":
        return render(
            request,
            "core/register.html",
        )

    payload = {
        "full_name": request.POST.get("full_name", "").strip(),
        "email": request.POST.get("email", "").strip(),
        "username": request.POST.get("username", "").strip(),
        "password": request.POST.get("password", ""),
        "confirm_password": request.POST.get(
            "confirm_password",
            "",
        ),
    }

    if payload["password"] != payload["confirm_password"]:
        return render(
            request,
            "core/register.html",
            {
                "error": "Passwords do not match.",
                "form": payload,
            },
        )

    try:
        response = requests.post(
            f"{BACKEND_URL}/auth/register",
            json=payload,
            timeout=5,
        )

        if response.ok:
            return redirect("/login/?registered=1")

        try:
            data = response.json()
            error = data.get(
                "detail",
                "Registration failed.",
            )
        except ValueError:
            error = "Registration failed."

    except requests.RequestException:
        error = "Backend unavailable."

    return render(
        request,
        "core/register.html",
        {
            "error": error,
            "form": payload,
        },
    )


def login(request):
    if request.method == "GET":
        return render(
            request,
            "core/login.html",
            {
                "registered": request.GET.get("registered") == "1",
            },
        )

    payload = {
        "email": request.POST.get("email", "").strip(),
        "password": request.POST.get("password", ""),
    }

    try:
        response = requests.post(
            f"{BACKEND_URL}/auth/login",
            json=payload,
            timeout=5,
        )

        if response.ok:
            data = response.json()

            request.session["access_token"] = data["access_token"]
            return redirect("home")

        try:
            data = response.json()
            error = data.get(
                "detail",
                "Invalid email or password.",
            )
        except ValueError:
            error = "Invalid email or password."

    except requests.RequestException:
        error = "Backend unavailable."

    return render(
        request,
        "core/login.html",
        {
            "error": error,
            "email": payload["email"],
        },
    )


def logout(request):
    request.session.flush()
    return redirect("register")

