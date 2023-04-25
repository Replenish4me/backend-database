import json
from typing import Dict, Any
import os

from .generator import rotate_rds_password

def lambda_handler(event: Dict[str, Dict[str, Any]], context: Dict[str, Any]):
    secret_name = os.environ['secret_name']
    rds_instance_identifier = os.environ['db_name']
    return rotate_rds_password(secret_name, rds_instance_identifier)
