from django.conf import settings


class HealthCheckHostMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path_info == "/health/":
            request.META["HTTP_HOST"] = settings.ALLOWED_HOSTS[0]
        return self.get_response(request)