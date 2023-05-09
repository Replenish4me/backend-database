import boto3
import random
import string

def generate_password(length):
    """Generate a random password."""
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def update_secret(secret_name, secret_value):
    """Update the value of a secret in Secrets Manager."""
    client = boto3.client('secretsmanager')
    response = client.update_secret(
        SecretId=secret_name,
        SecretString=secret_value
    )
    return response

def rotate_rds_password(secret_name, rds_instance_identifier):
    """Rotate the password of an RDS instance."""
    # Generate a new password
    new_password = generate_password(16)

    # Update the RDS instance with the new password
    rds = boto3.client('rds')
    rds.modify_db_instance(
        DBInstanceIdentifier=rds_instance_identifier,
        MasterUserPassword=new_password,
        ApplyImmediately=True
    )

    # Update the secret value with the new password
    update_secret(secret_name, new_password)

    return "Password rotated successfully."
