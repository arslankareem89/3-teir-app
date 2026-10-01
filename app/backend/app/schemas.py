from pydantic import BaseModel, EmailStr, Field, model_validator


class UserCreate(BaseModel):
    full_name: str = Field(min_length=2, max_length=20)
    email: EmailStr
    username: str = Field(min_length=3, max_length=15)
    password: str = Field(min_length=8, max_length=15)
    confirm_password: str = Field(min_length=8, max_length=15)

    @model_validator(mode="after")
    def passwords_match(self):
        if self.password != self.confirm_password:
            raise ValueError("Passwords do not match")
        return self

class UserLogin(BaseModel):
    email: EmailStr
    password: str
