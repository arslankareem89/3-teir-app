from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session
from .dependencies import get_current_user
from .auth import create_access_token
from .database import get_db
from .models import User
from .schemas import UserCreate, UserLogin
from .security import hash_password, verify_password


app = FastAPI(title="3-Tier App Backend")


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/api/message")
def message():
    return {"message": "Hello from FastAPI backend"}


@app.post("/auth/register")
def register(
    user: UserCreate,
    db: Session = Depends(get_db),
):
    existing_email = (
        db.query(User)
        .filter(User.email == user.email)
        .first()
    )

    if existing_email:
        raise HTTPException(
            status_code=400,
            detail="Email already registered",
        )

    existing_username = (
        db.query(User)
        .filter(User.username == user.username)
        .first()
    )

    if existing_username:
        raise HTTPException(
            status_code=400,
            detail="Username already exists",
        )

    new_user = User(
        full_name=user.full_name,
        email=user.email,
        username=user.username,
        password_hash=hash_password(user.password),
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {
        "message": "User registered successfully",
        "user_id": new_user.id,
        "username": new_user.username,
    }


@app.post("/auth/login")
def login(
    user: UserLogin,
    db: Session = Depends(get_db),
):
    existing_user = (
        db.query(User)
        .filter(User.email == user.email)
        .first()
    )

    if not existing_user:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password",
        )

    if not verify_password(
        user.password,
        existing_user.password_hash,
    ):
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password",
        )

    access_token = create_access_token(existing_user.id)

    return {
        "access_token": access_token,
        "token_type": "bearer",
    }

@app.get("/auth/me")
def me(current_user: User = Depends(get_current_user)):
    return {
        "id": current_user.id,
        "full_name": current_user.full_name,
        "email": current_user.email,
        "username": current_user.username,
    }
