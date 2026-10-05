from django.urls import path

from .views import health, home, login, logout, register


urlpatterns = [
    path("health/", health, name="health"),
    path("", home, name="home"),
    path("register/", register, name="register"),
    path("login/", login, name="login"),
    path("logout/", logout, name="logout"),
]
