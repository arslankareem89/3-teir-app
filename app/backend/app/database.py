import os
from collections.abc import Generator

from sqlalchemy import URL, create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker


def build_database_url() -> str | URL:
    configured_url = os.getenv("DATABASE_URL")
    if configured_url:
        return configured_url

    db_host = os.getenv("DB_HOST")
    if not db_host:
        raise RuntimeError("Set DATABASE_URL or DB_HOST to configure PostgreSQL")

    required_values = {
        "DB_NAME": os.getenv("DB_NAME"),
        "DB_USER": os.getenv("DB_USER"),
        "DB_PASSWORD": os.getenv("DB_PASSWORD"),
    }
    missing_values = [
        key for key, value in required_values.items() if value is None
    ]
    if missing_values:
        raise RuntimeError(
            "Missing database settings: " + ", ".join(missing_values),
        )

    return URL.create(
        drivername="postgresql+psycopg",
        username=required_values["DB_USER"],
        password=required_values["DB_PASSWORD"],
        host=db_host,
        port=int(os.getenv("DB_PORT", "5432")),
        database=required_values["DB_NAME"],
    )


DATABASE_URL = build_database_url()
engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
)


class Base(DeclarativeBase):
    pass


def get_db() -> Generator[Session, None, None]:
    database_session = SessionLocal()
    try:
        yield database_session
    finally:
        database_session.close()
