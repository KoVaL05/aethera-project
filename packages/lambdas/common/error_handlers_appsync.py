from enum import Enum


class ErrorType(Enum):
    UNEXPECTED = "Unexpected"
    UNAUTHORIZED = "Unauthorized"
    BAD_REQUEST = "BadRequest"


def createError(message: str, type: ErrorType):
    return {"error": {"message": message, "type": type}}
