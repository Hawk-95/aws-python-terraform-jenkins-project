import boto3
import json
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from botocore.exceptions import ClientError


SECRET_NAME = "rds-db-credentials-v2"
REGION = "ap-south-1"


def get_db_secret():
    client = boto3.client("secretsmanager", region_name=REGION)

    try:
        response = client.get_secret_value(SecretId=SECRET_NAME)
    except ClientError as e:
        raise RuntimeError(f"Unable to fetch secret: {e}")

    return json.loads(response["SecretString"])


secret = get_db_secret()

DATABASE_URL = (
    f"postgresql+psycopg2://{secret['username']}:{secret['password']}"
    f"@app-db.cfqim04cctng.ap-south-1.rds.amazonaws.com:5432/appdb"
)

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

