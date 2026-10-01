import os
from datetime import datetime, timedelta, timezone

import jwt


JWT_SECRET = os.getenv(
    "JWT_SECRET",
    "local-development-secret-change-me",
)

JWT_ALGORITHM = "HS256"
JWT_EXPIRATION_MINUTES = 30


def create_access_token(user_id: int) -> str:
    expires_at = datetime.now(timezone.utc) + timedelta(
        minutes=JWT_EXPIRATION_MINUTES
    )

    payload = {
        "sub": str(user_id),
        "exp": expires_at,
    }

    return jwt.encode(
        payload,
        JWT_SECRET,
        algorithm=JWT_ALGORITHM,
    )
