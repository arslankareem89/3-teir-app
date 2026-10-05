import os

import requests
from django.http import HttpResponse
from django.shortcuts import redirect, render


BACKEND_URL = os.getenv("BACKEND_URL", "http://127.0.0.1:8000")


def _api_request(method: str, path: str, *, json_data=None, token=None):
    headers = {}
    if token:
        headers["Authorization"] = f"Bearer {token}"

    return requests.request(
        method,
        f"{BACKEND_URL}{path}",
        json=json_data,
        headers=headers,
        timeout=5,
    )


def health(request):
    return HttpResponse("ok")


def home(request):
    token = request.session.get("access_token")
    if not token:
        return redirect("register")

    try:
        response = _api_request("GET", "/auth/me", token=token)
        if response.ok:
            return render(
                request,
                "core/home.html",
                {"user": response.json()},
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
        return render(request, "core/register.html")

    payload = {
        "full_name": request.POST.get("full_name", "").strip(),
        "email": request.POST.get("email", "").strip(),
        "username": request.POST.get("username", "").strip(),
        "password": request.POST.get("password", ""),
        "confirm_password": request.POST.get("confirm_password", ""),
    }

    if payload["password"] != payload["confirm_password"]:
        return render(
            request,
            "core/register.html",
            {"error": "Passwords do not match.", "form": payload},
        )

    try:
        response = _api_request("POST", "/auth/register", json_data=payload)
        if response.ok:
            return redirect("/login/?registered=1")

        try:
            error = response.json().get("detail", "Registration failed.")
        except ValueError:
            error = "Registration failed."
    except requests.RequestException:
        error = "Backend unavailable."

    return render(
        request,
        "core/register.html",
        {"error": error, "form": payload},
    )


def login(request):
    if request.method == "GET":
        return render(
            request,
            "core/login.html",
            {"registered": request.GET.get("registered") == "1"},
        )

    payload = {
        "email": request.POST.get("email", "").strip(),
        "password": request.POST.get("password", ""),
    }

    try:
        response = _api_request("POST", "/auth/login", json_data=payload)
        if response.ok:
            request.session["access_token"] = response.json()["access_token"]
            return redirect("home")

        try:
            error = response.json().get("detail", "Invalid email or password.")
        except ValueError:
            error = "Invalid email or password."
    except requests.RequestException:
        error = "Backend unavailable."

    return render(
        request,
        "core/login.html",
        {"error": error, "email": payload["email"]},
    )


def logout(request):
    request.session.flush()
    return redirect("register")

